import 'dart:collection' show MapView;

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:istnagram/state/constants/firebase_fields_name.dart';
import 'package:istnagram/state/posts/typedef/user_id.dart';

@immutable

/// as long as you extendend [MapView] your object is a [Map]
class UserInfoPayload extends MapView<String, String> {
  UserInfoPayload({
    required UserId userId,
    required String? dispalyName,
    required String? email,
  }) : super({
          ///the [super] constructor takes a [Map]
          FirebaseFieldName.userId: userId,
          FirebaseFieldName.displayName: dispalyName ?? '',
          FirebaseFieldName.email: email ?? '',
        });
}
