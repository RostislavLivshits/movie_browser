import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/movie_repository.dart';
import 'movie_details_event.dart';
import 'movie_details_state.dart';

class MovieDetailsBloc extends Bloc<MovieDetailsEvent, MovieDetailsState> {
  final MovieRepository repository;

  MovieDetailsBloc({required this.repository}) : super(const MovieDetailsState()) {
    on<LoadMovieDetails>(_onLoadMovieDetails);
  }

  Future<void> _onLoadMovieDetails(
      LoadMovieDetails event,
      Emitter<MovieDetailsState> emit,
      ) async {
    emit(state.copyWith(status: MovieDetailsStatus.loading));
    try {
      // Attempt to load details from API, or fallback to cache if offline
      final result = await repository.getMovieDetails(event.imdbID);

      emit(state.copyWith(
        status: MovieDetailsStatus.success,
        details: result.details,
        isFromCache: result.isFromCache,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: MovieDetailsStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}