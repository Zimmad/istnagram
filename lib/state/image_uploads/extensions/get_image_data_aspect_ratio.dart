import 'package:flutter/foundation.dart' show Uint8List;
import 'package:flutter/material.dart' as material show Image;
import 'package:istnagram/state/image_uploads/extensions/get_image_Aspect_ratio.dart';

extension GetImageDataAspectRatio on Uint8List {
  Future<double> getAspectRatio() {
    /// [this] refers to the [Uint8List], Uint8List are itself bytes.
    final image = material.Image.memory(this);
    return image.getAspectRatio();
  }
}
