enum MessageStatus { sending, sent, delivered, read }

enum MessageType { text, image, gif }

class MessageModel {
  const MessageModel({
    required this.id,
    required this.senderId,
    required this.body,
    required this.sentAt,
    this.status = MessageStatus.sent,
    this.type = MessageType.text,
  });

  final String id;
  final String senderId;
  final String body;
  final DateTime sentAt;
  final MessageStatus status;
  final MessageType type;

  MessageModel copyWith({
    String? id,
    String? senderId,
    String? body,
    DateTime? sentAt,
    MessageStatus? status,
    MessageType? type,
  }) {
    return MessageModel(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      body: body ?? this.body,
      sentAt: sentAt ?? this.sentAt,
      status: status ?? this.status,
      type: type ?? this.type,
    );
  }

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as String,
      senderId: json['senderId'] as String,
      body: json['body'] as String? ?? '',
      sentAt: DateTime.parse(json['sentAt'] as String),
      status: _statusFromJson(json['status'] as String?),
      type: _typeFromJson(json['type'] as String?),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'body': body,
      'sentAt': sentAt.toIso8601String(),
      'status': status.name,
      'type': type.name,
    };
  }

  static MessageStatus _statusFromJson(String? value) {
    switch (value) {
      case 'sending':
        return MessageStatus.sending;
      case 'delivered':
        return MessageStatus.delivered;
      case 'read':
        return MessageStatus.read;
      case 'sent':
      default:
        return MessageStatus.sent;
    }
  }

  static MessageType _typeFromJson(String? value) {
    switch (value) {
      case 'image':
        return MessageType.image;
      case 'gif':
        return MessageType.gif;
      case 'text':
      default:
        return MessageType.text;
    }
  }
}
