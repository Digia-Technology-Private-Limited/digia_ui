enum Environment { staging, production, version }

sealed class EnvironmentInfo {
  Environment environment;
  EnvironmentInfo(this.environment);
}

class Staging extends EnvironmentInfo {
  Staging() : super(Environment.staging);
}

class Production extends EnvironmentInfo {
  InitPriority initPriority;
  String appConfigPath;
  String functionsPath;
  Production(this.initPriority, this.appConfigPath, this.functionsPath)
      : super(Environment.production);
}

class Versioned extends EnvironmentInfo {
  int version;
  Versioned(this.version) : super(Environment.version);
}

sealed class InitPriority {}

class PrioritizeNetwork extends InitPriority {
  int timeout;
  PrioritizeNetwork(this.timeout);
}

class PrioritizeCache extends InitPriority {}

class PrioritizeLocal extends InitPriority {}
