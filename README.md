# flutter_console

A Flutter Console UI

#### 项目介绍

一个在Flutter端Console可视化的组件，将Console Window置于页面最顶层，用于调试，输出日志等。

#### 安装使用

[安装步骤](https://pub.dev/packages/flutter_console/install)

#### 简单Demo

```dart
import 'package:flutter/material.dart';
import 'dart:async';
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

```

![img](https://github.com/helloted/flutter_console/blob/main/images/window.png)

#### 功能介绍：

工具栏从左至右

- 折叠按钮：将整个Console Window折叠未一个小窗口，点击小窗口可以恢复大窗口。
- 拉伸按钮：用于将Console Window进行上下拉伸
- 清除按钮：可以将当前所有Log清除
- 关闭按钮：将Console Window关闭
- 至底按钮：Console Window滚动到最底部

![img](https://github.com/helloted/flutter_console/blob/main/images/demo.gif)

#### API介绍

```dart
  void show({required OverlayState baseOverlay, required ConsoleStream contentStream, double y = 200}) {}
  
  baseOverlay:将Console Window置于的overlay层，为了保证在其他页面能够正常显示Window，建议使用navigator的overlay；
  contentStream:日志通道，contentStream.push可以输入要显示的日志；
  y：Window显示的初始位置y坐标，默认200;
```

