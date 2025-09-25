class ProfileFormData {
  ProfileFormData({
    required this.displayName,
    required this.age,
    required this.jobTitle,
    required this.bio,
    required this.city,
    required this.photos,
    required this.gender,
    required this.interestedIn,
    required this.lookingFor,
  });

  final String displayName;
  final int age;
  final String jobTitle;
  final String bio;
  final String city;
  final List<String> photos;
  final GenderIdentity gender;
  final List<GenderIdentity> interestedIn;
  final LookingFor lookingFor;

  ProfileFormData copyWith({
    String? displayName,
    int? age,
    String? jobTitle,
    String? bio,
    String? city,
    List<String>? photos,
    GenderIdentity? gender,
    List<GenderIdentity>? interestedIn,
    LookingFor? lookingFor,
  }) {
    return ProfileFormData(
      displayName: displayName ?? this.displayName,
      age: age ?? this.age,
      jobTitle: jobTitle ?? this.jobTitle,
      bio: bio ?? this.bio,
      city: city ?? this.city,
      photos: photos ?? this.photos,
      gender: gender ?? this.gender,
      interestedIn: interestedIn ?? this.interestedIn,
      lookingFor: lookingFor ?? this.lookingFor,
    );
  }
}

enum GenderIdentity { female, male, nonBinary, other }

enum LookingFor { relationship, friendship, adventure }

ProfileFormData defaultProfile() {
  return ProfileFormData(
    displayName: 'Angel',
    age: 27,
    jobTitle: 'Product Designer',
    bio: 'Designing joyful experiences one swipe at a time.',
    city: 'San Francisco, CA',
    photos: const ['assets/2.png', 'assets/3.png', 'assets/4.png'],
    gender: GenderIdentity.female,
    interestedIn: const [GenderIdentity.male],
    lookingFor: LookingFor.relationship,
  );
}
