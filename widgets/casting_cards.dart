import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/models/models.dart';
import 'package:provider/provider.dart';

import '../services/movies_services_impl.dart';

class CastingCards extends StatelessWidget {
  const CastingCards({Key? key, this.movieId = 1}) : super(key: key);

  final int movieId;
  @override
  Widget build(BuildContext context) {
    final moviesProvider =
        Provider.of<MoviesServiceImpl>(context, listen: false);
    return FutureBuilder(
        future: moviesProvider.getCreditsProfile(movieId),
        builder: ((context, snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox(
              height: 180,
              child: CupertinoActivityIndicator(),
            );
          }
          final List<Cast> cast = snapshot.data!;
          return Container(
            margin: const EdgeInsets.only(bottom: 30),
            width: double.infinity,
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: ((context, index) => _CastCard(
                    actor: cast[index],
                  )),
              itemCount: 10,
            ),
          );
        }));
  }
}

class _CastCard extends StatelessWidget {
  const _CastCard({Key? key, required this.actor}) : super(key: key);
  final Cast actor;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: 110,
      height: 100,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),

            /* decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                  blurStyle: BlurStyle.solid,
                  color: Colors.white,
                  offset: Offset(0.5, 2.2),
                  spreadRadius: 0, //(x,y)
                  blurRadius: 4.0,
                ),
              ],
              borderRadius: BorderRadius.circular(20),
            ),*/
            child: FadeInImage(
              placeholder: const AssetImage('assets/no-image.jpg'),
              image: NetworkImage(actor.fullProfilePath),
              height: 140,
              width: 100,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            actor.name.toString(),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
