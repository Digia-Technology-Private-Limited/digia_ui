import 'base/action.dart';

class ActionDescriptor {
  final String? id;
  final ActionType type;
  final Map<String, dynamic> definition;
  final Map<String, dynamic> resolvedParameters;

  ActionDescriptor({
    this.id,
    required this.type,
    required this.definition,
    this.resolvedParameters = const {},
  });

  ActionDescriptor copyWith({
    String? id,
    ActionType? type,
    Map<String, dynamic>? definition,
    Map<String, dynamic>? resolvedParameters,
  }) {
    return ActionDescriptor(
      id: id ?? this.id,
      type: type ?? this.type,
      definition: definition ?? this.definition,
      resolvedParameters: resolvedParameters ?? this.resolvedParameters,
    );
  }
}
