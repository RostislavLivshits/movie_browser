import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/movie_repository.dart';
import 'favorites_event.dart';
import 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final MovieRepository repository;

  FavoritesBloc({required this.repository}) : super(const FavoritesState()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<ToggleFavorite>(_onToggleFavorite);
  }

  void _onLoadFavorites(LoadFavorites event, Emitter<FavoritesState> emit) {
    emit(state.copyWith(status: FavoritesStatus.loading));
    try {
      // Load favorite movies from local Hive storage
      final favorites = repository.getFavorites();
      emit(
        state.copyWith(status: FavoritesStatus.success, favorites: favorites),
      );
    } catch (e) {
      emit(state.copyWith(status: FavoritesStatus.failure));
    }
  }

  Future<void> _onToggleFavorite(
    ToggleFavorite event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      // Add or remove a movie from favorites in local storage
      await repository.toggleFavorite(event.movie);

      // Reload the list to update the UI
      add(LoadFavorites());
    } catch (e) {
      emit(state.copyWith(status: FavoritesStatus.failure));
    }
  }
}
