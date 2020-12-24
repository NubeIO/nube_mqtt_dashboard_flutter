import 'package:flutter/material.dart';

import '../../../themes/theme_interface.dart';
import '../../../widgets/theme_painter.dart';

class Selection extends StatelessWidget {
  final ITheme theme;
  final bool selected;
  final GestureTapCallback onTap;
  const Selection({
    Key key,
    @required this.theme,
    this.selected = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      child: Column(
        children: [
          MaterialButton(
            shape: const CircleBorder(),
            padding: EdgeInsets.zero,
            onPressed: onTap,
            child: Container(
              height: 56,
              width: 56,
              decoration: selected
                  ? BoxDecoration(
                      border: Border.all(
                        width: 2,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      shape: BoxShape.circle,
                    )
                  : null,
              child: Center(
                child: CustomPaint(
                  painter: ThemePainer(
                    theme.primary,
                    theme.background,
                    theme.secondary,
                  ),
                  size: const Size(48, 48),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            theme.name,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }
}
