// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_details_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MovieDetailsModelAdapter extends TypeAdapter<MovieDetailsModel> {
  @override
  final typeId = 1;

  @override
  MovieDetailsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MovieDetailsModel(
      imdbID: fields[0] as String,
      title: fields[1] as String,
      year: fields[2] as String,
      genre: fields[3] as String,
      director: fields[4] as String,
      actors: fields[5] as String,
      plot: fields[6] as String,
      imdbRating: fields[7] as String,
      poster: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MovieDetailsModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.imdbID)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.year)
      ..writeByte(3)
      ..write(obj.genre)
      ..writeByte(4)
      ..write(obj.director)
      ..writeByte(5)
      ..write(obj.actors)
      ..writeByte(6)
      ..write(obj.plot)
      ..writeByte(7)
      ..write(obj.imdbRating)
      ..writeByte(8)
      ..write(obj.poster);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovieDetailsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
