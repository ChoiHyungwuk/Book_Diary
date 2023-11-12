import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_book_search/service/bookService.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../res/strings.dart';
import '../widget/calender_picker_dialog.dart';

class BookReportEditPage extends StatefulWidget {
  BookReportEditPage({
    super.key,
    required this.index,
    title,
    author,
  });

  final int index;

  @override
  State<BookReportEditPage> createState() => _BookReportEditPageState();
}

class _BookReportEditPageState extends State<BookReportEditPage> {
  List<DateTime?> startDate = [DateTime.now()];
  List<DateTime?> endDate = [DateTime.now()];

  TextEditingController contentController = TextEditingController();

  void setStartDate(date) {
    setState(() {
      startDate = date;
    });
  }

  void setEndDate(date) {
    setState(() {
      endDate = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    // MemoService memoService = context.read<MemoService>();
    // Memo memo = memoService.memoList[index];

    // contentController.text = memo.content;

    // DateTime _dates;

    return Consumer<BookService>(
      builder: (context, bookService, child) {
        return Scaffold(
          resizeToAvoidBottomInset: false, //화면 밀림방지
          appBar: AppBar(
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
                child: ListTile(
                  leading: Image.network(
                      "https://img.freepik.com/premium-vector/default-image-icon-vector-missing-picture-page-for-website-design-or-mobile-app-no-photo-available_87543-11093.jpg",
                      fit: BoxFit.fitHeight),
                  title: Text("제목"),
                  subtitle: Text("작가명"),
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
                    onRatingUpdate: (rating) {},
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
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                  child: TextField(
                    textAlignVertical: TextAlignVertical.top,
                    controller: contentController,
                    decoration: InputDecoration(
                        hintText: "메모를 입력하세요",
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5)))),
                    maxLines: null,
                    expands: true,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.multiline,
                    onChanged: (value) {
                      // 텍스트필드 안의 값이 변할 때
                      // memoService.updateMemo(index: index, content: value);
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
