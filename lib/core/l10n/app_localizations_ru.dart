// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Кинобраузер';

  @override
  String get searchHint => 'Поиск фильмов...';

  @override
  String get favorites => 'Избранное';

  @override
  String get searchHistory => 'История поиска';

  @override
  String get clearAll => 'Очистить всё';

  @override
  String get noResults => 'Ничего не найдено';

  @override
  String get networkError => 'Ошибка сети';

  @override
  String get apiError => 'Ошибка API';

  @override
  String get cachedDataBanner => 'Показаны кэшированные данные';

  @override
  String get remove => 'Удалить';

  @override
  String get plot => 'Сюжет';

  @override
  String get genre => 'Жанр';

  @override
  String get director => 'Режиссер';

  @override
  String get actors => 'Актеры';

  @override
  String get rating => 'Рейтинг';
}
