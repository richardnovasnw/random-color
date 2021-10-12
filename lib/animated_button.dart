import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class AnimatedButton extends StatefulWidget {
  const AnimatedButton({Key? key}) : super(key: key);

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> {
  double padding1 = 8.0;
  double padding2 = 8.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder<double>(
            onEnd: () {
              setState(() {
                padding1 = 8.0;
              });
            },
            tween: Tween<double>(begin: 0, end: padding1),
            duration: const Duration(milliseconds: 200),
            curve: Curves.elasticOut,
            builder: (BuildContext context, double size, Widget? child) {
              return GestureDetector(
                child: Container(
                  color: Colors.transparent,
                  height: MediaQuery.of(context).size.height * .2,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: EdgeInsets.all(padding1),
                    child: const Card(
                      color: Colors.cyan,
                    ),
                  ),
                ),
                onTap: () {
                  setState(() {
                    padding1 = 24;
                  });
                },
              );
            },
          ),
          TweenAnimationBuilder<double>(
            onEnd: () {
              setState(() {
                padding2 = 8.0;
              });
            },
            tween: Tween<double>(begin: 0, end: padding2),
            duration: const Duration(milliseconds: 200),
            curve: Curves.elasticOut,
            builder: (BuildContext context, double size, Widget? child) {
              return GestureDetector(
                child: Container(
                  color: Colors.transparent,
                  height: MediaQuery.of(context).size.height * .2,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: EdgeInsets.all(padding2),
                    child: const Card(
                      color: Colors.cyan,
                    ),
                  ),
                ),
                onTap: () {
                  setState(() {
                    padding2 = 24;
                  });
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
