import '../models/types.dart';
import '../utils/functional_util.dart';
import '../utils/types.dart';

class TextProps {
  final ExprOr<String>? text;
  final JsonLike? textStyle;
  final ExprOr<int>? maxLines;
  final ExprOr<String>? alignment;
  final ExprOr<String>? overflow;

  TextProps({
    this.text,
    this.textStyle,
    this.maxLines,
    this.alignment,
    this.overflow,
  });

  factory TextProps.fromJson(JsonLike json) {
    return TextProps(
      text: ExprOr.fromJson<String>(json['text']),
      textStyle: as$<JsonLike>(json['textStyle']),
      maxLines: ExprOr.fromJson<int>(json['maxLines']),
      alignment: ExprOr.fromJson<String>(json['alignment']),
      overflow: ExprOr.fromJson<String>(json['overflow']),
    );
  }
}
