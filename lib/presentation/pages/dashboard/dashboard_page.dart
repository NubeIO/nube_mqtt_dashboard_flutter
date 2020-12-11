import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/layout/layout_cubit.dart';
import '../../../injectable/injection.dart';

class DashboardPage extends StatelessWidget {
  final cubit = getIt<LayoutCubit>();

  DashboardPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LayoutCubit, LayoutState>(
      cubit: cubit,
      listener: (context, state) {},
      builder: (context, state) {
        return const Placeholder();
      },
    );
  }
}
