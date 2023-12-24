import 'dart:async';
import 'package:flutter/material.dart';

import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/domain/entities/movie.dart';

typedef SearchMoviesCallback = Future<List<Movie>> Function(String query);

class SearchMovieDelegate extends SearchDelegate<Movie?> {
  final SearchMoviesCallback searchMovies;
  List<Movie> initialMovies;
  final StreamController<List<Movie>> debouncedMovies =
      StreamController.broadcast();
  final StreamController<bool> isLoadingStream = StreamController.broadcast();
  Timer? _debounceTimer;

  SearchMovieDelegate(
      {required this.searchMovies, required this.initialMovies});

  void clearStreams() {
    debouncedMovies.close();
    isLoadingStream.close();
  }

  void _onQueryChanged(String query) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      // if (query.isEmpty) {
      //   debouncedMovies.add([]);
      //   return;
      // }
      isLoadingStream.add(true);
      final movies = await searchMovies(query);
      initialMovies = movies;
      debouncedMovies.add(movies);
      isLoadingStream.add(false);
    });
  }

  Widget buildSuggestionsAndResults() {
    return StreamBuilder(
      stream: debouncedMovies.stream,
      // future: searchMovies(query),
      initialData: initialMovies,
      builder: (context, snapshot) {
        final movies = snapshot.data ?? [];
        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) {
            return _MovieItem(
              movie: movies[index],
              onMovieSelected: (context, movie) {
                clearStreams();
                close(context, movie);
              },
            );
          },
        );
      },
    );
  }

  @override
  String get searchFieldLabel => 'Buscar película';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      StreamBuilder(
          stream: isLoadingStream.stream,
          builder: (context, snapshot) => (snapshot.data ?? false)
              ? SpinPerfect(
                  duration: const Duration(seconds: 20),
                  infinite: true,
                  spins: 15,
                  child: IconButton(
                      onPressed: () => query = '',
                      icon: const Icon(Icons.refresh_rounded)))
              : FadeIn(
                  animate: query.isNotEmpty,
                  duration: const Duration(milliseconds: 200),
                  child: IconButton(
                      onPressed: () => query = '',
                      icon: const Icon(Icons.clear)))),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () => close(context, null),
        icon: const Icon(Icons.arrow_back_ios_new_outlined));
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestionsAndResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _onQueryChanged(query);
    return buildSuggestionsAndResults();
  }
}

class _MovieItem extends StatelessWidget {
  final Movie movie;
  final Function onMovieSelected;
  const _MovieItem({required this.movie, required this.onMovieSelected});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => {onMovieSelected(context, movie)},
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            children: [
              //Image
              SizedBox(
                  width: 0.2 * size.width,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(movie.posterPath,
                          loadingBuilder: (context, child, loadingProgress) =>
                              FadeIn(child: child)))),
              const SizedBox(width: 10),

              SizedBox(
                  width: 0.7 * size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(movie.title, style: textStyles.titleMedium),
                      (movie.overview.length > 100)
                          ? Text('${movie.overview.substring(0, 100)}...')
                          : Text(movie.overview),
                      Row(
                        children: [
                          Icon(Icons.star_half_rounded,
                              color: Colors.yellow.shade800),
                          const SizedBox(width: 5),
                          Text(HumanFormats.number(movie.voteAverage, 1),
                              style: textStyles.bodyMedium!
                                  .copyWith(color: Colors.yellow.shade900))
                        ],
                      )
                    ],
                  ))
              //Description
            ],
          )),
    );
  }
}
