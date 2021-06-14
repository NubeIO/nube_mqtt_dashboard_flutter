import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../widgets/screens/pin_screen.dart';

class CreatePinPage extends StatelessWidget {
  final String title;
  final String subtitle;

  const CreatePinPage({
    Key key,
    this.title = "Enter Pin Code",
    this.subtitle =
        "Please create a pin which will be used to lock down the application. ",
  }) : super(key: key);

  void _navigateOnSuccess(BuildContext context, String pin) {
    ExtendedNavigator.of(context).pop(pin);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PinScreen(
        title: title,
        subtitle: subtitle,
        onComplete: (value) => _navigateOnSuccess(context, value.getOrCrash()),
      ),
    );
  }
}
