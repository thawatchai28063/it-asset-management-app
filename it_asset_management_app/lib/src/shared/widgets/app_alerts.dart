import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

Future<void> showAppAlert(
  BuildContext context, {
  required String title,
  required String message,
  bool success = true,
}) {
  final mainColor = success ? Colors.green : Colors.red;

  return QuickAlert.show(
    context: context,
    type: success ? QuickAlertType.success : QuickAlertType.error,
    title: title,
    text: message,
    confirmBtnText: 'OK',
    confirmBtnColor: mainColor,
    titleColor: mainColor,
    barrierDismissible: false,
  );
}

Future<bool> showConfirmAlert(
  BuildContext context, {
  required String title,
  required String message,
  String confirmText = 'ยืนยัน',
}) {
  final completer = Completer<bool>();

  QuickAlert.show(
    context: context,
    type: QuickAlertType.confirm,
    title: title,
    text: message,
    confirmBtnText: confirmText,
    cancelBtnText: 'ยกเลิก',
    confirmBtnColor: Colors.red,
    titleColor: Colors.red,
    barrierDismissible: false,
    onConfirmBtnTap: () {
      Navigator.pop(context);
      if (!completer.isCompleted) {
        completer.complete(true);
      }
    },
    onCancelBtnTap: () {
      Navigator.pop(context);
      if (!completer.isCompleted) {
        completer.complete(false);
      }
    },
  );

  return completer.future;
}
