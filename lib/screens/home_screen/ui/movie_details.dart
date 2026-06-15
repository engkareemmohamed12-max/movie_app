import 'package:cineluxe/screens/update_profile_screen/logic/update_profile_view_model.dart';
import 'package:cineluxe/utils/app_assets.dart';
import 'package:cineluxe/utils/app_styles.dart';
import 'package:cineluxe/widgets/customized_elevated_button.dart';
import 'package:cineluxe/widgets/reusable_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_sizes.dart';
import '../../update_profile_screen/logic/states/update_profile_states.dart';
import '../logic/movie_view_model.dart';
import '../logic/movie_states/movie_states.dart';

class MovieDetailsScreen extends StatefulWidget {
  final int movieId;

  const MovieDetailsScreen({super.key, required this.movieId});

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  @override
  void initState() {
    super.initState();

    context.read<MovieCubit>().getMovieDetails(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    var height = context.height;
    var width = context.width;
    return Scaffold(
      backgroundColor: AppColors.blackColor,
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                color: AppColors.yellowColor,
                size: 50,
              ),
            );
          }
          if (state is UserLoaded) {
            final user = state.user;
            return BlocBuilder<MovieCubit, MovieState>(
              builder: (context, state) {
                if (state is MovieLoading) {
                  return Center(
                    child: LoadingAnimationWidget.staggeredDotsWave(
                      color: Colors.yellow,
                      size: 50,
                    ),
                  );
                }

                if (state is MovieDetailsSuccess) {
                  final movie = state.movie;
                  final userCubit = context.read<UserCubit>();

                  final isInWatchlist = userCubit.isMovieInWatchlist(
                    user,
                    movie.id!,
                  );

                  final isInHistory = userCubit.isMovieInHistory(
                    user,
                    movie.id!,
                  );
                  final suggestedList = state.suggestedMovies;

                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Image.network(
                              movie.largeCoverImage ?? '',
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: double.infinity,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.3),
                                        blurRadius: 12,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.broken_image,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                  ),
                                );
                              },
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: width * 0.04,
                                vertical: height * 0.04,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: Icon(Icons.arrow_back_ios),
                                    color: AppColors.yellowColor,
                                    iconSize: 30,
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      if (isInWatchlist) {
                                        await userCubit
                                            .removeMovieFromWatchlist(
                                              movie.id!,
                                            );
                                      } else {
                                        await userCubit.addMovieToWatchlist(
                                          movie,
                                        );
                                      }
                                    },
                                    icon: Icon(
                                      isInWatchlist
                                          ? Icons.bookmark
                                          : Icons.bookmark_border_outlined,
                                      color: AppColors.yellowColor,
                                    ),
                                    iconSize: 30,
                                  ),
                                ],
                              ),
                            ),
                            Positioned.fill(
                              child: Align(
                                alignment: Alignment.center,
                                child: Image.asset(AppAssets.watchLogo),
                              ),
                            ),
                            Positioned.fill(
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Text(
                                  movie.title ?? '',
                                  style: GoogleFonts.roboto(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: height * 0.01),
                        Center(
                          child: Text(
                            '${movie.year}',
                            style: AppStyles.grey20W700,
                          ),
                        ),
                        SizedBox(height: height * 0.02),
                        Center(
                          child: SizedBox(
                            width: width * 0.90,
                            child: CustomizedElevatedButton(
                              paddingHeight: 0.02,
                              backgroundColor: AppColors.redColor,
                              onPressed: () async {
                                if (!isInHistory) {
                                  await userCubit.addMovieToHistory(movie);
                                }
                              },
                              child: Text(
                                isInHistory ? 'Watched' : 'Watch',
                                style: AppStyles.grey20W700.copyWith(
                                  color: AppColors.whiteColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.02),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ReusableContainer(
                              icon: Image.asset(AppAssets.likes),
                              text: '15',
                            ),
                            ReusableContainer(
                              icon: Image.asset(AppAssets.clock),
                              text: "${movie.runtime}",
                            ),
                            ReusableContainer(
                              icon: Image.asset(AppAssets.star),
                              text: "${movie.rating}",
                            ),
                          ],
                        ),
                        SizedBox(height: height * 0.02),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.04,
                          ),
                          child: Text(
                            'Screen Shots',
                            style: AppStyles.white24W700,
                          ),
                        ),
                        SizedBox(height: height * 0.02),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.02,
                          ),
                          child: Column(
                            children: List.generate(
                              movie.screenshots.length > 3
                                  ? 3
                                  : movie.screenshots.length,
                              (index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.network(
                                      movie.screenshots[index],
                                      height: height * 0.25,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Container(
                                              height: height * 0.25,
                                              color: Colors.grey.shade300,
                                              child: const Center(
                                                child: Icon(Icons.broken_image),
                                              ),
                                            );
                                          },
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.04,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Similar', style: AppStyles.white24W700),

                              SizedBox(height: height * 0.02),

                              GridView.builder(
                                padding: EdgeInsetsGeometry.zero,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: suggestedList.length > 4
                                    ? 4
                                    : suggestedList.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: width * 0.04,
                                      mainAxisSpacing: height * 0.02,
                                      childAspectRatio: 0.65,
                                    ),
                                itemBuilder: (context, index) {
                                  final movie = suggestedList[index];

                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              child: Image.network(
                                                movie.mediumCoverImage ?? '',
                                                height: double.infinity,
                                                width: double.infinity,
                                                fit: BoxFit.cover,
                                                errorBuilder:
                                                    (
                                                      context,
                                                      error,
                                                      stackTrace,
                                                    ) {
                                                      return Container(
                                                        color: Colors.grey,
                                                        child: const Icon(
                                                          Icons.broken_image,
                                                        ),
                                                      );
                                                    },
                                              ),
                                            ),
                                            Positioned(
                                              top: 8,
                                              left: 8,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: Colors.black54,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      movie.rating
                                                              ?.toString() ??
                                                          '',
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 4),
                                                    const Icon(
                                                      Icons.star,
                                                      color: Colors.yellow,
                                                      size: 14,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      SizedBox(height: height * 0.01),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),

                        Padding(
                          padding: EdgeInsetsGeometry.symmetric(
                            horizontal: width * 0.04,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Summary', style: AppStyles.white24W700),

                              SizedBox(height: height * 0.01),

                              Text(
                                movie.descriptionFull ?? '',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: height * 0.01),

                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.04,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Cast', style: AppStyles.white24W700),

                              SizedBox(height: height * 0.01),

                              ListView.separated(
                                padding: EdgeInsets.zero,
                                itemCount: movie.cast?.length ?? 0,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                separatorBuilder: (_, __) =>
                                    SizedBox(height: height * 0.02),
                                itemBuilder: (context, index) {
                                  final cast = movie.cast?[index];
                                  if (cast == null) return const SizedBox();

                                  return Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1F1F1F),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: Colors.white12,
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            50,
                                          ),
                                          child: Image.network(
                                            cast.urlSmallImage ?? '',
                                            width: 70,
                                            height: 70,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                                  return Container(
                                                    width: 70,
                                                    height: 70,
                                                    color: Colors.grey,
                                                    child: const Icon(
                                                      Icons.person,
                                                      color: Colors.white,
                                                    ),
                                                  );
                                                },
                                          ),
                                        ),

                                        SizedBox(width: width * 0.04),

                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Name: ${cast.name ?? ''}',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),

                                              SizedBox(height: height * 0.005),

                                              Text(
                                                'Character: ${cast.characterName ?? ''}',
                                                style: TextStyle(
                                                  color: Colors.grey.shade400,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: height * 0.01),

                        Padding(
                          padding: EdgeInsetsGeometry.symmetric(
                            horizontal: width * 0.04,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Genres', style: AppStyles.white24W700),

                              SizedBox(height: height * 0.015),

                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children:
                                    movie.genres?.map((genre) {
                                      return Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 18,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF1F1F1F),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: Text(
                                          genre,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      );
                                    }).toList() ??
                                    [],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (state is MovieError) {
                  return Center(child: Text(state.message));
                }

                return const SizedBox();
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
