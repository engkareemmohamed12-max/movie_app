import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../utils/app_assets.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_routes.dart';
import '../../../utils/app_sizes.dart';
import '../../../widgets/customized_elevated_button.dart';
import '../../update_profile_screen/logic/states/update_profile_states.dart';
import '../../update_profile_screen/logic/update_profile_functions.dart';
import '../../update_profile_screen/logic/update_profile_view_model.dart';

class ProfileDetails extends StatefulWidget {
  const ProfileDetails({super.key});

  @override
  State<ProfileDetails> createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  String avatar = "";
  String name = '';

  @override
  Widget build(BuildContext context) {
    var width = context.width;
    var height = context.height;

    List<Widget> twoTabs = [
      Column(
        children: [
          ImageIcon(
            AssetImage(AppAssets.watchlistLogo),
            size: 40,
            color: AppColors.yellowColor,
          ),
          Text('Watch List',
              style: TextStyle(color: Colors.white, fontSize: 20)),
        ],
      ),
      Column(
        children: [
          ImageIcon(
            AssetImage(AppAssets.historyLogo),
            size: 40,
            color: AppColors.yellowColor,
          ),
          Text('History',
              style: TextStyle(color: Colors.white, fontSize: 20)),
        ],
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF282A28).withValues(alpha: 0.95),
      body: SafeArea(
        child: BlocConsumer<UserCubit, UserState>(
          listener: (context, state) {
            if (state is UserLoaded) {
              avatar = state.user.avatar ?? "";
              name = state.user.name ?? "";
            }
          },
          builder: (context, state) {
            if (state is UserLoading) {
              return Center(child: LoadingAnimationWidget.staggeredDotsWave(
                color: AppColors.yellowColor,
                size: 50,
              ),);
            }

            if (state is UserError) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }

            if (state is UserLoaded) {
              final user = state.user;
              final watchlist = user.watchlist ?? [];
              final history = user.history ?? [];

              return DefaultTabController(
                length: 2,
                child: NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      SliverOverlapAbsorber(
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                        sliver: SliverAppBar(
                          expandedHeight: height * 0.40,
                          pinned: true,
                          backgroundColor:
                          const Color(0xFF282A28).withValues(alpha: 0.95),
                        
                          flexibleSpace: FlexibleSpaceBar(
                            background: Column(
                              children: [
                                SizedBox(height: height * 0.06),
                        
                                // ================= HEADER (نفس تصميمك) =================
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width * 0.04),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          Container(
                                            width: width * 0.28,
                                            height: width * 0.28,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                            ),
                                            child: ClipOval(
                                              child: avatar.isNotEmpty
                                                  ? Image.asset(
                                                UpdateProfileFunctions
                                                    .getAvatarPath(
                                                    avatar),
                                                fit: BoxFit.cover,
                                              )
                                                  : const Icon(
                                                Icons.person,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            name,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 20),
                                          ),
                                        ],
                                      ),
                        
                                      Column(
                                        children: [
                                          Text(
                                            '${watchlist.length}',
                                            style: GoogleFonts.roboto(
                                              fontSize: 36,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            'Watchlist',
                                            style: GoogleFonts.roboto(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                        
                                      Column(
                                        children: [
                                          Text(
                                            '${history.length}',
                                            style: GoogleFonts.roboto(
                                              fontSize: 36,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            'History',
                                            style: GoogleFonts.roboto(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                        
                                SizedBox(height: height * 0.02),
                        
                                // ================= BUTTONS =================
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width * 0.04),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: CustomizedElevatedButton(
                                          paddingHeight: 0.02,
                                          onPressed: () async {
                                            await Navigator.pushNamed(
                                              context,
                                              AppRoutes.updateProfileScreen,
                                            );
                                            context.read<UserCubit>().loadUser();
                                          },
                                          child: Text(
                                            'Edit Profile',
                                            style: GoogleFonts.roboto(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.bgColor,
                                            ),
                                          ),
                                        ),
                                      ),
                        
                                      SizedBox(width: width * 0.02),
                        
                                      Expanded(
                                        flex: 1,
                                        child: CustomizedElevatedButton(
                                          backgroundColor: AppColors.redColor,
                                          paddingHeight: 0.02,
                                          onPressed: () {
                                            FirebaseAuth.instance.signOut();
                                            Navigator.pushReplacementNamed(
                                              context,
                                              AppRoutes.loginScreen,
                                            );
                                          },
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Exit',
                                                style: GoogleFonts.roboto(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              SizedBox(width: width * 0.02),
                                              Icon(Icons.logout, color: Colors.white),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ),
                              ],
                            ),
                          ),
                        
                          bottom: TabBar(
                            dividerColor: Colors.transparent,
                            indicatorColor: AppColors.yellowColor,
                            indicatorSize: TabBarIndicatorSize.tab,
                            tabs: twoTabs,
                          ),
                        ),
                      ),
                    ];
                  },

                  // ================= TAB CONTENT =================
                  body: Builder(
                    builder: (context)=>TabBarView(
                      children: [
                        Container(
                          color: AppColors.bgColor,
                          child: watchlist.isEmpty
                              ? Center(
                            child: Image.asset(AppAssets.popcorn),
                          )
                              : CustomScrollView(
                            slivers: [

                              SliverOverlapInjector(
                                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                              ),

                              SliverPadding(
                                padding: EdgeInsets.only(
                                  top: height * 0.02,
                                  left: width * 0.04,
                                  right: width * 0.04,
                                  bottom: height * 0.02,
                                ),

                                sliver: SliverGrid(
                                  delegate: SliverChildBuilderDelegate(
                                        (context, index) {
                                      final movie = watchlist[index];

                                      return Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(16),
                                            child: Image.network(
                                              movie.mediumCoverImage ?? '',
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              height: double.infinity,
                                            ),
                                          ),

                                          Positioned(
                                            top: 8,
                                            left: 8,
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.black.withValues(alpha: 0.7),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    '${movie.rating}',
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 3),
                                                  const Icon(
                                                    Icons.star,
                                                    color: Colors.yellow,
                                                    size: 16,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },

                                    childCount: watchlist.length,
                                  ),

                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: width * 0.03,
                                    mainAxisSpacing: height * 0.02,
                                    childAspectRatio: 0.62,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ),

                        Container(
                          color: AppColors.bgColor,
                          child: history.isEmpty
                              ? Center(
                            child: Image.asset(AppAssets.popcorn),
                          )
                              : CustomScrollView(
                            slivers: [

                              SliverOverlapInjector(
                                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                              ),

                              SliverPadding(
                                padding: EdgeInsets.only(
                                  top: height * 0.02,
                                  left: width * 0.04,
                                  right: width * 0.04,
                                  bottom: height * 0.02,
                                ),

                                sliver: SliverGrid(
                                  delegate: SliverChildBuilderDelegate(
                                        (context, index) {
                                      final movie = history[index];

                                      return Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(16),
                                            child: Image.network(
                                              movie.mediumCoverImage ?? '',
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              height: double.infinity,
                                            ),
                                          ),

                                          Positioned(
                                            top: 8,
                                            left: 8,
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.black.withValues(alpha: 0.7),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    '${movie.rating}',
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 3),
                                                  const Icon(
                                                    Icons.star,
                                                    color: Colors.yellow,
                                                    size: 16,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },

                                    childCount: watchlist.length,
                                  ),

                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: width * 0.03,
                                    mainAxisSpacing: height * 0.02,
                                    childAspectRatio: 0.62,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
