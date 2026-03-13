import 'package:equatable/equatable.dart';

import '../../../data/models/movie_model.dart';

enum FavoritesStatus { initial, loading, success, failure }

class FavoritesState extends Equatable {
  final FavoritesStatus status;
  final List<MovieModel> favorites;

  const FavoritesState({
    this.status = FavoritesStatus.initial,
    this.favorites = const <MovieModel>[],
  });

  FavoritesState copyWith({
    FavoritesStatus? status,
    List<MovieModel>? favorites,
  }) {
    return FavoritesState(
      status: status ?? this.status,
      favorites: favorites ?? this.favorites,
    );
  }

  @override
  List<Object> get props => [status, favorites];
}
