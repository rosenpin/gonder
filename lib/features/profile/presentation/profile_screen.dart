import 'package:flutter/material.dart';
import 'package:gonder/features/profile/data/profile_form_data.dart';
import 'package:gonder/features/profile/data/profile_store.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileStore _store = InMemoryProfileStore();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ProfileFormData? _profile;
  bool _isEditing = false;
  bool _isSaving = false;

  late final TextEditingController _nameController;
  late final TextEditingController _ageController;
  late final TextEditingController _jobController;
  late final TextEditingController _bioController;
  late final TextEditingController _cityController;

  final Set<GenderIdentity> _interestedInSelection = {};
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
    final profile = await _store.load();
    _applyProfile(profile);
  }

  void _applyProfile(ProfileFormData profile) {
    setState(() {
      _profile = profile;
      _gender = profile.gender;
      _lookingFor = profile.lookingFor;
      _interestedInSelection
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

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;
    final parsedAge = int.tryParse(_ageController.text.trim());
    if (parsedAge == null || parsedAge < 18 || parsedAge > 99) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Age must be between 18 and 99.')),
      );
      return;
    }
    if (_gender == null ||
        _lookingFor == null ||
        _interestedInSelection.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete discovery preferences.')),
      );
      return;
    }
    final updated = ProfileFormData(
      displayName: _nameController.text.trim(),
      age: parsedAge,
      jobTitle: _jobController.text.trim(),
      bio: _bioController.text.trim(),
      city: _cityController.text.trim(),
      photos: _profile?.photos ?? const [],
      gender: _gender!,
      interestedIn: _interestedInSelection.toList(),
      lookingFor: _lookingFor!,
    );

    setState(() => _isSaving = true);
    await _store.save(updated);
    setState(() {
      _isSaving = false;
      _isEditing = false;
      _profile = updated;
    });
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile saved successfully.')),
    );
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
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
          children: [
            _PhotoCarousel(photos: profile.photos),
            const SizedBox(height: 24),
            _isEditing
                ? _buildEditableSection(profile)
                : _buildReadOnlySection(profile),
            const SizedBox(height: 32),
            _buildDiscoveryPreferences(),
            const SizedBox(height: 32),
            if (_isEditing)
              FilledButton.icon(
                onPressed: _isSaving ? null : _saveChanges,
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
        ),
      ),
    );
  }

  Widget _buildEditableSection(ProfileFormData profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(labelText: 'Name'),
          textCapitalization: TextCapitalization.words,
          maxLength: 30,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your name.';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _ageController,
          decoration: const InputDecoration(labelText: 'Age'),
          keyboardType: TextInputType.number,
          maxLength: 2,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Enter your age.';
            }
            final age = int.tryParse(value);
            if (age == null || age < 18 || age > 99) {
              return 'Age must be 18-99.';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _jobController,
          decoration: const InputDecoration(labelText: 'Job Title'),
          maxLength: 40,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _bioController,
          decoration: const InputDecoration(
            labelText: 'Bio',
            alignLabelWithHint: true,
          ),
          maxLength: 280,
          minLines: 3,
          maxLines: 5,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _cityController,
          decoration: const InputDecoration(labelText: 'City'),
          maxLength: 50,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'City is required.';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildReadOnlySection(ProfileFormData profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${profile.displayName}, ${profile.age}',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        if (profile.jobTitle.isNotEmpty)
          Text(
            profile.jobTitle,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: Colors.grey.shade700),
          ),
        const SizedBox(height: 16),
        Text(profile.bio, style: Theme.of(context).textTheme.bodyLarge),
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

  Widget _buildDiscoveryPreferences() {
    final theme = Theme.of(context);
    final chips = GenderIdentity.values;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Discovery Preferences', style: theme.textTheme.titleLarge),
        const SizedBox(height: 12),
        DropdownButtonFormField<GenderIdentity>(
          key: ValueKey("gender-${_gender?.name ?? 'unset'}-$_isEditing"),
          initialValue: _gender,
          decoration: const InputDecoration(labelText: 'Gender identity'),
          items: chips
              .map(
                (gender) => DropdownMenuItem(
                  value: gender,
                  child: Text(_genderLabel(gender)),
                ),
              )
              .toList(),
          onChanged: _isEditing
              ? (value) => setState(() => _gender = value)
              : null,
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
              for (final gender in chips)
                FilterChip(
                  selected: _interestedInSelection.contains(gender),
                  label: Text(_genderLabel(gender)),
                  onSelected: !_isEditing
                      ? null
                      : (selected) => setState(() {
                          if (selected) {
                            _interestedInSelection.add(gender);
                          } else {
                            _interestedInSelection.remove(gender);
                          }
                        }),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<LookingFor>(
          key: ValueKey("looking-${_lookingFor?.name ?? 'unset'}-$_isEditing"),
          initialValue: _lookingFor,
          decoration: const InputDecoration(labelText: 'Looking for'),
          items: LookingFor.values
              .map(
                (value) => DropdownMenuItem(
                  value: value,
                  child: Text(_lookingForLabel(value)),
                ),
              )
              .toList(),
          onChanged: _isEditing
              ? (value) => setState(() => _lookingFor = value)
              : null,
        ),
      ],
    );
  }

  String _genderLabel(GenderIdentity gender) {
    switch (gender) {
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

  String _lookingForLabel(LookingFor value) {
    switch (value) {
      case LookingFor.relationship:
        return 'Relationship';
      case LookingFor.friendship:
        return 'Friendship';
      case LookingFor.adventure:
        return 'Adventure';
    }
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
