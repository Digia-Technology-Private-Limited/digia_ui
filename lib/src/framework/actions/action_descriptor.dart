import '../utils/types.dart';
import 'base/action.dart';

class ActionDescriptor {
  final String? id;
  final ActionType type;
  final JsonLike definition;
  final JsonLike resolvedParameters;

  ActionDescriptor({
    this.id,
    required JsonLike definition,
    JsonLike resolvedParameters = const {},
    required this.type,
  })  : definition = Map.unmodifiable(definition),
        resolvedParameters = Map.unmodifiable(resolvedParameters);

  ActionDescriptor copyWith({
    String? id,
    ActionType? type,
    JsonLike? definition,
    JsonLike? resolvedParameters,
  }) {
    return ActionDescriptor(
      id: id ?? this.id,
      type: type ?? this.type,
      definition: definition ?? this.definition,
      resolvedParameters: resolvedParameters ?? this.resolvedParameters,
    );
  }
}
