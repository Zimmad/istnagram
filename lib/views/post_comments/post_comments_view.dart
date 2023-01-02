import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:istnagram/state/auth/provider/user_id_provider.dart';
import 'package:istnagram/state/comments/models/Post_comment_request.dart';
import 'package:istnagram/state/comments/providers/post_comments_provider.dart';
import 'package:istnagram/state/comments/providers/send_comment_provider.dart';
import 'package:istnagram/state/posts/typedef/post_id.dart';
import 'package:istnagram/views/components/animations/empty_content_animation_view.dart';
import 'package:istnagram/views/components/animations/empty_content_with_text_animation_view.dart';
import 'package:istnagram/views/components/animations/error_animation_view.dart';
import 'package:istnagram/views/components/animations/loading_animation_view.dart';
import 'package:istnagram/views/components/comment/comment_tile.dart';
import 'package:istnagram/views/constants/strings.dart';
import 'package:istnagram/views/extensions/dismiss_keyboard.dart';

class PostCommentsView extends HookConsumerWidget {
  const PostCommentsView({
    super.key,
    required this.postId,
  });
  final PostId postId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commentController = useTextEditingController();
    final hasText = useState(false);
    final request = useState(RequestForPostAndComments(
      postId: postId,
    ));
    final comments = ref.watch(
      postCommentsProvider(request.value),
    );

    ///we hook our [useEffect] to the [commentController]. it means that if the [commentController] cahnges the [useEffect] will be reBUild
    useEffect(() {
      commentController.addListener(() {
        hasText.value = commentController.text.isNotEmpty;
      });
      return () {};
    }, [commentController]);
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.comments),
        actions: [
          IconButton(
              onPressed: hasText.value
                  ? () {
                      _submitCommentWithController(commentController, ref);
                    }
                  : null,
              icon: const Icon(Icons.send))
        ],
      ),
      body: SafeArea(
        child: Flex(
          direction: Axis.vertical,
          children: [
            Expanded(
              flex: 4,
              child: comments.when(
                data: (comments) {
                  if (comments.isEmpty) {
                    return const SingleChildScrollView(
                      child: EmptyContenWithTextAnimationView(
                        text: Strings.noCommentsYet,
                      ),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () {
                      ref.refresh(
                        postCommentsProvider(request.value),
                      );
                      return Future.delayed(
                        const Duration(seconds: 1),
                      );
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        final comment = comments.elementAt(index);
                        return CommentTile(comment: comment);
                      },
                    ),
                  );
                },
                loading: () {
                  return const LoadingAnimationView();
                },
                error: (error, stackTrace) {
                  return const ErrorAnimationView();
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8.0),
                  child: TextField(
                    textInputAction: TextInputAction.send,
                    controller:
                        commentController, //it means the button on the keyboard is " [send]"
                    onSubmitted: (comment) {
                      // onSubmitted is executed when the keyboard [send] button is pressed
                      if (comment.isNotEmpty) {
                        _submitCommentWithController(commentController, ref);
                      }
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: Strings.writeYourCommentHere,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  /// we uses [async] because we have to await on the [sendCommentNorifier] method [Future<bool> sendComment() ].
  Future<void> _submitCommentWithController(
    TextEditingController
        controller, // we need this because we want the inpuntText and to clear our inputText widget
    WidgetRef ref, // we need this to have a refrence at sendCommentProvider
  ) async {
    final userId = ref.read(userIdProvider);
    if (userId == null) {
      return;
    }
    final isSent = await ref.watch(sendCommentProvider.notifier).sendComment(
        fromUserId: userId, onPostId: postId, comment: controller.text);

    if (isSent) {
      controller.clear();
      dismissKeyboard(); // This method is defined as extension on Widget Class
    }
  }
}
