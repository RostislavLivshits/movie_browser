import 'package:hive_ce/hive.dart';
import '../../datasources/remote_data_source.dart';
import '../models/movie_model.dart';
import '../models/movie_details_model.dart';
import '../../domain/entities/movie_details_result.dart';

class MovieRepository {
  final MovieRemoteDataSource remoteDataSource;
  final Box<MovieDetailsModel> cachedDetailsBox;
  final Box<MovieModel> favoritesBox;

  MovieRepository({
    required this.remoteDataSource,
    required this.cachedDetailsBox,
    required this.favoritesBox,
  });

  Future<List<MovieModel>> searchMovies(String query, int page) async {
    return await remoteDataSource.searchMovies(query, page);
  }

  // Implementation of offline fallback behavior
  Future<MovieDetailsResult> getMovieDetails(String imdbID) async {
    try {
      // 1. Attempt remote request
      final remoteDetails = await remoteDataSource.getMovieDetails(imdbID);

      // 2. If successful -> cache response locally
      await cachedDetailsBox.put(imdbID, remoteDetails);

      return MovieDetailsResult(details: remoteDetails, isFromCache: false);
    } catch (e) {
      // 3. If remote fails -> try reading cached data
      final cachedDetails = cachedDetailsBox.get(imdbID);

      if (cachedDetails != null) {
        // 4. If cached data exists -> return cached result
        return MovieDetailsResult(details: cachedDetails, isFromCache: true);
      } else {
        // 5. Otherwise throw an error
        rethrow;
      }
    }
  }

  // Favorites management
  List<MovieModel> getFavorites() {
    return favoritesBox.values.toList();
  }

  Future<void> toggleFavorite(MovieModel movie) async {
    if (favoritesBox.containsKey(movie.imdbID)) {
      await favoritesBox.delete(movie.imdbID);
    } else {
      await favoritesBox.put(movie.imdbID, movie);
    }
  }

  bool isFavorite(String imdbID) {
    return favoritesBox.containsKey(imdbID);
  }
}