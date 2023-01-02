import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:istnagram/state/auth/provider/user_id_provider.dart';
import 'package:istnagram/state/image_uploads/models/file_type.dart';
import 'package:istnagram/state/image_uploads/models/thumbnaial_request.dart';
import 'package:istnagram/state/image_uploads/providers/image_uploader_provider.dart';
import 'package:istnagram/state/post_settings/models/post_settings.dart';
import 'package:istnagram/state/post_settings/provider/post_setting_provider.dart';
import 'package:istnagram/views/components/file_thumbnail_view.dart';
import 'package:istnagram/views/constants/strings.dart';

class CreateNewPostView extends StatefulHookConsumerWidget {
  const CreateNewPostView(
      {required this.fileToPost, required this.fileType, Key? key})
      : super(key: key);
  final File fileToPost;
  final FileType fileType;
  @override
  ConsumerState<CreateNewPostView> createState() => _CreateNewPostviewSView();
}

class _CreateNewPostviewSView extends ConsumerState<CreateNewPostView> {
  @override
  Widget build(BuildContext context) {
    final thumbnailRequest =
        ThumbnailRequest(file: widget.fileToPost, fileType: widget.fileType);
    final postSettings = ref.watch(postSettingProvider);
    // when you have to set or read the data of a notifier of a provider. Notifiers are the main classes that do all or the majority of the stuff.
    // ref.read(postSettingProvider.notifier).setSettings(setting: PostSettings.allowComments, value: true);
    final postController = useTextEditingController();
    final isPostBottonEnabled = useState(false);

    useEffect(() {
      void listner() {
        isPostBottonEnabled.value = postController.text.isNotEmpty;
      }

      postController.addListener(listner);
      return () {
        postController.removeListener(listner);
      };
    }, [postController]);

    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.createNewPost),
        actions: [
          IconButton(
            onPressed: isPostBottonEnabled.value
                ? () async {
                    final userId = ref.read(userIdProvider);
                    if (userId == null) {
                      return;
                    }
                    final message = postController.text;
                    final isUploaded = await ref
                        .read(imageUpoadProvider.notifier)
                        .upload(
                            file: widget.fileToPost,
                            fileType: widget.fileType,
                            message: message,
                            postSettings: postSettings,
                            userId: userId);
                    // mounted is the property of Widget Class, if the isUploaded and the the widget is still mounted then {// execute this block.....}
                    if (isUploaded && mounted) {
                      Navigator.of(context).pop();
                    }
                  }
                : null,
            icon: const Icon(Icons.send),
          ),
        ],
      ),
      body: SingleChildScrollView(
        // controller: controller,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FileThumbnailView(
              thumbnailRequest: thumbnailRequest,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: postController,
                decoration: const InputDecoration(
                  labelText: Strings.pleaseWriteYourMessageHere,
                ),
                autofocus: true,
                maxLines: null,
              ),
            ),
            ...PostSettings.values.map(
              (e) {
                /// for each [e] postSetting, we return a [ListTile] widget.
                return ListTile(
                  title: Text(e.title),
                  subtitle: Text(e.discription),
                  trailing: Switch(
                    value: postSettings[e] ?? false,
                    onChanged: (bool valueEntered) => ref
                        .read(postSettingProvider.notifier)
                        .setSettings(setting: e, value: valueEntered),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
