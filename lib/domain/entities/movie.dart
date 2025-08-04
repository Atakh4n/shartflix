import 'package:equatable/equatable.dart';

class Movie extends Equatable {
  final String id;
  final String title;
  final String? overview;
  final String? posterPath;
  final String? backdropPath;
  final DateTime? releaseDate;
  final double? voteAverage;
  final int? voteCount;
  final List<String> genreIds;
  final String? originalLanguage;
  final String? originalTitle;
  final bool? adult;
  final double? popularity;
  final bool isFavorite;
  final bool isInWatchlist;
  final int? runtime;
  final String? status;
  final String? tagline;
  final List<String> productionCompanies;
  final List<String> productionCountries;
  final List<String> spokenLanguages;

  const Movie({
    required this.id,
    required this.title,
    this.overview,
    this.posterPath,
    this.backdropPath,
    this.releaseDate,
    this.voteAverage,
    this.voteCount,
    this.genreIds = const [],
    this.originalLanguage,
    this.originalTitle,
    this.adult,
    this.popularity,
    this.isFavorite = false,
    this.isInWatchlist = false,
    this.runtime,
    this.status,
    this.tagline,
    this.productionCompanies = const [],
    this.productionCountries = const [],
    this.spokenLanguages = const [],
  });

  String get fullPosterUrl {
    if (posterPath != null) {
      return 'https://image.tmdb.org/t/p/w500$posterPath';
    }
    return '';
  }

  String get fullBackdropUrl {
    if (backdropPath != null) {
      return 'https://image.tmdb.org/t/p/w1280$backdropPath';
    }
    return '';
  }

  String get formattedReleaseDate {
    if (releaseDate != null) {
      return '${releaseDate!.day}/${releaseDate!.month}/${releaseDate!.year}';
    }
    return '';
  }

  String get formattedRating {
    if (voteAverage != null) {
      return voteAverage!.toStringAsFixed(1);
    }
    return '0.0';
  }

  String get formattedRuntime {
    if (runtime != null) {
      final hours = runtime! ~/ 60;
      final minutes = runtime! % 60;
      return '${hours}s ${minutes}dk';
    }
    return '';
  }

  Movie copyWith({
    String? id,
    String? title,
    String? overview,
    String? posterPath,
    String? backdropPath,
    DateTime? releaseDate,
    double? voteAverage,
    int? voteCount,
    List<String>? genreIds,
    String? originalLanguage,
    String? originalTitle,
    bool? adult,
    double? popularity,
    bool? isFavorite,
    bool? isInWatchlist,
    int? runtime,
    String? status,
    String? tagline,
    List<String>? productionCompanies,
    List<String>? productionCountries,
    List<String>? spokenLanguages,
  }) {
    return Movie(
      id: id ?? this.id,
      title: title ?? this.title,
      overview: overview ?? this.overview,
      posterPath: posterPath ?? this.posterPath,
      backdropPath: backdropPath ?? this.backdropPath,
      releaseDate: releaseDate ?? this.releaseDate,
      voteAverage: voteAverage ?? this.voteAverage,
      voteCount: voteCount ?? this.voteCount,
      genreIds: genreIds ?? this.genreIds,
      originalLanguage: originalLanguage ?? this.originalLanguage,
      originalTitle: originalTitle ?? this.originalTitle,
      adult: adult ?? this.adult,
      popularity: popularity ?? this.popularity,
      isFavorite: isFavorite ?? this.isFavorite,
      isInWatchlist: isInWatchlist ?? this.isInWatchlist,
      runtime: runtime ?? this.runtime,
      status: status ?? this.status,
      tagline: tagline ?? this.tagline,
      productionCompanies: productionCompanies ?? this.productionCompanies,
      productionCountries: productionCountries ?? this.productionCountries,
      spokenLanguages: spokenLanguages ?? this.spokenLanguages,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    overview,
    posterPath,
    backdropPath,
    releaseDate,
    voteAverage,
    voteCount,
    genreIds,
    originalLanguage,
    originalTitle,
    adult,
    popularity,
    isFavorite,
    isInWatchlist,
    runtime,
    status,
    tagline,
    productionCompanies,
    productionCountries,
    spokenLanguages,
  ];

  @override
  String toString() {
    return 'Movie(id: $id, title: $title, rating: $formattedRating)';
  }
}