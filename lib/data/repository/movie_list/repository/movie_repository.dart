import 'package:cineluxe/models/movie_response.dart';


abstract class MovieRepository {

  Future<MovieResponse> getMovies({
    String sortBy = 'date_added',
    String? genre,
  });
  Future<Movies> getMovieDetails(int movieId);

  Future<List<Movies>> getMovieSuggestions(
      int movieId,
      );

  Future<MovieResponse> searchMovies(String query);


}