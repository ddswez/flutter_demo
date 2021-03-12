import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'js_bridge_bean.dart';
import 'js_bridge_callback_bean.dart';

class DAppWebPage2 extends StatefulWidget {
  final String url;
  final String title;

  DAppWebPage2(this.url, {Key key, this.title}) : super(key: key);

  static void start(BuildContext context, String url, {String title}) {
    Navigator.of(context).push(CupertinoPageRoute(builder: (_) {
      return DAppWebPage2(url, title: title ?? "");
    }));
  }

  @override
  _DAppWebPageState createState() => _DAppWebPageState();
}

class _DAppWebPageState extends State<DAppWebPage2> {
  WebViewController _webViewController;

  double lineProgress = 0.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // backgroundColor: Colors.white,
          title: Text(
            widget.title,
          ),
          bottom: PreferredSize(
            child: _progressBar(lineProgress, context),
            preferredSize: Size.fromHeight(1),
          ),
          actions: <Widget>[
            InkWell(
              onTap: () {
                _onShowUserAgent(_webViewController, context);
              },
              child: Center(
                child: Text('channel'),
              ),
            )
          ],
        ),
        body: Builder(
          builder: (BuildContext context) {
            return WebView(
              initialUrl: widget.url,
              // initialUrl: 'https://flutter.dev',
              javascriptMode: JavascriptMode.unrestricted,
              debuggingEnabled: true,
              // onWebViewCreated: (WebViewController webViewController) {
              //
              // },
              onWebViewCreated: (WebViewController webViewController) {
                _webViewController = webViewController;
                // loadJS();
              },
              onPageFinished: (String url) {
                loadJS();
              },
              // onPageStarted: (String url) {
              //   loadJS();
              // },
              javascriptChannels: <JavascriptChannel>[
                _toasterJavascriptChannel(context),
              ].toSet(),
            );
          },
        )
        // javascriptChannels: jsChannels,
        // debuggingEnabled: true,
        // withJavascript: true,
        );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'FoxApp',
        onMessageReceived: (JavascriptMessage message) {
          print('----------');
          print(message.message);
          var decoded = json.decode(message.message);
          var jsBridge = JsBridge.fromJson(decoded);
          if (jsBridge.method.contains("requestAccounts")) {

            Scaffold.of(context).showSnackBar(
              SnackBar(content: Text(message.message)),
            );

            _jsBridgeCallBack(_webViewController, context);

          }

          // Scaffold.of(context).showSnackBar(
          //   SnackBar(content: Text(message.message)),
          // );
        });
  }

  void _jsBridgeCallBack(WebViewController controller, BuildContext context) async {
    // Send a message with the user agent string to the Toaster JavaScript channel we registered
    // with the WebView.
    // await controller.evaluateJavascript(
    //     "Toaster.postMessage('abc');");
    var callback = JsBridgeCallback();
    callback.result = ["0x076f83c7d56cd6174f5a1d10283b2dc9558e1924"];
    var j = json.encode(callback);
    print(callback.toJson());
    print(j);
    print('callback(\'$j\')');
    await controller.evaluateJavascript('callback(\'$j\')');
  }


  _progressBar(double progress, BuildContext context) {
    return LinearProgressIndicator(
      backgroundColor: Colors.white70.withOpacity(0),
      value: progress == 1.0 ? 0 : progress,
      minHeight: 2,
      valueColor: new AlwaysStoppedAnimation<Color>(Colors.green),
    );
  }

  Future<String> loadJS() async {

    var givenJS = await rootBundle.loadString('assets/web4.min.js');
    // flutterWebViewPlugin.evalJavascript(givenJS);
    // return givenJS.then((String js) {
    // var dsbridgeJS = await rootBundle.loadString('assets/dsbridge.js');
    // _webViewController.evaluateJavascript(dsbridgeJS);
    print('------------1234');
    await _webViewController.evaluateJavascript(givenJS);
    // _controller.future.evaluateJavascript(dsbridgeJS);
    // flutterWebViewPlugin.onStateChanged.listen((viewState) async {
    //   print('------------------${viewState.type.toString()}');
    //   if (viewState.type == WebViewState.finishLoad) {
    //     flutterWebViewPlugin.evalJavascript(givenJS);
    //     flutterWebViewPlugin.evalJavascript(dsbridgeJS);
    //     // Future.delayed(
    //     //   Duration(seconds: 1),
    //     //   () {
    //     //     flutterWebViewPlugin.evalJavascript(givenJS);
    //     //   },
    //     // );
    //   }
    // }
    // );
  }

  @override
  void dispose() {
    super.dispose();
  }
}


void _onShowUserAgent(
    WebViewController controller, BuildContext context) async {
  // Send a message with the user agent string to the Toaster JavaScript channel we registered
  // with the WebView.
  // await controller.evaluateJavascript(
  //     "Toaster.postMessage('abc');");
  await controller.evaluateJavascript(
      'FoxApp.postMessage("User Agent: " + navigator.userAgent);');
}
