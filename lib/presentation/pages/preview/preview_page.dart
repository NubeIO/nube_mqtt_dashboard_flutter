import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/preview/preview_cubit.dart';
import '../../../application/validation/value_object.dart';
import '../../../injectable/injection.dart';
import '../../themes/nube_theme.dart';
import '../../widgets/form_elements/builder/form_bool_builder.dart';
import '../../widgets/form_elements/builder/form_color_builder.dart';
import '../../widgets/form_elements/builder/form_option_builder.dart';
import '../../widgets/form_elements/checkbox_input.dart';
import '../../widgets/form_elements/color_input.dart';
import '../../widgets/responsive/master_layout.dart';
import '../../widgets/responsive/padding.dart';
import '../../widgets/responsive/screen_type_layout.dart';
import 'models/theme_option.dart';
import 'widgets/demo_layout.dart';
import 'widgets/theme_selection.dart';

class PreviewPage extends StatefulWidget {
  const PreviewPage({Key key}) : super(key: key);

  @override
  _PreviewPageState createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage>
    with TickerProviderStateMixin {
  final cubit = getIt<PreviewCubit>();
  final bottomHeight = 132.0;
  final heightOfInput = 40;

  void _navigationPop(BuildContext context) {
    ExtendedNavigator.of(context).pop();
  }

  Widget _themeForm(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: ResponsiveSize.padding(
          context,
          size: PaddingSize.large,
        ),
      ),
      child: Column(
        children: [
          _themeSelectionInput(context),
          SizedBox(
            height: ResponsiveSize.padding(
              context,
              size: PaddingSize.large,
            ),
          ),
          Column(
            children: [
              _buildBooleanInput(
                initialValue: cubit.state.brightness,
                label: "Brightness",
                isEnabled: context.watch<PreviewCubit>().enableInput,
                onChanged: (value) {
                  cubit.setBrightness(value);
                },
              ),
              _buildColorInput(
                initialValue: cubit.state.primary,
                label: "Primary",
                isEnabled: context.watch<PreviewCubit>().enableInput,
                onChanged: (value) {
                  cubit.setPrimary(value);
                },
              ),
              _buildColorInput(
                initialValue: cubit.state.primaryLight,
                label: "Primary Light",
                isEnabled: context.watch<PreviewCubit>().enableInput,
                onChanged: (value) {
                  cubit.setPrimaryLight(value);
                },
              ),
              _buildColorInput(
                initialValue: cubit.state.primaryDark,
                label: "Primary Dark",
                isEnabled: context.watch<PreviewCubit>().enableInput,
                onChanged: (value) {
                  cubit.setPrimaryDark(value);
                },
              ),
              _buildColorInput(
                initialValue: cubit.state.secondary,
                label: "Secondary",
                isEnabled: context.watch<PreviewCubit>().enableInput,
                onChanged: (value) {
                  cubit.setSecondary(value);
                },
              ),
              _buildColorInput(
                initialValue: cubit.state.secondaryLight,
                label: "Secondary Light",
                isEnabled: context.watch<PreviewCubit>().enableInput,
                onChanged: (value) {
                  cubit.setSecondaryLigh(value);
                },
              ),
              _buildColorInput(
                initialValue: cubit.state.secondaryDark,
                label: "Secondary Dark",
                isEnabled: context.watch<PreviewCubit>().enableInput,
                onChanged: (value) {
                  cubit.setSecondaryDark(value);
                },
              ),
              _buildColorInput(
                initialValue: cubit.state.background,
                label: "Background",
                isEnabled: context.watch<PreviewCubit>().enableInput,
                onChanged: (value) {
                  cubit.setBackground(value);
                },
              ),
              _buildColorInput(
                initialValue: cubit.state.surface,
                label: "Surface",
                isEnabled: context.watch<PreviewCubit>().enableInput,
                onChanged: (value) {
                  cubit.setSurface(value);
                },
              ),
              _buildColorInput(
                initialValue: cubit.state.error,
                label: "Error",
                isEnabled: context.watch<PreviewCubit>().enableInput,
                onChanged: (value) {
                  cubit.setError(value);
                },
              ),
              _buildColorInput(
                initialValue: cubit.state.onPrimary,
                label: "onPrimary",
                isEnabled: context.watch<PreviewCubit>().enableInput,
                onChanged: (value) {
                  cubit.setOnPrimary(value);
                },
              ),
              _buildColorInput(
                initialValue: cubit.state.onSecondary,
                label: "onSecondary",
                isEnabled: context.watch<PreviewCubit>().enableInput,
                onChanged: (value) {
                  cubit.setOnSecondary(value);
                },
              ),
              _buildColorInput(
                initialValue: cubit.state.onBackground,
                label: "onBackground",
                isEnabled: context.watch<PreviewCubit>().enableInput,
                onChanged: (value) {
                  cubit.setOnBackground(value);
                },
              ),
              _buildColorInput(
                initialValue: cubit.state.onSurface,
                label: "onSurface",
                isEnabled: context.watch<PreviewCubit>().enableInput,
                onChanged: (value) {
                  cubit.setOnSurface(value);
                },
              ),
              _buildColorInput(
                initialValue: cubit.state.onError,
                label: "onError",
                isEnabled: context.watch<PreviewCubit>().enableInput,
                onChanged: (value) {
                  cubit.setOnError(value);
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _themeSelectionInput(BuildContext context) {
    final themes = [
      ThemeOption.defaultTheme(),
      ThemeOption.dark(),
      ThemeOption.custom(cubit.customThemeData),
    ];

    return FormOptionBuilder<ThemeOption>(
      initialValue: ThemeOption.map(cubit.state.theme),
      builder: (
        builder,
        state,
        callback,
        selected,
      ) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SizedBox(
                width: ResponsiveSize.padding(
                  context,
                ),
              ),
              ...themes.map(
                (e) => Selection(
                  theme: e.theme,
                  selected: e.id == ThemeOption.map(cubit.state.theme).id,
                  onTap: () => callback(e),
                ),
              ),
              SizedBox(
                width: ResponsiveSize.padding(
                  context,
                ),
              ),
            ],
          ),
        );
      },
      validityListener: (value, valid) {
        cubit.onThemeChange(value);
      },
    );
  }

  Widget _buildFloatingSaveButton(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: cubit.submit,
      label: const Text("Save"),
    );
  }

  Widget _buildBottomSheet(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final bottomPercent = bottomHeight / height;
    final maxPercent = (height - AppBar().preferredSize.height) / height;
    return SafeArea(
      child: DraggableScrollableSheet(
        minChildSize: bottomPercent,
        initialChildSize: bottomPercent,
        maxChildSize: maxPercent,
        builder: (context, controller) {
          return Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                ),
              ),
              SingleChildScrollView(
                controller: controller,
                child: _themeForm(context),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PreviewCubit>(
      create: (context) => cubit,
      child: BlocConsumer<PreviewCubit, PreviewState>(
        listener: (context, state) {
          state.setState.maybeMap(
            orElse: () {},
            success: (_) => _navigationPop(context),
          );
        },
        builder: (context, state) {
          return Theme(
            data: NubeTheme(NubeTheme.map(state.theme)).themeData,
            child: Scaffold(
              body: ScreenTypeLayout(
                mobile: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: bottomHeight - 32),
                      child: Scaffold(
                        body: DemoWidget(
                          actions: [
                            FlatButton(
                              onPressed: cubit.submit,
                              child: const Text("Save"),
                            )
                          ],
                        ),
                      ),
                    ),
                    _buildBottomSheet(context)
                  ],
                ),
                tablet: MasterLayout(
                  width: 300,
                  master: Scaffold(
                    body: SingleChildScrollView(child: _themeForm(context)),
                    floatingActionButton: _buildFloatingSaveButton(context),
                  ),
                  detail: Container(
                    decoration: BoxDecoration(border: Border.all()),
                    child: const DemoWidget(),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget _buildBooleanInput({
  @required String label,
  @required ValueObject<bool> initialValue,
  @required void Function(ValueObject<bool> value) onChanged,
  @required bool isEnabled,
}) {
  return FormBooleanBuilder(
    builder: (context, value, state, onValueChanged) {
      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveSize.padding(
            context,
            size: PaddingSize.medium,
          ),
          vertical: ResponsiveSize.padding(
            context,
            size: PaddingSize.xsmall,
          ),
        ),
        child: SwitchInput(
          label: label,
          isEnabled: isEnabled,
          onValueChanged: onValueChanged,
          isError: state.maybeWhen(
            error: (_) => true,
            orElse: () => false,
          ),
          isCheck: value.getOrCrash(),
        ),
      );
    },
    initialValue: initialValue,
    validityListener: (value, valid) {
      onChanged(value);
    },
  );
}

Widget _buildColorInput({
  @required String label,
  @required ValueObject<int> initialValue,
  @required void Function(ValueObject<int> value) onChanged,
  @required bool isEnabled,
}) {
  return FormColorBuilder(
    builder: (context, value, state, onValueChanged) {
      return ColorInput(
        currentColor: Color(initialValue.getOrCrash()),
        label: label,
        isEnabled: isEnabled,
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveSize.padding(
            context,
            size: PaddingSize.medium,
          ),
          vertical: ResponsiveSize.padding(
            context,
            size: PaddingSize.xsmall,
          ),
        ),
        onValueChanged: (Color value) {
          onValueChanged(value);
        },
      );
    },
    initialValue: initialValue,
    validityListener: (value, valid) {
      onChanged(value);
    },
  );
}
