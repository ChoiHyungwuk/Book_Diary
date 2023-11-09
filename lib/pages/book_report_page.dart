import 'package:flutter/material.dart';

import '../res/strings.dart';

class BookReportPage extends StatefulWidget {
  BookReportPage({super.key});
  @override
  State<StatefulWidget> createState() => _BookReportPage();
}

class _BookReportPage extends State<BookReportPage> {
  final ButtonStyle style =
      ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 10));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                style: style,
                onPressed: () {},
                child: Row(children: [
                  Icon(Icons.list),
                  Text(bookReportListView),
                ]),
              ),
              SizedBox(
                width: 5,
              ),
              ElevatedButton(
                style: style,
                onPressed: () {},
                child: Row(children: [
                  Icon(Icons.grid_view_rounded),
                  Text(bookReportAlbumView),
                ]),
              ),
            ],
          ),
          Divider(),
          Expanded(
            child: ListView.separated(
              itemCount: 1,
              separatorBuilder: (BuildContext context, int index) {
                return Divider();
              },
              itemBuilder: (BuildContext context, int index) {
                return null;
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Column(children: [
          Icon(Icons.add_box_outlined),
          Text(addReport),
        ]),
      ),
    );
  }
}
