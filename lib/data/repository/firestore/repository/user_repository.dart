import '../../../../models/movie_response.dart';
import '../../../../models/user_model.dart';

abstract class UserRepository {
  Future<UserModel> getCurrentUser();

  Future<void> updateUser({
    required String name,
    required String phone,
    required String avatar,
  });

  Future<void> deleteUser();
  Future<void> updateWatchlist(List<Movies> watchlist);
  Future<void> updateHistory(List<Movies> history);
  Future<void> addMovieToWatchlist(Movies movie);
  Future<void> addMovieToHistory(Movies movie);
  Future<void> removeMovieFromWatchlist(int movieId);

}