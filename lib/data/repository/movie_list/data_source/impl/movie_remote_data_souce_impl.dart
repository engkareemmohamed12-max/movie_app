import 'package:dio/dio.dart';

import '../../../../../api/dio/dio_manager.dart';
import '../../../../../api/end_point.dart';
import '../movie_remote_data_source.dart';


class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {

  @override
  Future<Response> getMovies({
    String? sortBy,
    String? genre,
  }) async {

    return await DioManager.dio.get(
      EndPoints.moviesApi,

      queryParameters: {
        'sort_by': sortBy ?? 'date_added',
        'order_by': 'desc',
        'limit': 20,
        if (genre != null && genre.isNotEmpty && genre != 'all')
          'genre': genre,
      },
    );
  }
  @override
  Future<Response> getMovieDetails(int movieId) async {
    return await DioManager.dio.get(
      EndPoints.movieDetails,

      queryParameters: {
        'movie_id': movieId,
        'with_images': true,
        'with_cast': true,
      },
    );
  }

  @override
  Future<Response> getMovieSuggestions(
      int movieId,
      ) async {

    return await DioManager.dio.get(
      EndPoints.movieSuggestion,

      queryParameters: {
        'movie_id': movieId,
      },
    );
  }

  @override
  Future<Response> searchMovies(String query) async {

    return await DioManager.dio.get(
      EndPoints.moviesApi,

      queryParameters: {
        'query_term': query,
      },
    );
  }

}