import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repository/movie_list/repository/movie_repository.dart';
import '../../../models/movie_response.dart';
import 'browse_states/browse_states.dart';

class BrowseViewModel extends Cubit<BrowseStates> {

  BrowseViewModel(this.movieRepository)
      : super(BrowseLoadingState());

  final MovieRepository movieRepository;

  List<Movies> allMovies = [];

  List<String> genres = [];

  int selectedIndex = 0;

  Future<void> getBrowseData() async {

    emit(BrowseLoadingState());

    try {

      final response =
      await movieRepository.getMovies();

      allMovies =
          response.data?.movies ?? [];

      /// extract genres
      Set<String> genresSet = {};

      for (var movie in allMovies) {

        genresSet.addAll(
          movie.genres ?? [],
        );
      }

      genres = genresSet.toList();

      emit(BrowseSuccessState());

    } catch (e) {

      emit(
        BrowseErrorState(
          e.toString(),
        ),
      );
    }
  }

  List<Movies> getMoviesByGenre() {

    if (genres.isEmpty) return [];

    final selectedGenre =
    genres[selectedIndex];

    return allMovies.where((movie) {

      return movie.genres?.contains(
        selectedGenre,
      ) ?? false;

    }).toList();
  }

  void changeSelectedIndex(int index) {

    selectedIndex = index;

    emit(BrowseSuccessState());
  }
  void resetBrowse() {
    selectedIndex = 0;
    emit(BrowseInitialState());
  }
}