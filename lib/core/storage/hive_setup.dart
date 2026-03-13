import 'package:hive_ce_flutter/hive_flutter.dart';
import '../../features/movies/data/models/movie_model.dart';
import '../../features/movies/data/models/movie_details_model.dart';

Future<void> initHive() async {
  await Hive.initFlutter();

  Hive.registerAdapter(MovieModelAdapter());
  Hive.registerAdapter(MovieDetailsModelAdapter());

  await Hive.openBox<String>('search_history');
  await Hive.openBox<MovieModel>('favorites');
  await Hive.openBox<MovieDetailsModel>('cached_movie_details');
}
