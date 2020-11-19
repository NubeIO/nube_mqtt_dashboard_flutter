import 'package:flutter/material.dart';

import '../../../application/validation/value_validation_state.dart';
import '../icons/close.dart';
import '../icons/success.dart';

class InputStateWidget extends StatelessWidget {
  final ValueValidationState _validationState;
  const InputStateWidget({Key key, ValueValidationState validationState})
      : _validationState = validationState,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, 8.0),
      child: SizedBox(
        height: 24,
        width: 24,
        child: _validationState.when(
          initial: () => Container(),
          loading: () => const Padding(
            padding: EdgeInsets.all(2.0),
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          ),
          success: (_) => SuccessIcon(
            color: Theme.of(context).colorScheme.secondary,
          ),
          error: (error) => CloseIcon(color: Theme.of(context).errorColor),
        ),
      ),
    );
  }
}
