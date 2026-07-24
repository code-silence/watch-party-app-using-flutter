import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/heartbeat_service.dart';
import 'party_provider.dart';

final heartbeatServiceProvider = Provider<HeartbeatService>((ref) {
  return HeartbeatService(
    ref.read(partyRepositoryProvider),
  );
});