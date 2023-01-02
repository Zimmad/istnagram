import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:istnagram/state/constants/firebase_collection_name.dart';
import 'package:istnagram/state/constants/firebase_fields_name.dart';
import 'package:istnagram/state/posts/typedef/user_id.dart';

import '../models/user_info_model.dart';

/// To provide some vlaue (or get some value as function argument) as parameter, make the provider as a family provider. The  [.autoDispose  < outPut, inPuts >]
final userInfoProvider =
    StreamProvider.family.autoDispose<UserInfoModel, UserId>(
  (ref, UserId userId) {
    // the (ref, arg)  arg is the user input

    /// for using [StreamProvider] we first create a [streamController] for it, then [return] te [Stream] of
    ///  [StreamController] as result of provider. and upon the [ref] getting [dispose] of, [dispose] the [StramController].
    /// So the backing of a straem provider is usually a stream controller
    final controller = StreamController<UserInfoModel>();

    /// subscribe to he [FirebaseFirestore usecrs Collection]
    final sub = FirebaseFirestore.instance
        .collection(FirebaseCollectionName.users)
        . // than we go into the collection, and than into the user collections
        where(FirebaseFieldName.userId,
            isEqualTo:
                userId) // we are lokking for the specific user, so we uses the where clause
        .limit(1) // we limit our searc to one
        .snapshots() // we get the snapshots
        .listen(
      // and start listening to it
      // this is out subscrition
      (snapShot) {
        final doc = snapShot.docs
            .first; // our limit for search is one. so we have only one doc in the [list]
        final json = doc.data();
        final userInfoModel = UserInfoModel.fromJson(json, userId: userId);

        /// or [conroller.sink.add(userInfoModel)]
        controller.add(userInfoModel);
      }, // and we start listening to changes to that particular user
    );

    ref.onDispose(() {
      /// make sure that you are disposing of your subscriptions as well
      sub.cancel();
      controller.close();
    });

    return controller.stream;
  },
);
