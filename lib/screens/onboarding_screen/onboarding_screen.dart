import 'package:cineluxe/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:cineluxe/screens/login_screen/ui/login.dart';

import '../../prefs/is_seen.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_sizes.dart';
import '../../widgets/customized_elevated_button.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  int currentPage = 0;
  late PageController _controller;

  final List<Map<String, String>> data = const [
    {
      "image": "assets/images/OnBoarding1.png",
      "title": "Find Your Next Favorite Movie Here",
      "body":
          "Get access to a huge library of movies to suit all tastes. You will surely like it.",
    },
    {
      "image": "assets/images/OnBoarding2.png",
      "title": "Discover Movies",
      "body":
          "Explore a vast collection of movies in all qualities and genres. Find your next favorite film with ease.",
    },
    {
      "image": "assets/images/OnBoarding3.png",
      "title": "Explore All Genres",
      "body":
          "Discover movies from every genre, in all available qualities. Find something new and exciting to watch every day.",
    },
    {
      "image": "assets/images/OnBoarding4.png",
      "title": "Create Watchlist",
      "body":
          "Save movies to your watchlist to keep track of what you want to watch next. Enjoy films in various qualities and genres.",
    },
    {
      "image": "assets/images/OnBoarding5.png",
      "title": "Rate, Review, and Learn",
      "body":
          "Share your thoughts on the movies you've watched. Dive deep into film details and help others discover great movies with your reviews.",
    },
    {
      "image": "assets/images/OnBoarding6.png",
      "title": "Start Watching Now",
      "body": "Discover movies from every genre, in all available qualities.",
    },
  ];

  @override
  void initState() {
    _controller = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isFirst = currentPage == 0;
    bool isSecond = currentPage == 1;
    bool isLast = currentPage == data.length - 1;

    var height = context.height;
    var width = context.width;

    return Scaffold(
      body: PageView.builder(
        controller: _controller,
        itemCount: data.length,
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          setState(() => currentPage = index);
        },
        itemBuilder: (context, index) {
          var item = data[index];

          return Stack(
            children: [
              Positioned.fill(
                child: Image.asset(item["image"]!, fit: BoxFit.cover),
              ),

              /// gradient
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.9),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),

              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: width * 0.04,
                    vertical: height * 0.02,
                  ),
                  padding: EdgeInsets.all(width * 0.05),
                  decoration: BoxDecoration(
                    color: isFirst ? Colors.transparent : Colors.black,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /// Title
                      Text(
                        item["title"]!,
                        textAlign: TextAlign.center,
                        style: isFirst
                            ? AppStyles.medium36W400
                            : AppStyles.regular24W400,
                      ),

                      SizedBox(height: height * 0.015),

                      /// Body
                      if (!isLast)
                        Text(
                          item["body"]!,
                          textAlign: TextAlign.center,
                          style: isFirst
                              ? AppStyles.regular20W400
                              : AppStyles.regular20WhiteColorW400,
                        ),

                      SizedBox(height: height * 0.025),

                      /// Next / Explore / Finish
                      SizedBox(
                        width: double.infinity,
                        child: CustomizedElevatedButton(
                          onPressed: () async{
                            if (isLast) {
                              await IsSeen().setSeen(true);
                              if (!mounted) return;
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const Login(),
                                ),
                              );
                            } else {
                              _controller.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                          child: Text(
                            isFirst
                                ? "Explore Now"
                                : isLast
                                ? "Finish"
                                : "Next",
                            style: AppStyles.black20Bold,
                          ),
                        ),
                      ),

                      /// Back
                      if (!isFirst && !isSecond) ...[
                        SizedBox(height: height * 0.015),
                        SizedBox(
                          width: double.infinity,
                          child: CustomizedElevatedButton(
                            isOutlined: true,
                            onPressed: () {
                              _controller.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: Text("Back", style: AppStyles.yellow20Bold),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
