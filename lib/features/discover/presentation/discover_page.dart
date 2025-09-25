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
                Column(
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
                  ],
                ),
                const Icon(Icons.info_outline, color: Colors.white),
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
