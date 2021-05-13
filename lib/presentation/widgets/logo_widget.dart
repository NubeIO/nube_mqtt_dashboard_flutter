import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../domain/theme/entities.dart';

class LogoWidget extends StatelessWidget {
  final Size size;
  final Logo logo;

  const LogoWidget({
    Key key,
    this.size = Size.small,
    @required this.logo,
  }) : super(key: key);

  String imageUrl(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    if (brightness == Brightness.light) {
      switch (size) {
        case Size.small:
          return logo.light.smallUrl;
        case Size.large:
          return logo.light.largeUrl;
      }
    } else {
      switch (size) {
        case Size.small:
          return logo.dark.smallUrl;
        case Size.large:
          return logo.dark.largeUrl;
      }
    }
    return "";
  }

  String fallbackAsset(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    const path = "assets/images/";

    switch (size) {
      case Size.small:
        return "${path}logo_small.png";
      case Size.large:
        if (brightness == Brightness.light) {
          return "${path}logo_light.png";
        } else {
          return "${path}logo_dark.png";
        }
    }

    return "";
  }

  @override
  Widget build(BuildContext context) {
    final fallbackWidget = Padding(
      padding: const EdgeInsets.all(4.0),
      child: Image.asset(fallbackAsset(context)),
    );
    final image = imageUrl(context);

    return image.isEmpty
        ? fallbackWidget
        : CachedNetworkImage(
            imageUrl: image,
            progressIndicatorBuilder: (context, url, progress) =>
                fallbackWidget,
            errorWidget: (context, url, error) => fallbackWidget,
          );
  }
}

enum Size { small, large }
