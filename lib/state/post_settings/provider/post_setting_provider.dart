import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:istnagram/state/post_settings/models/post_settings.dart';
import 'package:istnagram/state/post_settings/notifiers/post_settings_notifier.dart';

final postSettingProvider =
    StateNotifierProvider<PostSettingNotifier, Map<PostSettings, bool>>(
  (ref) => PostSettingNotifier(),
);
