import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/entities/movie.dart';
import '../../../data/services/tmdb_service.dart';

part 'movie_event.dart';
part 'movie_state.dart';

@injectable
class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final TMDBService _tmdbService;

  MovieBloc(this._tmdbService) : super(MovieInitial()) {
    on<LoadMovies>(_onLoadMovies);
    on<RefreshMovies>(_onRefreshMovies);
    on<LoadMoreMovies>(_onLoadMoreMovies);
  }

  Future<void> _onLoadMovies(
      LoadMovies event,
      Emitter<MovieState> emit,
      ) async {
    emit(MovieLoading());

    try {
      // Paralel olarak tüm kategorileri yükle
      final results = await Future.wait([
        _tmdbService.getTrendingMovies(),
        _tmdbService.getPopularMovies(),
        _tmdbService.getNowPlayingMovies(),
        _tmdbService.getTopRatedMovies(),
        _tmdbService.getPopularTVShows(),
      ]);

      emit(MovieLoaded(
        trendingMovies: results[0],
        popularMovies: results[1],
        nowPlayingMovies: results[2],
        topRatedMovies: results[3],
        popularTVShows: results[4],
      ));
    } catch (e) {
      emit(MovieError(message: 'Filmler yüklenirken hata oluştu: $e'));
    }
  }

  Future<void> _onRefreshMovies(
      RefreshMovies event,
      Emitter<MovieState> emit,
      ) async {
    // Mevcut state'i koruyarak refresh yap
    final currentState = state;

    try {
      final results = await Future.wait([
        _tmdbService.getTrendingMovies(),
        _tmdbService.getPopularMovies(),
        _tmdbService.getNowPlayingMovies(),
        _tmdbService.getTopRatedMovies(),
        _tmdbService.getPopularTVShows(),
      ]);

      emit(MovieLoaded(
        trendingMovies: results[0],
        popularMovies: results[1],
        nowPlayingMovies: results[2],
        topRatedMovies: results[3],
        popularTVShows: results[4],
      ));
    } catch (e) {
      // Hata durumunda eski state'i koru
      if (currentState is MovieLoaded) {
        emit(currentState);
      } else {
        emit(MovieError(message: 'Filmler yüklenirken hata oluştu: $e'));
      }
    }
  }

  Future<void> _onLoadMoreMovies(
      LoadMoreMovies event,
      Emitter<MovieState> emit,
      ) async {
    final currentState = state;
    if (currentState is! MovieLoaded) return;

    try {
      List<Movie> newMovies = [];

      switch (event.category) {
        case MovieCategory.popular:
          newMovies = await _tmdbService.getPopularMovies(page: event.page);
          emit(currentState.copyWith(
            popularMovies: [...currentState.popularMovies, ...newMovies],
          ));
          break;
        case MovieCategory.nowPlaying:
          newMovies = await _tmdbService.getNowPlayingMovies(page: event.page);
          emit(currentState.copyWith(
            nowPlayingMovies: [...currentState.nowPlayingMovies, ...newMovies],
          ));
          break;
        case MovieCategory.topRated:
          newMovies = await _tmdbService.getTopRatedMovies(page: event.page);
          emit(currentState.copyWith(
            topRatedMovies: [...currentState.topRatedMovies, ...newMovies],
          ));
          break;
        case MovieCategory.tvShows:
          newMovies = await _tmdbService.getPopularTVShows(page: event.page);
          emit(currentState.copyWith(
            popularTVShows: [...currentState.popularTVShows, ...newMovies],
          ));
          break;
        default:
          break;
      }
    } catch (e) {
      // Sessizce hata yönetimi
      print('Error loading more movies: $e');
    }
  }
}