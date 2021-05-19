part of entities;

@freezed
abstract class JwtModel with _$JwtModel {
  const factory JwtModel({
    @required String tokenType,
    @required String accessToken,
  }) = _JwtModel;
}
