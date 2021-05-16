import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../routes/router.dart';
import '../../widgets/animated/illustration_onboarding.dart';
import '../../widgets/responsive/padding.dart';
import '../../widgets/text/clickable_text_span.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({Key key}) : super(key: key);

  void _onNavigateToRegister(BuildContext context) {
    ExtendedNavigator.of(context).pushHostPage();
  }

  void _onNavigateToLogin(BuildContext context) {
    ExtendedNavigator.of(context).pushHostPage(isRegistrationStep: false);
  }

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
          SizedBox(
            height: ResponsiveSize.padding(
              context,
              size: PaddingSize.xlarge,
            ),
          ),
          TextButton(
            onPressed: () => _onNavigateToRegister(context),
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
          SizedBox(
            height: ResponsiveSize.padding(
              context,
              size: PaddingSize.medium,
            ),
          ),
          ClickableTextSpan(
              textSelection: const TextSelection(
                baseOffset: 29,
                extentOffset: 39,
              ),
              onTap: () => _onNavigateToLogin(context),
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
          SizedBox(
            height: ResponsiveSize.padding(
              context,
              size: PaddingSize.xlarge,
            ),
          ),
        ],
      ),
    );
  }
}
