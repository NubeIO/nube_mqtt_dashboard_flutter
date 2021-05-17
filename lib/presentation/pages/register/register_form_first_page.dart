import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/register/register_cubit.dart';
import '../../../domain/forms/non_empty_validation.dart';
import '../../widgets/form_elements/customized/customized_inputs.dart';
import '../../widgets/responsive/padding.dart';

class RegisterFormFirstPage extends StatelessWidget {
  const RegisterFormFirstPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final FocusScopeNode _node = FocusScopeNode();

    Widget _formFirstNameInput(BuildContext context) {
      return FormStringInput(
        validation: NonEmptyValidation(
          mapper: (failure) => failure.when(
            empty: () => "First Name is required and can't be empty",
          ),
        ),
        label: "First Name",
        keyboardType: TextInputType.name,
        initialValue: context.watch<RegisterCubit>().state.firstName,
        onChanged: context.watch<RegisterCubit>().setFirstName,
        onEditingComplete: _node.nextFocus,
      );
    }

    Widget _formLastNameInput(BuildContext context) {
      return FormStringInput(
        validation: NonEmptyValidation(
          mapper: (failure) => failure.when(
            empty: () => "Last Name is required and can't be empty",
          ),
        ),
        label: "Last Name",
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.done,
        initialValue: context.watch<RegisterCubit>().state.lastName,
        onChanged: context.watch<RegisterCubit>().setLastName,
      );
    }

    Widget _buildMainInputs(BuildContext context) {
      return Form(
        child: FocusScope(
          node: _node,
          child: Column(
            children: [
              _formFirstNameInput(context),
              _formLastNameInput(context),
            ],
          ),
        ),
      );
    }

    return BlocBuilder<RegisterCubit, RegisterState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: ResponsiveSize.padding(
                context,
                size: PaddingSize.small,
              ),
            ),
            FormPadding(
              child: Text(
                "Register",
                style: textTheme.headline1,
              ),
            ),
            FormPadding(
              child: Text(
                "We'll need some basic info.",
                style: textTheme.bodyText1,
              ),
            ),
            SizedBox(
              height: ResponsiveSize.padding(
                context,
                size: PaddingSize.large,
              ),
            ),
            _buildMainInputs(context)
          ],
        );
      },
    );
  }
}
