import 'package:flutter/material.dart';
import 'package:movies_app/widgets/widgets.dart';

import '../models/models.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Object movie = ModalRoute.of(context)?.settings.arguments ?? Movie();
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        CustomSliverAppBar(
          movie: movie as Movie,
        ),
        SliverList(
            delegate: SliverChildListDelegate(
          [
            PosterAndTitle(
              movie: movie,
            ),
            Overview(
              movie: movie,
            ),
            CastingCards(movieId: movie.id!)
          ],
        )),
      ],
    ));
  }
}
