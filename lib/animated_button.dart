import 'package:flutter/material.dart';

class AnimatedButton extends StatefulWidget {
  const AnimatedButton({Key? key}) : super(key: key);

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with TickerProviderStateMixin {
  late double _scaleA;
  late double _scaleB;

  late AnimationController _controllerA;
  late AnimationController _controllerB;

  @override
  void initState() {
    _controllerA = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 0,
      ),
      lowerBound: 0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });

    _controllerB = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 0,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controllerA.dispose();
    _controllerB.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scaleA = 1 - _controllerA.value;
    _scaleB = 1 - _controllerB.value;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTapDown: _onTapDown,
                onTapUp: _onTapUp,
                child: Transform.scale(
                  scale: _scaleA,
                  child: Card(
                    color: Colors.cyan,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.15,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTapDown: (TapDownDetails details) {
                  _controllerB.forward();
                },
                onTapUp: (TapUpDetails details) {
                  _controllerB.reverse();
                },
                child: Transform.scale(
                  scale: _scaleB,
                  child: Card(
                    color: Colors.teal,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.15,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onTapDown(TapDownDetails details) {
    _controllerA.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controllerA.reverse();
  }
}
