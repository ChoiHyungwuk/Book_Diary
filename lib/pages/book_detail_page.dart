import 'package:flutter/material.dart';
import 'package:flutter_project_book_search/data/book.dart';
import 'package:flutter_project_book_search/res/colors.dart';
import 'package:flutter_project_book_search/res/strings.dart';
import 'package:flutter_project_book_search/res/style.dart';
import 'package:flutter_project_book_search/res/values.dart';

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
            children: <Widget>[
              Image.network(
                book.thumbnail,
                fit: BoxFit.contain,
              )
            ],
          ),
        ),
      ),
    );
  }
}
