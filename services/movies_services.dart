import 'package:flutter/material.dart';

import '../models/models.dart';

abstract class MoviesServices extends ChangeNotifier {
  getOnDisplayMovies();
  getPopularMovies();
  Future<List<Cast>> getCreditsProfile(int movieId);
  Future<List<Movie>> searchMovie(String query);
  void getSuggestionsByQuery(String searchTerm);
}
