import 'package:equatable/equatable.dart';
import 'package:hive_ce/hive.dart';

part 'movie_details_model.g.dart';

@HiveType(typeId: 1)
class MovieDetailsModel extends Equatable {
  @HiveField(0)
  final String imdbID;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String year;
  @HiveField(3)
  final String genre;
  @HiveField(4)
  final String director;
  @HiveField(5)
  final String actors;
  @HiveField(6)
  final String plot;
  @HiveField(7)
  final String imdbRating;
  @HiveField(8)
  final String poster;

  const MovieDetailsModel({
    required this.imdbID,
    required this.title,
    required this.year,
    required this.genre,
    required this.director,
    required this.actors,
    required this.plot,
    required this.imdbRating,
    required this.poster,
  });

  factory MovieDetailsModel.fromJson(Map<String, dynamic> json) {
    return MovieDetailsModel(
      imdbID: json['imdbID'] ?? '',
      title: json['Title'] ?? '',
      year: json['Year'] ?? '',
      genre: json['Genre'] ?? '',
      director: json['Director'] ?? '',
      actors: json['Actors'] ?? '',
      plot: json['Plot'] ?? '',
      imdbRating: json['imdbRating'] ?? '',
      poster: json['Poster'] ?? '',
    );
  }

  @override
  List<Object?> get props => [
    imdbID,
    title,
    year,
    genre,
    director,
    actors,
    plot,
    imdbRating,
    poster,
  ];
}
