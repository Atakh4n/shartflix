// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieModel _$MovieModelFromJson(Map<String, dynamic> json) => MovieModel(
      id: json['id'] as String,
      title: json['title'] as String,
      overview: json['overview'] as String?,
      posterPath: json['posterPath'] as String?,
      backdropPath: json['backdropPath'] as String?,
      releaseDate: json['releaseDate'] == null
          ? null
          : DateTime.parse(json['releaseDate'] as String),
      voteAverage: (json['voteAverage'] as num?)?.toDouble(),
      voteCount: (json['voteCount'] as num?)?.toInt(),
      genreIds: (json['genreIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      originalLanguage: json['originalLanguage'] as String?,
      originalTitle: json['originalTitle'] as String?,
      adult: json['adult'] as bool?,
      popularity: (json['popularity'] as num?)?.toDouble(),
      isFavorite: json['isFavorite'] as bool? ?? false,
      isInWatchlist: json['isInWatchlist'] as bool? ?? false,
      runtime: (json['runtime'] as num?)?.toInt(),
      status: json['status'] as String?,
      tagline: json['tagline'] as String?,
      productionCompanies: (json['productionCompanies'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      productionCountries: (json['productionCountries'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      spokenLanguages: (json['spokenLanguages'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$MovieModelToJson(MovieModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'overview': instance.overview,
      'posterPath': instance.posterPath,
      'backdropPath': instance.backdropPath,
      'releaseDate': instance.releaseDate?.toIso8601String(),
      'voteAverage': instance.voteAverage,
      'voteCount': instance.voteCount,
      'genreIds': instance.genreIds,
      'originalLanguage': instance.originalLanguage,
      'originalTitle': instance.originalTitle,
      'adult': instance.adult,
      'popularity': instance.popularity,
      'isFavorite': instance.isFavorite,
      'isInWatchlist': instance.isInWatchlist,
      'runtime': instance.runtime,
      'status': instance.status,
      'tagline': instance.tagline,
      'productionCompanies': instance.productionCompanies,
      'productionCountries': instance.productionCountries,
      'spokenLanguages': instance.spokenLanguages,
    };
