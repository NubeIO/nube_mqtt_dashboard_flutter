import 'package:flutter/widgets.dart';

import 'package:nube_mqtt_dashboard/presentation/widgets/lottie/lottie_widget.dart';

class OnBoardingIllustration extends LottieWidget {
  static const String path = "assets/lottie/illustration_onboarding.json";
  static const String pathDark =
      "assets/lottie/illustration_onboarding_dark.json";
  const OnBoardingIllustration({
    Key key,
    @required Size size,
  }) : super(
          key: key,
          asset: path,
          size: size,
        );
}
