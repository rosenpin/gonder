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
      bio: 'Weekend hiker who codes during the week. Always down for a good coffee shop recommendation or a spontaneous road trip. Currently building the next big app, but let\'s talk about something more interesting than work!',
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
      bio: 'I turn chaotic ideas into products people actually want to use. When I\'m not in meetings, you\'ll find me exploring new restaurants or planning my next weekend adventure. Life\'s too short for boring conversations and bad food!',
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
      bio: 'I make brands that don\'t suck. Obsessed with good typography, great coffee, and terrible puns. Currently learning pottery because apparently I need another creative outlet. Always up for gallery hopping or heated debates about comic sans.',
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
      bio: 'I make datasets tell stories and turn coffee into insights. When I\'m not fighting with Python, I\'m probably reading sci-fi novels or attempting latte art. Fair warning: I will definitely bring up AI ethics on the first date.',
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
      bio: 'I cook with seasonal ingredients and serve terrible dad jokes on the side. Farm-to-table enthusiast who believes the best conversations happen in the kitchen. Let me cook for you sometime?',
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
      bio: 'Professional question-asker who figures out why people click the wrong buttons. When I\'m not running user interviews, I\'m probably solving escape rooms or binge-watching true crime. INFJ who actually enjoys small talk.',
      city: 'San Francisco, CA',
      photos: const ['assets/6.png'],
      gender: GenderIdentity.female,
      interestedIn: const [GenderIdentity.male],
      lookingFor: LookingFor.relationship,
      distanceKm: 10,
    ),
    // Test profile with long bio
    UserProfile(
      id: 'profile-7',
      displayName: 'Maya',
      age: 30,
      jobTitle: 'Travel Writer',
      bio: 'Digital nomad who has lived in 15 countries and counting. I write about hidden gems, local food scenes, and the art of slow travel. Currently based in California but always planning my next adventure. I believe the best stories happen when you get a little lost, whether that\'s in a new city or a really good conversation. Looking for someone who gets excited about spontaneous weekend trips and doesn\'t mind that I have strong opinions about which airline has the best snacks.',
      city: 'San Francisco, CA',
      photos: const ['assets/1.png'],
      gender: GenderIdentity.female,
      interestedIn: const [GenderIdentity.male],
      lookingFor: LookingFor.relationship,
      distanceKm: 15,
    ),
    // Test profile with no bio
    UserProfile(
      id: 'profile-8',
      displayName: 'Alex',
      age: 25,
      jobTitle: 'Musician',
      bio: '',
      city: 'Oakland, CA',
      photos: const ['assets/2.png'],
      gender: GenderIdentity.male,
      interestedIn: const [GenderIdentity.female],
      lookingFor: LookingFor.adventure,
      distanceKm: 8,
    ),
    // Test profile with international content
    UserProfile(
      id: 'profile-9',
      displayName: 'Priya',
      age: 28,
      jobTitle: 'Cultural Consultant',
      bio: 'Born in Mumbai, raised in London, living in SF. I help companies navigate cultural differences and love sharing stories from around the world. Fluent in Hindi, English, and sarcasm. Always up for trying new cuisines or teaching someone how to make proper chai.',
      city: 'San Francisco, CA',
      photos: const ['assets/3.png'],
      gender: GenderIdentity.female,
      interestedIn: const [GenderIdentity.male, GenderIdentity.female],
      lookingFor: LookingFor.friendship,
      distanceKm: 12,
    ),
  ];
}
