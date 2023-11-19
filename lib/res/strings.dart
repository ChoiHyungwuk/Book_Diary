String searchOptionStr = "표시 개수";
String searchHint = "검색어를 입력해주세요";

String bookReport = "독후감";
String liked = "좋아요";
String searchBooks = "책 검색";
String backPress = "뒤로가기";

String select = "선택";
String cancel = "취소";
String ok = "확인";
String modify = "수정";
String delete = "삭제";
String editDay = "작성일";

//book Report Page Use
String addReport = "새 독후감";

String insertReportTitle = "제목을 입력해주세요";
String insertReportContent = "내용을 입력해주세요";
String insertReportBook = "책을 선택해주세요";
String insertReportstars = "별점을 입력해주세요";

String bookReportListView = "리스트형 보기";
String bookReportAlbumView = "앨범형 보기";
String bookReportBackPressed = "저장되지 않은 정보는 삭제됩니다\n정말 뒤로 가시겠습니까?";
String bookReportSave = "저장";
String bookReportMissingElement = "입력하지 않은 값이 있습니다";
String bookReportDelete = "삭제하시겠습니까?";

String bookReadStartDate = "독서 시작일";
String bookReadEndDate = "독서 완료일";

String bookSelect = "도서 선택하기";
String bookStarRate = "별점";
//book Report Page Use

enum ViewCounts {
  a('10', 10),
  b('20', 20),
  c('30', 30),
  d('40', 40);

  const ViewCounts(this.label, this.val);
  final String label;
  final int val;
}
