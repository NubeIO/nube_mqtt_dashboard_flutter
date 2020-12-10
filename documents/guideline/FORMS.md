# Forms 

## Validation 

All input form validations should extends `IValidation<Failure, Output>`, where `Failure` represents a union extending `Failure` and `Output` is dynamic. 

This interface takes in a `ValidationMapper<Failure>` which helps in mapping `Failure` to `String` that can be shown in the presentation layer. 

Necessary methods can be overridden as required and should follow functional programming principles. 

Example: 

````dart

class GenderValidation extends IValidation<GenderFailure, Gender> {
GenderValidation(ValidationMapper<GenderFailure> mapper) : super(mapper);
  
  @override
  Future<Either<GenderFailure, Gender>> validate(String input) async {
   ...
  }
}
````

In the above example the validation would test for a valid gender and return a `Gender` object for valid cases. 

The `Failure` should be created through a freezed union (use snippet `funion`) and then extended with `Failure` This is helpful in listing out all the possible failures. 

Example 

```dart

@freezed
abstract class PasswordFailure extends Failure with _$PasswordFailure {
  const factory PasswordFailure.length() = _TooShort;
  const factory PasswordFailure.weak() = _Weak;
  const factory PasswordFailure.passwordMismatch() = _PasswordMismatch;
}


```

---

## ValueValidationState

This is a union class that describes all the states a validation, an input in the form field can have. It will one of the following states

1.  **ValueValidationState.initial**
The initial state when the user hasn't interacted with the input. 

1.  **ValueValidationState.loading**
This state represents that the input has some kind of long running validation, for example: contacting the server. 

1. **ValueValidationState.success**
This returns the success state and contains a transformed input as its field. 

1. **ValueValidationState.error**
This returns the error state and contains a error message as its field. 


The above class is a `Union/Sealed` class which means it supports some of the built-in methods which helps in decision tree. For more details look into [freezed](/documents/OVERVIEW.md#freezed).

For example. 

```dart
/// * using all the possible states to map results. 
validationState.when(
  initial: () => Container(),
  loading: () => const Padding(
  padding: EdgeInsets.all(4.0),
    child: CircularProgressIndicator(
      strokeWidth: 2,
    ),
  ),
  success: (dynamic input) => Icon(Icons.check),
  error: (String error) => Icon(Icons.close),
);

/// * using only the success state and reverting to orElse.  
validationState.maybeWhen(
  success: (_) => Icon(Icons.check),
  orElse: () => Container(),
);

/// * Pretty similar to when but an instance of the state is returned. In `when` we get the fields as arguments.
validationState.map(
  initial: (Initial initial) => Container(),
  loading: (Loading loading) => const Padding(
    padding: EdgeInsets.all(4.0),
    child: CircularProgressIndicator(
      strokeWidth: 2,
    ),
  ),
  success: (Success success) => Icon(Icons.check),
  error: (Error error) => Icon(Icons.close),
);

/// * using only the success state and reverting to orElse.  
validationState.maybeMap(
  success: (Success success) => Icon(Icons.check),
  orElse: () => Container(),
);


```

---


## Form Builder

We have a few helpers to help manage, validate and transform the inputs in a form. The structures are similar in the implementation except for a key differences. 

Please go through each of them as your requirements. 

### FormTextBuilder

This helps in maintaining text inputs state. The structure for this looks is as follows, `FormTextBuilder<Output>` where the `Output` part represents the output that the builder would transform into. 

The `FormTextBuilder` requires a `builder` and  a `validation` to be passes in as named constructors. 

The `builder` is a `Function` which returns you the following and expects a `Widget`.

- `BuildContext`
- Current `ValueValidationState` 
- Callback `onValueChanged` which you should call when the input changes. 

`validation` expects a `IValidation<Failure, Output>` which we discussed earlier. 

`validityListener` is the last optional argument which returns the result of the validation. The first parameter is a `Option<Output>` i.e. it only returns a output for valid cases otherwise returns a `none()`. The second parameter is a bool which states the validity in boolean terms, i.e. true for `ValueValidationState.success`, false otherwise.

Example

```dart
FormTextBuilder<String>(
  /// Expects a IValidation interface.
  validation: EmailValidation((failure) {
    return failure.when(
        invalidEmail: () => "Invalid Email",
        emailTaken: () => "Email Taken",
      );
    }),
  builder: (
    BuildContext context,
    /// Current validation state
    ValueValidationState validationState, 
    /// Callback for when the value changes
    void Function(String) onValueChanged,
  ) {
    return CustomTextInput(
      validationState: validationState,
      onValueChanged: onValueChanged,
      );
    },
  validityListener: (
    /// Optional value that returns some(String) on valid results, none() other
    Option<String> value, 
    /// `true` if valid, `false` otherwise
    bool valid,
  ) {
    print(value)
  },
);
```

This will validate to see if the input is a valid email, returns the state depending on the input provided with `onValueChanged`. 


## FormOptionBuilder

This helps in maintaining dropdown inputs state. The structure for this looks is as follows, `FormOptionBuilder<Type>` where the `Type` part represents the data class. Its takes only inputs of class `Type` and returns the same. 

`Type` should extend `FormOption` which expects a `id` which acts as a key and a `label` to be displayed in the UI. 

The `FormOptionBuilder` requires a `builder` to be passes in as named constructors. 

The `builder` is a `Function` which returns you the following and expects a `Widget`.

- `BuildContext`
- Current `ValueValidationState` 
- Callback `onValueChanged` which you should call when the input changes. 
- `selectedValue` of the type `Type` provided in generics. This represents the current selected option and should be used accordingly. 


`validityListener` is the other optional argument which returns the result of the validation. The first parameter is a `Option<Type>` i.e. it only returns a output for valid cases otherwise returns a `none()`. The second parameter is a bool which states the validity in boolean terms, i.e. true if something is selected of the state is `ValueValidationState.success`. 

Example

```dart
FormOptionBuilder<Gender>(
  builder: (
    BuildContext context, 
    /// Current validation state
    ValueValidationState validationState, 
    /// Callback for when the value changes
    ValueChanged<Gender> onValueChanged, 
    // The current selected value
    Gender selectedValue
  ) {
    return OptionSelector(
      selectedValue: selectedValue,
      onValueChanged: onValueChanged,
      validationState: validationState,
      options: [
        /// List of Gender objects
      ],
    );
  },
  validityListener: (
    /// Optional value that returns some(String) on valid results, none() other
    Option<Gender> value, 
    /// `true` if valid, `false` otherwise
    bool valid,
  ) {
    print(value);
  },
);

```
This will validate to see if the input is a valid one, returns the state depending on the input provided with `onValueChanged`. 


## FormMultiSelectBuilder

This helps in maintaining multiple selection or chips inputs state. The structure for this looks is as follows `FormMultiSelectBuilder<Type>` where the `Type` part represents the data class. Its takes only inputs of class `Type` and returns the same. 

`Type` should extend `FormOption` which expects a `id` which acts as a key and a `label` to be displayed in the UI. 

The `FormMultiSelectBuilder` requires `choices`, `itemBuilder`, `child` and a `validation` to be passes in as named constructors. 

`choices` expects a list of `Type`, through which the `itemBuilder` would iterate for creating the widgets and their selection state.
 
The `itemBuilder` is a `Function` which returns you the following and expects a `Widget`.

- `BuildContext`
- `value` of type `Type`. 
- `isSelected` that signifies a selection.
- Callback `onValueChanged` which you should call when the selection changes. 


The `child` is a `Function` which returns you the following and expects a `Widget`.
- `BuildContext`
- `children` which is a list of `Widget` which have gone through `itemBuilder`

`validityListener` is the other optional argument which returns the result of the validation. The first parameter is a `Option<Type>` i.e. it only returns a output for valid cases otherwise returns a `none()`. The second parameter is a bool which states the validity in boolean terms, i.e. true if something is selected of the state is 
`ValueValidationState.success`. 

Example :

```dart

FormChipBuilder<Interest>(
  /// The list of choices to iterate the child through and manage in state
  choices: [
    Interest("Books"),
    Interest("Games"),
    Interest("Coding"),
    Interest("Business"),
    Interest("Stocks"),
  ],
  itemBuilder: (
    BuildContext context, 
    /// The option to build the `Widget` for
    Interest value, 
    /// `true` signifies the item is selected
    bool isSelected, 
    /// Callback for when the value changes
    ValueChanged<Interest> onValueChanged,
  ) {
    return ChoiceChip(
      label: Text(value.label),
      selected: isSelected,
      onSelected: (_) => onValueChanged(value),
    );
  },
  child: (
    BuildContext context, 
    /// List of children that are created by iterating through `choices` and mapped with `itemBuilder`
    List<Widget> children,
  ) {
    return Wrap(
      children: children,
    );
  },
  validityListener: (
    /// Optional value that returns some(String) on valid results, none() other
    Option<List<Interest>> value, 
    /// `true` if valid, `false` otherwise
    bool valid
  ) {
    print(value.toString());
  },
  validation: (
    /// Get the validation based on the current selection.
    List<Interest> value,
  ) => value.size == 3,
);

class Interest extends FormOption {
  Interest(String label) : super(id: label, label: label);
}

```


