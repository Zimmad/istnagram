import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:istnagram/state/constants/firebase_collection_name.dart';
import 'package:istnagram/state/constants/firebase_fields_name.dart';
import 'package:istnagram/state/image_uploads/extensions/get_collection_name_from_file_tye.dart';
import 'package:istnagram/state/image_uploads/typedefs/is_loading.dart';
import 'package:istnagram/state/posts/typedef/models/post.dart';
import 'package:istnagram/state/posts/typedef/post_id.dart';

typedef Succeeded = bool;

class DeletePostStateNotifier extends StateNotifier<IsLoading> {
  DeletePostStateNotifier() : super(false);

  set isLoading(bool value) => state = true;

  Future<Succeeded> deletePost({required Post post}) async {
    isLoading = true;

    try {
      /// delete the post's [thumbnail] ( which is inside the [FirebaseStorage])
      await FirebaseStorage.instance
          .ref()
          .child(post.userId)
          .child(FirebaseCollectionName.tumbnails)
          .child(post.thumbnailStorageId)
          .delete();

      /// delete the post's original file ([image] or [video])
      await FirebaseStorage.instance
          .ref()
          .child(post.fileType.collectionName)
          .child(post.originalFileStorageId)
          .delete();

      /// delete all [comments] associated with this post
      await _deleteAllDocuments(
          postId: post.postId, inCollection: FirebaseCollectionName.comments);

      /// delete all the [likes] that are associated with it
      await _deleteAllDocuments(
          postId: post.postId, inCollection: FirebaseCollectionName.likes);

      /// finaly delete the [post] itself
      final postInCollection = await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.posts)
          .where(FirebaseFieldName.postId, isEqualTo: post.postId)
          .limit(1)
          .get();

      /// it must be one if we finds it in the [post's collection] (this is because we
      /// have the [where(postId)] condition and the [postId] are unique)
      for (final doc in postInCollection.docs) {
        await doc.reference.delete();
      }

      return true;
    } catch (e) {
      return false;
    } finally {
      isLoading = false;
    }
  }

  Future<void> _deleteAllDocuments({
    required PostId postId,
    required String inCollection,
  }) {
    return FirebaseFirestore.instance.runTransaction(
      maxAttempts: 3,
      timeout: const Duration(seconds: 20),
      (transaction) async {
        final querry = await FirebaseFirestore.instance
            .collection(inCollection)
            .where(
              FirebaseFieldName.postId,
              isEqualTo: postId,
            )
            .get();
        for (final doc in querry.docs) {
          transaction.delete(doc.reference);
        }
      },
    );
  }
}
