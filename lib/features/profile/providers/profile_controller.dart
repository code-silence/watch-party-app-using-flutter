import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/profile_model.dart';
import 'profile_provider.dart';

final profileControllerProvider =
    AsyncNotifierProvider<ProfileController, ProfileModel>(
  ProfileController.new,
);

class ProfileController extends AsyncNotifier<ProfileModel> {
  @override
  Future<ProfileModel> build() async {
    return ref.read(profileRepositoryProvider).getProfile();
  }

  Future<void> updateProfile(ProfileModel profile) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await ref.read(profileRepositoryProvider).updateProfile(profile);
      return profile;
    });
  }
}