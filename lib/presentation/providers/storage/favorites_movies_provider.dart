import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/repositories/local_storate_repository.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final favoriteMoviesProvider =
    StateNotifierProvider<StorageMoviesNotifier, Map<int, Movie>>((ref) {
  final localStorageRepository = ref.watch(localStorageRepositoryProvider);
  return StorageMoviesNotifier(localStorageRepository: localStorageRepository);
});

class StorageMoviesNotifier extends StateNotifier<Map<int, Movie>> {
  int page = 0;
  bool isLoading = false;
  final LocalStorageRepository localStorageRepository;
  StorageMoviesNotifier({required this.localStorageRepository}) : super({});
  Future<List<Movie>> loadNextPage() async {
    if (isLoading) return [];
    isLoading = true;
    final movies =
        await localStorageRepository.loadMovies(limit: 20, offset: page * 10);
    page++;
    final tempMoviesMap = <int, Movie>{};
    for (final movie in movies) {
      tempMoviesMap[movie.id] = movie;
    }
    state = {...state, ...tempMoviesMap};
    isLoading = false;
    return movies;
  }

  Future<void> toggleFavorite(Movie movie) async {
    final bool isMovieInFavorites =
        await localStorageRepository.isMovieFavorite(movie.id);
    await localStorageRepository.toggleFavorite(movie);
    // final bool isMovieInFavorites = state[movie.id] != null;
    if (isMovieInFavorites) {
      state.remove(movie.id);
      state = {...state};
    } else {
      if (isLoading) state = {...state, movie.id: movie};
    }
  }
}
