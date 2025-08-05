/// Represents the target environment for the Digia UI SDK.
///
/// Environments determine which backend services and configuration
/// the SDK connects to. Common environments include local, development, and production.
class Environment {
  /// The name of this environment.
  final String name;

  /// Creates an environment with the specified name (for predefined environments).
  const Environment._(this.name);

  /// Creates a custom environment with the specified name.
  Environment.custom(this.name);

  /// Local development environment.
  static const local = Environment._('local');

  /// Development/testing environment.
  static const development = Environment._('development');

  /// Production environment.
  static const production = Environment._('production');

  /// Returns the environment name as a string.
  @override
  String toString() => name;

  /// Creates an Environment from a string name.
  ///
  /// Returns predefined environments for 'local', 'development', and 'production'.
  /// For other names, creates a custom environment.
  static Environment fromString(String name) {
    switch (name.toLowerCase()) {
      case 'local':
        return local;
      case 'development':
        return development;
      case 'production':
        return production;
      default:
        return Environment.custom(name);
    }
  }

  /// Checks equality based on environment name.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Environment &&
          runtimeType == other.runtimeType &&
          name == other.name;

  /// Returns hash code based on environment name.
  @override
  int get hashCode => name.hashCode;
}
