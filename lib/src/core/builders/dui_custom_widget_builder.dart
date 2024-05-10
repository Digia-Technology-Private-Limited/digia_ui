import 'package:digia_ui/src/core/builders/dui_custom_widget.dart';
import 'package:digia_ui/src/core/json_widget_builder.dart';
import 'package:digia_ui/src/core/page/props/dui_widget_json_data.dart';
import 'package:flutter/material.dart';

class DUICustomWidgetBuilder extends DUIWidgetBuilder {
  DUICustomWidgetBuilder({required super.data});

  static DUICustomWidgetBuilder create(DUIWidgetJsonData data) {
    return DUICustomWidgetBuilder(data: data);
  }

  @override
  Widget build(BuildContext context) {
    return DUICustomWidget(
      json: data.props['json'],
    );
  }
}

Map<String, dynamic> mapJson = {
  'title': 'Performance',
  'toggleItems': [
    {
      'title': 'Absolute Gains',
      'key': 'absoluteGains',
      'type': 'graph',
      'items': [
        {
          'timeframe': '1M',
          'graphData': [
            {
              'name': 'Your Portfolio',
              'valueText': '₹90.43L',
              'valueColor': '#4EB3A9',
              'color': '#4EB3A9',
              'barWidth': 9043307.27
            },
            {
              'name': 'Benchmark (S&P BSE 500 India TR INR)',
              'valueText': '₹57.37L',
              'valueColor': '#31302E',
              'color': '#31302E',
              'barWidth': 5737268.4076
            }
          ],
          'note': {
            'title': 'Don’t worry about short term fluctuations!',
            'subtitle':
                'Dynamic asset allocation and security selection leads to outperformance in the long-term'
          }
        },
        {
          'timeframe': '3M',
          'graphData': [
            {
              'name': 'Your Portfolio',
              'valueText': '₹1.66Cr',
              'valueColor': '#4EB3A9',
              'color': '#4EB3A9',
              'barWidth': 16625477.52
            },
            {
              'name': 'Benchmark (S&P BSE 500 India TR INR)',
              'valueText': '₹1.20Cr',
              'valueColor': '#31302E',
              'color': '#31302E',
              'barWidth': 12025006.748
            }
          ],
          'note': {
            'title': 'Don’t worry about short term fluctuations!',
            'subtitle':
                'Dynamic asset allocation and security selection leads to outperformance in the long-term'
          }
        },
        {
          'timeframe': '6M',
          'graphData': [
            {
              'name': 'Your Portfolio',
              'valueText': '₹4.62Cr',
              'valueColor': '#4EB3A9',
              'color': '#4EB3A9',
              'barWidth': 46167156.81
            },
            {
              'name': 'Benchmark (S&P BSE 500 India TR INR)',
              'valueText': '₹4.36Cr',
              'valueColor': '#31302E',
              'color': '#31302E',
              'barWidth': 43550293.1147
            }
          ],
          'note': {
            'title': 'Don’t worry about short term fluctuations!',
            'subtitle':
                'Dynamic asset allocation and security selection leads to outperformance in the long-term'
          }
        },
        {
          'timeframe': '1Y',
          'graphData': [
            {
              'name': 'Your Portfolio',
              'valueText': '₹6.72Cr',
              'valueColor': '#4EB3A9',
              'color': '#4EB3A9',
              'barWidth': 67237786.43
            },
            {
              'name': 'Benchmark (S&P BSE 500 India TR INR)',
              'valueText': '₹5.82Cr',
              'valueColor': '#31302E',
              'color': '#31302E',
              'barWidth': 58201363.5108
            }
          ],
          'note': {
            'title':
                'Since you started investing your portfolio is up by ₹7.05Cr',
            'subtitle':
                'Our team will continue to optimise your portfolio using dynamic asset allocation and fund selection.'
          }
        },
        {
          'timeframe': 'All Time',
          'graphData': [
            {
              'name': 'Your Portfolio',
              'valueText': '₹7.05Cr',
              'valueColor': '#4EB3A9',
              'color': '#4EB3A9',
              'barWidth': 70485348.0606
            },
            {
              'name': 'Benchmark (S&P BSE 500 India TR INR)',
              'valueText': '₹6.03Cr',
              'valueColor': '#31302E',
              'color': '#31302E',
              'barWidth': 60282538.0275
            }
          ],
          'note': {
            'title':
                'Since you started investing your portfolio is up by ₹7.05Cr',
            'subtitle':
                'Our team will continue to optimise your portfolio using dynamic asset allocation and fund selection. '
          }
        }
      ]
    },
    {
      'title': 'XIRR',
      'key': 'xirr',
      'type': 'graph',
      'items': [
        {
          'timeframe': '1M',
          'graphData': [
            {
              'name': 'Your Portfolio',
              'valueText': '4.12%',
              'valueColor': '#4EB3A9',
              'color': '#4EB3A9',
              'barWidth': 4.1166
            },
            {
              'name': 'Benchmark',
              'valueText': '2.61%',
              'valueColor': '#31302E',
              'color': '#31302E',
              'barWidth': 2.6116
            }
          ],
          'note': {
            'title': 'Don’t worry about short term fluctuations!',
            'subtitle':
                'Dynamic asset allocation and security selection leads to outperformance in the long-term'
          }
        },
        {
          'timeframe': '3M',
          'graphData': [
            {
              'name': 'Your Portfolio',
              'valueText': '7.84%',
              'valueColor': '#4EB3A9',
              'color': '#4EB3A9',
              'barWidth': 7.8387
            },
            {
              'name': 'Benchmark',
              'valueText': '5.64%',
              'valueColor': '#31302E',
              'color': '#31302E',
              'barWidth': 5.641
            }
          ],
          'note': {
            'title': 'Don’t worry about short term fluctuations!',
            'subtitle':
                'Dynamic asset allocation and security selection leads to outperformance in the long-term'
          }
        },
        {
          'timeframe': '6M',
          'graphData': [
            {
              'name': 'Your Portfolio',
              'valueText': '25.44%',
              'valueColor': '#4EB3A9',
              'color': '#4EB3A9',
              'barWidth': 25.4428
            },
            {
              'name': 'Benchmark',
              'valueText': '23.93%',
              'valueColor': '#31302E',
              'color': '#31302E',
              'barWidth': 23.927
            }
          ],
          'note': {
            'title': 'Don’t worry about short term fluctuations!',
            'subtitle':
                'Dynamic asset allocation and security selection leads to outperformance in the long-term'
          }
        },
        {
          'timeframe': '1Y',
          'graphData': [
            {
              'name': 'Your Portfolio',
              'valueText': '43.06%',
              'valueColor': '#4EB3A9',
              'color': '#4EB3A9',
              'barWidth': 43.0604
            },
            {
              'name': 'Benchmark',
              'valueText': '37.27%',
              'valueColor': '#31302E',
              'color': '#31302E',
              'barWidth': 37.2713
            }
          ],
          'note': {
            'title':
                'Since you started investing your portfolio is up by 33.66%',
            'subtitle':
                'Our team will continue to optimise your portfolio using dynamic asset allocation and fund selection.'
          }
        },
        {
          'timeframe': 'All Time',
          'graphData': [
            {
              'name': 'Your Portfolio',
              'valueText': '33.66%',
              'valueColor': '#4EB3A9',
              'color': '#4EB3A9',
              'barWidth': 33.6563
            },
            {
              'name': 'Benchmark',
              'valueText': '29.05%',
              'valueColor': '#31302E',
              'color': '#31302E',
              'barWidth': 29.0512
            }
          ],
          'note': {
            'title':
                'Since you started investing your portfolio is up by 33.66%',
            'subtitle':
                'Our team will continue to optimise your portfolio using dynamic asset allocation and fund selection. '
          }
        }
      ]
    },
    {
      'title': 'TWRR',
      'key': 'twrr',
      'type': 'graph',
      'items': [
        {
          'timeframe': '1M',
          'graphData': [
            {
              'name': 'Your Portfolio',
              'valueText': '3.66%',
              'valueColor': '#4EB3A9',
              'color': '#4EB3A9',
              'barWidth': 3.6629
            },
            {
              'name': 'Benchmark',
              'valueText': '3.51%',
              'valueColor': '#31302E',
              'color': '#31302E',
              'barWidth': 3.5117
            }
          ],
          'note': {
            'title': 'Don’t worry about short term fluctuations!',
            'subtitle':
                'Dynamic asset allocation and security selection leads to outperformance in the long-term'
          }
        },
        {
          'timeframe': '3M',
          'graphData': [
            {
              'name': 'Your Portfolio',
              'valueText': '43.63%',
              'valueColor': '#4EB3A9',
              'color': '#4EB3A9',
              'barWidth': 43.6305
            },
            {
              'name': 'Benchmark',
              'valueText': '7.38%',
              'valueColor': '#31302E',
              'color': '#31302E',
              'barWidth': 7.3828
            }
          ],
          'note': {
            'title': 'Don’t worry about short term fluctuations!',
            'subtitle':
                'Dynamic asset allocation and security selection leads to outperformance in the long-term'
          }
        },
        {
          'timeframe': '6M',
          'graphData': [
            {
              'name': 'Your Portfolio',
              'valueText': '5.94%',
              'valueColor': '#E99E4E',
              'color': '#E99E4E',
              'barWidth': 5.9405
            },
            {
              'name': 'Benchmark',
              'valueText': '24.28%',
              'valueColor': '#31302E',
              'color': '#31302E',
              'barWidth': 24.2772
            }
          ],
          'note': {
            'title': 'Don’t worry about short term fluctuations!',
            'subtitle':
                'Dynamic asset allocation and security selection leads to outperformance in the long-term'
          }
        },
        {
          'timeframe': '1Y',
          'graphData': [
            {
              'name': 'Your Portfolio',
              'valueText': '19.96%',
              'valueColor': '#E99E4E',
              'color': '#E99E4E',
              'barWidth': 19.962
            },
            {
              'name': 'Benchmark',
              'valueText': '38.83%',
              'valueColor': '#31302E',
              'color': '#31302E',
              'barWidth': 38.8328
            }
          ],
          'note': {
            'title':
                'Since you started investing your portfolio is up by 72.44%',
            'subtitle':
                'Our team will continue to optimise your portfolio using dynamic asset allocation and fund selection.'
          }
        },
        {
          'timeframe': 'All Time',
          'graphData': [
            {
              'name': 'Your Portfolio',
              'valueText': '72.44%',
              'valueColor': '#4EB3A9',
              'color': '#4EB3A9',
              'barWidth': 72.4396
            },
            {
              'name': 'Benchmark',
              'valueText': '59.29%',
              'valueColor': '#31302E',
              'color': '#31302E',
              'barWidth': 59.292
            }
          ],
          'note': {
            'title':
                'Since you started investing your portfolio is up by 72.44%',
            'subtitle':
                'Our team will continue to optimise your portfolio using dynamic asset allocation and fund selection. '
          }
        }
      ]
    }
  ]
};
