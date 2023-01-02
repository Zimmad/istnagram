import 'package:istnagram/state/image_uploads/models/file_type.dart';

extension GetCollection on FileType {
  String get collectionName {
    switch (this) {
      case FileType.image:
        return 'images';

      /// After returning some value you are out of the block of code.
      /// so you don't need [break] at the end.
      // break;
      case FileType.video:
        return 'videos';
      // break;
    }
  }
}
