import 'package:flutter/material.dart';
import 'package:flutter_project_book_search/data/book.dart';
import 'package:flutter_project_book_search/res/values.dart';
import 'package:flutter_project_book_search/service/bookService.dart';
import 'package:provider/provider.dart';

import '../res/strings.dart';
import '../widget/book_tile.dart';

int searchOption = 30;

class SearchPage extends StatelessWidget {
  SearchPage({super.key, required this.pageOption});

  final bool pageOption;

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _searchOptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuEntry<ViewCounts>> SearchEntries =
        <DropdownMenuEntry<ViewCounts>>[];
    for (final ViewCounts string in ViewCounts.values) {
      SearchEntries.add(
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
              backgroundColor: Colors.white,
              toolbarHeight: toolbarHeight,
              automaticallyImplyLeading: false,
              title: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 57,
                      alignment: AlignmentDirectional.center,
                      child: TextField(
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
                                icon: Icon(Icons.clear))),
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
                          dropdownMenuEntries: SearchEntries,
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
        );
      },
    );
  }
}
