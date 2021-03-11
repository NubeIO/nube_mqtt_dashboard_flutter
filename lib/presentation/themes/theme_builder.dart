import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../application/theme/theme_cubit.dart';
import '../../injectable/injection.dart';
import '../../utils/logger/log.dart';
import 'nube_theme.dart';
import 'theme_interface.dart';

const _TAG = "ThemeChangeBuilder";
typedef ThemeChangeBuilder = Widget Function(
    BuildContext context, ITheme theme);

class ThemeBuilder extends StatelessWidget {
  final ThemeChangeBuilder builder;
  const ThemeBuilder({Key key, this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ThemeCubit>(
      create: (context) => getIt<ThemeCubit>(),
      child: BlocConsumer<ThemeCubit, ThemeState>(
        listener: (context, state) {
          Log.i("Theme changed sucessfully", tag: _TAG);
        },
        builder: (context, state) => builder(
          context,
          NubeTheme.map(state.theme),
        ),
      ),
    );
  }
}
