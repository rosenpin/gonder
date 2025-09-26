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
      bio: '🏔️ Building apps by day, hiking trails by weekend. Love exploring new tech stacks and mountain peaks. Currently obsessed with Flutter and finding the perfect coffee shop for remote work. Looking for someone to share adventures with! 🚀☕',
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
      bio: '✨ Passionate about turning crazy ideas into products people love. When I\'m not iterating on user stories, you\'ll find me trying new restaurants, practicing yoga, or planning my next spontaneous weekend getaway. Life\'s too short for boring conversations! 🍜🧘‍♀️',
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
      bio: '🎨 I create playful brand systems that make people smile. Typography nerd, color theory enthusiast, and weekend pottery class attendee. Always up for gallery openings, design conferences, or a good debate about serif vs sans-serif fonts! 🏺✏️',
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
      bio: '📊 Turning data into stories and coffee into code. Python is my language of choice, but I also speak fluent sarcasm. When not wrestling with datasets, I\'m probably at a local café reading sci-fi novels or attempting to master latte art. Warning: will talk about AI ethics! 🤖☕',
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
      bio: '👨‍🍳 Serving seasonal plates and dad jokes since 2018. Believe that life is too short for bad food and boring conversations. Farm-to-table enthusiast, weekend forager, and expert at making people laugh while they wait for their food. Let me cook for you! 🥘🍄',
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
      bio: '🔍 Professional question-asker and empathy mapper. Spend my days figuring out why users click where they click, my evenings binge-watching true crime documentaries. Love board games, escape rooms, and any activity that involves solving puzzles. Myers-Briggs: INFJ 🧩🎲',
      city: 'San Francisco, CA',
      photos: const ['assets/6.png'],
      gender: GenderIdentity.female,
      interestedIn: const [GenderIdentity.male],
      lookingFor: LookingFor.relationship,
      distanceKm: 10,
    ),
  ];
}
