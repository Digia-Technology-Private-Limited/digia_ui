import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DUIInspector {
  BlocObserver? blocObserver;
  List<Interceptor>? dioInterceptors;

  DUIInspector({this.blocObserver, this.dioInterceptors});
}
