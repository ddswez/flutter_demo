import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';
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
              // initialUrl: "https://tronscan.org/#/transaction/7850c15384c112208ab52405f5651cff472cacc07b5f2a79f30008b4f6f5c157",
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
          print(message.message);
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );

          var decoded = json.decode(message.message);
          var jsBridge = JsBridgeBean.fromJson(decoded);
          switch(jsBridge.method) {
            case "requestAccounts": {
              _jsBridgeCallBack(_webViewController, context);
              break;
            }
            case "signMessage":
            case "signPersonalMessage":
            case "signTypedMessage": {
              _jsBridgeCallBack(_webViewController, context);
              break;
            }
            case "signTransaction": {
              _jsBridgeCallBack(_webViewController, context);
              break;
            }

          }

        });
  }

  /// address: 0x827b6f0a2e165cbd613ab445ba3fd08f47481011
  /// privateKey: a1bde198def90d8674c201c992eeb4a386459194a1d3bf02f8929b3ce4036159
  _signMessage(String data) async {
      if (data == null || data.isEmpty) {
        return;
      }
      Uint8List uint8ListData = hexToBytes(data);
      EthPrivateKey ethPrivateKey =
        EthPrivateKey.fromHex('a1bde198def90d8674c201c992eeb4a386459194a1d3bf02f8929b3ce4036159');
      Uint8List signedData = await ethPrivateKey.signPersonalMessage(uint8ListData);

      String signedDataHex = bytesToHex(signedData);

  }

  void _jsBridgeCallBack(WebViewController controller, BuildContext context) async {
    // Send a message with the user agent string to the Toaster JavaScript channel we registered
    // with the WebView.
    // await controller.evaluateJavascript(
    //     "Toaster.postMessage('abc');");
    var callback = JsBridgeCallback();
    callback.result = ["0x827b6f0a2e165cbd613ab445ba3fd08f47481011"];
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

    var givenJS = await rootBundle.loadString('assets/web5.min.js');
    // flutterWebViewPlugin.evalJavascript(givenJS);
    // return givenJS.then((String js) {
    // var dsbridgeJS = await rootBundle.loadString('assets/dsbridge.js');
    // _webViewController.evaluateJavascript(dsbridgeJS);
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
