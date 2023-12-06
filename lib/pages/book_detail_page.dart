import 'package:flutter/material.dart';
import 'package:flutter_project_book_search/data/book.dart';
import 'package:flutter_project_book_search/pages/web_view_page.dart';
import 'package:flutter_project_book_search/res/colors.dart';
import 'package:flutter_project_book_search/res/strings.dart';
import 'package:flutter_project_book_search/res/style.dart';
import 'package:flutter_project_book_search/res/values.dart';
import 'package:flutter_project_book_search/utils/utils.dart';

class BookDetailPage extends StatelessWidget {
  const BookDetailPage({super.key, required this.book});

  final Book book;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
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
            book.title,
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return SizedBox(
                      height: 200,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const Text('Modal BottomSheet'),
                            ElevatedButton(
                              child: const Text('Close BottomSheet'),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              icon: Icon(
                Icons.menu_rounded,
                size: iconBasicSize30,
                color: appBasicColor,
              ),
            )
          ],
        ),
        body: BookDetailPageBody(
          book: book,
        ),
      ),
    );
  }
}

class BookDetailPageBody extends StatelessWidget {
  const BookDetailPageBody({super.key, required this.book});
  final Book book;

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: SingleChildScrollView(
        child: Container(
          padding: bodyPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    imageReplace(book.thumbnail),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          book.title,
                          style: textStyleBlack20,
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.person,
                              size: iconBasicSize30,
                              color: greyColor,
                            ),
                            SizedBox(width: 10),
                            Text(
                              book.authors.join(", "),
                              style: textStyleBlack15,
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.store_rounded,
                              size: iconBasicSize30,
                              color: greyColor,
                            ),
                            SizedBox(width: 10),
                            Text(
                              book.publisher,
                              style: textStyleBlack15,
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.calendar_month_rounded,
                              size: iconBasicSize30,
                              color: greyColor,
                            ),
                            SizedBox(width: 10),
                            Text(
                              book.publishedDate.substring(0, 10),
                              style: textStyleBlack15,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  border: Border.symmetric(
                    horizontal: BorderSide(color: blackColor),
                  ), // 테두리 색상 지정
                ),
                child: ExpansionTile(
                  title: Text(
                    bookIntroduction,
                    style: textStyleBlack18,
                  ),
                  children: <Widget>[
                    book.contents.isEmpty
                        ? Text(
                            bookIntroductionEmpty,
                            style: textStyleBlack15,
                          )
                        : Text(
                            book.contents,
                            style: textStyleBlack15,
                            maxLines: 7,
                            overflow: TextOverflow.ellipsis,
                          ),
                    TextButton(
                        style: ButtonStyle(
                          overlayColor: MaterialStateProperty.all(overlayColor),
                        ),
                        onPressed: () async {
                          if (!await checkNetworkState(context)) {
                            return;
                          }
                          if (!context.mounted) {
                            return;
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WebViewPage(
                                url: book.previewLink,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          more,
                          style: textStyleHighlight15,
                        ))
                  ],
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
