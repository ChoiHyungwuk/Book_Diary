import 'package:flutter/material.dart';
import 'package:flutter_project_book_search/pages/book_report_page.dart';

import '../res/strings.dart';
import 'book_liked_page.dart';
import 'book_search.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var bottomNavIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: [
        SearchPage(),
        BookReportPage(),
        LikedBookPage(),
      ].elementAt(bottomNavIndex)),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        iconSize: 28,
        type: BottomNavigationBarType.fixed,
        onTap: (value) {
          setState(() {
            bottomNavIndex = value;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: searchBooks,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_note_rounded),
            label: bookReport,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: liked,
          ),
        ],
        currentIndex: bottomNavIndex,
      ),
    );
  }
}
