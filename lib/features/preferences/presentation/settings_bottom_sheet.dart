import 'package:flutter/material.dart';
import 'package:gonder/features/preferences/data/preferences_store.dart';
import 'package:gonder/features/profile/data/profile_form_data.dart';

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
  late final TextEditingController _cityController;

  @override
  void initState() {
    super.initState();
    _cityController = TextEditingController();
    _load();
  }

  Future<void> _load() async {
    final result = await preferencesStore.load();
    setState(() {
      _settings = result;
      _cityController.text = result.city;
    });
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  void _updateSettings(
    PreferenceSettings Function(PreferenceSettings) updater,
  ) {
    final current = _settings;
    if (current == null) return;
    setState(() {
      _settings = updater(current);
    });
  }

  Future<void> _save() async {
    final current = _settings;
    if (current == null) return;
    setState(() => _isSaving = true);
    final next = current.copyWith(city: _cityController.text.trim());
    await preferencesStore.save(next);
    if (!mounted) return;
    setState(() => _isSaving = false);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Preferences saved.')));
  }

  void _reset() {
    final defaults = defaultPreferences();
    setState(() {
      _settings = defaults;
      _cityController.text = defaults.city;
    });
  }

  @override
  Widget build(BuildContext context) {
    final settings = _settings;
    final theme = Theme.of(context);

    if (settings == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final chips = GenderIdentity.values;

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
                    for (final gender in chips)
                      FilterChip(
                        label: Text(_genderLabel(gender)),
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

  String _genderLabel(GenderIdentity gender) {
    switch (gender) {
      case GenderIdentity.female:
        return 'Women';
      case GenderIdentity.male:
        return 'Men';
      case GenderIdentity.nonBinary:
        return 'Non-binary';
      case GenderIdentity.other:
        return 'Everyone';
    }
  }
}
