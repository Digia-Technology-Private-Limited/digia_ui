import 'dart:convert';
import 'package:dio/dio.dart';

final Map<String, Object?> validConfigData = {
  'appSettings': <String, String>{'initialRoute': 'homepage'},
  'pages': <String, Object?>{
    'homepage': {
      'uid': 'homepage',
      'actions': {
        'onPageLoadAction': null,
        'onPageLoad': {'type': 'Action.buildPage'},
        'onBackPress': null
      },
      'inputArgs': null,
      'variables': null,
      'layout': {
        'root': {
          'category': 'widget',
          'type': 'fw/scaffold',
          'props': null,
          'containerProps': null,
          'children': {
            'appBar': [
              {
                'category': 'widget',
                'type': 'fw/appBar',
                'props': {
                  'title': {
                    'text': 'Digia Studio',
                    'textStyle': {
                      'fontToken': 'titleLarge',
                      'textColor': '#FFFFFF',
                      'textBgColor': null,
                      'textDecoration': 'none',
                      'textDecorationColor': null,
                      'textDecorationStyle': null
                    }
                  },
                  'elevation': 2,
                  'shadowColor': null,
                  'backgrounColor': '#4945FF',
                  'iconColor': null
                },
                'containerProps': {},
                'children': {},
                'dataRef': null,
                'varName': 'appbar1',
                'initStateDefs': null,
                'componentId': null,
                'componentArgs': {}
              }
            ],
            'body': [
              {
                'category': 'widget',
                'type': 'digia/column',
                'props': {
                  'mainAxisAlignment': {},
                  'crossAxisAlignment': 'start'
                },
                'containerProps': {
                  'visibility': true,
                  'align': 'none',
                  'style': {'padding': '12,0,12,0'},
                  'onClick': null
                },
                'children': {
                  'children': [
                    {
                      'category': 'widget',
                      'type': 'digia/richText',
                      'props': {
                        'textSpans': [
                          {
                            'text': 'Hey! ',
                            'spanStyle': {
                              'fontToken': 'titleLarge',
                              'textColor': '101213'
                            }
                          },
                          {
                            'text': 'Welcome to Digia.',
                            'spanStyle': {
                              'fontToken': 'titleLarge',
                              'textColor': '#4945FF'
                            }
                          }
                        ],
                        'maxLines': null,
                        'overflow': 'clip',
                        'alignment': 'start',
                        'textStyle': {}
                      },
                      'containerProps': {
                        'visibility': true,
                        'align': 'none',
                        'style': {'margin': '0,12,0,12'},
                        'onClick': null
                      },
                      'children': {},
                      'dataRef': null,
                      'varName': 'richtext1',
                      'initStateDefs': null,
                      'componentId': null,
                      'componentArgs': {}
                    },
                    {
                      'category': 'widget',
                      'type': 'digia/image',
                      'props': {
                        'style': {
                          'borderRadius': '0,0,0,0',
                          'bgColor': '#EEEEEE'
                        },
                        'fit': 'cover',
                        'aspectRatio': 2,
                        'imageSrc': 'https://picsum.photos/id/9/400/225',
                        'placeHolder': null,
                        'errorImage': null
                      },
                      'containerProps': {
                        'visibility': true,
                        'align': 'none',
                        'style': {'borderRadius': '4,4,4,4', 'height': '270'},
                        'onClick': null
                      },
                      'children': {},
                      'dataRef': null,
                      'varName': 'image1',
                      'initStateDefs': null,
                      'componentId': null,
                      'componentArgs': {}
                    },
                    {
                      'category': 'widget',
                      'type': 'digia/button',
                      'props': {
                        'text': {
                          'text': 'Click Me!',
                          'maxLines': null,
                          'overflow': 'clip',
                          'alignment': 'start',
                          'textStyle': {
                            'fontToken': {'value': 'titleLarge', 'font': null},
                            'textColor': '#FFFFFF',
                            'textBgColor': null,
                            'textDecoration': 'none',
                            'textDecorationColor': null,
                            'textDecorationStyle': null
                          }
                        },
                        'disabledStyle': {
                          'backgroundColor': null,
                          'disabledTextColor': null,
                          'disabledIconColor': null
                        },
                        'defaultStyle': {
                          'padding': '16,16,16,16',
                          'elevation': 2,
                          'shadowColor': null,
                          'alignment': 'none',
                          'backgroundColor': '#4945FF'
                        },
                        'shape': {
                          'value': 'roundedRect',
                          'borderStyle': 'none',
                          'borderWidth': null,
                          'borderColor': null,
                          'borderRadius': '100,100,100,100'
                        },
                        'leadingIcon': {
                          'iconData': null,
                          'iconSize': null,
                          'iconColor': null
                        },
                        'trailingIcon': {
                          'iconData': null,
                          'iconSize': null,
                          'iconColor': null
                        },
                        'onClick': {
                          'inkWell': true,
                          'steps': [
                            {
                              'disableActionIf': null,
                              'type': 'Action.openUrl',
                              'data': {
                                'url': 'https://www.digia.tech/',
                                'launchMode': null
                              }
                            }
                          ],
                          'analyticsData': null
                        },
                        'isDisabled': false
                      },
                      'containerProps': {
                        'visibility': true,
                        'align': 'none',
                        'style': {
                          'padding': null,
                          'margin': '0,16,0,0',
                          'bgColor': null,
                          'borderStyle': 'none',
                          'borderWidth': null,
                          'borderColor': null,
                          'borderRadius': null,
                          'width': null,
                          'height': null
                        },
                        'onClick': null,
                        'expansion': {'type': 'none', 'flexValue': 1}
                      },
                      'children': {},
                      'dataRef': null,
                      'varName': 'button1',
                      'initStateDefs': null,
                      'componentId': null,
                      'componentArgs': {}
                    }
                  ]
                },
                'dataRef': null,
                'varName': 'column1',
                'initStateDefs': null,
                'componentId': null,
                'componentArgs': {}
              }
            ]
          },
          'dataRef': null,
          'varName': 'scaffold1',
          'initStateDefs': null,
          'componentId': null,
          'componentArgs': null
        }
      }
    }
  },
  'components': <String, Object?>{},
  'rest': <String, dynamic>{'defaultHeaders': {}, 'resources': {}},
  'theme': <String, dynamic>{
    'colors': {
      'light': {
        'primary': '#a39cdd',
        'secondary': '#39d2c0',
        'tertiary': '#ee8b60',
        'alternate': '#ff5963',
        'primarytext': '#101213',
        'secondarytext': '#57636c',
        'primarybackground': '#f1f4f8',
        'secondarybackground': '#ffffff',
        'accent1': '#616161',
        'accent2': '#e0e0e0',
        'accent4': '#eeeeee',
        'success': '#04a24c',
        'error': '#e21c3d',
        'Warning': '#fcdc0c',
        'info': '#1c4494',
        'customcolor1': '#cc12b0',
        'customcolor2': '#205f7d'
      },
      'dark': {
        'primary': '#a39cdd',
        'secondary': '#39d2c0',
        'tertiary': '#ee8b60',
        'alternate': '#ff5963',
        'primarytext': '#101213',
        'secondarytext': '#57636c',
        'primarybackground': '#f1f4f8',
        'secondarybackground': '#ffffff',
        'accent1': '#616161',
        'accent2': '#e0e0e0',
        'accent4': '#eeeeee',
        'success': '#04a24c',
        'error': '#e21c3d',
        'Warning': '#fcdc0c',
        'info': '#1c4494',
        'customcolor1': '#cc12b0',
        'customcolor2': '#205f7d'
      }
    },
    'fonts': {
      'displayLarge': {
        'size': 57,
        'weight': 'regular',
        'font-family': 'Poppins',
        'height': 1.12,
        'style': 'normal'
      },
      'displayMedium': {
        'size': 45,
        'weight': 'regular',
        'font-family': 'Poppins',
        'height': 1.16,
        'style': 'normal'
      },
      'displaySmall': {
        'size': 36,
        'weight': 'regular',
        'font-family': 'Poppins',
        'height': 1.22,
        'style': 'normal'
      },
      'headlineLarge': {
        'size': 38,
        'weight': 'regular',
        'font-family': 'Poppins',
        'height': 1.25,
        'style': 'normal'
      },
      'headlineMedium': {
        'size': 28,
        'weight': 'regular',
        'font-family': 'Poppins',
        'height': 1.29,
        'style': 'normal'
      },
      'headlineSmall': {
        'size': 24,
        'weight': 'regular',
        'font-family': 'Poppins',
        'height': 1.33,
        'style': 'normal'
      },
      'titleLarge': {
        'size': 22,
        'weight': 'regular',
        'font-family': 'Poppins',
        'height': 1.27,
        'style': 'normal'
      },
      'titleMedium': {
        'size': 16,
        'weight': 'medium',
        'font-family': 'Poppins',
        'height': 1.5,
        'style': 'normal'
      },
      'titleSmall': {
        'size': 14,
        'weight': 'medium',
        'font-family': 'Poppins',
        'height': 1.43,
        'style': 'normal'
      },
      'labelLarge': {
        'size': 14,
        'weight': 'medium',
        'font-family': 'Poppins',
        'height': 1.43,
        'style': 'normal'
      },
      'labelMedium': {
        'size': 12,
        'weight': 'medium',
        'font-family': 'Poppins',
        'height': 1.33,
        'style': 'normal'
      },
      'labelSmall': {
        'size': 11,
        'weight': 'medium',
        'font-family': 'Poppins',
        'height': 1.45,
        'style': 'normal'
      },
      'bodyLarge': {
        'size': 16,
        'weight': 'regular',
        'font-family': 'Poppins',
        'height': 1.5,
        'style': 'normal'
      },
      'bodyMedium': {
        'size': 14,
        'weight': 'regular',
        'font-family': 'Poppins',
        'height': 1.43,
        'style': 'normal'
      },
      'bodySmall': {
        'size': 12,
        'weight': 'regular',
        'font-family': 'Poppins',
        'height': 1.33,
        'style': 'normal'
      },
      'default': {
        'size': 12,
        'weight': 'regular',
        'font-family': {'primary': 'Poppins', 'secondary': 'Roboto'},
        'height': 1.2,
        'style': 'normal'
      }
    }
  },
  'environment': <String, dynamic>{
    'name': 'Development',
    'kind': 'development',
    'variables': null
  },
  'version': 1,
  'versionUpdated': true,
  'functionsFilePath': 'path/to/functions',
  'appState': <String, dynamic>{},
};

final minimalConfigData = {
  'appSettings': <String, String>{'initialRoute': 'home'},
  'pages': <String, Object?>{},
  'theme': <String, dynamic>{
    'colors': {'light': {}},
    'fonts': {}
  },
  'rest': <String, dynamic>{'defaultHeaders': {}},
  'functionsFilePath': 'testPathToFunctionFile',
  'version': 1
};

final Map<String, dynamic> validNetworkConfigData = {
  'appConfigFileUrl': 'testPathToConfigFile',
  'functionsFilePath': 'updatedFunctionPath',
  'version': 2
};

final invalidConfigData = {
  'appSettings': <String, String>{'initialRoute': 'home'},
  'pages': <String, Object?>{},
  'theme': 'invalid',
  'rest': <String, dynamic>{},
};

final validConfigJson = json.encode({
  'isSuccess': true,
  'data': {'response': validConfigData}
});

final minimalConfigJson = json.encode({
  'isSuccess': true,
  'data': {'response': minimalConfigData}
});

final invalidConfigJson = json.encode({
  'isSuccess': true,
  'data': {'response': invalidConfigData}
});

Response createMockResponse(Map<String, dynamic> data, {String? path}) =>
    Response(
      data: {
        'data': {'response': data}
      },
      requestOptions: RequestOptions(),
    );
