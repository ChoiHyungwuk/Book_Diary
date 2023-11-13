String searchOptionStr = "표시 개수";
String searchHint = "검색어를 입력해주세요";

String bookReport = "독후감";
String liked = "좋아요";
String searchBooks = "책 검색";

//book Report Page Use
String bookReportListView = "리스트형 보기";
String bookReportAlbumView = "앨범형 보기";
String addReport = "새 독후감";
String bookReadStartDate = "독서 시작일";
String bookReadEndDate = "독서 완료일";
String bookReportBackPressed = "저장되지 않은 정보는 삭제됩니다.\n정말 뒤로 가시겠습니까?";

enum ViewCounts {
  a('10', 10),
  b('20', 20),
  c('30', 30),
  d('40', 40);

  const ViewCounts(this.label, this.val);
  final String label;
  final int val;
}
