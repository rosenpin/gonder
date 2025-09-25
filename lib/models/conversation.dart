import 'package:gonder/models/message.dart';

class Conversation {
  const Conversation({
    required this.id,
    required this.matchId,
    required this.participantIds,
    required this.messages,
  });

  final String id;
  final String matchId;
  final List<String> participantIds;
  final List<MessageModel> messages;

  Conversation copyWith({
    String? id,
    String? matchId,
    List<String>? participantIds,
    List<MessageModel>? messages,
  }) {
    return Conversation(
      id: id ?? this.id,
      matchId: matchId ?? this.matchId,
      participantIds: participantIds ?? List<String>.from(this.participantIds),
      messages: messages != null
          ? List<MessageModel>.from(messages)
          : List<MessageModel>.from(this.messages),
    );
  }

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'] as String,
      matchId: json['matchId'] as String,
      participantIds: (json['participantIds'] as List<dynamic>? ?? const [])
          .map((e) => e as String)
          .toList(),
      messages: (json['messages'] as List<dynamic>? ?? const [])
          .map((item) => MessageModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'matchId': matchId,
      'participantIds': participantIds,
      'messages': messages.map((m) => m.toJson()).toList(),
    };
  }
}
