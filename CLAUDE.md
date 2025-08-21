# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

### Build & Development
```bash
# Install dependencies
derry i
# or: flutter pub get

# Run code generation (build_runner)
derry build
# or: dart run build_runner build --delete-conflicting-outputs

# Format and fix code
derry lint
# or: derry fix; derry format

# Static analysis
derry analyze
# or: dart analyze

# Clean and rebuild
derry clean build
```

### Testing
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/flavors/debug_test.dart

# Run tests with coverage
flutter test --coverage
```

### Example App
```bash
# Run example app
cd example && flutter run

# Run with specific device
cd example && flutter run -d chrome
```

## Architecture Overview

### Digia UI SDK
This is the Flutter-based rendering engine for **Digia Studio**, a low-code mobile application platform. The SDK uses **Server-Driven UI (SDUI)** architecture to dynamically render native Flutter widgets from JSON configurations, enabling real-time UI updates without app store releases.

### Initialization Strategies
The SDK offers two initialization approaches to suit different needs:

#### NetworkFirst Strategy
- Prioritizes fresh content from CDN (< 100ms load times)  
- Recommended for production where latest content is critical
- Falls back to cache/local assets on timeout

#### CacheFirst Strategy  
- Instant startup using cached configuration
- Updates fetched in background for next session
- Best for fast startup times and offline capability

### Implementation Patterns

#### Option 1: DigiaUIApp (Eager Initialization)
```dart
void main() async {
  final digiaUI = await DigiaUI.initialize(
    DigiaUIOptions(
      accessKey: 'YOUR_ACCESS_KEY',
      flavor: Flavor.release(
        initStrategy: NetworkFirstStrategy(timeoutInMs: 2000),
        appConfigPath: 'assets/config.json',
        functionsPath: 'assets/functions.js'
      ),
    ),
  );
  
  runApp(DigiaUIApp(digiaUI: digiaUI, builder: (context) => MaterialApp(...)));
}
```

#### Option 2: DigiaUIAppBuilder (Lazy Initialization)  
```dart
void main() {
  runApp(DigiaUIAppBuilder(
    options: DigiaUIOptions(...),
    builder: (context, status) {
      if (status.isReady) return MaterialApp(home: DUIFactory().createInitialPage());
      if (status.isLoading) return LoadingWidget();
      return ErrorWidget();
    },
  ));
}
```

### Core Architecture

#### Configuration Flow
1. **DigiaUI.initialize()** - Loads DSL config via ConfigResolver
2. **DUIFactory().initialize()** - Sets up widget registry and UI resources  
3. **ConfigResolver** uses different ConfigSource implementations based on Flavor:
   - `NetworkConfigSource` - Loads from server
   - `AssetConfigSource` - Loads from local assets
   - `CacheConfigSource` - Loads from cached data

#### Virtual Widget System
- **VirtualWidget** base class - Abstract widget with `render(RenderPayload)` method
- **VirtualWidgetRegistry** - Maps JSON widget types to Flutter widgets
- **RenderPayload** - Contains resources, state, scope context for rendering
- 60+ built-in virtual widgets in `lib/src/framework/widgets/`

#### State Management (4 Levels)
1. **Global State** (`DUIAppState`) - App-wide, persistent, bidirectional with native code
2. **Page State** - Scoped to pages, cleared on navigation
3. **Component State** - Local to component instances  
4. **Local State** - Widget-level via State Container widgets

#### Action System
**ActionExecutor** processes declarative JSON actions:
- 20+ built-in actions in `lib/src/framework/actions/`
- Each action has dedicated processor (navigation, state, UI, API, files)
- Actions triggered by UI events execute Flutter operations

#### Expression Binding  
- Uses `digia_expr` package for dynamic data binding
- JavaScript execution via `flutter_js` for complex logic
- Method bindings provide Flutter APIs to expressions
- Variables accessible in `AppStateScopeContext`

## Key Patterns

### Usage Patterns

#### Full App Mode
Build entire app in Digia Studio, rendered via SDK:
```dart
MaterialApp(
  home: DUIFactory().createInitialPage(),
  onGenerateRoute: (settings) => DUIFactory().createPageRoute(
    settings.name!,
    settings.arguments as Map<String, dynamic>?,
  ),
)
```

#### Hybrid Mode  
Mix native Flutter with Digia UI pages:
```dart
Navigator.push(context, MaterialPageRoute(
  builder: (_) => DUIFactory().createPage('checkout_page', {
    'cartId': cartId,
    'userId': userId,
  }),
));
```

### Widget Registration
```dart
// Type-safe widget registration
DUIFactory().registerWidget<MapProps>(
  'custom/map',
  MapProps.fromJson,
  (props, childGroups) => CustomMapWidget(props),
);

// JSON widget registration
DUIFactory().registerJsonWidget(
  'custom/simple',
  (props, childGroups) => SimpleWidget(props['text']),
);
```

### State Management Integration
```dart
// Set state from native Flutter code (bidirectional)
DUIAppState().setValue('cartCount', cart.length);
DUIAppState().setValue('user', userProfile.toJson());

// Listen to state changes in native code
StreamSubscription _subscription = DUIAppState().listen('cartCount', (value) {
  _updateCartBadge(value);
});
```

### Environment Variables
```dart
// Runtime environment configuration  
DUIFactory().setEnvironmentVariable('baseUrl', 'https://api.com');
DUIFactory().setEnvironmentVariables({
  'baseUrl': 'https://api.example.com',
  'userId': 12345,
  'isLoggedIn': true,
});
```

## Configuration Structure

### Flavor System
Different flavors for different deployment scenarios:
- **`Flavor.debug()`** - Real-time server config, optional branch
- **`Flavor.staging()`** - Production-like with remote updates
- **`Flavor.versioned(version: 123)`** - Specific version loading
- **`Flavor.release()`** - Local assets, NetworkFirst/CacheFirst strategies

### Network Configuration  
- **NetworkClient** - Handles API communication with default Digia headers
- **NetworkConfiguration** - Configurable timeouts, retry policies, interceptors
- **API Models** - Defined in `restConfig` section of DUIConfig

### Resource Management
- **UIResources** - Container for icons, images, textStyles, colors
- Runtime resource overrides per page/component
- Theme support with light/dark color token maps
- Custom font factory support

## Testing Structure
- **Unit Tests** in `test/` with mock configurations
- **Flavor Testing** in `test/flavors/` for initialization strategies  
- **Mock Data** via `test/mocks.dart` and `test/config_data.dart`

## Key Dependencies & Requirements
- **Flutter 3.3.0+** and **Dart 3.3.0+**
- **`digia_expr: 0.0.15`** - Expression evaluation engine
- **`flutter_js: 0.8.5`** - JavaScript execution capability
- **Platform Support**: Android, iOS, Mobile Web
- **Business Source License 1.1** (converts to Apache 2.0 in 2029)