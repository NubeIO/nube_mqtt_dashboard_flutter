part of 'verification_cubit.dart';

@freezed
abstract class VerificationState with _$VerificationState {
  const factory VerificationState({
    @required ProfileStatusType status,
  }) = _Initial;

  factory VerificationState.initial() => VerificationState(
        status: ProfileStatusType.NEEDS_VERIFICATION,
      );
}
