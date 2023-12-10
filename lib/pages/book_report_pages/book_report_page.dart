import 'package:flutter/material.dart';
import 'package:flutter_project_book_search/data/book_report.dart';
import 'package:flutter_project_book_search/res/colors.dart';
import 'package:flutter_project_book_search/res/style.dart';
import 'package:flutter_project_book_search/res/values.dart';
import 'package:flutter_project_book_search/service/book_service.dart';
import 'package:flutter_project_book_search/utils/utils.dart';
import 'package:flutter_project_book_search/widget/tile/book_report_album_tile.dart';
import 'package:flutter_project_book_search/widget/tile/book_report_list_tile.dart';
import 'package:provider/provider.dart';

import '../../res/strings.dart';

class BookReportPage extends StatefulWidget {
  const BookReportPage({super.key});

  @override
  State<StatefulWidget> createState() => _BookReportPage();
}

class _BookReportPage extends State<BookReportPage> {
  final GlobalKey gridKey = GlobalKey();

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
        bool viewOption = bookService.getReportViewOption();
        final List<bool> selectedViewOption = <bool>[
          (viewOption),
          !(viewOption)
        ];

        return Scaffold(
          appBar: AppBar(
            toolbarHeight: appBarHeight,
            automaticallyImplyLeading: false,
            elevation: 1,
            title: Text(
              "$searchTargetOptionAll (${bookService.bookReportList.length})",
              style: appBarTitleStyle,
            ),
            actions: <Widget>[
              Row(
                children: <Widget>[
                  ToggleButtons(
                    onPressed: (int index) {
                      setState(() {
                        for (int i = 0; i < selectedViewOption.length; i++) {
                          selectedViewOption[i] = i == index;
                        }
                        bookService
                            .setReportViewOption(index == 0 ? true : false);
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
                    isSelected: selectedViewOption,
                    children: viewContent,
                  ),
                  SizedBox(width: 5),
                ],
              ),
            ],
          ),
          body: Container(
            padding: bodyPadding,
            child: Column(
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
                        key: gridKey,
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3, childAspectRatio: 3 / 5),
                          itemCount: bookService.bookReportList.length,
                          itemBuilder: (context, index) {
                            if (bookService.bookReportList.isEmpty) {
                              return SizedBox();
                            }
                            BookReport bookReport =
                                bookService.bookReportList.elementAt(index);
                            return BookReportAlbumTile(
                              bookReport: bookReport,
                              gridKey: gridKey,
                              conte: context,
                            );
                          },
                        ),
                      ))
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              addBookReportElement(context, null);
            },
            backgroundColor: appBasicColor,
            splashColor: overlayColor,
            tooltip: addReport,
            child: Icon(
              Icons.add_box_outlined,
              color: whiteColor,
              size: iconBasicSize30,
            ),
          ),
        );
      },
    );
  }
}
