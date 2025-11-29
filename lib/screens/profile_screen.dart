import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _soundEnabled = true;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      backgroundColor: AppColors.primaryPurpleDark,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Padding(
                padding: const EdgeInsets.only(left: 169, top: 62),
                child: Text(
                  'Profile',
                  style: AppTextStyles.pageTitle,
                ),
              ),
              
              // Profile Card
              Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  width: double.infinity,
                  height: 86,
                  decoration: BoxDecoration(
                    color: AppColors.backgroundGrayLighter,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      // Profile Image
                      Container(
                        width: 60,
                        height: 60,
                        margin: const EdgeInsets.only(left: 16),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundGray,
                          shape: BoxShape.circle,
                        ),
                        child: user?.userMetadata?['avatar_url'] != null
                            ? ClipOval(
                                child: Image.network(
                                  user!.userMetadata!['avatar_url'],
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const Icon(
                                Icons.person,
                                size: 40,
                                color: AppColors.textSecondary,
                              ),
                      ),
                      const SizedBox(width: 10),
                      
                      // Name and ID
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?.userMetadata?['name'] ?? 
                              user?.email?.split('@')[0] ?? 
                              'User',
                              style: AppTextStyles.profileName,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user?.id ?? 'No ID',
                              style: AppTextStyles.profileId,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Settings Items
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _buildSettingsItem(
                      'Sound',
                      trailing: Switch(
                        value: _soundEnabled,
                        onChanged: (value) {
                          setState(() {
                            _soundEnabled = value;
                          });
                        },
                        activeColor: AppColors.primaryPurpleDark,
                      ),
                    ),
                    const SizedBox(height: 6),
                    _buildSettingsItem('Help'),
                    const SizedBox(height: 6),
                    _buildSettingsItem('Rate us'),
                    const SizedBox(height: 6),
                    _buildSettingsItem('Share app'),
                    const SizedBox(height: 6),
                    _buildSettingsItem(
                      'Logout',
                      onTap: () async {
                        await authProvider.signOut();
                        if (mounted) {
                          Navigator.of(context).pushReplacementNamed('/signin');
                        }
                      },
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsItem(String title, {Widget? trailing, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 68.47,
        decoration: BoxDecoration(
          color: AppColors.primaryPurpleAccent5,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 21.07, vertical: 22.38),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: AppTextStyles.settingsItem,
            ),
            trailing ??
                const Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.textSecondary,
                  size: 13.83,
                ),
          ],
        ),
      ),
    );
  }

}

