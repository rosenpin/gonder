import 'package:flutter/material.dart';
import 'package:gonder/data/repositories/app_repositories.dart';
import 'package:gonder/models/preferences.dart';
import 'package:gonder/models/user_profile.dart';

class SettingsBottomSheet extends StatefulWidget {
  const SettingsBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return const FractionallySizedBox(
          heightFactor: 0.85,
          child: SettingsBottomSheet(),
        );
      },
    );
  }

  @override
  State<SettingsBottomSheet> createState() => _SettingsBottomSheetState();
}

class _SettingsBottomSheetState extends State<SettingsBottomSheet> {
  PreferenceSettings? _settings;
  bool _isSaving = false;
  final TextEditingController _cityController = TextEditingController();

  static const String _userId = 'user-1';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final loaded = await preferencesRepository.load(_userId);
    if (!mounted) return;
    setState(() {
      _settings = loaded;
      _cityController.text = loaded.city;
    });
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  void _updateSettings(
    PreferenceSettings Function(PreferenceSettings) transform,
  ) {
    final current = _settings;
    if (current == null) return;
    setState(() {
      _settings = transform(current);
    });
  }

  Future<void> _save() async {
    final current = _settings;
    if (current == null) return;
    setState(() => _isSaving = true);
    final persisted = current.copyWith(city: _cityController.text.trim());
    await preferencesRepository.save(persisted);
    if (!mounted) return;
    setState(() => _isSaving = false);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Preferences saved.')));
  }

  void _reset() {
    final defaults = _defaultSettings();
    setState(() {
      _settings = defaults;
      _cityController.text = defaults.city;
    });
  }

  @override
  Widget build(BuildContext context) {
    final settings = _settings;
    if (settings == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final theme = Theme.of(context);
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 8),
            child: Container(
              width: 48,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              children: [
                Text(
                  'Discovery Preferences',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                Text(
                  'Age range (${settings.ageRange.start.round()}-${settings.ageRange.end.round()})',
                  style: theme.textTheme.bodyMedium,
                ),
                RangeSlider(
                  values: settings.ageRange,
                  min: 18,
                  max: 80,
                  divisions: 62,
                  labels: RangeLabels(
                    settings.ageRange.start.round().toString(),
                    settings.ageRange.end.round().toString(),
                  ),
                  onChanged: (value) => _updateSettings(
                    (current) => current.copyWith(ageRange: value),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Maximum distance (${settings.maxDistanceKm} km)',
                  style: theme.textTheme.bodyMedium,
                ),
                Slider(
                  value: settings.maxDistanceKm.toDouble(),
                  min: 1,
                  max: 100,
                  divisions: 99,
                  label: '${settings.maxDistanceKm} km',
                  onChanged: (value) => _updateSettings(
                    (current) => current.copyWith(maxDistanceKm: value.round()),
                  ),
                ),
                const SizedBox(height: 24),
                Text('Show me', style: theme.textTheme.bodyMedium),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final gender in GenderIdentity.values)
                      FilterChip(
                        label: Text(gender.label),
                        selected: settings.selectedGenders.contains(gender),
                        onSelected: (selected) => _updateSettings((current) {
                          final next = Set<GenderIdentity>.from(
                            current.selectedGenders,
                          );
                          if (selected) {
                            next.add(gender);
                          } else {
                            next.remove(gender);
                          }
                          if (next.isEmpty) {
                            return current;
                          }
                          return current.copyWith(selectedGenders: next);
                        }),
                      ),
                  ],
                ),
                const SizedBox(height: 24),
                Text('Location', style: theme.textTheme.titleLarge),
                const SizedBox(height: 12),
                SwitchListTile.adaptive(
                  value: settings.useDeviceLocation,
                  title: const Text('Use device location'),
                  subtitle: const Text('Feature coming soon'),
                  onChanged: (enabled) => _updateSettings(
                    (current) => current.copyWith(useDeviceLocation: enabled),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _cityController,
                  decoration: const InputDecoration(
                    labelText: 'Set your location',
                    hintText: 'City, State',
                  ),
                ),
                const SizedBox(height: 24),
                Text('Notifications', style: theme.textTheme.titleLarge),
                const SizedBox(height: 12),
                SwitchListTile.adaptive(
                  value: settings.notificationsEnabled,
                  title: const Text('Enable push notifications'),
                  onChanged: (enabled) => _updateSettings(
                    (current) =>
                        current.copyWith(notificationsEnabled: enabled),
                  ),
                ),
                SwitchListTile.adaptive(
                  value: settings.newMatchAlerts,
                  title: const Text('New match alerts'),
                  onChanged: (enabled) => _updateSettings(
                    (current) => current.copyWith(newMatchAlerts: enabled),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
            child: Row(
              children: [
                TextButton(onPressed: _reset, child: const Text('Reset')),
                const Spacer(),
                FilledButton(
                  onPressed: _isSaving ? null : _save,
                  child: _isSaving
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Save'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PreferenceSettings _defaultSettings() {
    return PreferenceSettings(
      userId: _userId,
      ageRange: const RangeValues(24, 34),
      maxDistanceKm: 25,
      selectedGenders: {GenderIdentity.female, GenderIdentity.male},
      city: 'San Francisco, CA',
      useDeviceLocation: false,
      notificationsEnabled: true,
      newMatchAlerts: true,
    );
  }
}
