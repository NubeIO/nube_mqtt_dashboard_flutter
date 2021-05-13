part of entities;

@freezed
abstract class JwtModel with _$JwtModel {
  const factory JwtModel({
    @required String jwt,
    @required String refreshToken,
    @required String idToken,
  }) = _JwtModel;
}
