import 'package:istnagram/state/post_settings/constants/constants.dart';

enum PostSettings {
  allowLikes(
      title: Constants.allowLikesTitle,
      discription: Constants.allowLikesDiscription,
      storageKey: Constants.allowLikesStorageKey),

  allowComments(
    title: Constants.allowCommentsTitle,
    discription: Constants.allowCommentsDiscription,
    storageKey: Constants.allowCommentsStorageKey,
  );

  final String title;
  final String discription;
  final String storageKey;
  const PostSettings({
    required this.title,
    required this.discription,
    required this.storageKey,
  });
}
