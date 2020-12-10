import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:kt_dart/collection.dart';

import '../../../models/form_options.dart';

typedef ValueListener<T> = void Function(T value, bool valid);
typedef ValidationCallback<T> = bool Function(T value);

typedef FormValidatorBuilder<T extends FormOption> = Widget Function(
  BuildContext context,
  T value,
  bool isSelected,
  ValueChanged<T> onValueChanged,
);

typedef Child = Widget Function(
  BuildContext context,
  List<Widget> children,
);

class FormMultiSelectBuilder<T extends FormOption> extends StatefulWidget {
  final FormValidatorBuilder<T> itemBuilder;
  final KtList<T> _choices;
  final ValueListener<dartz.Option<KtList<T>>> _validityListener;
  final ValidationCallback<KtList<T>> _validation;
  final Child child;

  const FormMultiSelectBuilder({
    Key key,
    @required KtList<T> choices,
    @required this.itemBuilder,
    @required this.child,
    @required ValidationCallback<KtList<T>> validation,
    ValueListener<dartz.Option<KtList<T>>> validityListener,
  })  : _choices = choices,
        _validityListener = validityListener,
        _validation = validation,
        super(key: key);

  @override
  _FormMultiSelectBuilderState<T> createState() =>
      _FormMultiSelectBuilderState<T>();
}

class _FormMultiSelectBuilderState<T extends FormOption>
    extends State<FormMultiSelectBuilder<T>>
    with AutomaticKeepAliveClientMixin<FormMultiSelectBuilder<T>> {
  KtMutableList<T> _selectedChoices = KtMutableList.empty();

  @override
  void initState() {
    super.initState();
    widget._validityListener(dartz.none(), false);
  }

  @override
  bool get wantKeepAlive => true;

  void _onValueChanged(T input) {
    _selectedChoices.contains(input)
        ? _selectedChoices.remove(input)
        : _selectedChoices.add(input);
    setState(() {
      _selectedChoices = _selectedChoices;
    });
    if (widget._validation(_selectedChoices)) {
      widget._validityListener(dartz.some(_selectedChoices.toList()), true);
    } else {
      widget._validityListener(dartz.none(), false);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child(
      context,
      widget._choices
          .map((choice) => widget.itemBuilder(
                context,
                choice,
                _selectedChoices.contains(choice),
                _onValueChanged,
              ))
          .asList(),
    );
  }
}
