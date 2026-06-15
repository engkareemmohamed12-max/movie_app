import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repository/movie_list/repository/movie_repository.dart';
import 'states/search_states.dart';

class SearchViewModel extends Cubit<SearchStates> {
  final MovieRepository repository;

  SearchViewModel(this.repository)
      : super(SearchMoviesInitialState());

  String? _lastQuery;

  Future<void> searchMovies(String query) async {
    final trimmed = query.trim();

    if (trimmed.isEmpty) {
      emit(SearchMoviesInitialState());
      return;
    }

    if (trimmed == _lastQuery) return;
    _lastQuery = trimmed;

    emit(SearchMoviesLoadingState());

    try {
      final response = await repository.searchMovies(trimmed);

      emit(
        SearchMoviesSuccessState(
          response.data?.movies ?? [],
        ),
      );
    } catch (e) {
      emit(SearchMoviesErrorState(e.toString()));
    }
  }

  void resetSearch() {
    _lastQuery = null;
    emit(SearchMoviesInitialState());
  }
}