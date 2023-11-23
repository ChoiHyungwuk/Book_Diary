import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_book_search/data/book_meta.dart';
import 'package:flutter_project_book_search/data/book_report.dart';
import 'package:flutter_project_book_search/res/apiKey.dart';

import '../data/book.dart';
import '../main.dart';

class BookService extends ChangeNotifier {
  //좋아요 체크한 책 목록 불러오기
  BookService() {
    loadlikedBookList();
    loadBookReportList();
    checkNullElement();
  }

  List<Book> bookList = []; // 책 목록
  List<BookMetaData> bookMetaData = []; // 카카오 book api 메타 데이터
  List<Book> likedBookList = []; //좋아요 한 책 목록
  List<Book> bookSelectList = []; //책 선택 리스트
  List<BookReport> bookReportList = []; //독후감 리스트

  void toggleLikeBook({required Book book}) {
    String bookId = book.id;
    if (likedBookList.map((book) => book.id).contains(bookId)) {
      likedBookList.removeWhere((book) => book.id == bookId);
    } else {
      likedBookList.add(book);
    }
    notifyListeners();
    savelikedBookList();
  }

  void searchBooks(String query, int maxResults, List<Book> list) async {
    list.clear(); // 검색 버튼 누를때 이전 데이터들을 지워주기
    bookMetaData.clear();

    if (query.isNotEmpty) {
      Response res = await Dio().get(
        "https://dapi.kakao.com/v3/search/book?query=$query",
        options: Options(
          headers: {
            'Authorization': kakaoAPIKey,
          },
        ),
      );
      List items = res.data["documents"];

      bookMetaData.add(
        BookMetaData(
          isEnd: res.data["meta"]['is_end'],
          totalCount: res.data["meta"]['total_count'],
          pageableCount: res.data["meta"]['pageable_count'],
        ),
      );

      for (Map<String, dynamic> item in items) {
        if (item['thumbnail'] != "") {
          //썸네일 이미지 없는 것은 리스트에서 제외
          Book book = Book(
            id: item['isbn'],
            title: item['title'] ?? '',
            authors: (item['authors'] ?? []) as List,
            publishedDate: item['datetime']?.toString().substring(0, 10) ?? '',
            contents: item['contents'] ?? '',
            thumbnail: item['thumbnail'],
            previewLink: item['url'] ?? '',
          );
          list.add(book);
        }
      }
    }
    notifyListeners();
  }

  //좋아요 페이지 리스트
  savelikedBookList() {
    List bookJsonList = likedBookList.map((book) => book.toJson()).toList();

    String jsonString = jsonEncode(bookJsonList);

    prefs.setString('likedBookList', jsonString);
  }

  loadlikedBookList() {
    String? jsonString = prefs.getString('likedBookList');

    if (jsonString == null) return;

    List bookJsonList = jsonDecode(jsonString);

    likedBookList = bookJsonList.map((json) => Book.fromJson(json)).toList();
  }

  //독후감 페이지 리스트
  saveBookReportList() {
    List bookJsonList =
        bookReportList.map((bookReport) => bookReport.toJson()).toList();

    String jsonString = jsonEncode(bookJsonList);

    prefs.setString('bookReportList', jsonString);
  }

  loadBookReportList() {
    String? jsonString = prefs.getString('bookReportList');

    if (jsonString == null) return;

    List bookJsonList = jsonDecode(jsonString);

    bookReportList =
        bookJsonList.map((json) => BookReport.fromJson(json)).toList();
  }

  createInitReport({required DateTime editDay}) {
    BookReport report = BookReport(editDay: editDay);
    bookReportList.add(report);
    saveBookReportList();
  }

  // createBookReport({required DateTime editDay}) {
  //   BookReport report = BookReport(editDay: editDay);
  //   bookReportList.add(report);
  //   notifyListeners();
  //   saveBookReportList();
  // }

  updateBookReport({
    required int index,
    required String id,
    required String bookTitle,
    required String thumbnail,
    required List authors,
    required double stars,
    required String startDate,
    required String endDate,
    required String title,
    required String content,
  }) {
    BookReport report = bookReportList[index];
    report.editDay = DateTime.now();
    report.id = id;
    report.bookTitle = bookTitle;
    report.thumbnail = thumbnail;
    report.authors = authors;
    report.stars = stars;
    report.startDate = startDate;
    report.endDate = endDate;
    report.title = title;
    report.content = content;
    notifyListeners();
    saveBookReportList();
  }

  deleteBookReport({required int index}) {
    bookReportList.removeAt(index);
    notifyListeners();
    saveBookReportList();
  }

  checkNullElement() {
    for (int index = 0; index < bookReportList.length; index++) {
      if (bookReportList[index].id == null ||
          bookReportList[index].bookTitle == null ||
          bookReportList[index].thumbnail == null ||
          bookReportList[index].authors == null ||
          bookReportList[index].stars == null ||
          bookReportList[index].startDate == null ||
          bookReportList[index].endDate == null ||
          bookReportList[index].title == null ||
          bookReportList[index].content == null) {
        bookReportList.removeAt(index);
        index = 0; //지우고 리스트 처음부터 순회
      }
    }
    notifyListeners();
    saveBookReportList();
  }
}
