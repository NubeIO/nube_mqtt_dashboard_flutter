import '../../../domain/user/entities.dart';
import '../datasources/models/responses.dart';

class UserMapper {
  UserModel toUser(UserResponse response) {
    return UserModel(
      uuid: response.uuid,
      firstName: response.firstName,
      lastName: response.lastName,
      email: response.email,
      username: response.username,
      state: toVerificationStatus(response.state),
    );
  }

  UserVerificationState toVerificationStatus(String state) {
    if (state.toLowerCase() == "verified") {
      return UserVerificationState.UNVERIFIED;
    }
    return UserVerificationState.VERIFIED;
  }
}
