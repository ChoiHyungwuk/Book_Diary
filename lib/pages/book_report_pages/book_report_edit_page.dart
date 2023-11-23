import 'package:flutter/material.dart';
import 'package:flutter_project_book_search/data/book.dart';
import 'package:flutter_project_book_search/utils/utils.dart';
import 'package:flutter_project_book_search/pages/book_search.dart';
import 'package:flutter_project_book_search/res/colors.dart';
import 'package:flutter_project_book_search/res/style.dart';
import 'package:flutter_project_book_search/res/values.dart';
import 'package:flutter_project_book_search/service/book_service.dart';
import 'package:flutter_project_book_search/widget/dialog/dialog.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../data/book_report.dart';
import '../../res/strings.dart';
import '../../widget/dialog/calender_picker_dialog.dart';

class BookReportEditPage extends StatefulWidget {
  const BookReportEditPage({
    super.key,
    required this.index,
    this.book,
    this.editOption,
  });

  final int index;
  final Book? book;
  final bool? editOption; // true = 수정, false = 신규작성

  @override
  State<BookReportEditPage> createState() => _BookReportEditPageState();
}

class _BookReportEditPageState extends State<BookReportEditPage> {
  List<DateTime?> startDate = [DateTime.now()]; //독서 시작일
  List<DateTime?> endDate = [DateTime.now()]; //독서 종료일
  String? bookId; //책 고유ID
  String? bookTitle; //책 이름
  String? bookThumbnail; //책 썸네일
  List? authors; //저자
  double? starVal; //별점
  String? reportTitle; //독후감 제목
  String? reportContent; //독후감 내용

  late FToast fToast;

  TextEditingController contentController = TextEditingController();
  TextEditingController titleController = TextEditingController();

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

    initValues(bookReport, titleController, contentController);

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop == false &&
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
                    if (bookId == null || bookId == '') {
                      showToast(fToast, insertReportBook, 2);
                    } else if (starVal == null || starVal == 0.0) {
                      showToast(fToast, insertReportstars, 2);
                    } else if (reportTitle == null || reportTitle == '') {
                      showToast(fToast, insertReportTitle, 2);
                    } else if (reportContent == null || reportContent == '') {
                      showToast(fToast, insertReportContent, 2);
                    } else {
                      bookService.updateBookReport(
                          index: widget.index,
                          id: bookId!,
                          bookTitle: bookTitle!,
                          thumbnail: bookThumbnail!,
                          authors: authors!,
                          stars: starVal!,
                          startDate: startDate.first!.toIso8601String(),
                          endDate: endDate.first!.toIso8601String(),
                          title: reportTitle!,
                          content: reportContent!);
                      Navigator.pop(context);
                    }
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
            body: Container(
              padding: bodyPadding,
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 80,
                    alignment: Alignment.center,
                    child: bookId == null
                        ? ElevatedButton(
                            onPressed: () async {
                              bookService.bookSelectList.clear(); //검색목록 초기화
                              await selectBook(bookService, context);
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  appBasicColor),
                              overlayColor: MaterialStateProperty.all<Color>(
                                  overlayColor),
                              shadowColor: MaterialStateProperty.all<Color>(
                                  overlayColor),
                            ),
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.add_circle,
                                    size: iconBasicSize30,
                                    color: whiteColor,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    bookSelect,
                                    style: textStyleWhite15,
                                  ),
                                ],
                              ),
                            ),
                          )
                        : ListTile(
                            onTap: () async =>
                                await selectBook(bookService, context),
                            leading: Image.network('$bookThumbnail',
                                fit: BoxFit.fitHeight),
                            title: Text(
                              '$bookTitle',
                              style: textStyleBlack15,
                            ),
                            subtitle: Text(
                              '저자 : ${authors!.join(", ")}',
                              style: textStyleGrey13,
                            ),
                          ),
                  ),
                  Divider(),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: <Widget>[
                        OutlinedButton(
                          style: ButtonStyle(
                            alignment: Alignment.center,
                            overlayColor:
                                MaterialStateProperty.all<Color>(overlayColor),
                          ),
                          onPressed: () async {
                            startDate = await showCalenderPickerDialog(
                                context, bookReadStartDate, startDate);
                            setStartDate(startDate);
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                bookReadStartDate,
                                style: textLabelStyle,
                              ),
                              Text(
                                startDate[0].toString().substring(0, 10),
                                maxLines: 1,
                                style: textStyleFocus15,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(5),
                          child: Text("~"),
                        ),
                        OutlinedButton(
                          style: ButtonStyle(
                            alignment: Alignment.center,
                            overlayColor:
                                MaterialStateProperty.all<Color>(overlayColor),
                          ),
                          onPressed: () async {
                            endDate = await showCalenderPickerDialog(
                                context, bookReadEndDate, endDate);
                            setEndDate(endDate);
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                bookReadEndDate,
                                style: textLabelStyle,
                              ),
                              Text(
                                endDate[0].toString().substring(0, 10),
                                maxLines: 1,
                                style: textStyleFocus15,
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
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.amber),
                              borderRadius: BorderRadius.circular(5)),
                          child: Column(
                            children: [
                              Text(
                                bookStarRate,
                                style: textLabelStyle,
                              ),
                              RatingBar.builder(
                                initialRating: bookReport.stars ?? 0,
                                minRating: 1,
                                allowHalfRating: true,
                                unratedColor: Colors.amber.withAlpha(50),
                                itemCount: 5,
                                itemSize: iconSize20,
                                glow: false,
                                itemPadding:
                                    EdgeInsets.symmetric(horizontal: 0.0),
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (rating) {
                                  starVal = rating;
                                },
                                updateOnDrag: true,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextField(
                    controller: titleController,
                    textInputAction: TextInputAction.next,
                    maxLines: 1,
                    maxLength: 50,
                    decoration: InputDecoration(
                      hintText: insertReportTitle,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      focusedBorder: focusBorderColor,
                    ),
                    onChanged: (value) {
                      reportTitle = value;
                    },
                  ),
                  Expanded(
                    child: Scrollbar(
                      child: SingleChildScrollView(
                        child: TextField(
                          textAlignVertical: TextAlignVertical.top,
                          controller: contentController,
                          decoration: InputDecoration(
                            hintText: insertReportContent,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                            focusedBorder: focusBorderColor,
                          ),
                          textInputAction: TextInputAction.newline,
                          minLines: 5,
                          maxLines: null,
                          maxLength: 500,
                          keyboardType: TextInputType.multiline,
                          onChanged: (value) {
                            reportContent = value;
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> selectBook(BookService bookService, BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchPage(pageOption: true),
      ),
    );
    if (bookService.bookSelectList.isNotEmpty) {
      setState(
        () {
          bookId = bookService.bookSelectList.last.id;
          bookTitle = bookService.bookSelectList.last.title;
          bookThumbnail = bookService.bookSelectList.last.thumbnail;
          authors = bookService.bookSelectList.last.authors;
        },
      );
    }
  }

  backPressed(BookService bookService) {
    Navigator.pop(context);
    if (widget.editOption ?? true) {
      bookService.deleteBookReport(index: widget.index);
    }
  }

  initValues(BookReport list, TextEditingController title,
      TextEditingController content) {
    if (widget.editOption ?? false) {
      startDate = [DateTime.parse(list.startDate!)];
      endDate = [DateTime.parse(list.endDate!)];
      bookId = list.id;
      bookTitle = list.bookTitle;
      bookThumbnail = list.thumbnail;
      authors = list.authors;
      starVal = list.stars;
      title.text = list.title ?? '';
      content.text = list.content ?? '';
      reportTitle = list.title ?? '';
      reportContent = list.content ?? '';
    }
  }
}
