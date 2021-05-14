import '../../../domain/session/entities.dart';
import '../datasources/models/responses.dart';

class SessionMapper {
  JwtModel toJwt(JWTResponse value) {
    return JwtModel(
      jwt: value.jwt,
      refreshToken: value.refreshToken,
      idToken: value.idToken,
    );
  }
}
