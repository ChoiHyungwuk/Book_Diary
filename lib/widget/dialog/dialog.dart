import 'package:flutter/material.dart';
import 'package:flutter_project_book_search/res/strings.dart';
import 'package:flutter_project_book_search/res/style.dart';

Future<bool> showAlertDialog(BuildContext context, String title) async {
  bool choice = false;
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          title,
          style: textStyleBlack15,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              cancel,
              style: dialogNoStyle,
            ),
          ),
          TextButton(
            onPressed: () {
              choice = true;
              Navigator.pop(context);
            },
            child: Text(
              ok,
              style: dialogOkStyle,
            ),
          ),
        ],
      );
    },
  );
  return choice;
}
