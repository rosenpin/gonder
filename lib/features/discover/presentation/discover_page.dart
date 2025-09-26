import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:gonder/data/repositories/app_repositories.dart';
import 'package:gonder/features/preferences/presentation/settings_bottom_sheet.dart';
import 'package:gonder/models/user_profile.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  final CardSwiperController _swiperController = CardSwiperController();
  List<UserProfile> _profiles = const [];
  bool _isLoading = true;
  bool _isDeckFinished = false;

  @override
  void initState() {
    super.initState();
    _loadProfiles();
  }

  Future<void> _loadProfiles() async {
    final results = await discoveryRepository.fetchNearbyProfiles();
    if (!mounted) return;
    setState(() {
      _profiles = results;
      _isLoading = false;
      _isDeckFinished = results.isEmpty;
    });
  }

  void _triggerSwipe(CardSwiperDirection direction) {
    if (_isDeckFinished) return;
    _swiperController.swipe(direction);
  }

  bool _handleSwipe(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
  ) {
    setState(() {
      _isDeckFinished = currentIndex == null;
    });
    return true;
  }

  @override
  void dispose() {
    _swiperController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_profiles.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            _EmptyDeckPlaceholder(),
            SizedBox(height: 16),
            Text('Check back later for more matches.'),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Discover Matches 🔥',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.tune),
                tooltip: 'Discovery settings',
                onPressed: () => SettingsBottomSheet.show(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final availableWidth = constraints.maxWidth.isFinite
                    ? constraints.maxWidth
                    : 420.0;
                final availableHeight = constraints.maxHeight.isFinite
                    ? constraints.maxHeight
                    : 520.0;
                final deckWidth = availableWidth > 480 ? 480.0 : availableWidth;
                final deckHeight = availableHeight > 620
                    ? 620.0
                    : availableHeight;

                return Center(
                  child: SizedBox(
                    width: deckWidth,
                    height: deckHeight,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CardSwiper(
                          controller: _swiperController,
                          cardsCount: _profiles.length,
                          isLoop: false,
                          padding: EdgeInsets.zero,
                          numberOfCardsDisplayed: _profiles.length > 1
                              ? 2
                              : _profiles.length,
                          allowedSwipeDirection:
                              const AllowedSwipeDirection.only(
                                left: true,
                                right: true,
                                up: true,
                              ),
                          onSwipe: _handleSwipe,
                          onUndo:
                              (
                                int? previousIndex,
                                int currentIndex,
                                CardSwiperDirection direction,
                              ) {
                                setState(() {
                                  _isDeckFinished = false;
                                });
                                return true;
                              },
                          onEnd: () => setState(() => _isDeckFinished = true),
                          cardBuilder:
                              (
                                context,
                                index,
                                percentThresholdX,
                                percentThresholdY,
                              ) {
                                final profile = _profiles[index];
                                return _ProfileCard(profile: profile);
                              },
                        ),
                        if (_isDeckFinished) const _EmptyDeckPlaceholder(),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          _SwiperActionBar(
            controller: _swiperController,
            isDeckFinished: _isDeckFinished,
            onTrigger: _triggerSwipe,
          ),
        ],
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.profile});

  final UserProfile profile;

  void _showProfileDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ProfileDetailsSheet(profile: profile),
    );
  }

  @override
  Widget build(BuildContext context) {
    final photo = profile.photos.isNotEmpty ? profile.photos.first : null;

    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(24),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (photo != null)
            Image.asset(photo, fit: BoxFit.cover)
          else
            Container(color: Colors.grey.shade300),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black54],
              ),
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        profile.displayName,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        '${profile.age} • ${profile.city}',
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                      ),
                      if (profile.bio.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          profile.bio,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Colors.white70,
                                fontStyle: FontStyle.italic,
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () => _showProfileDetails(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.info_outline,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SwiperActionBar extends StatelessWidget {
  const _SwiperActionBar({
    required this.controller,
    required this.isDeckFinished,
    required this.onTrigger,
  });

  final CardSwiperController controller;
  final bool isDeckFinished;
  final void Function(CardSwiperDirection direction) onTrigger;

  VoidCallback? _onDirection(CardSwiperDirection direction) {
    if (isDeckFinished) return null;
    return () => onTrigger(direction);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _SwiperActionButton(
          icon: Icons.rotate_left,
          iconColor: Colors.orange,
          backgroundColor: Colors.orange.withValues(alpha: 0.12),
          size: 52,
          onTap: () => controller.undo(),
        ),
        _SwiperActionButton(
          icon: Icons.close,
          iconColor: Colors.redAccent,
          backgroundColor: Colors.redAccent.withValues(alpha: 0.15),
          size: 64,
          onTap: _onDirection(CardSwiperDirection.left),
        ),
        _SwiperActionButton(
          icon: Icons.star,
          iconColor: Colors.lightBlueAccent,
          backgroundColor: Colors.lightBlueAccent.withValues(alpha: 0.15),
          size: 48,
          onTap: _onDirection(CardSwiperDirection.top),
        ),
        _SwiperActionButton(
          icon: Icons.favorite,
          iconColor: Colors.green,
          backgroundColor: Colors.green.withValues(alpha: 0.15),
          size: 64,
          onTap: _onDirection(CardSwiperDirection.right),
        ),
        _SwiperActionButton(
          icon: Icons.flash_on,
          iconColor: Colors.deepPurple,
          backgroundColor: Colors.deepPurple.withValues(alpha: 0.15),
          size: 48,
          onTap: isDeckFinished ? null : () {},
        ),
      ],
    );
  }
}

class _SwiperActionButton extends StatelessWidget {
  const _SwiperActionButton({
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.size,
    this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final double size;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = onTap != null;
    return Material(
      color: isEnabled
          ? backgroundColor
          : backgroundColor.withValues(alpha: 0.2),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          height: size,
          width: size,
          child: Icon(
            icon,
            color: isEnabled ? iconColor : iconColor.withValues(alpha: 0.35),
            size: size * 0.46,
          ),
        ),
      ),
    );
  }
}

class _EmptyDeckPlaceholder extends StatelessWidget {
  const _EmptyDeckPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.sentiment_satisfied_outlined,
            size: 56,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 12),
          Text(
            'No more matches nearby',
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ProfileDetailsSheet extends StatelessWidget {
  const _ProfileDetailsSheet({required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Drag handle
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  children: [
                    // Profile photo
                    Container(
                      height: 400,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: profile.photos.isNotEmpty
                            ? Image.asset(
                                profile.photos.first,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              )
                            : Container(
                                color: Colors.grey.shade300,
                                child: const Center(
                                  child: Icon(Icons.person, size: 64),
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Name and basic info
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          profile.displayName,
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          profile.age.toString(),
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    
                    // Job title
                    if (profile.jobTitle.isNotEmpty) ...[
                      Row(
                        children: [
                          Icon(Icons.work_outline, size: 18, color: Colors.grey.shade600),
                          const SizedBox(width: 8),
                          Text(
                            profile.jobTitle,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(color: Colors.grey.shade700),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                    
                    // Location
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined, size: 18, color: Colors.grey.shade600),
                        const SizedBox(width: 8),
                        Text(
                          '${profile.city} • ${profile.distanceKm}km away',
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // Bio section
                    if (profile.bio.isNotEmpty) ...[
                      Row(
                        children: [
                          Icon(
                            Icons.person_outline,
                            size: 20,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'About ${profile.displayName}',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Text(
                          profile.bio,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(height: 1.5),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                    
                    // Interests section
                    Row(
                      children: [
                        Icon(
                          Icons.favorite_outline,
                          size: 20,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Looking For',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        profile.lookingFor.label,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(Icons.close, color: Colors.red),
                            label: const Text(
                              'Pass',
                              style: TextStyle(color: Colors.red),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.red),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: () {
                              Navigator.of(context).pop();
                              // Here you could trigger a like action
                            },
                            icon: const Icon(Icons.favorite),
                            label: const Text('Like'),
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
