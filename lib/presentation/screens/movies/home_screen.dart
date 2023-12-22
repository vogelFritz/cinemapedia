import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/providers.dart';
import '../../widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  static const String name = 'home-screen';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        bottomNavigationBar: CustomBottomNavigationBar(), body: _HomeView());
  }
}

class _HomeView extends ConsumerStatefulWidget {
  const _HomeView();

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<_HomeView> {
  @override
  void initState() {
    super.initState();
    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
    final slideShowMovies = ref.watch(moviesSlideshowProvider);
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
            const CustomAppbar(),
            MoviesSlideShow(movies: slideShowMovies),
            MoviesHorizontalListview(
              movies: nowPlayingMovies,
              title: 'En cines',
              subTitle: 'Lunes 20',
              loadNextPage:
                  ref.read(nowPlayingMoviesProvider.notifier).loadNextPage,
            ),
            MoviesHorizontalListview(
              movies: nowPlayingMovies,
              title: 'Proximamente',
              subTitle: 'En este mes',
              loadNextPage:
                  ref.read(nowPlayingMoviesProvider.notifier).loadNextPage,
            ),
            MoviesHorizontalListview(
              movies: nowPlayingMovies,
              title: 'Populares',
              //subTitle: 'En este mes',
              loadNextPage:
                  ref.read(nowPlayingMoviesProvider.notifier).loadNextPage,
            ),
            MoviesHorizontalListview(
              movies: nowPlayingMovies,
              title: 'Mejor calificadas',
              subTitle: 'De todos los tiempos',
              loadNextPage:
                  ref.read(nowPlayingMoviesProvider.notifier).loadNextPage,
            ),
            const SizedBox(height: 15)
          ],
        );
      }, childCount: 1))
    ]);
  }
}
