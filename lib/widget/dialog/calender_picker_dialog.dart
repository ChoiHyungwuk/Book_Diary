import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_book_search/res/colors.dart';
import 'package:flutter_project_book_search/res/strings.dart';
import 'package:flutter_project_book_search/res/style.dart';

Future<List<DateTime?>> showCalenderPickerDialog(
    BuildContext context, title, date) async {
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          title,
          style: textStyleBlack20,
        ),
        content: SizedBox(
          width: 350,
          height: 300,
          child: CalendarDatePicker2(
            config: CalendarDatePicker2Config(
              selectedDayHighlightColor: appBasicColor,
            ),
            value: date,
            onValueChanged: (dates) => date = dates,
          ),
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
  return date;
}
