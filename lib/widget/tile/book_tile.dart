import 'package:flutter/material.dart';
import 'package:flutter_project_book_search/data/book.dart';
import 'package:flutter_project_book_search/pages/book_detail_page.dart';
import 'package:flutter_project_book_search/res/colors.dart';
import 'package:flutter_project_book_search/res/strings.dart';
import 'package:flutter_project_book_search/res/style.dart';
import 'package:flutter_project_book_search/service/book_service.dart';
import 'package:flutter_project_book_search/utils/utils.dart';
import 'package:provider/provider.dart';

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
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop == false) {
          bookService.bookSelectList.clear();
        }
      },
      child: Row(
        children: <Widget>[
          Expanded(
            child: AbsorbPointer(
              absorbing: pageOption,
              child: Theme(
                data: ThemeData(highlightColor: overlayColor),
                child: ListTile(
                  splashColor: overlayColor,
                  onTap: () {
                    pageOption
                        ? null
                        : Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  // WebViewPage(
                                  //   url: book.previewLink
                                  //       .replaceFirst("http", "https"),
                                  // ),
                                  BookDetailPage(book: book),
                            ),
                          );
                  },
                  leading: imageReplace(book.thumbnail),
                  title: Text(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    book.title,
                    style: textStyleBlack15,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      book.authors.join().isEmpty
                          ? SizedBox()
                          : Text(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              "저자 : ${book.authors.join(", ")}",
                              style: textStyleGrey13,
                            ),
                      Text(
                        maxLines: 1,
                        "출간일 : ${book.publishedDate}",
                        style: textStyleGrey13,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
            alignment: Alignment.center,
            child: pageOption
                ? ElevatedButton(
                    onPressed: () {
                      bookService.bookSelectList.add(book);
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(appBasicColor),
                      overlayColor:
                          MaterialStateProperty.all<Color>(overlayColor),
                    ),
                    child: Text(
                      select,
                      style: textStyleWhite15,
                    ),
                  )
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
          ),
        ],
      ),
    );
  }
}
