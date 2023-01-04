import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:istnagram/state/constants/firebase_collection_name.dart';
import 'package:istnagram/state/constants/firebase_fields_name.dart';
import 'package:istnagram/state/posts/typedef/models/post.dart';
import 'package:istnagram/state/posts/typedef/search_term.dart';

final postBySearchTerm =
    StreamProvider.family.autoDispose<Iterable<Post>, SearchTerm>(
  (ref, SearchTerm searchTerm) {
    final controller = StreamController<Iterable<Post>>();

    /// we will be searching in the entire posts.
    final sub = FirebaseFirestore.instance
        .collection(FirebaseCollectionName.posts)
        .orderBy(FirebaseFieldName.createdAt, descending: true)
        .snapshots()
        .listen(
      (snapshot) {
        final posts = snapshot.docs
            .map((doc) => Post(
                  postId: doc.id,
                  json: doc.data(),
                ))
            .where((post) => post.message.toLowerCase().contains(
                  searchTerm.toLowerCase(),
                ));
        controller.sink.add(posts);
      },
    );

    ref.onDispose(() {
      sub.cancel();
      controller.close();
    });

    return controller.stream;
  },
);
