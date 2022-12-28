import 'package:istnagram/views/components/animations/lottie_animation_view.dart';
import 'package:istnagram/views/components/animations/models/lottie_animation.dart';

class DataNotFoundAnimationView extends LottieAnimationsView {
  const DataNotFoundAnimationView({super.key, super.repeat, super.reverse})
      : super(animation: LottieAnimation.dataNotFound);
}
