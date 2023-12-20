import 'package:flutter/material.dart';
import 'package:flutter_project_book_search/res/colors.dart';
import 'package:flutter_project_book_search/res/values.dart';

//AppBar
TextStyle appBarTitleStyle = TextStyle(
    fontSize: appBarTitleFontSize,
    color: textTitleColor,
    fontWeight: FontWeight.bold);

//AppIntro
TextStyle appIntroTitleStyle = TextStyle(
    fontSize: textSize20, color: appBasicColor, fontWeight: FontWeight.bold);

TextStyle appIntroSubTextStyle =
    TextStyle(fontSize: textSize20, color: overlayColor);

//Text
TextStyle textLabelStyle =
    TextStyle(fontSize: textLabelSize12, color: blackColor);

TextStyle textStyleGrey13 = TextStyle(fontSize: textSize13, color: greyColor);

TextStyle textStyleBlack14 = TextStyle(fontSize: textSize14, color: blackColor);

TextStyle textStyleBlack15 =
    TextStyle(fontSize: textBasicSize15, color: blackColor);
TextStyle textStyleWhite15 =
    TextStyle(fontSize: textBasicSize15, color: whiteColor);
TextStyle textStyleGrey15 =
    TextStyle(fontSize: textBasicSize15, color: greyColor);
TextStyle textStyleHighlight15 = TextStyle(
    fontSize: textBasicSize15,
    color: appBasicColor,
    fontWeight: FontWeight.bold);
TextStyle textStyleFocus15 =
    TextStyle(fontSize: textBasicSize15, color: textFocusColor);

TextStyle textStyleBlack18 = TextStyle(fontSize: textSize18, color: blackColor);

TextStyle textStyleBlack20 = TextStyle(fontSize: textSize20, color: blackColor);

//Dialog
TextStyle dialogOkStyle =
    TextStyle(fontSize: textBasicSize15, color: appBasicColor);
TextStyle dialogNoStyle =
    TextStyle(fontSize: textBasicSize15, color: blackColor);

//Button Border
MaterialStateProperty<BorderSide> focusButtonBorder = MaterialStateProperty.all(
  BorderSide(width: 3, color: appBasicColor),
);
MaterialStateProperty<BorderSide> outFocusButtonBorder =
    MaterialStateProperty.all(
  BorderSide(width: 1, color: greyColor),
);
