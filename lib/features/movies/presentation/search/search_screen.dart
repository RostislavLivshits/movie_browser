import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_browser/core/l10n/app_localizations.dart';
import 'bloc/movie_search_bloc.dart';
import 'bloc/movie_search_event.dart';
import 'bloc/movie_search_state.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              // TODO: Navigate to Favorites Screen
            },
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: l10n.searchHint,
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
              ),
              onChanged: (query) {
                // Trigger debounced search
                context.read<MovieSearchBloc>().add(SearchQueryChanged(query));
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<MovieSearchBloc, MovieSearchState>(
              builder: (context, state) {
                if (state.status == SearchStatus.loading && state.movies.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.status == SearchStatus.failure) {
                  return Center(child: Text(state.errorMessage.isNotEmpty ? state.errorMessage : l10n.apiError));
                } else if (state.status == SearchStatus.success && state.movies.isEmpty) {
                  return Center(child: Text(l10n.noResults));
                } else if (state.movies.isNotEmpty) {
                  // Basic list representation. We will add pagination and cards later.
                  return ListView.builder(
                    itemCount: state.movies.length,
                    itemBuilder: (context, index) {
                      final movie = state.movies[index];
                      return ListTile(
                        title: Text(movie.title),
                        subtitle: Text(movie.year),
                        leading: const Icon(Icons.movie),
                      );
                    },
                  );
                } else {
                  // Initial state: show search history
                  return _buildHistory(context, state, l10n);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistory(BuildContext context, MovieSearchState state, AppLocalizations l10n) {
    if (state.searchHistory.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.searchHistory,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              TextButton(
                onPressed: () => context.read<MovieSearchBloc>().add(ClearHistory()),
                child: Text(l10n.clearAll),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: state.searchHistory.length,
            itemBuilder: (context, index) {
              final query = state.searchHistory[index];
              return ListTile(
                leading: const Icon(Icons.history),
                title: Text(query),
                trailing: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => context.read<MovieSearchBloc>().add(RemoveHistoryItem(query)),
                ),
                onTap: () {
                  // Optional UX improvement: trigger search from history tap
                  context.read<MovieSearchBloc>().add(SearchQueryChanged(query));
                },
              );
            },
          ),
        ),
      ],
    );
  }
}