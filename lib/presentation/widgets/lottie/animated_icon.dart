import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AnimatedIcon extends StatelessWidget {
  final double size;
  final String assetName;

  const AnimatedIcon({
    Key key,
    this.size,
    this.assetName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final IconThemeData iconTheme = IconTheme.of(context);

    final double iconSize = size ?? iconTheme.size;

    return Lottie.asset(
      assetName,
      width: iconSize,
      height: iconSize,
      fit: BoxFit.fill,
    );
  }
}
