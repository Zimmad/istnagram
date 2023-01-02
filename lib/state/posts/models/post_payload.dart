import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:istnagram/state/image_uploads/models/file_type.dart';
import 'package:istnagram/state/post_settings/models/post_settings.dart';
import 'package:istnagram/state/posts/typedef/models/post_keys.dart';
import 'package:istnagram/state/posts/typedef/user_id.dart';

@immutable
class PostPayload extends MapView {
  PostPayload({
    required UserId userId,
    required String message,
    required String thumbnailUrl,
    required String fileUrl,
    required String fileName,
    required String thumbnailStorageId,
    required String originalFileStorageId,
    required FileType fileType,
    required double aspectRatio,
    required Map<PostSettings, bool> postSettings,
  }) : super({
          PostKey.userId: userId,
          PostKey.message: message,
          PostKey.createdAt: FieldValue.serverTimestamp(),
          PostKey.fileUrl: fileUrl,
          PostKey.fileName: fileName,
          PostKey.thumbnailUrl: thumbnailUrl,
          PostKey.thumnailStorageId: thumbnailStorageId,
          PostKey.originalFileStorageId: originalFileStorageId,
          PostKey.fileType: fileType,
          PostKey.aspectRatio: aspectRatio,
          PostKey.postSettings: {
            for (final postSetting in postSettings.entries)
              {postSetting.key.storageKey: postSetting.value}
          },
        });
}
