import 'package:realtokens_apps/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import pour SharedPreferences
import 'package:realtokens_apps/api/data_manager.dart';
import 'package:realtokens_apps/generated/l10n.dart';
import '/settings/manage_evm_addresses_page.dart'; // Import de la page pour gérer les adresses EVM
import 'dashboard_details_page.dart';
import 'package:realtokens_apps/app_state.dart'; // Import AppState

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  DashboardPageState createState() => DashboardPageState();
}

class DashboardPageState extends State<DashboardPage> {
  bool _showAmounts = true; // Variable pour contrôler la visibilité des montants

  @override
  void initState() {
    super.initState();
    _loadPrivacyMode(); // Charger l'état du mode confidentialité au démarrage
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Utils.loadData(context); // Charger les données au démarrage
    });
  }

  // Méthode pour basculer l'état de visibilité des montants
  void _toggleAmountsVisibility() async {
    setState(() {
      _showAmounts = !_showAmounts;
    });
    // Sauvegarder l'état du mode "confidentialité" dans SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showAmounts', _showAmounts);
  }

  // Charger l'état du mode "confidentialité" depuis SharedPreferences
  Future<void> _loadPrivacyMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _showAmounts = prefs.getBool('showAmounts') ?? true; // Par défaut, les montants sont visibles
    });
  }

  // Récupère la dernière valeur de loyer
  String _getLastRentReceived(DataManager dataManager) {
    final rentData = dataManager.rentData;

    if (rentData.isEmpty) {
      return S.of(context).noRentReceived;
    }

    rentData.sort((a, b) => DateTime.parse(b['date']).compareTo(DateTime.parse(a['date'])));
    final lastRent = rentData.first['rent'];

    // Utiliser _getFormattedAmount pour masquer ou afficher la valeur
    return Utils.getFormattedAmount(dataManager.convert(lastRent), dataManager.currencySymbol, _showAmounts);
  }

  // Groupement mensuel sur les 12 derniers mois glissants pour la carte Rendement
  List<double> _getLast12MonthsRent(DataManager dataManager) {
    final currentDate = DateTime.now();
    final rentData = dataManager.rentData;

    Map<String, double> monthlyRent = {};

    for (var rentEntry in rentData) {
      DateTime date = DateTime.parse(rentEntry['date']);
      // Exclure le mois en cours et ne garder que les données des 12 mois précédents
      if (date.isBefore(DateTime(currentDate.year, currentDate.month)) && date.isAfter(DateTime(currentDate.year, currentDate.month - 12, 1))) {
        String monthKey = DateFormat('yyyy-MM').format(date);
        monthlyRent[monthKey] = (monthlyRent[monthKey] ?? 0) + rentEntry['rent'];
      }
    }

    // Assurer que nous avons les 12 derniers mois dans l'ordre (sans le mois en cours)
    List<String> sortedMonths = List.generate(12, (index) {
      DateTime date = DateTime(currentDate.year, currentDate.month - 1 - index, 1); // Commence à partir du mois précédent
      return DateFormat('yyyy-MM').format(date);
    }).reversed.toList();

    return sortedMonths.map((month) => monthlyRent[month] ?? 0).toList();
  }

  double _getPortfolioBarGraphData(DataManager dataManager) {
    // Calcul du pourcentage de rentabilité (ROI)
    return (dataManager.roiGlobalValue); // ROI en %
  }

  Widget _buildPieChart(double rentedPercentage, BuildContext context) {
    return SizedBox(
      width: 120, // Largeur du camembert
      height: 70, // Hauteur du camembert
      child: PieChart(
        PieChartData(
          startDegreeOffset: -90, // Pour placer la petite section en haut
          sections: [
            PieChartSectionData(
              value: rentedPercentage,
              color: Colors.green, // Couleur pour les unités louées
              title: '',
              radius: 23, // Taille de la section louée
              titleStyle: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              gradient: LinearGradient(
                colors: [Colors.green.shade300, Colors.green.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            PieChartSectionData(
              value: 100 - rentedPercentage,
              color: Colors.blue, // Couleur pour les unités non louées
              title: '',
              radius: 17, // Taille de la section non louée
              gradient: LinearGradient(
                colors: [Colors.blue.shade300, Colors.blue.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ],
          borderData: FlBorderData(show: false),
          sectionsSpace: 2, // Un léger espace entre les sections pour les démarquer
          centerSpaceRadius: 23, // Taille de l'espace central
        ),
        swapAnimationDuration: const Duration(milliseconds: 800), // Durée de l'animation
        swapAnimationCurve: Curves.easeInOut, // Courbe pour rendre l'animation fluide
      ),
    );
  }

  // Méthode pour créer un graphique en barres en tant que jauge
  Widget _buildVerticalGauge(double value, BuildContext context) {
    // Utiliser une valeur par défaut si 'value' est NaN ou négatif
    double displayValue = value.isNaN || value < 0 ? 0 : value;

    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Ajuster la taille de la colonne au contenu
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "ROI", // Titre de la jauge
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyLarge?.color),
              ),
              const SizedBox(width: 8), // Espacement entre le texte et l'icône
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(S.of(context).roiPerProperties), // Titre du popup
                        content: Text(S.of(context).roiAlertInfo), // Texte du popup
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Fermer le popup
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Icon(
                  Icons.info_outline, // Icône à afficher
                  size: 15, // Taille de l'icône
                  color: Colors.grey, // Couleur de l'icône
                ),
              ),
            ],
          ),
          const SizedBox(height: 8), // Espacement entre le titre et la jauge
          SizedBox(
            height: 100, // Hauteur totale de la jauge
            width: 90, // Largeur de la jauge
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.center,
                maxY: 100, // Échelle sur 100%
                barTouchData: BarTouchData(
                  enabled: true, // Activer l'interaction pour l'animation au toucher
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${rod.toY.toStringAsFixed(1)}%',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        if (value % 25 == 0) {
                          return Text(
                            value.toInt().toString(),
                            style: TextStyle(fontSize: 10, color: Colors.black54), // Définir la taille et couleur du texte
                          );
                        }
                        return Container();
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(show: false), // Désactiver la grille
                borderData: FlBorderData(show: false),
                barGroups: [
                  BarChartGroupData(
                    x: 0,
                    barRods: [
                      BarChartRodData(
                        toY: displayValue, // Utiliser la valeur corrigée
                        width: 20, // Largeur de la barre
                        borderRadius: BorderRadius.circular(4), // Bordures arrondies
                        color: Colors.transparent, // Couleur transparente pour appliquer le dégradé
                        gradient: LinearGradient(
                          colors: [Colors.blueAccent, Colors.lightBlueAccent],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: 100, // Fond de la jauge
                          color: const Color.fromARGB(255, 78, 78, 78).withOpacity(0.3), // Couleur du fond grisé
                        ),
                        rodStackItems: [
                          BarChartRodStackItem(0, displayValue, Colors.blueAccent.withOpacity(0.6)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8), // Espacement entre le titre et la jauge
          Text(
            "${displayValue.toStringAsFixed(1)}%", // Valeur de la barre affichée en dessous
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.blue, // Même couleur que la barre
            ),
          ),
        ],
      ),
    );
  }

  // Méthode pour créer un mini graphique pour la carte Rendement
  Widget _buildMiniGraphForRendement(List<double> data, BuildContext context, DataManager dataManager) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        height: 70,
        width: 120,
        child: LineChart(
          LineChartData(
            gridData: FlGridData(show: false),
            titlesData: FlTitlesData(show: false),
            borderData: FlBorderData(show: false),
            minX: 0,
            maxX: data.length.toDouble() - 1,
            minY: data.reduce((a, b) => a < b ? a : b),
            maxY: data.reduce((a, b) => a > b ? a : b),
            lineBarsData: [
              LineChartBarData(
                spots: List.generate(data.length, (index) {
                  double roundedValue = double.parse(dataManager.convert(data[index]).toStringAsFixed(2));
                  return FlSpot(index.toDouble(), roundedValue);
                }),
                isCurved: true,
                barWidth: 2,
                color: Colors.blue,
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                    radius: 2,
                    color: Colors.blue,
                    strokeWidth: 0,
                  ),
                ),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue.withOpacity(0.4), // Couleur plus opaque en haut
                      Colors.blue.withOpacity(0), // Couleur plus transparente en bas
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ],
            // Ajout de LineTouchData pour le tooltip
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                getTooltipItems: (List<LineBarSpot> touchedSpots) {
                  return touchedSpots.map((touchedSpot) {
                    final flSpot = touchedSpot;
                    return LineTooltipItem(
                      '${flSpot.y.toStringAsFixed(2)} ${dataManager.currencySymbol}', // Utiliser currencySymbol de dataManager
                      const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }).toList();
                },
              ),
              handleBuiltInTouches: true,
            ),
          ),
        ),
      ),
    );
  }

  // Construction des cartes du Dashboard
  Widget _buildCard(
    String title,
    IconData icon,
    Widget firstChild,
    List<Widget> otherChildren,
    DataManager dataManager,
    BuildContext context, {
    bool hasGraph = false,
    Widget? rightWidget, // Ajout du widget pour le graphique
  }) {
    final appState = Provider.of<AppState>(context);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0,
      color: Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      icon,
                      size: 24 + appState.getTextSizeOffset(),
                      color: _getIconColor(title, context), // Appelle une fonction pour déterminer la couleur
                    ),
                    const SizedBox(width: 8), // Espacement entre l'icône et le texte
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 19 + appState.getTextSizeOffset(),
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    const SizedBox(width: 12), // Espacement entre le texte et l'icône
                    if (title == S.of(context).rents)
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const DashboardRentsDetailsPage(),
                            ),
                          );
                        },
                        child: Icon(
                          Icons.arrow_forward,
                          size: 24, // Taille de l'icône
                          color: Colors.grey, // Couleur de l'icône
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                firstChild,
                const SizedBox(height: 3),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: otherChildren,
                ),
              ],
            ),
            const Spacer(),
            if (hasGraph && rightWidget != null) rightWidget, // Affiche le graphique
          ],
        ),
      ),
    );
  }

  // Construction d'une ligne pour afficher la valeur avant le texte
  Widget _buildValueBeforeText(String value, String text) {
    final appState = Provider.of<AppState>(context);
    return Row(
      children: [
        Text(
          value,
          style: TextStyle(
              fontSize: 16 + appState.getTextSizeOffset(),
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyLarge?.color // Mettre la valeur en gras
              ),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(fontSize: 13 + appState.getTextSizeOffset(), color: Theme.of(context).textTheme.bodyLarge?.color),
        ),
      ],
    );
  }

  Widget _buildNoWalletCard(BuildContext context) {
    return Center(
      // Centrer la carte horizontalement
      child: Card(
        color: Colors.orange[200], // Couleur d'alerte
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Ajuster la taille de la colonne au contenu
            crossAxisAlignment: CrossAxisAlignment.center, // Centrer le contenu horizontalement
            children: [
              Text(
                S.of(context).noDataAvailable, // Utilisation de la traduction pour "Aucun wallet trouvé"
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center, // Centrer le texte
              ),
              const SizedBox(height: 10),
              Center(
                // Centrer le bouton dans la colonne
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ManageEvmAddressesPage(), // Ouvre la page de gestion des adresses
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue, // Texte blanc et fond bleu
                  ),
                  child: Text(S.of(context).manageAddresses), // Texte du bouton
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dataManager = Provider.of<DataManager>(context);
    final appState = Provider.of<AppState>(context);

    IconButton visibilityButton = IconButton(
      icon: Icon(_showAmounts ? Icons.visibility : Icons.visibility_off),
      onPressed: _toggleAmountsVisibility,
    );

    final lastRentReceived = _getLastRentReceived(dataManager);
    final totalRentReceived = Utils.getFormattedAmount(dataManager.convert(dataManager.getTotalRentReceived()), dataManager.currencySymbol, _showAmounts);
    final netAPY = (((dataManager.averageAnnualYield * (dataManager.walletValue + dataManager.rmmValue)) +
            (dataManager.totalUsdcDepositBalance * dataManager.usdcDepositApy + dataManager.totalXdaiDepositBalance * dataManager.xdaiDepositApy) -
            (dataManager.totalUsdcBorrowBalance * dataManager.usdcBorrowApy + dataManager.totalXdaiBorrowBalance * dataManager.xdaiBorrowApy)) /
        (dataManager.walletValue +
            dataManager.rmmValue +
            dataManager.totalUsdcDepositBalance +
            dataManager.totalXdaiDepositBalance +
            dataManager.totalUsdcBorrowBalance +
            dataManager.totalXdaiBorrowBalance));
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () => Utils.refreshData(context),
            displacement: 100,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.only(top: Utils.getAppBarHeight(context), left: 8.0, right: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          S.of(context).hello,
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyLarge?.color),
                        ),
                        visibilityButton,
                      ],
                    ),
                    if (dataManager.rentData.isEmpty || dataManager.walletValue == 0) _buildNoWalletCard(context),
                    const SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: S.of(context).lastRentReceived,
                            style: TextStyle(
                              fontSize: 15 + appState.getTextSizeOffset(),
                              color: Theme.of(context).textTheme.bodyMedium?.color,
                            ),
                          ),
                          TextSpan(
                            text: lastRentReceived,
                            style: TextStyle(
                              fontSize: 18 + appState.getTextSizeOffset(),
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                          ),
                          TextSpan(
                            text: '\n${S.of(context).totalRentReceived}: ',
                            style: TextStyle(
                              fontSize: 16 + appState.getTextSizeOffset(),
                              color: Theme.of(context).textTheme.bodyMedium?.color,
                            ),
                          ),
                          TextSpan(
                            text: totalRentReceived,
                            style: TextStyle(
                              fontSize: 18 + appState.getTextSizeOffset(),
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildCard(
                      S.of(context).portfolio,
                      Icons.dashboard,
                      _buildValueBeforeText(
                        Utils.getFormattedAmount(dataManager.convert(dataManager.totalWalletValue), dataManager.currencySymbol, _showAmounts),
                        S.of(context).totalPortfolio,
                      ),
                      [
                        _buildIndentedBalance(
                          S.of(context).wallet,
                          dataManager.convert(dataManager.walletValue),
                          dataManager.currencySymbol,
                          true,
                          context,
                        ),
                        _buildIndentedBalance(
                          S.of(context).rmm,
                          dataManager.convert(dataManager.rmmValue),
                          dataManager.currencySymbol,
                          true,
                          context,
                        ),
                        _buildIndentedBalance(
                          S.of(context).rwaHoldings,
                          dataManager.convert(dataManager.rwaHoldingsValue),
                          dataManager.currencySymbol,
                          true,
                          context,
                        ),
                        const SizedBox(height: 10),
                        _buildIndentedBalance(
                          S.of(context).depositBalance,
                          dataManager.convert(dataManager.totalUsdcDepositBalance + dataManager.totalXdaiDepositBalance),
                          dataManager.currencySymbol,
                          true,
                          context,
                        ),
                        _buildIndentedBalance(
                          S.of(context).borrowBalance,
                          dataManager.convert(dataManager.totalUsdcBorrowBalance + dataManager.totalXdaiBorrowBalance),
                          dataManager.currencySymbol,
                          false,
                          context,
                        ),
                      ],
                      dataManager,
                      context,
                      hasGraph: true,
                      rightWidget: _buildVerticalGauge(_getPortfolioBarGraphData(dataManager), context),
                    ),
                    const SizedBox(height: 8),
                    _buildCard(
                      S.of(context).properties,
                      Icons.home,
                      _buildValueBeforeText(
                        '${(dataManager.rentedUnits / dataManager.totalUnits * 100).toStringAsFixed(2)}%',
                        S.of(context).rented,
                      ),
                      [
                        Text(
                          '${S.of(context).properties}: ${dataManager.totalTokenCount}',
                          style: TextStyle(fontSize: 13 + appState.getTextSizeOffset(), color: Theme.of(context).textTheme.bodyMedium?.color),
                        ),
                        Text(
                          '   ${S.of(context).wallet}: ${dataManager.walletTokenCount}',
                          style: TextStyle(fontSize: 13 + appState.getTextSizeOffset(), color: Theme.of(context).textTheme.bodyMedium?.color),
                        ),
                        Row(
                          children: [
                            Text(
                              '   ${S.of(context).rmm}: ${dataManager.rmmTokenCount.toInt()}',
                              style: TextStyle(fontSize: 13 + appState.getTextSizeOffset(), color: Theme.of(context).textTheme.bodyMedium?.color),
                            ),
                            SizedBox(width: 6),
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(S.of(context).duplicate_title), // Titre de la popup
                                      content: Text(
                                        '${dataManager.duplicateTokenCount.toInt()} ${S.of(context).duplicate}', // Contenu de la popup
                                        style: TextStyle(fontSize: 13 + appState.getTextSizeOffset()),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(); // Fermer la popup
                                          },
                                          child: Text(S.of(context).close), // Bouton de fermeture
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Icon(Icons.info_outline, size: 15), // Icône sans padding implicite
                            ),
                          ],
                        ),
                        Text(
                          '${S.of(context).rentedUnits}: ${dataManager.rentedUnits} / ${dataManager.totalUnits}',
                          style: TextStyle(fontSize: 13 + appState.getTextSizeOffset(), color: Theme.of(context).textTheme.bodyMedium?.color),
                        ),
                      ],
                      dataManager,
                      context,
                      hasGraph: true,
                      rightWidget: Builder(
                        builder: (context) {
                          double rentedPercentage = dataManager.rentedUnits / dataManager.totalUnits * 100;
                          if (rentedPercentage.isNaN || rentedPercentage < 0) {
                            rentedPercentage = 0; // Remplacer NaN par une valeur par défaut comme 0
                          }
                          return _buildPieChart(rentedPercentage, context); // Ajout du camembert avec la vérification
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildCard(
                      S.of(context).tokens,
                      Icons.account_balance_wallet,
                      _buildValueBeforeText(dataManager.totalTokens.toStringAsFixed(2), S.of(context).totalTokens),
                      [
                        Text(
                          '${S.of(context).wallet}: ${dataManager.walletTokensSums.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 13 + appState.getTextSizeOffset(), color: Theme.of(context).textTheme.bodyMedium?.color),
                        ),
                        Text(
                          '${S.of(context).rmm}: ${dataManager.rmmTokensSums.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 13 + appState.getTextSizeOffset(), color: Theme.of(context).textTheme.bodyMedium?.color),
                        ),
                      ],
                      dataManager,
                      context,
                      hasGraph: true,
                      rightWidget: Builder(
                        builder: (context) {
                          double rentedPercentage = dataManager.walletTokensSums / dataManager.totalTokens * 100;
                          if (rentedPercentage.isNaN || rentedPercentage < 0) {
                            rentedPercentage = 0; // Remplacer NaN par une valeur par défaut comme 0
                          }
                          return _buildPieChart(rentedPercentage, context); // Ajout du camembert avec la vérification
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildCard(
                      S.of(context).rents,
                      Icons.attach_money,
                      Row(
                        children: [
                          _buildValueBeforeText('${netAPY.toStringAsFixed(2)}%', S.of(context).annualYield),
                          SizedBox(width: 6),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(S.of(context).apy), // Titre de la popup
                                    content: Text(
                                      S.of(context).netApyHelp, // Contenu de la popup
                                      style: TextStyle(fontSize: 13 + appState.getTextSizeOffset()),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(); // Fermer la popup
                                        },
                                        child: Text(S.of(context).close), // Bouton de fermeture
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Icon(Icons.info_outline, size: 15), // Icône sans padding implicite
                          ),
                        ],
                      ),
                      [
                        Text(
                          'APY brut: ${dataManager.averageAnnualYield.toStringAsFixed(2)} %',
                          style: TextStyle(fontSize: 13 + appState.getTextSizeOffset(), color: Theme.of(context).textTheme.bodyMedium?.color),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '${S.of(context).daily}: ${Utils.getFormattedAmount(dataManager.convert(dataManager.dailyRent), dataManager.currencySymbol, _showAmounts)}',
                          style: TextStyle(fontSize: 13 + appState.getTextSizeOffset(), color: Theme.of(context).textTheme.bodyMedium?.color),
                        ),
                        Text(
                          '${S.of(context).weekly}: ${Utils.getFormattedAmount(dataManager.convert(dataManager.weeklyRent), dataManager.currencySymbol, _showAmounts)}',
                          style: TextStyle(fontSize: 13 + appState.getTextSizeOffset(), color: Theme.of(context).textTheme.bodyMedium?.color),
                        ),
                        Text(
                          '${S.of(context).monthly}: ${Utils.getFormattedAmount(dataManager.convert(dataManager.monthlyRent), dataManager.currencySymbol, _showAmounts)}',
                          style: TextStyle(fontSize: 13 + appState.getTextSizeOffset(), color: Theme.of(context).textTheme.bodyMedium?.color),
                        ),
                        Text(
                          '${S.of(context).annually}: ${Utils.getFormattedAmount(dataManager.convert(dataManager.yearlyRent), dataManager.currencySymbol, _showAmounts)}',
                          style: TextStyle(fontSize: 13 + appState.getTextSizeOffset(), color: Theme.of(context).textTheme.bodyMedium?.color),
                        ),
                      ],
                      dataManager,
                      context,
                      hasGraph: true,
                      rightWidget: _buildMiniGraphForRendement(_getLast12MonthsRent(dataManager), context, dataManager),
                    ),
                    const SizedBox(height: 8),
                    _buildCard(
                      S.of(context).nextRondays,
                      Icons.trending_up,
                      _buildCumulativeRentList(dataManager),
                      [], // Pas d'autres enfants pour cette carte
                      dataManager,
                      context,
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCumulativeRentList(DataManager dataManager) {
    final cumulativeRentEvolution = dataManager.getCumulativeRentEvolution();
    DateTime today = DateTime.now();
    final appState = Provider.of<AppState>(context);

    // Filtrer pour n'afficher que les dates futures
    final futureRentEvolution = cumulativeRentEvolution.where((entry) {
      DateTime rentStartDate = entry['rentStartDate'];
      return rentStartDate.isAfter(today);
    }).toList();

    // Utiliser un Set pour ne garder que des dates uniques
    Set<DateTime> displayedDates = <DateTime>{};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: futureRentEvolution.map((entry) {
        DateTime rentStartDate = entry['rentStartDate'];

        // Vérifier si la date est déjà dans le Set
        if (displayedDates.contains(rentStartDate)) {
          return SizedBox.shrink(); // Ne rien afficher si la date est déjà affichée
        } else {
          // Ajouter la date au Set
          displayedDates.add(rentStartDate);

          // Vérifier si la date est "3000-01-01" et afficher 'date non connu'
          String displayDate = rentStartDate == DateTime(3000, 1, 1) ? 'Date non communiquée' : DateFormat('yyyy-MM-dd').format(rentStartDate);

          // Afficher la date et le loyer cumulé
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 0),
            child: Text(
              '$displayDate: ${Utils.getFormattedAmount(dataManager.convert(entry['cumulativeRent']), dataManager.currencySymbol, _showAmounts)}',
              style: TextStyle(fontSize: 13 + appState.getTextSizeOffset(), color: Theme.of(context).textTheme.bodyMedium?.color),
            ),
          );
        }
      }).toList(),
    );
  }

  // Fonction utilitaire pour ajouter un "+" ou "-" et afficher entre parenthèses
  Widget _buildIndentedBalance(String label, double value, String symbol, bool isPositive, BuildContext context) {
    // Utiliser la fonction _getFormattedAmount pour gérer la visibilité des montants
    final appState = Provider.of<AppState>(context);
    String formattedAmount = _showAmounts
        ? (isPositive ? "+ ${Utils.formatCurrency(value, symbol)}" : "- ${Utils.formatCurrency(value, symbol)}")
        : (isPositive ? "+ " : "- ") + ('*' * 10); // Affiche une série d'astérisques si masqué

    return Padding(
      padding: const EdgeInsets.only(left: 15.0), // Ajoute une indentation pour décaler à droite
      child: Row(
        children: [
          Text(
            formattedAmount, // Affiche le montant ou des astérisques
            style: TextStyle(
              fontSize: 13, // Taille du texte ajustée
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyMedium?.color, // Couleur en fonction du thème
            ),
          ),
          const SizedBox(width: 8), // Espace entre le montant et le label
          Text(
            label, // Affiche le label après le montant
            style: TextStyle(
              fontSize: 11 + appState.getTextSizeOffset(), // Texte légèrement plus petit
              color: Theme.of(context).textTheme.bodyMedium?.color, // Couleur en fonction du thème
            ),
          ),
        ],
      ),
    );
  }

  // Fonction pour obtenir la couleur en fonction du titre traduit
  Color _getIconColor(String title, BuildContext context) {
    final String translatedTitle = title.trim(); // Supprime les espaces éventuels

    if (translatedTitle == S.of(context).rents) {
      return Colors.green;
    } else if (translatedTitle == S.of(context).tokens) {
      return Colors.orange;
    } else if (translatedTitle == S.of(context).properties) {
      return Colors.blue;
    } else if (translatedTitle == S.of(context).portfolio) {
      return Colors.black;
    } else {
      return Colors.blue; // Couleur par défaut
    }
  }
}
