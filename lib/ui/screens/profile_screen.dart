import 'package:flutter/material.dart';
import 'package:formative_assignment1/data/dummy_database.dart';
import 'package:formative_assignment1/data/session.dart';
import 'package:formative_assignment1/theme/app_theme.dart';

class ProfileScreen extends StatefulWidget {
  /// Pass the other participant's user ID.
  /// Defaults to usr_002 (Eric Mugisha) for prototyping.
  final String peerId;

  const ProfileScreen({super.key, this.peerId = 'usr_002'});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<_ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  void _loadMessages() {
    final currentUserId = Session.currentUser?.id ?? 'usr_001';
    final thread = DummyDatabase.getThreadByParticipants(
      currentUserId,
      widget.peerId,
    );

    if (thread != null) {
      _messages = thread.messages.map((m) {
        return _ChatMessage(
          text: m.content,
          isMine: m.senderId == currentUserId,
          time: _formatTime(m.sentAt),
          status: m.status,
          imageUrl: null,
        );
      }).toList();
    } else {
      // Fallback seed messages matching the screenshot
      _messages = [
        _ChatMessage(
          text:
              "Hi! Are you coming to the Entrepreneurship Club meeting at the Innovation Hub later? 📍",
          isMine: false,
          time: '09:42 AM',
          status: MessageStatus.read,
        ),
        _ChatMessage(
          text:
              "Hey Aline! Yes, I'll be there. Just finishing up my lab report. What's on the agenda today?",
          isMine: true,
          time: '09:45 AM',
          status: MessageStatus.read,
        ),
        _ChatMessage(
          text:
              "We're discussing the Inter-Campus pitch competition. Here's the schedule for the briefing!",
          isMine: false,
          time: '09:46 AM',
          status: MessageStatus.read,
          imageUrl:
              'https://images.unsplash.com/photo-1484480974693-6ca0a78fb36b?w=400&q=80',
        ),
        _ChatMessage(
          text:
              "That looks great. I've prepared some slides on the marketing strategy section. I'll bring my laptop.",
          isMine: true,
          time: '09:48 AM',
          status: MessageStatus.delivered,
        ),
      ];
    }
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final m = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $period';
  }

  void _sendMessage() {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_ChatMessage(
        text: text,
        isMine: true,
        time: _formatTime(DateTime.now()),
        status: MessageStatus.sent,
      ));
      _inputController.clear();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final peer = DummyDatabase.getUserById(widget.peerId);
    final peerName = peer?.fullName ?? 'Unknown';
    final peerOnline = peer?.isOnline ?? false;
    final peerAvatar = peer?.avatarUrl;
    final peerInitial = peerName.isNotEmpty ? peerName[0] : '?';

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: _ChatAppBar(
          name: peerName,
          isOnline: peerOnline,
          avatarUrl: peerAvatar,
          avatarInitial: peerInitial,
          onBack: () => Navigator.maybePop(context),
        ),
      ),
      body: Column(
        children: [
          // ── Message list ─────────────────────────────────────────
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              itemCount: _messages.length + 1, // +1 for date divider
              itemBuilder: (context, index) {
                if (index == 0) {
                  return const _DateDivider(label: 'Today');
                }
                return _MessageBubble(message: _messages[index - 1]);
              },
            ),
          ),

          // ── Input bar ────────────────────────────────────────────
          _MessageInputBar(
            controller: _inputController,
            onSend: _sendMessage,
          ),
        ],
      ),
    );
  }
}

// ── App Bar ──────────────────────────────────────────────────────────────────

class _ChatAppBar extends StatelessWidget {
  final String name;
  final bool isOnline;
  final String? avatarUrl;
  final String avatarInitial;
  final VoidCallback onBack;

  const _ChatAppBar({
    required this.name,
    required this.isOnline,
    required this.avatarUrl,
    required this.avatarInitial,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(
          bottom: BorderSide(color: AppColors.cardBorder),
        ),
        boxShadow: AppShadows.card,
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              // Back button
              IconButton(
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back_rounded),
                color: AppColors.textDark,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              ),
              const SizedBox(width: AppSpacing.xs),

              // Avatar with online badge
              Stack(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: AppShadows.avatar,
                    ),
                    child: ClipOval(
                      child: avatarUrl != null
                          ? Image.network(
                              avatarUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  _initials(avatarInitial),
                            )
                          : _initials(avatarInitial),
                    ),
                  ),
                  if (isOnline)
                    Positioned(
                      bottom: 1,
                      right: 1,
                      child: Container(
                        width: 11,
                        height: 11,
                        decoration: BoxDecoration(
                          color: AppColors.onlineBadge,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.white,
                            width: AppSpacing.badgeBorderWidth,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: AppSpacing.sm),

              // Name + status
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(name, style: AppTextStyles.headingSmall),
                    Text(
                      isOnline ? 'Online' : 'Offline',
                      style: AppTextStyles.caption.copyWith(
                        color: isOnline
                            ? AppColors.success
                            : AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),

              // Action icons
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.videocam_outlined, size: 22),
                color: AppColors.textDark,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.call_outlined, size: 20),
                color: AppColors.textDark,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_vert_rounded, size: 22),
                color: AppColors.textDark,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _initials(String letter) {
    return Container(
      color: AppColors.primary,
      child: Center(
        child: Text(
          letter,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}

// ── Date Divider ─────────────────────────────────────────────────────────────

class _DateDivider extends StatelessWidget {
  final String label;
  const _DateDivider({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      child: Row(
        children: [
          Expanded(child: Divider(color: AppColors.cardBorder, height: 1)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadius.chip),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
            ),
          ),
          Expanded(child: Divider(color: AppColors.cardBorder, height: 1)),
        ],
      ),
    );
  }
}

// ── Message Bubble ───────────────────────────────────────────────────────────

class _ChatMessage {
  final String text;
  final bool isMine;
  final String time;
  final MessageStatus status;
  final String? imageUrl;

  const _ChatMessage({
    required this.text,
    required this.isMine,
    required this.time,
    required this.status,
    this.imageUrl,
  });
}

class _MessageBubble extends StatelessWidget {
  final _ChatMessage message;
  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isMine = message.isMine;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        mainAxisAlignment:
            isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMine) ...[
            const SizedBox(width: 4),
          ],
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.72,
            ),
            child: Column(
              crossAxisAlignment:
                  isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                // Image attachment
                if (message.imageUrl != null)
                  Container(
                    margin: const EdgeInsets.only(bottom: AppSpacing.xs),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      boxShadow: AppShadows.card,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      child: Image.network(
                        message.imageUrl!,
                        width: 220,
                        height: 150,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 220,
                          height: 150,
                          color: AppColors.primaryLight,
                          child: Icon(
                            Icons.image_rounded,
                            color: AppColors.primary,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  ),

                // Text bubble
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: isMine ? AppColors.primary : AppColors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(AppRadius.lg),
                      topRight: Radius.circular(AppRadius.lg),
                      bottomLeft: Radius.circular(
                        isMine ? AppRadius.lg : AppRadius.xs,
                      ),
                      bottomRight: Radius.circular(
                        isMine ? AppRadius.xs : AppRadius.lg,
                      ),
                    ),
                    border: isMine
                        ? null
                        : Border.all(color: AppColors.cardBorder),
                    boxShadow: AppShadows.card,
                  ),
                  child: Text(
                    message.text,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: isMine ? Colors.white : AppColors.textDark,
                      height: 1.45,
                    ),
                  ),
                ),

                // Time + status
                Padding(
                  padding: const EdgeInsets.only(top: 3, left: 4, right: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        message.time,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textMuted,
                          fontSize: 10,
                        ),
                      ),
                      if (isMine) ...[
                        const SizedBox(width: 3),
                        _StatusIcon(status: message.status),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusIcon extends StatelessWidget {
  final MessageStatus status;
  const _StatusIcon({required this.status});

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case MessageStatus.sent:
        return Icon(Icons.check_rounded, size: 14, color: AppColors.textMuted);
      case MessageStatus.delivered:
        return Icon(Icons.done_all_rounded,
            size: 14, color: AppColors.textMuted);
      case MessageStatus.read:
        return Icon(Icons.done_all_rounded, size: 14, color: AppColors.primary);
    }
  }
}

// ── Message Input Bar ────────────────────────────────────────────────────────

class _MessageInputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const _MessageInputBar({
    required this.controller,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(
          top: BorderSide(color: AppColors.cardBorder),
        ),
      ),
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.sm,
        bottom: AppSpacing.sm + MediaQuery.of(context).viewPadding.bottom,
      ),
      child: Row(
        children: [
          // Attachment icon
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.attach_file_rounded),
            color: AppColors.textMuted,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
          const SizedBox(width: AppSpacing.sm),

          // Text field
          Expanded(
            child: Container(
              constraints: const BoxConstraints(minHeight: 44),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(AppRadius.input),
              ),
              child: TextField(
                controller: controller,
                minLines: 1,
                maxLines: 4,
                style: AppTextStyles.bodyMedium,
                decoration: InputDecoration(
                  hintText: 'Type a message…',
                  hintStyle: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textMuted,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                ),
                onSubmitted: (_) => onSend(),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),

          // Send button
          GestureDetector(
            onTap: onSend,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                boxShadow: AppShadows.card,
              ),
              child: const Icon(
                Icons.send_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
