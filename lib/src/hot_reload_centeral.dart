import 'dart:async';

import 'package:socket_io_client/socket_io_client.dart' as io;

import '../digia_ui.dart';

class HotReloadCentral {
  static final HotReloadCentral _instance = HotReloadCentral._internal();

  factory HotReloadCentral() => _instance;

  HotReloadCentral._internal();

  final StreamController<String> _configStreamController =
      StreamController.broadcast();
  io.Socket? _socket;

  Stream<String> get configStream => _configStreamController.stream;

  Future<void> initialize() async {
    _connectSocket();
  }

  void _addListener() {
    _socket?.emit('join_room', {
      'id':
          '${DigiaUIClient.instance.accessKey}_${(DigiaUIClient.instance.flavorInfo as Debug).branchName}',
      'roomType': 'dashboard_app_room',
    });

    _socket?.on('room_message', (data) async {
      if (data['message']['action'] == 'hot_reload' &&
          (data['message']['socketIds'] as List).contains(_socket?.id)) {
        print('Reloading myself');
        await DigiaUIClient.reloadConfig(
          flavorInfo: (DigiaUIClient.instance.flavorInfo),
        );
        updateConfig('pageId');
      }
    });

    _socket?.on('error', (data) {
      print('Socket error: $data');
    });
  }

  void _connectSocket() {
    if (_socket != null) return;
    _socket = io.io(
        DigiaUIClient.instance.baseUrl.replaceFirst('/api/v1', ''),
        <String, dynamic>{
          'auth': {'clientType': 'app'},
        });
    // _socket?.emit('disconnect');
    _socket?.disconnect();
    _socket?.clearListeners();

    _socket?.connect();

    _socket?.on('connect', (_) {
      print('Connected to WebSocket');
      print('Socket ID: ${_socket?.id}');
      _addListener();
    });

    _socket?.on('disconnect', (reason) {
      _socket?.clearListeners();
      _socket?.on('connect', (_) {
        _addListener();
      });
      if (reason == 'io server disconnect') {
        _socket?.connect();
      }
    });
  }

  Future<void> updateConfig(String pageId) async {
    _configStreamController.add(pageId);
  }

  void dispose() {
    _socket?.dispose();
    _configStreamController.close();
  }
}
