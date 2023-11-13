import 'package:flutter/material.dart';
import 'package:flutter_project_book_search/data/book_report.dart';
import 'package:flutter_project_book_search/pages/book_report_edit_page.dart';
import 'package:flutter_project_book_search/service/bookService.dart';
import 'package:provider/provider.dart';

import '../res/strings.dart';
import '../widget/book_report_list_tile.dart';

class BookReportPage extends StatefulWidget {
  BookReportPage({super.key});
  @override
  State<StatefulWidget> createState() => _BookReportPage();
}

class _BookReportPage extends State<BookReportPage> {
  final ButtonStyle style =
      ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 10));

  @override
  Widget build(BuildContext context) {
    return Consumer<BookService>(
      builder: (context, bookService, child) {
        return Scaffold(
          body: Column(
            children: [
              Row(
                children: [
                  Text("전체(${bookService.UserbookReportList.length})"),
                  Expanded(
                    child: SizedBox(width: double.infinity),
                  ),
                  ElevatedButton(
                    style: style,
                    onPressed: () {},
                    child: Row(children: [
                      Icon(Icons.list),
                      Text(bookReportListView),
                    ]),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  ElevatedButton(
                    style: style,
                    onPressed: () {},
                    child: Row(children: [
                      Icon(Icons.grid_view_rounded),
                      Text(bookReportAlbumView),
                    ]),
                  ),
                ],
              ),
              Divider(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: ListView.separated(
                    itemCount: bookService.UserbookReportList.length,
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                    itemBuilder: (context, index) {
                      if (bookService.UserbookReportList.isEmpty)
                        return SizedBox();
                      BookReport bookReport =
                          bookService.UserbookReportList.elementAt(index);
                      return BookReportListTile(bookReport: bookReport);
                    },
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              bookService.createInitReport(editDay: DateTime.now());
              Navigator.push<void>(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => BookReportEditPage(
                    index: bookService.UserbookReportList.length - 1,
                  ),
                ),
              );
            },
            child: Icon(Icons.add_box_outlined),
          ),
        );
      },
    );
  }
}
