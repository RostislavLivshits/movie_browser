import '../../data/models/movie_details_model.dart';

class MovieDetailsResult {
  final MovieDetailsModel details;
  final bool isFromCache;

  MovieDetailsResult({required this.details, required this.isFromCache});
}
