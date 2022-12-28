import 'package:flutter/material.dart';
import 'package:istnagram/views/components/animations/models/lottie_animation.dart';
import 'package:lottie/lottie.dart';

class LottieAnimationsView extends StatelessWidget {
  const LottieAnimationsView({
    Key? key,
    required this.animation,
    this.repeat = true,
    this.reverse = false,
  }) : super(key: key);

  final LottieAnimation animation;
  final bool reverse;
  final bool repeat;

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      animation.fullPath,
      repeat: repeat,
      reverse: reverse,
    );
  }
}

extension GetFullPath on LottieAnimation {
  String get fullPath => 'assets/animations/$name.json';
}
