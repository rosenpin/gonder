import 'package:chatview/chatview.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late ChatController chatController;
  final ChatUser currentUser = ChatUser(id: '1', name: 'You');
  final ChatUser otherUser = ChatUser(id: '2', name: 'Bella');

  final List<Message> initialMessages = [
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
      initialMessageList: initialMessages,
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
          ).colorScheme.primary.withValues(alpha: 0.2),
          verticalBarColor: Theme.of(context).colorScheme.primary,
          repliedMsgAutoScrollConfig: RepliedMsgAutoScrollConfig(
            enableHighlightRepliedMsg: true,
            highlightColor: Theme.of(
              context,
            ).colorScheme.primary.withValues(alpha: 0.3),
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
