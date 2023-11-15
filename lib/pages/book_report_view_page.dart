import 'package:flutter/material.dart';
import 'package:flutter_project_book_search/data/book_report.dart';
import 'package:flutter_project_book_search/res/colors.dart';
import 'package:flutter_project_book_search/res/style.dart';
import 'package:flutter_project_book_search/res/values.dart';

class BookReportViewPage extends StatelessWidget {
  const BookReportViewPage({
    super.key,
    required this.bookReport,
  });

  final BookReport bookReport;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        toolbarHeight: appBarHeight,
        automaticallyImplyLeading: false,
        elevation: 1,
        title: Text("독후감 제목 들어갈 자리dddddddddd",
            style: appBarTitleStyle, overflow: TextOverflow.ellipsis),
        actions: <Widget>[
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.edit_square,
                color: appBasicColor,
              ))
        ],
      ),
      body: Container(),
    );
  }
}
