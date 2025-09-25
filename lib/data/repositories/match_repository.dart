import 'dart:async';

import 'package:gonder/models/match.dart';
import 'package:gonder/models/user_profile.dart';

abstract class MatchRepository {
  Future<List<MatchModel>> fetchMatches(String userId);
}

class InMemoryMatchRepository implements MatchRepository {
  InMemoryMatchRepository({List<MatchModel>? seed})
    : _matches = seed ?? _defaultMatches();

  final List<MatchModel> _matches;

  @override
  Future<List<MatchModel>> fetchMatches(String userId) async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    return _matches.where((match) => match.userId == userId).toList();
  }
}

List<MatchModel> _defaultMatches() {
  final now = DateTime.now();
  return [
    MatchModel(
      id: 'match-1',
      userId: 'user-1',
      matchedUser: UserProfile(
        id: 'user-2',
        displayName: 'Angel',
        age: 26,
        jobTitle: 'Photographer',
        bio: 'Capturing candid moments and chasing sunsets.',
        city: 'San Francisco, CA',
        photos: const ['assets/3.png', 'assets/4.png'],
        gender: GenderIdentity.female,
        interestedIn: const [GenderIdentity.male],
        lookingFor: LookingFor.relationship,
        distanceKm: 6,
      ),
      matchedOn: now.subtract(const Duration(days: 2)),
      lastMessagePreview: "Yes I'd love too",
    ),
  ];
}
