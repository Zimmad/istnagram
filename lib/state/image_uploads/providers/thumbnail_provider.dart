import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:istnagram/state/image_uploads/exceptions/could_no_build_thumbnail.dart';
import 'package:istnagram/state/image_uploads/extensions/get_image_Aspect_ratio.dart';
import 'package:istnagram/state/image_uploads/models/file_type.dart';
import 'package:istnagram/state/image_uploads/models/image_with_aspect_ratio.dart';
import 'package:istnagram/state/image_uploads/models/thumbnaial_request.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

// final thumnailProvider = FutureProvider.family.autoDispose<RETURNVALUE, INPUTVALUE>
final thumbnailProvider =
    FutureProvider.family.autoDispose<ImageWithAspectRatio, ThumbnailRequest>(
  (ref, ThumbnailRequest request) async {
    final Image image;
    switch (request.fileType) {
      case FileType.image:
        image = Image.file(
          request.file,
          fit: BoxFit.fitHeight,
        );
        break;
      case FileType.video:
        final thumb = await VideoThumbnail.thumbnailData(
          video: request.file.path,
          quality: 75,
          imageFormat: ImageFormat.JPEG,
        );
        if (thumb == null) {
          throw CouldNotBuildThumbnailException();
        } else {
          image = Image.memory(
            thumb,
            fit: BoxFit.fitHeight,
          );
        }
        break;
    }
    final aspectRatio = await image.getAspectRatio();
    return ImageWithAspectRatio(image: image, aspectRatio: aspectRatio);
  },
);
