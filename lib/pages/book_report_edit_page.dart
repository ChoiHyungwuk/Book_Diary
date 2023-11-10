import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class BookReportEditPage extends StatelessWidget {
  BookReportEditPage({super.key, required this.index});

  final int index;

  TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // MemoService memoService = context.read<MemoService>();
    // Memo memo = memoService.memoList[index];

    // contentController.text = memo.content;

    return Scaffold(
      // appBar: AppBar(
      //   actions: [
      //     IconButton(
      //       onPressed: () {
      //         // 삭제 버튼 클릭시
      //         // showDeleteDialog(context);
      //       },
      //       icon: Icon(Icons.delete),
      //     )
      //   ],
      // ),
      body: SafeArea(
        child: Column(
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
            Container(
              decoration: BoxDecoration(border: Border.all()),
              child: RatingBar.builder(
                initialRating: 3,
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
            Expanded(
              child: TextField(
                controller: contentController,
                decoration: InputDecoration(
                  hintText: "메모를 입력하세요",
                  border: InputBorder.none,
                ),
                autofocus: true,
                maxLines: null,
                expands: true,
                keyboardType: TextInputType.multiline,
                onChanged: (value) {
                  // 텍스트필드 안의 값이 변할 때
                  // memoService.updateMemo(index: index, content: value);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
