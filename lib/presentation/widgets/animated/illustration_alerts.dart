import 'package:flutter/widgets.dart';

import '../lottie/lottie_widget.dart';

class EmptyAlertsIllustration extends LottieWidget {
  static const String path = "assets/lottie/illustration_alerts.json";
  const EmptyAlertsIllustration({
    Key key,
    @required Size size,
  }) : super(
          key: key,
          asset: path,
          size: size,
        );
}
