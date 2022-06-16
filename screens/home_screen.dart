import 'package:flutter/material.dart';
import 'package:movies_app/search/search_delegate.dart';
import 'package:movies_app/services/movies_services_impl.dart';
import 'package:movies_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final moviesProvider =
        Provider.of<MoviesServiceImpl>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        actions: [
          Container(
              margin: const EdgeInsets.only(right: 5),
              child: IconButton(
                onPressed: () => showSearch(
                  context: context,
                  delegate: MovieSearchDelegate(),
                ),
                icon: const Icon(Icons.search_outlined),
              ))
        ],
        title: const Text('myAwesome App'),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          //main widget
          CardSwiper(
            movies: moviesProvider.onDisplayMovies,
          ),
          //slider popular
          MovieSlider(
            popular: moviesProvider.popularMovies,
            title: 'Popular',
            height: 260,
            onNextPage: () => moviesProvider.getPopularMovies(),
          )
        ]),
      ),
    );
  }
}
