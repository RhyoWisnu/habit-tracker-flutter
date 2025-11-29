import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import 'sign_in_screen.dart';
import 'home_screen.dart';
import 'dart:math' as math;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  void _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.isAuthenticated) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      // Note: Usually we stay on splash screen or go to SignIn.
      // If you want the button to be the only way to navigate, remove this else block.
      // For auto-redirect:
      /*
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const SignInScreen()),
      );
      */
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primaryPurple, AppColors.primaryPurple],
          ),
        ),
        child: Stack(
          children: [
            // Decorative circles
            Positioned(
              left: -39,
              top: 369,
              child: Container(
                width: 492,
                height: 492,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.purpleGradient,
                ),
              ),
            ),
            Positioned(
              left: -4,
              top: 404,
              child: Container(
                width: 422,
                height: 422,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.purpleGradient2,
                ),
              ),
            ),
            Positioned(
              left: 30,
              top: 438,
              child: Container(
                width: 354,
                height: 354,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.purpleGradient3,
                ),
              ),
            ),
            Positioned(
              left: 65,
              top: 473,
              child: Container(
                width: 284,
                height: 284,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryPurpleAccent,
                ),
              ),
            ),

            // Decorative vectors
            Positioned(
              right: 96,
              top: 410,
              child: CustomPaint(
                size: const Size(36, 14),
                painter: _VectorPainter(),
              ),
            ),
            Positioned(
              left: 53,
              top: 432,
              child: CustomPaint(
                size: const Size(22, 8),
                painter: _VectorPainter(),
              ),
            ),

            // Bottom rectangle
            Positioned(
              left: -2,
              bottom: 0,
              child: Container(
                width: 416,
                height: 266,
                decoration: const BoxDecoration(
                  color: AppColors.primaryPurpleAccent3,
                ),
              ),
            ),

            // Content
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 205),
                Text(
                  'Habitracker',
                  style: AppTextStyles.splashTitle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 49),
                  child: Text(
                    'Explore the app, Find some peace of mind to achive good habits.',
                    style: AppTextStyles.splashSubtitle,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 100),
                // Image placeholder - replace with actual image
                Image.asset(
                  'assets/images/splash_image.png',
                  width: 164,
                  height: 164,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 164,
                      height: 164,
                      color: Colors.white.withOpacity(0.2),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image_not_supported, color: Colors.white, size: 40),
                          SizedBox(height: 8),
                          Text("Image not found", style: TextStyle(color: Colors.white, fontSize: 10))
                        ],
                      ),
                    );
                  },
                ),
                const Spacer(),
                // Get Started Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const SignInScreen()),
                      );
                    },
                    child: Container(
                      width: 374,
                      height: 63,
                      decoration: BoxDecoration(
                        color: AppColors.textWhite,
                        borderRadius: BorderRadius.circular(38),
                      ),
                      child: Center(
                        child: Text(
                          'GET STARTED',
                          style: AppTextStyles.buttonText,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                // Home indicator line
                Container(
                  width: 143,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColors.borderLight,
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
                const SizedBox(height: 14),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _VectorPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.accentBlue
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
