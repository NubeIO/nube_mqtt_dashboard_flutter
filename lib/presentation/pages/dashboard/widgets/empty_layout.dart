import 'dart:async';

import 'package:flutter/material.dart';

import '../../../widgets/animated/illustration_empty_layout.dart';
import '../../../widgets/responsive/padding.dart';
import '../../../widgets/text/page_info_widget.dart';

class EmptyLayout extends StatefulWidget {
  const EmptyLayout({
    Key key,
  }) : super(key: key);

  @override
  _EmptyLayoutState createState() => _EmptyLayoutState();
}

class _EmptyLayoutState extends State<EmptyLayout> {
  bool isLoading = true;
  StreamSubscription _subscription;

  @override
  void initState() {
    _subscription = Future.delayed(
      const Duration(seconds: 5),
    ).asStream().listen((value) {
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.all(ResponsiveSize.padding(
            context,
            size: PaddingSize.medium,
          )),
          child: const AspectRatio(
            aspectRatio: 1,
            child: EmptyLayoutIllustration(
              size: Size.infinite,
            ),
          ),
        ),
        SizedBox(
          height: ResponsiveSize.padding(
            context,
            size: PaddingSize.medium,
          ),
        ),
        if (isLoading)
          const PageInfoText(
            title: "Loading",
            subtitle: "",
          )
        else
          const PageInfoText(
            title: "No Layout",
            subtitle: "Seems you don't have a layout.\nPlease try again later.",
          ),
        SizedBox(
          height: ResponsiveSize.padding(
            context,
            size: PaddingSize.xlarge,
          ),
        ),
      ],
    );
  }
}
