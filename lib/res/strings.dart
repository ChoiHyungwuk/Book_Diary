String searchOptionStr = "표시 개수";
String searchHint = "검색어를 입력 해주세요";

enum viewCounts {
  a('10', 10),
  b('20', 20),
  c('30', 30),
  d('40', 40);

  const viewCounts(this.label, this.val);
  final String label;
  final int val;
}
