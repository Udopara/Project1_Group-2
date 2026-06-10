import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:formative_assignment1/data/dummy_database.dart';
import 'package:formative_assignment1/theme/app_theme.dart';
import 'package:formative_assignment1/ui/widgets/app_bottom_nav_bar.dart';

// ── Screen ────────────────────────────────────────────────────────────────────

class PostDetailsScreen extends StatelessWidget {
  final String eventId;

  const PostDetailsScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    final event = DummyDatabase.getEventById(eventId);
    if (event == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Not Found')),
        body: const Center(child: Text('Event not found.')),
        bottomNavigationBar: const AppBottomNavBar(currentIndex: 0),
      );
    }

    final organizer = DummyDatabase.getUserById(event.organizerId);
    final attendeeUsers = event.attendeeIds
        .take(3)
        .map(DummyDatabase.getUserById)
        .whereType<UserModel>()
        .toList();
    final extraCount = (event.attendeeIds.length - 3).clamp(0, 999);
    final tags = ((event.metadata['tags'] as List?)?.cast<String>()) ?? <String>[];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.white,
        bottomNavigationBar: const AppBottomNavBar(currentIndex: 0),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Hero ───────────────────────────────────────────────
              _HeroSection(
                bannerUrl: event.bannerUrl,
                onBack: () => Navigator.pop(context),
              ),

              // ── Body ───────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category tags
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: [
                        _TagChip(
                            label: _categoryLabel(event.category), index: 0),
                        ...tags.take(2).toList().asMap().entries.map(
                              (e) => _TagChip(label: e.value, index: e.key + 1),
                            ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Title
                    Text(event.title, style: AppTextStyles.headingLarge),
                    const SizedBox(height: AppSpacing.lg),

                    // Attendee avatars
                    if (event.attendeeIds.isNotEmpty)
                      _AttendeesRow(
                          users: attendeeUsers, extraCount: extraCount),
                    if (event.attendeeIds.isNotEmpty)
                      const SizedBox(height: AppSpacing.lg),

                    // Date & Time
                    _InfoCard(
                      iconData: Icons.calendar_today_outlined,
                      iconBgColor: const Color(0xFFEEF0FF),
                      iconColor: AppColors.primary,
                      label: 'DATE & TIME',
                      title: _formatDate(event.startDate),
                      subtitle:
                          '${_formatTime(event.startDate)} - ${_formatTime(event.endDate)}',
                    ),
                    const SizedBox(height: AppSpacing.sm),

                    // Location
                    _InfoCard(
                      iconData: Icons.location_on_outlined,
                      iconBgColor: const Color(0xFFFFEEEE),
                      iconColor: AppColors.error,
                      label: 'LOCATION',
                      title: event.campus,
                      subtitle: event.location,
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // About
                    Text('About the Event',
                        style: AppTextStyles.headingSmall),
                    const SizedBox(height: AppSpacing.sm),
                    Text(event.description,
                        style: AppTextStyles.bodyMedium),
                    const SizedBox(height: AppSpacing.xl),

                    // Speaker card
                    if (organizer != null) _SpeakerCard(organizer: organizer),

                    const SizedBox(height: AppSpacing.xxl),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Helpers ───────────────────────────────────────────────────────────────────

String _categoryLabel(EventCategory cat) => switch (cat) {
      EventCategory.academic => 'Academic',
      EventCategory.social => 'Social',
      EventCategory.sports => 'Sports',
      EventCategory.tech => 'Workshop',
      EventCategory.cultural => 'Cultural',
      EventCategory.career => 'Career',
    };

String _formatDate(DateTime dt) {
  const months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];
  return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
}

String _formatTime(DateTime dt) {
  final period = dt.hour >= 12 ? 'PM' : 'AM';
  final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
  final m = dt.minute.toString().padLeft(2, '0');
  return '$h:$m $period';
}

// ── Hero section ──────────────────────────────────────────────────────────────

class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.bannerUrl, required this.onBack});
  final String bannerUrl;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return SizedBox(
      height: 220 + top,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            bannerUrl,
            fit: BoxFit.cover,
            errorBuilder: (ctx, err, st) => Container(
              color: AppColors.primaryLight,
              child: const Icon(Icons.image_outlined,
                  color: AppColors.primary, size: 48),
            ),
          ),
          // Bottom fade overlay
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Color(0x55000000)],
                stops: [0.5, 1.0],
              ),
            ),
          ),
          // Back button
          Positioned(
            top: top + 8,
            left: 12,
            child: _CircleButton(icon: Icons.arrow_back, onTap: onBack),
          ),
          // Share button
          Positioned(
            top: top + 8,
            right: 12,
            child: _CircleButton(icon: Icons.share_outlined, onTap: () {}),
          ),
        ],
      ),
    );
  }
}

// ── Circular icon button ──────────────────────────────────────────────────────

class _CircleButton extends StatelessWidget {
  const _CircleButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: const BoxDecoration(
          color: Color(0xE5EEEEEE),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.black87, size: 20),
      ),
    );
  }
}

// ── Category tag chip ─────────────────────────────────────────────────────────

class _TagChip extends StatelessWidget {
  static const List<Color> _bgColors = [
    Color(0xFFDCFCE7), // green
    Color(0xFFEEF0FF), // indigo
    Color(0xFFFFE4E6), // rose
  ];
  static const List<Color> _textColors = [
    Color(0xFF16A34A),
    Color(0xFF4648D4),
    Color(0xFFE11D48),
  ];

  const _TagChip({required this.label, required this.index});
  final String label;
  final int index;

  @override
  Widget build(BuildContext context) {
    final bg = _bgColors[index % _bgColors.length];
    final fg = _textColors[index % _textColors.length];
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelSmall.copyWith(
          color: fg,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ── Stacked attendee avatars ──────────────────────────────────────────────────

class _AttendeesRow extends StatelessWidget {
  const _AttendeesRow({required this.users, required this.extraCount});
  final List<UserModel> users;
  final int extraCount;

  @override
  Widget build(BuildContext context) {
    final itemCount = users.length + (extraCount > 0 ? 1 : 0);
    final stackWidth = itemCount * 22.0 + 10.0;

    return Row(
      children: [
        SizedBox(
          width: stackWidth,
          height: 34,
          child: Stack(
            children: [
              ...users.asMap().entries.map(
                (e) => Positioned(
                  left: e.key * 22.0,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.white, width: 2),
                      image: DecorationImage(
                        image: NetworkImage(e.value.avatarUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              if (extraCount > 0)
                Positioned(
                  left: users.length * 22.0,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.white, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        '+$extraCount',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          'Attending this event',
          style: AppTextStyles.bodySmall
              .copyWith(color: AppColors.textMedium),
        ),
      ],
    );
  }
}

// ── Info card (Date / Location) ───────────────────────────────────────────────

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.iconData,
    required this.iconBgColor,
    required this.iconColor,
    required this.label,
    required this.title,
    required this.subtitle,
  });

  final IconData iconData;
  final Color iconBgColor;
  final Color iconColor;
  final String label;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBg,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(iconData, color: iconColor, size: 22),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  title,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(subtitle, style: AppTextStyles.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Keynote speaker card ──────────────────────────────────────────────────────

class _SpeakerCard extends StatelessWidget {
  const _SpeakerCard({required this.organizer});
  final UserModel organizer;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: _DashedRectPainter(
        color: const Color(0x664648D4),
        radius: AppRadius.md,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.xl, horizontal: AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 38,
              backgroundImage: NetworkImage(organizer.avatarUrl),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'KEYNOTE SPEAKER',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primary,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(organizer.fullName, style: AppTextStyles.headingSmall),
            const SizedBox(height: 2),
            Text(
              '${organizer.department} · ${organizer.campus}',
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                  vertical: AppSpacing.sm,
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'View Profile',
                style: AppTextStyles.labelMedium
                    .copyWith(color: AppColors.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Dashed rounded-rect border painter ───────────────────────────────────────

class _DashedRectPainter extends CustomPainter {
  const _DashedRectPainter({required this.color, required this.radius});
  final Color color;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final rect = Rect.fromLTWH(1, 1, size.width - 2, size.height - 2);
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(radius));
    final sourcePath = Path()..addRRect(rrect);

    const dashLen = 6.0;
    const gapLen = 4.0;
    final dashedPath = Path();

    for (final metric in sourcePath.computeMetrics()) {
      var distance = 0.0;
      var draw = true;
      while (distance < metric.length) {
        final len = draw ? dashLen : gapLen;
        if (draw) {
          dashedPath.addPath(
            metric.extractPath(distance, distance + len),
            Offset.zero,
          );
        }
        distance += len;
        draw = !draw;
      }
    }

    canvas.drawPath(dashedPath, paint);
  }

  @override
  bool shouldRepaint(_DashedRectPainter old) => old.color != color;
}
