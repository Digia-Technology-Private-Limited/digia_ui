# Digia UI SDK

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)](https://flutter.dev)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

A powerful Flutter SDK for rendering server-driven UI (SDUI) in mobile applications. Part of the Digia Studio platform, this SDK enables dynamic UI updates and business logic changes without app store deployments.

## Overview

Digia UI SDK is the rendering engine for Digia Studio's low-code platform. It interprets JSON configurations to render native Flutter widgets, handle data bindings, and execute actions - all without requiring app rebuilds or store approvals.

### Key Features

- 🚀 **Dynamic UI Rendering** - Render Flutter widgets from server-driven JSON configurations
- 🔄 **Real-time Updates** - Push UI and logic changes instantly without app store approvals
- 💉 **Expression Binding** - Powerful data binding system for dynamic content
- 🎯 **Action System** - Pre-built actions for navigation, state management, API calls, and more
- 📱 **Native Performance** - Direct compilation to native code with Flutter's performance
- 🎨 **Theme Support** - Dynamic theming with support for light/dark modes
- 📊 **Analytics Ready** - Built-in hooks for analytics and tracking

## Installation

Add Digia UI SDK to your Flutter project:

```yaml
dependencies:
  digia_ui: ^latest_version
```

## Quick Start

1. Initialize the SDK in your main.dart:

```dart
void main() {
  runApp(
    DigiaUIScope(
      child: DUIApp(
        digiaAccessKey: 'YOUR_ACCESS_KEY',
        baseUrl: 'YOUR_API_BASE_URL',
        environment: 'production',
        flavorInfo: FlavorInfo(...),
        networkConfiguration: NetworkConfiguration(...),
      ),
    ),
  );
}
```

2. Render a dynamic page:

```dart
DUIFactory().createPage('page_id', args);
```

## Core Concepts

### Pages and Components

- **Pages**: Full-screen UI definitions with lifecycle hooks and state management
- **Components**: Reusable UI blocks that can be composed into pages
- Both pages and components are defined using JSON configurations from your Digia Studio project

### State Management

The SDK provides three levels of state management:

1. **Page State**: Scoped to individual pages
2. **Global State**: App-wide state with optional persistence
3. **Component State**: Local state for reusable components

```dart
// Access global state
DUIAppState().value['stateKey']

// Initialize persistent state
await DUIAppState().init(
  stateDescriptors,
  sharedPreferences,
);
```

### Actions

Pre-built actions for common mobile app operations:

- Navigation (`navigateToPage`, `navigateBack`)
- State Management (`setState`, `setAppState`)
- UI Controls (`showDialog`, `showBottomSheet`, `showToast`)
- Network (`callRestApi`)
- File Operations (`filePicker`, `imagePicker`)
- And more...

### Expression Binding

Dynamic expressions for data binding and computed values:

```json
{
  "text": "${user.name}",
  "visible": "${cart.items.length > 0}",
  "onTap": "${actions.navigateToPage('details', { id: item.id })}"
}
```

## Architecture

The SDK follows a clean architecture pattern with these key components:

- **DUIApp**: Root widget that bootstraps the SDK
- **DigiaUIScope**: Provides SDK context and message bus throughout the widget tree
- **DUIFactory**: Creates pages and components from JSON definitions
- **ConfigResolver**: Handles configuration loading and versioning
- **ActionExecutor**: Processes and executes actions
- **VirtualWidgetRegistry**: Manages widget creation and rendering

## Advanced Usage

### Custom Widget Registration

```dart
DUIFactory().registerWidget(
  'custom_widget',
  CustomWidgetProps.fromJson,
  (props, childGroups) => CustomVirtualWidget(props, childGroups),
);
```

### Network Configuration

```dart
NetworkConfiguration(
  timeout: Duration(seconds: 30),
  retryPolicy: RetryPolicy(...),
  interceptors: [...],
)
```

### Analytics Integration

```dart
DUIAnalytics(
  onPageView: (pageId, args) => trackScreen(pageId),
  onAction: (action) => trackAction(action),
)
```

## Best Practices

1. **Configuration Management**

   - Use environment-specific configurations
   - Implement proper version control for configurations
   - Cache configurations for offline support

2. **Performance**

   - Register only necessary widgets
   - Use lazy loading for heavy components
   - Implement proper error boundaries

3. **State Management**
   - Keep state granular and page-specific when possible
   - Use global state sparingly
   - Implement proper cleanup in stateful widgets

## Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

- 📚 [Documentation](https://docs.digia.studio)
- 💬 [Community Support](https://community.digia.studio)
- 🐛 [Issue Tracker](https://github.com/digia/digia-ui/issues)
