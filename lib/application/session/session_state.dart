part of 'session_cubit.dart';

@freezed
abstract class SessionState with _$SessionState {
  const factory SessionState.initial() = _Initial;
  const factory SessionState.authenticated() = _Authenticated;
  const factory SessionState.validatePin() = _ValidatePin;
  const factory SessionState.needsVerification() = _NeedsVerificationState;
  const factory SessionState.loggedOut() = _LoggedOutState;
}
