import 'package:cineluxe/models/movie_response.dart';

import '../../data_source/movie_remote_data_source.dart';
import '../movie_repository.dart';


class MovieRepositoryImpl implements MovieRepository {

  final MovieRemoteDataSource movieRemoteDataSource;

  MovieRepositoryImpl(this.movieRemoteDataSource);

  @override
  Future<MovieResponse> getMovies({
    String sortBy = 'date_added',
    String? genre,
  }) async {

    final response =
    await movieRemoteDataSource.getMovies(
      sortBy: sortBy,
      genre: genre,
    );

    return MovieResponse.fromJson(response.data);
  }

  @override
  Future<Movies> getMovieDetails(int movieId) async{
    final movie =
    await movieRemoteDataSource.getMovieDetails(movieId);
    return Movies.fromJson(
      movie.data['data']['movie'],
    );
  }



  @override
  Future<List<Movies>> getMovieSuggestions(
      int movieId,
      ) async {

    final response =
    await movieRemoteDataSource
        .getMovieSuggestions(movieId);

    List moviesJson =
    response.data['data']['movies'];

    return moviesJson
        .map(
          (e) => Movies.fromJson(e),
    )
        .toList();
  }

  @override
  Future<MovieResponse> searchMovies(String query) async {

    final response =
    await movieRemoteDataSource.searchMovies(query);

    return MovieResponse.fromJson(response.data);
  }

}