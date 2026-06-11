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

  List<_AgendaItem> get _agendaItems {
    final eventItems = DummyDatabase.events.map(_AgendaItem.fromEvent).toList();
    final clubItems = DummyDatabase.clubs.map(_AgendaItem.fromClub).toList();

    return switch (_categories[_selectedCategory]) {
      'Events' => eventItems,
      'Opportunities' => _opportunityItems,
      'Clubs' => clubItems,
      'Academic' => _academicItems,
      _ => [
          ...eventItems,
          ..._opportunityItems,
          ...clubItems,
          ..._academicItems,
        ],
    };
  }

  List<_AgendaItem> get _opportunityItems => const [
        _AgendaItem(
          icon: '🌿',
          iconBg: Color(0xFFE8F5E9),
          title: 'Sustainable Solutions Challenge',
          subtitle: 'Apply by May 20, 2026',
          campus: 'Mauritius Campus',
          tag: 'COMPETITION',
          tagColor: AppColors.error,
          tagBg: Color(0xFFFFEBEE),
          details:
              'Student teams can submit climate, energy, waste, and food-system ideas for judging. Shortlisted teams receive mentor office hours, pitch practice, prototype feedback, and a chance to present to campus partners.',
        ),
        _AgendaItem(
          icon: '🎓',
          iconBg: Color(0xFFE3F2FD),
          title: 'Campus Ambassador Program',
          subtitle: 'Apply by June 05, 2026',
          campus: 'Remote / Hybrid',
          tag: 'ROLE',
          tagColor: AppColors.primary,
          tagBg: AppColors.primaryLight,
          details:
              'Ambassadors support student onboarding, community announcements, and intercampus activity promotion. Selected students join training and receive weekly responsibilities across events and digital channels.',
        ),
        _AgendaItem(
          icon: '🔬',
          iconBg: Color(0xFFF3E5F5),
          title: 'AI Research Fellowship',
          subtitle: 'Apply by July 12, 2026',
          campus: 'Kigali Campus',
          tag: 'GRANT',
          tagColor: AppColors.success,
          tagBg: Color(0xFFE8F5E9),
          details:
              'The fellowship pairs students with faculty-led AI projects in education, health, and entrepreneurship. Applicants should share a statement, coursework, and one project sample or research interest.',
        ),
      ];

  List<_AgendaItem> get _academicItems => const [
        _AgendaItem(
          icon: '📚',
          iconBg: Color(0xFFE3F2FD),
          title: 'Capstone Clinic',
          subtitle: 'Today, 10:00 AM - 12:00 PM',
          campus: 'Learning Commons',
          tag: 'ACADEMIC',
          tagColor: AppColors.primary,
          tagBg: AppColors.primaryLight,
          details:
              'Final-year students can bring research questions, prototype blockers, and presentation drafts. Faculty mentors rotate through tables for feedback on scope, evidence, and next milestones.',
        ),
        _AgendaItem(
          icon: '🧠',
          iconBg: Color(0xFFF3E5F5),
          title: 'Data Structures Study Lab',
          subtitle: 'Today, 2:00 PM - 4:00 PM',
          campus: 'Computer Lab 1',
          tag: 'STUDY',
          tagColor: AppColors.success,
          tagBg: Color(0xFFE8F5E9),
          details:
              'A guided study block covering trees, graphs, complexity analysis, and exam-style problem solving. Peer tutors run short examples before students break into practice groups.',
        ),
        _AgendaItem(
          icon: '✍️',
          iconBg: Color(0xFFFFEBEE),
          title: 'Writing Center Drop-in',
          subtitle: 'Today, 3:30 PM - 5:30 PM',
          campus: 'Academic Support Desk',
          tag: 'SUPPORT',
          tagColor: AppColors.error,
          tagBg: Color(0xFFFFEBEE),
          details:
              'Students can review essays, lab reports, and reflective assignments with writing coaches. Bring a rubric, draft, or outline for focused support.',
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final user = Session.currentUser;
    final firstName = user?.fullName.split(' ').first ?? 'Student';
    final events = DummyDatabase.events;
    final featuredEvent = events.isNotEmpty ? events[1] : null;
    final agendaItems = _agendaItems;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.lg,
                AppSpacing.sm,
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 36,
                    height: 36,
                    child: Image.asset(
                      'assets/images/alu_logo.webp',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text('ALU Intercampus', style: AppTextStyles.headingSmall),
                  const Spacer(),
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
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSpacing.md),
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
                            'Search opportunities, events, people...',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    SizedBox(
                      height: 72,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _categories.length,
                        separatorBuilder: (_, _) =>
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
                    if (featuredEvent != null)
                      _FeaturedEventCard(event: featuredEvent),
                    const SizedBox(height: AppSpacing.xl),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${_categories[_selectedCategory]} Agenda',
                          style: AppTextStyles.headingMedium,
                        ),
                        Text(
                          '${agendaItems.length} items',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SizedBox(
                      height: 430,
                      child: ListView.separated(
                        itemCount: agendaItems.length,
                        separatorBuilder: (_, _) =>
                            const SizedBox(height: AppSpacing.sm),
                        itemBuilder: (context, index) {
                          final item = agendaItems[index];
                          return _AgendaTile(
                            item: item,
                            onTap: () => _showAgendaDetails(context, item),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxxl),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 0),
    );
  }

  void _showAgendaDetails(BuildContext context, _AgendaItem item) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (context) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _AgendaIcon(item: item),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.title, style: AppTextStyles.headingMedium),
                        const SizedBox(height: 2),
                        Text(item.subtitle, style: AppTextStyles.caption),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Text(item.campus, style: AppTextStyles.bodyMedium),
              const SizedBox(height: AppSpacing.sm),
              Text(item.details, style: AppTextStyles.bodyMedium),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        );
      },
    );
  }
}

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
            Container(decoration: BoxDecoration(gradient: AppGradients.heroBanner)),
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
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  Text(
                    event.title,
                    style: AppTextStyles.headingLarge.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
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

class _AgendaTile extends StatelessWidget {
  final _AgendaItem item;
  final VoidCallback onTap;

  const _AgendaTile({
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: AppColors.cardBorder),
          boxShadow: AppShadows.card,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _AgendaIcon(item: item),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title, style: AppTextStyles.headingSmall),
                  const SizedBox(height: 2),
                  Text(item.subtitle, style: AppTextStyles.caption),
                  const SizedBox(height: 2),
                  Text(
                    item.campus,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    item.details,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
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
                    color: item.tagBg,
                    borderRadius: BorderRadius.circular(AppRadius.chip),
                  ),
                  child: Text(
                    item.tag,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: item.tagColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AgendaIcon extends StatelessWidget {
  const _AgendaIcon({required this.item});

  final _AgendaItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: item.iconBg,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Center(child: Text(item.icon, style: const TextStyle(fontSize: 20))),
    );
  }
}

class _AgendaItem {
  final String icon;
  final Color iconBg;
  final String title;
  final String subtitle;
  final String campus;
  final String tag;
  final Color tagColor;
  final Color tagBg;
  final String details;

  const _AgendaItem({
    required this.icon,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.campus,
    required this.tag,
    required this.tagColor,
    required this.tagBg,
    required this.details,
  });

  factory _AgendaItem.fromEvent(EventModel event) {
    return _AgendaItem(
      icon: _eventIcon(event.category),
      iconBg: _eventIconBg(event.category),
      title: event.title,
      subtitle: '${_formatDate(event.startDate)} • ${_formatTime(event.startDate)}',
      campus: event.campus,
      tag: _eventCategoryLabel(event.category).toUpperCase(),
      tagColor: _eventTagColor(event.category),
      tagBg: _eventTagBg(event.category),
      details:
          '${event.description} Location: ${event.location}. Capacity: ${event.maxAttendees} students. Registered attendees: ${event.attendeeIds.length}. Registration deadline: ${event.metadata['registrationDeadline'] ?? 'To be announced'}.',
    );
  }

  factory _AgendaItem.fromClub(ClubModel club) {
    return _AgendaItem(
      icon: '👥',
      iconBg: const Color(0xFFE3F2FD),
      title: club.name,
      subtitle: '${club.memberIds.length} members • ${club.campus}',
      campus: club.campus,
      tag: 'CLUB',
      tagColor: AppColors.primary,
      tagBg: AppColors.primaryLight,
      details:
          '${club.description} Current focus areas include ${(club.metadata['tags'] as List).join(', ')}. The club has hosted ${club.metadata['totalEvents']} activities and has ${club.eventIds.length} upcoming or linked agendas in the intercampus calendar.',
    );
  }
}

String _eventCategoryLabel(EventCategory category) => switch (category) {
      EventCategory.academic => 'Academic',
      EventCategory.social => 'Event',
      EventCategory.sports => 'Sports',
      EventCategory.tech => 'Workshop',
      EventCategory.cultural => 'Event',
      EventCategory.career => 'Opportunity',
    };

String _eventIcon(EventCategory category) => switch (category) {
      EventCategory.academic => '📚',
      EventCategory.social => '🎤',
      EventCategory.sports => '🏆',
      EventCategory.tech => '💻',
      EventCategory.cultural => '🎉',
      EventCategory.career => '💼',
    };

Color _eventIconBg(EventCategory category) => switch (category) {
      EventCategory.academic => const Color(0xFFE3F2FD),
      EventCategory.social => const Color(0xFFFFEBEE),
      EventCategory.sports => const Color(0xFFE8F5E9),
      EventCategory.tech => const Color(0xFFF3E5F5),
      EventCategory.cultural => const Color(0xFFFFF3E0),
      EventCategory.career => AppColors.primaryLight,
    };

Color _eventTagColor(EventCategory category) => switch (category) {
      EventCategory.academic => AppColors.primary,
      EventCategory.social => AppColors.error,
      EventCategory.sports => AppColors.success,
      EventCategory.tech => AppColors.success,
      EventCategory.cultural => AppColors.warning,
      EventCategory.career => AppColors.primary,
    };

Color _eventTagBg(EventCategory category) => switch (category) {
      EventCategory.academic => AppColors.primaryLight,
      EventCategory.social => const Color(0xFFFFEBEE),
      EventCategory.sports => const Color(0xFFE8F5E9),
      EventCategory.tech => const Color(0xFFE8F5E9),
      EventCategory.cultural => const Color(0xFFFFF3E0),
      EventCategory.career => AppColors.primaryLight,
    };

String _formatDate(DateTime date) {
  return '${_monthName(date.month)} ${date.day}, ${date.year}';
}

String _formatTime(DateTime date) {
  final hour = date.hour == 0
      ? 12
      : date.hour > 12
          ? date.hour - 12
          : date.hour;
  final minute = date.minute.toString().padLeft(2, '0');
  final period = date.hour >= 12 ? 'PM' : 'AM';
  return '$hour:$minute $period';
}

String _monthName(int month) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return months[month - 1];
}
