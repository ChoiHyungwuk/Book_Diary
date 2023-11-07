import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../constant/book.dart';
import '../main.dart';

class BookService extends ChangeNotifier {
  //좋아요 체크한 책 목록 불러오기
  BookService() {
    loadlikedBookList();
  }

  List<Book> bookList = []; // 책 목록
  List<Book> likedBookList = []; //좋아요 한 책 목

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

  void search(String q) async {
    bookList.clear(); // 검색 버튼 누를때 이전 데이터들을 지워주기

    if (q.isNotEmpty) {
      Response res = await Dio().get(
        "https://www.googleapis.com/books/v1/volumes?q=$q&startIndex=0&maxResults=40",
      );
      List items = res.data["items"];

      for (Map<String, dynamic> item in items) {
        Book book = Book(
          id: item['id'],
          title: item['volumeInfo']['title'] ?? "",
          // subtitle: item['volumeInfo']['subtitle'] ?? "",
          authors: (item['volumeInfo']['authors'] ?? []) as List,
          publishedDate: item['volumeInfo']['publishedDate'] ?? "",
          thumbnail: item['volumeInfo']['imageLinks']?['thumbnail'] ??
              "https://thumbs.dreamstime.com/b/no-image-available-icon-flat-vector-no-image-available-icon-flat-vector-illustration-132482953.jpg",
          previewLink: item['volumeInfo']['previewLink'] ?? "",
        );
        bookList.add(book);
      }
    }
    notifyListeners();
  }

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
}
