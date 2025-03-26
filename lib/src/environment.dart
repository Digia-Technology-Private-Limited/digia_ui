enum Environment { local, development, production }

enum Flavor { debug, staging, release, version }

sealed class FlavorInfo {
  Flavor flavor;
  FlavorInfo(this.flavor);
}

class Staging extends FlavorInfo {
  Staging() : super(Flavor.staging);
}

class Debug extends FlavorInfo {
  final String? branchName;
  Debug(this.branchName) : super(Flavor.debug);
}

class Release extends FlavorInfo {
  InitPriority initPriority;
  String appConfigPath;
  String functionsPath;
  Release(this.initPriority, this.appConfigPath, this.functionsPath)
      : super(Flavor.release);
}

class Versioned extends FlavorInfo {
  int version;
  Versioned(this.version) : super(Flavor.version);
}

sealed class InitPriority {}

class PrioritizeNetwork extends InitPriority {
  int timeout;
  PrioritizeNetwork(this.timeout);
}

class PrioritizeCache extends InitPriority {}

class PrioritizeLocal extends InitPriority {}
