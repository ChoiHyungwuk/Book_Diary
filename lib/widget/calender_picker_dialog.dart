import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';

Future<List<DateTime?>> showCalenderPickerDialog(
    BuildContext context, title, date) async {
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Container(
          width: 350,
          height: 300,
          child: CalendarDatePicker2(
            config: CalendarDatePicker2Config(),
            value: date,
            onValueChanged: (dates) => date = dates,
          ),
        ),
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
  return date;
}
