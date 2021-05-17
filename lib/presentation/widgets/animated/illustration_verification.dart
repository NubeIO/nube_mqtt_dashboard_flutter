import 'package:flutter/widgets.dart';

import 'package:nube_mqtt_dashboard/presentation/widgets/lottie/lottie_widget.dart';

class VerificationIllustration extends LottieWidget {
  static const String path = "assets/lottie/illustration_verification.json";
  const VerificationIllustration({
    Key key,
    @required Size size,
  }) : super(
          key: key,
          asset: path,
          size: size,
        );
}
