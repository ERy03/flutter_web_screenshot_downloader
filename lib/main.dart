// import 'dart:html';
@JS()
library imgdownload;

import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:js/js.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:universal_html/html.dart' as html;

@JS('save')
external void save(String fileName, Uint8List data);

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
            // Downloading
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Tooltip(
                  message: 'using anchor element',
                  child: ElevatedButton(
                      onPressed: () {
                        screenshotController.capture().then((value) {
                          final base64Code = base64Encode(value!);
                          AnchorElement(
                              href: 'data:image/png;base64,$base64Code')
                            ..setAttribute('download', 'screenshot.png')
                            ..click();
                        }).catchError((onError) {
                          debugPrint(onError);
                        });
                      },
                      child: const Text('download:1')),
                ),
                const SizedBox(width: 10),
                Tooltip(
                  message: 'using js save function',
                  child: ElevatedButton(
                      onPressed: () {
                        screenshotController.capture().then((value) {
                          save('screenshot.png', value!);
                        }).catchError((onError) {
                          debugPrint(onError);
                        });
                      },
                      child: const Text('download:2')),
                ),
                const SizedBox(width: 10),
                Tooltip(
                  message: 'using data:application/octet-stream;base64',
                  child: ElevatedButton(
                      onPressed: () {
                        screenshotController.capture().then((value) {
                          final base64Code = base64Encode(value!);
                          final anchor = AnchorElement(
                              href:
                                  'data:application/octet-stream;base64,$base64Code')
                            ..target = 'blank'
                            ..download = 'screenshot.png';
                          document.body!.append(anchor);
                          anchor.click();
                          anchor.remove();
                        }).catchError((onError) {
                          debugPrint(onError);
                        });
                      },
                      child: const Text('download:3')),
                ),
                const SizedBox(width: 10),
                Tooltip(
                  message: 'using rawData',
                  child: ElevatedButton(
                      onPressed: () {
                        screenshotController.capture().then((value) {
                          final rawData = value!.buffer.asUint8List();
                          final content = base64Encode(rawData);
                          AnchorElement(
                              href:
                                  "data:application/octet-stream;charset=utf-16le;base64,$content")
                            ..setAttribute("download", "file.txt")
                            ..click();
                        }).catchError((onError) {
                          debugPrint(onError);
                        });
                      },
                      child: const Text('download:4')),
                ),
                const SizedBox(width: 10),
                Tooltip(
                  message: 'using blob with url',
                  child: ElevatedButton(
                      onPressed: () async {
                        screenshotController.capture().then((value) async {
                          final blob = html.Blob([value!], 'image/png');
                          final url =
                              await html.Url.createObjectUrlFromBlob(blob);
                          final a = html.AnchorElement();
                          a.href = url;
                          a.download = 'screenshot.png';
                          html.document.body!.append(a);
                          a.click();
                          await Future.delayed(const Duration(seconds: 1));
                          html.Url.revokeObjectUrl(url);
                        }).catchError((onError) {
                          debugPrint(onError);
                        });
                      },
                      child: const Text('download:5')),
                ),
              ],
            ),

            const SizedBox(height: 10),
            // Sharing with share plus
            ElevatedButton(
                onPressed: () {
                  screenshotController.capture().then((value) async {
                    await Share.shareXFiles([
                      XFile.fromData(value!,
                          mimeType: 'image/png', name: 'screenshot.png'),
                    ]);
                  }).catchError((onError) {
                    debugPrint(onError);
                  });
                },
                child: const Text('share with shareplus')),
            const SizedBox(height: 10),
            // Sharing with html
            ElevatedButton(
                onPressed: () {
                  screenshotController.capture().then((value) async {
                    try {
                      await html.window.navigator.share({
                        'files': [
                          html.Blob([
                            html.File(
                                [value!], 'image/png', {'type': 'image/png'})
                          ], 'screenshot.png')
                        ]
                      });
                    } catch (e) {
                      debugPrint(e.toString());
                    }
                  }).catchError((onError) {
                    debugPrint(onError);
                  });
                },
                child: const Text('share with html')),

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
