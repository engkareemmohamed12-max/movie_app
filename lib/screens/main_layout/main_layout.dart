import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:cineluxe/screens/home_screen/ui/home.dart';
import 'package:cineluxe/screens/search_screen/ui/search_screen.dart';
import 'package:cineluxe/screens/browse_screen/ui/browse.dart';
import 'package:cineluxe/screens/profile_screen/ui/profile_details.dart';

import '../../utils/app_assets.dart';
import '../../utils/app_colors.dart';
import '../home_screen/logic/movie_view_model.dart';
import '../search_screen/logic/search_view_model.dart';
import '../browse_screen/logic/browse_view_model.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    Home(),
    SearchScreen(),
    Browse(),
    ProfileDetails(),
  ];

  void _onTabChanged(int index) {
    if (_currentIndex == index) return;

    ///  Search
    if (_currentIndex == 1) {
      context.read<SearchViewModel>().resetSearch();
    }

    ///  Browse
    if (_currentIndex == 2) {
      context.read<BrowseViewModel>().resetBrowse();
    }

    setState(() {
      _currentIndex = index;
    });

    ///  refresh Home
    if (index == 0) {
      context.read<MovieCubit>().getRandomMovies();
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),

      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),

      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          left: width * 0.02,
          right: width * 0.02,
          bottom: height * 0.01,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: _onTabChanged,
            type: BottomNavigationBarType.fixed,
            backgroundColor: const Color(0xFF282A28),
            selectedItemColor: AppColors.yellowColor,
            unselectedItemColor: Colors.grey,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: const [
              BottomNavigationBarItem(
                icon: ImageIcon(AssetImage(AppAssets.homeLogo)),
                activeIcon: ImageIcon(AssetImage(AppAssets.home1Logo)),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: ImageIcon(AssetImage(AppAssets.searchLogo)),
                activeIcon: ImageIcon(AssetImage(AppAssets.search1Logo)),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: ImageIcon(AssetImage(AppAssets.exploreLogo)),
                activeIcon: ImageIcon(AssetImage(AppAssets.explore1Logo)),
                label: 'Browse',
              ),
              BottomNavigationBarItem(
                icon: ImageIcon(AssetImage(AppAssets.profileLogo)),
                activeIcon: ImageIcon(AssetImage(AppAssets.profile1Logo)),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}