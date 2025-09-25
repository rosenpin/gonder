import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gonder/features/profile/data/profile_form_data.dart';

class PreferenceSettings {
  const PreferenceSettings({
    required this.ageRange,
    required this.maxDistanceKm,
    required this.selectedGenders,
    required this.city,
    required this.useDeviceLocation,
    required this.notificationsEnabled,
    required this.newMatchAlerts,
  });

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
}

PreferenceSettings defaultPreferences() {
  return PreferenceSettings(
    ageRange: const RangeValues(24, 34),
    maxDistanceKm: 25,
    selectedGenders: {GenderIdentity.female, GenderIdentity.male},
    city: 'San Francisco, CA',
    useDeviceLocation: false,
    notificationsEnabled: true,
    newMatchAlerts: true,
  );
}

abstract class PreferencesStore {
  Future<PreferenceSettings> load();
  Future<void> save(PreferenceSettings settings);
}

class InMemoryPreferencesStore implements PreferencesStore {
  factory InMemoryPreferencesStore() => _instance;

  InMemoryPreferencesStore._internal();

  static final InMemoryPreferencesStore _instance =
      InMemoryPreferencesStore._internal();

  PreferenceSettings _cache = defaultPreferences();

  @override
  Future<PreferenceSettings> load() async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    return _cache;
  }

  @override
  Future<void> save(PreferenceSettings settings) async {
    await Future<void>.delayed(const Duration(milliseconds: 180));
    _cache = settings;
  }
}

final PreferencesStore preferencesStore = InMemoryPreferencesStore();
