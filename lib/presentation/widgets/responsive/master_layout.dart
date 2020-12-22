import 'package:flutter/material.dart';

import 'padding.dart';

class MasterLayout extends StatelessWidget {
  final Widget master;
  final Widget detail;
  final double width;

  const MasterLayout({
    Key key,
    @required this.master,
    this.detail,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: width ?? ResponsiveSize.panelWidth(context),
          child: master,
        ),
        Expanded(
          child: detail ??
              Container(
                color: Theme.of(context).colorScheme.primary,
              ),
        )
      ],
    );
  }
}
