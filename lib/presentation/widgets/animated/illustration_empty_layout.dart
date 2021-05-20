import 'package:flutter/widgets.dart';

import '../lottie/lottie_widget.dart';

class EmptyLayoutIllustration extends LottieWidget {
  static const String path = "assets/lottie/illustration_empty_layout.json";
  const EmptyLayoutIllustration({
    Key key,
    @required Size size,
  }) : super(
          key: key,
          asset: path,
          size: size,
        );
}
