/*
 * Created by haozhicao@tencent.com on 2021/9/9.
 * console_window.dart
 * 
 */

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'console_stream.dart';

double titleBarHeight = 36;
double minWindowHeight = 50;
double maxWindowHeight =
    window.physicalSize.height / window.devicePixelRatio * 0.75;

class ConsoleWidget extends StatefulWidget {
  final VoidCallback onCloseClicked;
  final VoidCallback onFoldClicked;
  final ConsoleStream consoleStream;
  ConsoleWidget({
    required Key key,
    required this.onCloseClicked,
    required this.onFoldClicked,
    required this.consoleStream,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() => ConsoleWidgetState();
}

class ConsoleWidgetState extends State<ConsoleWidget> {
  double windowHeight = 250;
  bool startResize = false;

  List<String> _logList = [];

  bool _autoToBottom = true;

  ScrollController _scrollController = ScrollController();

  void updateWindowHeight(DragUpdateDetails detail) {
    windowHeight -= detail.delta.dy;
    if (windowHeight <= minWindowHeight) {
      windowHeight = minWindowHeight;
    }
    if (windowHeight >= maxWindowHeight) {
      windowHeight = maxWindowHeight;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    widget.consoleStream.resume();
    widget.consoleStream.controller.stream.listen((data) {
      _logList.add(data);
      if (_logList.length >= 200) {
        _logList.removeAt(0);
      }
      if (this.mounted) {
        setState(() {});
        if (_autoToBottom) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      }
    });

    _scrollController.addListener(() {
      bool upDirection = _scrollController.position.userScrollDirection ==
          ScrollDirection.forward;

      /// 向上滑，停止自动滚动更新
      if (upDirection) {
        _autoToBottom = false;
      }

      /// 滑到最底部，开始自动滚动更新
      if (_scrollController.offset >
          _scrollController.position.maxScrollExtent) {
        _autoToBottom = true;
      }
    });
  }

  @override
  void dispose() {
    widget.consoleStream.destroy();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          buildTitleBar(),
          Container(
            height: 0.5,
            color: Colors.black87,
          ),
          Stack(
            children: [
              buildListView(),
              Positioned(
                child: GestureDetector(
                    onTap: () {
                      _autoToBottom = true;
                      _scrollController
                          .jumpTo(_scrollController.position.maxScrollExtent);
                    },
                    child: Icon(
                      Icons.vertical_align_bottom_rounded,
                      size: 20,
                      color: Colors.white,
                    )),
                bottom: 4,
                right: 4,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildTitleBar() {
    double iconMargin = 25;
    return Container(
      height: titleBarHeight,
      width: window.physicalSize.width / window.devicePixelRatio,
      color: Color(0xff2b2b2b),
      child: Row(
        children: [
          GestureDetector(
            onTap: widget.onFoldClicked,
            child: Container(
              margin: EdgeInsets.all(4.0),
              width: iconMargin,
              // color: Colors.red,
              child: Icon(
                Icons.close_fullscreen_sharp,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(4.0),
            width: iconMargin,
            // color: Colors.red,
            child: Icon(
              Icons.format_line_spacing_sharp,
              color: Colors.white,
            ),
          ),
          Spacer(),
          Text(
            'Console',
            style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                decoration: TextDecoration.none),
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              setState(() {
                _autoToBottom = true;
                _logList.clear();
              });
            },
            child: Container(
              margin: EdgeInsets.all(4.0),
              width: iconMargin,
              child: Icon(
                Icons.cleaning_services_sharp,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          GestureDetector(
            onTap: widget.onCloseClicked,
            child: Container(
              margin: EdgeInsets.all(4.0),
              width: iconMargin,
              // color: Colors.red,
              child: Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildListView() {
    return Container(
        height: windowHeight,
        padding: EdgeInsets.all(8.0),
        width: window.physicalSize.width / window.devicePixelRatio,
        color: Color(0xff2b2b2b),
        child: MediaQuery.removePadding(
          removeTop: true,
          context: context,
          child: RawScrollbar(
            thumbColor: Colors.white30,
            thickness: 5,
            controller: _scrollController,
            child: ListView.builder(
              controller: _scrollController,
              shrinkWrap: true,
              itemCount: _logList.length,
              itemBuilder: (context, index) {
                return Text(
                  _logList[index],
                  style: TextStyle(
                      color: Color(0xffbbbbbb),
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      decoration: TextDecoration.none),
                );
              },
            ),
          ),
        ));
  }
}