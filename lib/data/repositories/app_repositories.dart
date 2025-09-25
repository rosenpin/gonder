import 'package:gonder/data/repositories/conversation_repository.dart';
import 'package:gonder/data/repositories/discovery_repository.dart';
import 'package:gonder/data/repositories/match_repository.dart';
import 'package:gonder/data/repositories/preferences_repository.dart';
import 'package:gonder/data/repositories/profile_repository.dart';

final ProfileRepository profileRepository = InMemoryProfileRepository();
final PreferencesRepository preferencesRepository =
    InMemoryPreferencesRepository();
final ConversationRepository conversationRepository =
    InMemoryConversationRepository();
final MatchRepository matchRepository = InMemoryMatchRepository();
final DiscoveryRepository discoveryRepository = InMemoryDiscoveryRepository();
