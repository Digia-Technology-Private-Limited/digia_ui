import '../models/types.dart';
import '../utils/functional_util.dart';
import '../utils/types.dart';

class RichTextProps {
  final ExprOr<List>? textSpans;
  final JsonLike? textStyle;
  final ExprOr<int>? maxLines;
  final ExprOr<String>? alignment;
  final ExprOr<String>? overflow;

  RichTextProps({
    this.textSpans,
    this.textStyle,
    this.maxLines,
    this.alignment,
    this.overflow,
  });

  factory RichTextProps.fromJson(JsonLike json) {
    return RichTextProps(
      textSpans: ExprOr.fromJson<List>(json['textSpans']),
      textStyle: as$<JsonLike>(json['textStyle']),
      maxLines: ExprOr.fromJson<int>(json['maxLines']),
      alignment: ExprOr.fromJson<String>(json['alignment']),
      overflow: ExprOr.fromJson<String>(json['overflow']),
    );
  }
}
