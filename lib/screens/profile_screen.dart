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
  // BARU: Controller untuk mengedit nama
  final TextEditingController _nameController = TextEditingController();
  bool _isEditing = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  // BARU: Fungsi untuk menampilkan Dialog Edit
  void _showEditProfileDialog(BuildContext context, String currentName) {
    _nameController.text = currentName;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.backgroundGrayLighter,
          title: Text(
            'Edit Profile',
            style: AppTextStyles.settingsItem.copyWith(
              color: AppColors.primaryPurpleDark,
            ),
          ),
          content: TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Display Name',
              hintText: 'Enter your name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.primaryPurpleDark),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryPurpleDark,
              ),
              onPressed: () async {
                final newName = _nameController.text.trim();
                if (newName.isNotEmpty) {
                  Navigator.pop(context); // Tutup dialog
                  await _updateName(newName);
                }
              },
              child: const Text('Save', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  // BARU: Logika memanggil Provider untuk update data
  Future<void> _updateName(String newName) async {
    setState(() => _isEditing = true);
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      // Asumsi: Di AuthProvider Anda ada method updateUserName
      // Jika belum ada, Anda perlu membuatnya (lihat catatan di bawah)
      await authProvider.updateUserName(newName);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to update: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isEditing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Gunakan listen: true (default) agar UI update otomatis saat nama berubah
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    // Ambil nama saat ini untuk ditampilkan
    final currentName =
        user?.userMetadata?['name'] ?? user?.email?.split('@')[0] ?? 'User';

    return Scaffold(
      backgroundColor: AppColors.primaryPurpleDark,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 25),
              Center(child: Text('Profile', style: AppTextStyles.pageTitle)),

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
                        child:
                            user?.userMetadata?['avatar_url'] != null
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
                            // Tampilkan Loading jika sedang proses save
                            if (_isEditing)
                              const Text(
                                'Updating...',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              )
                            else
                              Text(
                                currentName,
                                style: AppTextStyles.profileName,
                                overflow:
                                    TextOverflow
                                        .ellipsis, // Mencegah teks terlalu panjang
                              ),
                          ],
                        ),
                      ),

                      // BARU: Tombol Edit di ujung kanan kartu
                      IconButton(
                        onPressed:
                            () => _showEditProfileDialog(context, currentName),
                        icon: const Icon(
                          Icons.edit,
                          color: AppColors.primaryPurpleDark,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ),
              ),

              // Settings Items
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
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

  Widget _buildSettingsItem(
    String title, {
    Widget? trailing,
    VoidCallback? onTap,
  }) {
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
            Text(title, style: AppTextStyles.settingsItem),
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
