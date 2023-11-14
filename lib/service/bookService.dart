import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_book_search/data/book_report.dart';

import '../data/book.dart';
import '../main.dart';

class BookService extends ChangeNotifier {
  //좋아요 체크한 책 목록 불러오기
  BookService() {
    loadlikedBookList();
    loadBookReportList();
  }

  List<Book> bookList = []; // 책 목록
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

  void search(String q, int maxResults, List<Book> list) async {
    list.clear(); // 검색 버튼 누를때 이전 데이터들을 지워주기

    if (q.isNotEmpty) {
      Response res = await Dio().get(
        "https://www.googleapis.com/books/v1/volumes?q=$q&startIndex=0&maxResults=$maxResults",
      );
      List items = res.data["items"];

      for (Map<String, dynamic> item in items) {
        Book book = Book(
          id: item['id'],
          title: item['volumeInfo']['title'] ?? "",
          authors: (item['volumeInfo']['authors'] ?? []) as List,
          publishedDate: item['volumeInfo']['publishedDate'] ?? "",
          thumbnail: item['volumeInfo']['imageLinks']?['thumbnail'] ??
              "https://img.freepik.com/premium-vector/default-image-icon-vector-missing-picture-page-for-website-design-or-mobile-app-no-photo-available_87543-11093.jpg",
          previewLink: item['volumeInfo']['previewLink'] ?? "",
        );
        list.add(book);
      }
    }
    notifyListeners();
  }

  //좋아요 페이지 리스트
  savelikedBookList() {
    List BookJsonList = likedBookList.map((Book) => Book.toJson()).toList();

    String jsonString = jsonEncode(BookJsonList);

    prefs.setString('likedBookList', jsonString);
  }

  loadlikedBookList() {
    String? jsonString = prefs.getString('likedBookList');

    if (jsonString == null) return;

    List BookJsonList = jsonDecode(jsonString);

    likedBookList = BookJsonList.map((json) => Book.fromJson(json)).toList();
  }

  //독후감 페이지 리스트
  saveBookReportList() {
    List BookJsonList =
        bookReportList.map((BookReport) => BookReport.toJson()).toList();

    String jsonString = jsonEncode(BookJsonList);

    prefs.setString('bookReportList', jsonString);
  }

  loadBookReportList() {
    String? jsonString = prefs.getString('bookReportList');

    if (jsonString == null) return;

    List BookJsonList = jsonDecode(jsonString);

    bookReportList =
        BookJsonList.map((json) => BookReport.fromJson(json)).toList();
  }

  createInitReport({required DateTime editDay}) {
    BookReport report = BookReport(editDay: editDay);
    bookReportList.add(report);
    saveBookReportList();
  }

  createBookReport({required DateTime editDay}) {
    BookReport report = BookReport(editDay: editDay);
    bookReportList.add(report);
    notifyListeners();
    saveBookReportList();
  }

  updateBookReport({required int index, DateTime? editDay}) {
    BookReport report = bookReportList[index];
    report.editDay = editDay ?? DateTime.now();
    report.startDate = report.startDate ?? DateTime.now().toIso8601String();
    report.endDate = report.endDate ?? DateTime.now().toIso8601String();
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
        index = 0;
      }
    }
    notifyListeners();
    saveBookReportList();
  }
}
