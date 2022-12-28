import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:istnagram/views/components/animations/empty_content_animation_view.dart';
import 'package:istnagram/views/components/animations/lottie_animation_view.dart';
import 'package:istnagram/views/components/animations/models/lottie_animation.dart';

// class EmtyContenWithTextAnimationView extends LottieAnimationsView {
//   const EmtyContenWithTextAnimationView(
//       {super.key, super.repeat, super.reverse})
//       : super(animation: LottieAnimation.empty);
// }

class EmtyContenWithTextAnimationView extends StatelessWidget {
  const EmtyContenWithTextAnimationView({super.key, required this.text});

  final String text;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(34),
            child: Text(
              text,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white54,
                  ),
            ),
          ),
          const EmtyContenAnimationView(),
        ],
      ),
    );
  }
}
