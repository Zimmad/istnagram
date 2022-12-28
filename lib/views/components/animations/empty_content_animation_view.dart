import 'package:istnagram/views/components/animations/lottie_animation_view.dart';
import 'package:istnagram/views/components/animations/models/lottie_animation.dart';

class EmtyContenAnimationView extends LottieAnimationsView {
  const EmtyContenAnimationView({super.key, super.repeat, super.reverse})
      : super(animation: LottieAnimation.empty);
}
