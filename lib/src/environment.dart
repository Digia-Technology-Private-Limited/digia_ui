// enum Environment { local, development, production }

// enum Flavor { debug, staging, release, version }

// sealed class Flavor {
//   Flavor flavor;
//   Flavor(this.flavor);
// }

// class Staging extends Flavor {
//   Staging() : super(Flavor.staging);
// }

// class Debug extends Flavor {
//   final String? branchName;
//   Debug(this.branchName) : super(Flavor.debug);
// }

// class Release extends Flavor {
//   InitPriority initPriority;
//   String appConfigPath;
//   String functionsPath;
//   Release(this.initPriority, this.appConfigPath, this.functionsPath)
//       : super(Flavor.release);
// }

// class Versioned extends Flavor {
//   int version;
//   Versioned(this.version) : super(Flavor.version);
// }

// sealed class InitPriority {}

// class PrioritizeNetwork extends InitPriority {
//   int timeout;
//   PrioritizeNetwork(this.timeout);
// }

// class PrioritizeCache extends InitPriority {}

// class PrioritizeLocal extends InitPriority {}
