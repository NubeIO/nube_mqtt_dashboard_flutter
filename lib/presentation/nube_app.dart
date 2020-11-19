import 'package:flutter/material.dart';

import 'nube_theme.dart';

class NubeApp extends StatelessWidget {
  const NubeApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Nube MQTT",
      theme: NubeTheme.lightTheme,
      home: const Placeholder(),
    );
  }
}
