import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late WebViewController _controller;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (await _controller.canGoBack()) {
          _controller.goBack();

          return false;
        } else {
          return false;
        }
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
        child: WebviewScaffold(
          url: 'https://bonybiz.com',
          withLocalStorage: true,
          withJavascript: true,
          withZoom: false,
          // hidden: true,
          geolocationEnabled: true,
          initialChild: Center(
            child: Image(
              image: AssetImage(
                'assets/LOGO.png',
              ),
            ),
          ),
          scrollBar: false,
        ),
      ),
    );
  }
}
