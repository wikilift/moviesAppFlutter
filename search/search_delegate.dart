import 'package:flutter/material.dart';
import 'package:movies_app/models/movie.dart';
import 'package:movies_app/services/movies_services_impl.dart';
import 'package:provider/provider.dart';

class MovieSearchDelegate extends SearchDelegate {
  @override
  String? get searchFieldLabel => 'Buscar...';
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => query = '',
        icon: const Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () => close(context, null), //lo que quieras enviar Future
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Text('buildResults');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return _emptySearh();
    }

    final moviesProvider =
        Provider.of<MoviesServiceImpl>(context, listen: false);
    moviesProvider.getSuggestionsByQuery(query);
    return StreamBuilder(
      builder: (context, AsyncSnapshot<List<Movie>> snapshot) {
        if (!snapshot.hasData) {
          return _emptySearh();
        }
        final movies = snapshot.data;
        return ListView.builder(
          itemBuilder: (context, index) {
            return _movieItem(movie: movies![index]);
          },
          itemCount: movies?.length,
        );
      },
      stream: moviesProvider.suggestionsStream,
    );
  }
}

Widget _emptySearh() {
  return const SizedBox(
      child: Center(
          child: Icon(
    Icons.movie_creation_outlined,
    color: Colors.black38,
    size: 150,
  )));
}

class _movieItem extends StatelessWidget {
  const _movieItem({Key? key, required this.movie}) : super(key: key);
  final Movie movie;

  @override
  Widget build(BuildContext context) {
    movie.heroId = 'seacrh-${movie.id}';
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        children: [
          Hero(
            tag: movie.heroId!,
            child: ListTile(
              onTap: () =>
                  Navigator.pushNamed(context, 'details', arguments: movie),
              title: Text(
                movie.title.toString(),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              leading: FadeInImage(
                placeholder: const AssetImage('assets/loading.gif'),
                image: NetworkImage(movie.fullPosterImg),
                width: 70,
                fit: BoxFit.contain,
              ),
              subtitle: Text(
                movie.originalTitle.toString(),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
