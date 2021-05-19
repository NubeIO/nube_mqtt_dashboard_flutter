part of entities;

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    @required String uuid,
    @required String firstName,
    @required String lastName,
    @required String email,
    @required String username,
    @required UserVerificationState state,
  }) = _UserModel;
}

enum UserVerificationState { VERIFIED, UNVERIFIED }
