import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:chatview/chatview.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mini Tinder',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pinkAccent),
        useMaterial3: true,
      ),
      home: const TinderHome(),
    );
  }
}

class TinderHome extends StatefulWidget {
  const TinderHome({super.key});

  @override
  State<TinderHome> createState() => _TinderHomeState();
}

class _TinderHomeState extends State<TinderHome> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: const [SwipeDeckView(), ChatViewPage()],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (value) => setState(() => _selectedIndex = value),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.local_fire_department),
            label: 'Discover',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Chat',
          ),
        ],
      ),
    );
  }
}

class SwipeDeckView extends StatefulWidget {
  const SwipeDeckView({super.key});

  @override
  State<SwipeDeckView> createState() => _SwipeDeckViewState();
}

class _SwipeDeckViewState extends State<SwipeDeckView> {
  final CardSwiperController _swiperController = CardSwiperController();
  final List<Profile> _profiles = [
    const Profile(name: 'David', age: 12, imagePath: 'assets/1.png'),
    const Profile(name: 'Esther', age: 10, imagePath: 'assets/2.png'),
    const Profile(name: 'Miriam', age: 9, imagePath: 'assets/3.png'),
    const Profile(name: 'Solomon', age: 13, imagePath: 'assets/4.png'),
    const Profile(name: 'Noah', age: 11, imagePath: 'assets/5.png'),
    const Profile(name: 'Deborah', age: 8, imagePath: 'assets/6.png'),
    const Profile(name: 'Josiah', age: 7, imagePath: 'assets/7.png'),
    const Profile(name: 'Ruth', age: 6, imagePath: 'assets/8.png'),
  ];

  bool _isDeckFinished = false;

  void _triggerSwipe(CardSwiperDirection direction) {
    if (_isDeckFinished) return;
    _swiperController.swipe(direction);
  }

  @override
  void dispose() {
    _swiperController.dispose();
    super.dispose();
  }

  bool _handleSwipe(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
  ) {
    setState(() {
      _isDeckFinished = currentIndex == null;
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Discover Goats 🔥',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final availableWidth = constraints.maxWidth.isFinite
                    ? constraints.maxWidth
                    : 420.0;
                final availableHeight = constraints.maxHeight.isFinite
                    ? constraints.maxHeight
                    : 520.0;
                final deckWidth = availableWidth > 480 ? 480.0 : availableWidth;
                final deckHeight = availableHeight > 620
                    ? 620.0
                    : availableHeight;

                return Center(
                  child: SizedBox(
                    width: deckWidth,
                    height: deckHeight,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CardSwiper(
                          controller: _swiperController,
                          cardsCount: _profiles.length,
                          isLoop: false,
                          padding: EdgeInsets.zero,
                          numberOfCardsDisplayed: _profiles.length > 1
                              ? 2
                              : _profiles.length,
                          allowedSwipeDirection:
                              const AllowedSwipeDirection.only(
                                left: true,
                                right: true,
                                up: true,
                              ),
                          onSwipe: _handleSwipe,
                          onUndo:
                              (
                                int? previousIndex,
                                int currentIndex,
                                CardSwiperDirection direction,
                              ) {
                                setState(() {
                                  _isDeckFinished = false;
                                });
                                return true;
                              },
                          onEnd: () => setState(() => _isDeckFinished = true),
                          cardBuilder:
                              (
                                context,
                                index,
                                percentThresholdX,
                                percentThresholdY,
                              ) {
                                final profile = _profiles[index];
                                return _ProfileCard(profile: profile);
                              },
                        ),
                        if (_isDeckFinished) const _EmptyDeckPlaceholder(),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          _SwiperActionBar(
            controller: _swiperController,
            isDeckFinished: _isDeckFinished,
            onTrigger: _triggerSwipe,
          ),
        ],
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(24),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(profile.imagePath, fit: BoxFit.cover),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black54],
              ),
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      profile.name,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      '${profile.age} years old',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                    ),
                  ],
                ),
                const Icon(Icons.info_outline, color: Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SwiperActionBar extends StatelessWidget {
  const _SwiperActionBar({
    required this.controller,
    required this.isDeckFinished,
    required this.onTrigger,
  });

  final CardSwiperController controller;
  final bool isDeckFinished;
  final void Function(CardSwiperDirection direction) onTrigger;

  VoidCallback? _onDirection(CardSwiperDirection direction) {
    if (isDeckFinished) return null;
    return () => onTrigger(direction);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _SwiperActionButton(
          icon: Icons.rotate_left,
          iconColor: Colors.orange,
          backgroundColor: Colors.orange.withOpacity(0.12),
          size: 52,
          onTap: () => controller.undo(),
        ),
        _SwiperActionButton(
          icon: Icons.close,
          iconColor: Colors.redAccent,
          backgroundColor: Colors.redAccent.withOpacity(0.15),
          size: 64,
          onTap: _onDirection(CardSwiperDirection.left),
        ),
        _SwiperActionButton(
          icon: Icons.star,
          iconColor: Colors.lightBlueAccent,
          backgroundColor: Colors.lightBlueAccent.withOpacity(0.15),
          size: 48,
          onTap: _onDirection(CardSwiperDirection.top),
        ),
        _SwiperActionButton(
          icon: Icons.favorite,
          iconColor: Colors.green,
          backgroundColor: Colors.green.withOpacity(0.15),
          size: 64,
          onTap: _onDirection(CardSwiperDirection.right),
        ),
        _SwiperActionButton(
          icon: Icons.flash_on,
          iconColor: Colors.deepPurple,
          backgroundColor: Colors.deepPurple.withOpacity(0.15),
          size: 48,
          onTap: isDeckFinished ? null : () {},
        ),
      ],
    );
  }
}

class _SwiperActionButton extends StatelessWidget {
  const _SwiperActionButton({
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.size,
    this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final double size;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = onTap != null;
    return Material(
      color: isEnabled ? backgroundColor : backgroundColor.withOpacity(0.2),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          height: size,
          width: size,
          child: Icon(
            icon,
            color: isEnabled ? iconColor : iconColor.withOpacity(0.35),
            size: size * 0.46,
          ),
        ),
      ),
    );
  }
}

class _EmptyDeckPlaceholder extends StatelessWidget {
  const _EmptyDeckPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.sentiment_satisfied_outlined,
            size: 56,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 12),
          Text(
            'No more adventurers nearby',
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class ChatViewPage extends StatefulWidget {
  const ChatViewPage({super.key});

  @override
  State<ChatViewPage> createState() => _ChatViewPageState();
}

class _ChatViewPageState extends State<ChatViewPage> {
  late ChatController chatController;
  final ChatUser currentUser = ChatUser(id: '1', name: 'You');
  final ChatUser otherUser = ChatUser(id: '2', name: 'Bella');

  List<Message> messageList = [
    Message(
      id: '1',
      message: 'Hey! How are you doing? 🐐',
      createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
      sentBy: '2',
      messageType: MessageType.text,
    ),
    Message(
      id: '2',
      message: 'I\'m doing great! Just finished grazing in the meadow 🌱',
      createdAt: DateTime.now().subtract(const Duration(minutes: 3)),
      sentBy: '1',
      messageType: MessageType.text,
    ),
    Message(
      id: '3',
      message:
          'That sounds amazing! Would you like to meet up at the barn later? ❤️',
      createdAt: DateTime.now().subtract(const Duration(minutes: 1)),
      sentBy: '2',
      messageType: MessageType.text,
    ),
  ];

  @override
  void initState() {
    super.initState();
    chatController = ChatController(
      initialMessageList: messageList,
      scrollController: ScrollController(),
      currentUser: currentUser,
      otherUsers: [otherUser],
    );
  }

  void onSendTap(
    String message,
    ReplyMessage replyMessage,
    MessageType messageType,
  ) {
    final newMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      message: message,
      createdAt: DateTime.now(),
      sentBy: currentUser.id,
      replyMessage: replyMessage,
      messageType: messageType,
    );
    chatController.addMessage(newMessage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat with Bella 💕'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: ChatView(
        chatController: chatController,
        onSendTap: onSendTap,
        chatViewState: ChatViewState.hasMessages,
        chatViewStateConfig: const ChatViewStateConfiguration(
          loadingWidgetConfig: ChatViewStateWidgetConfiguration(
            loadingIndicatorColor: Colors.pink,
          ),
          onReloadButtonTap: null,
        ),
        typeIndicatorConfig: TypeIndicatorConfiguration(
          flashingCircleBrightColor: Theme.of(context).colorScheme.primary,
          flashingCircleDarkColor: Colors.grey,
        ),
        appBar: ChatViewAppBar(
          elevation: 2,
          backGroundColor: Theme.of(context).colorScheme.primary,
          profilePicture: 'assets/2.png',
          chatTitle: 'Bella',
          chatTitleTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          userStatus: 'Online',
          userStatusTextStyle: const TextStyle(color: Colors.white70),
        ),
        chatBubbleConfig: ChatBubbleConfiguration(
          outgoingChatBubbleConfig: ChatBubble(
            linkPreviewConfig: const LinkPreviewConfiguration(
              backgroundColor: Colors.white,
              bodyStyle: TextStyle(color: Colors.grey, fontSize: 16),
              titleStyle: TextStyle(color: Colors.black, fontSize: 20),
            ),
            receiptsWidgetConfig: const ReceiptsWidgetConfig(
              showReceiptsIn: ShowReceiptsIn.all,
            ),
            color: Theme.of(context).colorScheme.primary,
          ),
          inComingChatBubbleConfig: ChatBubble(
            linkPreviewConfig: const LinkPreviewConfiguration(
              linkStyle: TextStyle(
                color: Colors.white,
                decoration: TextDecoration.underline,
              ),
              backgroundColor: Colors.grey,
              bodyStyle: TextStyle(color: Colors.white, fontSize: 16),
              titleStyle: TextStyle(color: Colors.white, fontSize: 20),
            ),
            textStyle: const TextStyle(color: Colors.white),
            onMessageRead: (message) {},
            senderNameTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
            color: Colors.grey.shade600,
          ),
        ),
        sendMessageConfig: SendMessageConfiguration(
          imagePickerIconsConfig: ImagePickerIconsConfiguration(
            cameraIconColor: Theme.of(context).colorScheme.primary,
            galleryIconColor: Theme.of(context).colorScheme.primary,
          ),
          replyMessageColor: Colors.grey,
          defaultSendButtonColor: Theme.of(context).colorScheme.primary,
          replyDialogColor: Colors.grey.shade100,
          replyTitleColor: Theme.of(context).colorScheme.primary,
          textFieldBackgroundColor: Colors.white,
          closeIconColor: Theme.of(context).colorScheme.primary,
          textFieldConfig: const TextFieldConfiguration(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            maxLines: 5,
            minLines: 1,
            textStyle: TextStyle(color: Colors.black),
            hintText: 'Type a message...',
            hintStyle: TextStyle(color: Colors.grey),
          ),
          micIconColor: Theme.of(context).colorScheme.primary,
          voiceRecordingConfiguration: VoiceRecordingConfiguration(
            backgroundColor: Theme.of(context).colorScheme.primary,
            recorderIconColor: Colors.white,
            waveStyle: const WaveStyle(
              showMiddleLine: false,
              waveColor: Colors.white,
              extendWaveform: true,
            ),
          ),
        ),
        chatBackgroundConfig: ChatBackgroundConfiguration(
          messageTimeIconColor: Colors.grey,
          defaultGroupSeparatorConfig: DefaultGroupSeparatorConfiguration(
            textStyle: TextStyle(color: Colors.grey.shade600, fontSize: 17),
          ),
          backgroundColor: Colors.grey.shade50,
        ),
        profileCircleConfig: const ProfileCircleConfiguration(
          profileImageUrl: 'assets/2.png',
        ),
        repliedMessageConfig: RepliedMessageConfiguration(
          backgroundColor: Theme.of(
            context,
          ).colorScheme.primary.withOpacity(0.2),
          verticalBarColor: Theme.of(context).colorScheme.primary,
          repliedMsgAutoScrollConfig: RepliedMsgAutoScrollConfig(
            enableHighlightRepliedMsg: true,
            highlightColor: Theme.of(
              context,
            ).colorScheme.primary.withOpacity(0.3),
            highlightScale: 1.1,
          ),
          textStyle: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.25,
          ),
          replyTitleTextStyle: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        swipeToReplyConfig: SwipeToReplyConfiguration(
          replyIconColor: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  @override
  void dispose() {
    chatController.dispose();
    super.dispose();
  }
}

class Profile {
  const Profile({
    required this.name,
    required this.age,
    required this.imagePath,
  });

  final String name;
  final int age;
  final String imagePath;
}
