import 'package:collection/collection.dart';

enum DataType {
  string('string'),
  number('number'),
  boolean('boolean'),
  json('json'),
  jsonArray('list'),
  scrollController('scrollController'),
  timerController('timerController'),
  streamController('streamController'),
  asyncController('asyncController'),
  textEditingController('textFieldController'),
  file('file');

  final String id;

  const DataType(this.id);

  static DataType? fromString(dynamic value) {
    return values.firstWhereOrNull((e) => e.id == value);
  }
}
