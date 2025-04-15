import 'package:dio/dio.dart';
import '../framework/state/state_observer.dart';

class DUIInspector {
  StateObserver? stateObserver;
  List<Interceptor>? dioInterceptors;

  DUIInspector({this.stateObserver, this.dioInterceptors});
}
