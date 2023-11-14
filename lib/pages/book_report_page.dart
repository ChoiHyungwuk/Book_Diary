import 'package:flutter/material.dart';
import 'package:flutter_project_book_search/data/book_report.dart';
import 'package:flutter_project_book_search/main.dart';
import 'package:flutter_project_book_search/pages/book_report_edit_page.dart';
import 'package:flutter_project_book_search/service/bookService.dart';
import 'package:flutter_project_book_search/widget/book_report_album_tile.dart';
import 'package:flutter_project_book_search/widget/book_report_list_tile.dart';
import 'package:provider/provider.dart';

import '../res/strings.dart';

class BookReportPage extends StatefulWidget {
  BookReportPage({super.key});

  @override
  State<StatefulWidget> createState() => _BookReportPage();
}

class _BookReportPage extends State<BookReportPage> {
  final List<bool> _selectedViewOption = <bool>[
    (prefs.getBool('viewOption') ?? true),
    !(prefs.getBool('viewOption') ?? true)
  ];
  bool viewOption = prefs.getBool('viewOption') ?? true;

  List<Widget> viewContent = <Widget>[
    Row(
      children: [
        Icon(Icons.list),
        Text(
          bookReportListView,
          style: TextStyle(fontSize: 10),
        ),
      ],
    ),
    Row(
      children: [
        Icon(Icons.grid_view_rounded),
        Text(bookReportAlbumView, style: TextStyle(fontSize: 10)),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<BookService>(
      builder: (context, bookService, child) {
        return Scaffold(
          body: Column(
            children: [
              Container(
                height: 65,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    Text("전체(${bookService.bookReportList.length})",
                        style: TextStyle(fontSize: 15)),
                    Expanded(
                      child: SizedBox(width: double.infinity),
                    ),
                    ToggleButtons(
                      onPressed: (int index) {
                        setState(() {
                          for (int i = 0; i < _selectedViewOption.length; i++) {
                            _selectedViewOption[i] = i == index;
                          }
                          prefs.setBool(
                              'viewOption', index == 0 ? true : false);
                          viewOption = index == 0 ? true : false;
                        });
                      },
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      selectedBorderColor: Colors.blue[900],
                      selectedColor: Colors.white,
                      fillColor: Colors.blueAccent,
                      color: Colors.black,
                      constraints: const BoxConstraints(
                        minHeight: 35.0,
                        minWidth: 90.0,
                      ),
                      isSelected: _selectedViewOption,
                      children: viewContent,
                    )
                  ],
                ),
              ),
              Divider(),
              viewOption
                  ? Expanded(
                      child: ListView.separated(
                        itemCount: bookService.bookReportList.length,
                        separatorBuilder: (context, index) {
                          return Divider();
                        },
                        itemBuilder: (context, index) {
                          if (bookService.bookReportList.isEmpty) {
                            return SizedBox();
                          }
                          BookReport bookReport =
                              bookService.bookReportList.elementAt(index);
                          return BookReportListTile(bookReport: bookReport);
                        },
                      ),
                    )
                  : Expanded(
                      child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3, childAspectRatio: 3 / 4),
                      itemCount: bookService.bookReportList.length,
                      itemBuilder: (context, index) {
                        if (bookService.bookReportList.isEmpty) {
                          return SizedBox();
                        }
                        BookReport bookReport =
                            bookService.bookReportList.elementAt(index);
                        return BookReportAlbumTile(bookReport: bookReport);
                      },
                    ))
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              bookService.createInitReport(editDay: DateTime.now());
              Navigator.push<void>(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => BookReportEditPage(
                    index: bookService.bookReportList.length - 1,
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
