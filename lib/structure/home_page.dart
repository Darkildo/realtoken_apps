import 'package:flutter/material.dart';
import 'package:realtokens/managers/data_manager.dart';
import 'package:realtokens/structure/agenda.dart';
import 'package:realtokens/utils/currency_utils.dart';
import 'package:realtokens/utils/ui_utils.dart';

import 'bottom_bar.dart';
import 'drawer.dart';
import 'package:realtokens/pages/dashboard/dashboard_page.dart';
import 'package:realtokens/pages/portfolio/portfolio_page.dart';
import 'package:realtokens/pages/Statistics/stats_selector_page.dart';
import 'package:realtokens/pages/maps_page.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import 'package:realtokens/app_state.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  final GlobalKey _walletIconKey = GlobalKey(); // Clé pour obtenir la position de l'icône

  List<Map<String, dynamic>> portfolio = [];

  double _getContainerHeight(BuildContext context) {
    double bottomPadding = MediaQuery.of(context).viewPadding.bottom;
    return bottomPadding > 0 ? 75 : 60;
  }

  static const List<Widget> _pages = <Widget>[
    DashboardPage(),
    PortfolioPage(),
    StatsSelectorPage(),
    MapsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _openAgendaModal(BuildContext context) {
    final dataManager = Provider.of<DataManager>(context, listen: false);
    final portfolio = dataManager.portfolio;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      builder: (context) => AgendaCalendar(portfolio: portfolio),
    );
  }

  void _showWalletPopup(BuildContext context) {
        final currencyUtils = Provider.of<CurrencyProvider>(context, listen: false);

    final RenderBox renderBox =
        _walletIconKey.currentContext!.findRenderObject() as RenderBox;
    final Offset position = renderBox.localToGlobal(Offset.zero);
    final double iconSize = renderBox.size.height;

    final dataManager = Provider.of<DataManager>(context, listen: false);
    final double usdcBalance = dataManager.gnosisUsdcBalance;
    final double xdaiBalance = dataManager.gnosisXdaiBalance;

    showMenu(
      
      context: context,
      color: Theme.of(context).cardColor,
      position: RelativeRect.fromLTRB(
        position.dx, 
        position.dy + iconSize, // Juste en dessous de l'icône
        position.dx + renderBox.size.width, 
        position.dy + iconSize + 50, // Ajuste la hauteur
      ),
      items: [
        PopupMenuItem(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12), // Coins arrondis
            child: Container(
              padding: const EdgeInsets.all(12),
              
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("💰 Solde Wallet",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Theme.of(context).textTheme.bodyMedium?.color)),
                  const Divider(),
                  Row(
                    children: [
                      Image.asset('assets/icons/usdc.png',
                          width: 20, height: 20),
                      const SizedBox(width: 8),
                      Text(currencyUtils.formatCurrency(currencyUtils.convert(usdcBalance), currencyUtils.currencySymbol),
                          style: TextStyle(fontSize: 14, color: Theme.of(context).textTheme.bodyMedium?.color)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Image.asset('assets/icons/xdai.png',
                          width: 20, height: 20),
                      const SizedBox(width: 8),
                      Text(currencyUtils.formatCurrency(currencyUtils.convert(xdaiBalance) , currencyUtils.currencySymbol),
                          style: TextStyle(fontSize: 14, color: Theme.of(context).textTheme.bodyMedium?.color)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final dataManager = Provider.of<DataManager>(context);
        final currencyUtils = Provider.of<CurrencyProvider>(context, listen: false);

    final double walletTotal =
        dataManager.gnosisUsdcBalance + dataManager.gnosisXdaiBalance;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: _pages.elementAt(_selectedIndex),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  height: UIUtils.getAppBarHeight(context),
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.black.withOpacity(0.3)
                      : Colors.white.withOpacity(0.3),
                  child: AppBar(
                    forceMaterialTransparency: true,
                    backgroundColor: Colors.transparent,
                    elevation: 0.5,
                    actions: [
                      // Icône portefeuille avec un Popup Menu
                      IconButton(
                        key: _walletIconKey, // Associe la clé pour obtenir la position
                        icon: Icon(
                          Icons.account_balance_wallet,
                          size: 20,
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                        onPressed: () => _showWalletPopup(context),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Center(
                          child: Text(
                            currencyUtils.formatCurrency(currencyUtils.convert(walletTotal), currencyUtils.currencySymbol),
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).textTheme.bodyMedium?.color,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.calendar_today,
                          size: 20,
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                        onPressed: () => _openAgendaModal(context),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  height: _getContainerHeight(context),
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.black.withOpacity(0.3)
                      : Colors.white.withOpacity(0.3),
                  child: SafeArea(
                    top: false,
                    child: CustomBottomNavigationBar(
                      selectedIndex: _selectedIndex,
                      onItemTapped: _onItemTapped,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: CustomDrawer(
        onThemeChanged: (value) {
          appState.updateTheme(value);
        },
      ),
    );
  }
}
