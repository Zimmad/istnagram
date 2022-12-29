import 'package:flutter/cupertino.dart';
import 'package:istnagram/views/components/constants/strings.dart';
import 'package:istnagram/views/components/dialog/alert_dialog_model.dart';

@immutable
class LogoutDialog extends AlertDialogModel<bool> {
  const LogoutDialog()
      : super(
          title: Strings.logOut,
          message: Strings.areYouSureThatYouWantToLogOutOfTheApp,
          buttons: const {Strings.logOut: true, Strings.cancel: false},
        );
}
