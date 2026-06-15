import '../../../../models/movie_response.dart';

abstract class MovieState {}

class MovieInitial extends MovieState {}

class MovieLoading extends MovieState {}

class MovieSuccess extends MovieState {
  final MovieResponse? movieResponse;

  MovieSuccess({this.movieResponse});
}

class MovieDetailsSuccess extends MovieState {
  final Movies movie;
  final List<Movies> suggestedMovies;

  MovieDetailsSuccess({required this.movie, required this.suggestedMovies});
}

class MovieError extends MovieState {
  final String message;

  MovieError(this.message);
}

class MovieDetailsError extends MovieState{
  final String message;

  MovieDetailsError(this.message);
}

class MovieDetailsLoading extends MovieState{}

class MovieSuggestionsSuccess
    extends MovieState {}
