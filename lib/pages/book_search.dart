import 'package:flutter/material.dart';
import 'package:flutter_project_book_search/data/book.dart';
import 'package:flutter_project_book_search/res/colors.dart';
import 'package:flutter_project_book_search/res/values.dart';
import 'package:flutter_project_book_search/service/bookService.dart';
import 'package:provider/provider.dart';

import '../res/strings.dart';
import '../widget/tile/book_tile.dart';

int searchOption = 30;

class SearchPage extends StatelessWidget {
  SearchPage({super.key, required this.pageOption});

  final bool pageOption;

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _searchOptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuEntry<ViewCounts>> searchEntries =
        <DropdownMenuEntry<ViewCounts>>[];
    for (final ViewCounts string in ViewCounts.values) {
      searchEntries.add(
        DropdownMenuEntry<ViewCounts>(value: string, label: string.label),
      );
    }

    return Consumer<BookService>(
      builder: (context, bookService, child) {
        List<Book> bookLists =
            pageOption ? bookService.bookSelectList : bookService.bookList;
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: appBarColor,
              toolbarHeight: appBarHeight,
              automaticallyImplyLeading: false,
              elevation: 1,
              leading: pageOption
                  ? IconButton(
                      splashColor: overlayColor,
                      onPressed: () {
                        bookService.bookSelectList.clear();
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_rounded,
                        color: appBasicColor,
                        size: iconBasicSize30,
                      ),
                    )
                  : null,
              title: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 57,
                      alignment: AlignmentDirectional.center,
                      child: TextField(
                        textInputAction: TextInputAction.done,
                        onSubmitted: (value) {
                          bookService.search(value, searchOption, bookLists);
                        },
                        controller: _searchController,
                        cursorColor: Colors.grey,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search, color: Colors.grey),
                            hintText: searchHint,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                _searchController.clear();
                              },
                              splashColor: overlayColor,
                              icon: Icon(Icons.clear),
                            ),
                            suffixIconColor: MaterialStateColor.resolveWith(
                              (states) {
                                if (states.contains(MaterialState.focused)) {
                                  return appBasicColor;
                                }
                                return greyColor;
                              },
                            )),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  pageOption
                      ? Container()
                      : DropdownMenu<ViewCounts>(
                          controller: _searchOptionController,
                          width: 95,
                          dropdownMenuEntries: searchEntries,
                          initialSelection: ViewCounts.c,
                          label: Text(searchOptionStr),
                          onSelected: (value) {
                            searchOption = value?.val ?? 30;
                          },
                        ),
                ],
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: GlowingOverscrollIndicator(
                color: overlayColor,
                axisDirection: AxisDirection.down,
                child: ListView.separated(
                  itemCount: bookLists.length,
                  separatorBuilder: (context, index) {
                    return Divider();
                  },
                  itemBuilder: (context, index) {
                    if (bookLists.isEmpty) return SizedBox();
                    Book book = bookLists.elementAt(index);
                    return BookTile(book: book, pageOption: pageOption);
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
