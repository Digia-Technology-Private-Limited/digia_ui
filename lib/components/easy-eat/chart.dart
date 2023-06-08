import 'package:digia_ui/components/DUIText/dui_text.dart';
import 'package:digia_ui/components/charts/line/dui_chart.dart';
import 'package:digia_ui/components/easy-eat/chart.props.dart';
import 'package:digia_ui/components/utils/DUIStyleClass/dui_style_class.dart';
import 'package:digia_ui/core/container/dui_container.dart';
import 'package:flutter/material.dart';

class EEChart extends StatelessWidget {
  final EEChartProps props;

  const EEChart({super.key, required this.props});

  factory EEChart.create(Map<String, dynamic> json) =>
      EEChart(props: EEChartProps.fromJson(json));

  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DUIText(props.heading),
        DUIText(props.mainText),
        DUIText(props.comparisonText),
        DUIChart(props.chartData),
        const SizedBox(height: 16),
        DUIContainer(
            styleClass: DUIStyleClass.fromJson(
                "al:center;bdr:8;p:8;bds:solid;bdc:224,224,224"),
            child: DUIText(props.bottomText))
      ],
    );
  }
}
