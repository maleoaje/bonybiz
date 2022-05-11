import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  late WebViewController _webViewController;
  double progress = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (await _webViewController.canGoBack()) {
          _webViewController.goBack();

          return false;
        } else {
          return false;
        }
      },
      child: Scaffold(
          body: Column(
        children: [
          SizedBox(
            height: 24,
          ),
          LinearProgressIndicator(
            value: progress,
            color: Colors.orange,
            backgroundColor: Colors.black12,
          ),
          Expanded(
            child: WebView(
              initialUrl: 'https://bonybiz.com',
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _webViewController = webViewController;
                _controller.complete(webViewController);
              },
              onProgress: (progress) {
                setState(() {
                  this.progress = progress / 100;
                });
              },
              javascriptChannels: <JavascriptChannel>{
                _toasterJavascriptChannel(context),
              },
              navigationDelegate: (NavigationRequest request) {
                if (request.url.startsWith('https://bonybiz.com ')) {
                  print('blocking navigation to $request}');
                  return NavigationDecision.prevent;
                }
                print('allowing navigation to $request');
                return NavigationDecision.navigate;
              },
              onPageStarted: (String url) {
                print('Page started loading: $url');
              },
              onPageFinished: (String url) {
                print('Page finished loading: $url');

                _webViewController
                    .evaluateJavascript("javascript:(function() { " +
                        "var footer = document.getElementsByTagName('footer')[0];" +
                        "footer.parentNode.removeChild(footer);" +
                        "})()")
                    .then((value) =>
                        debugPrint('Page finished loading Javascript'))
                    .catchError((onError) => debugPrint('$onError'));
              },
              gestureNavigationEnabled: true,
            ),
          ),
        ],
      )),
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          // ignore: deprecated_member_use
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }
}
