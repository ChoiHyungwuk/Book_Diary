import 'package:flutter/material.dart';
import 'package:flutter_project_book_search/service/bookService.dart';
import 'package:flutter_project_book_search/widget/dialog.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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

  void setStartDate(date) {
    setState(() {
      startDate = date;
      if (startDate[0]!.microsecondsSinceEpoch >
          endDate[0]!.microsecondsSinceEpoch) {
        endDate = date; //종료일보다 값이 높을 경우 동일 시간값으로 설정
      }
    });
  }

  void setEndDate(date) {
    setState(() {
      endDate = date;
      if (startDate[0]!.microsecondsSinceEpoch >
          endDate[0]!.microsecondsSinceEpoch) {
        startDate = date; //시작일보다 값이 높을 경우 동일 시간값으로 설정
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    BookService bookService = context.read<BookService>();
    BookReport bookReport = bookService.UserbookReportList[widget.index];

    // contentController.text = memo.content;

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
      child: Scaffold(
        resizeToAvoidBottomInset: false, //화면 밀림방지
        appBar: AppBar(
          leading: IconButton(
              onPressed: () async {
                if (await show(context, bookReportBackPressed)) {
                  backPressed(bookService);
                }
              },
              icon: Icon(Icons.arrow_back_sharp)),
          actions: [
            TextButton(
                onPressed: () => {
                      Navigator.pop(context),
                    },
                child: Text(
                  "저장",
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
        body: Column(
          children: [
            Container(
              child: bookReport.id == null
                  ? Center(
                      child: ElevatedButton(
                          onPressed: () {},
                          child: Row(
                            children: [
                              Icon(Icons.add_circle),
                              Text("책 선택하기"),
                            ],
                          )),
                    )
                  : ListTile(
                      leading: Image.network(
                          "https://img.freepik.com/premium-vector/default-image-icon-vector-missing-picture-page-for-website-design-or-mobile-app-no-photo-available_87543-11093.jpg",
                          fit: BoxFit.fitHeight),
                      title: Text(''),
                      subtitle: Text(''),
                    ),
            ),
            Divider(),
            Row(children: <Widget>[
              TextButton(
                onPressed: () async {
                  startDate = await showCalenderPickerDialog(
                      context, bookReadStartDate, startDate);
                  setStartDate(startDate);
                },
                child: Column(
                  children: [
                    Text(bookReadStartDate),
                    Text(startDate[0].toString().substring(0, 10)),
                  ],
                ),
              ),
              SizedBox(child: Text("~")),
              TextButton(
                onPressed: () async {
                  endDate = await showCalenderPickerDialog(
                      context, bookReadEndDate, endDate);
                  setEndDate(endDate);
                },
                child: Column(
                  children: [
                    Text(bookReadEndDate),
                    Text(endDate[0].toString().substring(0, 10)),
                  ],
                ),
              ),
              Expanded(
                child: SizedBox(
                  width: double.infinity,
                ),
              ),
              Container(
                decoration: BoxDecoration(border: Border.all()),
                child: RatingBar.builder(
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
                  },
                  updateOnDrag: true,
                ),
              ),
            ]),
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
                          borderRadius: BorderRadius.all(Radius.circular(5)))),
                  maxLines: null,
                  expands: true,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.multiline,
                  onChanged: (value) {
                    reportContent = value;
                    // memoService.updateMemo(index: index, content: value);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  backPressed(BookService bookService) {
    bookService.deleteBookReport(index: widget.index);
    Navigator.pop(context);
  }
}
