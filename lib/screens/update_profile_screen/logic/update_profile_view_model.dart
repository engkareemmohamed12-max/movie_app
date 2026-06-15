import 'package:cineluxe/screens/update_profile_screen/logic/states/update_profile_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repository/firestore/repository/user_repository.dart';
import '../../../models/movie_response.dart';
import '../../../models/user_model.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository repository;

  UserCubit(this.repository) : super(UserInitial());

  Future<void> loadUser() async {
    emit(UserLoading());

    try {
      final user = await repository.getCurrentUser();
      emit(UserLoaded(user));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> updateUser({
    required String name,
    required String phone,
    required String avatar,
  }) async {
    emit(UserLoading());

    try {
      await repository.updateUser(name: name, phone: phone, avatar: avatar);

      emit(UserUpdated());
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> deleteUser() async {
    emit(UserLoading());

    try {
      await repository.deleteUser();
      emit(UserDeleted());
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> updateWatchlist(List<Movies> watchlist) async {
    emit(UserLoading());
    try {
      await repository.updateWatchlist(watchlist);
      final user = await repository.getCurrentUser();
      emit(UserLoaded(user));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> updateHistory(List<Movies> history) async {
    emit(UserLoading());
    try {
      await repository.updateHistory(history);
      final user = await repository.getCurrentUser();
      emit(UserLoaded(user));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> addMovieToWatchlist(Movies movie) async {
    try {
      await repository.addMovieToWatchlist(movie);

      final user = await repository.getCurrentUser();

      emit(UserLoaded(user));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> addMovieToHistory(Movies movie) async {
    try {
      await repository.addMovieToHistory(movie);
      final user = await repository.getCurrentUser();
      emit(UserLoaded(user));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> removeMovieFromWatchlist(int movieId) async {
    try {
      await repository.removeMovieFromWatchlist(movieId);
      final user = await repository.getCurrentUser();
      emit(UserLoaded(user));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  bool isMovieInWatchlist(UserModel user, int movieId) {
    return user.watchlist?.any((movie) => movie.id == movieId) ?? false;
  }

  bool isMovieInHistory(UserModel user, int movieId) {
    return user.history?.any((movie) => movie.id == movieId) ?? false;
  }
}
