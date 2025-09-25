import 'package:gonder/models/user_profile.dart';

class MatchModel {
  const MatchModel({
    required this.id,
    required this.userId,
    required this.matchedUser,
    required this.matchedOn,
    required this.lastMessagePreview,
  });

  final String id;
  final String userId;
  final UserProfile matchedUser;
  final DateTime matchedOn;
  final String lastMessagePreview;

  MatchModel copyWith({
    String? id,
    String? userId,
    UserProfile? matchedUser,
    DateTime? matchedOn,
    String? lastMessagePreview,
  }) {
    return MatchModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      matchedUser: matchedUser ?? this.matchedUser,
      matchedOn: matchedOn ?? this.matchedOn,
      lastMessagePreview: lastMessagePreview ?? this.lastMessagePreview,
    );
  }

  factory MatchModel.fromJson(Map<String, dynamic> json) {
    return MatchModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      matchedUser: UserProfile.fromJson(
        json['matchedUser'] as Map<String, dynamic>,
      ),
      matchedOn: DateTime.parse(json['matchedOn'] as String),
      lastMessagePreview: json['lastMessagePreview'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'matchedUser': matchedUser.toJson(),
      'matchedOn': matchedOn.toIso8601String(),
      'lastMessagePreview': lastMessagePreview,
    };
  }
}
