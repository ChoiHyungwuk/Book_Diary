import 'package:flutter/material.dart';
import 'package:flutter_project_book_search/data/book_report.dart';
import 'package:flutter_project_book_search/res/colors.dart';
import 'package:flutter_project_book_search/res/strings.dart';
import 'package:flutter_project_book_search/res/style.dart';
import 'package:flutter_project_book_search/res/values.dart';
import 'package:flutter_project_book_search/service/bookService.dart';
import 'package:flutter_project_book_search/widget/dialog/dialog.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

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
        leading: IconButton(
          splashColor: overlayColor,
          tooltip: backPress,
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_rounded,
            color: appBasicColor,
            size: iconBasicSize30,
          ),
        ),
        title: Text(
          style: appBarTitleStyle,
          overflow: TextOverflow.ellipsis,
          bookReport.title ?? '',
        ),
        actions: <Widget>[
          IconButton(
            tooltip: modify,
            onPressed: () {
              BookService bookService = context.read<BookService>();
            },
            icon: Icon(
              Icons.edit_square,
              color: appBasicColor,
              size: iconBasicSize30,
            ),
          ),
          IconButton(
            tooltip: delete,
            onPressed: () async {
              BookService bookService = context.read<BookService>();
              if (await showAlertDialog(context, bookReportDelete)) {
                if (bookService.bookReportList
                    .map((bookReport) => bookReport.id)
                    .contains(bookReport.id)) {
                  bookService.bookReportList.removeWhere(
                      (bookReport) => bookReport.id == bookReport.id);
                  if (!context.mounted) {
                    return; //비동기 내부에서 context를 파라미터로 전달하려할 때 사용
                  }
                  Navigator.pop(context);
                }
              }
            },
            icon: Icon(
              Icons.delete,
              color: appBasicColor,
              size: iconBasicSize30,
            ),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Text(bookReport.title ?? ''),
          Text(bookReport.content ?? ''),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '$editDay : ${bookReport.editDay.year}년 ${bookReport.editDay.month}월 ${bookReport.editDay.day}일 ${bookReport.editDay.hour}시 ${bookReport.editDay.minute}분',
              textAlign: TextAlign.end,
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Row(
              children: <Widget>[
                Image.network(bookReport.thumbnail ?? ''),
                Column(
                  children: <Widget>[
                    Text(bookReport.bookTitle ?? ''),
                    Text(bookReport.startDate?.substring(0, 10) ?? ''),
                    Text(bookReport.endDate?.substring(0, 10) ?? ''),
                    RatingBar.builder(
                      initialRating: bookReport.stars ?? 0,
                      allowHalfRating: true,
                      unratedColor: Colors.amber.withAlpha(50),
                      itemCount: 5,
                      itemSize: iconSize20,
                      itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        return;
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
