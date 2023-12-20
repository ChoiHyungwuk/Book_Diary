import 'package:flutter/material.dart';
import 'package:flutter_project_book_search/data/book_report.dart';
import 'package:flutter_project_book_search/res/strings.dart';
import 'package:flutter_project_book_search/utils/utils.dart';

showLongTouthBottomSheet(BuildContext context, BookReport bookReport) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return SizedBox(
        height: 200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(bookReport.bookTitle ?? ''),
              ElevatedButton(
                child: const Text('$bookReportStr $modify'),
                onPressed: () async {
                  await modifyBookReportElement(context, bookReport);
                },
              ),
              ElevatedButton(
                child: const Text('$bookReportStr $delete'),
                onPressed: () async {
                  await deleteBookReportElement(context, bookReport);
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}
