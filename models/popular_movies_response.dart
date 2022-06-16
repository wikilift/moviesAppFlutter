import 'dart:convert';
import 'models.dart';

class PopularMoviesResonse {
  PopularMoviesResonse({
    this.page,
    required this.results,
    this.totalPages,
    this.totalResults,
  });

  int? page;
  List<Movie> results = [];
  int? totalPages;
  int? totalResults;

  factory PopularMoviesResonse.fromJson(String str) =>
      PopularMoviesResonse.fromMap(json.decode(str));

  factory PopularMoviesResonse.fromMap(Map<String, dynamic> json) =>
      PopularMoviesResonse(
        page: json["page"],
        results: List<Movie>.from(json["results"].map((x) => Movie.fromMap(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
      );
}
