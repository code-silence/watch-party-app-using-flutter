import '../../../auth/data/services/auth_service.dart';
import '../../../../shared/models/app_user.dart';

class ProfileRepository {
  ProfileRepository(this._service);

  final AuthService _service;

  Future<AppUser?> getProfile() async {
    final user = _service.currentUser;

    if (user == null) return null;

    final snapshot = await _service.usersRef.child(user.uid).get();

    if (!snapshot.exists) return null;

    return AppUser.fromMap(
      snapshot.value as Map<dynamic, dynamic>,
    );
  }

  Future<void> updateDisplayName(String displayName) async {
    final user = _service.currentUser;

    if (user == null) return;

    await _service.usersRef.child(user.uid).update({
      'displayName': displayName.trim(),
    });
  }

  Future<void> updatePhotoUrl(String? photoUrl) async {
    final user = _service.currentUser;

    if (user == null) return;

    await _service.usersRef.child(user.uid).update({
      'photoUrl': photoUrl,
    });
  }

  Future<AppUser?> getUserByUid(String uid) async {
  final snapshot = await _service.usersRef.child(uid).get();

  if (!snapshot.exists) return null;

  return AppUser.fromMap(
    snapshot.value as Map<dynamic, dynamic>,
  );
}
}