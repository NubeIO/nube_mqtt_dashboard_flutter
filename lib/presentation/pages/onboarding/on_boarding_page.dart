import 'package:flutter/material.dart';
import 'package:nube_mqtt_dashboard/presentation/widgets/animated/illustration_onboarding.dart';
import 'package:nube_mqtt_dashboard/presentation/widgets/text/clickable_text_span.dart';
import 'package:nube_mqtt_dashboard/utils/logger/log.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final accentColor = Theme.of(context).colorScheme.secondary;
    final theme = Theme.of(context).textTheme;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                AspectRatio(
                  aspectRatio: 1,
                  child: OnBoardingIllustration(
                    size: Size.infinite,
                  ),
                ),
              ],
            ),
          ),
          Text("Powered by", style: theme.bodyText1),
          Text(
            "Nube IO",
            style: theme.headline1.copyWith(
              fontSize: 36,
            ),
          ),
          Text(
            "IoT Solutions For The Build Environment",
            style: theme.caption,
          ),
          const SizedBox(height: 48.0),
          TextButton(
            onPressed: () {},
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(Colors.white),
              backgroundColor: MaterialStateProperty.all(accentColor),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0),
                ),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: Text("Start Registration"),
            ),
          ),
          const SizedBox(height: 16.0),
          ClickableTextSpan(
              textSelection: const TextSelection(
                baseOffset: 29,
                extentOffset: 39,
              ),
              onTap: () {
                Log.i('Tap Here Double onTap');
              },
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "I've already got an account. ",
                    style: theme.bodyText1,
                  ),
                  TextSpan(
                    text: 'Let me in!',
                    style: theme.bodyText1.copyWith(
                      fontWeight: FontWeight.bold,
                      color: accentColor,
                    ),
                  ),
                ],
              )),
          const SizedBox(height: 24.0),
        ],
      ),
    );
  }
}
