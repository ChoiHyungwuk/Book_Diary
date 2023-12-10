import 'package:flutter/material.dart';
import 'package:flutter_project_book_search/data/book.dart';
import 'package:flutter_project_book_search/res/strings.dart';
import 'package:flutter_project_book_search/utils/utils.dart';

showAddBottomSheet(BuildContext context, Book book) {
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
              Text(book.title),
              ElevatedButton(
                child: const Text(addReport),
                onPressed: () {
                  addBookReportElement(context, book);
                },
              ),
              // ElevatedButton(
              //   child: const Text(delete),
              //   onPressed: () async {
              //     await deleteBookReportElement(context, book);
              //   },
              // ),
            ],
          ),
        ),
      );
    },
  );
}
