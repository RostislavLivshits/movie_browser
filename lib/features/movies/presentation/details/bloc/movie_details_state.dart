import 'package:equatable/equatable.dart';

import '../../../data/models/movie_details_model.dart';

enum MovieDetailsStatus { initial, loading, success, failure }

class MovieDetailsState extends Equatable {
  final MovieDetailsStatus status;
  final MovieDetailsModel? details;
  final bool isFromCache;
  final String errorMessage;

  const MovieDetailsState({
    this.status = MovieDetailsStatus.initial,
    this.details,
    this.isFromCache = false,
    this.errorMessage = '',
  });

  MovieDetailsState copyWith({
    MovieDetailsStatus? status,
    MovieDetailsModel? details,
    bool? isFromCache,
    String? errorMessage,
  }) {
    return MovieDetailsState(
      status: status ?? this.status,
      details: details ?? this.details,
      isFromCache: isFromCache ?? this.isFromCache,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, details, isFromCache, errorMessage];
}
