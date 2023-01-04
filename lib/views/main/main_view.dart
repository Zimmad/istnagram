import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:istnagram/state/auth/provider/auth_state_notifier_provider.dart';
import 'package:istnagram/state/image_uploads/helpers/image_picker_helper.dart';
import 'package:istnagram/state/image_uploads/models/file_type.dart';
import 'package:istnagram/state/post_settings/provider/post_setting_provider.dart';
import 'package:istnagram/views/components/dialog/logout_dialog.dart';
import 'package:istnagram/views/constants/strings.dart';
import 'package:istnagram/views/components/dialog/alert_dialog_model.dart';
import 'package:istnagram/views/create_new_post/create_new_post_view.dart';
import 'package:istnagram/views/tabs/search/search_view.dart';
import 'package:istnagram/views/tabs/user_posts/user_posts_view.dart';

/// The view that is displayed to the user when you are logged in
class MainView extends ConsumerStatefulWidget {
  const MainView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainViewState();
}

class _MainViewState extends ConsumerState<MainView> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(Strings.appName),
          actions: [
            IconButton(
              icon: const FaIcon(FontAwesomeIcons.film),
              onPressed: () async {
                final videoFile =
                    await ImagePickerHelper.pickVideoFromGallery();
                if (videoFile == null) {
                  return;
                }
                ref.invalidate(postSettingProvider);
                // go to the screen to create a new post
                if (!mounted) {
                  return;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateNewPostView(
                        fileToPost: videoFile, fileType: FileType.video),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.add_photo_alternate_outlined),
              onPressed: () async {
                final imageFile =
                    await ImagePickerHelper.pickVideoFromGallery();
                if (imageFile == null) {
                  return;
                }
                // If the post settings provider is not refreshed, the same settings will be set as default.
                ref.invalidate(postSettingProvider);
                if (!mounted) {
                  return;
                }
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateNewPostView(
                          fileToPost: imageFile, fileType: FileType.image),
                    ));
              },
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                final shouldLogout = await const LogoutDialog()
                    .present(context)
                    .then((value) => value ?? false);
                if (shouldLogout) {
                  await ref.read(authStateProvider.notifier).logout();
                }
              },
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.person),
              ),
              Tab(
                icon: Icon(Icons.search),
              ),
              Tab(
                icon: Icon(Icons.home),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            UserPostsView(),
            SearchView(),
            UserPostsView(),
          ],
        ),
      ),
    );
  }
}
