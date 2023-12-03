import 'package:flutter/material.dart';
import 'package:flutter_project_book_search/pages/book_report_pages/book_report_view_page.dart';
import 'package:flutter_project_book_search/res/colors.dart';
import 'package:flutter_project_book_search/res/style.dart';
import 'package:flutter_project_book_search/res/values.dart';
import 'package:flutter_project_book_search/utils/utils.dart';
import 'package:flutter_project_book_search/widget/modal_bottom_sheet/long_touch_bottom_sheet.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../data/book_report.dart';

class BookReportAlbumTile extends StatelessWidget {
  const BookReportAlbumTile({
    super.key,
    required this.bookReport,
    required this.gridKey,
    required this.conte,
  });

  final BookReport bookReport;
  final GlobalKey gridKey;
  final BuildContext conte;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      overlayColor: MaterialStateProperty.all<Color>(overlayColor),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookReportViewPage(bookReport: bookReport),
          ),
        );
      },
      onLongPress: () {
        showLongTouthBottomSheet(context, bookReport);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          children: <Widget>[
            bookReport.thumbnail == null
                ? SizedBox()
                : imageReplace(bookReport.thumbnail ?? ''),
            SizedBox(height: 1),
            Text(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              bookReport.bookTitle ?? "제목이 없습니다",
              style: textStyleBlack14,
            ),
            SizedBox(height: 1),
            AbsorbPointer(
              absorbing: true, //클릭 가능 여부 true = 클릭 막기
              child: RatingBar.builder(
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
            ),
          ],
        ),
      ),
    );
  }
}
