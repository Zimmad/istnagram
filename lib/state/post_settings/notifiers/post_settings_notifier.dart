import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:istnagram/state/post_settings/models/post_settings.dart';

class PostSettingNotifier extends StateNotifier<Map<PostSettings, bool>> {
  PostSettingNotifier()
      : super(
          UnmodifiableMapView(
            {for (final setting in PostSettings.values) setting: true},
          ),
        );

  void setSettings({required PostSettings setting, required bool value}) {
    /// [state] is a [Map<setting , bool>] which we have passed to the constructor of [StateNotifier]
    final existingValue = state[this];

    if (existingValue == null || existingValue == value) {
      return;
    }
    state = Map.unmodifiable(
      Map.from(state)..[setting] = value, // ".." is called cascade notation
    );

    ///The above [code] can be written like below as well
    //   final Map<PostSettings, bool> _map = Map.from( state );
    //   _map[setting] = value;
    //  state =  Map.unmodifiable(_map );  /// Or  [state = Map.unmodifiable (_map[setting]=value)].
  }
}
