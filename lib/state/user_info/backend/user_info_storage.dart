import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:istnagram/state/constants/firebase_collection_name.dart';
import 'package:istnagram/state/constants/firebase_fields_name.dart';
import 'package:istnagram/state/posts/typedef/user_id.dart';
import 'package:istnagram/state/user_info/models/user_info_payload.dart';

@immutable
class UserInfoStorage {
  const UserInfoStorage();

  /// method [saveUser]
  Future<bool> saveUser({
    // Check if we have this user's info from before
    required UserId userId,
    required String displayName,
    required String? email,
  }) async {
    try {
      final userInfo = await FirebaseFirestore.instance
              .collection(
                /// the FireStore Collection which we will be using (that is [users])
                FirebaseCollectionName.users,
              ) // using where, we are going to look for specific user with a given userId
              //because we wanna check if you have a given user stored in the [user]
              ///collection than we are just going to update it. if you don't have
              ///a user with the input [userId] than we are going to create a new one
              .where(FirebaseFieldName.userId, isEqualTo: userId)
              .limit(1) // we limit our search to one
              .get() // this command returns querry snapshot. It is Map of <String , obj> pretty much like json.
          ;

      ///This is how we know if the user already exists, by checking the [user] collection [docs]
      if (userInfo.docs.isNotEmpty) {
        /// it means we already have this user's info
        userInfo.docs.first.reference.update({
          FirebaseFieldName.displayName: displayName,
          FirebaseFieldName.email: email ?? '',
        });
        return true;
      } else {
        final payLoad = UserInfoPayload(
            userId: userId, dispalyName: displayName, email: email);

        await FirebaseFirestore.instance
                .collection(FirebaseFieldName.userId)
                .add(payLoad) // this [add] function require a [Map] object
            ;
        return true;
      }
    } catch (e) {
      return false;
    }
  }
}
