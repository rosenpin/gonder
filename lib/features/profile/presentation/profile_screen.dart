import 'package:flutter/material.dart';
import 'package:gonder/data/repositories/app_repositories.dart';
import 'package:gonder/features/preferences/presentation/settings_bottom_sheet.dart';
import 'package:gonder/models/user_profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserProfile? _profile;
  bool _isEditing = false;
  bool _isSaving = false;

  late final TextEditingController _nameController;
  late final TextEditingController _ageController;
  late final TextEditingController _jobController;
  late final TextEditingController _bioController;
  late final TextEditingController _cityController;

  final Set<GenderIdentity> _interestedIn = {};
  GenderIdentity? _gender;
  LookingFor? _lookingFor;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _ageController = TextEditingController();
    _jobController = TextEditingController();
    _bioController = TextEditingController();
    _cityController = TextEditingController();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profile = await profileRepository.fetchCurrentProfile();
    if (!mounted) return;
    _applyProfile(profile);
  }

  void _applyProfile(UserProfile profile) {
    setState(() {
      _profile = profile;
      _gender = profile.gender;
      _lookingFor = profile.lookingFor;
      _interestedIn
        ..clear()
        ..addAll(profile.interestedIn);
      _nameController.text = profile.displayName;
      _ageController.text = profile.age.toString();
      _jobController.text = profile.jobTitle;
      _bioController.text = profile.bio;
      _cityController.text = profile.city;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _jobController.dispose();
    _bioController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing && _profile != null) {
        _applyProfile(_profile!);
      }
    });
  }

  Future<void> _saveProfile() async {
    final current = _profile;
    if (current == null) return;
    final name = _nameController.text.trim();
    final age = int.tryParse(_ageController.text.trim());
    final bio = _bioController.text.trim();
    final job = _jobController.text.trim();
    final city = _cityController.text.trim();

    if (name.isEmpty || age == null || age < 18 || age > 99 || city.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Complete required fields before saving.'),
        ),
      );
      return;
    }
    if (_gender == null || _lookingFor == null || _interestedIn.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Set your discovery preferences first.')),
      );
      return;
    }

    final updated = current.copyWith(
      displayName: name,
      age: age,
      bio: bio,
      jobTitle: job,
      city: city,
      gender: _gender,
      interestedIn: _interestedIn.toList(),
      lookingFor: _lookingFor,
    );

    setState(() => _isSaving = true);
    await profileRepository.saveProfile(updated);
    if (!mounted) return;
    setState(() {
      _profile = updated;
      _isSaving = false;
      _isEditing = false;
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Profile saved.')));
  }

  @override
  Widget build(BuildContext context) {
    final profile = _profile;
    if (profile == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Profile'),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.tune),
              tooltip: 'Discovery settings',
              onPressed: () => SettingsBottomSheet.show(context),
            ),
          if (_isEditing)
            TextButton(
              onPressed: _isSaving ? null : _toggleEditing,
              child: const Text('Cancel'),
            )
          else
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              tooltip: 'Edit profile',
              onPressed: _toggleEditing,
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
        children: [
          _PhotoCarousel(photos: profile.photos),
          const SizedBox(height: 24),
          if (_isEditing)
            _EditableDetails(
              nameController: _nameController,
              ageController: _ageController,
              jobController: _jobController,
              bioController: _bioController,
              cityController: _cityController,
            )
          else
            _ReadOnlyDetails(profile: profile),
          const SizedBox(height: 32),
          _DiscoveryPreferencesSection(
            isEditing: _isEditing,
            gender: _gender,
            lookingFor: _lookingFor,
            interestedIn: _interestedIn,
            onGenderChanged: (value) => setState(() => _gender = value),
            onLookingForChanged: (value) => setState(() => _lookingFor = value),
            onInterestSelectionChanged: (identity, selected) => setState(() {
              if (selected) {
                _interestedIn.add(identity);
              } else {
                _interestedIn.remove(identity);
              }
            }),
          ),
          if (_isEditing) ...[
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: _isSaving ? null : _saveProfile,
              icon: _isSaving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.check),
              label: Text(_isSaving ? 'Saving…' : 'Save changes'),
            ),
          ],
        ],
      ),
    );
  }
}

class _EditableDetails extends StatelessWidget {
  const _EditableDetails({
    required this.nameController,
    required this.ageController,
    required this.jobController,
    required this.bioController,
    required this.cityController,
  });

  final TextEditingController nameController;
  final TextEditingController ageController;
  final TextEditingController jobController;
  final TextEditingController bioController;
  final TextEditingController cityController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: nameController,
          maxLength: 30,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(labelText: 'Name'),
        ),
        TextField(
          controller: ageController,
          keyboardType: TextInputType.number,
          maxLength: 2,
          decoration: const InputDecoration(labelText: 'Age'),
        ),
        TextField(
          controller: jobController,
          maxLength: 40,
          decoration: const InputDecoration(labelText: 'Job title'),
        ),
        TextField(
          controller: bioController,
          maxLength: 280,
          minLines: 3,
          maxLines: 5,
          decoration: const InputDecoration(
            labelText: 'Bio',
            alignLabelWithHint: true,
          ),
        ),
        TextField(
          controller: cityController,
          maxLength: 50,
          decoration: const InputDecoration(labelText: 'City'),
        ),
      ],
    );
  }
}

class _ReadOnlyDetails extends StatelessWidget {
  const _ReadOnlyDetails({required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${profile.displayName}, ${profile.age}',
          style: textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        if (profile.jobTitle.isNotEmpty)
          Text(profile.jobTitle, style: textTheme.titleMedium),
        const SizedBox(height: 16),
        Text(profile.bio, style: textTheme.bodyLarge),
        const SizedBox(height: 16),
        Row(
          children: [
            const Icon(Icons.location_on_outlined),
            const SizedBox(width: 8),
            Text(profile.city),
          ],
        ),
      ],
    );
  }
}

class _DiscoveryPreferencesSection extends StatelessWidget {
  const _DiscoveryPreferencesSection({
    required this.isEditing,
    required this.gender,
    required this.lookingFor,
    required this.interestedIn,
    required this.onGenderChanged,
    required this.onLookingForChanged,
    required this.onInterestSelectionChanged,
  });

  final bool isEditing;
  final GenderIdentity? gender;
  final LookingFor? lookingFor;
  final Set<GenderIdentity> interestedIn;
  final ValueChanged<GenderIdentity?> onGenderChanged;
  final ValueChanged<LookingFor?> onLookingForChanged;
  final void Function(GenderIdentity identity, bool selected)
  onInterestSelectionChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Discovery Preferences', style: theme.textTheme.titleLarge),
        const SizedBox(height: 12),
        DropdownButtonFormField<GenderIdentity>(
          key: ValueKey('gender-${gender?.name}-${isEditing.toString()}'),
          initialValue: gender,
          decoration: const InputDecoration(labelText: 'Gender identity'),
          items: GenderIdentity.values
              .map(
                (value) =>
                    DropdownMenuItem(value: value, child: Text(value.label)),
              )
              .toList(),
          onChanged: isEditing ? onGenderChanged : null,
        ),
        const SizedBox(height: 16),
        InputDecorator(
          decoration: const InputDecoration(
            labelText: 'Interested in',
            border: OutlineInputBorder(),
          ),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final value in GenderIdentity.values)
                FilterChip(
                  label: Text(value.label),
                  selected: interestedIn.contains(value),
                  onSelected: isEditing
                      ? (selected) =>
                            onInterestSelectionChanged(value, selected)
                      : null,
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<LookingFor>(
          key: ValueKey('looking-${lookingFor?.name}-${isEditing.toString()}'),
          initialValue: lookingFor,
          decoration: const InputDecoration(labelText: 'Looking for'),
          items: LookingFor.values
              .map(
                (value) =>
                    DropdownMenuItem(value: value, child: Text(value.label)),
              )
              .toList(),
          onChanged: isEditing ? onLookingForChanged : null,
        ),
      ],
    );
  }
}

class _PhotoCarousel extends StatelessWidget {
  const _PhotoCarousel({required this.photos});

  final List<String> photos;

  @override
  Widget build(BuildContext context) {
    if (photos.isEmpty) {
      return Container(
        height: 220,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Center(child: Text('Add photos to showcase yourself.')),
      );
    }

    return SizedBox(
      height: 240,
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.9),
        itemCount: photos.length,
        itemBuilder: (context, index) {
          final path = photos[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.asset(path, fit: BoxFit.cover),
            ),
          );
        },
      ),
    );
  }
}
