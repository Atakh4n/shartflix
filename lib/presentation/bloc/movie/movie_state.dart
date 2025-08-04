part of 'movie_bloc.dart';

abstract class MovieState extends Equatable {
  const MovieState();

  @override
  List<Object?> get props => [];
}

class MovieInitial extends MovieState {}

class MovieLoading extends MovieState {}

class MovieLoaded extends MovieState {
  final List<Movie> trendingMovies;
  final List<Movie> popularMovies;
  final List<Movie> nowPlayingMovies;
  final List<Movie> topRatedMovies;
  final List<Movie> popularTVShows;

  const MovieLoaded({
    this.trendingMovies = const [],
    this.popularMovies = const [],
    this.nowPlayingMovies = const [],
    this.topRatedMovies = const [],
    this.popularTVShows = const [],
  });

  MovieLoaded copyWith({
    List<Movie>? trendingMovies,
    List<Movie>? popularMovies,
    List<Movie>? nowPlayingMovies,
    List<Movie>? topRatedMovies,
    List<Movie>? popularTVShows,
  }) {
    return MovieLoaded(
      trendingMovies: trendingMovies ?? this.trendingMovies,
      popularMovies: popularMovies ?? this.popularMovies,
      nowPlayingMovies: nowPlayingMovies ?? this.nowPlayingMovies,
      topRatedMovies: topRatedMovies ?? this.topRatedMovies,
      popularTVShows: popularTVShows ?? this.popularTVShows,
    );
  }

  // İlk film featured olarak gösterilecek
  Movie? get featuredMovie => trendingMovies.isNotEmpty ? trendingMovies.first : null;

  @override
  List<Object?> get props => [
    trendingMovies,
    popularMovies,
    nowPlayingMovies,
    topRatedMovies,
    popularTVShows,
  ];
}

class MovieError extends MovieState {
  final String message;

  const MovieError({required this.message});

  @override
  List<Object?> get props => [message];
}