/*
 * Created by haozhicao@tencent.com on 2021/8/31.
 * log_show_overlay.dart
 * 
 */

import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'console_stream.dart';
import 'console_window.dart';

class ConsoleOverlay {
  double _widgetLastY = 200;
  Offset _dragTouchOffset = Offset(0, 0);
  late BuildContext baseContext;
  OverlayEntry? _holder;
  late OverlayState topOverlay;
  final logUIWidgetKey = GlobalKey<ConsoleWidgetState>();

  /// 展开时的Widget
  late ConsoleWidget unFoldView;

  /// 折叠时
  Widget? foldView;

  void show({required OverlayState baseOverlay, required ConsoleStream contentStream, double y = 200}) {
    topOverlay = baseOverlay;
    _widgetLastY = y;
    unFoldView = ConsoleWidget(
      key: logUIWidgetKey,
      onCloseClicked: _removeHolderIfExit,
      onFoldClicked: foldAction,
      consoleStream: contentStream,
    );
    unfoldWidgetUpdate();
  }

  /// 展开的变动
  void unfoldWidgetUpdate() {
    createUnfoldDragTarget(offset: Offset(0, _widgetLastY));
  }

  /// 变为折叠
  void foldAction() {
    if (foldView == null) {
      foldView = GestureDetector(
        onTap: unfoldWidgetUpdate,
        child: Container(
          width: 50,
          height: 50,
          child: Center(
            child: Icon(
              Icons.bug_report,
              color: Colors.white70,
              size: 35,
            ),
          ),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.orangeAccent, width: 2),
              color: Colors.black,
              borderRadius: BorderRadius.circular(25.0)),
        ),
      );
    }
    createFoldDragTarget(offset: Offset(10, _widgetLastY));
  }

  void _removeHolderIfExit() {
    if (_holder != null) {
      _holder!.remove();
      _holder = null;
    }
  }

  void refresh() {
    _holder!.markNeedsBuild();
  }

  void createUnfoldDragTarget({required Offset offset}) {
    _removeHolderIfExit();
    _holder = OverlayEntry(builder: (context) {
      double maxY = 200;
      if (logUIWidgetKey.currentState != null) {
        maxY = MediaQuery.of(context).size.height -
            logUIWidgetKey.currentState!.windowHeight -
            titleBarHeight;
      }
      return Positioned(
          top: offset.dy < 50
              ? 50
              : offset.dy > maxY
                  ? maxY
                  : offset.dy,
          child: DragTarget(
              builder: (BuildContext context, List incoming, List rejected) {
            return GestureDetector(
              onVerticalDragDown: (DragDownDetails details) {
                RenderBox renderBox = logUIWidgetKey.currentContext!
                    .findRenderObject() as RenderBox;
                _dragTouchOffset =
                    renderBox.globalToLocal(details.globalPosition);
              },
              child: Draggable(
                axis: Axis.vertical,
                child: unFoldView,
                feedback: unFoldView,
                onDragEnd: (detail) {
                  _widgetLastY = detail.offset.dy;
                  createUnfoldDragTarget(offset: detail.offset);
                  _dragTouchOffset = Offset(0, 0);
                },
                onDragUpdate: (DragUpdateDetails detail) {
                  bool yFit = _dragTouchOffset.dy >= 0 &&
                      _dragTouchOffset.dy <= titleBarHeight;
                  bool xFit =
                      _dragTouchOffset.dx >= 30 && _dragTouchOffset.dx <= 60;
                  if (xFit && yFit) {
                    logUIWidgetKey.currentState!.updateWindowHeight(detail);
                  }
                },
                childWhenDragging: Container(),
                ignoringFeedbackSemantics: false,
              ),
            );
            // );
          }));
    });
    topOverlay.insert(_holder!);
  }

  void createFoldDragTarget({required Offset offset}) {
    _removeHolderIfExit();
    _holder = OverlayEntry(builder: (context) {
      double maxY = MediaQuery.of(context).size.height - 50;
      double top = offset.dy > maxY ? maxY : offset.dy;
      return Positioned(
          top: top,
          left: offset.dx,
          child: DragTarget(
              builder: (BuildContext context, List incoming, List rejected) {
            return Draggable(
              child: foldView!,
              feedback: foldView!,
              onDragEnd: (detail) {
                _widgetLastY = detail.offset.dy;
                createFoldDragTarget(offset: detail.offset);
              },
              childWhenDragging: Container(),
              ignoringFeedbackSemantics: false,
            );
          }));
    });
    topOverlay.insert(_holder!);
  }
}
