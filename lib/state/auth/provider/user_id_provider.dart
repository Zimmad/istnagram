import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:istnagram/state/auth/provider/auth_state_notifier_provider.dart';
import 'package:istnagram/state/posts/typedef/user_id.dart';

final userIdProvider = Provider<UserId?>(
  (ref) => ref.watch(authStateProvider).userId,
);
