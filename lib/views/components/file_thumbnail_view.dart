import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:istnagram/state/image_uploads/providers/thumbnail_provider.dart';
import 'package:istnagram/views/components/animations/loading_animation_view.dart';
import 'package:istnagram/views/components/animations/small_error_animation_view.dart';

import '../../state/image_uploads/models/thumbnaial_request.dart';

class FileThumbnailView extends ConsumerWidget {
  const FileThumbnailView({required this.thumbnailRequest, Key? key})
      : super(key: key);
  final ThumbnailRequest thumbnailRequest;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final thumbnail = ref.watch(thumbnailProvider(thumbnailRequest));
    return thumbnail.when(
      data: (imageWithAspectRation) {
        return AspectRatio(
          aspectRatio: imageWithAspectRation.aspectRatio,
          child: imageWithAspectRation.image,
        );
      },
      loading: () {
        return const LoadingAnimationView();
      },
      error: (error, stackTrace) {
        return const SmallErrorAnimationView();
      },
    );
  }
}
