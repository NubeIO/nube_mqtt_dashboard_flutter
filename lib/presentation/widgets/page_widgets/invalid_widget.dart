import 'package:flutter/material.dart';

import '../../../domain/layout/failures.dart';

class ErrorTypeWidget extends StatelessWidget {
  final LayoutParseFailure failure;

  const ErrorTypeWidget({
    Key key,
    @required this.failure,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          failure.when(
            unknown: () => "Unknown Widget Type.",
            parse: () => "Error Parsing Widget",
          ),
          style: Theme.of(context)
              .textTheme
              .headline3
              .copyWith(color: Theme.of(context).colorScheme.error),
        ),
        const SizedBox(
          height: 16,
        ),
        Text(
          failure.when(
            unknown: () => "Please update the app or contact admin.",
            parse: () =>
                "Something went wrong when trying to parse widget data.",
          ),
        ),
      ],
    );
  }
}
