import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../responsive/padding.dart';

class LoadingOverlay {
  BuildContext _context;
  bool isShowing = false;

  void hide() {
    if (isShowing) {
      Navigator.of(_context).pop();
      isShowing = false;
    }
  }

  void show({Widget child}) {
    showDialog(
      context: _context,
      barrierDismissible: false,
      builder: (context) => _FullScreenLoader(child: child),
    );
    isShowing = true;
  }

  void showText(String text) {
    show(
      child: Text(
        text,
        style: Theme.of(_context)
            .textTheme
            .headline3
            .copyWith(color: Theme.of(_context).colorScheme.secondary),
      ),
    );
  }

  LoadingOverlay._create(this._context);

  factory LoadingOverlay.of(BuildContext context) {
    return LoadingOverlay._create(context);
  }
}

class _FullScreenLoader extends StatelessWidget {
  final Widget child;

  const _FullScreenLoader({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.background.withOpacity(.01),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(child: CircularProgressIndicator()),
            SizedBox(height: ResponsiveSize.padding(context)),
            Theme(
              data: ThemeData(brightness: Brightness.dark),
              child: child ?? Container(),
            ),
          ],
        ));
  }
}
