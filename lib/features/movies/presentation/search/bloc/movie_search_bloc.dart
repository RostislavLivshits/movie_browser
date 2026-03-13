import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:hive_ce/hive.dart';
import '../../../data/repositories/movie_repository.dart';
import 'movie_search_event.dart';
import 'movie_search_state.dart';

// Event transformer for debouncing search requests (approx. 500 ms)
EventTransformer<E> debounce<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(
      events,
      mapper,
    ); // In a real scenario with rxdart you'd use debounceTime, but droppable or restartable is often used for search.
    // Note: For a true 500ms debounce without rxdart, we will use a manual delay inside the handler.
  };
}

class MovieSearchBloc extends Bloc<MovieSearchEvent, MovieSearchState> {
  final MovieRepository repository;
  final Box<String> historyBox;
  int _currentPage = 1;

  MovieSearchBloc({required this.repository, required this.historyBox})
    : super(const MovieSearchState()) {
    // Restartable ensures only the latest search query is processed
    on<SearchQueryChanged>(_onSearchQueryChanged, transformer: restartable());
    on<LoadNextPage>(_onLoadNextPage, transformer: droppable());
    on<LoadSearchHistory>(_onLoadSearchHistory);
    on<RemoveHistoryItem>(_onRemoveHistoryItem);
    on<ClearHistory>(_onClearHistory);

    // Load history on initialization
    add(LoadSearchHistory());
  }

  Future<void> _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<MovieSearchState> emit,
  ) async {
    final query = event.query.trim();
    if (query.isEmpty) {
      return emit(
        state.copyWith(
          status: SearchStatus.initial,
          movies: [],
          query: '',
          hasReachedMax: false,
        ),
      );
    }

    // Debounce implementation: wait 500ms before making the API call
    await Future.delayed(const Duration(milliseconds: 500));

    emit(state.copyWith(status: SearchStatus.loading, query: query));

    try {
      _currentPage = 1;
      final movies = await repository.searchMovies(query, _currentPage);

      // Save to history
      if (!state.searchHistory.contains(query)) {
        await historyBox.add(query);
        add(LoadSearchHistory());
      }

      emit(
        state.copyWith(
          status: SearchStatus.success,
          movies: movies,
          hasReachedMax: movies
              .isEmpty, // OMDb returns a specific format, simplify for now
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: SearchStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onLoadNextPage(
    LoadNextPage event,
    Emitter<MovieSearchState> emit,
  ) async {
    // Safety checks as per requirements
    if (state.hasReachedMax || state.status != SearchStatus.success) return;

    try {
      _currentPage++;
      final movies = await repository.searchMovies(state.query, _currentPage);

      if (movies.isEmpty) {
        emit(state.copyWith(hasReachedMax: true));
      } else {
        emit(
          state.copyWith(
            status: SearchStatus.success,
            movies: List.of(state.movies)..addAll(movies),
            hasReachedMax: false,
          ),
        );
      }
    } catch (e) {
      // OMDb API returns "Movie not found!" when requested page exceeds total results
      if (e.toString().contains('Movie not found')) {
        emit(state.copyWith(hasReachedMax: true));
      } else {
        // Emit failure only if it's a real network/API issue
        emit(
          state.copyWith(
            status: SearchStatus.failure,
            errorMessage: e.toString(),
          ),
        );
      }
    }
  }

  void _onLoadSearchHistory(
    LoadSearchHistory event,
    Emitter<MovieSearchState> emit,
  ) {
    final history = historyBox.values.toList().reversed.toList();
    emit(state.copyWith(searchHistory: history));
  }

  Future<void> _onRemoveHistoryItem(
    RemoveHistoryItem event,
    Emitter<MovieSearchState> emit,
  ) async {
    final keyToRemove = historyBox.keys.firstWhere(
      (k) => historyBox.get(k) == event.query,
      orElse: () => null,
    );
    if (keyToRemove != null) {
      await historyBox.delete(keyToRemove);
      add(LoadSearchHistory());
    }
  }

  Future<void> _onClearHistory(
    ClearHistory event,
    Emitter<MovieSearchState> emit,
  ) async {
    await historyBox.clear();
    add(LoadSearchHistory());
  }
}
