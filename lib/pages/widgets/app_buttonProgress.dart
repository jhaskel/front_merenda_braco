import 'package:flutter/material.dart';
import 'dart:async';
class AppButtonProgress extends StatefulWidget {
  String title;
  final Function onPressed;

  AppButtonProgress(this.title,{this.onPressed});

  @override
  _AppButtonProgressState createState() => _AppButtonProgressState();
}

class _AppButtonProgressState extends State<AppButtonProgress> with TickerProviderStateMixin {
  int _state = 0;
  Animation _animation;
  AnimationController _controller;
  GlobalKey _globalKey = GlobalKey();
  double _width = double.maxFinite;

  String get title => widget.title;


  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
        ),
        child: Align(
          alignment: Alignment.center,
          child: PhysicalModel(
            elevation: 8,
            shadowColor: Colors.lightGreenAccent,
            color: Colors.lightGreen,
            borderRadius: BorderRadius.circular(25),
            child: Container(
              key: _globalKey,
              height: 48,
              width: _width,
              child: MaterialButton(
                animationDuration: Duration(milliseconds: 1000),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: EdgeInsets.all(0),
                child: setUpButtonChild(),
                onPressed: () {
                   widget.onPressed;
                  setState(() {
                    if (_state == 0) {
                      animateButton();
                    }
                  });
                },
                elevation: 4,
                color: Colors.lightGreen,
              ),
            ),
          ),
        ),
      ),

    );
  }

  setUpButtonChild() {
    if (_state == 0) {
      return Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      );
    } else if (_state == 1) {
      return SizedBox(
        height: 36,
        width: 36,
        child: CircularProgressIndicator(
          value: null,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    } else {
      return Icon(Icons.check, color: Colors.white);
    }
  }

  void animateButton() {
    double initialWidth = _globalKey.currentContext.size.width;

    _controller =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);

    _animation = Tween(begin: 0.0, end: 1).animate(_controller)
      ..addListener(() {
        setState(() {
          _width = initialWidth - ((initialWidth - 48) * _animation.value);
        });
      });
    _controller.forward();

    setState(() {
      _state = 1;
    });

    Timer(Duration(milliseconds: 3300), () {
      setState(() {
        _state = 2;
      });
    });
  }
}