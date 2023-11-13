import 'package:flutter/material.dart';

Future<bool> show(BuildContext context, String title) async {
  bool choice = false;
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('${title}'),
        actions: [
          // 취소 버튼
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("취소"),
          ),
          // 확인 버튼
          TextButton(
            onPressed: () {
              choice = true;
              Navigator.pop(context);
            },
            child: Text(
              "확인",
              style: TextStyle(color: Colors.pink),
            ),
          ),
        ],
      );
    },
  );
  return choice;
}
