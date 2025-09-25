import 'dart:async';

import 'package:gonder/models/conversation.dart';
import 'package:gonder/models/message.dart';

abstract class ConversationRepository {
  Future<Conversation> fetchConversation(String conversationId);
  Future<Conversation> sendMessage({
    required String conversationId,
    required MessageModel message,
  });
}

class InMemoryConversationRepository implements ConversationRepository {
  InMemoryConversationRepository({Conversation? seed})
    : _conversation = seed ?? _defaultConversation();

  Conversation _conversation;

  @override
  Future<Conversation> fetchConversation(String conversationId) async {
    await Future<void>.delayed(const Duration(milliseconds: 140));
    return _conversation;
  }

  @override
  Future<Conversation> sendMessage({
    required String conversationId,
    required MessageModel message,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    _conversation = _conversation.copyWith(
      messages: [..._conversation.messages, message],
    );
    return _conversation;
  }
}

Conversation _defaultConversation() {
  final now = DateTime.now();
  return Conversation(
    id: 'conversation-1',
    matchId: 'match-1',
    participantIds: const ['user-1', 'user-2'],
    messages: [
      MessageModel(
        id: 'm1',
        senderId: 'user-1',
        body: "You're really pretty!",
        sentAt: now.subtract(const Duration(hours: 2, minutes: 6)),
        status: MessageStatus.sent,
      ),
      MessageModel(
        id: 'm2',
        senderId: 'user-2',
        body: 'Thank you',
        sentAt: now.subtract(const Duration(hours: 2, minutes: 5)),
        status: MessageStatus.read,
      ),
      MessageModel(
        id: 'm3',
        senderId: 'user-2',
        body: 'Your really handsome!!',
        sentAt: now.subtract(const Duration(hours: 2, minutes: 3)),
        status: MessageStatus.read,
      ),
      MessageModel(
        id: 'm4',
        senderId: 'user-1',
        body: 'Thanks :)\nWanna hang out sometime? Or go out',
        sentAt: now.subtract(const Duration(hours: 1, minutes: 59)),
        status: MessageStatus.sent,
      ),
      MessageModel(
        id: 'm5',
        senderId: 'user-2',
        body: "Yes I'd love too",
        sentAt: now.subtract(const Duration(hours: 1, minutes: 56)),
        status: MessageStatus.read,
      ),
    ],
  );
}
