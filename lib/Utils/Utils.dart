import 'package:flutter/material.dart';
import 'package:flutter_project_book_search/res/colors.dart';
import 'package:flutter_project_book_search/res/style.dart';
import 'package:flutter_project_book_search/res/values.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast(FToast fToast, String msg, int duration) {
  Widget toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: overlayColor,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.error_outline, size: iconBasicSize30),
        SizedBox(
          width: 12.0,
        ),
        Text(msg, style: textStyleBlack15),
      ],
    ),
  );

  fToast.showToast(
    child: toast,
    gravity: ToastGravity.BOTTOM,
    toastDuration: Duration(seconds: duration),
  );

  // Custom Toast Position
  // fToast.showToast(
  //   child: toast,
  //   toastDuration: Duration(seconds: 2),
  //   positionedToastBuilder: (context, child) {
  //     return Positioned(
  //       child: child,
  //       top: 16.0,
  //       left: 16.0,
  //     );
  //   },
  // );
}

double setWidthSize(context, double val) {
  return MediaQuery.of(context).size.width * val;
}

double setHeightSize(context, double val) {
  return MediaQuery.of(context).size.height * val;
}
