import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/validation/value_object.dart';
import '../../../application/validation/value_validation_bloc.dart';
import '../../../constants/app_constants.dart';
import '../../../domain/forms/length_validation.dart';
import '../form_elements/builder/form_text_builder.dart';
import '../form_elements/pin_input.dart';
import '../responsive/master_layout.dart';
import '../responsive/padding.dart';
import '../responsive/screen_type_layout.dart';

class PinScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final void Function(ValueObject<String> value) _onComplete;

  const PinScreen({
    Key key,
    @required this.title,
    @required this.subtitle,
    @required void Function(ValueObject<String> value) onComplete,
  })  : _onComplete = onComplete,
        super(key: key);

  void _onCompleted(ValueObject<String> value) {
    _onComplete(value);
  }

  Widget _buildMobile(
      BuildContext context, ValueChanged<String> onValueChanged) {
    return Form(
      child: Padding(
        padding: EdgeInsets.all(
          ResponsiveSize.padding(
            context,
            size: PaddingSize.medium,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headline1,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyText2,
            ),
            const SizedBox(height: 32),
            PinInput(
              onValueChanged: onValueChanged,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScaffold(
    BuildContext context,
    ValueChanged<String> onValueChanged,
  ) {
    return Scaffold(
      appBar: AppBar(),
      body: _buildMobile(context, onValueChanged),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: _buildFab(context),
    );
  }

  StatelessWidget _buildFab(
    BuildContext context,
  ) =>
      context.select<ValueValidationBloc<String>, bool>(
              (element) => element.isValid)
          ? FloatingActionButton(
              onPressed: () => _onCompleted(
                  context.read<ValueValidationBloc<String>>().value),
              child: const Icon(Icons.chevron_right),
            )
          : Container();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FormTextBuilder<String>(
        validation: LengthValidation(
          length: AppConstants.PIN_LENGTH,
          mapper: (failure) => failure.when(
            invalidLength: () => "Invalid length for pin.",
          ),
        ),
        builder: (context, _, onValueChanged) {
          return ScreenTypeLayout(
            mobile: _buildScaffold(context, onValueChanged),
            tablet: MasterLayout(
              master: _buildScaffold(context, onValueChanged),
            ),
          );
        },
      ),
    );
  }
}
