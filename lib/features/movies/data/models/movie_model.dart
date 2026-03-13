import 'package:equatable/equatable.dart';
import 'package:hive_ce/hive.dart';

part 'movie_model.g.dart';

@HiveType(typeId: 0)
class MovieModel extends Equatable {
  @HiveField(0)
  final String imdbID;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String year;

  @HiveField(3)
  final String type;

  @HiveField(4)
  final String poster;

  const MovieModel({
    required this.imdbID,
    required this.title,
    required this.year,
    required this.type,
    required this.poster,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      imdbID: json['imdbID'] ?? '',
      title: json['Title'] ?? '',
      year: json['Year'] ?? '',
      type: json['Type'] ?? '',
      poster: json['Poster'] ?? '',
    );
  }

  @override
  List<Object?> get props => [imdbID, title, year, type, poster];
}
