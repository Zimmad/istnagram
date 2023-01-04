import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:istnagram/views/components/search_grd_view.dart';
import 'package:istnagram/views/constants/strings.dart';
import 'package:istnagram/views/extensions/dismiss_keyboard.dart';

class SearchView extends HookConsumerWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();
    final searchTerm = useState('');
    useEffect(() {
      controller.addListener(() {
        searchTerm.value = controller.text;
      });
      return () {}; // useEffect has a return of type void function
    }, [controller]);

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: controller,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                labelText: Strings.enterYourSearchTermHere,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    controller.clear();
                    dismissKeyboard(); // code inside of dismissKeyboard  /// " FocusManager.instance.primaryFocus?.unfocus()"
                  },
                ),
              ),
            ),
          ),
        ),
        SearchGridView(
          searchTerm: searchTerm.value,
        )
      ],
    );
  }
}
