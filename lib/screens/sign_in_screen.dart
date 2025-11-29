import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import 'sign_up_screen.dart';
import 'home_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.signInWithEmail(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (success && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authProvider.errorMessage ?? 'Sign in failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.textWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              // Background decorative elements
              Positioned(
                left: -101,
                top: 92,
                child: Container(
                  width: 255,
                  height: 258,
                  decoration: const BoxDecoration(
                    color: AppColors.backgroundBeige,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              
              // Content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 133),
                    Text(
                      'Welcome Back!',
                      style: AppTextStyles.welcomeTitle,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 50),
                    
                    // Google Sign In Button
                    _buildGoogleButton(),
                    const SizedBox(height: 20),
                    
                    // OR LOG IN WITH EMAIL
                    Center(
                      child: Text(
                        'OR LOG IN WITH EMAIL',
                        style: AppTextStyles.rubikBold(14, AppColors.textSecondary)
                            .copyWith(letterSpacing: 0.05),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Email Field
                    _buildTextField(
                      controller: _emailController,
                      hint: 'Email address',
                      icon: null,
                    ),
                    const SizedBox(height: 20),
                    
                    // Password Field
                    _buildTextField(
                      controller: _passwordController,
                      hint: 'Password',
                      icon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                          color: AppColors.textSecondary,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      obscureText: _obscurePassword,
                    ),
                    const SizedBox(height: 20),
                    
                    // Forgot Password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // TODO: Implement forgot password
                        },
                        child: Text(
                          'Forgot Password?',
                          style: AppTextStyles.buttonText.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Log In Button
                    _buildLogInButton(),
                    const SizedBox(height: 20),
                    
                    // Facebook Button
                    _buildFacebookButton(),
                    const SizedBox(height: 20),
                    
                    // Sign Up Link
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const SignUpScreen()),
                          );
                        },
                        child: Text(
                          "DON'T HAVE AN ACCOUNT? SIGN UP",
                          style: AppTextStyles.buttonText.copyWith(
                            color: AppColors.textBlack,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    Widget? icon,
    bool obscureText = false,
  }) {
    return Container(
      height: 63,
      decoration: BoxDecoration(
        color: AppColors.backgroundGray,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: AppTextStyles.inputLabel.copyWith(color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTextStyles.inputLabel,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
          suffixIcon: icon,
        ),
      ),
    );
  }

  Widget _buildGoogleButton() {
    return Container(
      height: 63,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderGray, width: 1),
        borderRadius: BorderRadius.circular(38),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            final authProvider = Provider.of<AuthProvider>(context, listen: false);
            await authProvider.signInWithGoogle();
          },
          borderRadius: BorderRadius.circular(38),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Google icon placeholder
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(Icons.g_mobiledata, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                'CONTINUE WITH GOOGLE',
                style: AppTextStyles.buttonText,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFacebookButton() {
    return Container(
      height: 63,
      decoration: BoxDecoration(
        color: AppColors.primaryPurpleAccent6,
        borderRadius: BorderRadius.circular(38),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            final authProvider = Provider.of<AuthProvider>(context, listen: false);
            await authProvider.signInWithFacebook();
          },
          borderRadius: BorderRadius.circular(38),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.facebook, color: AppColors.textWhite, size: 24),
              const SizedBox(width: 12),
              Text(
                'CONTINUE WITH FACEBOOK',
                style: AppTextStyles.buttonText.copyWith(
                  color: AppColors.textWhite,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogInButton() {
    return Container(
      height: 63,
      decoration: BoxDecoration(
        color: AppColors.primaryPurple,
        borderRadius: BorderRadius.circular(35.76),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _signIn,
          borderRadius: BorderRadius.circular(35.76),
          child: Center(
            child: Text(
              'LOG IN',
              style: AppTextStyles.rubikMedium(13.18, AppColors.textWhite)
                  .copyWith(letterSpacing: 0.05),
            ),
          ),
        ),
      ),
    );
  }

}



