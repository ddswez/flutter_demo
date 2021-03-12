import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:oktoast/oktoast.dart';

class DAppWebPage extends StatefulWidget {
  final String url;
  final String title;

  DAppWebPage(this.url, {Key key, this.title}) : super(key: key);

  static void start(BuildContext context, String url, {String title}) {
    Navigator.of(context).push(CupertinoPageRoute(builder: (_) {
      return DAppWebPage(url, title: title ?? "");
    }));
  }

  @override
  _DAppWebPageState createState() => _DAppWebPageState();
}

class _DAppWebPageState extends State<DAppWebPage> {
  FlutterWebviewPlugin flutterWebViewPlugin = FlutterWebviewPlugin();

  double lineProgress = 0.0;

  @override
  void initState() {
    super.initState();
    flutterWebViewPlugin.onProgressChanged.listen((progress) {
      print(progress);
      setState(() {
        lineProgress = progress;
      });
    });
    loadJS();
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      appBar: AppBar(
        // backgroundColor: Colors.white,
        title: Text(
          widget.title,
        ),
        bottom: PreferredSize(
          child: _progressBar(lineProgress, context),
          preferredSize: Size.fromHeight(1),
        ),
      ),
      url: widget.url,
      javascriptChannels: jsChannels,
      debuggingEnabled: true,
      withJavascript: true,
    );
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
    var givenJS = await rootBundle.loadString('assets/web3.min.js');
    var dsbridgeJS = await rootBundle.loadString('assets/dsbridge.js');
    // flutterWebViewPlugin.evalJavascript(givenJS);
    // return givenJS.then((String js) {
    flutterWebViewPlugin.onStateChanged.listen((viewState) async {
      print('------------------${viewState.type.toString()}');
      if (viewState.type == WebViewState.finishLoad) {
        flutterWebViewPlugin.evalJavascript(givenJS);
        flutterWebViewPlugin.evalJavascript(dsbridgeJS);
        // Future.delayed(
        //   Duration(seconds: 1),
        //   () {
        //     flutterWebViewPlugin.evalJavascript(givenJS);
        //   },
        // );
      }
    });
  }

  @override
  void dispose() {
    flutterWebViewPlugin.dispose();
    super.dispose();
  }
}

final Set<JavascriptChannel> jsChannels = [
  // JavascriptChannel(
  //     name: 'call',
  //     onMessageReceived: (JavascriptMessage message) {
  //       print('-------------------1111');
  //       print(message.message);
  //     }),
  // JavascriptChannel(
  //     name: 'requestAccounts',
  //     onMessageReceived: (JavascriptMessage message) {
  //       print('-------------------222');
  //       print(message.message);
  //     }),
  JavascriptChannel(
      // name: '_dsbridge',
      name: 'FoxApp',
      onMessageReceived: (JavascriptMessage message) {
        showToast('333');
        print('-------------------333');
        print(message.message);
      }),
].toSet();
