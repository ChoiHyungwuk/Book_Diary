import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_project_book_search/pages/book_report_page.dart';
import 'package:flutter_project_book_search/res/colors.dart';
import 'package:flutter_project_book_search/res/values.dart';
import 'package:flutter_project_book_search/utils/utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  DateTime? backPressedTime;
  late FToast fToast;

  @override
  void initState() {
    super.initState();
    fToast = FToast(); //토스트 메시지 초기화
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) {
          DateTime nowTime = DateTime.now();
          if (didPop == false &&
              (backPressedTime == null ||
                  nowTime.difference(backPressedTime!) >
                      Duration(seconds: 2))) {
            backPressedTime = nowTime;
            showToast(fToast, backPressForExit, 2);
          } else {
            SystemNavigator.pop();
          }
        },
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
      ),
    );
  }
}
