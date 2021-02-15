import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../../application/layout/pages/pages_cubit.dart';
import '../../../../domain/layout/entities.dart';
import '../../../models/device_screen_type.dart';
import '../../../widgets/responsive/padding.dart';
import '../../../widgets/responsive/screen_type_layout.dart';
import 'widget_item.dart';

const widthCount = 2;

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
    final heightCalc = widthCount * ResponsiveSize.widgetHeight(context);

    return StaggeredGridView.countBuilder(
      crossAxisCount:
          ResponsiveSize.widgetsCrossAxisCount(context, deviceScreenType),
      padding: EdgeInsets.all(ResponsiveSize.padding(context)),
      crossAxisSpacing:
          ResponsiveSize.padding(context, size: PaddingSize.small),
      mainAxisSpacing: ResponsiveSize.padding(context, size: PaddingSize.small),
      itemBuilder: (context, index) {
        final widget = page.widgets[index];
        return WidgetItem(
          key: ValueKey(widget.id),
          widgetEntity: widget,
        );
      },
      itemCount: page.widgets.size,
      staggeredTileBuilder: (index) {
        final widget = page.widgets[index];
        return widget.map(
          gaugeWidget: (_) =>
              StaggeredTile.count(widthCount * 2, heightCalc * 2),
          sliderWidget: (_) {
            return StaggeredTile.count(widthCount * 2, heightCalc);
          },
          switchWidget: (_) => StaggeredTile.count(widthCount, heightCalc),
          valueWidget: (_) => StaggeredTile.count(widthCount, heightCalc),
          switchGroupWidget: (widget) {
            final cellSpan = widget.config.items.size > 1 ? 2 : 1;
            return StaggeredTile.count(widthCount * cellSpan, heightCalc);
          },
          mapWidget: (_) => StaggeredTile.count(widthCount, heightCalc),
          failure: (_) => StaggeredTile.count(widthCount, heightCalc),
        );
      },
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
