import 'package:flutter/material.dart';
import 'package:flutter_project_book_search/data/book.dart';
import 'package:flutter_project_book_search/service/book_service.dart';
import 'package:flutter_project_book_search/widget/tile/book_tile.dart';
import 'package:provider/provider.dart';

class LikedBookPage extends StatelessWidget {
  const LikedBookPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BookService>(builder: (context, bookService, child) {
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: ListView.separated(
            itemCount: bookService.likedBookList.length,
            separatorBuilder: (context, index) {
              return Divider();
            },
            itemBuilder: (context, index) {
              if (bookService.likedBookList.isEmpty) return SizedBox();
              Book book = bookService.likedBookList.elementAt(index);
              return BookTile(book: book, pageOption: false);
            },
          ),
        ),
      );
    });
  }
}
