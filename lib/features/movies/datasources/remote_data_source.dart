import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../data/models/movie_details_model.dart';
import '../data/models/movie_model.dart';

class MovieRemoteDataSource {
  final Dio dio;

  MovieRemoteDataSource({required this.dio});

  Future<List<MovieModel>> searchMovies(String query, int page) async {
    final response = await dio.get(
      'https://www.omdbapi.com/',
      queryParameters: {
        'apikey': apiKey,
        's': query,
        'page': page,
      },
    );

    if (response.data['Response'] == 'False') {
      throw Exception(response.data['Error'] ?? 'API Error');
    }

    final List<dynamic> results = response.data['Search'] ?? [];
    return results.map((json) => MovieModel.fromJson(json)).toList();
  }

  Future<MovieDetailsModel> getMovieDetails(String imdbID) async {
    final response = await dio.get(
      'https://www.omdbapi.com/',
      queryParameters: {
        'apikey': apiKey,
        'i': imdbID,
      },
    );

    if (response.data['Response'] == 'False') {
      throw Exception(response.data['Error'] ?? 'API Error');
    }

    return MovieDetailsModel.fromJson(response.data);
  }
}