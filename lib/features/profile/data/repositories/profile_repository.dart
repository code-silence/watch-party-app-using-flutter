import 'package:firebase_database/firebase_database.dart';

import '../../../auth/data/services/auth_service.dart';
import '../../models/profile_model.dart';

class ProfileRepository {
  ProfileRepository(this._authService);

  final AuthService _authService;

  DatabaseReference get _usersRef => _authService.usersRef;

  Future<ProfileModel> getProfile() async {
    final uid = _authService.currentUser!.uid;

    final snapshot = await _usersRef.child(uid).get();

    final map = snapshot.value as Map<dynamic, dynamic>;

    return ProfileModel.fromMap(uid, map);
  }

  Future<void> updateProfile(ProfileModel profile) async {
    await _usersRef.child(profile.uid).update(profile.toMap());
  }
}