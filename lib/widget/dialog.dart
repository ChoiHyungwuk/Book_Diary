import 'package:flutter/material.dart';

void showDeleteDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("정말로 삭제하시겠습니까?"),
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
              Navigator.pop(context); // 팝업 닫기
              Navigator.pop(context); // HomePage 로 가기
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
}
