import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:istnagram/state/auth/provider/user_id_provider.dart';
import 'package:istnagram/state/constants/firebase_collection_name.dart';
import 'package:istnagram/state/constants/firebase_fields_name.dart';
import 'package:istnagram/state/posts/typedef/models/post_keys.dart';
import 'package:istnagram/state/posts/typedef/user_id.dart';

import '../typedef/models/post.dart';

/// We will be using [StreamProvider] (This will be an auto [dispose] StreamProvider)

final userPostsProvider = StreamProvider.autoDispose<Iterable<Post>>(
  (ref) {
    final controller = StreamController<Iterable<Post>>();
    final userId = ref.watch(userIdProvider);

    /// As soon as someone start listening to our streamProvider gets an empty array
    controller.onListen = () {
      controller.sink.add([]);
    };
    final sub = FirebaseFirestore.instance
        .collection(FirebaseCollectionName.posts)
        .orderBy(FirebaseFieldName.createdAt, descending: true)
        .where(PostKey.userId, isEqualTo: userId)
        .snapshots()
        .listen((event) {
      final documents = event.docs;
      final posts = documents
          .where(
            (element) => !element.metadata.hasPendingWrites,
          )
          .map((doc) => Post(
                postId: doc.id,
                json: doc.data(),
              ));
      controller.sink.add(posts);
    });

    ///as soon as our provider is dispose, we want our subscriotion [sub] is cancled and [controlller] is also closed
    ref.onDispose(() {
      sub.cancel();
      controller.close();
    });

    return controller.stream;
  },
);
