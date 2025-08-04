import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/movie.dart';

part 'movie_model.g.dart';

@JsonSerializable()
class MovieModel extends Movie {
  const MovieModel({
    required String id,
    required String title,
    String? overview,
    @JsonKey(name: 'poster_path') String? posterPath,
    @JsonKey(name: 'backdrop_path') String? backdropPath,
    @JsonKey(name: 'release_date') DateTime? releaseDate,
    @JsonKey(name: 'vote_average') double? voteAverage,
    @JsonKey(name: 'vote_count') int? voteCount,
    @JsonKey(name: 'genre_ids') List<String> genreIds = const [],
    @JsonKey(name: 'original_language') String? originalLanguage,
    @JsonKey(name: 'original_title') String? originalTitle,
    bool? adult,
    double? popularity,
    @JsonKey(name: 'is_favorite') bool isFavorite = false,
    @JsonKey(name: 'is_in_watchlist') bool isInWatchlist = false,
    int? runtime,
    String? status,
    String? tagline,
    @JsonKey(name: 'production_companies') List<String> productionCompanies = const [],
    @JsonKey(name: 'production_countries') List<String> productionCountries = const [],
    @JsonKey(name: 'spoken_languages') List<String> spokenLanguages = const [],
  }) : super(
    id: id,
    title: title,
    overview: overview,
    posterPath: posterPath,
    backdropPath: backdropPath,
    releaseDate: releaseDate,
    voteAverage: voteAverage,
    voteCount: voteCount,
    genreIds: genreIds,
    originalLanguage: originalLanguage,
    originalTitle: originalTitle,
    adult: adult,
    popularity: popularity,
    isFavorite: isFavorite,
    isInWatchlist: isInWatchlist,
    runtime: runtime,
    status: status,
    tagline: tagline,
    productionCompanies: productionCompanies,
    productionCountries: productionCountries,
    spokenLanguages: spokenLanguages,
  );

  factory MovieModel.fromJson(Map<String, dynamic> json) =>
      _$MovieModelFromJson(json);

  Map<String, dynamic> toJson() => _$MovieModelToJson(this);

  factory MovieModel.fromEntity(Movie movie) {
    return MovieModel(
      id: movie.id,
      title: movie.title,
      overview: movie.overview,
      posterPath: movie.posterPath,
      backdropPath: movie.backdropPath,
      releaseDate: movie.releaseDate,
      voteAverage: movie.voteAverage,
      voteCount: movie.voteCount,
      genreIds: movie.genreIds,
      originalLanguage: movie.originalLanguage,
      originalTitle: movie.originalTitle,
      adult: movie.adult,
      popularity: movie.popularity,
      isFavorite: movie.isFavorite,
      isInWatchlist: movie.isInWatchlist,
      runtime: movie.runtime,
      status: movie.status,
      tagline: movie.tagline,
      productionCompanies: movie.productionCompanies,
      productionCountries: movie.productionCountries,
      spokenLanguages: movie.spokenLanguages,
    );
  }
}