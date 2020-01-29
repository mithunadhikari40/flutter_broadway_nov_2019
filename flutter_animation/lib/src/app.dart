import 'dart:math' as Math;

import 'package:flutter/material.dart';
import 'package:flutter_animation/src/widgets/cat_image.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> with TickerProviderStateMixin {
  Animation<double> boxAnimation;
  Animation<double> flapAnimation;
  AnimationController boxController;
  AnimationController flapController;

  AnimationController controller;
  Animation<double> animation;

  @override
  void initState() {
    boxController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);
    boxAnimation = Tween(begin: -40.0, end: -95.0).animate(
      CurvedAnimation(parent: boxController, curve: Curves.linear),
    );

    flapController =
        AnimationController(duration: Duration(microseconds: 200), vsync: this);

    flapAnimation = Tween(begin: Math.pi * .6, end: Math.pi * .7).animate(
      CurvedAnimation(parent: flapController, curve: Curves.easeInOut),
    );

    flapController.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        flapController.forward();
      } else if (status == AnimationStatus.completed) {
        flapController.reverse();
      }
    });

    flapController.forward();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    animation = Tween(begin: 0.99, end: 1.01)
        .animate(CurvedAnimation(parent: controller, curve: Curves.linear));
    controller.addStatusListener((status){
      if (status == AnimationStatus.dismissed) {
        controller.forward();
      } else if (status == AnimationStatus.completed) {
        controller.reverse();
      }

    });
    controller.forward();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Animation App",
      home: Scaffold(
        appBar: AppBar(
          title: Text("Animation App!"),
        ),
        body: Center(
          child: InkWell(
            child: Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                buildBody(),
                buildBox(),
                buildLeftHand(),
                buildRightHand(),
              ],
            ),
            onTap: _onTap,
          ),
        ),
      ),
    );
  }

  Widget buildBody() {
    return AnimatedBuilder(
        animation: boxAnimation,
        builder: (BuildContext context, Widget child) {
          return Positioned(
            child: child,
            top: boxAnimation.value,
            left: 0.0,
            right: 0.0,
          );
        },
        child: CatImage());
  }

  Widget buildBox() {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget child) {
        return Transform.scale(
          child: Container(
            color: Colors.brown,
            height: 250,
            width: 250,
          ), scale: animation.value,
        );
      },
    );
  }

  Widget buildLeftHand() {
    return Positioned(
      left: 4.0,
      top: 2.0,
      child: AnimatedBuilder(
        animation: flapAnimation,
        builder: (BuildContext context, Widget child) {
          return Transform.rotate(
            angle: flapAnimation.value,
            alignment: Alignment.topLeft,
            child: Container(
              width: 100,
              height: 10,
              color: Colors.brown,
            ),
          );
        },
      ),
    );
  }

  Widget buildRightHand() {
    return Positioned(
      right: 4.0,
      top: 2.0,
      child: AnimatedBuilder(
        animation: flapAnimation,
        builder: (BuildContext context, Widget child) {
          return Transform.rotate(
            angle: -flapAnimation.value,
            alignment: Alignment.topRight,
            child: Container(
              width: 100,
              height: 10,
              color: Colors.brown,
            ),
          );
        },
      ),
    );
  }

  void _onTap() {
    //check the status of the animation and either forward or reverse the animation
    if (boxAnimation.status == AnimationStatus.dismissed ||
        boxAnimation.status == AnimationStatus.reverse) {
      boxController.forward();

      flapController.stop();
    } else if (boxAnimation.status == AnimationStatus.completed ||
        boxAnimation.status == AnimationStatus.forward) {
      boxController.reverse();
      flapController.forward();
    }
  }
}
