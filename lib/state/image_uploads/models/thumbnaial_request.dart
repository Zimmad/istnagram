import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:istnagram/state/image_uploads/models/file_type.dart';

@immutable
class ThumbnailRequest {
  final File file;
  final FileType fileType;

  const ThumbnailRequest({
    required this.file,
    required this.fileType,
  });

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ThumbnailRequest &&
            runtimeType == other.runtimeType &&
            file == other.file &&
            fileType == other.fileType;
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        file,
        fileType,
      ]);
}
