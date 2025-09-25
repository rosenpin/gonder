import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<ChatMessage> _messages = [
    ChatMessage(
      id: 'm1',
      text: "You're really pretty!",
      timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 3)),
      isMine: true,
    ),
    ChatMessage(
      id: 'm2',
      text: 'Thank you',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isMine: false,
    ),
    ChatMessage(
      id: 'm3',
      text: 'Your really handsome!!',
      timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 0)),
      isMine: false,
    ),
    ChatMessage(
      id: 'm4',
      text: 'Thanks :)\nWanna hang out sometime? Or go out',
      timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 58)),
      isMine: true,
    ),
    ChatMessage(
      id: 'm5',
      text: "Yes I'd love too",
      timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 55)),
      isMine: false,
    ),
  ];

  final TextEditingController _composerController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final DateTime _matchDate = DateTime(2024, 4, 29);

  @override
  void dispose() {
    _composerController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleSend() {
    final text = _composerController.text.trim();
    if (text.isEmpty) return;
    final message = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      timestamp: DateTime.now(),
      isMine: true,
    );
    setState(() {
      _messages.add(message);
    });
    _composerController.clear();
    Future.delayed(const Duration(milliseconds: 50), () {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(96),
        child: _ChatHeader(matchDate: _matchDate),
      ),
      body: Column(
        children: [
          _MatchBanner(matchDate: _matchDate),
          const Divider(height: 1),
          Expanded(
            child: ListView.separated(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              itemCount: _messages.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final message = _messages[index];
                final next = index + 1 < _messages.length
                    ? _messages[index + 1]
                    : null;
                final showAvatar =
                    !message.isMine && (next == null || next.isMine);
                final showTimestamp =
                    next == null || next.isMine != message.isMine;
                return _MessageBubble(
                  message: message,
                  showAvatar: showAvatar,
                  showTimestamp: showTimestamp,
                );
              },
            ),
          ),
          const Divider(height: 1),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 20),
              child: Row(
                children: [
                  _ComposerIconButton(icon: Icons.add, onPressed: () {}),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _composerController,
                      minLines: 1,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Type a message',
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  _ComposerIconButton(
                    icon: Icons.send,
                    onPressed: _handleSend,
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.text,
    required this.timestamp,
    required this.isMine,
  });

  final String id;
  final String text;
  final DateTime timestamp;
  final bool isMine;
}

class _ChatHeader extends StatelessWidget {
  const _ChatHeader({required this.matchDate});

  final DateTime matchDate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formattedTime = TimeOfDay.now().format(context);
    return AppBar(
      automaticallyImplyLeading: false,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFF5D8F), Color(0xFFFF926B)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      foregroundColor: Colors.white,
      backgroundColor: Colors.transparent,
      title: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () {},
            ),
            const SizedBox(width: 4),
            const CircleAvatar(
              radius: 24,
              backgroundImage: AssetImage('assets/2.png'),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Angel',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'You matched on ${_formatMatchDate(matchDate)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white70,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
            const Spacer(),
            IconButton(icon: const Icon(Icons.flag_outlined), onPressed: () {}),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  formattedTime,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Colors.white70,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static String _formatMatchDate(DateTime date) {
    return '${_monthLabel(date.month)} ${date.day}, ${date.year}';
  }

  static String _monthLabel(int month) {
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
}

class _MatchBanner extends StatelessWidget {
  const _MatchBanner({required this.matchDate});

  final DateTime matchDate;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'YOU MATCHED WITH ANGEL ON ${_ChatHeader._formatMatchDate(matchDate).toUpperCase()}',
            style: textTheme.labelSmall?.copyWith(
              color: Colors.pinkAccent,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.1,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({
    required this.message,
    required this.showAvatar,
    required this.showTimestamp,
  });

  final ChatMessage message;
  final bool showAvatar;
  final bool showTimestamp;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final alignment = message.isMine
        ? CrossAxisAlignment.end
        : CrossAxisAlignment.start;
    final bubbleColor = message.isMine
        ? const Color(0xFF3FB7FF)
        : Colors.grey.shade200;
    final textColor = message.isMine ? Colors.white : Colors.black87;
    final borderRadius = BorderRadius.only(
      topLeft: const Radius.circular(28),
      topRight: const Radius.circular(28),
      bottomLeft: Radius.circular(message.isMine ? 24 : 6),
      bottomRight: Radius.circular(message.isMine ? 6 : 24),
    );

    return Column(
      crossAxisAlignment: alignment,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: message.isMine
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            if (!message.isMine)
              Opacity(
                opacity: showAvatar ? 1 : 0,
                child: const CircleAvatar(
                  radius: 16,
                  backgroundImage: AssetImage('assets/2.png'),
                ),
              ),
            if (!message.isMine) const SizedBox(width: 8),
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: bubbleColor,
                  borderRadius: borderRadius,
                ),
                child: Text(
                  message.text,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: textColor,
                    height: 1.4,
                  ),
                ),
              ),
            ),
            if (message.isMine) const SizedBox(width: 8),
            if (message.isMine)
              const Icon(Icons.check, size: 18, color: Color(0xFF3FB7FF)),
          ],
        ),
        if (showTimestamp) ...[
          const SizedBox(height: 6),
          Text(
            _formatTimestamp(message.timestamp),
            style: theme.textTheme.labelSmall?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ],
    );
  }

  static String _formatTimestamp(DateTime time) {
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }
}

class _ComposerIconButton extends StatelessWidget {
  const _ComposerIconButton({
    required this.icon,
    required this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: const CircleBorder(),
      color: backgroundColor ?? Colors.white,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(icon, size: 22, color: foregroundColor ?? Colors.black54),
        ),
      ),
    );
  }
}
