import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:istnagram/state/auth/models/auth_state.dart';
import 'package:istnagram/state/auth/notifiers/auth_state_notifier.dart';

final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>(
  (ref) => AuthStateNotifier(),
);
