import 'package:flutter/material.dart';
import 'package:formative_assignment1/data/session.dart';
import 'package:formative_assignment1/theme/app_theme.dart';
import 'package:formative_assignment1/ui/widgets/app_bottom_nav_bar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Session.currentUser;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0.5,
        automaticallyImplyLeading: false,
        title: Text('My Profile', style: AppTextStyles.headingLarge),
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

            // Avatar
            Center(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary,
                    width: AppSpacing.avatarBorderWidth,
                  ),
                  boxShadow: AppShadows.avatar,
                ),
                child: CircleAvatar(
                  radius: 52,
                  backgroundColor: AppColors.white,
                  backgroundImage: NetworkImage(
                    user?.avatarUrl ?? 'https://i.pravatar.cc/150?img=47',
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            Text(
              user?.fullName ?? '—',
              style: AppTextStyles.headingMedium,
            ),
            const SizedBox(height: AppSpacing.xs),

            // Campus badge
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(AppRadius.chip),
              ),
              child: Text(
                user?.campus ?? '—',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Stats
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
                    _statItem(
                      user?.eventIds.length.toString() ?? '0',
                      'Events',
                    ),
                    Container(
                      height: 30,
                      width: 1,
                      color: AppColors.cardBorder,
                    ),
                    _statItem(
                      user?.clubIds.length.toString() ?? '0',
                      'Communities',
                    ),
                    Container(
                      height: 30,
                      width: 1,
                      color: AppColors.cardBorder,
                    ),
                    _statItem(
                      user?.metadata['connects']?.toString() ?? '0',
                      'Connects',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Menu
            Container(
              margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadius.card),
                boxShadow: AppShadows.card,
              ),
              child: Column(
                children: [
                  _menuItem(
                    context,
                    Icons.chat_bubble_outline_rounded,
                    'My Posts',
                    () {},
                  ),
                  _divider(),
                  _menuItem(
                    context,
                    Icons.event_available_outlined,
                    'My RSVPs',
                    () => Navigator.pushNamed(context, '/rsvp'),
                  ),
                  _divider(),
                  _menuItem(
                    context,
                    Icons.bookmark_outline_rounded,
                    'Saved',
                    () {},
                  ),
                  _divider(),
                  _menuItem(
                    context,
                    Icons.notifications_outlined,
                    'Notifications',
                    () {},
                  ),
                  _divider(),
                  _menuItem(
                    context,
                    Icons.person_outline_rounded,
                    'Account Settings',
                    () {},
                  ),
                  _divider(),
                  _menuItem(
                    context,
                    Icons.help_outline_rounded,
                    'Help & Support',
                    () {},
                  ),
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

  Widget _statItem(String value, String label) {
    return Column(
      children: [
        Text(value, style: AppTextStyles.statValue),
        const SizedBox(height: AppSpacing.xs),
        Text(label, style: AppTextStyles.statLabel),
      ],
    );
  }

  Widget _menuItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
      title: Text(
        title,
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textDark,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios_rounded,
        color: AppColors.textMuted,
        size: 14,
      ),
      onTap: onTap,
    );
  }

  Widget _divider() => Divider(
    color: AppColors.cardBorder,
    height: 1,
    indent: AppSpacing.lg,
    endIndent: AppSpacing.lg,
  );
}
