
import 'dart:async';
import 'package:flutter/material.dart';

class HomeSlider extends StatefulWidget {
  final List<String> images;
  const HomeSlider({Key? key, required this.images}) : super(key: key);

  @override
  _HomeSliderState createState() => _HomeSliderState();
}

class _HomeSliderState extends State<HomeSlider> {
  late int _currentSlideIndex;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _currentSlideIndex = 0;
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      setState(() {
        if (_currentSlideIndex == widget.images.length - 1) {
          _currentSlideIndex = 0;
        } else {
          _currentSlideIndex++;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 200,
          width: double.infinity,
          child: Image.asset(
            widget.images[_currentSlideIndex],
            fit: BoxFit.contain, // Adjust the fit property here
          ),
        ),
      ],
    );
  }
}