import 'package:flutter/material.dart';

import '../widgets/overlays/loading.dart';

mixin LoadingMixin {
  void showLoading(BuildContext context, {String message = ""}) {
    if (message.isEmpty) {
      LoadingOverlay.of(context).show();
    } else {
      LoadingOverlay.of(context).showText(message);
    }
  }

  void hideLoading(BuildContext context) {
    LoadingOverlay.of(context).hide();
  }
}
