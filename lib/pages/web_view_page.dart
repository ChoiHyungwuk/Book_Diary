import 'package:flutter/material.dart';
import 'package:flutter_project_book_search/res/strings.dart';
import 'package:webview_flutter/webview_flutter.dart';

// ignore: must_be_immutable
class WebViewPage extends StatelessWidget {
  WebViewPage({super.key, required this.url});

  String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text(bookIntroduction),
      ),
      body: WebView(
        initialUrl: url, // 웹 페이지의 URL
        javascriptMode: JavascriptMode.unrestricted, // JavaScript 활성화
        onWebViewCreated: (WebViewController webViewController) {
          // WebView가 생성되면 호출되는 콜백
        },
      ),
    );
  }
}
