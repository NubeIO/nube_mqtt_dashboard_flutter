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

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 5)).then((value) {
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

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
