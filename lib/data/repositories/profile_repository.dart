import 'dart:async';

import 'package:gonder/models/user_profile.dart';

abstract class ProfileRepository {
  Future<UserProfile> fetchCurrentProfile();
  Future<void> saveProfile(UserProfile profile);
}

class InMemoryProfileRepository implements ProfileRepository {
  InMemoryProfileRepository({UserProfile? seed})
    : _profile = seed ?? _defaultProfile();

  UserProfile _profile;

  @override
  Future<UserProfile> fetchCurrentProfile() async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    return _profile;
  }

  @override
  Future<void> saveProfile(UserProfile profile) async {
    await Future<void>.delayed(const Duration(milliseconds: 180));
    _profile = profile;
  }
}

UserProfile _defaultProfile() {
  return UserProfile(
    id: 'user-1',
    displayName: 'Angel',
    age: 27,
    jobTitle: 'Product Designer',
    bio: 'Designing joyful experiences one swipe at a time.',
    city: 'San Francisco, CA',
    photos: const ['assets/2.png', 'assets/3.png', 'assets/4.png'],
    gender: GenderIdentity.female,
    interestedIn: const [GenderIdentity.male],
    lookingFor: LookingFor.relationship,
    distanceKm: 8,
  );
}
