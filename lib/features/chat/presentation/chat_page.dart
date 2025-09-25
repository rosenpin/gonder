import 'package:flutter/material.dart';
import 'package:gonder/data/repositories/app_repositories.dart';
import 'package:gonder/models/conversation.dart';
import 'package:gonder/models/message.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Conversation? _conversation;
  bool _isSending = false;
  final TextEditingController _composerController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final DateTime _matchDate = DateTime(2024, 4, 29);

  static const String _conversationId = 'conversation-1';
  static const String _currentUserId = 'user-1';

  @override
  void initState() {
    super.initState();
    _loadConversation();
  }

  Future<void> _loadConversation() async {
    final result = await conversationRepository.fetchConversation(
      _conversationId,
    );
    if (!mounted) return;
    setState(() => _conversation = result);
  }

  @override
  void dispose() {
    _composerController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _handleSend() async {
    final conversation = _conversation;
    if (conversation == null) return;
    final text = _composerController.text.trim();
    if (text.isEmpty) return;

    final message = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: _currentUserId,
      body: text,
      sentAt: DateTime.now(),
      status: MessageStatus.sending,
    );

    setState(() {
      _isSending = true;
      _conversation = conversation.copyWith(
        messages: [...conversation.messages, message],
      );
      _composerController.clear();
    });

    final updated = await conversationRepository.sendMessage(
      conversationId: _conversationId,
      message: message.copyWith(status: MessageStatus.sent),
    );

    if (!mounted) return;
    setState(() {
      _conversation = updated;
      _isSending = false;
    });

    Future.delayed(const Duration(milliseconds: 80), () {
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
    final conversation = _conversation;
    if (conversation == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(82),
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
              itemCount: conversation.messages.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final message = conversation.messages[index];
                final next = index + 1 < conversation.messages.length
                    ? conversation.messages[index + 1]
                    : null;
                final showAvatar =
                    message.senderId != _currentUserId &&
                    (next == null || next.senderId == _currentUserId);
                final showTimestamp =
                    next == null || next.senderId == _currentUserId;
                return _MessageBubble(
                  message: message,
                  isMine: message.senderId == _currentUserId,
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
                    onPressed: _isSending ? null : _handleSend,
                    backgroundColor: Theme.of(context).colorScheme.primary,
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

class _ChatHeader extends StatelessWidget {
  const _ChatHeader({required this.matchDate});

  final DateTime matchDate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.92),
      foregroundColor: Colors.white,
      title: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 4),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () {},
            ),
            const SizedBox(width: 6),
            const CircleAvatar(
              radius: 22,
              backgroundImage: AssetImage('assets/2.png'),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text(
                      'Angel',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text('🐐', style: TextStyle(fontSize: 18)),
                  ],
                ),
                Text(
                  'Matched on ${_formatMatchDate(matchDate)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.78),
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.flag_outlined),
              tooltip: 'Report',
              onPressed: () {},
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
    final primary = Theme.of(context).colorScheme.primary;
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'You matched with Angel on ${_ChatHeader._formatMatchDate(matchDate)}',
            style: textTheme.bodySmall?.copyWith(
              color: Colors.grey.shade600,
              letterSpacing: 0.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            'Keep it classy, goat friend 🐐',
            style: textTheme.labelSmall?.copyWith(
              color: primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({
    required this.message,
    required this.isMine,
    required this.showAvatar,
    required this.showTimestamp,
  });

  final MessageModel message;
  final bool isMine;
  final bool showAvatar;
  final bool showTimestamp;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final alignment = isMine
        ? CrossAxisAlignment.end
        : CrossAxisAlignment.start;
    final bubbleColor = isMine ? theme.colorScheme.primary : Colors.white;
    final textColor = isMine ? Colors.white : Colors.black87;
    final borderRadius = BorderRadius.only(
      topLeft: const Radius.circular(24),
      topRight: const Radius.circular(24),
      bottomLeft: Radius.circular(isMine ? 18 : 12),
      bottomRight: Radius.circular(isMine ? 12 : 18),
    );

    return Column(
      crossAxisAlignment: alignment,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: isMine
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            if (!isMine)
              Opacity(
                opacity: showAvatar ? 1 : 0,
                child: const CircleAvatar(
                  radius: 16,
                  backgroundImage: AssetImage('assets/2.png'),
                ),
              ),
            if (!isMine) const SizedBox(width: 8),
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
                  message.body,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: textColor,
                    height: 1.4,
                  ),
                ),
              ),
            ),
            if (isMine) const SizedBox(width: 8),
            if (isMine)
              Icon(
                Icons.check,
                size: 18,
                color: isMine ? const Color(0xFF3FB7FF) : Colors.transparent,
              ),
          ],
        ),
        if (showTimestamp) ...[
          const SizedBox(height: 6),
          Text(
            _formatTimestamp(message.sentAt),
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
  final VoidCallback? onPressed;
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
