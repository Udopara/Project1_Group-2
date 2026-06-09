import 'package:flutter/material.dart';
import 'package:formative_assignment1/theme/app_theme.dart';
import 'package:formative_assignment1/data/dummy_database.dart';
import 'package:formative_assignment1/ui/widgets/app_bottom_nav_bar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch user data from the local dummy database
    final user = DummyDatabase.getUserById('usr_001');

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,

      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0.5,
        automaticallyImplyLeading: false,
        title: Text(
            'My Profile',
            style: AppTextStyles.headingLarge
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings_rounded, color: AppColors.textMedium),
            onPressed: () {},
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.xl),

            // Profile Image Section
            Center(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary, width: AppSpacing.avatarBorderWidth),
                  boxShadow: AppShadows.avatar,
                ),
                child: CircleAvatar(
                  radius: 52,
                  backgroundColor: AppColors.white,
                  backgroundImage: NetworkImage(user?.avatarUrl ?? 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=256'),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Student Identity Info
            Text(
              user?.fullName ?? 'Aline Umuhoza',
              style: AppTextStyles.headingMedium,
            ),
            const SizedBox(height: AppSpacing.xs),

            // Campus Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(AppRadius.chip),
              ),
              child: Text(
                user?.campus ?? 'Kigali Campus',
                style: AppTextStyles.labelSmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Statistics Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  boxShadow: AppShadows.card,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(user?.eventIds.length.toString() ?? '23', 'Events'),
                    Container(height: 30, width: 1, color: AppColors.cardBorder),
                    _buildStatItem(user?.clubIds.length.toString() ?? '5', 'Communities'),
                    Container(height: 30, width: 1, color: AppColors.cardBorder),
                    _buildStatItem(user?.metadata['connects']?.toString() ?? '87', 'Connections'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Options List Menu
            Container(
              margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadius.card),
                boxShadow: AppShadows.card,
              ),
              child: Column(
                children: [
                  _buildMenuItem(Icons.chat_bubble_outline_rounded, 'My Posts', () {}),
                  _buildDivider(),
                  _buildMenuItem(Icons.bookmark_outline_rounded, 'Saved', () {}),
                  _buildDivider(),
                  _buildMenuItem(Icons.notifications_outlined, 'Notifications', () {}),
                  _buildDivider(),
                  _buildMenuItem(Icons.person_outline_rounded, 'Account Settings', () {}),
                  _buildDivider(),
                  _buildMenuItem(Icons.help_outline_rounded, 'Help & Support', () {}),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),

      bottomNavigationBar: const AppBottomNavBar(currentIndex: 4),
    );
  }

  Widget _buildStatItem(String count, String label) {
    return Column(
      children: [
        Text(count, style: AppTextStyles.statValue),
        const SizedBox(height: AppSpacing.xs),
        Text(label, style: AppTextStyles.statLabel),
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
      title: Text(title, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textDark, fontWeight: FontWeight.w600)),
      trailing: Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textMuted, size: 14),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: AppColors.cardBorder,
      height: 1,
      indent: AppSpacing.lg,
      endIndent: AppSpacing.lg,
    );
  }
}