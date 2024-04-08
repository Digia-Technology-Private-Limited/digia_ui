import 'package:digia_ui/digia_ui.dart';
import 'package:flutter/material.dart';

// const String baseUrl = 'http://localhost:5000/hydrator/api';
const String baseUrl = 'https://app.digia.tech/hydrator/api';

void main() async {
  await DigiaUIClient.initializeFromData(accessKey: "", data: const {
    'theme': <String, dynamic>{
      'colors': {'light': <String, dynamic>{}},
    },
    'fonts': <String, dynamic>{},
    'pages': <String, dynamic>{},
    'rest': <String, dynamic>{},
    'appSettings': <String, dynamic>{'initialRoute': ''}
  });
  const pageUid = 'Test';

  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    home: DUIPage(
        key: UniqueKey(),
        pageUid: pageUid,
        config: DUIConfig({
          'theme': <String, dynamic>{
            'colors': {'light': <String, dynamic>{}},
          },
          'fonts': <String, dynamic>{},
          'pages': <String, dynamic>{
            pageUid: {
              'uid': pageUid,
              "actions": {
                "onPageLoad": <String, dynamic>{
                  "type": "Action.buildPage",
                  "data": <String, dynamic>{}
                }
              },
              "variables": {
                "counter": {
                  "type": "integer",
                  "default": 0,
                },
                "pressedCount": {
                  "type": "integer",
                  "default": 0,
                }
              },
              "layout": {
                "root": {
                  "type": "fw/scaffold",
                  "children": {
                    "appBar": [
                      {
                        "type": "fw/appBar",
                        "props": {
                          "title": {"text": "Digia UI"},
                          "elevation": 3,
                          "shadowColor": "#000000",
                          "backgrounColor": "#A14012",
                          "iconColor": "#FFFFFF"
                        }
                      }
                    ],
                    "body": [
                      {
                        "type": "digia/column",
                        "props": {
                          "mainAxisAlignment": "center",
                          "crossAxisAlignment": "center",
                        },
                        "children": {
                          "children": [
                            {
                              "type": "digia/text2",
                              "props": {
                                "text": r"Counter Value is ${counter}",
                                "textStyle": {
                                  "textColor": "#00224D",
                                }
                              },
                              "containerProps": {"align": "center"}
                            },
                            {
                              "type": "fw/sized_box",
                              "props": {"height": 20}
                            },
                            {
                              "type": "digia/row",
                              "props": {
                                "mainAxisAlignment": "center",
                                "crossAxisAlignment": "center",
                              },
                              "children": {
                                "children": [
                                  {
                                    "type": "digia/button",
                                    "props": {
                                      "style": {
                                        "bgColor": "#00224D",
                                        "height": 40,
                                        "border": {"borderRadius": 16},
                                      },
                                      "text": {
                                        "text": "Decrement",
                                        "textStyle": {"textColor": "#FFFFFF"}
                                      },
                                      "onClick": {
                                        "type": "Action.setPageState",
                                        "data": {
                                          "events": [
                                            {
                                              'variableName': "counter",
                                              'value': r'${diff(counter, 1)}'
                                            },
                                            {
                                              'variableName': "pressedCount",
                                              'value':
                                                  r'${sum(pressedCount, 1)}'
                                            }
                                          ]
                                        }
                                      }
                                    }
                                  },
                                  {
                                    "type": "fw/sized_box",
                                    "props": {"width": 20}
                                  },
                                  {
                                    "type": "digia/button",
                                    "props": {
                                      "text": {
                                        "text": "Increment",
                                        "textStyle": {"textColor": "#FFFFFF"}
                                      },
                                      "style": {
                                        "bgColor": "#00224D",
                                        "height": 40,
                                        "border": {"borderRadius": 16}
                                      },
                                      "onClick": {
                                        "type": "Action.setPageState",
                                        "data": {
                                          "events": [
                                            {
                                              'variableName': "counter",
                                              'value': r'${sum(counter, 1)}'
                                            },
                                            {
                                              'variableName': "pressedCount",
                                              'value':
                                                  r'${sum(pressedCount, 1)}'
                                            }
                                          ]
                                        }
                                      }
                                    }
                                  }
                                ]
                              }
                            },
                            {
                              "type": "fw/sized_box",
                              "props": {"height": 20}
                            },
                            {
                              "type": "digia/text2",
                              "props": {
                                "text":
                                    r"You have pressed a total of this many times: ${pressedCount}",
                                "textStyle": {
                                  "textColor": "#00224D",
                                }
                              },
                              "containerProps": {"align": "center"}
                            },
                            {
                              "type": "fw/sized_box",
                              "props": {"height": 20}
                            },
                            {
                              "type": "digia/button",
                              "props": {
                                "text": {
                                  "text": "Reset",
                                  "textStyle": {"textColor": "#FFFFFF"}
                                },
                                "style": {
                                  "bgColor": "#FF204E",
                                  "height": 40,
                                  "border": {"borderRadius": 16}
                                },
                                "onClick": {
                                  "type": "Action.setPageState",
                                  "data": {
                                    "events": [
                                      {'variableName': "counter", 'value': 0},
                                      {
                                        'variableName': "pressedCount",
                                        'value': 0
                                      }
                                    ]
                                  }
                                }
                              }
                            }
                          ]
                        }
                      },
                    ]
                  }
                }
              }
            }
          },
          'rest': <String, dynamic>{},
          'appSettings': <String, dynamic>{'initialRoute': ''}
        })),
  ));
  // runApp(const DUIApp(
  //     digiaAccessKey: "65fb12a543a6c8e5400e6366", baseUrl: baseUrl));
}
