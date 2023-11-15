import 'package:flutter/material.dart';
import 'package:flutter_project_book_search/pages/book_report_view_page.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../data/book_report.dart';

class BookReportListTile extends StatelessWidget {
  const BookReportListTile({
    super.key,
    required this.bookReport,
  });

  final BookReport bookReport;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookReportViewPage(bookReport: bookReport),
          ),
        );
      },
      leading: Image.network(
        bookReport.thumbnail ??
            "https://img.freepik.com/premium-vector/default-image-icon-vector-missing-picture-page-for-website-design-or-mobile-app-no-photo-available_87543-11093.jpg",
        fit: BoxFit.fitHeight,
      ),
      title: Text(
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        bookReport.bookTitle ?? "제목이 없습니다",
        style: TextStyle(fontSize: 16),
      ),
      subtitle: Text(
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        bookReport.title ?? "내용이 없습니다",
        style: TextStyle(color: Colors.grey),
      ),
      trailing: AbsorbPointer(
        absorbing: true, //클릭 가능 여부
        child: RatingBar.builder(
          initialRating: bookReport.stars ?? 0,
          allowHalfRating: true,
          unratedColor: Colors.amber.withAlpha(50),
          itemCount: 5,
          itemSize: 20.0,
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
    );
  }
}
