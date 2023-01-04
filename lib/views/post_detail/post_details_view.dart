import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:istnagram/state/comments/models/comment_post_request.dart';
import 'package:istnagram/state/enums/date_sorting.dart';
import 'package:istnagram/state/posts/providers/can_current_delete_post_provider.dart';
import 'package:istnagram/state/posts/providers/delete_post_provider.dart';
import 'package:istnagram/state/posts/providers/specific_posts_with_comments.dart';
import 'package:istnagram/state/posts/typedef/models/post.dart';
import 'package:istnagram/views/components/animations/error_animation_view.dart';
import 'package:istnagram/views/components/animations/loading_animation_view.dart';
import 'package:istnagram/views/components/animations/small_error_animation_view.dart';
import 'package:istnagram/views/components/comment/compact_comment_colum.dart';
import 'package:istnagram/views/components/dialog/alert_dialog_model.dart';
import 'package:istnagram/views/components/dialog/delete_dialoge.dart';
import 'package:istnagram/views/components/like_button.dart';
import 'package:istnagram/views/components/likes_count_view.dart';
import 'package:istnagram/views/components/post/post_date_view.dart';
import 'package:istnagram/views/components/post/post_display_name_and_message.dart';
import 'package:istnagram/views/components/post/post_image_or_video_view.dart';
// import 'package:istnagram/views/components/constants/strings.dart';
import 'package:istnagram/views/constants/strings.dart';
import 'package:istnagram/views/post_comments/post_comments_view.dart';
import 'package:share_plus/share_plus.dart';

//*--------------------------------------//--------------------------------------//--------------------------------------//--------------------------------------

class PostDetailsView extends ConsumerStatefulWidget {
  const PostDetailsView({Key? key, required this.post}) : super(key: key);

  /// we uses this [post] only to get the postId. we are not notify through this [post]
  final Post post;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PostDetailsViewState();
}

class _PostDetailsViewState extends ConsumerState<PostDetailsView> {
  @override
  Widget build(BuildContext context) {
    final request = RequestForPostAndComments(
      postId: widget.post.postId,
      limit: 3,
      dateSorting: DateSorting.oldesOnTop,
      sortByCreatedAt: true,
    );

    /// get the actual posts togather with the it comments
    final postWithComments =
        ref.watch(specificPostWithCommentsProvider(request));

    /// can we delete this post
    final canDeletPost =
        ref.watch(canCurrentUserDeletePostPeovider(widget.post));

    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.postDetails),
        actions: [
          /// for the actions we have a list of widgets

          // share button is always present
          postWithComments.when(
            data: (postWithComments) {
              /// We are returning the share btton, the share button will always share the [file] of [postWithComments]
              return IconButton(
                icon: const Icon(
                  Icons.share,
                ),
                onPressed: () {
                  final url = postWithComments.post.fileUrl;

                  /// this will present the native (android or ios) sharing dialog sheet
                  Share.share(
                    url,
                    subject: Strings
                        .checkOutThisPost, // this is like the title on the native share dialoge
                  );
                },
              );
            },
            error: (error, stackTrace) {
              return const SmallErrorAnimationView();
            },
            loading: () {
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),

          // show,only, the delete button if the user can delete the post
          if (canDeletPost.value ?? false)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                final shouldDeltePost =
                    await DeleteDialog(titleObjectToDelete: Strings.post)
                        .present(context)
                        .then((shouldDelete) => shouldDelete ?? false);
                if (shouldDeltePost) {
                  await ref
                      .read(deletePostProvider.notifier)
                      .deletePost(post: widget.post);
                  if (mounted) {
                    Navigator.of(context).pop();
                  }
                }
              },
            )
        ],
      ),

      /// the entire [body] is dependent on the [postWithComments] async values
      body: postWithComments.when(
        data: (postWithComments) {
          /// this [post] is comming from a post provider, and we are notify when changes happen

          final postId = postWithComments.post.postId;
          return SingleChildScrollView(
            // controller: controller,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PostImageOrVideoView(
                  post: postWithComments.post,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    /// like button , only if the post allows it
                    if (postWithComments.post.allowLikes)
                      LikeButton(postId: postId),

                    if (postWithComments.post.allowComments)
                      IconButton(
                        icon: const Icon(Icons.mode_comment_outlined),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return PostCommentsView(
                                    postId: postWithComments.post.postId);
                              },
                            ),
                          );
                        },
                      ),
                  ],
                ),

                /// Post details (and to show devider at bottom)
                PostDisplayNameAndMessage(post: postWithComments.post),
                PostDateView(dateTime: postWithComments.post.createdAt),
                const Padding(
                  padding: EdgeInsets.all(8),
                  child: Divider(
                    color: Colors.white70,
                  ),
                ),

                // now display comments
                CompactCommentsColumn(comments: postWithComments.comments),
                // display like count
                if (postWithComments.post.allowLikes)
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        LikesCountView(postId: postWithComments.post.postId),
                      ],
                    ),
                  ),
                // add spacing to bottom of screen
                const SizedBox(
                  height: 100,
                )
              ],
            ),
          );
        },
        error: (error, stackTrace) {
          return const ErrorAnimationView();
        },
        loading: () {
          return const LoadingAnimationView();
        },
      ),
    );
  }
}
