import 'package:cineluxe/models/movie_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_sizes.dart';
import '../../../utils/app_styles.dart';
import '../../home_screen/ui/movie_details.dart';
import '../logic/browse_states/browse_states.dart';
import '../logic/browse_view_model.dart';

class Browse extends StatelessWidget {
  const Browse({super.key});

  @override
  Widget build(BuildContext context) {
    var width = context.width;
    var height = context.height;

    var vm = context.read<BrowseViewModel>();

    return BlocBuilder<BrowseViewModel, BrowseStates>(
      builder: (context, state) {

        if (state is BrowseLoadingState) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is BrowseErrorState) {
          return Scaffold(
            body: Center(
              child: Text(
                state.error,
                style: AppStyles.white16W400,
              ),
            ),
          );
        }

        final List<Movies> movies = vm.getMoviesByGenre();

        return Scaffold(
          backgroundColor: AppColors.bgColor,

          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.02,
                vertical: height * 0.02,
              ),
              child: Column(
                children: [

                  /// GENRES
                  SizedBox(
                    height: height * 0.06,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: vm.genres.length,
                      separatorBuilder: (_, __) =>
                          SizedBox(width: width * 0.02),
                      itemBuilder: (context, index) {
                        final isSelected = vm.selectedIndex == index;

                        return InkWell(
                          onTap: () {
                            vm.changeSelectedIndex(index);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: width * 0.04,
                              vertical: height * 0.013,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),

                              ///  COLOR STYLE RESTORED
                              color: isSelected
                                  ? AppColors.yellowColor
                                  : AppColors.blackColor,

                              border: Border.all(
                                color: AppColors.yellowColor,
                                width: 2,
                              ),
                            ),
                            child: Text(
                              vm.genres[index],

                              ///  TEXT STYLE RESTORED
                              style: isSelected
                                  ? AppStyles.black20bold.copyWith(
                                fontSize: 16,
                              )
                                  : AppStyles.yellow20bold.copyWith(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: height * 0.02),

                  /// MOVIES
                  Expanded(
                    child: GridView.builder(
                      itemCount: movies.length,
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.65,
                      ),
                      itemBuilder: (context, index) {
                        final movie = movies[index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MovieDetailsScreen(
                                  movieId: movie.id ?? 0,
                                ),
                              ),
                            );
                          },
                          child: Stack(
                            children: [

                              /// IMAGE
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      movie.mediumCoverImage ?? '',
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),

                              /// RATING
                              Positioned(
                                top: 10,
                                left: 10,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        movie.rating.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}