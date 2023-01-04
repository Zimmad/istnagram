import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:istnagram/state/posts/providers/user_posts_provider.dart';
import 'package:istnagram/views/components/animations/empty_content_with_text_animation_view.dart';
import 'package:istnagram/views/components/animations/error_animation_view.dart';
import 'package:istnagram/views/components/animations/loading_animation_view.dart';
import 'package:istnagram/views/components/post/posts_grid_view.dart';
import 'package:istnagram/views/constants/strings.dart';

class UserPostsView extends ConsumerWidget {
  const UserPostsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //a stream provider can have various states like 'initializing,listening, waiting, error etc' .
    final posts = ref.watch(
        userPostsProvider); // asyncValue is like a porxy object, that allows you to build various widget dependent on the state of your provider
    return RefreshIndicator(
      onRefresh: () {
        ref.invalidate(userPostsProvider);
        return Future.delayed(const Duration(seconds: 1));
      },

      ///how to turn an [AsyncValue] to a widget? By using it when function,
      /// In all these three states (data, loading, error) we have to return a widget
      child: posts.when(
        data: (data) {
          ///We gets an [Iterable<Post>] from an [AsyncValue<Iterable<Post>>]
          if (data.isEmpty) {
            return const EmptyContenWithTextAnimationView(
                text: Strings.youHaveNoPosts);
          } else {
            return PostGridView(posts: data);
          }
        },
        loading: () {
          return const LoadingAnimationView();
        },
        error: (error, stackTrace) {
          return const ErrorAnimationView();
        },
      ),
    );
  }
}
