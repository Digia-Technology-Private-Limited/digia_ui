import 'dart:convert';
import 'package:dio/dio.dart';

// Base config data
final validConfigData = {
  'theme': {
    'colors': {
      'light': {'primary': '#000000'}
    },
    'fonts': {'body': 'Roboto'}
  },
  'pages': {'home': {}},
  'rest': {'defaultHeaders': {}},
  'appSettings': {'initialRoute': 'home'},
  'version': 1,
  'versionUpdated': true,
  'functionsFilePath': 'path/to/functions'
};

// JSON stringified versions
final validConfigJson = json.encode({
  'data': {'response': validConfigData}
});

final minimalConfigJson = json.encode({
  'data': {'response': minimalConfigData}
});

final invalidConfigJson = json.encode({
  'data': {'response': invalidConfigData}
});

// Network response mock helpers
Response createMockResponse(Map<String, dynamic> data, {String? path}) =>
    Response(
        data: {
          'data': {'response': data}
        },
        requestOptions:
            RequestOptions(path: path ?? '/config/getAppConfigRelease'));

final minimalConfigData = {
  'theme': {
    'colors': {'light': {}},
    'fonts': {}
  },
  'pages': {},
  'rest': {'defaultHeaders': {}},
  'appSettings': {'initialRoute': 'home'}
};

final invalidConfigData = {
  'theme': 'invalid',
  'pages': {},
  'rest': {},
  'appSettings': {'initialRoute': 'home'}
};
