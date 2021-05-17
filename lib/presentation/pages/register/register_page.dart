import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nube_mqtt_dashboard/presentation/pages/register/register_form_last_page.dart';
import 'package:nube_mqtt_dashboard/presentation/pages/register/register_form_second_page.dart';

import '../../../application/register/register_cubit.dart';
import '../../../injectable/injection.dart';
import 'register_form_first_page.dart';

class RegisterPage extends StatelessWidget {
  final _formsPageViewController = PageController();

  RegisterPage({Key key}) : super(key: key);

  void _onNavigateBack(BuildContext context) {
    Navigator.of(context).pop();
  }

  void _nextFormStep(BuildContext context) {
    _formsPageViewController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  void _previousFormStep(BuildContext context) {
    _formsPageViewController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  void _onFabClick(BuildContext context, RegisterState state) {
    state.currentPage.maybeWhen(last: () {
      context.read<RegisterCubit>().register();
    }, orElse: () {
      _nextFormStep(context);
    });
  }

  bool _onWillPop() {
    if (_formsPageViewController.page.round() ==
        _formsPageViewController.initialPage) return true;

    _formsPageViewController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );

    return false;
  }

  Widget _buildBackButton(BuildContext context) {
    return context.watch<RegisterCubit>().state.currentPage.maybeWhen(
          first: () => BackButton(
            onPressed: () => _onNavigateBack(context),
          ),
          orElse: () => BackButton(
            onPressed: () => _previousFormStep(context),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<RegisterCubit>(),
      child: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              leading: _buildBackButton(context),
            ),
            body: PageView.builder(
              controller: _formsPageViewController,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              onPageChanged: (value) {
                context.read<RegisterCubit>().onPageChanged(value);
              },
              itemBuilder: (context, index) {
                return [
                  WillPopScope(
                    onWillPop: () => Future.sync(_onWillPop),
                    child: const RegisterFormFirstPage(),
                  ),
                  WillPopScope(
                    onWillPop: () => Future.sync(_onWillPop),
                    child: const RegisterFormSecondPage(),
                  ),
                  WillPopScope(
                    onWillPop: () => Future.sync(_onWillPop),
                    child: const RegisterFormLastPage(),
                  ),
                ][index];
              },
            ),
            floatingActionButton: context.watch<RegisterCubit>().isValid
                ? FloatingActionButton(
                    onPressed: () => _onFabClick(context, state),
                    child: Icon(
                      state.currentPage.maybeWhen(
                        last: () => Icons.check,
                        orElse: () => Icons.chevron_right_rounded,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}
