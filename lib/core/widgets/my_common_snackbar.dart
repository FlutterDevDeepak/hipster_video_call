import 'package:flutter/material.dart';
import 'package:hipster/core/widgets/app_text.dart';

class MycustomSnackbar {
  static void showSnackBar(
    BuildContext context,
    String title, {
    bool isError = false,
  }) {
    final snackBar = SnackBar(
      content: AppText(text: title),
      backgroundColor: isError ? Colors.red : Colors.green[500],
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: 3),
      action: SnackBarAction(
        label: 'Dismiss',
        disabledTextColor: Colors.white,
        textColor: Colors.yellow,
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void showWarningSnackBar(
    BuildContext context,
    String title, {
    bool isError = false,
    bool showAtTop = false,
  }) {
    final snackBar = SnackBar(
      content: Text(title),
      backgroundColor: Colors.black,
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: 3),
      margin: showAtTop
          ? EdgeInsets.fromLTRB(
              16,
              50,
              16,
              MediaQuery.of(context).size.height - 150,
            )
          : EdgeInsets.all(16),
      action: SnackBarAction(
        label: 'Dismiss',
        disabledTextColor: Colors.white,
        textColor: Colors.white,
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
