import 'package:flutter/material.dart';
import 'package:flutter_project_book_search/pages/home_page.dart';
import 'package:flutter_project_book_search/res/colors.dart';
import 'package:flutter_project_book_search/res/strings.dart';
import 'package:flutter_project_book_search/res/style.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(
      Duration(seconds: 2),
      () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      },
    );

    return Scaffold(
      backgroundColor: whiteColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('lib/res/image/logo.png'),
              fit: BoxFit.contain,
              width: 200,
            ),
            SizedBox(height: 20),
            Text(
              appIntro,
              style: appIntroSubTextStyle,
            ),
            Text(
              appSubName,
              style: appIntroTitleStyle,
            ),
          ],
        ),
      ),
    );
  }
}
