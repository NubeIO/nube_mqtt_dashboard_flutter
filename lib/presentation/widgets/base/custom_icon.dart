import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

@protected
class CustomIcon extends StatelessWidget {
  final double size;
  final Color color;
  final String assetName;
  final String semanticsLabel;
  const CustomIcon({
    Key key,
    this.size,
    this.color,
    this.assetName,
    this.semanticsLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final IconThemeData iconTheme = IconTheme.of(context);

    final double iconSize = size ?? iconTheme.size;

    final double iconOpacity = iconTheme.opacity;
    Color iconColor = color ?? iconTheme.color;
    if (iconOpacity != 1.0) {
      iconColor = iconColor.withOpacity(iconColor.opacity * iconOpacity);
    }

    return SvgPicture.asset(
      assetName,
      width: iconSize,
      height: iconSize,
      fit: BoxFit.fill,
      color: color,
      semanticsLabel: semanticsLabel,
    );
  }
}
