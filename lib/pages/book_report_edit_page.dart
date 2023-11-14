import 'package:flutter/material.dart';
import 'package:flutter_project_book_search/pages/book_search.dart';
import 'package:flutter_project_book_search/res/values.dart';
import 'package:flutter_project_book_search/service/bookService.dart';
import 'package:flutter_project_book_search/widget/dialog.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:provider/provider.dart';

import '../data/book_report.dart';
import '../res/strings.dart';
import '../widget/calender_picker_dialog.dart';

class BookReportEditPage extends StatefulWidget {
  BookReportEditPage({
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

  TextEditingController contentController = TextEditingController();

  var test;

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
  Widget build(BuildContext context) {
    BookService bookService = context.read<BookService>();
    BookReport bookReport = bookService.bookReportList[widget.index];

    return WillPopScope(
      onWillPop: () {
        return Future(
          () async {
            if (await show(context, bookReportBackPressed)) {
              backPressed(bookService);
            }
            return false;
          },
        );
      },
      child: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus(); //화면 다른 부분이 터치 되었을 때 키보드 내리게하기
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false, //화면 밀림방지
            appBar: AppBar(
              toolbarHeight: toolbarHeight,
              leading: IconButton(
                  onPressed: () async {
                    if (await show(context, bookReportBackPressed)) {
                      backPressed(bookService);
                    }
                  },
                  icon: Icon(Icons.arrow_back_sharp)),
              actions: [
                TextButton(
                    onPressed: () {
                      if (bookReport.id == null || bookReport.id == '') {
                        toastMsgWarning("도서를 선택해주세요").show(context);
                      } else if (bookReport.stars == null ||
                          bookReport.stars == 0.0) {
                        toastMsgWarning("별점을 입력해주세요").show(context);
                      } else if (bookReport.title == null ||
                          bookReport.title == '') {
                        toastMsgWarning("제목을 입력해주세요").show(context);
                      } else if (bookReport.content == null ||
                          bookReport.content == '') {
                        toastMsgWarning("내용을 입력해주세요").show(context);
                      } else {
                        bookService.updateBookReport(
                            index: widget.index, editDay: DateTime.now());
                        Navigator.pop(context);
                      }
                      print(
                          '1 : ${bookReport.id} 2 : ${bookReport.stars} 3 : ${bookReport.title} 4 : ${bookReport.content}');
                    },
                    child: Text(
                      bookReportSave,
                      style: TextStyle(color: Colors.white),
                    ))
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
                              overlayColor: MaterialStateProperty.all<Color>(
                                  Colors.deepPurple)),
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
                              MaterialStateProperty.all<Size>(Size(120, 40))),
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
                            child: Text(bookReadStartDate,
                                style: TextStyle(
                                    fontSize: 11, color: Colors.black)),
                          ),
                          SizedBox(height: 5),
                          Align(
                            alignment: Alignment.centerLeft,
                            child:
                                Text(startDate[0].toString().substring(0, 10)),
                          ),
                        ],
                      ),
                    ),
                    Container(padding: EdgeInsets.all(5), child: Text("~")),
                    OutlinedButton(
                      style: ButtonStyle(
                          maximumSize:
                              MaterialStateProperty.all<Size>(Size(120, 40))),
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
                            child: Text(bookReadEndDate,
                                style: TextStyle(
                                    fontSize: 11, color: Colors.black)),
                          ),
                          SizedBox(height: 5),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(endDate[0].toString().substring(0, 10)),
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
                              style: TextStyle(fontSize: 11),
                            ),
                          ),
                          RatingBar.builder(
                            initialRating: 0,
                            minRating: 1,
                            allowHalfRating: true,
                            unratedColor: Colors.amber.withAlpha(50),
                            itemCount: 5,
                            itemSize: 20.0,
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
                    decoration: InputDecoration(
                      hintText: "제목을 입력하세요",
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
                          hintText: "내용을 입력하세요",
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)))),
                      maxLines: null,
                      expands: true,
                      textInputAction: TextInputAction.done,
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

  MotionToast toastMsgWarning(String descroption) {
    return MotionToast.warning(
        title: Text(bookReportMissingElement), description: Text(descroption));
  }

  Future<void> selectBook(BookService bookService, BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SearchPage(pageOption: true)),
    );
    setState(() {
      bookService.bookReportList[widget.index].id =
          bookService.bookSelectList.last.id;
      bookService.bookReportList[widget.index].bookTitle =
          bookService.bookSelectList.last.title;
      bookService.bookReportList[widget.index].thumbnail =
          bookService.bookSelectList.last.thumbnail;
      bookService.bookReportList[widget.index].authors =
          bookService.bookSelectList.last.authors;
    });
  }

  backPressed(BookService bookService) {
    bookService.deleteBookReport(index: widget.index);
    Navigator.pop(context);
  }
}
