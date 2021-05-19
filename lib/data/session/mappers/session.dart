import '../../../domain/session/entities.dart';
import '../datasources/models/responses.dart';

class SessionMapper {
  JwtModel toJwt(JWTResponse value) {
    return JwtModel(
      accessToken: value.accessToken,
      tokenType: value.tokenType,
    );
  }
}
