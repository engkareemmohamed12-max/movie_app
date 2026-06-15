import 'package:dio/dio.dart';

abstract class MovieRemoteDataSource {

  Future<Response> getMovies({
    String? sortBy,
    String? genre,
  });

  Future<Response> getMovieDetails(
      int movieId,
      );

  Future<Response> getMovieSuggestions(
      int movieId,
      );

  Future<Response> searchMovies(String query);

}