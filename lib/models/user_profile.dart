enum GenderIdentity { female, male, nonBinary, other }

enum LookingFor { relationship, friendship, adventure }

class UserProfile {
  const UserProfile({
    required this.id,
    required this.displayName,
    required this.age,
    required this.jobTitle,
    required this.bio,
    required this.city,
    required this.photos,
    required this.gender,
    required this.interestedIn,
    required this.lookingFor,
    required this.distanceKm,
  });

  final String id;
  final String displayName;
  final int age;
  final String jobTitle;
  final String bio;
  final String city;
  final List<String> photos;
  final GenderIdentity gender;
  final List<GenderIdentity> interestedIn;
  final LookingFor lookingFor;
  final int distanceKm;

  UserProfile copyWith({
    String? id,
    String? displayName,
    int? age,
    String? jobTitle,
    String? bio,
    String? city,
    List<String>? photos,
    GenderIdentity? gender,
    List<GenderIdentity>? interestedIn,
    LookingFor? lookingFor,
    int? distanceKm,
  }) {
    return UserProfile(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      age: age ?? this.age,
      jobTitle: jobTitle ?? this.jobTitle,
      bio: bio ?? this.bio,
      city: city ?? this.city,
      photos: photos ?? List<String>.from(this.photos),
      gender: gender ?? this.gender,
      interestedIn: interestedIn != null
          ? List<GenderIdentity>.from(interestedIn)
          : List<GenderIdentity>.from(this.interestedIn),
      lookingFor: lookingFor ?? this.lookingFor,
      distanceKm: distanceKm ?? this.distanceKm,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'displayName': displayName,
      'age': age,
      'jobTitle': jobTitle,
      'bio': bio,
      'city': city,
      'photos': photos,
      'gender': gender.name,
      'interestedIn': interestedIn.map((e) => e.name).toList(),
      'lookingFor': lookingFor.name,
      'distanceKm': distanceKm,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      displayName: json['displayName'] as String,
      age: json['age'] as int,
      jobTitle: json['jobTitle'] as String? ?? '',
      bio: json['bio'] as String? ?? '',
      city: json['city'] as String? ?? '',
      photos: (json['photos'] as List<dynamic>? ?? const [])
          .map((e) => e as String)
          .toList(),
      gender: _genderFromJson(json['gender'] as String?),
      interestedIn: (json['interestedIn'] as List<dynamic>? ?? const [])
          .map((value) => _genderFromJson(value as String?))
          .toList(),
      lookingFor: _lookingForFromJson(json['lookingFor'] as String?),
      distanceKm: json['distanceKm'] as int? ?? 0,
    );
  }

  static GenderIdentity _genderFromJson(String? value) {
    switch (value) {
      case 'male':
        return GenderIdentity.male;
      case 'nonBinary':
        return GenderIdentity.nonBinary;
      case 'other':
        return GenderIdentity.other;
      case 'female':
      default:
        return GenderIdentity.female;
    }
  }

  static LookingFor _lookingForFromJson(String? value) {
    switch (value) {
      case 'friendship':
        return LookingFor.friendship;
      case 'adventure':
        return LookingFor.adventure;
      case 'relationship':
      default:
        return LookingFor.relationship;
    }
  }
}

extension GenderIdentityLabel on GenderIdentity {
  String get label {
    switch (this) {
      case GenderIdentity.female:
        return 'Female';
      case GenderIdentity.male:
        return 'Male';
      case GenderIdentity.nonBinary:
        return 'Non-binary';
      case GenderIdentity.other:
        return 'Other';
    }
  }
}

extension LookingForLabel on LookingFor {
  String get label {
    switch (this) {
      case LookingFor.relationship:
        return 'Relationship';
      case LookingFor.friendship:
        return 'Friendship';
      case LookingFor.adventure:
        return 'Adventure';
    }
  }
}
