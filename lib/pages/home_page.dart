import 'package:flutter/material.dart';
import 'package:flutter_project_book_search/pages/book_report_page.dart';
import 'package:flutter_project_book_search/res/colors.dart';
import 'package:flutter_project_book_search/res/values.dart';
import '../res/strings.dart';
import 'book_liked_page.dart';
import 'book_search.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var bottomNavIndex = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: [
          BookReportPage(),
          SearchPage(pageOption: false),
          LikedBookPage(),
        ].elementAt(bottomNavIndex),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: appBasicColor,
          unselectedItemColor: greyColor,
          showUnselectedLabels: false,
          selectedFontSize: bottomBarFontSize,
          iconSize: iconBasicSize30,
          unselectedIconTheme: IconThemeData(size: iconMinSize25),
          type: BottomNavigationBarType.fixed,
          onTap: (value) {
            setState(() {
              bottomNavIndex = value;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.edit_document),
              label: bookReport,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: searchBooks,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.star),
              label: liked,
            ),
          ],
          currentIndex: bottomNavIndex,
        ),
      ),
    );
  }
}
