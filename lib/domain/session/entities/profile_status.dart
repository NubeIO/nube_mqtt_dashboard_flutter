part of entities;

enum ProfileStatusType { PROFILE_EXISTS, NEEDS_VERIFICATION, LOGGED_OUT }

extension ProfileStatusTypeExtension on ProfileStatusType {
  String get name => toString();
}
