import 'package:equatable/equatable.dart';

import '../../../data/models/movie_model.dart';

enum SearchStatus { initial, loading, success, failure }

class MovieSearchState extends Equatable {
  final SearchStatus status;
  final List<MovieModel> movies;
  final bool hasReachedMax;
  final String errorMessage;
  final String query;
  final List<String> searchHistory;

  const MovieSearchState({
    this.status = SearchStatus.initial,
    this.movies = const <MovieModel>[],
    this.hasReachedMax = false,
    this.errorMessage = '',
    this.query = '',
    this.searchHistory = const <String>[],
  });

  MovieSearchState copyWith({
    SearchStatus? status,
    List<MovieModel>? movies,
    bool? hasReachedMax,
    String? errorMessage,
    String? query,
    List<String>? searchHistory,
  }) {
    return MovieSearchState(
      status: status ?? this.status,
      movies: movies ?? this.movies,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      errorMessage: errorMessage ?? this.errorMessage,
      query: query ?? this.query,
      searchHistory: searchHistory ?? this.searchHistory,
    );
  }

  @override
  List<Object> get props => [
    status,
    movies,
    hasReachedMax,
    errorMessage,
    query,
    searchHistory,
  ];
}
