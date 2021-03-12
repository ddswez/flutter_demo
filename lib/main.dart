import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_learn/web_page.dart';

import 'dapp_web_page.dart';
import 'dapp_web_page_2.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  List tabs = ["新闻", "历史", "图片"];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = new TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body:
      NestedScrollView(
        headerSliverBuilder: (context, value){
          return [
            SliverToBoxAdapter(
              // child: Text("test", textScaleFactor: 3,),
              child: Image.network('https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fa4.att.hudong.com%2F27%2F67%2F01300000921826141299672233506.jpg&refer=http%3A%2F%2Fa4.att.hudong.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1614351491&t=75c032684786d5fe8a752060f57e856d')
            ),
            SliverToBoxAdapter(
              child: TabBar(
                controller: _tabController,
                tabs: tabs.map((e) => Tab(text: e)).toList(),
                unselectedLabelColor: Colors.red,
                labelColor: Colors.black,
                indicatorColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.label,
                isScrollable: true,
                labelPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              ),
            )
          ];
        },
        body: Container(
          child: TabBarView(
            controller: _tabController,
            children: tabs.map((e) {
              return Column(
                children: [
                  InkWell(
                    onTap: (){
                      // DAppWebPage.start(context,
                      //     'https://www.minidex.com/#/swap', title: 'test');
                      // DAppWebPage2.start(context,
                      //     'https://uniswap.biliangwang.com/#/swap', title: 'test');
                      DAppWebPage2.start(context,
                          'https://tcard.trister.io/#/home', title: 'test');
                      // DAppWebPage2.start(context,
                      //     'https://js-eth-sign.surge.sh/', title: 'test');
                    },
                    child: Text('go dapp', textScaleFactor: 3),
                  ),
                  Container(
                      alignment: Alignment.center,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(CupertinoPageRoute(
                              builder: (BuildContext context) => WebViewExample()));
                        },
                        child: Text(e, textScaleFactor: 3),
                      ))
                ],
              )
                ;
            }).toList(),
          ),
        ),
        // child: Container(
        //   alignment: Alignment.center,
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: <Widget>[
        //       SizedBox(height: 50),
        //       Text("abc"),
        //       Text(
        //         "bcd",
        //       ),
        //       SizedBox(height: 50),
        //       TabBar(
        //         controller: _tabController,
        //         tabs: tabs.map((e) => Tab(text: e)).toList(),
        //       ),
        //       Expanded(
        //           child: TabBarView(
        //         controller: _tabController,
        //         children: tabs.map((e) {
        //           return Container(
        //               alignment: Alignment.center,
        //               child: Text(e, textScaleFactor: 5));
        //         }).toList(),
        //       )),
        //       Text("abc", textScaleFactor: 2,),
        //     ],
        //   ),
        // ),
      ),
    );
  }
}
