import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hive_ce/hive.dart';
import 'package:movie_browser/features/movies/data/models/movie_details_model.dart';
import 'package:movie_browser/features/movies/data/models/movie_model.dart';
import 'package:movie_browser/features/movies/data/repositories/movie_repository.dart';
import 'package:movie_browser/features/movies/datasources/remote_data_source.dart';

// 1. Create Mock classes using mocktail
class MockMovieRemoteDataSource extends Mock implements MovieRemoteDataSource {}
class MockCachedDetailsBox extends Mock implements Box<MovieDetailsModel> {}
class MockFavoritesBox extends Mock implements Box<MovieModel> {}

void main() {
  late MovieRepository repository;
  late MockMovieRemoteDataSource mockRemoteDataSource;
  late MockCachedDetailsBox mockCachedDetailsBox;
  late MockFavoritesBox mockFavoritesBox;

  // 2. Setup initial state before each test
  setUp(() {
    mockRemoteDataSource = MockMovieRemoteDataSource();
    mockCachedDetailsBox = MockCachedDetailsBox();
    mockFavoritesBox = MockFavoritesBox();

    repository = MovieRepository(
      remoteDataSource: mockRemoteDataSource,
      cachedDetailsBox: mockCachedDetailsBox,
      favoritesBox: mockFavoritesBox,
    );
  });

  const tImdbID = 'tt1234567';
  const tMovieDetails = MovieDetailsModel(
    imdbID: tImdbID,
    title: 'Test Movie',
    year: '2023',
    genre: 'Action',
    director: 'Test Director',
    actors: 'Actor 1, Actor 2',
    plot: 'Test plot...',
    imdbRating: '8.0',
    poster: 'N/A',
  );

  group('getMovieDetails (Offline Fallback)', () {

    test('remote success caches data and returns isFromCache: false', () async {
      // Arrange
      when(() => mockRemoteDataSource.getMovieDetails(tImdbID))
          .thenAnswer((_) async => tMovieDetails);
      when(() => mockCachedDetailsBox.put(tImdbID, tMovieDetails))
          .thenAnswer((_) async => {});

      // Act
      final result = await repository.getMovieDetails(tImdbID);

      // Assert
      expect(result.details, tMovieDetails);
      expect(result.isFromCache, false);
      verify(() => mockRemoteDataSource.getMovieDetails(tImdbID)).called(1);
      verify(() => mockCachedDetailsBox.put(tImdbID, tMovieDetails)).called(1);
    });

    test('remote failure returns cached data if available (isFromCache: true)', () async {
      // Arrange
      when(() => mockRemoteDataSource.getMovieDetails(tImdbID))
          .thenThrow(Exception('Network error'));
      when(() => mockCachedDetailsBox.get(tImdbID))
          .thenReturn(tMovieDetails);

      // Act
      final result = await repository.getMovieDetails(tImdbID);

      // Assert
      expect(result.details, tMovieDetails);
      expect(result.isFromCache, true);
      verify(() => mockRemoteDataSource.getMovieDetails(tImdbID)).called(1);
      verify(() => mockCachedDetailsBox.get(tImdbID)).called(1);
    });

    test('remote failure without cache throws error', () async {
      // Arrange
      when(() => mockRemoteDataSource.getMovieDetails(tImdbID))
          .thenThrow(Exception('Network error'));
      when(() => mockCachedDetailsBox.get(tImdbID))
          .thenReturn(null);

      // Act & Assert
      expect(
            () => repository.getMovieDetails(tImdbID),
        throwsA(isA<Exception>()),
      );
      verify(() => mockRemoteDataSource.getMovieDetails(tImdbID)).called(1);
      verify(() => mockCachedDetailsBox.get(tImdbID)).called(1);
    });
  });
}