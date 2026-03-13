import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hive_ce/hive.dart';
import 'package:movie_browser/features/movies/data/models/movie_model.dart';
import 'package:movie_browser/features/movies/data/repositories/movie_repository.dart';
import 'package:movie_browser/features/movies/presentation/search/bloc/movie_search_bloc.dart';
import 'package:movie_browser/features/movies/presentation/search/bloc/movie_search_event.dart';
import 'package:movie_browser/features/movies/presentation/search/bloc/movie_search_state.dart';

class MockMovieRepository extends Mock implements MovieRepository {}
class MockHistoryBox extends Mock implements Box<String> {}

void main() {
  late MovieSearchBloc bloc;
  late MockMovieRepository mockRepository;
  late MockHistoryBox mockHistoryBox;

  setUp(() {
    mockRepository = MockMovieRepository();
    mockHistoryBox = MockHistoryBox();

    // Stub history box methods used during BLoC initialization
    when(() => mockHistoryBox.values).thenReturn([]);

    bloc = MovieSearchBloc(
      repository: mockRepository,
      historyBox: mockHistoryBox,
    );
  });

  tearDown(() {
    bloc.close();
  });

  const tMovie = MovieModel(
    imdbID: 'tt123',
    title: 'Batman',
    year: '2000',
    type: 'movie',
    poster: 'N/A',
  );

  group('MovieSearchBloc', () {

    blocTest<MovieSearchBloc, MovieSearchState>(
      'successful search emits loading then success',
      build: () {
        when(() => mockRepository.searchMovies('Batman', 1))
            .thenAnswer((_) async => [tMovie]);
        when(() => mockHistoryBox.add('Batman'))
            .thenAnswer((_) async => 1);
        when(() => mockHistoryBox.values)
            .thenReturn(['Batman']);

        return bloc;
      },
      act: (bloc) => bloc.add(const SearchQueryChanged('Batman')),
      // Wait for debounce duration
      wait: const Duration(milliseconds: 500),
      expect: () => [
        const MovieSearchState(status: SearchStatus.loading, query: 'Batman'),
        // Intermediate state emitted right after search, before history is reloaded
        const MovieSearchState(
          status: SearchStatus.success,
          query: 'Batman',
          movies: [tMovie],
          hasReachedMax: false,
          searchHistory: [],
        ),
        // Final state emitted after LoadSearchHistory event is processed
        const MovieSearchState(
          status: SearchStatus.success,
          query: 'Batman',
          movies: [tMovie],
          hasReachedMax: false,
          searchHistory: ['Batman'],
        ),
      ],
    );

    blocTest<MovieSearchBloc, MovieSearchState>(
      'pagination appends results correctly',
      build: () {
        when(() => mockRepository.searchMovies('Batman', 2))
            .thenAnswer((_) async => [tMovie]); // New page returns one more movie
        return bloc;
      },
      // Seed the initial state with one movie already loaded
      seed: () => const MovieSearchState(
        status: SearchStatus.success,
        query: 'Batman',
        movies: [tMovie],
      ),
      act: (bloc) => bloc.add(LoadNextPage()),
      expect: () => [
        const MovieSearchState(
          status: SearchStatus.success,
          query: 'Batman',
          movies: [tMovie, tMovie], // Results should be appended
          hasReachedMax: false,
        ),
      ],
    );

    blocTest<MovieSearchBloc, MovieSearchState>(
      'error emits failure state',
      build: () {
        when(() => mockRepository.searchMovies('Batman', 1))
            .thenThrow(Exception('API Error'));
        return bloc;
      },
      act: (bloc) => bloc.add(const SearchQueryChanged('Batman')),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        const MovieSearchState(status: SearchStatus.loading, query: 'Batman'),
        const MovieSearchState(
          status: SearchStatus.failure,
          query: 'Batman',
          errorMessage: 'Exception: API Error',
        ),
      ],
    );
  });
}