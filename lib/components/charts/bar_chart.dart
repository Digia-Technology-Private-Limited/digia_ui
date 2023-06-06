import 'package:digia_ui/Utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

class BarGraph extends StatelessWidget {
  const BarGraph({super.key});

  @override
  Widget build(BuildContext context) {
    final x = barData.valueFor(keyPath: 'chart.x');
    final y = barData.valueFor(keyPath: 'chart.y');
    var child =
        Chart(data: barData['data'] as List<Map<String, dynamic>>, variables: {
      '$x': Variable(
        accessor: (Map<String, dynamic> dict) => dict[x] as String,
      ),
      '$y': Variable(
        accessor: (Map<String, dynamic> dict) => dict[y] as num,
      )
    }, marks: [
      IntervalMark(
          position: Varset(x) * Varset(y),
          label: LabelEncode(encoder: (p0) => Label(p0[y].toString())))
    ]);

    return child;
  }
}

const barData = {
  "data": [
    {
      'date': '26 May',
      'order_type': 'Dine-In',
      'orderCount': 4,
    },
    {
      'date': '26 May',
      'order_type': 'Delivery',
      'orderCount': 0,
    },
    {
      'date': '26 May',
      'order_type': 'Pick-up',
      'orderCount': 1,
    },
    {
      'date': '27 May',
      'order_type': 'Dine-In',
      'orderCount': 0,
    },
    {
      'date': '27 May',
      'order_type': 'Delivery',
      'orderCount': 0,
    },
    {
      'date': '27 May',
      'order_type': 'Pick-up',
      'orderCount': 0,
    },
    {
      'date': '28 May',
      'order_type': 'Dine-In',
      'orderCount': 0,
    },
    {
      'date': '28 May',
      'order_type': 'Delivery',
      'orderCount': 0,
    },
    {
      'date': '28 May',
      'order_type': 'Pick-up',
      'orderCount': 0,
    },
    {
      'date': '29 May',
      'order_type': 'Dine-In',
      'orderCount': 1,
    },
    {
      'date': '29 May',
      'order_type': 'Delivery',
      'orderCount': 1,
    },
    {
      'date': '29 May',
      'order_type': 'Pick-up',
      'orderCount': 5,
    },
    {
      'date': '30 May',
      'order_type': 'Dine-In',
      'orderCount': 2,
    },
    {
      'date': '30 May',
      'order_type': 'Delivery',
      'orderCount': 0,
    },
    {
      'date': '30 May',
      'order_type': 'Pick-up',
      'orderCount': 0,
    },
    {
      'date': '31 May',
      'order_type': 'Dine-In',
      'orderCount': 1,
    },
    {
      'date': '31 May',
      'order_type': 'Delivery',
      'orderCount': 0,
    },
    {
      'date': '31 May',
      'order_type': 'Pick-up',
      'orderCount': 0,
    },
    {
      'date': '01 Jun',
      'order_type': 'Dine-In',
      'orderCount': 0,
    },
    {
      'date': '01 Jun',
      'order_type': 'Delivery',
      'orderCount': 0,
    },
    {
      'date': '01 Jun',
      'order_type': 'Pick-up',
      'orderCount': 0,
    },
  ],
  "chart": {"x": "date", "y": "orderCount"}
};
