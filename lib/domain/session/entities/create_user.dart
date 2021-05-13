part of entities;

@freezed
abstract class CreateUserEntity with _$CreateUserEntity {
  const factory CreateUserEntity({
    @required String firstName,
    @required String lastName,
    @required String email,
    @required String password,
    @required String username,
  }) = _CreateUserEntity;
}
