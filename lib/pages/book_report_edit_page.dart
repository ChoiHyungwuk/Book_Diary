import 'package:flutter/material.dart';
import 'package:flutter_project_book_search/Utils/Utils.dart';
import 'package:flutter_project_book_search/pages/book_search.dart';
import 'package:flutter_project_book_search/res/colors.dart';
import 'package:flutter_project_book_search/res/style.dart';
import 'package:flutter_project_book_search/res/values.dart';
import 'package:flutter_project_book_search/service/bookService.dart';
import 'package:flutter_project_book_search/widget/dialog/dialog.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../data/book_report.dart';
import '../res/strings.dart';
import '../widget/dialog/calender_picker_dialog.dart';

class BookReportEditPage extends StatefulWidget {
  const BookReportEditPage({
    super.key,
    required this.index,
  });

  final int index;

  @override
  State<BookReportEditPage> createState() => _BookReportEditPageState();
}

class _BookReportEditPageState extends State<BookReportEditPage> {
  List<DateTime?> startDate = [DateTime.now()]; //독서 시작일
  List<DateTime?> endDate = [DateTime.now()]; //독서 종료일
  double? starVal; //별점
  String? reportTitle; //독후감 제목
  String? reportContent; //독후감 내용

  late FToast fToast;

  TextEditingController contentController = TextEditingController();

  void setStartDate(date) {
    setState(() {
      startDate = date;
      if (startDate.first!.microsecondsSinceEpoch >
          endDate.first!.microsecondsSinceEpoch) {
        endDate = date; //종료일보다 값이 높을 경우 동일 시간값으로 설정
      }
    });
  }

  void setEndDate(date) {
    setState(() {
      endDate = date;
      if (startDate.first!.microsecondsSinceEpoch >
          endDate.first!.microsecondsSinceEpoch) {
        startDate = date; //시작일보다 값이 높을 경우 동일 시간값으로 설정
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fToast = FToast(); //토스트 메시지 초기화
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    BookService bookService = context.read<BookService>();
    BookReport bookReport = bookService.bookReportList[widget.index];

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop == true &&
            await showAlertDialog(context, bookReportBackPressed)) {
          backPressed(bookService);
        }
      },
      child: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus(); //화면 다른 부분이 터치 되었을 때 키보드 내리게하기
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false, //화면 밀림방지
            appBar: AppBar(
              backgroundColor: appBarColor,
              toolbarHeight: appBarHeight,
              automaticallyImplyLeading: false,
              elevation: 1,
              leading: IconButton(
                onPressed: () async {
                  if (await showAlertDialog(context, bookReportBackPressed)) {
                    backPressed(bookService);
                  }
                },
                tooltip: backPress,
                icon: Icon(
                  Icons.arrow_back_rounded,
                  color: appBasicColor,
                  size: iconBasicSize30,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    if (bookReport.id == null || bookReport.id == '') {
                      showToast(fToast, insertReportBook, 2);
                    } else if (bookReport.stars == null ||
                        bookReport.stars == 0.0) {
                      showToast(fToast, insertReportstars, 2);
                    } else if (bookReport.title == null ||
                        bookReport.title == '') {
                      showToast(fToast, insertReportTitle, 2);
                    } else if (bookReport.content == null ||
                        bookReport.content == '') {
                      showToast(fToast, insertReportContent, 2);
                    } else {
                      bookService.updateBookReport(
                          index: widget.index, editDay: DateTime.now());
                      Navigator.pop(context);
                    }
                    // print(
                    // '1 : ${bookReport.id} 2 : ${bookReport.stars} 3 : ${bookReport.title} 4 : ${bookReport.content}');
                  },
                  splashColor: overlayColor,
                  tooltip: bookReportSave,
                  icon: Icon(
                    Icons.done,
                    color: appBasicColor,
                    size: iconBasicSize30,
                  ),
                )
              ],
            ),
            body: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 80,
                  alignment: Alignment.center,
                  child: bookReport.id == null
                      ? ElevatedButton(
                          onPressed: () async {
                            bookService.bookSelectList.clear(); //검색목록 초기화
                            await selectBook(bookService, context);
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(appBasicColor),
                            overlayColor:
                                MaterialStateProperty.all<Color>(overlayColor),
                            shadowColor:
                                MaterialStateProperty.all<Color>(overlayColor),
                          ),
                          child: Container(
                            width: 120,
                            height: 50,
                            child: Row(
                              children: [
                                Icon(Icons.add_circle),
                                SizedBox(width: 5),
                                Text(bookSelect),
                              ],
                            ),
                          ),
                        )
                      : ListTile(
                          onTap: () async =>
                              await selectBook(bookService, context),
                          leading: Image.network(
                              '${bookService.bookReportList[widget.index].thumbnail}',
                              fit: BoxFit.fitHeight),
                          title: Text(
                              '${bookService.bookReportList[widget.index].bookTitle}'),
                          subtitle: Text(
                              '저자 : ${bookService.bookReportList[widget.index].authors!.join(", ")}'),
                        ),
                ),
                Divider(),
                Container(
                  height: 40,
                  margin: EdgeInsets.all(5),
                  child: Row(children: <Widget>[
                    OutlinedButton(
                      style: ButtonStyle(
                        maximumSize:
                            MaterialStateProperty.all<Size>(Size(120, 40)),
                        overlayColor:
                            MaterialStateProperty.all<Color>(overlayColor),
                      ),
                      onPressed: () async {
                        startDate = await showCalenderPickerDialog(
                            context, bookReadStartDate, startDate);
                        setStartDate(startDate);
                        bookReport.startDate =
                            startDate.first!.toIso8601String();
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child:
                                Text(bookReadStartDate, style: textLabelStyle),
                          ),
                          SizedBox(height: 5),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              startDate[0].toString().substring(0, 10),
                              maxLines: 1,
                              style: textStyleFocus15,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(padding: EdgeInsets.all(5), child: Text("~")),
                    OutlinedButton(
                      style: ButtonStyle(
                        maximumSize:
                            MaterialStateProperty.all<Size>(Size(120, 40)),
                        overlayColor:
                            MaterialStateProperty.all<Color>(overlayColor),
                      ),
                      onPressed: () async {
                        endDate = await showCalenderPickerDialog(
                            context, bookReadEndDate, endDate);
                        setEndDate(endDate);
                        bookReport.endDate = endDate.first!.toIso8601String();
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(bookReadEndDate, style: textLabelStyle),
                          ),
                          SizedBox(height: 5),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              endDate[0].toString().substring(0, 10),
                              maxLines: 1,
                              style: textStyleFocus15,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                      ),
                    ),
                    Container(
                      width: 120,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.amber),
                          borderRadius: BorderRadius.circular(5)),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              bookStarRate,
                              style: textLabelStyle,
                            ),
                          ),
                          RatingBar.builder(
                            initialRating: 0,
                            minRating: 1,
                            allowHalfRating: true,
                            unratedColor: Colors.amber.withAlpha(50),
                            itemCount: 5,
                            itemSize: iconSize20,
                            glow: false,
                            itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              starVal = rating;
                              bookReport.stars = starVal;
                            },
                            updateOnDrag: true,
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                  child: TextField(
                    textInputAction: TextInputAction.done,
                    maxLines: 1,
                    maxLength: 50,
                    decoration: InputDecoration(
                      hintText: insertReportTitle,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      reportTitle = value;
                      bookReport.title = reportTitle;
                    },
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                    child: TextField(
                      textAlignVertical: TextAlignVertical.top,
                      controller: contentController,
                      decoration: InputDecoration(
                          hintText: insertReportContent,
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)))),
                      textInputAction: TextInputAction.done,
                      minLines: 5,
                      maxLines: null,
                      maxLength: 500,
                      keyboardType: TextInputType.multiline,
                      onChanged: (value) {
                        reportContent = value;
                        bookReport.content = reportContent;
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> selectBook(BookService bookService, BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SearchPage(pageOption: true)),
    );
    if (bookService.bookSelectList.isNotEmpty) {
      setState(
        () {
          bookService.bookReportList[widget.index].id =
              bookService.bookSelectList.last.id;
          bookService.bookReportList[widget.index].bookTitle =
              bookService.bookSelectList.last.title;
          bookService.bookReportList[widget.index].thumbnail =
              bookService.bookSelectList.last.thumbnail;
          bookService.bookReportList[widget.index].authors =
              bookService.bookSelectList.last.authors;
        },
      );
    }
  }

  backPressed(BookService bookService) {
    bookService.deleteBookReport(index: widget.index);
    Navigator.pop(context);
  }
}
