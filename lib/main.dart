// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  ScreenshotController screenshotController = ScreenshotController();

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Screenshot(
              controller: screenshotController,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Image(
                    image: AssetImage(
                        'assets/images/james-barker-v3-zcCWMjgM-unsplash.jpg'),
                    height: 250,
                  ),
                  const Text(
                    'You have pushed the button this many times:',
                  ),
                  Text(
                    '$_counter',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
            ),
            // ElevatedButton(
            //     onPressed: () {
            //       screenshotController.capture().then((value) {
            //         final base64Code = base64Encode(value!);
            //         AnchorElement(href: 'data:image/png;base64,$base64Code')
            //           ..setAttribute('download', 'screenshot.png')
            //           ..click();
            //       }).catchError((onError) {
            //         debugPrint(onError);
            //       });
            //     },
            //     child: const Text('download')),
            ElevatedButton(
                onPressed: () {
                  screenshotController.capture().then((value) {
                    Share.shareXFiles([
                      XFile.fromData(value!,
                          mimeType: 'image/png', name: 'screenshot.png'),
                    ]);
                  }).catchError((onError) {
                    debugPrint(onError);
                  });
                },
                child: const Text('share')),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Share.share('check out my website https://google.com');
              },
              child: const Text('share link'),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
