import 'package:equatable/equatable.dart';

abstract class MovieDetailsEvent extends Equatable {
  const MovieDetailsEvent();

  @override
  List<Object> get props => [];
}

class LoadMovieDetails extends MovieDetailsEvent {
  final String imdbID;

  const LoadMovieDetails(this.imdbID);

  @override
  List<Object> get props => [imdbID];
}