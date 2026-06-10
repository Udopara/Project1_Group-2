import 'package:flutter/material.dart';
import 'package:formative_assignment1/data/dummy_database.dart';
import 'package:formative_assignment1/data/session.dart';
import 'package:formative_assignment1/theme/app_theme.dart';
import 'package:formative_assignment1/ui/widgets/app_bottom_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCategory = 0;

  final List<String> _categories = [
    'All',
    'Events',
    'Opportunities',
    'Clubs',
    'Academic',
  ];

  final List<IconData> _categoryIcons = [
    Icons.apps_rounded,
    Icons.event_rounded,
    Icons.work_outline_rounded,
    Icons.groups_rounded,
    Icons.school_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    final user = Session.currentUser;
    final firstName = user?.fullName.split(' ').first ?? 'Student';
    final events = DummyDatabase.events;
    final featuredEvent = events.isNotEmpty ? events[1] : null; // Pitch Night

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top App Bar ──────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.lg,
                AppSpacing.sm,
              ),
              child: Row(
                children: [
                  // Avatar + org name
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary,
                      boxShadow: AppShadows.avatar,
                    ),
                    child: ClipOval(
                      child: user?.avatarUrl != null
                          ? Image.network(
                              user!.avatarUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _avatarFallback(
                                firstName,
                              ),
                            )
                          : _avatarFallback(firstName),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'ALU Intercampus',
                    style: AppTextStyles.headingSmall,
                  ),
                  const Spacer(),
                  // Notification bell
                  Stack(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.notifications_none_rounded,
                          size: 26,
                        ),
                        color: AppColors.textDark,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: AppColors.error,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.scaffoldBg,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ── Scrollable body ──────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSpacing.md),

                    // ── Greeting ─────────────────────────────────────
                    Row(
                      children: [
                        Text(
                          'Hi, $firstName! ',
                          style: AppTextStyles.displayLarge,
                        ),
                        const Text('👋', style: TextStyle(fontSize: 28)),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      "What's happening today?",
                      style: AppTextStyles.bodyMedium,
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // ── Search bar ───────────────────────────────────
                    Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(AppRadius.input),
                        border: Border.all(color: AppColors.cardBorder),
                        boxShadow: AppShadows.card,
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: AppSpacing.lg),
                          Icon(
                            Icons.search_rounded,
                            color: AppColors.textMuted,
                            size: 20,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            'Search opportunities, events, people…',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // ── Category chips ───────────────────────────────
                    SizedBox(
                      height: 72,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _categories.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(width: AppSpacing.sm),
                        itemBuilder: (context, i) {
                          final selected = _selectedCategory == i;
                          return GestureDetector(
                            onTap: () =>
                                setState(() => _selectedCategory = i),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 52,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: selected
                                        ? AppColors.primary
                                        : AppColors.white,
                                    borderRadius: BorderRadius.circular(
                                      AppRadius.md,
                                    ),
                                    border: Border.all(
                                      color: selected
                                          ? AppColors.primary
                                          : AppColors.cardBorder,
                                    ),
                                    boxShadow:
                                        selected ? AppShadows.card : null,
                                  ),
                                  child: Icon(
                                    _categoryIcons[i],
                                    color: selected
                                        ? AppColors.white
                                        : AppColors.textMuted,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _categories[i],
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: selected
                                        ? AppColors.primary
                                        : AppColors.textMuted,
                                    fontWeight: selected
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // ── Featured section ─────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Featured', style: AppTextStyles.headingMedium),
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'See all',
                            style: AppTextStyles.labelMedium.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Featured event card
                    if (featuredEvent != null)
                      _FeaturedEventCard(event: featuredEvent),
                    const SizedBox(height: AppSpacing.xl),

                    // ── Latest Opportunities ─────────────────────────
                    Text(
                      'Latest Opportunities',
                      style: AppTextStyles.headingMedium,
                    ),
                    const SizedBox(height: AppSpacing.md),

                    _OpportunityTile(
                      icon: '🌿',
                      iconBg: const Color(0xFFE8F5E9),
                      title: 'Sustainable Solutions Challenge',
                      subtitle: 'Apply by May 20, 2026',
                      campus: 'Mauritius Campus',
                      tag: 'COMPETITION',
                      tagColor: AppColors.error,
                      tagBg: const Color(0xFFFFEBEE),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _OpportunityTile(
                      icon: '🎓',
                      iconBg: const Color(0xFFE3F2FD),
                      title: 'Campus Ambassador Program',
                      subtitle: 'Apply by June 05, 2026',
                      campus: 'Remote / Hybrid',
                      tag: 'ROLE',
                      tagColor: AppColors.primary,
                      tagBg: AppColors.primaryLight,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _OpportunityTile(
                      icon: '🔬',
                      iconBg: const Color(0xFFF3E5F5),
                      title: 'AI Research Fellowship',
                      subtitle: 'Apply by July 12, 2026',
                      campus: 'Kigali Campus',
                      tag: 'GRANT',
                      tagColor: AppColors.success,
                      tagBg: const Color(0xFFE8F5E9),
                    ),
                    const SizedBox(height: AppSpacing.xxxl),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // ── Bottom Navigation Bar (shared widget) ────────────────────
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 0),

      // ── FAB ──────────────────────────────────────────────────────
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        shape: const CircleBorder(),
        elevation: 4,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _avatarFallback(String name) {
    return Container(
      color: AppColors.primary,
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0] : 'S',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

// ── Featured Event Card ──────────────────────────────────────────────────────

class _FeaturedEventCard extends StatelessWidget {
  final EventModel event;
  const _FeaturedEventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.gradientBanner),
        boxShadow: AppShadows.elevated,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.gradientBanner),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background gradient
            Container(
              decoration: BoxDecoration(
                gradient: AppGradients.heroBanner,
              ),
            ),
            // Dark overlay for readability
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.65),
                  ],
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tag
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(AppRadius.chip),
                    ),
                    child: Text(
                      'ALU Entrepreneurship',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Title
                  Text(
                    event.title,
                    style: AppTextStyles.headingLarge.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  // Meta row
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_rounded,
                        color: Colors.white70,
                        size: 13,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'May 24, 2026',
                        style: AppTextStyles.caption.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      const Icon(
                        Icons.location_on_rounded,
                        color: Colors.white70,
                        size: 13,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        event.campus,
                        style: AppTextStyles.caption.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Opportunity Tile ─────────────────────────────────────────────────────────

class _OpportunityTile extends StatelessWidget {
  final String icon;
  final Color iconBg;
  final String title;
  final String subtitle;
  final String campus;
  final String tag;
  final Color tagColor;
  final Color tagBg;

  const _OpportunityTile({
    required this.icon,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.campus,
    required this.tag,
    required this.tagColor,
    required this.tagBg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        children: [
          // Icon circle
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Center(child: Text(icon, style: const TextStyle(fontSize: 20))),
          ),
          const SizedBox(width: AppSpacing.md),
          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.headingSmall),
                const SizedBox(height: 2),
                Text(subtitle, style: AppTextStyles.caption),
                const SizedBox(height: 2),
                Text(
                  campus,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          // Tag + chevron
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textMuted,
                size: 20,
              ),
              const SizedBox(height: AppSpacing.sm),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: tagBg,
                  borderRadius: BorderRadius.circular(AppRadius.chip),
                ),
                child: Text(
                  tag,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: tagColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
