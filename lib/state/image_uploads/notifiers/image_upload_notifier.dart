import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:istnagram/state/constants/firebase_collection_name.dart';
import 'package:istnagram/state/image_uploads/constant/constants.dart';
import 'package:istnagram/state/image_uploads/exceptions/could_no_build_thumbnail.dart';
import 'package:istnagram/state/image_uploads/extensions/get_collection_name_from_file_tye.dart';
import 'package:istnagram/state/image_uploads/extensions/get_image_data_aspect_ratio.dart';
import 'package:istnagram/state/image_uploads/models/file_type.dart';
import 'package:istnagram/state/image_uploads/typedefs/is_loading.dart';
import 'package:istnagram/state/post_settings/models/post_settings.dart';
import 'package:istnagram/state/posts/models/post_payload.dart';
import 'package:istnagram/state/posts/typedef/user_id.dart';

import 'package:image/image.dart' as img;
import 'package:uuid/uuid.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class ImageUploadNotifier extends StateNotifier<IsLoading> {
  ImageUploadNotifier() : super(false);

  set isLoading(bool value) {
    state = value;
  }

  Future<bool> upload(
      {required File file,
      required FileType fileType,
      required String message,
      required Map<PostSettings, bool> postSettings,
      required UserId userId}) async {
    isLoading = true;

    /// when working with data you works with [Uint8List]
    late Uint8List thumbnailUint8List;
    switch (fileType) {
      case FileType.image:
        // final fileAsImage = img.decodeImage(await file.readAsBytes()); //* this is same as below
        final fileAsImage = img.decodeImage(file.readAsBytesSync());
        if (fileAsImage == null) {
          isLoading = false; // we abort loading
          throw const CouldNotBuildThumbnailException(); // if terminate the execution of the function entirely. Works like [return]
          //return false; // and we rerurns false imediately, mean we don't want to continue
        }
        final thumbnail =
            img.copyResize(fileAsImage, width: Constants.imageThumbnailWidth);
        final thumbnailData = img.encodeJpg(thumbnail);
        thumbnailUint8List = Uint8List.fromList(thumbnailData);

        break;
      case FileType.video:
        final thumb = await VideoThumbnail.thumbnailData(
          video: file.path, // the video comes from the [file.path]
          imageFormat: ImageFormat.JPEG,
          maxHeight: Constants.videoThumbnailMaxHeight,
          quality: Constants.videoThumnailQulity,
        );
        if (thumb == null || thumb.isEmpty) {
          isLoading = false;
          throw const CouldNotBuildThumbnailException();
          // return false;
        }
        thumbnailUint8List = thumb;
        break;
    }

    /// Calculate the [AspectRatio]
    final thumbnailAspectRatio = await thumbnailUint8List.getAspectRatio();

    /// Calculating the refrences. the fileName for firestore [fileName] field
    final fileName = const Uuid().v4();

    // create refrences to the thumbnail and the image itself
    final thumbnailRef = FirebaseStorage.instance
        .ref()
        .child(userId)
        .child(FirebaseCollectionName.tumbnails)
        .child(fileName);

    final originalFileRef = FirebaseStorage.instance
        .ref()
        .child(userId)
        .child(fileType.collectionName)
        .child(fileName);

    try {
      // upload the thumbnail
      final thumbnailUploadTask =
          await thumbnailRef.putData(thumbnailUint8List);
      final thumbnailStorageId = thumbnailUploadTask.ref.name;

      // upload the original file
      final originalFileUploadTask = await originalFileRef.putFile(file);
      final originalFileStorageId = originalFileUploadTask.ref.name;

      /// upload the post (post payload)
      final postPayload = PostPayload(
        userId: userId,
        message: message,
        thumbnailUrl: await thumbnailRef.getDownloadURL(),
        fileUrl: await originalFileRef.getDownloadURL(),
        fileName: fileName,
        thumbnailStorageId: thumbnailStorageId,
        originalFileStorageId: originalFileStorageId,
        fileType: fileType,
        aspectRatio: thumbnailAspectRatio,
        postSettings: postSettings,
      );
      await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.posts)
          .add(postPayload as Map<String, dynamic>);
      return true;
    } catch (e) {
      return false;
    } finally {
      isLoading = false;
    }
  }
}
