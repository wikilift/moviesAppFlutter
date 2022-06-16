import 'package:flutter/material.dart';

class MovieSlider extends StatelessWidget {
  const MovieSlider(
      {Key? key,
      this.height,
      required this.popular,
      this.title = "",
      required this.onNextPage})
      : super(key: key);
  final double? height;
  final String? title;
  final List<dynamic> popular;
  final Function onNextPage;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height ?? 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(title.toString(),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold))),
          const SizedBox(
            height: 5,
          ),
          _MoviePoster(
            popular: popular,
            onNextPage: onNextPage,
          )
        ],
      ),
    );
  }
}

class _MoviePoster extends StatefulWidget {
  const _MoviePoster({
    Key? key,
    required this.popular,
    required this.onNextPage,
  }) : super(key: key);
  final List<dynamic> popular;
  final Function onNextPage;

  @override
  State<_MoviePoster> createState() => _MoviePosterState();
}

class _MoviePosterState extends State<_MoviePoster> {
  final scrollController = ScrollController();
  bool loading = false;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (loading) return;

      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 500) {
        loading = true;
        widget.onNextPage();
      }

      // print(scrollController.position.pixels);
      // print(scrollController.position.maxScrollExtent);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.popular.isEmpty) {
      return const SizedBox(
          width: double.infinity,
          height: 100,
          child: Center(child: CircularProgressIndicator()));
    }
    return Expanded(
      child: ListView.builder(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: widget.popular.length,
        itemBuilder: (_, int index) {
          final movie = widget.popular[index];
          movie.heroId = 'slider-${movie.id}';
          return Container(
            width: 130,
            height: 190,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: SingleChildScrollView(
              child: Hero(
                tag: movie.heroId!,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, 'details',
                          arguments: movie),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: FadeInImage(
                          width: 130,
                          height: 190,
                          fit: BoxFit.cover,
                          placeholder: const AssetImage('assets/loading.gif'),
                          image: NetworkImage(movie.fullPosterImg.toString()),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      movie.title.toString(),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
