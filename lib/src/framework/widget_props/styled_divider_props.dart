import 'package:flutter/material.dart';

import '../models/types.dart';
import '../utils/functional_util.dart';
import '../utils/types.dart';

class SizeProps {
  final ExprOr<double>? height;
  final ExprOr<double>? width;

  const SizeProps({this.height, this.width});

  factory SizeProps.fromJson(Map<String, dynamic> json) {
    return SizeProps(
      height: ExprOr.fromJson<double>(json['height']),
      width: ExprOr.fromJson<double>(json['width']),
    );
  }
}

class StyledDividerProps {
  final SizeProps? size;
  final ExprOr<double>? thickness;
  final String? lineStyle;
  final ExprOr<double>? indent;
  final ExprOr<double>? endIndent;
  final String? strokeCap;
  final ExprOr<Object?>? dashPattern;
  final ExprOr<Color>? color;
  final JsonLike? gradient;
  final String? borderPattern;

  const StyledDividerProps({
    this.thickness,
    this.lineStyle,
    this.indent,
    this.endIndent,
    this.strokeCap,
    this.dashPattern,
    this.color,
    this.gradient,
    this.borderPattern,
    this.size,
  });

  factory StyledDividerProps.fromJson(Map<String, dynamic> json) {
    return StyledDividerProps(
      size: SizeProps.fromJson(json),
      thickness: ExprOr.fromJson<double>(json['thickness']),
      gradient: as$<JsonLike>(json['colorType']?['gradiant']),
      lineStyle: as$<String>(json['lineStyle']),
      indent: ExprOr.fromJson<double>(json['indent']),
      endIndent: ExprOr.fromJson<double>(json['endIndent']),
      strokeCap: as$<String>(json['borderPattern']?['strokeCap']),
      dashPattern:
          ExprOr.fromJson<Object>(json['borderPattern']?['dashPattern']),
      color: ExprOr.fromJson<Color>(json['colorType']?['color']),
      borderPattern: as$<String>(json['borderPattern']?['value']),
    );
  }
}
