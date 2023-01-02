import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:istnagram/state/comments/models/comment_payload.dart';
import 'package:istnagram/state/constants/firebase_collection_name.dart';
import 'package:istnagram/state/image_uploads/typedefs/is_loading.dart';
import 'package:istnagram/state/posts/typedef/post_id.dart';
import 'package:istnagram/state/posts/typedef/user_id.dart';

class SendCommentNotifier extends StateNotifier<IsLoading> {
  SendCommentNotifier() : super(false);
  set isLoading(bool value) => state = value;
  Future<bool> sendComment({
    required UserId fromUserId,
    required PostId onPostId,
    required String comment,
  }) async {
    isLoading = true;
    final payLoad = CommentPayload(
        fromUserId: fromUserId, onPostId: onPostId, comment: comment);
    try {
      await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.comments)
          .add(payLoad);
      return true;
    } catch (e) {
      return false;
    } finally {
      isLoading = false;
    }
  }
}
