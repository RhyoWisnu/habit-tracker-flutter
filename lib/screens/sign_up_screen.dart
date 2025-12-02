import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import 'sign_in_screen.dart';
import 'home_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _agreeToPrivacy = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (!_agreeToPrivacy) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please agree to the Privacy Policy')),
      );
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.signUpWithEmail(
      _emailController.text.trim(),
      _passwordController.text,
      _nameController.text.trim(),
    );

    if (success && mounted) {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authProvider.errorMessage ?? 'Sign up failed')),
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
                      'Create your account ',
                      style: AppTextStyles.welcomeTitle,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 50),

                    // OR LOG IN WITH EMAIL
                    Center(
                      child: Text(
                        'LOG IN WITH EMAIL',
                        style: AppTextStyles.rubikBold(
                          14,
                          AppColors.textSecondary,
                        ).copyWith(letterSpacing: 0.05),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Name Field
                    _buildTextField(
                      controller: _nameController,
                      hint: 'Name',
                      icon: null,
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
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
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

                    // Privacy Policy Checkbox
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _agreeToPrivacy = !_agreeToPrivacy;
                            });
                          },
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color:
                                    _agreeToPrivacy
                                        ? AppColors.primaryPurple
                                        : AppColors.borderDark,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(4),
                              color:
                                  _agreeToPrivacy
                                      ? AppColors.primaryPurple
                                      : Colors.transparent,
                            ),
                            child:
                                _agreeToPrivacy
                                    ? const Icon(
                                      Icons.check,
                                      color: AppColors.textWhite,
                                      size: 16,
                                    )
                                    : null,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'i have read the Privace Policy',
                            style: AppTextStyles.buttonText.copyWith(
                              color: AppColors.primaryPurple,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Get Started Button
                    _buildGetStartedButton(),
                    const SizedBox(height: 20),

                    // Sign In Link
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => const SignInScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'ALREADY HAVE AN ACCOUNT? SIGN IN',
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
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 22,
          ),
          suffixIcon: icon,
        ),
      ),
    );
  }

  Widget _buildGetStartedButton() {
    return Container(
      height: 59.29,
      decoration: BoxDecoration(
        color: AppColors.primaryPurple,
        borderRadius: BorderRadius.circular(35.76),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _signUp,
          borderRadius: BorderRadius.circular(35.76),
          child: Center(
            child: Text(
              'GET STARTED',
              style: AppTextStyles.rubikMedium(
                13.18,
                AppColors.textWhite,
              ).copyWith(letterSpacing: 0.05),
            ),
          ),
        ),
      ),
    );
  }
}
