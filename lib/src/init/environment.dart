class Environment {
  final String name;

  const Environment._(this.name);

  Environment.custom(this.name);

  static const local = Environment._('local');
  static const development = Environment._('development');
  static const production = Environment._('production');

  @override
  String toString() => name;

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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Environment &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;
}
