class BookMetaData {
  //Meta value
  bool isEnd; //현재 페이지가 마지막 페이지인지 여부, 값이 false면 page를 증가시켜 다음 페이지를 요청할 수 있음
  int totalCount; //검색된 문서 수
  int pageableCount; //중복된 문서를 제외하고, 처음부터 요청 페이지까지의 노출 가능 문서 수

  BookMetaData({
    required this.isEnd,
    required this.totalCount,
    required this.pageableCount,
  });
}
