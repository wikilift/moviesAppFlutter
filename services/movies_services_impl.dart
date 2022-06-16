import 'dart:async';

import 'package:flutter/material.dart';
import 'package:movies_app/helpers/custom_debouncer.dart';
import 'package:movies_app/models/now_playing_response.dart';
import 'package:movies_app/models/popular_movies_response.dart';
import 'package:movies_app/models/search_movie_response.dart';
import 'package:movies_app/services/movies_services.dart';
import 'package:http/http.dart' as http;

import '../models/models.dart';

class MoviesServiceImpl extends ChangeNotifier implements MoviesServices {
  final String _baseUrl = 'api.themoviedb.org';
  final String _apiKey = '1a09d4fe880219a712158637be617556';
  final String _language = 'es-ES';
  int _popularPage = 0;

  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies = [];
  Map<int, List<Cast>> movieCast = {};
  final StreamController<List<Movie>> _suggestionsStreamController =
      StreamController.broadcast();

  Stream<List<Movie>> get suggestionsStream =>
      _suggestionsStreamController.stream;

  final debouncer = Debouncer(
    duration: const Duration(milliseconds: 500),
  );

  MoviesServiceImpl() {
    getOnDisplayMovies();
    getPopularMovies();
  }

  @override
  getOnDisplayMovies() async {
    var response = await _getJsonData(endPoint: '3/movie/now_playing');

    final data = NowPlayingResonse.fromJson(response);

    onDisplayMovies = data.results;

    notifyListeners();
  }

  @override
  getPopularMovies() async {
    _popularPage++;
    var response =
        await _getJsonData(endPoint: '3/movie/popular', page: _popularPage);

    final data = PopularMoviesResonse.fromJson(response);

    popularMovies = [...popularMovies, ...data.results];

    notifyListeners();
  }

  @override
  Future<List<Cast>> getCreditsProfile(int movieId) async {
    if (movieCast.containsKey(movieId)) {
      return movieCast[movieId]!;
    }
    var response = await _getJsonData(endPoint: '3/movie/$movieId/credits');

    final data = CreditsResponse.fromJson(response);
    movieCast[movieId] = data.cast;
    return data.cast;
  }

  @override
  Future<List<Movie>> searchMovie(String query) async {
    final url = Uri.https(
      _baseUrl,
      '3/search/movie',
      {'api_key': _apiKey, 'language': _language, 'query': query},
    );
    final response = await http.get(url);
    print(response.body);
    final moviesSearchResponse = SearchMovieResponse.fromJson(response.body);
    return moviesSearchResponse.results;
  }

  Future<String> _getJsonData({
    required String endPoint,
    int page = 1,
  }) async {
    final url = Uri.https(
      _baseUrl,
      endPoint,
      {'api_key': _apiKey, 'language': _language, 'page': '$page'},
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return "Error";
    }
  }

  @override
  void getSuggestionsByQuery(String searchTerm) {
    debouncer.onValue = (value) async {
      final results = await searchMovie(value);

      _suggestionsStreamController.add(results);

      final timer = Timer.periodic(const Duration(milliseconds: 300), (_) {
        debouncer.value = searchTerm;
      });
      Future.delayed(const Duration(milliseconds: 301))
          .then((_) => timer.cancel());
    };
  }
}
