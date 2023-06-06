import 'package:digia_ui/Utils/extensions.dart';
import 'package:digia_ui/Utils/util_functions.dart';
import 'package:digia_ui/components/utils/DUIStyleClass/dui_style_class.dart';
import 'package:digia_ui/core/container/dui_container.dart';
import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

class LineChart extends StatelessWidget {
  final DUIStyleClass? styleClass;

  final Map<String, dynamic> lineData;

  const LineChart({super.key, this.styleClass, required this.lineData});

  factory LineChart.fromJson(Map<String, dynamic> json) => LineChart(
      lineData: json['lineData'], styleClass: DUIStyleClass.fromJson(json));

  @override
  Widget build(BuildContext context) {
    final lines = lineData['lines'] as List<Map<String, dynamic>>;
    final x = lineData.valueFor(keyPath: 'axis.x.name');
    final y = lineData.valueFor(keyPath: 'axis.y.name');
    final colorMap = lines.fold({}, (previousValue, element) {
      previousValue[element['id']] = element['color'];
      return previousValue;
    });

    final mergedData = lines
        .map((l) {
          final p = l['points'] as List<Map<String, dynamic>>;
          return p.map((e) => {...e, 'groupBy': l['id'] as String});
        })
        .expand((e) => e)
        .toList();
    final child = Chart(
      data: mergedData,
      variables: {
        '$x': Variable(
          accessor: (Map<String, dynamic> dict) => dict[x] as String,
        ),
        '$y': Variable(
            accessor: (Map<String, dynamic> dict) => dict[y] as num,
            scale: LinearScale(
              ticks: [0, 250, 500, 750, 1000],
              formatter: (v) => 'RM ${v.toInt()}',
            )),
        'groupBy': Variable(
          accessor: (Map<String, dynamic> dict) => dict['groupBy'] as String,
        ),
      },
      marks: [
        LineMark(
          position: Varset(x) * Varset(y) / Varset('groupBy'),
          shape: ShapeEncode(value: BasicLineShape(dash: [5, 5])),
          size: SizeEncode(value: 0.5),
          color: ColorEncode(encoder: (p0) {
            return toColor(colorMap[p0['groupBy']]);
          }),
        )
      ],
      axes: [
        Defaults.horizontalAxis,
        Defaults.verticalAxis,
      ],
    );

    final widget = styleClass == null
        ? child
        : DUIContainer(styleClass: styleClass, child: child);

    return SingleChildScrollView(child: widget);
  }
}

const samplelineData = {
  "lines": [
    {
      "id": "revenue",
      "color": "primary",
      "width": 2,
      "showPoints": true,
      "points": [
        {'date': "29 May", "revenue": 148},
        {'date': "30 May", "revenue": 86.4},
        {'date': "31 May", "revenue": 340},
        {'date': "1 Jun", "revenue": 0},
        {'date': "2 Jun", "revenue": 0},
        {'date': "3 Jun", "revenue": 0},
        {'date': "4 Jun", "revenue": 0},
      ]
    },
    {
      "id": "comparison",
      "color": "secondary",
      "width": 2,
      "showPoints": false,
      "points": [
        {'date': "29 May", "revenue": 180},
        {'date': "30 May", "revenue": 993.7},
        {'date': "31 May", "revenue": 0},
        {'date': "1 Jun", "revenue": 0},
        {'date': "2 Jun", "revenue": 257.4},
        {'date': "3 Jun", "revenue": 0},
        {'date': "4 Jun", "revenue": 0},
      ]
    }
  ],
  "axis": {
    "x": {"name": "date"},
    "y": {"name": "revenue"}
  }
};

// const lineData = {"data": []};
