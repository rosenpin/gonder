import 'dart:async';

import 'package:gonder/models/user_profile.dart';

abstract class DiscoveryRepository {
  Future<List<UserProfile>> fetchNearbyProfiles();
}

class InMemoryDiscoveryRepository implements DiscoveryRepository {
  InMemoryDiscoveryRepository({List<UserProfile>? seed})
    : _profiles = seed ?? _defaultProfiles();

  final List<UserProfile> _profiles;

  @override
  Future<List<UserProfile>> fetchNearbyProfiles() async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    return List<UserProfile>.from(_profiles);
  }
}

List<UserProfile> _defaultProfiles() {
  return [
    UserProfile(
      id: 'profile-1',
      displayName: 'David',
      age: 28,
      jobTitle: 'Software Engineer',
      bio: 'Building apps and hiking trails.',
      city: 'San Jose, CA',
      photos: const ['assets/1.png'],
      gender: GenderIdentity.male,
      interestedIn: const [GenderIdentity.female],
      lookingFor: LookingFor.relationship,
      distanceKm: 12,
    ),
    UserProfile(
      id: 'profile-2',
      displayName: 'Esther',
      age: 27,
      jobTitle: 'Product Manager',
      bio: 'Turning ideas into lovable products.',
      city: 'Oakland, CA',
      photos: const ['assets/2.png'],
      gender: GenderIdentity.female,
      interestedIn: const [GenderIdentity.male],
      lookingFor: LookingFor.adventure,
      distanceKm: 9,
    ),
    UserProfile(
      id: 'profile-3',
      displayName: 'Miriam',
      age: 29,
      jobTitle: 'Visual Designer',
      bio: 'I design playful brand systems.',
      city: 'San Francisco, CA',
      photos: const ['assets/3.png'],
      gender: GenderIdentity.female,
      interestedIn: const [GenderIdentity.male],
      lookingFor: LookingFor.friendship,
      distanceKm: 5,
    ),
    UserProfile(
      id: 'profile-4',
      displayName: 'Solomon',
      age: 26,
      jobTitle: 'Data Scientist',
      bio: 'Coffee lover and data storyteller.',
      city: 'San Mateo, CA',
      photos: const ['assets/4.png'],
      gender: GenderIdentity.male,
      interestedIn: const [GenderIdentity.female],
      lookingFor: LookingFor.relationship,
      distanceKm: 11,
    ),
    UserProfile(
      id: 'profile-5',
      displayName: 'Noah',
      age: 31,
      jobTitle: 'Chef',
      bio: 'Serving seasonal plates and dad jokes.',
      city: 'Berkeley, CA',
      photos: const ['assets/5.png'],
      gender: GenderIdentity.male,
      interestedIn: const [GenderIdentity.female],
      lookingFor: LookingFor.adventure,
      distanceKm: 7,
    ),
    UserProfile(
      id: 'profile-6',
      displayName: 'Deborah',
      age: 25,
      jobTitle: 'UX Researcher',
      bio: 'Asking the whys to design better journeys.',
      city: 'San Francisco, CA',
      photos: const ['assets/6.png'],
      gender: GenderIdentity.female,
      interestedIn: const [GenderIdentity.male],
      lookingFor: LookingFor.relationship,
      distanceKm: 10,
    ),
  ];
}
