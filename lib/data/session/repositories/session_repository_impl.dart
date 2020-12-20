import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/session/session_repository_interface.dart';
import '../managers/session_preference.dart';

@LazySingleton(as: ISessionRepository)
class ProwdlySessionRepositoryImpl extends ISessionRepository {
  final SessionPreferenceManager _sessionPreferenceManager;

  bool _hasValidated = false;

  ProwdlySessionRepositoryImpl(this._sessionPreferenceManager) {
    _hasValidated = _sessionPreferenceManager.isUserPinSet;
  }

  @override
  Future<bool> hasValidated() async {
    return _hasValidated;
  }

  @override
  Future<SessionType> getSessionType() async {
    return _sessionPreferenceManager.status;
  }

  @override
  Future<bool> isUserPinSet() async {
    return _sessionPreferenceManager.isUserPinSet;
  }

  @override
  Future<bool> isAdminPinSet() async {
    return _sessionPreferenceManager.isAdminPinSet;
  }

  @override
  Future<Option<PinConfiguration>> getPinConfiguration() async {
    if (_sessionPreferenceManager.adminPin.isEmpty &&
        _sessionPreferenceManager.pin.isEmpty) {
      return const None();
    }
    return Some(
      PinConfiguration(
        adminPin: _sessionPreferenceManager.adminPin,
        userPin: _sessionPreferenceManager.pin,
      ),
    );
  }

  @override
  Future<Either<CreatePinFailure, Unit>> createPins({
    @required String adminPin,
    @required String userPin,
  }) async {
    try {
      _sessionPreferenceManager.status = SessionType.REQUIRES_PIN;
      _sessionPreferenceManager.adminPin = adminPin;
      _sessionPreferenceManager.pin = userPin;
      return const Right(unit);
    } catch (e) {
      return const Left(CreatePinFailure.unexpected());
    }
  }

  @override
  Future<Either<CreatePinFailure, Unit>> createUserPin(
    Option<String> pin,
  ) async {
    try {
      _sessionPreferenceManager.status = SessionType.REQUIRES_PIN;
      _sessionPreferenceManager.pin = pin.getOrElse(() => "");
      return const Right(unit);
    } catch (e) {
      return const Left(CreatePinFailure.unexpected());
    }
  }

  @override
  Future<Either<CreatePinFailure, Unit>> createAdminPin(String pin) async {
    try {
      _sessionPreferenceManager.status = SessionType.REQUIRES_PIN;
      _sessionPreferenceManager.adminPin = pin;
      return const Right(unit);
    } catch (e) {
      return const Left(CreatePinFailure.unexpected());
    }
  }

  @override
  Future<Either<ValidatePinFailure, UserType>> validatePin(String pin) async {
    try {
      if (_sessionPreferenceManager.adminPin == pin) {
        _sessionPreferenceManager.status = SessionType.REQUIRES_PIN;
        _hasValidated = true;
        return const Right(UserType.ADMIN);
      } else if (_sessionPreferenceManager.pin == pin) {
        _sessionPreferenceManager.status = SessionType.REQUIRES_PIN;
        _hasValidated = true;
        return const Right(UserType.USER);
      }
    } catch (e) {
      return const Left(ValidatePinFailure.unexpected());
    }

    return const Left(ValidatePinFailure.invalidPin());
  }

  @override
  Future<Either<LogoutFailure, Unit>> logout() async {
    try {
      _sessionPreferenceManager.clearData();
      return const Right(unit);
    } catch (e) {
      return const Left(LogoutFailure.unexpected());
    }
  }
}
