import 'dart:math';

import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:random/animated_button.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red[800],
          child: const Text('Next'),
          onPressed: () {
            Navigator.push<void>(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => const ZoomAndPan(),
              ),
            );
          }),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        titleTextStyle: const TextStyle(color: Colors.black),
        title: const Text(
          'AppBar',
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.push<void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const AnimatedButton(),
                  ),
                );
              },
              child: const Text('Animated Button'))
        ],
      ),
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverList(
                    delegate: SliverChildListDelegate(
                  [
                    Container(
                        height: 50,
                        color: Colors.red,
                        child: const Text('Random Height Child 1')),
                    Container(
                        height: 50,
                        color: Colors.teal,
                        child: const Text('Random Height Child 2')),
                    Container(
                        height: 70,
                        color: Colors.cyan,
                        child: const Text('Random Height Child 3')),
                  ],
                )),
                SliverPersistentHeader(
                  delegate: _SliverAppBarDelegate(
                    const TabBar(
                      labelColor: Colors.black87,
                      unselectedLabelColor: Colors.grey,
                      tabs: [
                        Tab(text: "A"),
                        Tab(text: "B"),
                      ],
                    ),
                  ),
                  floating: true,
                  pinned: true,
                ),
              ];
            },
            body: TabBarView(children: [
              GridView.builder(
                  shrinkWrap: true,
                  itemCount: 30,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemBuilder: (context, i) {
                    return Container(
                      height: 40,
                      width: 40,
                      color: Colors
                          .primaries[Random().nextInt(Colors.primaries.length)],
                    );
                  }),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: 30,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 100,
                      color: Colors
                          .primaries[Random().nextInt(Colors.primaries.length)],
                    );
                  })
            ])),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

isolateEntry(SendPort sendPort) async {
  ReceivePort port = ReceivePort();
  sendPort.send(port.sendPort);
  num sum = 0;

  await for (var message in port) {
    List<int> data = message[0];
    SendPort replyPort = message[1];

    for (int i = 0; i < data.length; i++) {
      sum += data[i];
    }
    replyPort.send(sum);
  }
}

class ZoomAndPan extends StatefulWidget {
  const ZoomAndPan({Key? key}) : super(key: key);

  @override
  _ZoomAndPanState createState() => _ZoomAndPanState();
}

class _ZoomAndPanState extends State<ZoomAndPan> {
  Future sendReceive(SendPort send, List<int> message) async {
    ReceivePort responsePort = ReceivePort();
    send.send([message, responsePort.sendPort]);
    return responsePort.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red[800],
        onPressed: () async {
          ReceivePort port = ReceivePort();
          await Isolate.spawn(isolateEntry, port.sendPort);
          int sum = await sendReceive(await port.first, [1, 5, 2, 3, 6]);
          print('result : $sum');
        },
        child: const Text('Isolate'),
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InteractiveViewer(
                constrained: true,
                panEnabled: true,
                child: Image.asset(
                  'assets/image/deadpool.jpg',
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
