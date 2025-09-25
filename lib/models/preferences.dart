import 'package:flutter/material.dart';
import 'package:gonder/models/user_profile.dart';

class PreferenceSettings {
  const PreferenceSettings({
    required this.userId,
    required this.ageRange,
    required this.maxDistanceKm,
    required this.selectedGenders,
    required this.city,
    required this.useDeviceLocation,
    required this.notificationsEnabled,
    required this.newMatchAlerts,
  });

  final String userId;
  final RangeValues ageRange;
  final int maxDistanceKm;
  final Set<GenderIdentity> selectedGenders;
  final String city;
  final bool useDeviceLocation;
  final bool notificationsEnabled;
  final bool newMatchAlerts;

  PreferenceSettings copyWith({
    RangeValues? ageRange,
    int? maxDistanceKm,
    Set<GenderIdentity>? selectedGenders,
    String? city,
    bool? useDeviceLocation,
    bool? notificationsEnabled,
    bool? newMatchAlerts,
  }) {
    return PreferenceSettings(
      userId: userId,
      ageRange: ageRange ?? this.ageRange,
      maxDistanceKm: maxDistanceKm ?? this.maxDistanceKm,
      selectedGenders: selectedGenders != null
          ? Set<GenderIdentity>.from(selectedGenders)
          : Set<GenderIdentity>.from(this.selectedGenders),
      city: city ?? this.city,
      useDeviceLocation: useDeviceLocation ?? this.useDeviceLocation,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      newMatchAlerts: newMatchAlerts ?? this.newMatchAlerts,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'ageRange': {'start': ageRange.start, 'end': ageRange.end},
      'maxDistanceKm': maxDistanceKm,
      'selectedGenders': selectedGenders.map((e) => e.name).toList(),
      'city': city,
      'useDeviceLocation': useDeviceLocation,
      'notificationsEnabled': notificationsEnabled,
      'newMatchAlerts': newMatchAlerts,
    };
  }

  factory PreferenceSettings.fromJson(Map<String, dynamic> json) {
    final genders = (json['selectedGenders'] as List<dynamic>? ?? const [])
        .map((value) => _genderFromJson(value as String?))
        .toSet();
    return PreferenceSettings(
      userId: json['userId'] as String,
      ageRange: RangeValues(
        (json['ageRange']?['start'] as num?)?.toDouble() ?? 18,
        (json['ageRange']?['end'] as num?)?.toDouble() ?? 30,
      ),
      maxDistanceKm: json['maxDistanceKm'] as int? ?? 25,
      selectedGenders: genders.isEmpty
          ? {GenderIdentity.female, GenderIdentity.male}
          : genders,
      city: json['city'] as String? ?? '',
      useDeviceLocation: json['useDeviceLocation'] as bool? ?? false,
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      newMatchAlerts: json['newMatchAlerts'] as bool? ?? true,
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
}
