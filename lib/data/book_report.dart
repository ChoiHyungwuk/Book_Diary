class BookReport {
  DateTime editDay; //독후감 작성일 <- 필터 기능 생성 시 이용
  String? id; //책 id
  String? bookTitle; //책 제목
  String? thumbnail; // 썸네일 이미지 링크
  List? authors; //글쓴이
  double? stars; //별점
  String? startDate; //독서 시작일
  String? endDate; //독서 종료일
  String? title; //독후감 제목
  String? content; //독후감 내용

  BookReport({
    required this.editDay,
    this.id,
    this.bookTitle,
    this.thumbnail,
    this.authors,
    this.stars,
    this.startDate,
    this.endDate,
    this.title,
    this.content,
  });

  Map toJson() {
    return {
      'editDay': editDay.toIso8601String(),
      'id': id,
      'bookTitle': bookTitle,
      'thumbnail': thumbnail,
      'authors': authors,
      'stars': stars,
      'startDate': startDate,
      'endDate': endDate,
      'title': title,
      'content': content
    };
  }

  factory BookReport.fromJson(json) {
    return BookReport(
      editDay: DateTime.parse(json['editDay']),
      id: json['id'],
      bookTitle: json['bookTitle'],
      thumbnail: json['thumbnail'],
      authors: json['authors'],
      stars: json['stars'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      title: json['title'],
      content: json['content'],
    );
  }
}
