import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:istnagram/state/auth/provider/user_id_provider.dart';
import 'package:istnagram/state/posts/typedef/models/post.dart';

final canCurrentUserDeletePostPeovider =
    StreamProvider.family.autoDispose<bool, Post>(
  (ref, Post post)

  /// [async*] this is async generator. Thsi enable us to use [yield] keyword in our function
  async* {
    final userId = ref.watch(userIdProvider);

    /// by using [yield] we can avoid useing streamController
    yield userId ==
        post.userId; // we are genetating boolean values and adding to our stream without using streamController
  },
);
