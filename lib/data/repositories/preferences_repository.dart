import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gonder/models/preferences.dart';
import 'package:gonder/models/user_profile.dart';

abstract class PreferencesRepository {
  Future<PreferenceSettings> load(String userId);
  Future<void> save(PreferenceSettings settings);
}

class InMemoryPreferencesRepository implements PreferencesRepository {
  InMemoryPreferencesRepository({PreferenceSettings? seed})
    : _settings = seed ?? _defaultSettings();

  PreferenceSettings _settings;

  @override
  Future<PreferenceSettings> load(String userId) async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    return _settings.userId == userId ? _settings : _settings.copyWith();
  }

  @override
  Future<void> save(PreferenceSettings settings) async {
    await Future<void>.delayed(const Duration(milliseconds: 160));
    _settings = settings;
  }
}

PreferenceSettings _defaultSettings() {
  return PreferenceSettings(
    userId: 'user-1',
    ageRange: const RangeValues(24, 34),
    maxDistanceKm: 25,
    selectedGenders: {GenderIdentity.male},
    city: 'San Francisco, CA',
    useDeviceLocation: false,
    notificationsEnabled: true,
    newMatchAlerts: true,
  );
}
