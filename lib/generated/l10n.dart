// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Settings`
  String get settingsTitle {
    return Intl.message(
      'Settings',
      name: 'settingsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Dark Theme`
  String get darkTheme {
    return Intl.message(
      'Dark Theme',
      name: 'darkTheme',
      desc: '',
      args: [],
    );
  }

  /// `Light`
  String get light {
    return Intl.message(
      'Light',
      name: 'light',
      desc: '',
      args: [],
    );
  }

  /// `Dark`
  String get dark {
    return Intl.message(
      'Dark',
      name: 'dark',
      desc: '',
      args: [],
    );
  }

  /// `Theme updated to {theme}`
  String themeUpdated(Object theme) {
    return Intl.message(
      'Theme updated to $theme',
      name: 'themeUpdated',
      desc: '',
      args: [theme],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Language updated to {language}`
  String languageUpdated(Object language) {
    return Intl.message(
      'Language updated to $language',
      name: 'languageUpdated',
      desc: '',
      args: [language],
    );
  }

  /// `English`
  String get english {
    return Intl.message(
      'English',
      name: 'english',
      desc: '',
      args: [],
    );
  }

  /// `Francais`
  String get french {
    return Intl.message(
      'Francais',
      name: 'french',
      desc: '',
      args: [],
    );
  }

  /// `Español`
  String get spanish {
    return Intl.message(
      'Español',
      name: 'spanish',
      desc: '',
      args: [],
    );
  }

  /// `Italiano`
  String get italian {
    return Intl.message(
      'Italiano',
      name: 'italian',
      desc: '',
      args: [],
    );
  }

  /// `中文`
  String get chinese {
    return Intl.message(
      '中文',
      name: 'chinese',
      desc: '',
      args: [],
    );
  }

  /// `Português`
  String get portuguese {
    return Intl.message(
      'Português',
      name: 'portuguese',
      desc: '',
      args: [],
    );
  }

  /// `Manage Wallets`
  String get manageEvmAddresses {
    return Intl.message(
      'Manage Wallets',
      name: 'manageEvmAddresses',
      desc: '',
      args: [],
    );
  }

  /// `Hello`
  String get hello {
    return Intl.message(
      'Hello',
      name: 'hello',
      desc: '',
      args: [],
    );
  }

  /// `Your last rent received amounts to `
  String get lastRentReceived {
    return Intl.message(
      'Your last rent received amounts to ',
      name: 'lastRentReceived',
      desc: '',
      args: [],
    );
  }

  /// `Portfolio`
  String get portfolio {
    return Intl.message(
      'Portfolio',
      name: 'portfolio',
      desc: '',
      args: [],
    );
  }

  /// `Total Portfolio`
  String get totalPortfolio {
    return Intl.message(
      'Total Portfolio',
      name: 'totalPortfolio',
      desc: '',
      args: [],
    );
  }

  /// `Wallet`
  String get wallet {
    return Intl.message(
      'Wallet',
      name: 'wallet',
      desc: '',
      args: [],
    );
  }

  /// `RMM`
  String get rmm {
    return Intl.message(
      'RMM',
      name: 'rmm',
      desc: '',
      args: [],
    );
  }

  /// `Currency`
  String get currency {
    return Intl.message(
      'Currency',
      name: 'currency',
      desc: '',
      args: [],
    );
  }

  /// `RWA Holdings SA`
  String get rwaHoldings {
    return Intl.message(
      'RWA Holdings SA',
      name: 'rwaHoldings',
      desc: '',
      args: [],
    );
  }

  /// `Properties`
  String get properties {
    return Intl.message(
      'Properties',
      name: 'properties',
      desc: '',
      args: [],
    );
  }

  /// `Rented`
  String get rented {
    return Intl.message(
      'Rented',
      name: 'rented',
      desc: '',
      args: [],
    );
  }

  /// `Rented Units`
  String get rentedUnits {
    return Intl.message(
      'Rented Units',
      name: 'rentedUnits',
      desc: '',
      args: [],
    );
  }

  /// `units`
  String get units {
    return Intl.message(
      'units',
      name: 'units',
      desc: '',
      args: [],
    );
  }

  /// `Tokens`
  String get tokens {
    return Intl.message(
      'Tokens',
      name: 'tokens',
      desc: '',
      args: [],
    );
  }

  /// `Total Tokens`
  String get totalTokens {
    return Intl.message(
      'Total Tokens',
      name: 'totalTokens',
      desc: '',
      args: [],
    );
  }

  /// `Rents`
  String get rents {
    return Intl.message(
      'Rents',
      name: 'rents',
      desc: '',
      args: [],
    );
  }

  /// `Net Yield`
  String get annualYield {
    return Intl.message(
      'Net Yield',
      name: 'annualYield',
      desc: '',
      args: [],
    );
  }

  /// `Daily`
  String get daily {
    return Intl.message(
      'Daily',
      name: 'daily',
      desc: '',
      args: [],
    );
  }

  /// `Weekly`
  String get weekly {
    return Intl.message(
      'Weekly',
      name: 'weekly',
      desc: '',
      args: [],
    );
  }

  /// `Monthly`
  String get monthly {
    return Intl.message(
      'Monthly',
      name: 'monthly',
      desc: '',
      args: [],
    );
  }

  /// `Annually`
  String get annually {
    return Intl.message(
      'Annually',
      name: 'annually',
      desc: '',
      args: [],
    );
  }

  /// `No rent received`
  String get noRentReceived {
    return Intl.message(
      'No rent received',
      name: 'noRentReceived',
      desc: '',
      args: [],
    );
  }

  /// `Finances`
  String get finances {
    return Intl.message(
      'Finances',
      name: 'finances',
      desc: '',
      args: [],
    );
  }

  /// `Others`
  String get others {
    return Intl.message(
      'Others',
      name: 'others',
      desc: '',
      args: [],
    );
  }

  /// `Details of the Others section`
  String get othersTitle {
    return Intl.message(
      'Details of the Others section',
      name: 'othersTitle',
      desc: '',
      args: [],
    );
  }

  /// `Insights`
  String get insights {
    return Intl.message(
      'Insights',
      name: 'insights',
      desc: '',
      args: [],
    );
  }

  /// `Characteristics`
  String get characteristics {
    return Intl.message(
      'Characteristics',
      name: 'characteristics',
      desc: '',
      args: [],
    );
  }

  /// `Year of construction`
  String get constructionYear {
    return Intl.message(
      'Year of construction',
      name: 'constructionYear',
      desc: '',
      args: [],
    );
  }

  /// `Number of stories`
  String get propertyStories {
    return Intl.message(
      'Number of stories',
      name: 'propertyStories',
      desc: '',
      args: [],
    );
  }

  /// `Total units`
  String get totalUnits {
    return Intl.message(
      'Total units',
      name: 'totalUnits',
      desc: '',
      args: [],
    );
  }

  /// `Lot size`
  String get lotSize {
    return Intl.message(
      'Lot size',
      name: 'lotSize',
      desc: '',
      args: [],
    );
  }

  /// `Interior size`
  String get squareFeet {
    return Intl.message(
      'Interior size',
      name: 'squareFeet',
      desc: '',
      args: [],
    );
  }

  /// `Offering`
  String get offering {
    return Intl.message(
      'Offering',
      name: 'offering',
      desc: '',
      args: [],
    );
  }

  /// `Initial launch date`
  String get initialLaunchDate {
    return Intl.message(
      'Initial launch date',
      name: 'initialLaunchDate',
      desc: '',
      args: [],
    );
  }

  /// `Rental type`
  String get rentalType {
    return Intl.message(
      'Rental type',
      name: 'rentalType',
      desc: '',
      args: [],
    );
  }

  /// `First rent`
  String get rentStartDate {
    return Intl.message(
      'First rent',
      name: 'rentStartDate',
      desc: '',
      args: [],
    );
  }

  /// `Total investment`
  String get totalInvestment {
    return Intl.message(
      'Total investment',
      name: 'totalInvestment',
      desc: '',
      args: [],
    );
  }

  /// `Asset price`
  String get underlyingAssetPrice {
    return Intl.message(
      'Asset price',
      name: 'underlyingAssetPrice',
      desc: '',
      args: [],
    );
  }

  /// `Maintenance reserve`
  String get initialMaintenanceReserve {
    return Intl.message(
      'Maintenance reserve',
      name: 'initialMaintenanceReserve',
      desc: '',
      args: [],
    );
  }

  /// `Gross rent per month`
  String get grossRentMonth {
    return Intl.message(
      'Gross rent per month',
      name: 'grossRentMonth',
      desc: '',
      args: [],
    );
  }

  /// `Net rent per month`
  String get netRentMonth {
    return Intl.message(
      'Net rent per month',
      name: 'netRentMonth',
      desc: '',
      args: [],
    );
  }

  /// `Annual yield`
  String get annualPercentageYield {
    return Intl.message(
      'Annual yield',
      name: 'annualPercentageYield',
      desc: '',
      args: [],
    );
  }

  /// `Blockchain`
  String get blockchain {
    return Intl.message(
      'Blockchain',
      name: 'blockchain',
      desc: '',
      args: [],
    );
  }

  /// `Token address`
  String get tokenAddress {
    return Intl.message(
      'Token address',
      name: 'tokenAddress',
      desc: '',
      args: [],
    );
  }

  /// `Network`
  String get network {
    return Intl.message(
      'Network',
      name: 'network',
      desc: '',
      args: [],
    );
  }

  /// `Token symbol`
  String get tokenSymbol {
    return Intl.message(
      'Token symbol',
      name: 'tokenSymbol',
      desc: '',
      args: [],
    );
  }

  /// `Contract type`
  String get contractType {
    return Intl.message(
      'Contract type',
      name: 'contractType',
      desc: '',
      args: [],
    );
  }

  /// `Rental status`
  String get rentalStatus {
    return Intl.message(
      'Rental status',
      name: 'rentalStatus',
      desc: '',
      args: [],
    );
  }

  /// `Yield evolution`
  String get yieldEvolution {
    return Intl.message(
      'Yield evolution',
      name: 'yieldEvolution',
      desc: '',
      args: [],
    );
  }

  /// `Price evolution`
  String get priceEvolution {
    return Intl.message(
      'Price evolution',
      name: 'priceEvolution',
      desc: '',
      args: [],
    );
  }

  /// `View on RealT`
  String get viewOnRealT {
    return Intl.message(
      'View on RealT',
      name: 'viewOnRealT',
      desc: '',
      args: [],
    );
  }

  /// `Not specified`
  String get notSpecified {
    return Intl.message(
      'Not specified',
      name: 'notSpecified',
      desc: '',
      args: [],
    );
  }

  /// `No price evolution. The last price is:`
  String get noPriceEvolution {
    return Intl.message(
      'No price evolution. The last price is:',
      name: 'noPriceEvolution',
      desc: '',
      args: [],
    );
  }

  /// `Price evolution:`
  String get priceEvolutionPercentage {
    return Intl.message(
      'Price evolution:',
      name: 'priceEvolutionPercentage',
      desc: '',
      args: [],
    );
  }

  /// `No yield evolution. The last yield is:`
  String get noYieldEvolution {
    return Intl.message(
      'No yield evolution. The last yield is:',
      name: 'noYieldEvolution',
      desc: '',
      args: [],
    );
  }

  /// `Yield evolution:`
  String get yieldEvolutionPercentage {
    return Intl.message(
      'Yield evolution:',
      name: 'yieldEvolutionPercentage',
      desc: '',
      args: [],
    );
  }

  /// `Unknown City`
  String get unknownCity {
    return Intl.message(
      'Unknown City',
      name: 'unknownCity',
      desc: '',
      args: [],
    );
  }

  /// `Name Unavailable`
  String get nameUnavailable {
    return Intl.message(
      'Name Unavailable',
      name: 'nameUnavailable',
      desc: '',
      args: [],
    );
  }

  /// `Other`
  String get other {
    return Intl.message(
      'Other',
      name: 'other',
      desc: '',
      args: [],
    );
  }

  /// `Total Value`
  String get totalValue {
    return Intl.message(
      'Total Value',
      name: 'totalValue',
      desc: '',
      args: [],
    );
  }

  /// `Amount`
  String get amount {
    return Intl.message(
      'Amount',
      name: 'amount',
      desc: '',
      args: [],
    );
  }

  /// `APY`
  String get apy {
    return Intl.message(
      'APY',
      name: 'apy',
      desc: '',
      args: [],
    );
  }

  /// `average APY`
  String get averageApy {
    return Intl.message(
      'average APY',
      name: 'averageApy',
      desc: '',
      args: [],
    );
  }

  /// `Revenue`
  String get revenue {
    return Intl.message(
      'Revenue',
      name: 'revenue',
      desc: '',
      args: [],
    );
  }

  /// `Day`
  String get day {
    return Intl.message(
      'Day',
      name: 'day',
      desc: '',
      args: [],
    );
  }

  /// `Month`
  String get month {
    return Intl.message(
      'Month',
      name: 'month',
      desc: '',
      args: [],
    );
  }

  /// `Year`
  String get year {
    return Intl.message(
      'Year',
      name: 'year',
      desc: '',
      args: [],
    );
  }

  /// `RealToken`
  String get appName {
    return Intl.message(
      'RealToken',
      name: 'appName',
      desc: '',
      args: [],
    );
  }

  /// `mobile app for Community`
  String get appDescription {
    return Intl.message(
      'mobile app for Community',
      name: 'appDescription',
      desc: '',
      args: [],
    );
  }

  /// `RealTokens list`
  String get realTokensList {
    return Intl.message(
      'RealTokens list',
      name: 'realTokensList',
      desc: '',
      args: [],
    );
  }

  /// `Recent changes`
  String get recentChanges {
    return Intl.message(
      'Recent changes',
      name: 'recentChanges',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `About`
  String get about {
    return Intl.message(
      'About',
      name: 'about',
      desc: '',
      args: [],
    );
  }

  /// `Feedback`
  String get feedback {
    return Intl.message(
      'Feedback',
      name: 'feedback',
      desc: '',
      args: [],
    );
  }

  /// `Application`
  String get application {
    return Intl.message(
      'Application',
      name: 'application',
      desc: '',
      args: [],
    );
  }

  /// `Version`
  String get version {
    return Intl.message(
      'Version',
      name: 'version',
      desc: '',
      args: [],
    );
  }

  /// `Author`
  String get author {
    return Intl.message(
      'Author',
      name: 'author',
      desc: '',
      args: [],
    );
  }

  /// `Thanks`
  String get thanks {
    return Intl.message(
      'Thanks',
      name: 'thanks',
      desc: '',
      args: [],
    );
  }

  /// `Thank you to everyone who contributed to this project.`
  String get thankYouMessage {
    return Intl.message(
      'Thank you to everyone who contributed to this project.',
      name: 'thankYouMessage',
      desc: '',
      args: [],
    );
  }

  /// `Special thanks to @Sigri, @ehpst, and @pitsbi for their support.`
  String get specialThanks {
    return Intl.message(
      'Special thanks to @Sigri, @ehpst, and @pitsbi for their support.',
      name: 'specialThanks',
      desc: '',
      args: [],
    );
  }

  /// `Donate`
  String get donate {
    return Intl.message(
      'Donate',
      name: 'donate',
      desc: '',
      args: [],
    );
  }

  /// `Support the project`
  String get supportProject {
    return Intl.message(
      'Support the project',
      name: 'supportProject',
      desc: '',
      args: [],
    );
  }

  /// `If you like this app and want to support its development, you can donate.`
  String get donationMessage {
    return Intl.message(
      'If you like this app and want to support its development, you can donate.',
      name: 'donationMessage',
      desc: '',
      args: [],
    );
  }

  /// `PayPal`
  String get paypal {
    return Intl.message(
      'PayPal',
      name: 'paypal',
      desc: '',
      args: [],
    );
  }

  /// `Crypto`
  String get crypto {
    return Intl.message(
      'Crypto',
      name: 'crypto',
      desc: '',
      args: [],
    );
  }

  /// `Crypto Donation Address`
  String get cryptoDonationAddress {
    return Intl.message(
      'Crypto Donation Address',
      name: 'cryptoDonationAddress',
      desc: '',
      args: [],
    );
  }

  /// `Send your donations to the following address:`
  String get sendDonations {
    return Intl.message(
      'Send your donations to the following address:',
      name: 'sendDonations',
      desc: '',
      args: [],
    );
  }

  /// `Address copied to clipboard`
  String get addressCopied {
    return Intl.message(
      'Address copied to clipboard',
      name: 'addressCopied',
      desc: '',
      args: [],
    );
  }

  /// `Copy`
  String get copy {
    return Intl.message(
      'Copy',
      name: 'copy',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get close {
    return Intl.message(
      'Close',
      name: 'close',
      desc: '',
      args: [],
    );
  }

  /// `Week`
  String get week {
    return Intl.message(
      'Week',
      name: 'week',
      desc: '',
      args: [],
    );
  }

  /// `Rent Received Graph`
  String get rentGraph {
    return Intl.message(
      'Rent Received Graph',
      name: 'rentGraph',
      desc: '',
      args: [],
    );
  }

  /// `Token Distribution by Property Type`
  String get tokenDistribution {
    return Intl.message(
      'Token Distribution by Property Type',
      name: 'tokenDistribution',
      desc: '',
      args: [],
    );
  }

  /// `Single Family`
  String get singleFamily {
    return Intl.message(
      'Single Family',
      name: 'singleFamily',
      desc: '',
      args: [],
    );
  }

  /// `Multi Family`
  String get multiFamily {
    return Intl.message(
      'Multi Family',
      name: 'multiFamily',
      desc: '',
      args: [],
    );
  }

  /// `Duplex`
  String get duplex {
    return Intl.message(
      'Duplex',
      name: 'duplex',
      desc: '',
      args: [],
    );
  }

  /// `Condominium`
  String get condominium {
    return Intl.message(
      'Condominium',
      name: 'condominium',
      desc: '',
      args: [],
    );
  }

  /// `Mixed-Use`
  String get mixedUse {
    return Intl.message(
      'Mixed-Use',
      name: 'mixedUse',
      desc: '',
      args: [],
    );
  }

  /// `Commercial`
  String get commercial {
    return Intl.message(
      'Commercial',
      name: 'commercial',
      desc: '',
      args: [],
    );
  }

  /// `SFR Portfolio`
  String get sfrPortfolio {
    return Intl.message(
      'SFR Portfolio',
      name: 'sfrPortfolio',
      desc: '',
      args: [],
    );
  }

  /// `MFR Portfolio`
  String get mfrPortfolio {
    return Intl.message(
      'MFR Portfolio',
      name: 'mfrPortfolio',
      desc: '',
      args: [],
    );
  }

  /// `Resort Bungalow`
  String get resortBungalow {
    return Intl.message(
      'Resort Bungalow',
      name: 'resortBungalow',
      desc: '',
      args: [],
    );
  }

  /// `Unknown`
  String get unknown {
    return Intl.message(
      'Unknown',
      name: 'unknown',
      desc: '',
      args: [],
    );
  }

  /// `Search...`
  String get searchHint {
    return Intl.message(
      'Search...',
      name: 'searchHint',
      desc: '',
      args: [],
    );
  }

  /// `All Cities`
  String get allCities {
    return Intl.message(
      'All Cities',
      name: 'allCities',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get rentalStatusAll {
    return Intl.message(
      'All',
      name: 'rentalStatusAll',
      desc: '',
      args: [],
    );
  }

  /// `Rented`
  String get rentalStatusRented {
    return Intl.message(
      'Rented',
      name: 'rentalStatusRented',
      desc: '',
      args: [],
    );
  }

  /// `Partially Rented`
  String get rentalStatusPartiallyRented {
    return Intl.message(
      'Partially Rented',
      name: 'rentalStatusPartiallyRented',
      desc: '',
      args: [],
    );
  }

  /// `Not Rented`
  String get rentalStatusNotRented {
    return Intl.message(
      'Not Rented',
      name: 'rentalStatusNotRented',
      desc: '',
      args: [],
    );
  }

  /// `Sort by Name`
  String get sortByName {
    return Intl.message(
      'Sort by Name',
      name: 'sortByName',
      desc: '',
      args: [],
    );
  }

  /// `Sort by Value`
  String get sortByValue {
    return Intl.message(
      'Sort by Value',
      name: 'sortByValue',
      desc: '',
      args: [],
    );
  }

  /// `Sort by APY`
  String get sortByAPY {
    return Intl.message(
      'Sort by APY',
      name: 'sortByAPY',
      desc: '',
      args: [],
    );
  }

  /// `Sort by recently added`
  String get sortByInitialLaunchDate {
    return Intl.message(
      'Sort by recently added',
      name: 'sortByInitialLaunchDate',
      desc: '',
      args: [],
    );
  }

  /// `Ascending`
  String get ascending {
    return Intl.message(
      'Ascending',
      name: 'ascending',
      desc: '',
      args: [],
    );
  }

  /// `Descending`
  String get descending {
    return Intl.message(
      'Descending',
      name: 'descending',
      desc: '',
      args: [],
    );
  }

  /// `Token Distribution by City`
  String get tokenDistributionByCity {
    return Intl.message(
      'Token Distribution by City',
      name: 'tokenDistributionByCity',
      desc: '',
      args: [],
    );
  }

  /// `Token Distribution by Region`
  String get tokenDistributionByRegion {
    return Intl.message(
      'Token Distribution by Region',
      name: 'tokenDistributionByRegion',
      desc: '',
      args: [],
    );
  }

  /// `Token Distribution by Country`
  String get tokenDistributionByCountry {
    return Intl.message(
      'Token Distribution by Country',
      name: 'tokenDistributionByCountry',
      desc: '',
      args: [],
    );
  }

  /// `Clear Cache/Data`
  String get clearCacheData {
    return Intl.message(
      'Clear Cache/Data',
      name: 'clearCacheData',
      desc: '',
      args: [],
    );
  }

  /// `Dashboard`
  String get dashboard {
    return Intl.message(
      'Dashboard',
      name: 'dashboard',
      desc: '',
      args: [],
    );
  }

  /// `Statistics`
  String get statistics {
    return Intl.message(
      'Statistics',
      name: 'statistics',
      desc: '',
      args: [],
    );
  }

  /// `No data available, please add a new wallet`
  String get noDataAvailable {
    return Intl.message(
      'No data available, please add a new wallet',
      name: 'noDataAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Add wallet`
  String get manageAddresses {
    return Intl.message(
      'Add wallet',
      name: 'manageAddresses',
      desc: '',
      args: [],
    );
  }

  /// `Deposits`
  String get depositBalance {
    return Intl.message(
      'Deposits',
      name: 'depositBalance',
      desc: '',
      args: [],
    );
  }

  /// `Borrows`
  String get borrowBalance {
    return Intl.message(
      'Borrows',
      name: 'borrowBalance',
      desc: '',
      args: [],
    );
  }

  /// `USDC Deposit Balance`
  String get usdcDepositBalance {
    return Intl.message(
      'USDC Deposit Balance',
      name: 'usdcDepositBalance',
      desc: '',
      args: [],
    );
  }

  /// `USDC Borrow Balance`
  String get usdcBorrowBalance {
    return Intl.message(
      'USDC Borrow Balance',
      name: 'usdcBorrowBalance',
      desc: '',
      args: [],
    );
  }

  /// `XDAI Deposit Balance`
  String get xdaiDepositBalance {
    return Intl.message(
      'XDAI Deposit Balance',
      name: 'xdaiDepositBalance',
      desc: '',
      args: [],
    );
  }

  /// `XDAI Borrow Balance`
  String get xdaiBorrowBalance {
    return Intl.message(
      'XDAI Borrow Balance',
      name: 'xdaiBorrowBalance',
      desc: '',
      args: [],
    );
  }

  /// `Ethereum contract`
  String get ethereumContract {
    return Intl.message(
      'Ethereum contract',
      name: 'ethereumContract',
      desc: '',
      args: [],
    );
  }

  /// `Gnosis contract`
  String get gnosisContract {
    return Intl.message(
      'Gnosis contract',
      name: 'gnosisContract',
      desc: '',
      args: [],
    );
  }

  /// `View on map`
  String get viewOnMap {
    return Intl.message(
      'View on map',
      name: 'viewOnMap',
      desc: '',
      args: [],
    );
  }

  /// `Maps`
  String get maps {
    return Intl.message(
      'Maps',
      name: 'maps',
      desc: '',
      args: [],
    );
  }

  /// `Total of revenues`
  String get totalRentReceived {
    return Intl.message(
      'Total of revenues',
      name: 'totalRentReceived',
      desc: '',
      args: [],
    );
  }

  /// `Rents`
  String get groupedRentGraph {
    return Intl.message(
      'Rents',
      name: 'groupedRentGraph',
      desc: '',
      args: [],
    );
  }

  /// `Cumulative Rent Graph`
  String get cumulativeRentGraph {
    return Intl.message(
      'Cumulative Rent Graph',
      name: 'cumulativeRentGraph',
      desc: '',
      args: [],
    );
  }

  /// `Property ROI`
  String get roiPerProperties {
    return Intl.message(
      'Property ROI',
      name: 'roiPerProperties',
      desc: '',
      args: [],
    );
  }

  /// `This ROI feature is in beta and is currently calculated based on the income received from the property and the initial token value.`
  String get roiAlertInfo {
    return Intl.message(
      'This ROI feature is in beta and is currently calculated based on the income received from the property and the initial token value.',
      name: 'roiAlertInfo',
      desc: '',
      args: [],
    );
  }

  /// `Last 30 days`
  String get recentUpdatesTitle {
    return Intl.message(
      'Last 30 days',
      name: 'recentUpdatesTitle',
      desc: '',
      args: [],
    );
  }

  /// `No recent changes available.`
  String get noRecentUpdates {
    return Intl.message(
      'No recent changes available.',
      name: 'noRecentUpdates',
      desc: '',
      args: [],
    );
  }

  /// `Unknown name`
  String get unknownTokenName {
    return Intl.message(
      'Unknown name',
      name: 'unknownTokenName',
      desc: '',
      args: [],
    );
  }

  /// `Image link not available`
  String get noImageAvailable {
    return Intl.message(
      'Image link not available',
      name: 'noImageAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Duplicate properties`
  String get duplicate_title {
    return Intl.message(
      'Duplicate properties',
      name: 'duplicate_title',
      desc: '',
      args: [],
    );
  }

  /// `Properties present in multiple wallets/RMM`
  String get duplicate {
    return Intl.message(
      'Properties present in multiple wallets/RMM',
      name: 'duplicate',
      desc: '',
      args: [],
    );
  }

  /// `Future Rents`
  String get futureRents {
    return Intl.message(
      'Future Rents',
      name: 'futureRents',
      desc: '',
      args: [],
    );
  }

  /// `No future rents`
  String get noFutureRents {
    return Intl.message(
      'No future rents',
      name: 'noFutureRents',
      desc: '',
      args: [],
    );
  }

  /// `Next Rondays`
  String get nextRondays {
    return Intl.message(
      'Next Rondays',
      name: 'nextRondays',
      desc: '',
      args: [],
    );
  }

  /// `Date not provided`
  String get noCommunicatedDate {
    return Intl.message(
      'Date not provided',
      name: 'noCommunicatedDate',
      desc: '',
      args: [],
    );
  }

  /// `Services status`
  String get serviceStatusPage {
    return Intl.message(
      'Services status',
      name: 'serviceStatusPage',
      desc: '',
      args: [],
    );
  }

  /// `Last update`
  String get lastExecution {
    return Intl.message(
      'Last update',
      name: 'lastExecution',
      desc: '',
      args: [],
    );
  }

  /// `Everything is working correctly`
  String get allWorkCorrectly {
    return Intl.message(
      'Everything is working correctly',
      name: 'allWorkCorrectly',
      desc: '',
      args: [],
    );
  }

  /// `The data may not be up to date`
  String get somethingWrong {
    return Intl.message(
      'The data may not be up to date',
      name: 'somethingWrong',
      desc: '',
      args: [],
    );
  }

  /// `RealT`
  String get realTTitle {
    return Intl.message(
      'RealT',
      name: 'realTTitle',
      desc: '',
      args: [],
    );
  }

  /// `Net Annual Rent`
  String get netAnnualRent {
    return Intl.message(
      'Net Annual Rent',
      name: 'netAnnualRent',
      desc: '',
      args: [],
    );
  }

  /// `RealT Performance`
  String get realTPerformance {
    return Intl.message(
      'RealT Performance',
      name: 'realTPerformance',
      desc: '',
      args: [],
    );
  }

  /// `Text size`
  String get textSize {
    return Intl.message(
      'Text size',
      name: 'textSize',
      desc: '',
      args: [],
    );
  }

  /// `Convert sqft to m²`
  String get convertSqft {
    return Intl.message(
      'Convert sqft to m²',
      name: 'convertSqft',
      desc: '',
      args: [],
    );
  }

  /// `Rent not started`
  String get rentStartFuture {
    return Intl.message(
      'Rent not started',
      name: 'rentStartFuture',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Action`
  String get confirmAction {
    return Intl.message(
      'Confirm Action',
      name: 'confirmAction',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to clear cache and data?`
  String get areYouSureClearData {
    return Intl.message(
      'Are you sure you want to clear cache and data?',
      name: 'areYouSureClearData',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message(
      'Confirm',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `Export Data`
  String get exportData {
    return Intl.message(
      'Export Data',
      name: 'exportData',
      desc: '',
      args: [],
    );
  }

  /// `Import Data`
  String get importData {
    return Intl.message(
      'Import Data',
      name: 'importData',
      desc: '',
      args: [],
    );
  }

  /// `Data exported successfully`
  String get exportSuccess {
    return Intl.message(
      'Data exported successfully',
      name: 'exportSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Failed to export data`
  String get exportFailed {
    return Intl.message(
      'Failed to export data',
      name: 'exportFailed',
      desc: '',
      args: [],
    );
  }

  /// `Data imported successfully`
  String get importSuccess {
    return Intl.message(
      'Data imported successfully',
      name: 'importSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Failed to import data`
  String get importFailed {
    return Intl.message(
      'Failed to import data',
      name: 'importFailed',
      desc: '',
      args: [],
    );
  }

  /// `Import or export data (zip)`
  String get importExportData {
    return Intl.message(
      'Import or export data (zip)',
      name: 'importExportData',
      desc: '',
      args: [],
    );
  }

  /// `Import/Export Function`
  String get aboutImportExportTitle {
    return Intl.message(
      'Import/Export Function',
      name: 'aboutImportExportTitle',
      desc: '',
      args: [],
    );
  }

  /// `This function allows you to save and re-import balance history data (wallet and RMM) into a ZIP file.`
  String get aboutImportExport {
    return Intl.message(
      'This function allows you to save and re-import balance history data (wallet and RMM) into a ZIP file.',
      name: 'aboutImportExport',
      desc: '',
      args: [],
    );
  }

  /// `Wallet Balance History`
  String get walletBalanceHistory {
    return Intl.message(
      'Wallet Balance History',
      name: 'walletBalanceHistory',
      desc: '',
      args: [],
    );
  }

  /// `Hours`
  String get hours {
    return Intl.message(
      'Hours',
      name: 'hours',
      desc: '',
      args: [],
    );
  }

  /// `Days`
  String get days {
    return Intl.message(
      'Days',
      name: 'days',
      desc: '',
      args: [],
    );
  }

  /// `Weeks`
  String get weeks {
    return Intl.message(
      'Weeks',
      name: 'weeks',
      desc: '',
      args: [],
    );
  }

  /// `Period`
  String get period {
    return Intl.message(
      'Period',
      name: 'period',
      desc: '',
      args: [],
    );
  }

  /// `Miscellaneous Costs`
  String get miscellaneousCosts {
    return Intl.message(
      'Miscellaneous Costs',
      name: 'miscellaneousCosts',
      desc: '',
      args: [],
    );
  }

  /// `Renovation Reserve`
  String get renovationReserve {
    return Intl.message(
      'Renovation Reserve',
      name: 'renovationReserve',
      desc: '',
      args: [],
    );
  }

  /// `Realt Listing Fee`
  String get realtListingFee {
    return Intl.message(
      'Realt Listing Fee',
      name: 'realtListingFee',
      desc: '',
      args: [],
    );
  }

  /// `Total Expenses`
  String get totalExpenses {
    return Intl.message(
      'Total Expenses',
      name: 'totalExpenses',
      desc: '',
      args: [],
    );
  }

  /// `Property Maintenance (Monthly)`
  String get propertyMaintenanceMonthly {
    return Intl.message(
      'Property Maintenance (Monthly)',
      name: 'propertyMaintenanceMonthly',
      desc: 'Monthly maintenance expenses for the property',
      args: [],
    );
  }

  /// `Property Management`
  String get propertyManagement {
    return Intl.message(
      'Property Management',
      name: 'propertyManagement',
      desc: 'Fees for property management services',
      args: [],
    );
  }

  /// `RealT Platform`
  String get realtPlatform {
    return Intl.message(
      'RealT Platform',
      name: 'realtPlatform',
      desc: 'Fees for using the RealT platform',
      args: [],
    );
  }

  /// `Insurance`
  String get insurance {
    return Intl.message(
      'Insurance',
      name: 'insurance',
      desc: 'Insurance costs for the property',
      args: [],
    );
  }

  /// `Property Taxes`
  String get propertyTaxes {
    return Intl.message(
      'Property Taxes',
      name: 'propertyTaxes',
      desc: 'Taxes associated with the property',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message(
      'Edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `Balance`
  String get balance {
    return Intl.message(
      'Balance',
      name: 'balance',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Edit Wallet Balance History`
  String get editWalletBalance {
    return Intl.message(
      'Edit Wallet Balance History',
      name: 'editWalletBalance',
      desc: '',
      args: [],
    );
  }

  /// `Date`
  String get date {
    return Intl.message(
      'Date',
      name: 'date',
      desc: '',
      args: [],
    );
  }

  /// `Average purchase price removed`
  String get initialPriceRemoved {
    return Intl.message(
      'Average purchase price removed',
      name: 'initialPriceRemoved',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid number`
  String get enterValidNumber {
    return Intl.message(
      'Please enter a valid number',
      name: 'enterValidNumber',
      desc: '',
      args: [],
    );
  }

  /// `Average purchase price updated`
  String get initialPriceUpdated {
    return Intl.message(
      'Average purchase price updated',
      name: 'initialPriceUpdated',
      desc: '',
      args: [],
    );
  }

  /// `Average purchase price`
  String get initialPrice {
    return Intl.message(
      'Average purchase price',
      name: 'initialPrice',
      desc: '',
      args: [],
    );
  }

  /// `Manual Edit`
  String get manualEdit {
    return Intl.message(
      'Manual Edit',
      name: 'manualEdit',
      desc: '',
      args: [],
    );
  }

  /// `Property Type`
  String get propertyType {
    return Intl.message(
      'Property Type',
      name: 'propertyType',
      desc: '',
      args: [],
    );
  }

  /// `Section 8`
  String get section8paid {
    return Intl.message(
      'Section 8',
      name: 'section8paid',
      desc: '',
      args: [],
    );
  }

  /// `Properties for Sale`
  String get propertiesForSale {
    return Intl.message(
      'Properties for Sale',
      name: 'propertiesForSale',
      desc: '',
      args: [],
    );
  }

  /// `No properties for sale`
  String get noPropertiesForSale {
    return Intl.message(
      'No properties for sale',
      name: 'noPropertiesForSale',
      desc: '',
      args: [],
    );
  }

  /// `Net`
  String get net {
    return Intl.message(
      'Net',
      name: 'net',
      desc: '',
      args: [],
    );
  }

  /// `Gross`
  String get brute {
    return Intl.message(
      'Gross',
      name: 'brute',
      desc: '',
      args: [],
    );
  }

  /// `Unknown country`
  String get unknownCountry {
    return Intl.message(
      'Unknown country',
      name: 'unknownCountry',
      desc: '',
      args: [],
    );
  }

  /// `No market offers available`
  String get no_market_offers_available {
    return Intl.message(
      'No market offers available',
      name: 'no_market_offers_available',
      desc: '',
      args: [],
    );
  }

  /// `Offer ID`
  String get offer_id {
    return Intl.message(
      'Offer ID',
      name: 'offer_id',
      desc: '',
      args: [],
    );
  }

  /// `Token Amount`
  String get token_amount {
    return Intl.message(
      'Token Amount',
      name: 'token_amount',
      desc: '',
      args: [],
    );
  }

  /// `Token Value`
  String get token_value {
    return Intl.message(
      'Token Value',
      name: 'token_value',
      desc: '',
      args: [],
    );
  }

  /// `Delta Price`
  String get delta_price {
    return Intl.message(
      'Delta Price',
      name: 'delta_price',
      desc: '',
      args: [],
    );
  }

  /// `Creation Date`
  String get creation_date {
    return Intl.message(
      'Creation Date',
      name: 'creation_date',
      desc: '',
      args: [],
    );
  }

  /// `Buy`
  String get buy_token {
    return Intl.message(
      'Buy',
      name: 'buy_token',
      desc: '',
      args: [],
    );
  }

  /// `Sell`
  String get sell_token {
    return Intl.message(
      'Sell',
      name: 'sell_token',
      desc: '',
      args: [],
    );
  }

  /// `YAMM offers related to token`
  String get secondary_offers_related_to_token {
    return Intl.message(
      'YAMM offers related to token',
      name: 'secondary_offers_related_to_token',
      desc: '',
      args: [],
    );
  }

  /// `Error: {error}`
  String error_occurred(Object error) {
    return Intl.message(
      'Error: $error',
      name: 'error_occurred',
      desc: '',
      args: [error],
    );
  }

  /// `Properties For Sale`
  String get properties_for_sale {
    return Intl.message(
      'Properties For Sale',
      name: 'properties_for_sale',
      desc: '',
      args: [],
    );
  }

  /// `RealT`
  String get realt {
    return Intl.message(
      'RealT',
      name: 'realt',
      desc: '',
      args: [],
    );
  }

  /// `Secondary`
  String get secondary {
    return Intl.message(
      'Secondary',
      name: 'secondary',
      desc: '',
      args: [],
    );
  }

  /// `APY History`
  String get apyHistory {
    return Intl.message(
      'APY History',
      name: 'apyHistory',
      desc: '',
      args: [],
    );
  }

  /// `ROI History`
  String get roiHistory {
    return Intl.message(
      'ROI History',
      name: 'roiHistory',
      desc: '',
      args: [],
    );
  }

  /// `Bar Chart`
  String get barChart {
    return Intl.message(
      'Bar Chart',
      name: 'barChart',
      desc: '',
      args: [],
    );
  }

  /// `Line Chart`
  String get lineChart {
    return Intl.message(
      'Line Chart',
      name: 'lineChart',
      desc: '',
      args: [],
    );
  }

  /// `Rent Distribution`
  String get rentDistribution {
    return Intl.message(
      'Rent Distribution',
      name: 'rentDistribution',
      desc: '',
      args: [],
    );
  }

  /// `Country`
  String get country {
    return Intl.message(
      'Country',
      name: 'country',
      desc: '',
      args: [],
    );
  }

  /// `Region`
  String get region {
    return Intl.message(
      'Region',
      name: 'region',
      desc: '',
      args: [],
    );
  }

  /// `City`
  String get city {
    return Intl.message(
      'City',
      name: 'city',
      desc: '',
      args: [],
    );
  }

  /// `Bedroom/Bath`
  String get bedroomBath {
    return Intl.message(
      'Bedroom/Bath',
      name: 'bedroomBath',
      desc: 'Label for bedroom and bath information',
      args: [],
    );
  }

  /// `The net yield is calculated by weighting the yields of the portfolios (wallet/RMM) and the deposit/borrow balances with their respective rates.`
  String get netApyHelp {
    return Intl.message(
      'The net yield is calculated by weighting the yields of the portfolios (wallet/RMM) and the deposit/borrow balances with their respective rates.',
      name: 'netApyHelp',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'es'),
      Locale.fromSubtags(languageCode: 'fr'),
      Locale.fromSubtags(languageCode: 'it'),
      Locale.fromSubtags(languageCode: 'pt'),
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
