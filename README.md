# flutter_console

A Flutter Console UI

#### 项目介绍

一个在Flutter端Console可视化的组件，将Console Window置于页面最顶层，用于调试，输出日志等。

#### 快速上手

在根目录执行命令行flutter run，或者在IDE中run

#### 简单Demo

```
  void showLog() {
    ConsoleStream logStream = ConsoleStream();
    ConsoleOverlay().show(baseOverlay:Overlay.of(context)!, contentStream: logStream, y: 300,);
    pushLog(logStream);
  }

  void pushLog(ConsoleStream cr) {
    cr.push('Show Log:' + DateTime.now().millisecondsSinceEpoch.toString());
    Future.delayed(const Duration(milliseconds: 1000), () {
      pushLog(cr);
    });
  }
```

![img](/images/window.png)

#### 功能介绍：

X:关闭按钮，将Console Window关闭

i:拉伸按钮，用于将Console Window进行上下拉伸

c:清除按钮，可以将当前所有Log清除

f:折叠按钮，将整个Console Window折叠未一个小窗口，点击小窗口可以恢复大窗口。

Bo:Console Window滚动到最底部

![img](/images/demo.gif)

#### API介绍

```
  void show({required OverlayState baseOverlay, required ConsoleStream contentStream, double y = 200}) {}
  
  baseOverlay:将Console Window置于的overlay层，为了保证在其他页面能够正常显示Window，建议使用navigator的overlay；
  contentStream:日志通道，contentStream.push可以输入要显示的日志；
  y：Window显示的初始位置y坐标，默认200;
```

