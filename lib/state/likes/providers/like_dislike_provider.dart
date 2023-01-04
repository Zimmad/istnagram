import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:istnagram/state/constants/firebase_collection_name.dart';
import 'package:istnagram/state/constants/firebase_fields_name.dart';
import 'package:istnagram/state/likes/models/like.dart';
import 'package:istnagram/state/likes/models/like_dislike_request.dart';

final likeDislikeProvider =
    FutureProvider.family.autoDispose<bool, LikeDislikeRequest>(
  (ref, LikeDislikeRequest request) async {
    final query = FirebaseFirestore.instance
        .collection(FirebaseCollectionName.likes)
        .where(FirebaseFieldName.postId, isEqualTo: request.postId)
        .where(FirebaseFieldName.userId, isEqualTo: request.likedBy)
        .get();
    final hasLiked = await query.then((snapshot) => snapshot.docs.isNotEmpty);

    if (hasLiked) {
      try {
        await query.then((snapshot) async {
          for (final doc in snapshot.docs) {
            // We have only one like in the list.
            await doc.reference.delete();
          }
        });
        return true;
      } catch (e) {
        return false;
      }
    } else {
      // post a like object to firebase
      final like = Like(
          postId: request.postId,
          likedBy: request.likedBy,
          dateTime: (FieldValue.serverTimestamp() as Timestamp).toDate());
      try {
        await FirebaseFirestore.instance
            .collection(FirebaseCollectionName.likes)
            .add(like);
        return true;
      } catch (e) {
        return false;
      }
    }
  },
);
