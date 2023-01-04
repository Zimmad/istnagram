import '../models/auth_result.dart';

import '../../posts/typedef/user_id.dart';

class AuthState {
  final AuthResult? result;
  final bool isLoading;
  final UserId? userId;
  const AuthState({
    required this.result,
    required this.isLoading,
    required this.userId,
  });

  /// When the app starts we have an auth state that is known,so we don't log you in
  const AuthState.unknown()
      : result = null,
        isLoading = false,
        userId = null;

  /// Creating method to for changing the isLoading flag.
  AuthState copiedWithIsLoading({required bool isLoading}) {
    return AuthState(
      result: result,
      isLoading: isLoading,
      userId: userId,
    );
  }

  /// For every Model Object you need to implement [operator ==] and  when riverPod is providing you new values
  /// it actually checks weather the new value is equal to the previous value
  @override
  bool operator ==(covariant AuthState other) {
    return identical(this, other) ||
        (result == other.result &&
            isLoading == other.isLoading &&
            userId == other.userId);
  }

  @override
  int get hashCode => Object.hash(
        result,
        isLoading,
        userId,
      );
}
