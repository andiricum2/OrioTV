import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:oriotv/src/models/content.dart';

class MyWebViewScreen extends StatelessWidget {
  final Media media;

  const MyWebViewScreen({Key? key, required this.media}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(media.title ?? ""),
      ),
      body: WebView(
        initialUrl: media.url,
        javascriptMode: JavascriptMode.unrestricted,
        navigationDelegate: (NavigationRequest request) {
          // Prevent navigation to a new page
          return NavigationDecision.prevent;
        },
      ),
    );
  }
}
