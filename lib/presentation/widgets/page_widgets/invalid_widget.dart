import 'package:flutter/material.dart';

class ErrorTypeWidget extends StatelessWidget {
  final String title;
  final String subtitle;

  const ErrorTypeWidget({
    Key key,
    this.title,
    this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.headline3.copyWith(
            fontSize: 34,
            color: colorScheme.onError,
          ),
        ),
        Text(
          subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.bodyText1.copyWith(
            color: colorScheme.onError.withOpacity(.6),
            height: 1.2,
          ),
        ),
      ],
    );
  }
}
