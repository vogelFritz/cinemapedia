import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import '../../providers/providers.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends ConsumerState<HomeView> {
  @override
  void initState() {
    super.initState();
    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
    ref.read(popularMoviesProvider.notifier).loadNextPage();
    ref.read(upcomingMoviesProvider.notifier).loadNextPage();
    ref.read(topRatedMoviesProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    final initialLoading = ref.watch(initialLoadingProvider);
    if (initialLoading) return const FullScreenLoader();

    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
    final slideShowMovies = ref.watch(moviesSlideshowProvider);
    final popularMovies = ref.watch(popularMoviesProvider);
    final topRatedMovies = ref.watch(topRatedMoviesProvider);
    final upcomingMovies = ref.watch(upcomingMoviesProvider);
    if (slideShowMovies.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return CustomScrollView(slivers: [
      const SliverAppBar(
        floating: true,
        flexibleSpace: FlexibleSpaceBar(title: CustomAppbar()),
      ),
      SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
        return Column(
          children: [
            MoviesSlideShow(movies: slideShowMovies),
            MoviesHorizontalListview(
              movies: nowPlayingMovies,
              title: 'En cines',
              subTitle: 'Lunes 20',
              loadNextPage:
                  ref.read(nowPlayingMoviesProvider.notifier).loadNextPage,
            ),
            MoviesHorizontalListview(
              movies: upcomingMovies,
              title: 'Proximamente',
              subTitle: 'En este mes',
              loadNextPage:
                  ref.read(upcomingMoviesProvider.notifier).loadNextPage,
            ),
            MoviesHorizontalListview(
              movies: popularMovies,
              title: 'Populares',
              //subTitle: 'En este mes',
              loadNextPage:
                  ref.read(popularMoviesProvider.notifier).loadNextPage,
            ),
            MoviesHorizontalListview(
              movies: topRatedMovies,
              title: 'Mejor calificadas',
              subTitle: 'De todos los tiempos',
              loadNextPage:
                  ref.read(topRatedMoviesProvider.notifier).loadNextPage,
            ),
            const SizedBox(height: 15)
          ],
        );
      }, childCount: 1))
    ]);
  }
}
