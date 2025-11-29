import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:habitracker/screens/splash_screen.dart';
import 'package:habitracker/screens/sign_in_screen.dart';
import 'package:habitracker/providers/auth_provider.dart';
import 'package:habitracker/providers/habit_provider.dart';
import 'package:habitracker/utils/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  // TODO: Replace with your Supabase credentials
  await Supabase.initialize(
    url:
        'https://lvtylucyjpvyftxfcnsh.supabase.co', // Replace with your Supabase URL
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imx2dHlsdWN5anB2eWZ0eGZjbnNoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM3OTE4ODUsImV4cCI6MjA3OTM2Nzg4NX0.PKIhNeK7eznhKxHZq-Nof31M5PgjZR5nO0vBQRlvXTA', // Replace with your Supabase anon key
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => HabitProvider()),
      ],
      child: MaterialApp(
        title: 'Habitracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: AppColors.primaryPurple,
          scaffoldBackgroundColor: AppColors.backgroundLight,
          fontFamily: 'Rubik',
          useMaterial3: true,
        ),
        home: const SplashScreen(),
        routes: {
          '/signin': (context) => const SignInScreen(),
        },
      ),
    );
  }
}
