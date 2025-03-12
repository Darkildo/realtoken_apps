import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:realtokens/generated/l10n.dart';
import 'package:realtokens/models/healthandltv_record.dart';
import 'package:realtokens/models/rented_record.dart';
import 'package:realtokens/utils/parameters.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../models/balance_record.dart';
import '../models/roi_record.dart';
import '../models/apy_record.dart';
import 'archive_manager.dart';

class DataManager extends ChangeNotifier {
  List<String> evmAddresses = [];
  double totalWalletValue = 0;
  double roiGlobalValue = 0;
  double netGlobalApy = 0;
  double walletValue = 0;
  double rmmValue = 0;
  Map<String, double> perWalletRmmValues = {};
  double rwaHoldingsValue = 0;
  int rentedUnits = 0;
  int totalUnits = 0;
  double initialTotalValue = 0.0;
  double yamTotalValue = 0.0;
  double totalTokens = 0.0;
  double walletTokensSums = 0.0;
  double rmmTokensSums = 0.0;
  double averageAnnualYield = 0;
  double dailyRent = 0;
  double weeklyRent = 0;
  double monthlyRent = 0;
  double yearlyRent = 0;
  Map<String, List<String>> userIdToAddresses = {};
  double totalUsdcDepositBalance = 0;
  double totalUsdcBorrowBalance = 0;
  double totalXdaiDepositBalance = 0;
  double totalXdaiBorrowBalance = 0;
  double gnosisUsdcBalance = 0;
  double gnosisXdaiBalance = 0;
  int totalRealtTokens = 0;
  double totalRealtInvestment = 0.0;
  double netRealtRentYear = 0.0;
  double realtInitialPrice = 0.0;
  double realtActualPrice = 0.0;
  int totalRealtUnits = 0;
  int rentedRealtUnits = 0;
  double averageRealtAnnualYield = 0.0;
  double usdcDepositApy = 0.0;
  double usdcBorrowApy = 0.0;
  double xdaiDepositApy = 0.0;
  double xdaiBorrowApy = 0.0;
  double apyAverage = 0.0;
  double healthFactor = 0.0;
  double ltv = 0.0;
  int walletTokenCount = 0;
  int rmmTokenCount = 0;
  int totalTokenCount = 0;
  int duplicateTokenCount = 0;
  bool isLoadingMain = true;
  bool isLoadingSecondary = true;
  bool isLoadingTransactions = true;
  List<Map<String, dynamic>> rentData = [];
  List<Map<String, dynamic>> detailedRentData = [];
  List<Map<String, dynamic>> propertyData = [];
  List<Map<String, dynamic>> rmmBalances = [];
  List<Map<String, dynamic>> perWalletBalances = [];
  List<Map<String, dynamic>> _allTokens =
      []; // Liste privée pour tous les tokens
  List<Map<String, dynamic>> get allTokens => _allTokens;
  List<Map<String, dynamic>> _portfolio = [];
  List<Map<String, dynamic>> get portfolio => _portfolio;
  List<Map<String, dynamic>> _recentUpdates = [];
  List<Map<String, dynamic>> get recentUpdates => _recentUpdates;
  List<Map<String, dynamic>> walletTokens = [];
  List<Map<String, dynamic>> realTokens = [];
  List<Map<String, dynamic>> tempRentData = [];
  List<BalanceRecord> balanceHistory = [];
  List<BalanceRecord> walletBalanceHistory = [];
  List<RoiRecord> roiHistory = [];
  List<ApyRecord> apyHistory = [];
  List<HealthAndLtvRecord> healthAndLtvHistory = [];
  List<RentedRecord> rentedHistory = [];
  Map<String, double> customInitPrices = {};
  List<Map<String, dynamic>> propertiesForSale = [];
  List<Map<String, dynamic>> propertiesForSaleFetched = [];
  List<Map<String, dynamic>> yamMarketFetched = [];
  List<Map<String, dynamic>> yamWalletsTransactionsFetched = [];
  List<Map<String, dynamic>> yamMarketData = [];
  List<Map<String, dynamic>> yamMarket = [];
  List<Map<String, dynamic>> yamHistory = [];
  List<Map<String, dynamic>> transactionsHistory = [];
  Map<String, List<Map<String, dynamic>>> transactionsByToken = {};
  List<Map<String, dynamic>> whitelistTokens = [];

  var customInitPricesBox = Hive.box('CustomInitPrices');

  DateTime? lastArchiveTime; // Variable pour stocker le dernier archivage
  DateTime? _lastUpdated; // Stocker la dernière mise à jour
  final Duration _updateCooldown =
      Duration(minutes: 5); // Délai minimal avant la prochaine mise à jour
  final ArchiveManager _archiveManager = ArchiveManager();

  DataManager() {
    loadCustomInitPrices(); // Charger les prix personnalisés lors de l'initialisation
  }

  Future<void> loadWalletsAddresses({bool forceFetch = false}) async {
    final prefs = await SharedPreferences.getInstance();
// Charger les adresses
    evmAddresses = prefs.getStringList('evmAddresses') ?? [];
  }

  Future<void> updateMainInformations({bool forceFetch = false}) async {
    var box = Hive.box('realTokens'); // Ouvrir la boîte Hive pour le cache

    // Vérifier si une mise à jour est nécessaire
    if (!forceFetch &&
        _lastUpdated != null &&
        DateTime.now().difference(_lastUpdated!) < _updateCooldown) {
      debugPrint("⏳ Mise à jour ignorée : déjà effectuée récemment.");
      return;
    }

    _lastUpdated = DateTime.now();
    debugPrint("🔄 Début de la mise à jour des informations principales...");

    // Fonction générique pour fetch + cache
    Future<void> fetchData({
      required Future<List<dynamic>> Function() apiCall,
      required String cacheKey,
      required void Function(List<Map<String, dynamic>>) updateVariable,
      required String debugName,
    }) async {
      try {
        var data = await apiCall();
        if (data.isNotEmpty) {
          debugPrint("✅ Mise à jour des données $debugName.");
          box.put(cacheKey, json.encode(data));
          updateVariable(List<Map<String, dynamic>>.from(data));
        } else {
          debugPrint(
              "⚠️ Pas de nouvelles données $debugName, chargement du cache...");
          var cachedData = box.get(cacheKey);
          if (cachedData != null) {
            updateVariable(
                List<Map<String, dynamic>>.from(json.decode(cachedData)));
          }
        }
        notifyListeners();
      } catch (e) {
        debugPrint("❌ Erreur lors de la mise à jour $debugName : $e");
      }
    }

    // Exécution des mises à jour en parallèle
    await Future.wait([
      fetchData(
          apiCall: () => ApiService.fetchWalletTokens(forceFetch: forceFetch),
          cacheKey: 'cachedTokenData_tokens',
          updateVariable: (data) => walletTokens = data,
          debugName: "Tokens"),

      fetchData(
          apiCall: () => ApiService.fetchRealTokens(forceFetch: forceFetch),
          cacheKey: 'cachedRealTokens',
          updateVariable: (data) => realTokens = data,
          debugName: "RealTokens"),
      fetchData(
          apiCall: () => ApiService.fetchRmmBalances(forceFetch: forceFetch),
          cacheKey: 'rmmBalances',
          updateVariable: (data) {
            rmmBalances = data;
            fetchRmmBalances();
          },
          debugName: "RMM Balances"),
      fetchData(
          apiCall: () => ApiService.fetchRentData(forceFetch: forceFetch),
          cacheKey: 'tempRentData',
          updateVariable: (data) => tempRentData = data,
          debugName: "Loyer temporaire"),
      fetchData(
          apiCall: () => ApiService.fetchPropertiesForSale(),
          cacheKey: 'cachedPropertiesForSaleData',
          updateVariable: (data) => propertiesForSaleFetched = data,
          debugName: "Propriétés en vente"),
      // Ajout de l'appel pour récupérer les tokens whitelistés pour chaque wallet
      fetchData(
          apiCall: () =>
              ApiService.fetchWhitelistTokens(forceFetch: forceFetch),
          cacheKey: 'cachedWhitelistTokens',
          updateVariable: (data) => whitelistTokens = data,
          debugName: "Whitelist")
    ]);

    // Charger les historiques
    loadWalletBalanceHistory();
    loadRentedHistory();
    loadRoiHistory();
    loadApyHistory();
    loadHealthAndLtvHistory();
    isLoadingMain = false;
  }

  Future<void> updateSecondaryInformations(BuildContext context,
      {bool forceFetch = false}) async {
    var box = Hive.box('realTokens'); // Ouvrir la boîte Hive pour le cache

    // Fonction générique pour fetch + cache
    Future<void> fetchData({
      required Future<List<dynamic>> Function() apiCall,
      required String cacheKey,
      required void Function(List<Map<String, dynamic>>) updateVariable,
      required String debugName,
    }) async {
      try {
        var data = await apiCall();
        if (data.isNotEmpty) {
          debugPrint("✅ Mise à jour des données $debugName.");
          box.put(cacheKey, json.encode(data));
          updateVariable(List<Map<String, dynamic>>.from(data));
        } else {
          debugPrint(
              "⚠️ Pas de nouvelles données $debugName, chargement du cache...");
          var cachedData = box.get(cacheKey);
          if (cachedData != null) {
            updateVariable(
                List<Map<String, dynamic>>.from(json.decode(cachedData)));
          }
        }
        notifyListeners();
      } catch (e) {
        debugPrint("❌ Erreur lors de la mise à jour $debugName : $e");
      }
    }

    // Exécution des mises à jour en parallèle
    await Future.wait([
      fetchData(
          apiCall: () =>
              ApiService.fetchYamWalletsTransactions(forceFetch: forceFetch),
          cacheKey: 'cachedWalletsTransactions',
          updateVariable: (data) => yamWalletsTransactionsFetched = data,
          debugName: "YAM Wallets Transactions"),
      fetchData(
          apiCall: () => ApiService.fetchYamMarket(forceFetch: forceFetch),
          cacheKey: 'cachedYamMarket',
          updateVariable: (data) => yamMarketFetched = data,
          debugName: "YAM Market"),
      fetchData(
          apiCall: () => ApiService.fetchTokenVolumes(forceFetch: forceFetch),
          cacheKey: 'yamHistory',
          updateVariable: (data) {
            rmmBalances = data;
            fetchYamHistory();
          },
          debugName: "YAM Volumes History"),
      fetchData(
          apiCall: () => ApiService.fetchTransactionsHistory(
              portfolio: portfolio, forceFetch: forceFetch),
          cacheKey: 'transactionsHistory',
          updateVariable: (data) async {
            transactionsHistory = data;
            await processTransactionsHistory(
                context, transactionsHistory, yamWalletsTransactionsFetched);
          },
          debugName: "Transactions History"),
    ]);

    isLoadingSecondary = false;
  }

  Future<void> loadWalletBalanceHistory() async {
    try {
      var box = Hive.box('walletValueArchive'); // Ouvrir la boîte Hive
      List<dynamic>? balanceHistoryJson = box.get(
          'balanceHistory_totalWalletValue'); // Récupérer les données sauvegardées

      // Convertir chaque élément JSON en objet BalanceRecord et l'ajouter à walletBalanceHistory
      walletBalanceHistory = balanceHistoryJson!.map((recordJson) {
        return BalanceRecord.fromJson(Map<String, dynamic>.from(recordJson));
      }).toList();

      notifyListeners(); // Notifier les listeners après la mise à jour

      debugPrint(
          '✅ Données de l\'historique du portefeuille chargées avec succès.');
    } catch (e) {
      debugPrint(
          'Erreur lors du chargement des données de l\'historique du portefeuille : $e');
    }
  }

  Future<void> loadRentedHistory() async {
    try {
      var box = Hive.box('rentedArchive'); // Ouvrir la boîte Hive
      List<dynamic>? rentedHistoryJson =
          box.get('rented_history'); // Récupérer les données sauvegardées

      rentedHistory = rentedHistoryJson!.map((recordJson) {
        return RentedRecord.fromJson(Map<String, dynamic>.from(recordJson));
      }).toList();

      notifyListeners(); // Notifier les listeners après la mise à jour

      debugPrint(
          '✅ Données de l\'historique du portefeuille chargées avec succès.');
    } catch (e) {
      debugPrint(
          'Erreur lors du chargement des données de l\'historique du portefeuille : $e');
    }
  }

  Future<void> loadRoiHistory() async {
    try {
      var box = Hive.box('roiValueArchive'); // Ouvrir la boîte Hive
      List<dynamic>? roiHistoryJson =
          box.get('roi_history'); // Récupérer les données sauvegardées

      roiHistory = roiHistoryJson!.map((recordJson) {
        return RoiRecord.fromJson(Map<String, dynamic>.from(recordJson));
      }).toList();

      notifyListeners(); // Notifier les listeners après la mise à jour

      debugPrint('Données de l\'historique du ROI chargées avec succès.');
    } catch (e) {
      debugPrint(
          'Erreur lors du chargement des données de l\'historique du ROI : $e');
    }
  }

  Future<void> loadApyHistory() async {
    try {
      var box = Hive.box('apyValueArchive'); // Ouvrir la boîte Hive
      List<dynamic>? apyHistoryJson =
          box.get('apy_history'); // Récupérer les données sauvegardées

      // Charger l'historique
      apyHistory = apyHistoryJson!.map((recordJson) {
        return ApyRecord.fromJson(Map<String, dynamic>.from(recordJson));
      }).toList();

      notifyListeners(); // Notifier les listeners après la mise à jour

      debugPrint('Données de l\'historique APY chargées avec succès.');
    } catch (e) {
      debugPrint(
          'Erreur lors du chargement des données de l\'historique APY : $e');
    }
  }

  Future<void> loadHealthAndLtvHistory() async {
    try {
      var box = Hive.box('HealthAndLtvValueArchive'); // Ouvrir la boîte Hive
      List<dynamic>? healthAndLtvHistoryJson =
          box.get('healthAndLtv_history'); // Récupérer les données sauvegardées

      // Charger l'historique
      healthAndLtvHistory = healthAndLtvHistoryJson!.map((recordJson) {
        return HealthAndLtvRecord.fromJson(
            Map<String, dynamic>.from(recordJson));
      }).toList();

      notifyListeners(); // Notifier les listeners après la mise à jour

      debugPrint('Données de l\'historique healthAndLtv chargées avec succès.');
    } catch (e) {
      debugPrint(
          'Erreur lors du chargement des données de l\'historique healthAndLtv : $e');
    }
  }

  // Sauvegarde l'historique des balances dans Hive
  Future<void> saveWalletBalanceHistory() async {
    var box = Hive.box('walletValueArchive');
    List<Map<String, dynamic>> balanceHistoryJson =
        walletBalanceHistory.map((record) => record.toJson()).toList();
    await box.put('balanceHistory_totalWalletValue', balanceHistoryJson);
    notifyListeners(); // Notifier les listeners de tout changement
  }

  Future<void> saveRentedHistory() async {
    var box = Hive.box('rentedArchive');
    List<Map<String, dynamic>> rentedHistoryJson =
        rentedHistory.map((record) => record.toJson()).toList();
    await box.put('rented_history', rentedHistoryJson);
    notifyListeners(); // Notifier les listeners de tout changement
  }

  Future<void> updatedDetailRentVariables({bool forceFetch = false}) async {
    var box = Hive.box('realTokens'); // Ouvrir la boîte Hive pour le cache

    try {
      // Mise à jour des détails de loyer détaillés
      var detailedRentDataResult =
          await ApiService.fetchDetailedRentDataForAllWallets();
      if (detailedRentDataResult.isNotEmpty) {
        debugPrint(
            "Mise à jour des détails de loyer avec de nouvelles valeurs.");
        box.put('detailedRentData', json.encode(detailedRentDataResult));
        detailedRentData = detailedRentDataResult.cast<Map<String, dynamic>>();
        notifyListeners(); // Notifier les listeners après la mise à jour
      } else {
        debugPrint("⚠️ Les détails de loyer sont vides, pas de mise à jour.");
      }
    } catch (error) {
      debugPrint("❌ Erreur lors de la récupération des données: $error");
    }
  }

  // Méthode pour ajouter des adresses à un userId
  void addAddressesForUserId(String userId, List<String> addresses) {
    if (userIdToAddresses.containsKey(userId)) {
      userIdToAddresses[userId]!.addAll(addresses);
    } else {
      userIdToAddresses[userId] = addresses;
    }
    saveUserIdToAddresses(); // Sauvegarder après modification
    notifyListeners();
  }

  // Sauvegarder la Map des userIds et adresses dans SharedPreferences
  Future<void> saveUserIdToAddresses() async {
    final prefs = await SharedPreferences.getInstance();
    final userIdToAddressesJson = userIdToAddresses.map((userId, addresses) {
      return MapEntry(
          userId, jsonEncode(addresses)); // Encoder les adresses en JSON
    });

    prefs.setString('userIdToAddresses', jsonEncode(userIdToAddressesJson));
  }

  // Charger les userIds et leurs adresses depuis SharedPreferences
  Future<void> loadUserIdToAddresses() async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString('userIdToAddresses');

    if (savedData != null) {
      final decodedMap = Map<String, dynamic>.from(jsonDecode(savedData));
      userIdToAddresses = decodedMap.map((userId, encodedAddresses) {
        final addresses = List<String>.from(jsonDecode(encodedAddresses));
        return MapEntry(userId, addresses);
      });
    }
    notifyListeners();
  }

  // Supprimer une adresse spécifique
  void removeAddressForUserId(String userId, String address) {
    if (userIdToAddresses.containsKey(userId)) {
      userIdToAddresses[userId]!.remove(address);
      if (userIdToAddresses[userId]!.isEmpty) {
        userIdToAddresses
            .remove(userId); // Supprimer le userId si plus d'adresses
      }
      saveUserIdToAddresses(); // Sauvegarder après suppression
      notifyListeners();
    }
  }

  // Supprimer un userId et toutes ses adresses
  void removeUserId(String userId) {
    userIdToAddresses.remove(userId);
    saveUserIdToAddresses(); // Sauvegarder après suppression
    notifyListeners();
  }

  // Méthode pour récupérer les adresses associées à un userId
  List<String>? getAddressesForUserId(String userId) {
    return userIdToAddresses[userId];
  }

  // Méthode pour obtenir tous les userIds
  List<String> getAllUserIds() {
    return userIdToAddresses.keys.toList();
  }

  Future<void> fetchAndStoreAllTokens() async {
    var box = Hive.box('realTokens');

    // Variables temporaires pour calculer les nouvelles valeurs
    int tempTotalTokens = 0;
    double tempTotalInvestment = 0.0;
    double tempNetRentYear = 0.0;
    double tempInitialPrice = 0.0;
    double tempActualPrice = 0.0;
    int tempTotalUnits = 0;
    int tempRentedUnits = 0;
    double tempAnnualYieldSum = 0.0;
    int yieldCount = 0;

    final cachedRealTokens = box.get('cachedRealTokens');
    if (cachedRealTokens != null) {
      realTokens =
          List<Map<String, dynamic>>.from(json.decode(cachedRealTokens));
      debugPrint("Données RealTokens en cache utilisées.");
    }
    List<Map<String, dynamic>> allTokensList = [];

    // Si des tokens existent, les ajouter à la liste des tokens
    if (realTokens.isNotEmpty) {
      _recentUpdates = _extractRecentUpdates(realTokens);
      for (var realToken in realTokens.cast<Map<String, dynamic>>()) {
        // Vérification: Ne pas ajouter si totalTokens est 0 ou si fullName commence par "OLD-"
        // Récupérer la valeur customisée de initPrice si elle existe
        final tokenContractAddress = realToken['uuid'].toLowerCase() ??
            ''; // Utiliser l'adresse du contrat du token

        if (realToken['totalTokens'] != null &&
            realToken['totalTokens'] > 0 &&
            realToken['fullName'] != null &&
            !realToken['fullName'].startsWith('OLD-') &&
            realToken['uuid'].toLowerCase() !=
                Parameters.rwaTokenAddress.toLowerCase()) {
          double? customInitPrice = customInitPrices[tokenContractAddress];
          double initPrice = customInitPrice ??
              (realToken['historic']['init_price'] as num?)?.toDouble() ??
              0.0;

          String fullName = realToken['fullName'];
          List<String> parts = fullName.split(',');
          String country = parts.length == 4 ? parts[3].trim() : 'USA';
          List<String> parts2 = fullName.split(',');
          String regionCode =
              parts2.length >= 3 ? parts[2].trim().substring(0, 2) : 'unknown';
          List<String> parts3 = fullName.split(',');
          String city = parts3.length >= 2 ? parts[1].trim() : 'Unknown';

          allTokensList.add({
            'uuid': tokenContractAddress,
            'shortName': realToken['shortName'],
            'fullName': realToken['fullName'],
            'country': country,
            'regionCode': regionCode,
            'city': city,
            'imageLink': realToken['imageLink'],
            'lat': realToken['coordinate']['lat'],
            'lng': realToken['coordinate']['lng'],
            'totalTokens': realToken['totalTokens'],
            'tokenPrice': realToken['tokenPrice'],
            'totalValue': realToken['totalInvestment'],
            'amount': 0.0,
            'annualPercentageYield': realToken['annualPercentageYield'],
            'dailyIncome':
                realToken['netRentDayPerToken'] * realToken['totalTokens'],
            'monthlyIncome':
                realToken['netRentMonthPerToken'] * realToken['totalTokens'],
            'yearlyIncome':
                realToken['netRentYearPerToken'] * realToken['totalTokens'],
            'initialLaunchDate': realToken['initialLaunchDate']?['date'],
            'totalInvestment': realToken['totalInvestment'],
            'underlyingAssetPrice': realToken['underlyingAssetPrice'] ?? 0.0,
            'initialMaintenanceReserve': realToken['initialMaintenanceReserve'],
            'rentalType': realToken['rentalType'],
            'rentStartDate': realToken['rentStartDate']?['date'],
            'rentedUnits': realToken['rentedUnits'],
            'totalUnits': realToken['totalUnits'],
            'grossRentMonth': realToken['grossRentMonth'],
            'netRentMonth': realToken['netRentMonth'],
            'constructionYear': realToken['constructionYear'],
            'propertyStories': realToken['propertyStories'],
            'lotSize': realToken['lotSize'],
            'squareFeet': realToken['squareFeet'],
            'marketplaceLink': realToken['marketplaceLink'],
            'propertyType': realToken['propertyType'],
            'historic': realToken['historic'],
            'ethereumContract': realToken['ethereumContract'],
            'gnosisContract': realToken['gnosisContract'],
            'initPrice': initPrice,
            'totalRentReceived': 0.0,
            'initialTotalValue': initPrice,
            'propertyMaintenanceMonthly':
                realToken['propertyMaintenanceMonthly'],
            'propertyManagement': realToken['propertyManagement'],
            'realtPlatform': realToken['realtPlatform'],
            'insurance': realToken['insurance'],
            'propertyTaxes': realToken['propertyTaxes'],
            'realtListingFee': realToken['realtListingFee'],
            'renovationReserve': realToken['renovationReserve'],
            'miscellaneousCosts': realToken['miscellaneousCosts'],
            'section8paid': realToken['section8paid'] ?? 0.0,

            'yamTotalVolume': 0.0, // Ajout de la valeur Yam calculée
            'yamAverageValue': 0.0, // Ajout de la valeur moyenne Yam calculée
            'transactions': []
          });

          tempTotalTokens += 1; // Conversion explicite en int
          tempTotalInvestment += realToken['totalInvestment'] ?? 0.0;
          tempNetRentYear += realToken['netRentYearPerToken'] *
              (realToken['totalTokens'] as num).toInt();
          tempTotalUnits += (realToken['totalUnits'] as num?)?.toInt() ??
              0; // Conversion en int avec vérification
          tempRentedUnits += (realToken['rentedUnits'] as num?)?.toInt() ?? 0;
          // Gérer le cas où tokenPrice est soit un num soit une liste
          dynamic tokenPriceData = realToken['tokenPrice'];
          double? tokenPrice;
          int totalTokens = (realToken['totalTokens'] as num).toInt();

          if (tokenPriceData is List && tokenPriceData.isNotEmpty) {
            tokenPrice = (tokenPriceData.first as num)
                .toDouble(); // Utiliser le premier élément de la liste
          } else if (tokenPriceData is num) {
            tokenPrice = tokenPriceData
                .toDouble(); // Utiliser directement si c'est un num
          }

          tempInitialPrice += initPrice * totalTokens;

          if (tokenPrice != null) {
            tempActualPrice += tokenPrice * totalTokens;
          }

          // Calcul du rendement annuel
          if (realToken['annualPercentageYield'] != null) {
            tempAnnualYieldSum += realToken['annualPercentageYield'];
            yieldCount++;
          }
        }
      }
    }

    // Mettre à jour la liste des tokens
    _allTokens = allTokensList;
    debugPrint(
        "Tokens récupérés: ${allTokensList.length}"); // Vérifiez que vous obtenez bien des tokens

    // Mise à jour des variables partagées
    totalRealtTokens = tempTotalTokens; //en retire le RWA token dans le calcul
    totalRealtInvestment = tempTotalInvestment;
    realtInitialPrice = tempInitialPrice;
    realtActualPrice = tempActualPrice;
    netRealtRentYear = tempNetRentYear;
    totalRealtUnits = tempTotalUnits;
    rentedRealtUnits = tempRentedUnits;
    averageRealtAnnualYield =
        yieldCount > 0 ? tempAnnualYieldSum / yieldCount : 0.0;

    _archiveManager
        .archiveRentedValue(rentedRealtUnits / totalRealtUnits * 100);

    // Notifie les widgets que les données ont changé
    notifyListeners();
  }

  // Méthode pour récupérer et calculer les données pour le Dashboard et Portfolio
  Future<void> fetchAndCalculateData({bool forceFetch = false}) async {
    debugPrint("🔄 Début de la récupération des données de tokens...");

    var box = Hive.box('realTokens');
    initialTotalValue = 0.0;
    yamTotalValue = 0.0;

    // Charger les données en cache si disponibles
    final cachedTokens = box.get('cachedTokenData_tokens');
    if (cachedTokens != null) {
      walletTokens = List<Map<String, dynamic>>.from(json.decode(cachedTokens));
      debugPrint("✅ Données Tokens en cache utilisées.");
    }

    if (walletTokens.isEmpty) {
      debugPrint("⚠️ Aucun token récupéré depuis l'API.");
    } else {
      debugPrint("Nombre de tokens récupérés: ${walletTokens.length}");
    }

    // Variables temporaires de calcul global
    double walletValueSum = 0.0;
    double rmmValueSum = 0.0;
    double rwaValue = 0.0;
    double walletTokensSum = 0.0;
    double rmmTokensSum = 0.0;
    double annualYieldSum = 0.0;
    double dailyRentSum = 0.0;
    double monthlyRentSum = 0.0;
    double yearlyRentSum = 0.0;
    int yieldCount = 0;
    List<Map<String, dynamic>> newPortfolio = [];

    // Réinitialisation des compteurs globaux
    walletTokenCount = 0;
    rmmTokenCount = 0;
    rentedUnits = 0;
    totalUnits = 0;

    // Sets pour stocker les tokens et adresses uniques
    Set<String> uniqueWalletTokens = {};
    Set<String> uniqueRmmTokens = {};
    Set<String> uniqueRentedUnitAddresses = {};
    Set<String> uniqueTotalUnitAddresses = {};

    // Fonction locale pour parser le fullName
    Map<String, String> parseFullName(String fullName) {
      final parts = fullName.split(',');
      final country = parts.length == 4 ? parts[3].trim() : 'USA';
      final regionCode =
          parts.length >= 3 ? parts[2].trim().substring(0, 2) : 'unknown';
      final city = parts.length >= 2 ? parts[1].trim() : 'Unknown City';
      return {
        'country': country,
        'regionCode': regionCode,
        'city': city,
      };
    }

    // Fonction locale pour mettre à jour les compteurs d'unités (pour éviter le comptage en double)
    void updateUnitCounters(
        String tokenAddress, Map<String, dynamic> realToken) {
      if (!uniqueRentedUnitAddresses.contains(tokenAddress)) {
        rentedUnits += (realToken['rentedUnits'] ?? 0) as int;
        uniqueRentedUnitAddresses.add(tokenAddress);
      }
      if (!uniqueTotalUnitAddresses.contains(tokenAddress)) {
        totalUnits += (realToken['totalUnits'] ?? 0) as int;
        uniqueTotalUnitAddresses.add(tokenAddress);
      }
    }

    debugPrint("🔍 Traitement des tokens...");
    for (var walletToken in walletTokens) {
      final tokenAddress = walletToken['token'].toLowerCase();
      debugPrint(
          "🔍 Traitement du token: ${walletToken['token']} (type: ${walletToken['type']})");

      // Recherche du token correspondant dans realTokens
      final matchingRealToken =
          realTokens.cast<Map<String, dynamic>>().firstWhere(
                (realToken) => realToken['uuid'].toLowerCase() == tokenAddress,
                orElse: () => <String, dynamic>{},
              );
      if (matchingRealToken.isEmpty) {
        debugPrint(
            "⚠️ Aucun RealToken correspondant trouvé pour le token: $tokenAddress");
        continue;
      }
      debugPrint("✅ Token trouvé: ${matchingRealToken['shortName']}");

      final double tokenPrice = matchingRealToken['tokenPrice'] ?? 0.0;
      final double tokenValue = walletToken['amount'] * tokenPrice;

      // Mise à jour des compteurs d'unités (une seule fois par token)
      updateUnitCounters(tokenAddress, matchingRealToken);

      // Séparation entre tokens RWA et autres
      if (tokenAddress == Parameters.rwaTokenAddress.toLowerCase()) {
        rwaValue += tokenValue;
      } else {
        if (walletToken['type'] == "wallet") {
          walletValueSum += tokenValue;
          walletTokensSum += walletToken['amount'];
          uniqueWalletTokens.add(tokenAddress);
        } else {
          rmmValueSum += tokenValue;
          rmmTokensSum += walletToken['amount'];
          uniqueRmmTokens.add(tokenAddress);
        }

        // Calcul des revenus si la date de lancement est passée
        final today = DateTime.now();
        final launchDateString = matchingRealToken['rentStartDate']?['date'];
        if (launchDateString != null) {
          final launchDate = DateTime.tryParse(launchDateString);
          if (launchDate != null && launchDate.isBefore(today)) {
            annualYieldSum += matchingRealToken['annualPercentageYield'];
            yieldCount++;
            dailyRentSum +=
                matchingRealToken['netRentDayPerToken'] * walletToken['amount'];
            monthlyRentSum += matchingRealToken['netRentMonthPerToken'] *
                walletToken['amount'];
            yearlyRentSum += matchingRealToken['netRentYearPerToken'] *
                walletToken['amount'];
          }
        }
      }

      // Récupération du prix d'initialisation
      final tokenContractAddress = matchingRealToken['uuid'].toLowerCase();
      double? customInitPrice = customInitPrices[tokenContractAddress];
      double initPrice = customInitPrice ??
          ((matchingRealToken['historic']['init_price'] as num?)?.toDouble() ??
              0.0);

      // Parsing du fullName pour obtenir country, regionCode et city
      final nameDetails = parseFullName(matchingRealToken['fullName']);

      // Récupération des données Yam
      final yamData = yamHistory.firstWhere(
        (yam) => yam['id'].toLowerCase() == tokenContractAddress,
        orElse: () => <String, dynamic>{},
      );
      final double yamTotalVolume = yamData['totalVolume'] ?? 1.0;
      final double yamAverageValue =
          (yamData['averageValue'] != null && yamData['averageValue'] != 0)
              ? yamData['averageValue']
              : tokenPrice;

      // Fusion dans le portfolio par token (agrégation si le même token apparaît plusieurs fois)
      int index = newPortfolio
          .indexWhere((item) => item['uuid'] == tokenContractAddress);
      if (index != -1) {
        Map<String, dynamic> existingItem = newPortfolio[index];
        List<String> wallets = existingItem['wallets'] is List<String>
            ? List<String>.from(existingItem['wallets'])
            : [];
        if (!wallets.contains(walletToken['wallet'])) {
          wallets.add(walletToken['wallet']);
        }
        existingItem['wallets'] = wallets;
        existingItem['amount'] += walletToken['amount'];
        existingItem['totalValue'] = existingItem['amount'] * tokenPrice;
        existingItem['initialTotalValue'] = existingItem['amount'] * initPrice;
        existingItem['dailyIncome'] =
            matchingRealToken['netRentDayPerToken'] * existingItem['amount'];
        existingItem['monthlyIncome'] =
            matchingRealToken['netRentMonthPerToken'] * existingItem['amount'];
        existingItem['yearlyIncome'] =
            matchingRealToken['netRentYearPerToken'] * existingItem['amount'];
      } else {
        Map<String, dynamic> portfolioItem = {
          'id': matchingRealToken['id'],
          'uuid': tokenContractAddress,
          'shortName': matchingRealToken['shortName'],
          'fullName': matchingRealToken['fullName'],
          'country': nameDetails['country'],
          'regionCode': nameDetails['regionCode'],
          'city': nameDetails['city'],
          'imageLink': matchingRealToken['imageLink'],
          'lat': matchingRealToken['coordinate']['lat'],
          'lng': matchingRealToken['coordinate']['lng'],
          'amount': walletToken['amount'],
          'totalTokens': matchingRealToken['totalTokens'],
          'source': walletToken['type'],
          'tokenPrice': tokenPrice,
          'totalValue': tokenValue,
          'initialTotalValue': walletToken['amount'] * initPrice,
          'annualPercentageYield': matchingRealToken['annualPercentageYield'],
          'dailyIncome':
              matchingRealToken['netRentDayPerToken'] * walletToken['amount'],
          'monthlyIncome':
              matchingRealToken['netRentMonthPerToken'] * walletToken['amount'],
          'yearlyIncome':
              matchingRealToken['netRentYearPerToken'] * walletToken['amount'],
          'initialLaunchDate': matchingRealToken['initialLaunchDate']?['date'],
          'bedroomBath': matchingRealToken['bedroomBath'],
          // financials details
          'totalInvestment': matchingRealToken['totalInvestment'] ?? 0.0,
          'underlyingAssetPrice':
              matchingRealToken['underlyingAssetPrice'] ?? 0.0,
          'realtListingFee': matchingRealToken['realtListingFee'],
          'initialMaintenanceReserve':
              matchingRealToken['initialMaintenanceReserve'],
          'renovationReserve': matchingRealToken['renovationReserve'],
          'miscellaneousCosts': matchingRealToken['miscellaneousCosts'],
          'grossRentMonth': matchingRealToken['grossRentMonth'],
          'netRentMonth': matchingRealToken['netRentMonth'],
          'propertyMaintenanceMonthly':
              matchingRealToken['propertyMaintenanceMonthly'],
          'propertyManagement': matchingRealToken['propertyManagement'],
          'realtPlatform': matchingRealToken['realtPlatform'],
          'insurance': matchingRealToken['insurance'],
          'propertyTaxes': matchingRealToken['propertyTaxes'],
          'rentalType': matchingRealToken['rentalType'],
          'rentStartDate': matchingRealToken['rentStartDate']?['date'],
          'rentedUnits': matchingRealToken['rentedUnits'],
          'totalUnits': matchingRealToken['totalUnits'],
          'constructionYear': matchingRealToken['constructionYear'],
          'propertyStories': matchingRealToken['propertyStories'],
          'lotSize': matchingRealToken['lotSize'],
          'squareFeet': matchingRealToken['squareFeet'],
          'marketplaceLink': matchingRealToken['marketplaceLink'],
          'propertyType': matchingRealToken['propertyType'],
          'historic': matchingRealToken['historic'],
          'ethereumContract': matchingRealToken['ethereumContract'],
          'gnosisContract': matchingRealToken['gnosisContract'],
          'totalRentReceived': 0.0, // sera mis à jour juste après
          'initPrice': initPrice,
          'section8paid': matchingRealToken['section8paid'] ?? 0.0,
          'yamTotalVolume': yamTotalVolume,
          'yamAverageValue': yamAverageValue,
          'transactions': transactionsByToken[tokenContractAddress] ?? [],
          // Nouveau champ "wallets" pour suivre dans quels wallets ce token apparaît
          'wallets': [walletToken['wallet']],
        };
        newPortfolio.add(portfolioItem);
      }

      initialTotalValue += walletToken['amount'] * initPrice;
      yamTotalValue += walletToken['amount'] * yamAverageValue;

      // Mise à jour du loyer total pour ce token
      if (tokenAddress.isNotEmpty) {
        double? rentDetails = getRentDetailsForToken(tokenAddress);
        int index =
            newPortfolio.indexWhere((item) => item['uuid'] == tokenAddress);
        if (index != -1) {
          newPortfolio[index]['totalRentReceived'] = rentDetails;
        }
      }
    } // Fin de la boucle sur walletTokens

    // -------- Regroupement par wallet --------
    // Pour chaque token dans la liste brute, on regroupe par wallet et on cumule :
    // - La valeur totale des tokens de type "wallet"
    // - La somme des quantités
    // - Le nombre de tokens présents
    Map<String, Map<String, dynamic>> walletTotals = {};
    for (var token in walletTokens) {
      final String wallet = token['wallet'];
      // Initialisation si nécessaire
      if (!walletTotals.containsKey(wallet)) {
        walletTotals[wallet] = {
          'walletValueSum': 0.0,
          'walletTokensSum': 0.0,
          'tokenCount': 0,
        };
      }
      final tokenAddress = token['token'].toLowerCase();
      final matchingRealToken =
          realTokens.cast<Map<String, dynamic>>().firstWhere(
                (rt) => rt['uuid'].toLowerCase() == tokenAddress,
                orElse: () => <String, dynamic>{},
              );
      if (matchingRealToken.isEmpty) continue;
      final double tokenPrice = matchingRealToken['tokenPrice'] ?? 0.0;
      final double tokenValue = token['amount'] * tokenPrice;
      // On additionne uniquement pour les tokens de type "wallet"
      if (token['type'] == "wallet") {
        walletTotals[wallet]!['walletValueSum'] += tokenValue;
        walletTotals[wallet]!['walletTokensSum'] += token['amount'];
      }
      walletTotals[wallet]!['tokenCount'] += 1;
    }

    // Affichage des statistiques par wallet
    walletTotals.forEach((wallet, totals) {
      debugPrint(
          "Wallet: $wallet → Valeur: ${totals['walletValueSum']}, Quantité: ${totals['walletTokensSum']}, Nombre de tokens: ${totals['tokenCount']}");
    });

// -------- Calcul de la valeur RMM par wallet --------
    Map<String, double> walletRmmValues = {};
    for (var token in walletTokens) {
      // On considère ici uniquement les tokens de type RMM (donc différents de "wallet")
      if (token['type'] != "wallet") {
        final String wallet = token['wallet'];
        final String tokenAddress = token['token'].toLowerCase();
        // Recherche du token correspondant dans realTokens (comme déjà fait précédemment)
        final matchingRealToken =
            realTokens.cast<Map<String, dynamic>>().firstWhere(
                  (rt) => rt['uuid'].toLowerCase() == tokenAddress,
                  orElse: () => <String, dynamic>{},
                );
        if (matchingRealToken.isEmpty) continue;
        final double tokenPrice = matchingRealToken['tokenPrice'] ?? 0.0;
        final double tokenValue = token['amount'] * tokenPrice;
        // Cumuler la valeur RMM pour ce wallet
        walletRmmValues[wallet] = (walletRmmValues[wallet] ?? 0.0) + tokenValue;
      }
    }
// Stocker ces valeurs dans une variable accessible (par exemple, dans DataManager)
    perWalletRmmValues = walletRmmValues;
    walletRmmValues.forEach((wallet, value) {
      debugPrint("Wallet: $wallet → Valeur RMM: $value");
    });

    // -------- Mise à jour des variables globales pour le Dashboard --------
    totalWalletValue = walletValueSum +
        rmmValueSum +
        rwaValue +
        totalUsdcDepositBalance +
        totalXdaiDepositBalance -
        totalUsdcBorrowBalance -
        totalXdaiBorrowBalance;
    _archiveManager.archiveTotalWalletValue(totalWalletValue);

    walletValue = double.parse(walletValueSum.toStringAsFixed(3));
    rmmValue = double.parse(rmmValueSum.toStringAsFixed(3));
    rwaHoldingsValue = double.parse(rwaValue.toStringAsFixed(3));
    walletTokensSums = double.parse(walletTokensSum.toStringAsFixed(3));
    rmmTokensSums = double.parse(rmmTokensSum.toStringAsFixed(3));
    totalTokens = (walletTokensSum + rmmTokensSum);
    averageAnnualYield = yieldCount > 0 ? annualYieldSum / yieldCount : 0;
    dailyRent = dailyRentSum;
    weeklyRent = dailyRentSum * 7;
    monthlyRent = monthlyRentSum;
    yearlyRent = yearlyRentSum;

    walletTokenCount = uniqueWalletTokens.length;
    rmmTokenCount = uniqueRmmTokens.length;
    final Set<String> allUniqueTokens = {
      ...uniqueWalletTokens,
      ...uniqueRmmTokens
    };
    totalTokenCount = allUniqueTokens.length;
    duplicateTokenCount =
        uniqueWalletTokens.intersection(uniqueRmmTokens).length;

    _portfolio = newPortfolio;
    roiGlobalValue = getTotalRentReceived() / initialTotalValue * 100;
    _archiveManager.archiveRoiValue(roiGlobalValue);

    netGlobalApy = (((averageAnnualYield * (walletValue + rmmValue)) +
            (totalUsdcDepositBalance * usdcDepositApy +
                totalXdaiDepositBalance * xdaiDepositApy) -
            (totalUsdcBorrowBalance * usdcBorrowApy +
                totalXdaiBorrowBalance * xdaiBorrowApy)) /
        (walletValue +
            rmmValue +
            totalUsdcDepositBalance +
            totalXdaiDepositBalance +
            totalUsdcBorrowBalance +
            totalXdaiBorrowBalance));
    _archiveManager.archiveApyValue(netGlobalApy, averageAnnualYield);

    healthFactor =
        (rmmValue * 0.7) / (totalUsdcBorrowBalance + totalXdaiBorrowBalance);
    ltv = ((totalUsdcBorrowBalance + totalXdaiBorrowBalance) / rmmValue * 100);
    _archiveManager.archiveHealthAndLtvValue(healthFactor, ltv);

    notifyListeners();
  }

  List<Map<String, dynamic>> getCumulativeRentEvolution() {
    List<Map<String, dynamic>> cumulativeRentList = [];
    double cumulativeRent = 0.0;

    // Filtrer les entrées valides et trier par `rentStartDate`
    final validPortfolioEntries = _portfolio.where((entry) {
      return entry['rentStartDate'] != null && entry['dailyIncome'] != null;
    }).toList()
      ..sort((a, b) {
        DateTime dateA = DateTime.parse(a['rentStartDate']);
        DateTime dateB = DateTime.parse(b['rentStartDate']);
        return dateA.compareTo(dateB);
      });

    // Accumuler les loyers
    for (var portfolioEntry in validPortfolioEntries) {
      DateTime rentStartDate = DateTime.parse(portfolioEntry['rentStartDate']);
      double dailyIncome = portfolioEntry['dailyIncome'] ?? 0.0;

      // Ajouter loyer au cumul
      cumulativeRent += dailyIncome * 7; // Supposons un calcul hebdomadaire

      // Ajouter à la liste des loyers cumulés
      cumulativeRentList.add({
        'rentStartDate': rentStartDate,
        'cumulativeRent': cumulativeRent,
      });
    }

    return cumulativeRentList;
  }

  // Méthode pour extraire les mises à jour récentes sur les 30 derniers jours
  List<Map<String, dynamic>> _extractRecentUpdates(
      List<dynamic> realTokensRaw) {
    final List<Map<String, dynamic>> realTokens =
        realTokensRaw.cast<Map<String, dynamic>>();
    List<Map<String, dynamic>> recentUpdates = [];

    for (var token in realTokens) {
      // Vérification si update30 existe, est une liste et est non vide
      if (token.containsKey('update30') &&
          token['update30'] is List &&
          token['update30'].isNotEmpty) {
        // debugPrint("Processing updates for token: ${token['shortName'] ?? 'Nom inconnu'}");

        // Récupérer les informations de base du token
        final String shortName = token['shortName'] ?? 'Nom inconnu';
        final String imageLink =
            (token['imageLink'] != null && token['imageLink'].isNotEmpty)
                ? token['imageLink'][0]
                : 'Lien d\'image non disponible';

        // Filtrer et formater les mises à jour pertinentes
        List<Map<String, dynamic>> updatesWithDetails =
            List<Map<String, dynamic>>.from(token['update30'])
                .where((update) =>
                    update.containsKey('key') &&
                    _isRelevantKey(update['key'])) // Vérifier que 'key' existe
                .map((update) => _formatUpdateDetails(
                    update, shortName, imageLink)) // Formater les détails
                .toList();

        // Ajouter les mises à jour extraites dans recentUpdates
        recentUpdates.addAll(updatesWithDetails);
      } else {
        //debugPrint('Aucune mise à jour pour le token : ${token['shortName'] ?? 'Nom inconnu'}');
      }
    }

    // Trier les mises à jour par date
    recentUpdates.sort((a, b) =>
        DateTime.parse(b['timsync']).compareTo(DateTime.parse(a['timsync'])));
    return recentUpdates;
  }

  // Vérifier les clés pertinentes
  bool _isRelevantKey(String key) {
    return key == 'netRentYearPerToken' || key == 'annualPercentageYield';
  }

  // Formater les détails des mises à jour
  Map<String, dynamic> _formatUpdateDetails(
      Map<String, dynamic> update, String shortName, String imageLink) {
    String formattedKey = 'Donnée inconnue';
    String formattedOldValue = 'Valeur inconnue';
    String formattedNewValue = 'Valeur inconnue';

    // Vérifiez que les clés existent avant de les utiliser
    if (update['key'] == 'netRentYearPerToken') {
      double newValue = double.tryParse(update['new_value'] ?? '0') ?? 0.0;
      double oldValue = double.tryParse(update['old_value'] ?? '0') ?? 0.0;
      formattedKey = 'Net Rent Per Token (Annuel)';
      formattedOldValue = "${oldValue.toStringAsFixed(2)} USD";
      formattedNewValue = "${newValue.toStringAsFixed(2)} USD";
    } else if (update['key'] == 'annualPercentageYield') {
      double newValue = double.tryParse(update['new_value'] ?? '0') ?? 0.0;
      double oldValue = double.tryParse(update['old_value'] ?? '0') ?? 0.0;
      formattedKey = 'Rendement Annuel (%)';
      formattedOldValue = "${oldValue.toStringAsFixed(2)}%";
      formattedNewValue = "${newValue.toStringAsFixed(2)}%";
    }

    return {
      'shortName': shortName,
      'formattedKey': formattedKey,
      'formattedOldValue': formattedOldValue,
      'formattedNewValue': formattedNewValue,
      'timsync': update['timsync'] ?? '', // Assurez-vous que 'timsync' existe
      'imageLink': imageLink,
    };
  }

  // Méthode pour récupérer les données des loyers
  Future<void> fetchRentData({bool forceFetch = false}) async {
    var box = Hive.box('realTokens');

    // Charger les données en cache si disponibles
    final cachedRentData = box.get('cachedRentData');
    if (cachedRentData != null) {
      rentData = List<Map<String, dynamic>>.from(json.decode(cachedRentData));
      debugPrint("Données rentData en cache utilisées.");
    }
    Future(() async {
      try {
        // Exécuter l'appel d'API pour récupérer les données de loyer

        // Vérifier si les résultats ne sont pas vides avant de mettre à jour les variables
        if (tempRentData.isNotEmpty) {
          debugPrint(
              "Mise à jour des données de rentData avec de nouvelles valeurs.");
          rentData = tempRentData; // Mise à jour de la variable locale
          box.put('cachedRentData', json.encode(tempRentData));
        } else {
          debugPrint(
              "Les résultats des données de rentData sont vides, pas de mise à jour.");
        }
      } catch (e) {
        debugPrint("Erreur lors de la récupération des données de loyer: $e");
      }
    }).then((_) {
      notifyListeners(); // Notifier les listeners une fois les données mises à jour
    });
  }

  Future<void> processTransactionsHistory(
      BuildContext context,
      List<Map<String, dynamic>> transactionsHistory,
      List<Map<String, dynamic>> yamTransactions) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final Set<String> evmAddresses =
        Set.from(prefs.getStringList('evmAddresses') ?? {});

    Map<String, List<Map<String, dynamic>>> tempTransactionsByToken = {};

    debugPrint("📌 Début du traitement des transactions...");
    debugPrint(
        "📊 Nombre de transactionsHistory: ${transactionsHistory.length}");
    debugPrint("📊 Nombre de yamTransactions: ${yamTransactions.length}");

    for (var transaction in transactionsHistory) {
      final String? tokenId = transaction['token']?['id']?.toLowerCase();
      final String? timestamp = transaction['timestamp'];
      final String? amountStr = transaction['amount'];
      final String? sender = transaction['sender']?.toLowerCase();
      final String? transactionId = transaction['id']?.toLowerCase();

      if (tokenId == null ||
          timestamp == null ||
          amountStr == null ||
          transactionId == null) {
        debugPrint("⚠️ Transaction ignorée (champ manquant): $transaction");
        continue;
      }

      try {
        final int timestampMs = int.parse(timestamp) * 1000;
        final double amount = double.tryParse(amountStr) ?? 0.0;
        final bool isInternalTransfer = evmAddresses.contains(sender);
        String transactionType = isInternalTransfer
            ? S.of(context).internal_transfer
            : S.of(context).purchase;

        // Vérifier s'il existe une transaction YAM correspondante
        final matchingYamTransaction = yamTransactions.firstWhere(
          (yamTransaction) {
            final String? yamId =
                yamTransaction['Transaction ID'].toLowerCase();
            if (yamId == null || yamId.isEmpty) return false;
            final String yamIdTrimmed = yamId.substring(0, yamId.length - 10);
            final bool match = transactionId.startsWith(yamIdTrimmed);
            return match;
          },
          orElse: () => {},
        );

        double? price;
        if (matchingYamTransaction.isNotEmpty) {
          final double? rawPrice = matchingYamTransaction['Price']?.toDouble();
          price = rawPrice ?? 0.0;
          transactionType = S.of(context).yam;
          debugPrint("✅ Correspondance YAM trouvée ! Prix: $price");
        } else {
          debugPrint("❌ Aucune correspondance YAM trouvée.");
        }

        tempTransactionsByToken.putIfAbsent(tokenId, () => []).add({
          "amount": amount,
          "dateTime": DateTime.fromMillisecondsSinceEpoch(timestampMs),
          "transactionType": transactionType,
          "price": price,
        });
      } catch (e) {
        continue;
      }
    }

    // Ajouter les transactions YAM qui n'ont pas été trouvées dans transactionsHistory
    debugPrint(
        "📌 Vérification des transactions YAM non trouvées dans transactionsHistory...");
    for (var yamTransaction in yamTransactions) {
      final String? yamId = yamTransaction['Transaction ID']?.toLowerCase();
      if (yamId == null || yamId.isEmpty) continue;

      final String yamIdTrimmed = yamId.substring(0, yamId.length - 10);
      final bool alreadyExists = transactionsHistory.any((transaction) =>
          transaction['id']?.startsWith(yamIdTrimmed) ?? false);

      if (!alreadyExists) {
        final String? yamTimestamp = yamTransaction['Created At'];
        final double? yamPrice = yamTransaction['Price']?.toDouble();
        final double? yamQuantity = yamTransaction['Quantity']?.toDouble();
        final String? offerTokenAddress =
            yamTransaction['Offer Token Address']?.toLowerCase();

        if (yamTimestamp == null ||
            yamPrice == null ||
            yamQuantity == null ||
            offerTokenAddress == null) {
          debugPrint(
              "⚠️ Transaction YAM ignorée (champ manquant): $yamTransaction");
          continue;
        }

        final int timestampMs = int.parse(yamTimestamp) * 1000;

        debugPrint(
            "➕ Ajout d'une nouvelle transaction YAM | ID: $yamId, Token: $offerTokenAddress, Amount: $yamQuantity, Price: $yamPrice");

        tempTransactionsByToken.putIfAbsent(offerTokenAddress, () => []).add({
          "amount": yamQuantity,
          "dateTime": DateTime.fromMillisecondsSinceEpoch(timestampMs),
          "transactionType": S.of(context).yam,
          "price": yamPrice,
        });
      }
    }

    debugPrint("✅ Fin du traitement des transactions.");
    transactionsByToken.addAll(tempTransactionsByToken);
    isLoadingTransactions = false;
  }

  // Méthode pour récupérer les données des propriétés
  Future<void> fetchPropertyData({bool forceFetch = false}) async {
    List<Map<String, dynamic>> tempPropertyData = [];

    // Fusionner les tokens du portefeuille et du RMM
    List<dynamic> allTokens = [];
    for (var wallet in walletTokens) {
      allTokens
          .addAll(wallet['balances']); // Ajouter tous les balances des wallets
    }

    // Parcourir chaque token du portefeuille et du RMM
    for (var token in allTokens) {
      if (token != null &&
          token['token'] != null &&
          (token['token']['address'] != null || token['token']['id'] != null)) {
        final tokenAddress =
            (token['token']['address'] ?? token['token']['id'])?.toLowerCase();

        // Correspondre avec les RealTokens
        final matchingRealToken = realTokens
            .cast<Map<String, dynamic>>()
            .firstWhere(
              (realToken) =>
                  realToken['uuid'].toLowerCase() == tokenAddress.toLowerCase(),
              orElse: () => <String, dynamic>{},
            );

        if (matchingRealToken.isNotEmpty &&
            matchingRealToken['propertyType'] != null) {
          final propertyType = matchingRealToken['propertyType'];

          // Vérifiez si le type de propriété existe déjà dans propertyData
          final existingPropertyType = tempPropertyData.firstWhere(
            (data) => data['propertyType'] == propertyType,
            orElse: () => <String,
                dynamic>{}, // Renvoie un map vide si aucune correspondance n'est trouvée
          );

          if (existingPropertyType.isNotEmpty) {
            // Incrémenter le compte si la propriété existe déjà
            existingPropertyType['count'] += 1;
          } else {
            // Ajouter une nouvelle entrée si la propriété n'existe pas encore
            tempPropertyData.add({'propertyType': propertyType, 'count': 1});
          }
        }
      } else {
        debugPrint('Invalid token or missing address for token: $token');
      }
    }
    propertyData = tempPropertyData;
    notifyListeners();
  }

  // Méthode pour réinitialiser toutes les données
  Future<void> resetData() async {
    // Remettre toutes les variables à leurs valeurs initiales
    totalWalletValue = 0;
    walletValue = 0;
    rmmValue = 0;
    rwaHoldingsValue = 0;
    rentedUnits = 0;
    totalUnits = 0;
    totalTokens = 0;
    walletTokensSums = 0.0;
    rmmTokensSums = 0.0;
    averageAnnualYield = 0;
    dailyRent = 0;
    weeklyRent = 0;
    monthlyRent = 0;
    yearlyRent = 0;
    totalUsdcDepositBalance = 0;
    totalUsdcBorrowBalance = 0;
    totalXdaiDepositBalance = 0;
    totalXdaiBorrowBalance = 0;

    // Réinitialiser toutes les variables relatives à RealTokens
    totalRealtTokens = 0;
    totalRealtInvestment = 0.0;
    netRealtRentYear = 0.0;
    realtInitialPrice = 0.0;
    realtActualPrice = 0.0;
    totalRealtUnits = 0;
    rentedRealtUnits = 0;
    averageRealtAnnualYield = 0.0;

    // Réinitialiser les compteurs de tokens
    walletTokenCount = 0;
    rmmTokenCount = 0;
    totalTokenCount = 0;
    duplicateTokenCount = 0;

    // Vider les listes de données
    rentData = [];
    detailedRentData = [];
    propertyData = [];
    rmmBalances = [];
    perWalletBalances = [];
    walletTokens = [];
    realTokens = [];
    tempRentData = [];
    _portfolio = [];
    _recentUpdates = [];

    // Réinitialiser la map userIdToAddresses
    userIdToAddresses.clear();

    // Notifier les observateurs que les données ont été réinitialisées
    notifyListeners();

    // Supprimer également les préférences sauvegardées si nécessaire
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Si vous voulez vider toutes les préférences

    // Vider les caches Hive
    var box = Hive.box('realTokens');
    await box.clear(); // Vider la boîte Hive utilisée pour le cache des tokens

    debugPrint('Toutes les données ont été réinitialisées.');
  }

 Future<void> fetchRmmBalances() async {
  try {
    // Totaux globaux
    double totalUsdcDepositSum = 0;
    double totalUsdcBorrowSum = 0;
    double totalXdaiDepositSum = 0;
    double totalXdaiBorrowSum = 0;
    double totalGnosisUsdcSum = 0;
    double totalGnosisXdaiSum = 0;

    // Liste pour stocker les données par wallet
    List<Map<String, dynamic>> walletDetails = [];

    String? timestamp;

    // Itérer sur chaque balance (chaque wallet)
    for (var balance in rmmBalances) {
      double usdcDeposit = balance['usdcDepositBalance'];
      double usdcBorrow = balance['usdcBorrowBalance'];
      double xdaiDeposit = balance['xdaiDepositBalance'];
      double xdaiBorrow = balance['xdaiBorrowBalance'];
      double gnosisUsdc = balance['gnosisUsdcBalance'];
      double gnosisXdai = balance['gnosisXdaiBalance'];
      timestamp = balance['timestamp']; // Dernier timestamp mis à jour

      // Mise à jour des totaux globaux
      totalUsdcDepositSum += usdcDeposit;
      totalUsdcBorrowSum += usdcBorrow;
      totalXdaiDepositSum += xdaiDeposit;
      totalXdaiBorrowSum += xdaiBorrow;
      totalGnosisUsdcSum += gnosisUsdc;
      totalGnosisXdaiSum += gnosisXdai;

      // Stocker les données propres au wallet
      walletDetails.add({
        'address': balance['address'],
        'usdcDeposit': usdcDeposit,
        'usdcBorrow': usdcBorrow,
        'xdaiDeposit': xdaiDeposit,
        'xdaiBorrow': xdaiBorrow,
        'gnosisUsdc': gnosisUsdc,
        'gnosisXdai': gnosisXdai,
        'timestamp': timestamp,
      });
    }

    // Mise à jour des variables globales avec les totaux cumulés
    totalUsdcDepositBalance = totalUsdcDepositSum;
    totalUsdcBorrowBalance = totalUsdcBorrowSum;
    totalXdaiDepositBalance = totalXdaiDepositSum;
    totalXdaiBorrowBalance = totalXdaiBorrowSum;
    gnosisUsdcBalance = totalGnosisUsdcSum;
    gnosisXdaiBalance = totalGnosisXdaiSum;

    // Stocker les détails par wallet
    perWalletBalances = walletDetails;

    // Calcul de l'APY GLOBAL uniquement après avoir accumulé les totaux
    try {
      usdcDepositApy = await calculateAPY('usdcDeposit');
      usdcBorrowApy = await calculateAPY('usdcBorrow');
      xdaiDepositApy = await calculateAPY('xdaiDeposit');
      xdaiBorrowApy = await calculateAPY('xdaiBorrow');
    } catch (e) {
      debugPrint('Erreur lors du calcul de l\'APY global: $e');
    }

    // Debug : Afficher les totaux globaux et APY
    debugPrint(
        'Totaux globaux: USDC Deposit: $totalUsdcDepositSum, USDC Borrow: $totalUsdcBorrowSum, '
        'XDAI Deposit: $totalXdaiDepositSum, XDAI Borrow: $totalXdaiBorrowSum, '
        'Gnosis USDC: $totalGnosisUsdcSum, Gnosis XDAI: $totalGnosisXdaiSum');

    debugPrint('APY Global: USDC Deposit: $usdcDepositApy, USDC Borrow: $usdcBorrowApy, '
        'XDAI Deposit: $xdaiDepositApy, XDAI Borrow: $xdaiBorrowApy');

    notifyListeners(); // Notifier l'interface que les données ont été mises à jour

    // Archivage global si une heure s'est écoulée depuis le dernier archivage
    if (lastArchiveTime == null || DateTime.now().difference(lastArchiveTime!).inHours >= 1) {
      if (timestamp != null) {
        _archiveManager.archiveBalance('usdcDeposit', totalUsdcDepositSum, timestamp);
        _archiveManager.archiveBalance('usdcBorrow', totalUsdcBorrowSum, timestamp);
        _archiveManager.archiveBalance('xdaiDeposit', totalXdaiDepositSum, timestamp);
        _archiveManager.archiveBalance('xdaiBorrow', totalXdaiBorrowSum, timestamp);
        lastArchiveTime = DateTime.now();
      }
    }
  } catch (e) {
    debugPrint('Erreur lors de la récupération des balances RMM: $e');
  }
}

  Future<double> calculateAPY(String tokenType) async {
    // Récupérer l'historique des balances
    List<BalanceRecord> history = await _archiveManager.getBalanceHistory(tokenType);

    // Vérifier s'il y a au moins deux enregistrements pour calculer l'APY
    if (history.length < 2) {
      throw Exception("Not enough data to calculate APY.");
    }

    // Calculer l'APY moyen des 3 dernières paires valides
    double averageAPYForLastThreePairs = _calculateAPYForLastThreeValidPairs(history);

    // Si aucune paire valide n'est trouvée, retourner 0
    if (averageAPYForLastThreePairs == 0) {
      return 0;
    }

    // Calculer l'APY moyen global sur toutes les paires
    apyAverage = _calculateAverageAPY(history);

    return averageAPYForLastThreePairs; // Retourner l'APY moyen des 3 dernières paires valides
  }

  // Calculer l'APY sur les 3 dernières paires valides (APY > 0 et < 20%)
  double _calculateAPYForLastThreeValidPairs(List<BalanceRecord> history) {
    double totalAPY = 0;
    int validPairsCount = 0;

    // Parcourir l'historique à l'envers pour chercher les paires valides
    for (int i = history.length - 1; i > 0 && validPairsCount < 3; i--) {
      double apy = _calculateAPY(history[i], history[i - 1]);

      // Si l'APY est valide (entre 0 et 20%), on l'ajoute
      if (apy > 0 && apy < 20) {
        totalAPY += apy;
        validPairsCount++;
      }
    }

    // Calculer la moyenne sur les paires valides trouvées
    return validPairsCount > 0 ? totalAPY / validPairsCount : 0;
  }

  // Calculer la moyenne des APY sur toutes les paires d'enregistrements, en ignorant les dépôts/retraits
  double _calculateAverageAPY(List<BalanceRecord> history) {
    double totalAPY = 0;
    int count = 0;

    for (int i = 1; i < history.length; i++) {
      double apy = _calculateAPY(history[i], history[i - 1]);

      // Ne prendre en compte que les paires valides (APY entre 0 et 25%)
      if (apy > 0 && apy < 25) {
        totalAPY += apy;
        count++;
      }
    }

    // Retourner la moyenne des APY valides, ou 0 s'il n'y a aucune paire valide
    return count > 0 ? totalAPY / count : 0;
  }

  // Fonction pour calculer l'APY entre deux enregistrements avec une tolérance pour les petits changements
  double _calculateAPY(BalanceRecord current, BalanceRecord previous) {
    double initialBalance = previous.balance;
    double finalBalance = current.balance;

    // Calculer la différence en pourcentage
    double percentageChange =
        ((finalBalance - initialBalance) / initialBalance) * 100;

    // Ignorer si la différence est trop faible (par exemple moins de 0,001%)
    if (percentageChange.abs() < 0.001) {
      return 0; // Ne pas prendre en compte cette paire
    }

    // Ignorer si la différence est supérieure à 20% ou inférieure à 0% (dépôt ou retrait)
    if (percentageChange > 20 || percentageChange < 0) {
      return 0; // Ne pas prendre en compte cette paire
    }

    // Calculer la durée en secondes
    double timePeriodInSeconds =
        current.timestamp.difference(previous.timestamp).inSeconds.toDouble();

    // Ignorer les périodes trop courtes (moins de 1 minute, par exemple)
    if (timePeriodInSeconds < 60) {
      return 0;
    }

    // Calculer l'APY en utilisant des secondes et convertir pour une période annuelle
    double apy = ((finalBalance - initialBalance) / initialBalance) *
        (365 * 24 * 60 * 60 / timePeriodInSeconds) *
        100;

    return apy;
  }

  double getTotalRentReceived() {
    return rentData.fold(
        0.0,
        (total, rentEntry) =>
            total +
            (rentEntry['rent'] is String
                ? double.parse(rentEntry['rent'])
                : rentEntry['rent']));
  }

  double getRentDetailsForToken(String token) {
    double totalRent = 0.0;

    // Parcourir chaque entrée de la liste detailedRentData
    for (var entry in detailedRentData) {
      // Vérifie si l'entrée contient une liste de 'rents'
      if (entry.containsKey('rents') && entry['rents'] is List) {
        List rents = entry['rents'];

        // Parcourir chaque élément de la liste des loyers
        for (var rentEntry in rents) {
          if (rentEntry['token'] != null &&
              rentEntry['token'].toLowerCase() == token.toLowerCase()) {
            // Ajoute le rent à totalRent si le token correspond
            totalRent += (rentEntry['rent'] ?? 0.0).toDouble();
          }
        }
      }
    }

    return totalRent;
  }

  // Méthode pour charger les valeurs définies manuellement depuis Hive
  Future<void> loadCustomInitPrices() async {
    final savedData = customInitPricesBox.get('customInitPrices') as String?;

    if (savedData != null) {
      final decodedMap = Map<String, dynamic>.from(jsonDecode(savedData));
      customInitPrices =
          decodedMap.map((key, value) => MapEntry(key, value as double));
    }
    notifyListeners();
  }

  // Méthode pour sauvegarder les valeurs manuelles dans Hive
  Future<void> saveCustomInitPrices() async {
    final encodedData = jsonEncode(customInitPrices);
    await customInitPricesBox.put('customInitPrices', encodedData);
  }

  // Méthode pour définir une valeur initPrice personnalisée
  void setCustomInitPrice(String tokenUuid, double initPrice) {
    customInitPrices[tokenUuid] = initPrice;
    //debugPrint("token: $tokenUuid et prix: $initPrice");
    saveCustomInitPrices(); // Sauvegarder après modification
    notifyListeners();
  }

  void removeCustomInitPrice(String tokenUuid) {
    customInitPrices.remove(tokenUuid);
    saveCustomInitPrices(); // Sauvegarde les changements dans Hive
    notifyListeners();
  }

  Future<void> fetchAndStorePropertiesForSale() async {
    try {
      if (propertiesForSaleFetched.isNotEmpty) {
        propertiesForSale = propertiesForSaleFetched.map((property) {
          // Chercher le RealToken correspondant à partir de realTokens en comparant `title` et `fullName`
          final matchingToken = allTokens.firstWhere(
            (token) =>
                property['title'] != null &&
                token['shortName'] != null &&
                property['title']
                    .toString()
                    .contains(token['shortName'].toString()),
            orElse: () => <String, dynamic>{},
          );

          return {
            'title': property['title'],
            'fullName': matchingToken['fullName'],
            'shortName': matchingToken['shortName'],
            'marketplaceLink': matchingToken['marketplaceLink'],
            'country': matchingToken['country'],
            'city': matchingToken['city'],
            'tokenPrice': matchingToken['tokenPrice'],
            'annualPercentageYield': matchingToken['annualPercentageYield'],
            'totalTokens': matchingToken['totalTokens'],
            'rentStartDate': matchingToken['rentStartDate'],
            'status': property['status'],
            'productId': property['product_id'],
            'stock': property['stock'],
            'maxPurchase': property['max_purchase'],
            'imageLink': matchingToken['imageLink'],
          };
        }).toList();
      } else {
        debugPrint("⚠️ DataManager: Aucune propriété en vente trouvée");
      }
    } catch (e) {
      debugPrint(
          "DataManager: Erreur lors de la récupération des propriétés en vente: $e");
    }

    // Notifie les widgets que les données ont changé
    notifyListeners();
  }

  Future<void> fetchAndStoreYamMarketData() async {
    var box = Hive.box('realTokens');

    // Récupération des données en cache, si disponibles
    final cachedData = box.get('cachedYamMarket');
    List<Map<String, dynamic>> yamMarketData = [];

    if (cachedData != null) {
      yamMarketFetched =
          List<Map<String, dynamic>>.from(json.decode(cachedData));
      debugPrint(
          "✅ Données YamMarket en cache trouvées : ${yamMarketFetched.length} offres chargées.");
    } else {
      debugPrint("⚠️ Aucune donnée YamMarket en cache.");
    }

    double totalTokenValue = 0.0;
    int totalOffers = 0;
    double totalTokenAmount = 0.0;

    List<Map<String, dynamic>> allOffersList = [];

    if (yamMarketFetched.isNotEmpty) {
      //debugPrint("🔄 Début du traitement des ${yamMarketFetched.length} offres...");

      for (var offer in yamMarketFetched) {
        // debugPrint("🔍 Traitement de l'offre ID: ${offer['id_offer']} - Token Sell: ${offer['token_to_sell']} - Token Buy: ${offer['token_to_buy']}");

        // Vérifier si le token de l'offre correspond à un token de allTokens
        final matchingToken = allTokens.firstWhere(
            (token) =>
                token['uuid'] == offer['token_to_sell']?.toLowerCase() ||
                token['uuid'] == offer['token_to_buy']?.toLowerCase(),
            orElse: () {
          // debugPrint("⚠️ Aucun token correspondant trouvé pour l'offre ${offer['id_offer']}. UUIDs: sell=${offer['token_to_sell']}, buy=${offer['token_to_buy']}");
          return <String, dynamic>{};
        });

        // Vérifier si un token a été trouvé
        if (matchingToken.isEmpty) {
          //debugPrint("🚨 Offre ignorée car aucun token correspondant trouvé.");
          continue;
        }

        // Récupérer et convertir les valeurs nécessaires
        double tokenAmount = (offer['token_amount'] ?? 0.0).toDouble();
        double tokenValue = (offer['token_value'] ?? 0.0).toDouble();
        totalTokenValue += tokenValue;
        totalTokenAmount += tokenAmount;
        totalOffers += 1;

        // Ajouter l'offre traitée à la liste
        allOffersList.add({
          'id': offer['id'],
          'shortName': matchingToken['shortName'] ?? 'Unknown',
          'country': matchingToken['country'] ?? 'Unknown',
          'city': matchingToken['city'] ?? 'Unknown',
          'rentStartDate': matchingToken['rentStartDate'],
          'tokenToPay': offer['token_to_pay'],
          'imageLink': matchingToken['imageLink'],
          'holderAddress': offer['holder_address'],
          'token_amount': offer['token_amount'],
          'token_price': matchingToken['tokenPrice'],
          'annualPercentageYield': matchingToken['annualPercentageYield'],
          'tokenDigit': offer['token_digit'],
          'creationDate': offer['creation_date'],
          'token_to_pay': offer['token_to_pay'],
          'token_to_sell': offer['token_to_sell'],
          'token_to_buy': offer['token_to_buy'],
          'id_offer': offer['id_offer'],
          'tokenToPayDigit': offer['token_to_pay_digit'],
          'token_value': offer['token_value'],
          'blockNumber': offer['block_number'],
          'supp': offer['supp'],
          'timsync': offer['timsync'],
          'buyHolderAddress': offer['buy_holder_address'],
        });

        //debugPrint("✅ Offre ajoutée : ${offer['id_offer']} - Token: ${matchingToken['shortName']} - Montant: $tokenAmount - Valeur: $tokenValue");
      }

      yamMarket = allOffersList;
      //debugPrint("✅ Mise à jour de YamMarket terminée : $_totalOffers offres disponibles.");

      notifyListeners();
    } else {
      debugPrint("⚠️ Aucune donnée YamMarket disponible après traitement.");
    }
  }

  void fetchYamHistory() {
    var box = Hive.box('realTokens');
    final yamHistoryJson = box.get('yamHistory');

    if (yamHistoryJson == null) {
      debugPrint(
          "❌ fetchYamHistory -> Aucune donnée Yam History trouvée dans Hive.");
      return;
    }

    List<dynamic> yamHistoryData = json.decode(yamHistoryJson);

    // Regroupement par token
    Map<String, List<Map<String, dynamic>>> grouped = {};
    for (var entry in yamHistoryData) {
      String token = entry['Token'];
      if (grouped[token] == null) {
        grouped[token] = [];
      }
      grouped[token]!.add(Map<String, dynamic>.from(entry));
    }

    List<Map<String, dynamic>> tokenStatistics = [];
    grouped.forEach((token, entries) {
      double totalVolume = 0;
      double totalQuantity = 0;
      for (var day in entries) {
        totalVolume += (day['Volume'] as num).toDouble();
        totalQuantity += (day['Quantity'] as num).toDouble();
      }
      double averageValue = totalQuantity > 0 ? totalVolume / totalQuantity : 0;
      tokenStatistics.add({
        'id': token,
        'totalVolume': totalVolume,
        'averageValue': averageValue,
      });
    });

    debugPrint(
        "fetchYamHistory -> Mise à jour des statistiques des tokens Yam.");
    yamHistory = tokenStatistics;
    notifyListeners();
  }
}
