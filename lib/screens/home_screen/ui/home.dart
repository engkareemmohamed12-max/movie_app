import 'dart:ui';
import 'package:cineluxe/models/movie_response.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../utils/app_sizes.dart';
import '../../update_profile_screen/logic/update_profile_view_model.dart';
import '../logic/movie_states/movie_states.dart';
import '../logic/movie_view_model.dart';
import 'movie_details.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex = 0;
  @override
  void initState() {
    super.initState();
    context.read<UserCubit>().loadUser();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = context.height;
    var screenWidth = context.width;

    return Scaffold(
      body: Stack(
        children: [
          BlocBuilder<MovieCubit, MovieState>(
            builder: (context, state) {
              final movies = context.read<MovieCubit>().latestMovies ?? [];

              String? image;

              if (movies.isNotEmpty && currentIndex < movies.length) {
                image = movies[currentIndex].mediumCoverImage;
              }

              if (image == null || image.isEmpty) {
                return Container(color: Colors.black);
              }

              return Positioned.fill(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: Stack(
                    key: ValueKey(image),
                    fit: StackFit.expand,
                    children: [
                      Image.network(image, fit: BoxFit.cover),

                      BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                        child: Container(color: Colors.black.withOpacity(0.5)),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.02),
                  Image.asset(
                    'assets/images/Available Now.png',
                    width: screenWidth * 0.6,
                  ),
                  SizedBox(height: screenHeight * 0.02),

                  BlocBuilder<MovieCubit, MovieState>(
                    builder: (context, state) {
                      final cubit = context.read<MovieCubit>();
                      if (state is MovieLoading && cubit.latestMovies == null) {
                        return _buildLoading(300);
                      }

                      final movies = cubit.latestMovies ?? [];
                      return CarouselSlider.builder(
                        itemCount: movies.length,
                        options: CarouselOptions(
                          height: 300,
                          enlargeCenterPage: true,
                          viewportFraction: 0.75,
                          enableInfiniteScroll: true,
                          onPageChanged: (index, reason) {
                            setState(() {
                              currentIndex = index;
                            });
                          },
                        ),
                        itemBuilder: (context, index, realIndex) =>
                            _buildCarouselItem(movies[index], context),
                      );
                    },
                  ),

                  SizedBox(height: screenHeight * 0.02),
                  Image.asset(
                    'assets/images/Watch Now.png',
                    width: screenWidth * 0.5,
                  ),
                  SizedBox(height: screenHeight * 0.03),

                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          context
                              .watch<MovieCubit>()
                              .currentGenre
                              .toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'See More >',
                            style: TextStyle(color: Colors.orange),
                          ),
                        ),
                      ],
                    ),
                  ),

                  BlocBuilder<MovieCubit, MovieState>(
                    builder: (context, state) {
                      final cubit = context.read<MovieCubit>();
                      if (state is MovieLoading) return _buildLoading(150);

                      final movies = cubit.categoryMovies ?? [];
                      return SizedBox(
                        height: screenHeight * 0.2,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.04,
                          ),
                          itemCount: movies.length,
                          itemBuilder: (context, index) => _buildListItem(
                            movies[index],
                            screenWidth,
                            context,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoading(double height) => SizedBox(
    height: height,
    child: Center(
      child: LoadingAnimationWidget.staggeredDotsWave(
        color: Colors.yellow,
        size: 50,
      ),
    ),
  );

  Widget _buildCarouselItem(Movies movie, BuildContext context) =>
      GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MovieDetailsScreen(movieId: movie.id ?? 0),
            ),
          );
        },
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: NetworkImage(movie.mediumCoverImage ?? ''),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: 15,
              left: 15,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Text(
                      movie.rating?.toString() ?? '0',
                      style: const TextStyle(color: Colors.white),
                    ),
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  Widget _buildListItem(
    Movies movie,
    double screenWidth,
    BuildContext context,
  ) => GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MovieDetailsScreen(movieId: movie.id ?? 0),
        ),
      );
    },
    child: Container(
      width: screenWidth * 0.3,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          image: NetworkImage(movie.mediumCoverImage ?? ''),
          fit: BoxFit.cover,
        ),
      ),
    ),
  );
}
