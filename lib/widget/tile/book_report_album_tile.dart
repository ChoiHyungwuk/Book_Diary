import 'package:flutter/material.dart';
import 'package:flutter_project_book_search/pages/book_report_view_page.dart';
import 'package:flutter_project_book_search/res/colors.dart';
import 'package:flutter_project_book_search/res/style.dart';
import 'package:flutter_project_book_search/res/values.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../data/book_report.dart';

class BookReportAlbumTile extends StatelessWidget {
  const BookReportAlbumTile({
    super.key,
    required this.bookReport,
  });

  final BookReport bookReport;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        overlayColor: MaterialStateProperty.all<Color>(overlayColor),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookReportViewPage(bookReport: bookReport),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Column(
            children: [
              Image.network(
                bookReport.thumbnail ??
                    "https://img.freepik.com/premium-vector/default-image-icon-vector-missing-picture-page-for-website-design-or-mobile-app-no-photo-available_87543-11093.jpg",
                fit: BoxFit.fitHeight,
                height: 130,
              ),
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
      ),
    );
  }
}
