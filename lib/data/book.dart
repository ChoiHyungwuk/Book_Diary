class Book {
  String id;
  String title;
  // String subtitle;
  String thumbnail; // 썸네일 이미지 링크
  String previewLink; // ListTile 을 눌렀을 때 이동하는 링크

  List authors; //글쓴이
  String publishedDate; //출간일

  Book({
    required this.id,
    required this.title,
    // required this.subtitle,
    required this.thumbnail,
    required this.previewLink,
    required this.authors,
    required this.publishedDate,
  });

  Map toJson() {
    return {
      'id': id,
      'title': title,
      'thumbnail': thumbnail,
      'previewLink': previewLink,
      'authors': authors,
      'publishedDate': publishedDate
    };
  }

  factory Book.fromJson(json) {
    return Book(
      id: json['id'],
      title: json['title'],
      thumbnail: json['thumbnail'],
      previewLink: json['previewLink'],
      authors: json['authors'],
      publishedDate: json['publishedDate'],
    );
  }
}
