import 'package:flutter/material.dart';

Future<String?> showConfirmDialog(
    BuildContext context, String disMessage) async {
  AlertDialog dialog = AlertDialog(
    title: const Text("Xác nhận"),
    content: Text(disMessage),
    actions: [
      ElevatedButton(
          onPressed: () =>
              Navigator.of(context, rootNavigator: true).pop("cancel"),
          child: const Text("Hủy")),
      ElevatedButton(
          onPressed: () => Navigator.of(context, rootNavigator: true).pop("ok"),
          child: const Text("OK")),
    ],
  );
  String? res = await showDialog<String?>(
      barrierDismissible: false,
      context: context,
      builder: (context) => dialog);
  return res;
}

void showSnackBar(BuildContext context, String message, int second) {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message),
    duration: Duration(seconds: second),
  ));
}
