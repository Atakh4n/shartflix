part of 'movie_bloc.dart';

abstract class MovieEvent extends Equatable {
  const MovieEvent();

  @override
  List<Object?> get props => [];
}

class LoadMovies extends MovieEvent {}

class RefreshMovies extends MovieEvent {}

class LoadMoreMovies extends MovieEvent {
  final MovieCategory category;
  final int page;

  const LoadMoreMovies({
    required this.category,
    required this.page,
  });

  @override
  List<Object?> get props => [category, page];
}

enum MovieCategory {
  trending,
  popular,
  nowPlaying,
  topRated,
  tvShows,
}