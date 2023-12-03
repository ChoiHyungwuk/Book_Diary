import 'package:flutter/material.dart';
import 'package:flutter_project_book_search/data/book_report.dart';
import 'package:flutter_project_book_search/res/colors.dart';
import 'package:flutter_project_book_search/res/strings.dart';
import 'package:flutter_project_book_search/res/style.dart';
import 'package:flutter_project_book_search/res/values.dart';
import 'package:flutter_project_book_search/utils/utils.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

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
              modifyBookReportElement(context, bookReport);
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
              deleteBookReportElement(context, bookReport);
            },
            icon: Icon(
              Icons.delete,
              color: appBasicColor,
              size: iconBasicSize30,
            ),
          ),
        ],
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Container(
            padding: bodyPadding,
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    bookReport.title ?? '',
                    style: textStyleBlack18,
                  ),
                ),
                Divider(height: 40),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    bookReport.content ?? '',
                    style: textStyleBlack15,
                  ),
                ),
                Divider(height: 40),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '$editDay : ${bookReport.editDay.year}년 ${bookReport.editDay.month}월 ${bookReport.editDay.day}일 ${bookReport.editDay.hour}시 ${bookReport.editDay.minute}분',
                    textAlign: TextAlign.end,
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: Divider(
                    height: 40,
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Scrollbar(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: <Widget>[
                            imageReplace(bookReport.thumbnail ?? ''),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  bookReport.bookTitle ?? '',
                                  style: textStyleBlack20,
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.person,
                                      size: iconBasicSize30,
                                      color: greyColor,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      '${bookReport.authors?.join(', ')}',
                                      style: textStyleBlack15,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.calendar_month_rounded,
                                      size: iconBasicSize30,
                                      color: greyColor,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      '${bookReport.startDate?.substring(0, 10)} ~ ${bookReport.endDate?.substring(0, 10)}',
                                      style: textStyleBlack15,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.star_half_rounded,
                                      size: iconBasicSize30,
                                      color: greyColor,
                                    ),
                                    SizedBox(width: 10),
                                    AbsorbPointer(
                                      absorbing: true,
                                      child: RatingBar.builder(
                                        initialRating: bookReport.stars ?? 0,
                                        allowHalfRating: true,
                                        unratedColor:
                                            Colors.amber.withAlpha(50),
                                        itemCount: 5,
                                        itemSize: iconBasicSize30,
                                        itemPadding: EdgeInsets.symmetric(
                                            horizontal: 0.0),
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        onRatingUpdate: (rating) {
                                          return;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
