import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MovieScreen extends ConsumerStatefulWidget {
  static const String name = 'movie_screen';
  final String movieId;
  const MovieScreen({super.key, required this.movieId});

  @override
  MovieScreenState createState() => MovieScreenState();
}

class MovieScreenState extends ConsumerState<MovieScreen> {
  @override
  void initState() {
    ref.read(movieInfoProvider.notifier).loadMovie(widget.movieId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Movie? movie = ref.watch(movieInfoProvider)[widget.movieId];
    if (movie == null) {
      return const Scaffold(
          body: Center(child: CircularProgressIndicator(strokeWidth: 2)));
    }
    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          _CustomSliverAppBar(movie: movie),
          SliverList(
              delegate: SliverChildBuilderDelegate(
                  (context, index) => _MovieDetails(movie: movie),
                  childCount: 1))
        ],
      ),
    );
  }
}

class _MovieDetails extends StatelessWidget {
  final Movie movie;
  const _MovieDetails({required this.movie});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textStyles = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(movie.posterPath,
                        width: 0.3 * size.width)),
                const SizedBox(width: 10),
                SizedBox(
                    width: 0.7 * (size.width - 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(movie.title, style: textStyles.titleLarge),
                        Text(movie.overview)
                      ],
                    ))
              ],
            )),
        Padding(
            padding: const EdgeInsets.all(8),
            child: Wrap(
              children: [
                ...movie.genreIds.map((genero) => Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: Chip(
                        label: Text(genero),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)))))
              ],
            )),
        const SizedBox(height: 100)
      ],
    );
  }
}

class _CustomSliverAppBar extends StatelessWidget {
  final Movie movie;
  const _CustomSliverAppBar({required this.movie});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SliverAppBar(
      backgroundColor: Colors.black,
      expandedHeight: 0.7 * size.height,
      foregroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
          titlePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          title: Text(
            movie.title,
            style: const TextStyle(fontSize: 20),
            textAlign: TextAlign.start,
          ),
          background: Stack(
            children: [
              SizedBox.expand(
                  child: Image.network(movie.posterPath, fit: BoxFit.cover)),
              const SizedBox.expand(
                child: DecoratedBox(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [0.7, 1.0],
                            colors: [Colors.transparent, Colors.black87]))),
              ),
              const SizedBox.expand(
                child: DecoratedBox(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            stops: [0.0, 0.3],
                            colors: [Colors.black87, Colors.transparent]))),
              )
            ],
          )),
    );
  }
}
