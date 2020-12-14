import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kt_dart/collection.dart';

import '../../../../application/layout/pages/pages_cubit.dart';
import '../../../../domain/layout/entities.dart';
import '../../../models/device_screen_type.dart';
import '../../../widgets/responsive/padding.dart';
import '../../../widgets/responsive/screen_type_layout.dart';
import 'widget_item.dart';

class WidgetsScreen extends StatelessWidget {
  final PageEntity page;

  const WidgetsScreen({
    Key key,
    @required this.page,
  }) : super(key: key);

  Widget _buildMobile(
    BuildContext context,
    DeviceScreenType deviceScreenType,
  ) {
    return GridView.count(
      crossAxisCount: ResponsiveSize.widgetsCrossAxisCount(
        context,
        deviceScreenType,
      ),
      padding: EdgeInsets.all(ResponsiveSize.padding(context)),
      crossAxisSpacing:
          ResponsiveSize.padding(context, size: PaddingSize.small),
      mainAxisSpacing: ResponsiveSize.padding(context, size: PaddingSize.small),
      children: page.widgets
          .map((widget) => WidgetItem(
                key: ValueKey(widget.id),
                widgetEntity: widget,
              ))
          .asList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PageCubit>(
      create: (context) => PageCubit.create(page),
      child: BlocBuilder<PageCubit, PageState>(
        builder: (context, state) {
          return ScreenTypeLayout(
              mobile: _buildMobile(context, DeviceScreenType.Mobile),
              tablet: _buildMobile(context, DeviceScreenType.Tablet));
        },
      ),
    );
  }
}
