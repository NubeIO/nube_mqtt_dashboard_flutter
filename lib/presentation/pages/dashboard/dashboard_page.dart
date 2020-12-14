import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/layout/layout_cubit.dart';
import '../../../domain/layout/failures.dart';
import '../../../generated/i18n.dart';
import '../../../injectable/injection.dart';
import '../../widgets/responsive/drawer_detail_layout.dart';
import '../../widgets/responsive/snackbar.dart';

class DashboardPage extends StatelessWidget {
  final cubit = getIt<LayoutCubit>();

  DashboardPage({Key key}) : super(key: key);

  void _onFailure(BuildContext context, LayoutFailure failure) {
    final snackbar = ResponsiveSnackbar.build(
      context,
      content: Text(
        failure.when(
            unexpected: () => I18n.of(context).failureGeneric,
            invalidLayout: () =>
                "Opps! The layout doesn't seem to be valid. Please contact ."),
        style: Theme.of(context)
            .textTheme
            .bodyText1
            .copyWith(color: Theme.of(context).errorColor),
      ),
    );
    Scaffold.of(context).showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<LayoutCubit, LayoutState>(
        cubit: cubit,
        listener: (context, state) {
          state.layoutState.maybeWhen(
              failure: (failure) {
                _onFailure(context, failure);
              },
              orElse: () {});
        },
        builder: (context, state) {
          final list = state.layoutBuilder.pages;
          return DrawerDetailLayout(
            appBarBuilder: (context, index) {
              return AppBar(
                elevation: 8,
                title: Text(list[index].name),
              );
            },
            detailBuilder: (context, selectedIndex) {
              return Container();
            },
            itemBuilder: (context, index, selected, onTapCallback) {
              return ListTile(
                selected: selected,
                onTap: () => onTapCallback(index),
                title: Text(list[index].name),
              );
            },
            itemCount: list.size,
          );
        },
      ),
    );
  }
}
