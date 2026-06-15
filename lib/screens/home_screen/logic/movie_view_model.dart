import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repository/movie_list/repository/movie_repository.dart';
import '../../../models/movie_response.dart';
import '../../../models/movie_details_response.dart';
import 'movie_states/movie_states.dart';

class MovieCubit extends Cubit<MovieState> {
  final MovieRepository repository;

  List<Movies>? latestMovies;
  List<Movies>? categoryMovies;
  List<Movies>? suggestedMovies;

  String currentGenre = 'action';

  MovieCubit(this.repository) : super(MovieInitial()) {
    getAllHomeData();
  }

  Future<void> getAllHomeData({
    String? genre,
    bool force = false,
  }) async {
    final newGenre = genre ?? currentGenre;

    if (!force &&
        latestMovies != null &&
        newGenre == currentGenre) {
      return;
    }

    emit(MovieLoading());

    currentGenre = newGenre;

    try {
      if (latestMovies == null || force) {
        final latestResult = await repository.getMovies(
          sortBy: 'date_added',
        );

        latestMovies =
            latestResult.data?.movies?.take(6).toList();
      }

      final categoryResult = await repository.getMovies(
        genre: currentGenre,
      );

      categoryMovies = categoryResult.data?.movies;

      emit(
        MovieSuccess(
          movieResponse: categoryResult,
        ),
      );
    } catch (e) {
      emit(
        MovieError(e.toString()),
      );
    }
  }

  Future<void> getMovieDetails(int movieId) async {
    emit(MovieLoading());

    try {
      final results = await Future.wait([
        repository.getMovieDetails(movieId),
        repository.getMovieSuggestions(movieId),
      ]);

      final Movies movie = results[0] as Movies;
      suggestedMovies = results[1] as List<Movies>;

      emit(
        MovieDetailsSuccess(
          movie: movie,
          suggestedMovies: suggestedMovies!,
        ),
      );
    } catch (e) {
      emit(
        MovieError(e.toString()),
      );
    }
  }

  Future<void> getRandomMovies() async {
    final genres = [
      'action',
      'comedy',
      'drama',
      'horror',
      'sci-fi',
    ];

    await getAllHomeData(
      genre: genres[Random().nextInt(genres.length)],
      force: true,
    );
  }


  Future<void> getMovieSuggestions(
      int movieId,
      ) async {

    emit(MovieLoading());

    try {

      suggestedMovies =
      await repository
          .getMovieSuggestions(movieId);

      emit(
        MovieSuggestionsSuccess(),
      );

    } catch (e) {

      emit(
        MovieError(e.toString()),
      );

    }
  }

}