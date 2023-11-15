import 'package:flutter/material.dart';
import 'package:flutter_project_book_search/data/book_report.dart';

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
        title: Text("독후감 제목 들어갈 자리"),
        actions: <Widget>[
          IconButton(onPressed: () {}, icon: Icon(Icons.edit_square))
        ],
      ),
      body: Container(),
    );
  }
}
