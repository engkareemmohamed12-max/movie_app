import 'package:cineluxe/models/user_model.dart';

import '../../../../../models/movie_response.dart';
import '../../data_sources/remote/user_remote_data_source.dart';
import '../user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource userRemoteDataSource;
  UserRepositoryImpl(this.userRemoteDataSource);

  @override
  Future<UserModel> getCurrentUser() {
    return userRemoteDataSource.getCurrentUser();
  }

  @override
  Future<void> updateUser({
    required String name,
    required String phone,
    required String avatar,
  }) {
    return userRemoteDataSource.updateUser(
      name: name,
      phone: phone,
      avatar: avatar,
    );
  }

  @override
  Future<void> deleteUser() {
    return userRemoteDataSource.deleteUser();
  }
  @override
  Future<void> updateWatchlist(List<Movies> watchlist) {
    return userRemoteDataSource.updateWatchlist(watchlist);
  }
  @override
  Future<void> updateHistory(List<Movies> history) {
    return userRemoteDataSource.updateHistory(history);
  }
  @override
  Future<void> addMovieToWatchlist(Movies movie) {
    return userRemoteDataSource.addMovieToWatchlist(movie);
  }
  @override
  Future<void> addMovieToHistory(Movies movie) {
    return userRemoteDataSource.addMovieToHistory(movie);
  }
  @override
  Future<void> removeMovieFromWatchlist(int movieId) {
    return userRemoteDataSource.removeMovieFromWatchlist(movieId);
  }

}