import 'package:styled_divider/styled_divider.dart';

DividerLineStyle? toLineStyle(String? style) {
  if (style == null) return null;
  switch (style) {
    case 'dashdotted':
      return DividerLineStyle.dashdotted;
    case 'dashed':
      return DividerLineStyle.dashed;
    case 'dotted':
      return DividerLineStyle.dotted;
    case 'solid':
      return DividerLineStyle.solid;
  }

  return null;
}
