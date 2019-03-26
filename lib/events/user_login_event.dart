import 'package:event_bus/event_bus.dart';

EventBus eventBus = EventBus();

class UserLoginEvent {
  bool isLoginSuccess;

  UserLoginEvent({this.isLoginSuccess});
}
