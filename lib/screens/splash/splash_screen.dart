import 'package:audioplayers/audioplayers.dart';
import 'package:cineluxe/screens/onboarding_screen/onboarding_screen.dart';
import 'package:flutter/material.dart';

import '../../core/services/app_startup_service.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late AnimationController brandController;

  late Animation<Offset> triangleMove;
  late Animation<double> triangleScale;
  late Animation<double> triangleOpacity;

  late Animation<double> textOpacity;

  late Animation<double> brandOpacity;
  late Animation<Offset> brandMove;
  late Animation<double> brandScale;
  final AudioPlayer player = AudioPlayer();

  String displayedText = "";
  final String fullText = "Cineluxe";

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    );

    brandController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    triangleMove = Tween<Offset>(
      begin: const Offset(-2.5, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOutCubic));

    triangleScale = Tween<double>(
      begin: 0.4,
      end: 1,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOutBack));

    triangleOpacity = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeIn));

    textOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.6, 1, curve: Curves.easeIn),
      ),
    );

    brandOpacity = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: brandController, curve: Curves.easeOut));

    brandMove = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: brandController, curve: Curves.easeOutExpo),
        );

    brandScale = Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(parent: brandController, curve: Curves.easeOutBack),
    );

    controller.forward();
    Future.delayed(const Duration(milliseconds: 100), () async {
      await player.play(AssetSource('sounds/splash_sound.mp3'));
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      typeWriter();
    });

    Future.delayed(const Duration(milliseconds: 700), () {
      brandController.forward();
    });

    //  Navigation
    Future.delayed(const Duration(milliseconds: 1800), () async {

    if (!mounted) return;

    await AppStartupService.handleStartup(context);

    });
  }

  void typeWriter() async {
    for (int i = 0; i < fullText.length; i++) {
      await Future.delayed(const Duration(milliseconds: 40));
      if (!mounted) return;
      setState(() {
        displayedText += fullText[i];
      });
    }
  }

  @override
  void dispose() {
    controller.dispose();
    brandController.dispose();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121312),
      body: SizedBox.expand(
        child: Column(
          children: [
            const Spacer(),

            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    FadeTransition(
                      opacity: triangleOpacity,
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFFFC107),
                            width: 4,
                          ),
                        ),
                      ),
                    ),

                    SlideTransition(
                      position: triangleMove,
                      child: FadeTransition(
                        opacity: triangleOpacity,
                        child: ScaleTransition(
                          scale: triangleScale,
                          child: CustomPaint(
                            size: const Size(90, 90),
                            painter: TriangleOutlinePainter(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                FadeTransition(
                  opacity: textOpacity,
                  child: Text(
                    displayedText,
                    style: const TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.italic,
                      letterSpacing: 2,
                      color: Color(0xFFFFC107),
                      shadows: [
                        Shadow(
                          blurRadius: 15,
                          color: Colors.black,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const Spacer(),

            FadeTransition(
              opacity: brandOpacity,
              child: SlideTransition(
                position: brandMove,
                child: ScaleTransition(
                  scale: brandScale,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Image.asset(
                      "assets/images/brand.png",
                      width: 180,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TriangleOutlinePainter extends CustomPainter {
  @override
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFFC107)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(size.width * 0.2, size.height * 0.15); // top
    path.lineTo(size.width * 0.85, size.height * 0.5); // right
    path.lineTo(size.width * 0.2, size.height * 0.85); // bottom
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
