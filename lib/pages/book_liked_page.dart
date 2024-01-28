import 'package:flutter/material.dart';
import 'package:flutter_project_book_search/data/book.dart';
import 'package:flutter_project_book_search/res/strings.dart';
import 'package:flutter_project_book_search/res/style.dart';
import 'package:flutter_project_book_search/res/values.dart';
import 'package:flutter_project_book_search/service/book_service.dart';
import 'package:flutter_project_book_search/widget/tile/book_tile.dart';
import 'package:provider/provider.dart';

class LikedBookPage extends StatelessWidget {
  const LikedBookPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BookService>(builder: (context, bookService, child) {
      return Scaffold(
        appBar: AppBar(
          toolbarHeight: appBarHeight,
          automaticallyImplyLeading: false,
          elevation: 1,
          title: Text(
            bookToReadLater,
            style: appBarTitleStyle,
          ),
        ),
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
