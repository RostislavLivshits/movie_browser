import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_browser/features/movies/data/models/movie_model.dart';
import 'package:movie_browser/features/movies/data/repositories/movie_repository.dart';
import 'package:movie_browser/features/movies/presentation/favorites/bloc/favorites_bloc.dart';
import 'package:movie_browser/features/movies/presentation/favorites/bloc/favorites_event.dart';
import 'package:movie_browser/features/movies/presentation/favorites/bloc/favorites_state.dart';

class MockMovieRepository extends Mock implements MovieRepository {}

void main() {
  late FavoritesBloc bloc;
  late MockMovieRepository mockRepository;

  setUp(() {
    mockRepository = MockMovieRepository();
    bloc = FavoritesBloc(repository: mockRepository);
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

  group('FavoritesBloc', () {

    blocTest<FavoritesBloc, FavoritesState>(
      'loading favorites emits success with movies',
      build: () {
        when(() => mockRepository.getFavorites()).thenReturn([tMovie]);
        return bloc;
      },
      act: (bloc) => bloc.add(LoadFavorites()),
      expect: () => [
        const FavoritesState(status: FavoritesStatus.loading),
        const FavoritesState(status: FavoritesStatus.success, favorites: [tMovie]),
      ],
    );

    blocTest<FavoritesBloc, FavoritesState>(
      'removing favorite updates state',
      build: () {
        // Stub toggle to do nothing
        when(() => mockRepository.toggleFavorite(tMovie)).thenAnswer((_) async {});
        // After toggling, LoadFavorites is called, which gets the updated list (empty)
        when(() => mockRepository.getFavorites()).thenReturn([]);
        return bloc;
      },
      // Seed state with the movie already in favorites
      seed: () => const FavoritesState(
        status: FavoritesStatus.success,
        favorites: [tMovie],
      ),
      act: (bloc) => bloc.add(const ToggleFavorite(tMovie)),
      expect: () => [
        // LoadFavorites is dispatched inside _onToggleFavorite
        // It first emits loading (preserving the current favorites list)
        const FavoritesState(status: FavoritesStatus.loading, favorites: [tMovie]),
        // Then emits success with the new empty list
        const FavoritesState(status: FavoritesStatus.success, favorites: []),
      ],
    );
  });
}