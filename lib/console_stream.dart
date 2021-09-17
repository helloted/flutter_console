/*
 * Created by haozhicao@tencent.com on 2021/9/2.
 * console_stream.dart
 * 
 */

import 'dart:async';

import 'package:flutter/material.dart';

class ConsoleStream {
  late StreamController<String> controller;
  bool _shouldForward = false;

  ConsoleStream() {
    controller = rebuildStreamController();
  }

  StreamController<String> rebuildStreamController() {
    return StreamController<String>(
      onListen: () => _shouldForward = true,
      onPause: () => _shouldForward = false,
      onResume: () => _shouldForward = true,
      onCancel: () => _shouldForward = false,
    );
  }

  
  void push(Object? message) {
    if (!_shouldForward) {
      return;
    }

    String msg;
    if (message is Function) {
      msg = message().toString();
    } else if (message is String) {
      msg = message;
    } else {
      msg = message.toString();
    }

    controller.add(msg);
  }

  void pause() {
    _shouldForward = false;
    controller.close();
  }

  void resume() {
    controller = rebuildStreamController();
    _shouldForward = true;
  }

  void destroy() {
    _shouldForward = false;
    controller.close();
  }
}