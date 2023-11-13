import 'package:flutter/material.dart';
import 'package:flutter_project_book_search/service/bookService.dart';
import 'package:provider/provider.dart';

import '../data/book_report.dart';

class BookReportListTile extends StatelessWidget {
  const BookReportListTile({
    super.key,
    required this.bookReport,
  });

  final BookReport bookReport;

  @override
  Widget build(BuildContext context) {
    BookService bookService = context.read<BookService>();

    return ListTile(
      onTap: () {},
      leading: Image.network(
        bookReport.thumbnail ??
            "https://img.freepik.com/premium-vector/default-image-icon-vector-missing-picture-page-for-website-design-or-mobile-app-no-photo-available_87543-11093.jpg",
        fit: BoxFit.fitHeight,
      ),
      title: Text(
        bookReport.title ?? "빈 제목",
        style: TextStyle(fontSize: 16),
      ),
      subtitle: Text(
        "저자 : ",
        style: TextStyle(color: Colors.grey),
      ),
    );
  }
}
