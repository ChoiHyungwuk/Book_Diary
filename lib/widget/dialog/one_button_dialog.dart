import 'package:flutter/material.dart';
import 'package:flutter_project_book_search/res/strings.dart';
import 'package:flutter_project_book_search/res/style.dart';

showOneButtonDialog(BuildContext context, String title) {
  showDialog(
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
              ok,
              style: dialogOkStyle,
            ),
          ),
        ],
      );
    },
  );
}
