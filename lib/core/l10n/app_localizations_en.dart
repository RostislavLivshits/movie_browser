// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Movie Browser';

  @override
  String get searchHint => 'Search movies...';

  @override
  String get favorites => 'Favorites';

  @override
  String get searchHistory => 'Search History';

  @override
  String get clearAll => 'Clear All';

  @override
  String get noResults => 'No results found';

  @override
  String get networkError => 'Network connection error';

  @override
  String get apiError => 'API Error';

  @override
  String get cachedDataBanner => 'Showing cached data';

  @override
  String get remove => 'Remove';

  @override
  String get plot => 'Plot';

  @override
  String get genre => 'Genre';

  @override
  String get director => 'Director';

  @override
  String get actors => 'Actors';

  @override
  String get rating => 'Rating';
}
