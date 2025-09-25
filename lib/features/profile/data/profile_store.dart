import 'dart:async';

import 'package:gonder/features/profile/data/profile_form_data.dart';

abstract class ProfileStore {
  Future<ProfileFormData> load();
  Future<void> save(ProfileFormData data);
}

class InMemoryProfileStore implements ProfileStore {
  InMemoryProfileStore({ProfileFormData? seed})
    : _cache = seed ?? defaultProfile();

  ProfileFormData _cache;

  @override
  Future<ProfileFormData> load() async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return _cache;
  }

  @override
  Future<void> save(ProfileFormData data) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    _cache = data;
  }
}
