import 'package:digia_ui/Utils/util_functions.dart';
import 'package:digia_ui/components/charts/line/line_chart_props.dart';
import 'package:digia_ui/core/container/dui_container.dart';
import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

class LineChart extends StatelessWidget {
  final LineChartProps props;

  const LineChart(this.props, {super.key});

  factory LineChart.create(Map<String, dynamic> json) =>
      LineChart(LineChartProps.fromJson(json));

  @override
  Widget build(BuildContext context) {
    // final lines = lineData['lines'] as List<Map<String, dynamic>>;
    final x = props.data.xAxis.name;
    final y = props.data.yAxis.name;
    final seriesStyleMap = props.data.series.fold({}, (result, element) {
      result[element.group] = {
        'color': element.color,
        'width': element.width,
        'lineStyle': element.lineStyle
      };
      return result;
    });

    final chartData = props.data.series
        .map((line) {
          return line.data.asMap().entries.map((point) {
            return {
              'index': point.key,
              'value': point.value,
              'group': line.group
            };
          });
        })
        .expand((e) => e)
        .toList();
    final child = Chart(
      data: chartData,
      variables: {
        x: Variable(
          accessor: (Map<String, dynamic> dict) => dict['index'] as int,
          scale: LinearScale(formatter: (p) {
            final axisData = props.data.xAxis;

            if (axisData.data == null) {
              return p.toString();
            }

            final allowedIndexes = [
              for (var i = 0; i < axisData.data!.length; i++) i
            ];
            if (allowedIndexes.contains(p)) {
              return axisData.data![p.toInt()];
            }

            return null;
          }),
        ),
        y: Variable(
            accessor: (Map<String, dynamic> dict) => dict['value'] as num,
            scale: LinearScale(
              formatter: (p) {
                final axisData = props.data.yAxis;
                if (axisData.labelFormatter != null) {
                  return axisData.labelFormatter!
                      .replaceAll('{value}', p.toString());
                }

                return p.toString();
              },
            )),
        'group': Variable(
          accessor: (Map<String, dynamic> dict) => dict['group'] as String,
        ),
      },
      marks: [
        LineMark(
          position: Varset(x) * Varset(y) / Varset('group'),
          shape: ShapeEncode(encoder: (p) {
            final lineStyle = seriesStyleMap[p['group']]['lineStyle']
                as Map<String, dynamic>?;

            final dashArray = (lineStyle?['dashArray'] as List<num>?)
                ?.take(2)
                .map((e) => e.toDouble())
                .toList();

            if (dashArray != null) {
              return BasicLineShape(dash: dashArray);
            }

            return BasicLineShape(smooth: lineStyle?['smooth'] ?? true);
          }),
          // shape: ShapeEncode(value: BasicLineShape(dash: [5, 5])),
          size: SizeEncode(
            encoder: (p) {
              final width = seriesStyleMap[p['group']]['width'] as double?;
              return width ?? 2.0;
            },
          ),
          color: ColorEncode(encoder: (p) {
            return toColor(seriesStyleMap[p['group']]['color']);
          }),
        ),
        // )
        PointMark()
      ],
      axes: [
        Defaults.horizontalAxis,
        Defaults.verticalAxis,
      ],
      selections: {'tap': PointSelection()},
      tooltip: TooltipGuide(),
    );

    final widget = props.styleClass == null
        ? child
        : DUIContainer(styleClass: props.styleClass, child: child);

    return SingleChildScrollView(child: widget);
  }
}

const samplelineData = {
  "styleClass": "w:300;h:300;bgc:white;p:20,40,0,20",
  "data": {
    "series": [
      {
        "group": "revenue",
        "color": "primary",
        "width": 2.0,
        "data": [148, 86.4, 340, 0, 0, 0, 0]
      },
      {
        "group": "comparison",
        "color": "secondary",
        "width": 1.0,
        "data": [180, 993.7, 0, 0, 257.4, 0, 0],
        "lineStyle": {
          "smooth": false,
          "dashArray": [3, 5]
        }
      }
    ],
    "xAxis": {
      "name": "date",
      "data": ["29 May", "30 May", "31 May", "1 Jun", "2 Jun", "3 Jun", "4 Jun"]
    },
    "yAxis": {"name": "revenue", "labelFormatter": "RM {value}"}
  }
};

// const lineData = {"data": []};
