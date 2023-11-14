import 'package:flutter/material.dart';
import 'package:flutter_project_book_search/data/book.dart';
import 'package:flutter_project_book_search/service/bookService.dart';
import 'package:provider/provider.dart';

import '../pages/web_view_page.dart';

class BookTile extends StatelessWidget {
  const BookTile({
    super.key,
    required this.book,
    required this.pageOption,
  });

  final Book book;
  final bool pageOption; //false = 검색 기능만, true = 선택 기능포함

  @override
  Widget build(BuildContext context) {
    BookService bookService = context.read<BookService>();

    return ListTile(
      splashColor: Colors.blue,
      onTap: () {
        pageOption
            ? null
            : Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WebViewPage(
                    url: book.previewLink.replaceFirst("http", "https"),
                  ),
                ),
              );
      },
      leading: Image.network(
        book.thumbnail,
        fit: BoxFit.fitHeight,
      ),
      title: Text(
        book.title,
        style: TextStyle(fontSize: 16),
      ),
      subtitle: Text(
        "저자 : ${book.authors.join(", ")}\n출간일 : ${book.publishedDate}",
        style: TextStyle(color: Colors.grey),
      ),
      trailing: pageOption
          ? ElevatedButton(
              onPressed: () {
                bookService.bookSelectList.add(book);
                Navigator.pop(context);
              },
              child: Text("선택"))
          : IconButton(
              onPressed: () {
                bookService.toggleLikeBook(book: book);
              },
              icon: bookService.likedBookList
                      .map((book) => book.id)
                      .contains(book.id)
                  ? Icon(
                      Icons.star,
                      color: Colors.amber,
                    )
                  : Icon(Icons.star_border),
            ),
    );
  }
}
