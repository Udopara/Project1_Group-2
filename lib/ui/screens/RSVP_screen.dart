import 'package:flutter/material.dart';
import 'package:formative_assignment1/data/dummy_database.dart';
import 'package:formative_assignment1/data/session.dart';
import 'package:formative_assignment1/theme/app_theme.dart';
import 'package:formative_assignment1/ui/widgets/app_bottom_nav_bar.dart';

class RSVP extends StatefulWidget {
  const RSVP({super.key});

  @override
  State<RSVP> createState() => _RSVPState();
}

class _RSVPState extends State<RSVP> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final userId = Session.currentUser?.id ?? 'usr_001';
    final events = DummyDatabase.getEventsByUser(userId);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: Session.currentUser?.avatarUrl != null
                  ? NetworkImage(Session.currentUser!.avatarUrl)
                  : null,
              backgroundColor: AppColors.primaryLight,
              child: Session.currentUser?.avatarUrl == null
                  ? Text(
                      Session.currentUser?.fullName.substring(0, 1) ?? 'A',
                      style: AppTextStyles.labelMedium.copyWith(color: AppColors.primary),
                    )
                  : null,
            ),
            SizedBox(width: AppSpacing.md),
            Text(
              "ALU Intercampus",
              style: AppTextStyles.headingSmall.copyWith(color: AppColors.primary),
            ),
          ],
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: AppColors.primary),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg, AppSpacing.xl, AppSpacing.lg, AppSpacing.sm,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("My RSVPs", style: AppTextStyles.headingLarge),
                SizedBox(height: AppSpacing.xs),
                Text(
                  "Manage your upcoming campus experiences.",
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted),
                ),
                SizedBox(height: AppSpacing.lg),
                _TabBar(
                  selectedIndex: _selectedTab,
                  onTabChanged: (i) => setState(() => _selectedTab = i),
                ),
              ],
            ),
          ),
          Expanded(
            child: events.isEmpty
                ? Center(
                    child: Text(
                      "No events yet.",
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.sm,
                    ),
                    itemCount: events.length,
                    separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.lg),
                    itemBuilder: (_, index) => _EventCard(event: events[index]),
                  ),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 0),
    );
  }
}

//TabBar

class _TabBar extends StatelessWidget {
  const _TabBar({required this.selectedIndex, required this.onTabChanged});

  final int selectedIndex;
  final ValueChanged<int> onTabChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          _TabItem(
            label: 'Going',
            selected: selectedIndex == 0,
            onTap: () => onTabChanged(0),
          ),
          _TabItem(
            label: 'Interested',
            selected: selectedIndex == 1,
            onTap: () => onTabChanged(1),
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.labelMedium.copyWith(
              color: selected ? AppColors.white : AppColors.textMuted,
            ),
          ),
        ),
      ),
    );
  }
}

//Event Card

class _EventCard extends StatelessWidget {
  const _EventCard({required this.event});

  final EventModel event;

  String _formatDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '${months[dt.month - 1]} ${dt.day} • $hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppRadius.card),
            ),
            child: Stack(
              children: [
                Image.network(
                  event.bannerUrl,
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    height: 180,
                    color: AppColors.primaryLight,
                  ),
                ),
                Positioned(
                  bottom: AppSpacing.md,
                  left: AppSpacing.md,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                    child: Text(
                      'GOING',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: AppSpacing.md,
                  right: AppSpacing.md,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: Color(0x44000000),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite_border,
                      color: AppColors.white,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event.title, style: AppTextStyles.headingSmall),
                SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.textMuted),
                    SizedBox(width: AppSpacing.xs),
                    Text(_formatDate(event.startDate), style: AppTextStyles.caption),
                  ],
                ),
                SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textMuted),
                    SizedBox(width: AppSpacing.xs),
                    Expanded(
                      child: Text(
                        event.location,
                        style: AppTextStyles.caption,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.xs),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
