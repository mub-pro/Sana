import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lottie/lottie.dart';

import 'nav_bar.dart';

class SplashScreen extends HookWidget {
  static const String id = 'splash_screen';
  @override
  Widget build(BuildContext context) {
    final animatedController = useAnimationController();
    return Scaffold(
        backgroundColor: Color(0xFF2A0651),
        body: Center(
          child: Lottie.asset(
            'assets/lottie/animated.json',
            controller: animatedController,
            repeat: false,
            onLoaded: (com) {
              animatedController.addStatusListener((status) {
                if (status == AnimationStatus.completed) {
                  Navigator.popUntil(context, (route) => false);
                  Navigator.pushNamed(context, NavBar.id);
                }
              });
              animatedController
                ..duration = com.duration
                ..forward();
            },
          ),
        ));
  }
}
