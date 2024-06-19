import 'package:digia_ui/digia_ui.dart';
import 'package:flutter/material.dart';

// const String baseUrl = 'http://localhost:5000/hydrator/api';
const String baseUrl = 'https://app.digia.tech/api/v1';

void main() async {
  await DigiaUIClient.initializeFromData(
    baseUrl: baseUrl,
      accessKey: "",
      data: const {
        'theme': <String, dynamic>{
          'colors': {'light': <String, dynamic>{}},
        },
        'fonts': <String, dynamic>{},
        'pages': <String, dynamic>{},
        'rest': <String, dynamic>{},
        'appSettings': <String, dynamic>{'initialRoute': ''},
        'appState': <String, dynamic>{
          "counter": {
            "type": "integer",
            "default": 0,
          },
          "pressedCount": {
            "type": "integer",
            "default": 0,
          }
        }
      },
      networkConfiguration: NetworkConfiguration(defaultHeaders: {
        "Authorization":
            "Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJkZXZpY2UiOjQsImV4cCI6MTcxNjgwNjc2NSwiaWF0IjoxNzE2Nzg4NzY1LCJqayI6ImF1dGgiLCJ1c2VyIjp7ImlkIjoiNjY0NjAxOWE1Yjg5ZWE0ZTU2ZTcxOTlkIiwiaXNRdWl6VGFrZW4iOmZhbHNlLCJwaG9uZSI6IiIsIkludml0ZSI6eyJUb2tlbiI6IiIsIkV4cGlyYXRpb25FcG9jaCI6MH0sIndoYXRzYXBwT3B0aW4iOmZhbHNlLCJhb2ZEZXRhaWxzIjp7InBlcm1hbmVudEFkZHJlc3MiOnt9LCJiaXJ0aENpdHkiOiIiLCJwb2xpdGljYWxseUV4cG9zZWQiOmZhbHNlLCJjdXJyZW50QWRkcmVzcyI6e319LCJDeWJyaWxsYUFjY291bnRJRCI6IiIsIkN5YnJpbGxhQWNjb3VudE9sZElEIjowLCJBY2NvdW50SUQiOiIwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAiLCJDeWJyaWxsYUludmVzdG9ySUQiOjAsIkludmVzdG9ySUQiOiIwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAiLCJPbGRNZW1iZXJQYXJ0bmVyIjowLCJMaW5rZWRpblBob3RvU2F2ZWQiOmZhbHNlLCJpbnZpdGVBY2Nlc3NQaG9uZSI6IiIsImVtcGxveWVyTmFtZSI6IiIsInJlZmVycmFsVXNlcklkIjoiMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwIiwiaXNJbnZpdGVBY2Nlc3NQaG9uZVZlcmlmaWVkIjpmYWxzZSwiYXBwbGljYW50c0FoZWFkIjowLCJpc0ludml0ZVdoYXRzYXBwTm90aWZ5IjpmYWxzZSwicGluIjoiIiwiaW52aXRlRXh0ZW5zaW9uUmVhc29uIjoiIiwicXVpelRva2VuIjoiIiwiY3licmlsbGFNYW5kYXRlSWQiOjAsInJ0YUN5YnJpbGxhTWFuZGF0ZUlkIjowLCJzaXBJRCI6IjAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMCIsIk9uYm9hcmRpbmdNb2RlIjowLCJ1dG0iOnt9LCJvYmplY3RpdmUiOnsiaWQiOiIwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAifSwicG9ydGZvbGlvUmV2aWV3SUQiOiIwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAiLCJwbXNFeHBlcnRDYWxsRGV0YWlscyI6eyJsYXN0VXBkYXRlZFRzIjoiMDAwMS0wMS0wMVQwMDowMDowMFoifSwiYXBwc2ZseWVyVVRNIjp7fSwiY3JlYXRlZEJ5IjoiMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwIiwiZGV6ZXJ2QXBwUmF0aW5nQ2xpY2tlZCI6ZmFsc2UsImFtbERldGFpbHMiOnt9fX0.sZD5wQmGkjhLTY5eyxKa6sTeo8CMcZcrhYgtHkkF4yPrTqfFbOPnhiOAbqEjCPJYetLWTDj7zeVDnx-ytiZC9g",
      }, timeout: 30));
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
                              "type": "digia/text",
                              "props": {
                                "text": r"Counter Value is ${appState.counter}",
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
                                      "height": 40,
                                      "defaultStyle": {
                                        "backgroundColor": "#00224D",
                                        "shape": {
                                          "value": "roundedRect",
                                          "borderRadius": 16
                                        },
                                      },
                                      "text": {
                                        "text": "Decrement",
                                        "textStyle": {"textColor": "#FFFFFF"}
                                      },
                                      "onClick": {
                                        "type": "Action.setAppState",
                                        "data": {
                                          "events": [
                                            {
                                              'variableName': "counter",
                                              'value':
                                                  r'${diff(appState.counter, 1)}'
                                            },
                                            {
                                              'variableName': "pressedCount",
                                              'value':
                                                  r'${sum(appState.pressedCount, 1)}'
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
                                      "height": 40,
                                      "defaultStyle": {
                                        "backgroundColor": "#00224D",
                                        "shape": {
                                          "value": "roundedRect",
                                          "borderRadius": 16
                                        },
                                      },
                                      "onClick": {
                                        "type": "Action.setAppState",
                                        "data": {
                                          "events": [
                                            {
                                              'variableName': "counter",
                                              'value':
                                                  r'${sum(appState.counter, 1)}'
                                            },
                                            {
                                              'variableName': "pressedCount",
                                              'value':
                                                  r'${sum(appState.pressedCount, 1)}'
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
                              "type": "digia/text",
                              "props": {
                                "text":
                                    r"You have pressed a total of this many times: ${appState.pressedCount}",
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
                                "height": 40,
                                "defaultStyle": {
                                  "backgroundColor": "#FF204E",
                                  "shape": {
                                    "value": "roundedRect",
                                    "borderRadius": 16
                                  },
                                },
                                "onClick": {
                                  "type": "Action.setAppState",
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
