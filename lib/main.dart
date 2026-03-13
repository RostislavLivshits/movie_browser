import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:dio/dio.dart';

import 'core/l10n/app_localizations.dart';
import 'core/storage/hive_setup.dart';
import 'features/movies/data/repositories/movie_repository.dart';
import 'features/movies/datasources/remote_data_source.dart';
import 'features/movies/presentation/search/bloc/movie_search_bloc.dart';
import 'features/movies/presentation/favorites/bloc/favorites_bloc.dart';
import 'features/movies/presentation/favorites/bloc/favorites_event.dart';
import 'features/movies/data/models/movie_model.dart';
import 'features/movies/data/models/movie_details_model.dart';
import 'features/movies/presentation/search/search_screen.dart';

void main() async {
  // Required for async operations before runApp
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize local storage
  await initHive();

  // Dependency Injection (Pragmatic approach without excessive abstractions)
  final dio = Dio();
  final remoteDataSource = MovieRemoteDataSource(dio: dio);

  final repository = MovieRepository(
    remoteDataSource: remoteDataSource,
    cachedDetailsBox: Hive.box<MovieDetailsModel>('cached_movie_details'),
    favoritesBox: Hive.box<MovieModel>('favorites'),
  );

  runApp(MyApp(repository: repository));
}

class MyApp extends StatelessWidget {
  final MovieRepository repository;

  const MyApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    // Wrap with RepositoryProvider to make repository accessible in new screens
    return RepositoryProvider.value(
      value: repository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => MovieSearchBloc(
              repository: repository,
              historyBox: Hive.box<String>('search_history'),
            ),
          ),
          BlocProvider(
            create: (context) => FavoritesBloc(
              repository: repository,
            )..add(LoadFavorites()),
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const SearchScreen(),
        ),
      ),
    );
  }
}