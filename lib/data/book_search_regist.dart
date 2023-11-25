class BookSearchRegist {
  String searchText; // 검색어

  BookSearchRegist({
    required this.searchText,
  });

  Map toJson() {
    return {
      'searchText': searchText,
    };
  }

  factory BookSearchRegist.fromJson(json) {
    return BookSearchRegist(
      searchText: json['searchText'],
    );
  }
}
