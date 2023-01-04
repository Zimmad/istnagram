import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:istnagram/state/comments/extensions/comment_sorting_by_request.dart';
import 'package:istnagram/state/comments/models/comment.dart';
import 'package:istnagram/state/comments/models/comment_post_request.dart';
import 'package:istnagram/state/comments/models/post_with_comments.dart';
import 'package:istnagram/state/constants/firebase_collection_name.dart';
import 'package:istnagram/state/constants/firebase_fields_name.dart';
import 'package:istnagram/state/posts/typedef/models/post.dart';

final specificPostWithCommentsProvider = StreamProvider.family
    .autoDispose<PostWithCommnets, RequestForPostAndComments>(
  (ref, RequestForPostAndComments request) {
    final controller = StreamController<
        PostWithCommnets>(); // PostWithComments is our outPut value

// our two subscriptions will set these two values
    Post? post;
    Iterable<Comment>? comments;
    // we need to ensure that our output stream controller does not get a post with comment that only has a post or only
// has the comments

    void notify() {
      final localPost = post;

      if (localPost == null) {
        return;
      }

      final outPutComments = (comments ?? []).applySortingFrom(request);

      final result =
          PostWithCommnets(post: localPost, comments: outPutComments);

      controller.sink.add(result);
    }

// now watch changes to the post
    final postSubscription = FirebaseFirestore.instance
        .collection(FirebaseCollectionName.posts)
        .where(FieldPath.documentId, //FieldPath returns the documentId
            isEqualTo: request.postId)
        .limit(1)
        .snapshots()
        .listen(
      (snapshot) {
        if (snapshot.docs.isEmpty) {
          post = null; // we did not find any post so we null out both of them
          comments = null;
          notify(); // we can skip this. this is for understanding
          return;
        }
        final doc = snapshot.docs.first;
        if (doc.metadata.hasPendingWrites) {
          ///we don't want posts that has pending weites
          return;
        }
        post = Post(
          postId: doc.id,
          json: doc.data(),
        );
        notify();
      },
    );

    ///watch changes to the comments
    final commnetsQuerry = FirebaseFirestore.instance
        .collection(FirebaseFieldName.comment)
        .where(FirebaseFieldName.postId, isEqualTo: request.postId)
        .orderBy(FirebaseFieldName.createdAt, descending: true);

    final limitedcommentQuerry = request.limit != null
        ? commnetsQuerry.limit(request.limit!)
        : commnetsQuerry;

    final commentSubscription = limitedcommentQuerry.snapshots().listen(
      (snapshot) {
        comments =
            snapshot.docs.where((doc) => !doc.metadata.hasPendingWrites).map(
          (doc) {
            return Comment(json: doc.data(), id: doc.id);
          },
        ).toList();
        notify();
      },
    );
    //! some or all of these need an index to be created. but after running this code you will
    //! get link-url to that in debug console (after clicking on that the index will be created automatically)
    ref.onDispose(
      () {
        postSubscription.cancel();
        commentSubscription.cancel();
        controller.close();
      },
    );

    return controller.stream;
  },
);
