import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../data/models/movie_model.dart';
import '../../data/repositories/movie_repository.dart';
import '../favorites/bloc/favorites_bloc.dart';
import '../favorites/bloc/favorites_event.dart';
import '../favorites/bloc/favorites_state.dart';
import 'bloc/movie_details_bloc.dart';
import 'bloc/movie_details_event.dart';
import 'bloc/movie_details_state.dart';

class DetailsScreen extends StatelessWidget {
  final MovieModel movie;

  const DetailsScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    // Provide MovieDetailsBloc scoped to this screen
    return BlocProvider(
      create: (context) =>
          MovieDetailsBloc(repository: context.read<MovieRepository>())
            ..add(LoadMovieDetails(movie.imdbID)),
      child: _DetailsView(movie: movie),
    );
  }
}

class _DetailsView extends StatelessWidget {
  final MovieModel movie;

  const _DetailsView({required this.movie});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
        actions: [
          // Favorites toggle button
          BlocBuilder<FavoritesBloc, FavoritesState>(
            builder: (context, state) {
              final isFavorite = state.favorites.any(
                (m) => m.imdbID == movie.imdbID,
              );
              return IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : null,
                ),
                onPressed: () {
                  context.read<FavoritesBloc>().add(ToggleFavorite(movie));
                },
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<MovieDetailsBloc, MovieDetailsState>(
          builder: (context, state) {
            if (state.status == MovieDetailsStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.status == MovieDetailsStatus.failure) {
              return Center(
                child: Text(
                  state.errorMessage.isNotEmpty
                      ? state.errorMessage
                      : l10n.apiError,
                ),
              );
            } else if (state.status == MovieDetailsStatus.success &&
                state.details != null) {
              final details = state.details!;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Offline cache banner requirement
                    if (state.isFromCache)
                      Container(
                        width: double.infinity,
                        color: Colors.orangeAccent,
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          l10n.cachedDataBanner,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    // Movie Poster
                    if (details.poster != 'N/A' && details.poster.isNotEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              details.poster,
                              height: 300,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.broken_image, size: 100),
                            ),
                          ),
                        ),
                      ),
                    // Movie Details Data
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${details.title} (${details.year})',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${l10n.rating}: ${details.imdbRating}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          Text('${l10n.genre}: ${details.genre}'),
                          const SizedBox(height: 8),
                          Text('${l10n.director}: ${details.director}'),
                          const SizedBox(height: 8),
                          Text('${l10n.actors}: ${details.actors}'),
                          const SizedBox(height: 16),
                          Text(
                            l10n.plot,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            details.plot,
                            style: const TextStyle(fontSize: 16, height: 1.4),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
