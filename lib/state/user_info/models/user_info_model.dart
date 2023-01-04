import 'dart:collection' show MapView;

import 'package:flutter/foundation.dart' show immutable;
import 'package:istnagram/state/constants/firebase_fields_name.dart';
import 'package:istnagram/state/posts/typedef/user_id.dart';

@immutable

/// [UserInfoModel] is [json] serializable
class UserInfoModel extends MapView<String, String?> {
  final String userId;
  final String displayName;
  final String? email;

  UserInfoModel({required this.userId, required this.displayName, this.email})
      : super({
          FirebaseFieldName.userId: userId,
          FirebaseFieldName.displayName: displayName,
          FirebaseFieldName.email: email //?? ''
        });

  UserInfoModel.fromJson(Map<String, dynamic> json, {required UserId userId})
      : this(
            userId: userId,
            displayName: json[FirebaseFieldName.displayName] as String,
            email: json[FirebaseFieldName.email]);

  //! For any model object, always define the equality (==) and hashCode() .
  //! hooks_riverpod uses this equality and hashing of objects --(riverpod do continous comparison)

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        runtimeType == other.runtimeType &&
            other is UserInfoModel &&
            userId == other.userId &&
            displayName == other.displayName &&
            email == other.email;
  }

  @override
  int get hashCode => Object.hashAll([
        userId,
        displayName,
        email,
      ]);
}
