import 'package:flutter/widgets.dart';

import '../lottie/lottie_widget.dart';

class LoadingIllustration extends LottieWidget {
  static const String path = "assets/lottie/illustration_loading.json";
  const LoadingIllustration({
    Key key,
    @required Size size,
  }) : super(
          key: key,
          asset: path,
          size: size,
        );
}
