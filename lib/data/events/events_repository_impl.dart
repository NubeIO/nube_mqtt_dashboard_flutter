import 'package:injectable/injectable.dart';
import 'package:rxdart/subjects.dart';

import '../../domain/events/events_repository_interface.dart';
import '../../utils/logger/log.dart';

const _TAG = "EventsRepository";

@LazySingleton(as: IEventsRepository)
class EventsRepositoryImpl extends IEventsRepository {
  final PublishSubject<GlobalEvents> _eventsSubject = PublishSubject()
    ..listen((event) {
      Log.i("Global Event $event", tag: _TAG);
    });
  EventsRepositoryImpl();

  @override
  Stream<GlobalEvents> get eventStream => _eventsSubject.stream;

  @override
  Future<Unit> logout() async {
    _eventsSubject.add(GlobalEvents.LOGOUT);
    return unit;
  }
}
