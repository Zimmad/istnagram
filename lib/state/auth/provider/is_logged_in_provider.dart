import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:istnagram/state/auth/models/auth_result.dart';
import 'package:istnagram/state/auth/models/auth_state.dart';
import 'package:istnagram/state/auth/provider/auth_state_notifier_provider.dart';

final isLoggedInProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.result == AuthResult.success;
});
