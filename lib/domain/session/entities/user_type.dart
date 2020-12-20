part of entities;

enum UserType { USER, ADMIN }

extension UserTypeExtension on UserType {
  String get name => toString();
}
