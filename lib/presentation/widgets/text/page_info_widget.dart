import 'package:flutter/material.dart';

import '../responsive/padding.dart';

class PageInfoText extends StatelessWidget {
  final String title;
  final String subtitle;

  const PageInfoText({
    Key key,
    @required this.title,
    @required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Text(
          title,
          style: textTheme.headline1,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveSize.padding(
              context,
              size: PaddingSize.large,
            ),
            vertical: ResponsiveSize.padding(
              context,
              size: PaddingSize.small,
            ),
          ),
          child: Text(
            subtitle,
            style: textTheme.bodyText1,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
