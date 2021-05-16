import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieWidget extends StatelessWidget {
  final String asset;
  final String darkAsset;
  final Size size;

  const LottieWidget({
    Key key,
    @required this.asset,
    String darkAsset,
    @required this.size,
  })  : darkAsset = darkAsset ?? asset,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return Lottie.asset(
      brightness == Brightness.light ? asset : darkAsset,
      width: size.width,
      height: size.height,
      fit: BoxFit.fill,
    );
  }
}
