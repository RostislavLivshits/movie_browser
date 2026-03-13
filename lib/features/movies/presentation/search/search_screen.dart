import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../details/details_screen.dart';
import '../favorites/favorites_screen.dart';
import 'bloc/movie_search_bloc.dart';
import 'bloc/movie_search_event.dart';
import 'bloc/movie_search_state.dart';
import 'widgets/movie_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<MovieSearchBloc>().add(LoadNextPage());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9); // Load more when 90% scrolled
  }

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
              // Navigate to Favorites Screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavoritesScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: l10n.searchHint,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (query) {
                context.read<MovieSearchBloc>().add(SearchQueryChanged(query));
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<MovieSearchBloc, MovieSearchState>(
              builder: (context, state) {
                if (state.status == SearchStatus.loading &&
                    state.movies.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.status == SearchStatus.failure &&
                    state.movies.isEmpty) {
                  // Show error text ONLY if we don't have any cached/loaded movies
                  return Center(
                    child: Text(
                      state.errorMessage.isNotEmpty
                          ? state.errorMessage
                          : l10n.apiError,
                    ),
                  );
                } else if (state.status == SearchStatus.failure) {
                  return Center(
                    child: Text(
                      state.errorMessage.isNotEmpty
                          ? state.errorMessage
                          : l10n.apiError,
                    ),
                  );
                } else if (state.status == SearchStatus.success &&
                    state.movies.isEmpty) {
                  return Center(child: Text(l10n.noResults));
                } else if (state.movies.isNotEmpty) {
                  // Build list with pagination support
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: state.hasReachedMax
                        ? state.movies.length
                        : state.movies.length + 1,
                    itemBuilder: (context, index) {
                      // Show loading indicator at the bottom
                      if (index >= state.movies.length) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      final movie = state.movies[index];
                      return MovieCard(
                        movie: movie,
                        onTap: () {
                          // Navigate to Details Screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailsScreen(movie: movie),
                            ),
                          );
                        },
                      );
                    },
                  );
                } else {
                  return _buildHistory(context, state, l10n);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistory(
    BuildContext context,
    MovieSearchState state,
    AppLocalizations l10n,
  ) {
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
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              TextButton(
                onPressed: () =>
                    context.read<MovieSearchBloc>().add(ClearHistory()),
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
                  onPressed: () => context.read<MovieSearchBloc>().add(
                    RemoveHistoryItem(query),
                  ),
                ),
                onTap: () {
                  // Update the text field visually
                  _searchController.text = query;
                  // Move the cursor to the end of the text
                  _searchController.selection = TextSelection.fromPosition(
                    TextPosition(offset: query.length),
                  );
                  // Re-search directly from history
                  context.read<MovieSearchBloc>().add(
                    SearchQueryChanged(query),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
