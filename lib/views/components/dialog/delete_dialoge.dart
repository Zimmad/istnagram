import 'package:flutter/foundation.dart' show immutable;
import 'package:istnagram/views/components/constants/strings.dart';
import 'package:istnagram/views/components/dialog/alert_dialog_model.dart';

@immutable
class DeleteDialog extends AlertDialogModel<bool> {
  DeleteDialog({
    required String titleObjectToDelete,
  }) : super(
            title: '${Strings.delete} $titleObjectToDelete',
            message:
                '${Strings.areYouSureThatYouWantToDeleteThis} $titleObjectToDelete',
            buttons: {
              Strings.cancel: false,
              Strings.delete: true,
            });
}
