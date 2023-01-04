import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:istnagram/state/comments/tpedefs/comment_id.dart';
import 'package:istnagram/state/constants/firebase_collection_name.dart';
import 'package:istnagram/state/image_uploads/typedefs/is_loading.dart';

class DeleteCommentStateNotifier extends StateNotifier<IsLoading> {
  DeleteCommentStateNotifier() : super(false);
  set isLoading(bool value) => state = true;

  Future<bool> deleteComment({required CommentId commentId}) async {
    try {
      isLoading = true;
      final query = FirebaseFirestore.instance
          .collection(FirebaseCollectionName.comments)
          .where(
            FieldPath.documentId,
            isEqualTo: commentId,
          )
          .limit(1)
          .get();
      await query.then((value) async {
        for (final doc in value.docs) {
          // we have only one doc in the list.as we have set the limit to one(1)
          await doc.reference.delete();
        }
      });
      return true;
    } catch (e) {
      return false;
    } finally {
      // return false;
    }
  }
}
