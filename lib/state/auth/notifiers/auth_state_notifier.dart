import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:istnagram/state/auth/backend/authenticator.dart';
import 'package:istnagram/state/auth/models/auth_result.dart';
import 'package:istnagram/state/auth/models/auth_state.dart';
import 'package:istnagram/state/user_info/backend/user_info_storage.dart';

import '../../posts/typedef/user_id.dart';

/// Every [StateNotifier] has to haave an initial state. For that we need to
/// create a constructor and pass that initial state to its super class
class AuthStateNotifier extends StateNotifier<AuthState> {
  final authenticator = const Authenticator();
  final userInfoStorage = const UserInfoStorage();
  AuthStateNotifier() : super(const AuthState.unknown()) {
    if (authenticator.isAlreadyLoggedIn) {
      /// if any changes happens in this [state] object, the listeners will be notifies of this change.
      state = AuthState(
          result: AuthResult.success,
          isLoading: false,
          userId: authenticator.userId);
    }
  }

  // we have already written these functions in the authenticator, but the authenticator is
  // is not state. The authenticator just simply calls some function, it does'nt know about the state, if ]
  // you are already logged in or logged out.

  Future<void> logout() async {
    state = state.copiedWithIsLoading(isLoading: true);
    authenticator.loggedOut();
    state = const AuthState.unknown();
  }

  Future<void> loginWithGoogle() async {
    state = state.copiedWithIsLoading(isLoading: true);
    final result = await authenticator.loginWithGoogle();
    final userId = authenticator.userId;
    if (result == AuthResult.success && userId != null) {
      await saveUserInfo(userId: userId);
    }
    state = AuthState(
      userId: userId,
      isLoading: false,
      result: result,
    );
  }

  Future<void> loginWithFacebook() async {
    state = state.copiedWithIsLoading(isLoading: true);
    final result = await authenticator.loginWithFacebook();
    final userId = authenticator.userId;
    if (result == AuthResult.success && userId != null) {
      await saveUserInfo(userId: userId);
    }
    state = AuthState(
      userId: userId,
      isLoading: false,
      result: result,
    );
  }

  Future<void> saveUserInfo({required UserId userId}) =>
      userInfoStorage.saveUser(
          userId: userId,
          displayName: authenticator.displayName,
          email: authenticator.email);
}
