import 'package:flutter/material.dart';
import 'package:flutter_project_book_search/data/book.dart';
import 'package:flutter_project_book_search/res/colors.dart';
import 'package:flutter_project_book_search/res/style.dart';
import 'package:flutter_project_book_search/res/values.dart';
import 'package:flutter_project_book_search/service/book_service.dart';
import 'package:flutter_project_book_search/utils/utils.dart';
import 'package:provider/provider.dart';

import '../res/strings.dart';
import '../widget/tile/book_tile.dart';

int searchOption = 30;

class SearchPage extends StatefulWidget {
  SearchPage({super.key, required this.pageOption});

  final bool pageOption;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool isSearch = false;

  FocusNode searchFocusNode = FocusNode();

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
        List<Book> bookLists = widget.pageOption
            ? bookService.bookSelectList
            : bookService.bookList;
        return SafeArea(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus(); //화면 다른 부분이 터치 되었을 때 키보드 내리게하기
            },
            child: Scaffold(
              appBar: AppBar(
                toolbarHeight: appBarHeight,
                automaticallyImplyLeading: false,
                elevation: 1,
                leading: widget.pageOption
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
                        child: InkWell(
                          onTap: () {
                            searchFocusNode.requestFocus();
                            setState(() {
                              isSearch = true;
                            });
                          },
                          child: AbsorbPointer(
                            absorbing: true,
                            child: TextField(
                              textInputAction: TextInputAction.done,
                              onSubmitted: (value) {
                                setState(() {
                                  isSearch = false;
                                });
                                bookService.searchBooks(
                                    value, searchOption, bookLists);
                              },
                              controller: _searchController,
                              focusNode: searchFocusNode,
                              cursorColor: Colors.grey,
                              decoration: InputDecoration(
                                prefixIcon:
                                    Icon(Icons.search, color: Colors.grey),
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
                                  icon: Icon(Icons.cancel_rounded),
                                ),
                                suffixIconColor: MaterialStateColor.resolveWith(
                                  (states) {
                                    if (states
                                        .contains(MaterialState.focused)) {
                                      return appBasicColor;
                                    }
                                    return greyColor;
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    widget.pageOption
                        ? Container()
                        : DropdownMenu<ViewCounts>(
                            width: 95,
                            controller: _searchOptionController,
                            dropdownMenuEntries: searchEntries,
                            initialSelection: ViewCounts.val_30,
                            label: Text(
                              searchOptionStr,
                              style: textLabelStyle,
                            ),
                            onSelected: (value) {
                              searchOption = value?.val ?? 30;
                            },
                          ),
                  ],
                ),
              ),
              body: isSearch
                  ? searchContainer()
                  : Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 40),
                      child: GlowingOverscrollIndicator(
                        color: overlayColor,
                        axisDirection: AxisDirection.down,
                        child: Scrollbar(
                          thumbVisibility: true,
                          child: ListView.separated(
                            itemCount: bookLists.length,
                            separatorBuilder: (context, index) {
                              return Divider(
                                height: 5,
                              );
                            },
                            itemBuilder: (context, index) {
                              if (bookLists.isEmpty) return SizedBox();
                              Book book = bookLists.elementAt(index);
                              return BookTile(
                                  book: book, pageOption: widget.pageOption);
                            },
                          ),
                        ),
                      ),
                    ),
              bottomSheet: isSearch
                  ? null
                  : Container(
                      width: double.infinity,
                      height: 40,
                      child: Row(
                        children: <Widget>[
                          FilledButton(
                            onPressed: () {},
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(transparentColor),
                              overlayColor:
                                  MaterialStateProperty.all(overlayColor),
                              fixedSize: MaterialStateProperty.all<Size>(
                                Size.fromWidth(
                                  setWidthSize(context, 0.5),
                                ),
                              ),
                            ),
                            child: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              size: iconBasicSize30,
                              color: appBasicColor,
                            ),
                          ),
                          Container(
                              height: 30,
                              child: VerticalDivider(
                                width: 0,
                              )),
                          FilledButton(
                            onPressed: () {},
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(transparentColor),
                              overlayColor:
                                  MaterialStateProperty.all(overlayColor),
                              fixedSize: MaterialStateProperty.all<Size>(
                                Size.fromWidth(
                                  setWidthSize(context, 0.5),
                                ),
                              ),
                            ),
                            child: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: iconBasicSize30,
                              color: appBasicColor,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }

  Container searchContainer() {
    return Container(
      padding: bodyPadding,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              OutlinedButton(
                onPressed: () async {
                  await showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return SizedBox(
                        height: 200,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(searchOptions),
                              ElevatedButton(
                                child: Text(searchOptionAll),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Row(
                  children: <Widget>[
                    Text(
                      '전체',
                      style: textStyleBlack15,
                    ),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: iconBasicSize30,
                      color: appBasicColor,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SizedBox(width: double.infinity),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    isSearch = false;
                    FocusScope.of(context).unfocus();
                  });
                },
                child: Text(
                  searchClose,
                  style: textStyleHighlight15,
                ),
              ),
            ],
          ),
          Divider(),
          Text(
            searchOptionTitle,
            style: textStyleBlack15,
          ),
          // Expanded(
          //   child: ListView.separated(
          //     itemCount: 1,
          //     separatorBuilder: (context, index) {
          //       return Divider();
          //     },
          //     itemBuilder: (context, index) {
          //       return null;
          //     },
          //   ),
          // ),
          TextButton(
            onPressed: () {},
            child: Text(
              searchRegistDeleteAll,
              style: textStyleHighlight15,
            ),
          ),
        ],
      ),
    );
  }
}
