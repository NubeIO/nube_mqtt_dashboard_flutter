import 'package:flutter/material.dart';

import '../../../themes/nube_theme.dart';

class InputStyles {
  static TextStyle labelStyle(BuildContext context, {bool hasFocus}) {
    return hasFocus ? smallLabel(context) : regularLabel(context);
  }

  static TextStyle regularLabel(BuildContext context) {
    return Theme.of(context).textTheme.bodyText1.copyWith(
          fontSize: 16,
          fontFamily: "Poppins",
          color: NubeTheme.colorText300(context),
        );
  }

  static TextStyle smallLabel(BuildContext context) {
    return Theme.of(context).textTheme.bodyText1.copyWith(
          fontSize: 12,
          height: 1.2,
          color: NubeTheme.colorText300(context),
        );
  }

  static TextStyle textStyle(BuildContext context) {
    return Theme.of(context)
        .textTheme
        .bodyText1
        .copyWith(fontFamily: "Poppins");
  }

  static TextStyle prefixStyle(BuildContext context) {
    return Theme.of(context)
        .textTheme
        .headline3
        .copyWith(color: Theme.of(context).colorScheme.primary);
  }
}
