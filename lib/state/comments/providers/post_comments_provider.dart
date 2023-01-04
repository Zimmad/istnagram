import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:istnagram/state/comments/extensions/comment_sorting_by_request.dart';
import 'package:istnagram/state/comments/models/comment_post_request.dart';
import 'package:istnagram/state/comments/models/comment.dart';
import 'package:istnagram/state/constants/firebase_collection_name.dart';
import 'package:istnagram/state/constants/firebase_fields_name.dart';

final postCommentsProvider = StreamProvider.family
    .autoDispose<Iterable<Comment>, RequestForPostAndComments>(
        (ref, RequestForPostAndComments requestForPostAndComments) {
  final controller = StreamController<Iterable<Comment>>();

  final sub = FirebaseFirestore.instance
      .collection(FirebaseCollectionName.comments)
      .where(FirebaseFieldName.postId,
          isEqualTo: requestForPostAndComments.postId)
      .snapshots()
      .listen(
    (snapshot) {
      final documents = snapshot.docs;
      final limitedDocuments = requestForPostAndComments.limit != null
          ? documents.take(requestForPostAndComments.limit!)
          : documents;

      final comments = limitedDocuments
          .where(
            (doc) => !doc.metadata.hasPendingWrites,
          )
          .map((doc) => Comment(json: doc.data(), id: doc.id));

      final result = comments.applySortingFrom(requestForPostAndComments);
      controller.sink.add(result);
    },
  );

  ref.onDispose(() {
    ///cancel subscription to the stram of FirebaseFirestore stream of snapshots.
    sub.cancel();

    /// dispose the StreamController,
    controller.close();
  });

  return controller.stream;
});
