import 'package:cineluxe/screens/browse_screen/logic/browse_view_model.dart';
import 'package:cineluxe/screens/browse_screen/ui/browse.dart';
import 'package:cineluxe/screens/forget_password_screen/logic/reset_view_model.dart';
import 'package:cineluxe/screens/forget_password_screen/ui/forget_password.dart';
import 'package:cineluxe/screens/home_screen/logic/movie_view_model.dart';
import 'package:cineluxe/screens/login_screen/logic/login_view_model.dart';
import 'package:cineluxe/screens/login_screen/ui/login.dart';
import 'package:cineluxe/screens/main_layout/main_layout.dart';
import 'package:cineluxe/screens/onboarding_screen/onboarding_screen.dart';
import 'package:cineluxe/screens/register_screen/logic/register_view_model.dart';
import 'package:cineluxe/screens/register_screen/ui/register.dart';
import 'package:cineluxe/screens/search_screen/logic/search_view_model.dart';
import 'package:cineluxe/screens/search_screen/ui/search_screen.dart';
import 'package:cineluxe/screens/splash/splash_screen.dart';
import 'package:cineluxe/screens/update_profile_screen/logic/update_profile_view_model.dart';
import 'package:cineluxe/screens/update_profile_screen/ui/Profile.dart';
import 'package:cineluxe/utils/app_routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'data/repository/auth/data_sources/remote/impl/auth_remote_data_source_impl.dart';
import 'data/repository/auth/repository/impl/auth_repository_impl.dart';
import 'data/repository/firestore/data_sources/remote/impl/user_remote_data_source_impl.dart';
import 'data/repository/firestore/repository/impl/user_repository_impl.dart';
import 'data/repository/movie_list/data_source/impl/movie_remote_data_souce_impl.dart';
import 'data/repository/movie_list/repository/impl/movie_repository_impl.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => LoginViewModel(
              AuthRepositoryImpl(
                AuthRemoteDataSourceImpl(FirebaseAuth.instance),
              ),
            ),
          ),
          BlocProvider(
            create: (context) => RegisterViewModel(
              AuthRepositoryImpl(
                AuthRemoteDataSourceImpl(FirebaseAuth.instance),
              ),
            ),
          ),
          BlocProvider(
            create: (context) => ResetViewModel(
              AuthRepositoryImpl(
                AuthRemoteDataSourceImpl(FirebaseAuth.instance),
              ),
            ),
          ),
          BlocProvider(
            create: (context) => MovieCubit(
              MovieRepositoryImpl(
                MovieRemoteDataSourceImpl(),
              ),
            ),
          ),
          BlocProvider(
            create: (context) => UserCubit(
              UserRepositoryImpl(
                UserRemoteDataSourceImpl(FirebaseFirestore.instance), ), )..loadUser(), ),


          BlocProvider(
            create: (context) => SearchViewModel(
              MovieRepositoryImpl(
                MovieRemoteDataSourceImpl(),
              ),
            ),
          ),

          BlocProvider(

            create: (context) => BrowseViewModel(

              MovieRepositoryImpl(
                MovieRemoteDataSourceImpl(),
              ),

            )..getBrowseData(),

            child: const Browse(),
          )

        ],
        child: const MyApp(),
      ),
    ),
  );

  Future.delayed(const Duration(milliseconds: 200), () {
    FlutterNativeSplash.remove();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'cineluxe',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splashScreen,

      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,

      routes: {
        AppRoutes.loginScreen: (context) => const Login(),
        AppRoutes.forgetPasswordScreen: (context) => const ForgetPassword(),
        AppRoutes.registerScreen: (context) => const Register(),
        AppRoutes.splashScreen: (context) => const SplashScreen(),
        AppRoutes.onboardingScreen: (context) => const OnBoardingPage(),
        AppRoutes.updateProfileScreen: (context) => UpdateProfileScreen(),
        AppRoutes.homeScreen: (context) => const MainLayout(),
        AppRoutes.searchScreen: (context) => const SearchScreen(),
      },
    );
  }
}