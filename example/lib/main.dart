import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_console/flutter_console.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final navKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navKey,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Console'),
        ),
        body: Center(
          child: GestureDetector(
            onTap: showLog,
              child: Container(
            height: 50,
            width: 100,
            color: Colors.purple,
            child: Center(
              child: Text(
                'show',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          )),
        ),
      ),
    );
  }

  void showLog() {
    ConsoleStream logStream = ConsoleStream();
    ConsoleOverlay().show(baseOverlay:navKey.currentState!.overlay!, contentStream: logStream, y: 300,);
    pushLog(logStream);
  }

  void pushLog(ConsoleStream cr) {
    cr.push('Show Log:' + DateTime.now().millisecondsSinceEpoch.toString());
    Future.delayed(const Duration(milliseconds: 1000), () {
      pushLog(cr);
    });
  }
}
