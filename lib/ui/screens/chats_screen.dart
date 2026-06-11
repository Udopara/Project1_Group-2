import 'dart:math';

import 'package:flutter/material.dart';
import 'package:formative_assignment1/data/dummy_database.dart';
import 'package:formative_assignment1/data/session.dart';
import 'package:formative_assignment1/theme/app_theme.dart';
import 'package:formative_assignment1/ui/widgets/app_bottom_nav_bar.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _query = _searchController.text.toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final me = Session.currentUser ?? DummyDatabase.users.first;
    final activeUsers = DummyDatabase.users
        .where((u) => u.isOnline && u.id != me.id)
        .toList();

    // Only threads the current user belongs to
    final myThreads = DummyDatabase.chatThreads
        .where((t) => t.participantIds.contains(me.id))
        .toList();

    // Filter by search query against the other participant's name
    final threads = _query.isEmpty
        ? myThreads
        : myThreads.where((t) {
            final otherId = t.participantIds.firstWhere(
              (id) => id != me.id,
              orElse: () => '',
            );
            final other = DummyDatabase.getUserById(otherId);
            return other?.fullName.toLowerCase().contains(_query) ?? false;
          }).toList();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 0,
        leading: Padding(
          padding: const EdgeInsets.all(10),
          child: CircleAvatar(backgroundImage: NetworkImage(me.avatarUrl)),
        ),
        title: const Text('Messages'),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: AppColors.textDark,
            ),
            onPressed: () {},
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.edit_outlined),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 3),
      body: SafeArea(
        top: false,
        child: CustomScrollView(
          slivers: [
            // ── Search bar ─────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.md,
                  AppSpacing.lg,
                  AppSpacing.lg,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(AppRadius.chip),
                    boxShadow: AppShadows.card,
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search conversations...',
                      prefixIcon: const Icon(
                        Icons.search,
                        color: AppColors.textMuted,
                        size: 20,
                      ),
                      filled: false,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.chip),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ),
            ),

            // ── "ACTIVE NOW" heading ────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: AppSpacing.lg,
                  bottom: AppSpacing.sm,
                ),
                child: Text(
                  'ACTIVE NOW',
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: SizedBox(
                height: 90,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  children: [
                    ...activeUsers.map(
                      (u) => Padding(
                        padding: const EdgeInsets.only(right: AppSpacing.lg),
                        child: _ActiveUserItem(
                          avatarUrl: u.avatarUrl,
                          name: u.fullName.split(' ').first,
                        ),
                      ),
                    ),
                    const _AddContactItem(),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.xl,
                  AppSpacing.lg,
                  AppSpacing.sm,
                ),
                child: Text(
                  'RECENT CHATS',
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                0,
                AppSpacing.lg,
                AppSpacing.xxl,
              ),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((_, i) {
                  final thread = threads[i];
                  final otherId = thread.participantIds.firstWhere(
                    (id) => id != me.id,
                    orElse: () => '',
                  );
                  final other = DummyDatabase.getUserById(otherId);
                  if (other == null) return const SizedBox.shrink();
                  final lastMsg = thread.messages.isNotEmpty
                      ? thread.messages.last
                      : null;
                  final unreadCount = thread.messages
                      .where((m) =>
                          m.receiverId == me.id &&
                          m.status != MessageStatus.read)
                      .length;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: GestureDetector(
                      onTap: () => Navigator.pushNamed(
                        context,
                        '/chat-detail',
                        arguments: otherId,
                      ),
                      child: _ChatRow(
                        avatarUrl: other.avatarUrl,
                        name: other.fullName,
                        preview: lastMsg?.content ?? '',
                        time: lastMsg != null ? _formatTime(lastMsg.sentAt) : '',
                        unreadCount: unreadCount,
                        isGroup: false,
                      ),
                    ),
                  );
                }, childCount: threads.length),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
      final period = dt.hour >= 12 ? 'PM' : 'AM';
      final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
      final m = dt.minute.toString().padLeft(2, '0');
      return '$h:$m $period';
    }
    return '${dt.day}/${dt.month}';
  }
}

class _ActiveUserItem extends StatelessWidget {
  const _ActiveUserItem({required this.avatarUrl, required this.name});
  final String avatarUrl;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            Container(
              width: 56,
              height: 56,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary, width: 2),
              ),
              child: CircleAvatar(backgroundImage: NetworkImage(avatarUrl)),
            ),
            Positioned(
              bottom: 2,
              right: 2,
              child: Container(
                width: 13,
                height: 13,
                decoration: BoxDecoration(
                  color: AppColors.onlineBadge,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.scaffoldBg, width: 2),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(name, style: AppTextStyles.caption),
      ],
    );
  }
}

class _AddContactItem extends StatelessWidget {
  const _AddContactItem();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 56,
          height: 56,
          child: CustomPaint(
            painter: _DashedCirclePainter(color: AppColors.textMuted),
            child: const Center(
              child: Icon(Icons.add, color: AppColors.textMuted, size: 22),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text('Add', style: AppTextStyles.caption),
      ],
    );
  }
}

class _DashedCirclePainter extends CustomPainter {
  const _DashedCirclePainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 4) / 2;
    const dashCount = 14;
    const dashAngle = (2 * pi) / dashCount;
    const sweepAngle = dashAngle * 0.65;
    for (var i = 0; i < dashCount; i++) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        i * dashAngle - pi / 2,
        sweepAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_DashedCirclePainter old) => old.color != color;
}

class _ChatRow extends StatelessWidget {
  const _ChatRow({
    required this.avatarUrl,
    required this.name,
    required this.preview,
    required this.time,
    required this.unreadCount,
    required this.isGroup,
  });
  final String? avatarUrl;
  final String name;
  final String preview;
  final String time;
  final int unreadCount;
  final bool isGroup;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        children: [
          // Avatar
          if (isGroup)
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.group_outlined,
                color: AppColors.primary,
                size: 24,
              ),
            )
          else
            CircleAvatar(
              radius: 24,
              backgroundImage: avatarUrl != null
                  ? NetworkImage(avatarUrl!)
                  : null,
            ),

          const SizedBox(width: AppSpacing.md),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  preview,
                  style: AppTextStyles.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          const SizedBox(width: AppSpacing.sm),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(time, style: AppTextStyles.caption),
              if (unreadCount > 0) ...[
                const SizedBox(height: 4),
                Container(
                  width: 18,
                  height: 18,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$unreadCount',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.white,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
