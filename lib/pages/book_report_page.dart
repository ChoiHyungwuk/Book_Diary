import 'package:flutter/material.dart';
import 'package:flutter_project_book_search/data/book_report.dart';
import 'package:flutter_project_book_search/main.dart';
import 'package:flutter_project_book_search/pages/book_report_edit_page.dart';
import 'package:flutter_project_book_search/res/colors.dart';
import 'package:flutter_project_book_search/res/style.dart';
import 'package:flutter_project_book_search/res/values.dart';
import 'package:flutter_project_book_search/service/bookService.dart';
import 'package:flutter_project_book_search/widget/tile/book_report_album_tile.dart';
import 'package:flutter_project_book_search/widget/tile/book_report_list_tile.dart';
import 'package:provider/provider.dart';

import '../res/strings.dart';

class BookReportPage extends StatefulWidget {
  const BookReportPage({super.key});

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
          appBar: AppBar(
            backgroundColor: appBarColor,
            toolbarHeight: appBarHeight,
            automaticallyImplyLeading: false,
            elevation: 1,
            title: Text(
              "전체(${bookService.bookReportList.length})",
              style: appBarTitleStyle,
            ),
            actions: <Widget>[
              Row(
                children: <Widget>[
                  ToggleButtons(
                    onPressed: (int index) {
                      setState(() {
                        for (int i = 0; i < _selectedViewOption.length; i++) {
                          _selectedViewOption[i] = i == index;
                        }
                        prefs.setBool('viewOption', index == 0 ? true : false);
                        viewOption = index == 0 ? true : false;
                      });
                    },
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    selectedBorderColor: selectBorderColor,
                    selectedColor: whiteColor,
                    splashColor: overlayColor,
                    fillColor: appBasicColor,
                    borderColor: appBasicColor,
                    color: appBasicColor,
                    constraints: const BoxConstraints(
                      minHeight: 35.0,
                      minWidth: 90.0,
                    ),
                    isSelected: _selectedViewOption,
                    children: viewContent,
                  ),
                  SizedBox(width: 5),
                ],
              ),
            ],
          ),
          body: Column(
            children: [
              viewOption
                  ? Expanded(
                      child: GlowingOverscrollIndicator(
                        color: overlayColor,
                        axisDirection: AxisDirection.down,
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
                      ),
                    )
                  : Expanded(
                      child: GlowingOverscrollIndicator(
                      color: overlayColor,
                      axisDirection: AxisDirection.down,
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
                      ),
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
            backgroundColor: appBasicColor,
            splashColor: overlayColor,
            tooltip: addReport,
            child: Icon(
              Icons.add_box_outlined,
              size: iconBasicSize30,
            ),
          ),
        );
      },
    );
  }
}
