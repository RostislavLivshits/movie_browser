import 'package:equatable/equatable.dart';

import '../../../data/models/movie_model.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object> get props => [];
}

class LoadFavorites extends FavoritesEvent {}

class ToggleFavorite extends FavoritesEvent {
  final MovieModel movie;

  const ToggleFavorite(this.movie);

  @override
  List<Object> get props => [movie];
}
