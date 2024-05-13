import 'package:digia_ui/src/analytics/mixpanel.dart';
import 'package:flutter/material.dart';

import 'package:digia_ui/src/core/page/dui_page.dart';
import 'package:digia_ui/src/digia_ui_client.dart';

class DUIApp extends StatelessWidget {
  final String digiaAccessKey;
  final GlobalKey<NavigatorState>? navigatorKey;
  final ThemeData? theme;
  final String? baseUrl;
  final String? mixpanelKey;
  // final Map<String, dynamic> initProperties;

  DUIApp({
    super.key,
    required this.digiaAccessKey,
    this.navigatorKey,
    this.theme,
    this.mixpanelKey,
    this.baseUrl,
    // required this.initProperties
  }) {
    if (mixpanelKey != null) {
      MixpanelManager.init(mixpanelKey!, digiaAccessKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // key: key,
      debugShowCheckedModeBanner: false,
      theme: theme ??
          ThemeData(
            fontFamily: 'Poppins',
            scaffoldBackgroundColor: Colors.white,
            brightness: Brightness.light,
          ),
      title: 'Digia App',
      home: FutureBuilder(
        // future: DigiaUIClient.initializeFromNetwork(
        //     accessKey: digiaAccessKey, baseUrl: baseUrl),
        future: DigiaUIClient.initializeFromData(
            accessKey: digiaAccessKey, data: json),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Scaffold(
              body: SafeArea(
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Intializing from Cloud...'),
                      LinearProgressIndicator()
                    ],
                  ),
                ),
              ),
            );
          }

          if (snapshot.hasError) {
            return const Scaffold(
              body: SafeArea(
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Could not fetch Config.',
                        style: TextStyle(color: Colors.red, fontSize: 24),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          final initialRouteData =
              DigiaUIClient.getConfigResolver().getfirstPageData();

          return DUIPage(pageUid: initialRouteData.uid);
        },
      ),
    );
  }
}

Map<String, dynamic> json = {
  "appSettings": {"initialRoute": "courses"},
  "pages": {
    "courses": {
      "slug": "courses",
      "uid": "courses",
      "actions": {
        "onPageLoad": {
          "type": "Action.loadPage",
          "data": {
            "apis": {
              "courses": {
                "apiName": "courses",
                "httpMethod": "GET",
                "apiUrl": "https://demo5020025.mockable.io/",
                "headers": {},
                "variables": {},
                "body": {}
              }
            }
          }
        }
      },
      "inputArgs": null,
      "layout": null
    },
    "bytes-onboarding": {
      "slug": "bytes-onboarding",
      "uid": "bytes-onboarding",
      "actions": {
        "onPageLoad": {"type": "Action.buildPage", "data": {}}
      },
      "inputArgs": null,
      "layout": {
        "body": {"root": null},
        "header": null,
        "footer": null,
        "root": {
          "type": "fw/scaffold",
          "props": null,
          "containerProps": null,
          "children": {
            "body": [
              {
                "type": "digia/column",
                "props": {
                  "mainAxisAlignment": "start",
                  "crossAxisAlignment": "center",
                  "isScrollable": null
                },
                "containerProps": {
                  "style": {"padding": "10,10,10,10", "bgColor": "#FFFFFF"}
                },
                "children": {
                  "children": [
                    {
                      "type": "digia/text",
                      "props": {
                        "text": "BYTES",
                        "textStyle": {
                          "textColor": "#FFFFFF",
                          "fontToken": "displaylarge",
                          "textBgColor": null
                        },
                        "alignment": "center",
                        "maxLines": null
                      },
                      "containerProps": {
                        "style": {
                          "bgColor": "#00C063",
                          "alignment": "center",
                          "padding": "0,0,0,0",
                          "margin": "0,0,0,0",
                          "borderStyle": "none",
                          "borderWidth": 2,
                          "borderRadius": "18,18,18,18",
                          "width": "400",
                          "height": "45%",
                          "borderColor": null
                        },
                        "align": "center"
                      }
                    },
                    {
                      "type": "digia/richText",
                      "props": {
                        "textSpans": [
                          {
                            "text": "Stoppage for your       ",
                            "spanStyle": {
                              "textColor": "#101213",
                              "fontToken": "headlinelarge"
                            }
                          },
                          {
                            "text": "Curiosity",
                            "spanStyle": {
                              "fontToken": "headlinelarge",
                              "textColor": "#1C4494",
                              "textDecorationColor": null,
                              "textDecorationStyle": "solid"
                            }
                          }
                        ]
                      },
                      "containerProps": {
                        "style": {
                          "alignment": "centerLeft",
                          "padding": "0,0,0,0",
                          "margin": "16,20,0,0"
                        }
                      }
                    },
                    {
                      "type": "digia/text",
                      "props": {
                        "text":
                            "Discover Bytes, an intuitive and versatile Content Platform powered by Digia.",
                        "textStyle": {"fontToken": "titlemedium"},
                        "alignment": "start"
                      },
                      "containerProps": {
                        "style": {"margin": "16,20,0,0"}
                      }
                    },
                    {
                      "type": "digia/button",
                      "props": {
                        "text": {
                          "text": "Get Started",
                          "textStyle": {
                            "fontToken": "titlemedium",
                            "textColor": "#FFFFFF",
                            "textBgColor": null
                          }
                        },
                        "onClick": null,
                        "style": {"bgColor": null}
                      },
                      "containerProps": {
                        "style": {
                          "bgColor": "#04A24C",
                          "borderWidth": null,
                          "padding": "10,10,10,10",
                          "alignment": "none",
                          "borderRadius": "25,25,25,25",
                          "margin": "16,30,0,0"
                        },
                        "align": "topLeft",
                        "onClick": {
                          "type": "Action.navigateToPage",
                          "data": {"pageId": "courses", "args": {}, "url": null}
                        }
                      }
                    }
                  ]
                }
              }
            ]
          }
        }
      }
    },
    "articlelist": {
      "slug": "articlelist",
      "uid": "articlelist",
      "actions": {
        "onPageLoad": {
          "type": "Action.loadPage",
          "data": {
            "apis": {
              "articles": {
                "httpMethod": "GET",
                "apiUrl": "https://demo5020025.mockable.io/",
                "headers": {},
                "variables": {
                  "courseID": {
                    "type": "number",
                    "isList": false,
                    "defaultValue": "1"
                  }
                }
              }
            }
          }
        }
      },
      "inputArgs": {
        "type": "object",
        "default": null,
        "items": null,
        "properties": {
          "courseID": {
            "type": "number",
            "default": "6",
            "items": null,
            "properties": null,
            "required": []
          }
        },
        "required": ["courseID"]
      },
      "layout": null
    }
  },
  "rest": {
    "baseUrl": "https://app.digia.tech/hydrator/api",
    "defaultHeaders": {},
    "apis": {
      "courses": {
        "httpMethod": "GET",
        "apiUrl": "https://demo5020025.mockable.io/",
        "headers": {},
        "variables": {},
        "body": {}
      },
      "articles": {
        "httpMethod": "GET",
        "apiUrl": "https://demo5020025.mockable.io/",
        "headers": {},
        "variables": {
          "courseID": {"type": "number", "isList": false, "defaultValue": "1"}
        }
      }
    }
  },
  "theme": {
    "colors": {
      "light": {
        "primary": "#a39cdd",
        "secondary": "#D23991",
        "tertiary": "#ee8b60",
        "alternate": "#ff5963",
        "primarytext": "#101213",
        "secondarytext": "#57636c",
        "primarybackground": "#f1f4f8",
        "secondarybackground": "#ffffff",
        "accent1": "#616161",
        "accent2": "#e0e0e0",
        "accent4": "#eeeeee",
        "success": "#04a24c",
        "error": "#e21c3d",
        "Warning": "#fcdc0c",
        "info": "#1c4494",
        "customcolor1": "#cc12b0",
        "customcolor2": "#205f7d"
      },
      "dark": {
        "primary": "#a39cdd",
        "secondary": "#39d2c0",
        "tertiary": "#ee8b60",
        "alternate": "#ff5963",
        "primarytext": "#101213",
        "secondarytext": "#57636c",
        "primarybackground": "#f1f4f8",
        "secondarybackground": "#ffffff",
        "accent1": "#616161",
        "accent2": "#e0e0e0",
        "accent4": "#eeeeee",
        "success": "#04a24c",
        "error": "#e21c3d",
        "Warning": "#fcdc0c",
        "info": "#1c4494",
        "customcolor1": "#cc12b0",
        "customcolor2": "#205f7d"
      }
    },
    "fonts": {
      "displaylarge": {
        "size": 64,
        "weight": "regular",
        "font-family": "Roboto"
      },
      "displaymedium": {
        "size": 48,
        "weight": "regular",
        "font-family": "Roboto"
      },
      "displaysmall": {
        "size": 36,
        "weight": "regular",
        "font-family": "Roboto"
      },
      "headlinelarge": {
        "size": 32,
        "weight": "regular",
        "font-family": "Roboto"
      },
      "headlinemedium": {
        "size": 28,
        "weight": "regular",
        "font-family": "Roboto"
      },
      "headlinesmall": {
        "size": 24,
        "weight": "regular",
        "font-family": "Roboto"
      },
      "titlelarge": {
        "size": 22,
        "weight": "semi-bold",
        "font-family": "Roboto"
      },
      "titlemedium": {"size": 16, "weight": "regular", "font-family": "Roboto"},
      "titlesmall": {"size": 14, "weight": "regular", "font-family": "Roboto"},
      "labellarge": {"size": 14, "weight": "bold", "font-family": "Roboto"},
      "labelmedium": {"size": 12, "weight": "regular", "font-family": "Roboto"},
      "labelsmall": {"size": 11, "weight": "regular", "font-family": "Roboto"},
      "bodylarge": {"size": 16, "weight": "regular", "font-family": "Roboto"},
      "bodymedium": {"size": 14, "weight": "regular", "font-family": "Roboto"},
      "bodysmall": {"size": 12, "weight": "regular", "font-family": "Roboto"},
      "custom": {"size": 16, "weight": "regular", "font-family": "Roboto"},
      "default": {
        "size": 12,
        "weight": "regular",
        "font-family": {"primary": "poppins", "secondary": "Roboto"}
      }
    }
  }
};

Map<String, dynamic> json2 = {
  "appSettings": {"initialRoute": "bytes-onboarding-65a4e1b85cc29694890b42e8"},
  "pages": {
    "courses-65a4e1b85cc29694890b42e8": {
      "slug": "courses-65a4e1b85cc29694890b42e8",
      "uid": "courses-65a4e1b85cc29694890b42e8",
      "actions": {
        "onPageLoad": {
          "type": "Action.loadPage",
          "data": {"pageId": "courses-65a4e1b85cc29694890b42e8"}
        }
      },
      "inputArgs": null,
      "layout": null
    },
    "bytes-onboarding-65a4e1b85cc29694890b42e8": {
      "slug": "bytes-onboarding-65a4e1b85cc29694890b42e8",
      "uid": "bytes-onboarding-65a4e1b85cc29694890b42e8",
      "actions": {
        "onPageLoad": {"type": "Action.buildPage", "data": {}}
      },
      "inputArgs": null,
      "layout": {
        "body": {"root": null},
        "header": null,
        "footer": null,
        "root": {
          "type": "fw/scaffold",
          "props": null,
          "containerProps": null,
          "children": {
            "body": [
              {
                "type": "digia/column",
                "props": {
                  "mainAxisAlignment": "start",
                  "crossAxisAlignment": "center",
                  "isScrollable": null
                },
                "containerProps": {
                  "style": {"padding": "10,10,10,10", "bgColor": "#FFFFFF"}
                },
                "children": {
                  "children": [
                    {
                      "type": "digia/text",
                      "props": {
                        "text": "BYTES",
                        "textStyle": {
                          "textColor": "#FFFFFF",
                          "fontToken": "displaylarge",
                          "textBgColor": null
                        },
                        "alignment": "start",
                        "maxLines": null
                      },
                      "containerProps": {
                        "style": {
                          "bgColor": "#00C063",
                          "alignment": "center",
                          "padding": "0,0,0,0",
                          "margin": "0,0,0,0",
                          "borderStyle": "none",
                          "borderWidth": 2,
                          "borderRadius": "18,18,18,18",
                          "width": "400",
                          "height": "45%",
                          "borderColor": null
                        },
                        "align": "none"
                      }
                    },
                    {
                      "type": "digia/richText",
                      "props": {
                        "textSpans": [
                          {
                            "text": "Stoppage for your\n",
                            "spanStyle": {
                              "textColor": "#101213",
                              "fontToken": "headlinelarge"
                            }
                          },
                          {
                            "text": "Curiosity",
                            "spanStyle": {
                              "fontToken": "headlinelarge",
                              "textColor": "#1C4494",
                              "textDecorationColor": null,
                              "textDecorationStyle": "solid"
                            }
                          }
                        ]
                      },
                      "containerProps": {
                        "style": {
                          "alignment": "centerLeft",
                          "padding": "0,0,0,0",
                          "margin": "16,20,0,0"
                        }
                      }
                    },
                    {
                      "type": "digia/text",
                      "props": {
                        "text":
                            "Discover Bytes, an intuitive and versatile Content Platform powered by Digia.",
                        "textStyle": {"fontToken": "titlemedium"},
                        "alignment": "start"
                      },
                      "containerProps": {
                        "style": {"margin": "16,20,0,0"}
                      }
                    },
                    {
                      "type": "digia/button",
                      "props": {
                        "text": {
                          "text": "Get Started",
                          "textStyle": {
                            "fontToken": "titlemedium",
                            "textColor": "#FFFFFF",
                            "textBgColor": null
                          }
                        },
                        "onClick": null,
                        "style": {"bgColor": null}
                      },
                      "containerProps": {
                        "style": {
                          "bgColor": "#04A24C",
                          "borderWidth": null,
                          "padding": "10,10,10,10",
                          "alignment": "none",
                          "borderRadius": "25,25,25,25",
                          "margin": "16,30,0,0"
                        },
                        "align": "topLeft",
                        "onClick": {
                          "type": "Action.navigateToPage",
                          "data": {
                            "pageId": "courses-65a4e1b85cc29694890b42e8",
                            "args": {},
                            "url": null
                          }
                        }
                      }
                    }
                  ]
                }
              }
            ]
          }
        }
      }
    },
    "articlelist-65a4e1b85cc29694890b42e8": {
      "slug": "articlelist-65a4e1b85cc29694890b42e8",
      "uid": "articlelist-65a4e1b85cc29694890b42e8",
      "actions": {
        "onPageLoad": {
          "type": "Action.loadPage",
          "data": {"pageId": "articlelist-65a4e1b85cc29694890b42e8"}
        }
      },
      "inputArgs": {
        "type": "object",
        "default": null,
        "items": null,
        "properties": {
          "courseID": {
            "type": "number",
            "default": "6",
            "items": null,
            "properties": null,
            "required": []
          }
        },
        "required": ["courseID"]
      },
      "layout": null
    }
  },
  "rest": {
    "baseUrl": "https://app.digia.tech/hydrator/api",
    "defaultHeaders": {}
  },
  "theme": {
    "colors": {
      "light": {
        "primary": "#a39cdd",
        "secondary": "#D23991",
        "tertiary": "#ee8b60",
        "alternate": "#ff5963",
        "primarytext": "#101213",
        "secondarytext": "#57636c",
        "primarybackground": "#f1f4f8",
        "secondarybackground": "#ffffff",
        "accent1": "#616161",
        "accent2": "#e0e0e0",
        "accent4": "#eeeeee",
        "success": "#04a24c",
        "error": "#e21c3d",
        "Warning": "#fcdc0c",
        "info": "#1c4494",
        "customcolor1": "#cc12b0",
        "customcolor2": "#205f7d"
      },
      "dark": {
        "primary": "#a39cdd",
        "secondary": "#39d2c0",
        "tertiary": "#ee8b60",
        "alternate": "#ff5963",
        "primarytext": "#101213",
        "secondarytext": "#57636c",
        "primarybackground": "#f1f4f8",
        "secondarybackground": "#ffffff",
        "accent1": "#616161",
        "accent2": "#e0e0e0",
        "accent4": "#eeeeee",
        "success": "#04a24c",
        "error": "#e21c3d",
        "Warning": "#fcdc0c",
        "info": "#1c4494",
        "customcolor1": "#cc12b0",
        "customcolor2": "#205f7d"
      }
    },
    "fonts": {
      "displaylarge": {
        "size": 64,
        "weight": "regular",
        "font-family": "Roboto"
      },
      "displaymedium": {
        "size": 48,
        "weight": "regular",
        "font-family": "Roboto"
      },
      "displaysmall": {
        "size": 36,
        "weight": "regular",
        "font-family": "Roboto"
      },
      "headlinelarge": {
        "size": 32,
        "weight": "regular",
        "font-family": "Roboto"
      },
      "headlinemedium": {
        "size": 28,
        "weight": "regular",
        "font-family": "Roboto"
      },
      "headlinesmall": {
        "size": 24,
        "weight": "regular",
        "font-family": "Roboto"
      },
      "titlelarge": {
        "size": 22,
        "weight": "semi-bold",
        "font-family": "Roboto"
      },
      "titlemedium": {"size": 16, "weight": "regular", "font-family": "Roboto"},
      "titlesmall": {"size": 14, "weight": "regular", "font-family": "Roboto"},
      "labellarge": {"size": 14, "weight": "bold", "font-family": "Roboto"},
      "labelmedium": {"size": 12, "weight": "regular", "font-family": "Roboto"},
      "labelsmall": {"size": 11, "weight": "regular", "font-family": "Roboto"},
      "bodylarge": {"size": 16, "weight": "regular", "font-family": "Roboto"},
      "bodymedium": {"size": 14, "weight": "regular", "font-family": "Roboto"},
      "bodysmall": {"size": 12, "weight": "regular", "font-family": "Roboto"},
      "custom": {"size": 16, "weight": "regular", "font-family": "Roboto"},
      "default": {
        "size": 12,
        "weight": "regular",
        "font-family": {"primary": "poppins", "secondary": "Roboto"}
      }
    }
  }
};
