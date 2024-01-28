import 'package:flutter/material.dart';
import 'package:flutter_project_book_search/data/book.dart';
import 'package:flutter_project_book_search/main.dart';
import 'package:flutter_project_book_search/res/colors.dart';
import 'package:flutter_project_book_search/res/enums.dart';
import 'package:flutter_project_book_search/res/style.dart';
import 'package:flutter_project_book_search/res/values.dart';
import 'package:flutter_project_book_search/service/book_service.dart';
import 'package:flutter_project_book_search/utils/utils.dart';
import 'package:flutter_project_book_search/widget/dialog/two_button_dialog.dart';
import 'package:provider/provider.dart';

import '../res/strings.dart';
import '../widget/tile/book_tile.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key, required this.pageOption});

  final bool pageOption;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool isSearch = false; //검색입력창 포커스 제어 플래그
  bool isSearchEmpty = false; //검색결과 없을 때
  String lastSearchText = '';
  String optionButtonText = searchTargetOptionAll;

  int totalPage = 1;
  int currentPage = 1;
  bool isEnd = true;

  var selectSearchTargetOption = SearchTarget.all;
  var selectSearchSortOption = SearchSort.accuracy;

  FocusNode searchFocusNode = FocusNode();
  FocusNode searchOptionButtonFocusNode = FocusNode();

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (!widget.pageOption) {
      lastSearchText = prefs.getString('lastSearchText') ?? '';
      _searchController.text = lastSearchText;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookService>(
      builder: (context, bookService, child) {
        List<Book> bookLists = widget.pageOption
            ? bookService.bookSelectList
            : bookService.bookList;

        isEnd = (bookService.bookMetaData.isEmpty || currentPage == 33)
            ? false
            : bookService.bookMetaData.first.isEnd;
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
                  children: <Widget>[
                    Flexible(
                      child: SizedBox(
                        height: 57,
                        child: TextField(
                          onTap: () {
                            setState(() {
                              isSearch = true;
                            });
                          },
                          textInputAction: TextInputAction.done,
                          onSubmitted: (value) async {
                            if (!await checkNetworkState(context)) {
                              return;
                            }
                            lastSearchText = value;
                            isSearch = false;
                            currentPage = 1;
                            bookService.searchBooks(
                                value,
                                bookLists,
                                currentPage,
                                selectSearchTargetOption.name,
                                selectSearchSortOption.name);
                            if (!widget.pageOption) {
                              prefs.setString('lastSearchText', lastSearchText);
                              bookService.addBookSearchList(
                                  text: lastSearchText);
                            }
                          },
                          controller: _searchController,
                          focusNode: searchFocusNode,
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
                              icon: Icon(Icons.cancel_rounded),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              body: isSearch
                  ? searchContainer(bookService)
                  : bookLists.isEmpty
                      ? Center(
                          child: Text(
                            searchEmpty,
                            style: textStyleBlack20,
                          ),
                        )
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
                                      book: book,
                                      pageOption: widget.pageOption);
                                },
                              ),
                            ),
                          ),
                        ),
              bottomSheet: isSearch
                  ? null
                  : pageController(bookService, bookLists, context),
            ),
          ),
        );
      },
    );
  }

  Container pageController(
      BookService bookService, List<Book> bookLists, BuildContext context) {
    return Container(
      width: double.infinity,
      height: 40,
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(
              splashColor: overlayColor,
            ),
            child: FilledButton(
              onPressed: prePage(bookService, bookLists),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(transparentColor),
                overlayColor: MaterialStateProperty.all(overlayColor),
                fixedSize: MaterialStateProperty.all<Size>(
                  Size.fromWidth(
                    setWidthSize(context, 0.5),
                  ),
                ),
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: iconBasicSize30,
                color: currentPage == 1 ? greyColor : appBasicColor,
              ),
            ),
          ),
          SizedBox(
            height: 30,
            child: VerticalDivider(
              width: 0,
            ),
          ),
          FilledButton(
            onPressed: nextPage(bookService, bookLists),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(transparentColor),
              overlayColor: MaterialStateProperty.all(overlayColor),
              fixedSize: MaterialStateProperty.all<Size>(
                Size.fromWidth(
                  setWidthSize(context, 0.5),
                ),
              ),
            ),
            child: Icon(
              Icons.arrow_forward_ios_rounded,
              size: iconBasicSize30,
              color: isEnd ? greyColor : appBasicColor,
            ),
          ),
        ],
      ),
    );
  }

  Container searchContainer(BookService bookService) {
    return Container(
      padding: bodyPadding,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              OutlinedButton(
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(overlayColor),
                ),
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return StatefulBuilder(
                        builder: (context, setState) => Container(
                          padding: bodyPadding,
                          height: 300,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                    child: TextButton(
                                      style: ButtonStyle(
                                          overlayColor:
                                              MaterialStateProperty.all(
                                                  overlayColor)),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        searchClose,
                                        style: textStyleBlack15,
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  searchTargetOptions,
                                  style: textStyleBlack20,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    OutlinedButton(
                                      focusNode: searchOptionButtonFocusNode,
                                      style: ButtonStyle(
                                        fixedSize: MaterialStateProperty.all(
                                          Size.fromWidth(
                                            setWidthSize(context, 0.30),
                                          ),
                                        ),
                                        side: selectSearchTargetOption ==
                                                SearchTarget.all
                                            ? focusButtonBorder
                                            : outFocusButtonBorder,
                                        overlayColor:
                                            MaterialStateProperty.all<Color>(
                                                overlayColor),
                                      ),
                                      child: Text(
                                        searchTargetOptionAll,
                                        style: textStyleBlack15,
                                      ),
                                      onPressed: () {
                                        setState(
                                          () {
                                            optionButtonTextUpdate(
                                                searchTargetOptionAll);
                                            selectSearchTargetOption =
                                                SearchTarget.all;
                                          },
                                        );
                                      },
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    OutlinedButton(
                                      style: ButtonStyle(
                                        fixedSize: MaterialStateProperty.all(
                                          Size.fromWidth(
                                            setWidthSize(context, 0.30),
                                          ),
                                        ),
                                        side: selectSearchTargetOption ==
                                                SearchTarget.person
                                            ? focusButtonBorder
                                            : outFocusButtonBorder,
                                        overlayColor:
                                            MaterialStateProperty.all<Color>(
                                                overlayColor),
                                      ),
                                      child: Text(
                                        searchTargetOptionAuthors,
                                        style: textStyleBlack15,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          optionButtonTextUpdate(
                                              searchTargetOptionAuthors);
                                          selectSearchTargetOption =
                                              SearchTarget.person;
                                        });
                                      },
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    OutlinedButton(
                                      style: ButtonStyle(
                                        fixedSize: MaterialStateProperty.all(
                                          Size.fromWidth(
                                            setWidthSize(context, 0.30),
                                          ),
                                        ),
                                        side: selectSearchTargetOption ==
                                                SearchTarget.title
                                            ? focusButtonBorder
                                            : outFocusButtonBorder,
                                        overlayColor:
                                            MaterialStateProperty.all<Color>(
                                                overlayColor),
                                      ),
                                      child: Text(
                                        searchTargetOptionTitle,
                                        style: textStyleBlack15,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          optionButtonTextUpdate(
                                              searchTargetOptionTitle);
                                          selectSearchTargetOption =
                                              SearchTarget.title;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  searchSortOptions,
                                  style: textStyleBlack20,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    OutlinedButton(
                                      focusNode: searchOptionButtonFocusNode,
                                      style: ButtonStyle(
                                        fixedSize: MaterialStateProperty.all(
                                          Size.fromWidth(
                                            setWidthSize(context, 0.30),
                                          ),
                                        ),
                                        side: selectSearchSortOption ==
                                                SearchSort.accuracy
                                            ? focusButtonBorder
                                            : outFocusButtonBorder,
                                        overlayColor:
                                            MaterialStateProperty.all<Color>(
                                                overlayColor),
                                      ),
                                      child: Text(
                                        searchSortOptionAccuracy,
                                        style: textStyleBlack15,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          selectSearchSortOption =
                                              SearchSort.accuracy;
                                        });
                                      },
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    OutlinedButton(
                                      style: ButtonStyle(
                                        fixedSize: MaterialStateProperty.all(
                                          Size.fromWidth(
                                            setWidthSize(context, 0.30),
                                          ),
                                        ),
                                        side: selectSearchSortOption ==
                                                SearchSort.latest
                                            ? focusButtonBorder
                                            : outFocusButtonBorder,
                                        overlayColor:
                                            MaterialStateProperty.all<Color>(
                                                overlayColor),
                                      ),
                                      child: Text(
                                        searchSortOptionLatest,
                                        style: textStyleBlack15,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          selectSearchSortOption =
                                              SearchSort.latest;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Row(
                  children: <Widget>[
                    Text(
                      optionButtonText,
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
                style: ButtonStyle(
                    overlayColor:
                        MaterialStateProperty.all<Color>(overlayColor)),
                onPressed: () {
                  setState(() {
                    isSearch = false;
                    _searchController.text = lastSearchText;
                    FocusScope.of(context).unfocus();
                  });
                },
                child: Text(
                  searchClose,
                  style: textStyleBlack15,
                ),
              ),
            ],
          ),
          Divider(),
          Row(
            children: <Widget>[
              Text(
                searchRegist,
                style: textStyleBlack15,
              ),
              Expanded(
                child: SizedBox(width: double.infinity),
              ),
              TextButton(
                style: ButtonStyle(
                    overlayColor:
                        MaterialStateProperty.all<Color>(overlayColor)),
                onPressed: () async {
                  if (await showTwoButtonDialog(
                      context, searchRegistDeleteAllMsg)) {
                    bookService.deleteAllBookSearchList();
                  }
                },
                child: Text(
                  searchRegistDeleteAll,
                  style: textStyleHighlight15,
                ),
              ),
            ],
          ),
          Expanded(
            child: Scrollbar(
              child: ListView.separated(
                itemCount: bookService.bookSearchRegistList.length,
                separatorBuilder: (context, index) {
                  return Divider(height: 5);
                },
                itemBuilder: (context, index) {
                  if (bookService.bookSearchRegistList.isEmpty) {
                    return SizedBox();
                  }
                  return Theme(
                    data: ThemeData(highlightColor: transparentColor),
                    child: ListTile(
                      splashColor: transparentColor,
                      onTap: () {
                        _searchController.text =
                            bookService.bookSearchRegistList[index].searchText;
                        searchFocusNode.requestFocus();
                      },
                      leading: Icon(Icons.history_rounded),
                      title: Text(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        bookService.bookSearchRegistList[index].searchText,
                        style: textStyleBlack15,
                      ),
                      trailing: IconButton(
                        highlightColor: overlayColor,
                        onPressed: () =>
                            bookService.deleteBookSearchList(index: index),
                        icon: Icon(
                          Icons.close_rounded,
                          size: iconBasicSize30,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  dynamic prePage(BookService bookService, List<Book> bookList) {
    if (currentPage == 1) {
      return null;
    }
    return () {
      bookService.searchBooks(lastSearchText, bookList, --currentPage,
          selectSearchTargetOption.name, selectSearchSortOption.name);
    };
  }

  dynamic nextPage(BookService bookService, List<Book> bookList) {
    if (bookService.bookMetaData.isNotEmpty &&
        bookService.bookMetaData.first.isEnd) {
      return null;
    }
    return () {
      bookService.searchBooks(lastSearchText, bookList, ++currentPage,
          selectSearchTargetOption.name, selectSearchSortOption.name);
      isEnd = bookService.bookMetaData.isEmpty
          ? false
          : bookService.bookMetaData.first.isEnd;
    };
  }

  void optionButtonTextUpdate(String text) {
    super.setState(() {
      optionButtonText = text;
    });
  }

  showClearButton() {
    setState(() {});
  }
}
