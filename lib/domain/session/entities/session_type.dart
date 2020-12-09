part of entities;

enum SessionType { REQUIRES_PIN, CREATE_PIN }

extension SessionTypeExtension on SessionType {
  String get name => toString();
}
