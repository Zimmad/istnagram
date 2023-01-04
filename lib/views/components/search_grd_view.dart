import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:istnagram/state/posts/providers/posts_by_search_terms.dart';
import 'package:istnagram/views/components/animations/data_not_found_animation.dart';
import 'package:istnagram/views/components/animations/empty_content_with_text_animation_view.dart';
import 'package:istnagram/views/components/animations/error_animation_view.dart';
import 'package:istnagram/views/components/post/post_sliver_grid_view.dart';
import 'package:istnagram/views/components/post/posts_grid_view.dart';
import 'package:istnagram/views/constants/strings.dart';

class SearchGridView extends ConsumerWidget {
  const SearchGridView({super.key, required this.searchTerm});
  final String searchTerm;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (searchTerm.isEmpty) {
      return const SliverToBoxAdapter(
        child: EmptyContenWithTextAnimationView(
            text: Strings.enterYourSearchTermHere),
      );
    }
    final posts = ref.watch(postBySearchTerm(searchTerm));

    return posts.when(
      data: (posts) {
        if (posts.isEmpty) {
          return const SliverToBoxAdapter(child: DataNotFoundAnimationView());
        } else {
          return PostSliverGridView(posts: posts);
        }
      },
      error: (error, stackTrace) {
        return const SliverToBoxAdapter(child: ErrorAnimationView());
      },
      loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
