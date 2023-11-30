import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum DividerOrientation {
  horizontal,
  vertical,
}

@JsonSerializable()
class DUIDividerProps {
  DividerOrientation _orientation;
  DividerOrientation get orientation => _orientation;

  DUIDividerProps({
    DividerOrientation? orientation,
  }): _orientation = orientation ?? DividerOrientation.horizontal;
}
