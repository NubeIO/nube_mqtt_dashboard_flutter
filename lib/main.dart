import 'package:flutter/material.dart';

import 'injectable/injection.dart';
import 'presentation/nube_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const NubeApp());
}
