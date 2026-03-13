import 'package:equatable/equatable.dart';

abstract class MovieSearchEvent extends Equatable {
  const MovieSearchEvent();

  @override
  List<Object> get props => [];
}

class SearchQueryChanged extends MovieSearchEvent {
  final String query;

  const SearchQueryChanged(this.query);

  @override
  List<Object> get props => [query];
}

class LoadNextPage extends MovieSearchEvent {}

class LoadSearchHistory extends MovieSearchEvent {}

class RemoveHistoryItem extends MovieSearchEvent {
  final String query;

  const RemoveHistoryItem(this.query);

  @override
  List<Object> get props => [query];
}

class ClearHistory extends MovieSearchEvent {}