# ui_sdk

Digia Ui SDK.

## [1.8.0] - 2026-03-17
- ✏️ TextField Enhancements: Added regex-based formatting and text capitalization support for better input control.
- 🎨 AppBar: Added support for surfaceTintColor to improve theming flexibility.
- 🧭 BottomNavigationBar: Fixed an issue where hidden items (showIf = false) still occupied layout space.
- 🔄 StreamController: Control Object action now works correctly.

## [1.7.0] - 2026-02-12
- 🎨 Dynamic Layouts: width and height in Button and Container widgets, along with Stack positioning, can now be driven dynamically.
- 🆕 Scratchify Widget: Introduced Scratchify — build beautiful, interactive scratch cards with ease.
- ▶️ YouTube Player: Fixed platform inconsistencies; the player now works correctly on Android and iOS, matching web behavior.
- 🎞️ Lottie Callbacks: Added completion callback support when a Lottie animation finishes (applicable when repeat is set to once).
- 🖼️ Local Assets Preview: Local assets can now be viewed directly in Digia Preview as well as the Dashboard.
- 🧭 Overlay Control: DigiaUI can now be instructed to programmatically show or hide bottom sheets and dialogs — useful when triggering overlays from a host screen.
- 📊 Charts: Fixed an issue where library-defined colors were not applied correctly.
- 📅 Calendar Widget: Header UI refinements for a cleaner and more consistent appearance.

## [1.6.1] – 2026-01-19
- 🎚️ Slider Widget: Fixed a lag issue during drag interactions for smoother responsiveness.
- 🎥 Video Player: Resolved an issue where the video content did not respect the parent container’s aspect ratio.
- 🎨 Expressions: Fixed a bug where expressions were not evaluated correctly in color properties.
- 📊 Charts: Corrected an issue where chart colors did not properly reflect their corresponding values.

## [1.6.0] – 2025-12-23

- 📅 Calendar Widget: Added support for year selection, allowing users to quickly navigate to a specific year.
- ✏️ TextField Improvements: Visual refinements and enhanced developer control over content padding and layout for better look and feel.

## [1.5.0] – 2025-12-19

- 🧑‍🎨 Avatar Widget: Fixed an issue where the oval shape was not respected when an image was applied
- 🧱 GridView: Improved compatibility and smoother behavior when used with SmartScrollView
- ✨ Gradient Text Support: Added support for gradients in text — bring richer visuals and expressive styling to your typography

## [1.4.0] – 2025-11-19

This release introduces beautiful new UI widgets that make designing stunning apps easier than ever.

- 🎚️ Slider: A smooth and fully customizable slider widget — perfect for selecting values with precision
- 📖 Story: Create Instagram-style stories effortlessly with built-in transitions and autoplay
- 📊 Charts: Build beautiful, interactive charts with minimal configuration
- 🧱 Masonry GridView: Create Pinterest-style staggered grids for dynamic, adaptive layouts

Also, we have removed support for AVIF image format, trimming the APK size by over 1 MB.

## [1.3.0] – 2025-10-27

- 🧭 NavigationBarCustom: Added support for separate selected and unselected widgets — fully customizable NavigationBarItem states.
- 🧱 Layout Improvements: Removed reliance on LayoutBuilder in certain widgets to avoid issues with IntrinsicHeight. Size is now measured efficiently without performance loss.
- ✏️ TextField: Added support for prefix and suffix icon constraints — perfect for customizing icon sizes.
- 🎠 Carousel: Height and width no longer default to double.infinity, preventing unbounded constraint issues.

## [1.2.1] – 2025-10-01

- 🐞 Fixed an issue where context was being unmounted after async calls
- 🧹 Removed unsupported delay option from FutureBuilder (was never intended for use)

## [1.2.0] – 2025-09-29

- 🖥️ New Debug Console: View network requests, state changes, and app events in real-time while previewing on the Dashboard. [See integration steps](https://github.com/Digia-Technology-Private-Limited/digia_inspector)
- 🔗 GraphQL Support: Digia now supports GraphQL queries and mutations.
- 🖼️ Image Widget: Added alignment property; fixed Blurhash rendering issues.
- 🔒 TextField: obscureText is now dynamic — perfect for show/hide password toggles.
- 🎨 Button Widget: Redesigned to look and behave more like a standard button.
- 🏗️ Column & Row Widgets: Added spacing options (between items, start, and end).
- 🎠 Carousel: Improved behavior to better match WYSIWYG experience in Digia Studio.
- 🐞 StreamBuilder: Fixed bug preventing a stream from being subscribed to multiple times.
- 🐞 Parent Properties: Fixed issue where properties like Flex expansion and Stack positioning were not applied to components.
- 🧹 Chores & Hygiene: General codebase improvements and cleanup.

## [1.1.0] – 2025-08-21

- ✅ Verified compatibility with Flutter 3.35.1
- 📦 Updated several packages to newer versions for hygiene
- 📖 Improved README documentation
- ✨ Added indicator decoration support to TabBar
- 🔄 Upgraded SmartAuth to latest for Android 35 compatibility
- 🐞 Fixed SVG color rendering issue
- 🐞 Fixed keyboard stuttering on open/close (dependency issue) — details

## [1.0.0] – 2025-08-07

⚠ This version is not backward compatible with 0.x.x.
Public Release (1.0.0)

## [1.0.0-rc.9] – 2025-08-06 (Release Candidate)

⚠ This version is not backward compatible with 0.x.x.

- 🐞 Fixed a bug where nearest context was not being used inside Bottomsheet.

## [1.0.0-rc.8] – 2025-08-06 (Release Candidate)

⚠ This version is not backward compatible with 0.x.x.

- ✨ Added support for `resizeToAvoidBottomInset` in Scaffold. Defaults to true.

## [1.0.0-rc.7] – 2025-08-04 (Release Candidate)

⚠ This version is not backward compatible with 0.x.x.

- ✨ Added support for async calling of JS functions
- ✨ Widgets now expose all internal scope variables with their own name as prefix (e.g., widgetA.varA)
- 🐞 Bug fixes in UploadAction and ImagePicker
- 🐞 Fixed gradient issues in border rendering
- 🎨 Added support for radial gradients

## [1.0.0-rc.6] – 2025-07-23 (Release Candidate)

⚠ This version is not backward compatible with 0.x.x.

- Fixed compatibility with Flutter 3.32.X

## [1.0.0-rc.5] – 2025-07-21 (Release Candidate)

⚠ This version is not backward compatible with 0.x.x.

- 🐞 Bug fixes in SetState Action
- 🛠️ Changes to FutureBuilder's exposed variables

## [1.0.0-rc.4] – 2025-07-21 (Release Candidate)

⚠ This version is not backward compatible with 0.x.x.

- 🐞 Bug fixes to Switch Widget

## [1.0.0-rc.3] – 2025-07-18 (Release Candidate)

⚠ This version is not backward compatible with 0.x.x.

- 🛠️ Minor functionality improvements to Switch Widget

## [1.0.0-rc.2] – 2025-07-18 (Release Candidate)

⚠ This version is not backward compatible with 0.x.x.

- 🛠️ Minor functionality improvements in FutureBuilder and PaginatedListView
- 🧭 WebView can now intercept the back button to navigate within its own stack before exiting (Android only)

## [1.0.0-rc.1] – 2025-07-15 (Release Candidate)

⚠ Breaking Changes:
This version is not backward compatible with 0.x.x.
Most widgets have been overhauled, and the property binding system has been redesigned to support our new Visual Dashboard experience — including Drag & Drop, live property editing, and dynamic controller bindings.

If you're upgrading from a previous version, please refer to the migration guide to adapt existing configurations.

## [0.4.3] - 2025-07-04

- 🔁 Reverted previous fix for StateContainer value retention — it will now reinitialize on every rebuild
- A comprehensive fix addressing both concerns will be released soon
- 🐞 Fixed an issue where TextField malfunctioned when both controller and initialValue were set
- 🐞 Added null safety handling for Analytics events

## [0.4.2] - 2025-06-29

- 🛠️ Initial page in carousel can now be dynamic

## [0.4.1] - 2025-06-27

- 🐞 Fixed a bug where StateContainer values were lost when the parent widget rebuilt

## [0.4.0] - 2025-06-24

- 🔧 Revamped message handling in DigiaUI SDK — messages can now be listened to globally without passing handlers to each page
- Simply extend DigiaMessageHandlerMixin in any stateful widget and register the messages you want to handle

## [0.3.22] - 2025-06-24

- 🐞 Fixed a rare race condition that could cause app crashes during initialization
- 🐞 Resolved padding issues with bullet points in the HTML widget
- 🛠️ Improved BottomSheet to be keyboard-aware and respect safe area insets

## [0.3.21] - 2025-06-19

- 🐞 Fixed a bug in PaginatedList where a default UI was shown when custom no-items or no-more-items indicators were not provided

## [0.3.20] - 2025-06-18

- 🐞 Fixed a bug in Carousel where numeric values were not properly converted to num type

## [0.3.19] - 2025-06-16

- 🌗 Added support for both Light and Dark themes for a better adaptive UI experience

## [0.3.18] - 2025-06-14

- 🆕 Added an option in PageView to prebuild all pages — recommended only for a small number of pages
- 🎨 Image widget now supports Lottie animations as placeholders
- 🐞 Fixed gradient angle issue in rectangular boxes by replacing angle with begin and end alignments

## [0.3.17] - 2025-06-10

- 🆕 Introduced RangeSlider widget for selecting a value range with two draggable thumbs
- 🐞 Fixed a memory leak issue that could cause out-of-memory exceptions on low-end devices
- 🎯 Added onChange action support to Carousel for better interactivity

## [0.3.16] - 2025-05-23

- ✅ APIs now support application/x-www-form-urlencoded content type
- 🎨 Images now fade in by default for a smoother experience
- 🐞 Fixed unnecessary SafeArea padding caused by empty persistent footer buttons in Scaffold
- 🐞 Stream’s onSuccess and onError callbacks no longer depend on StreamBuilder
- 🐞 Error texts in Image widget are now hidden in production builds

## [0.3.15] - 2025-05-20

- 🛠️ TextField’s default debounceValue is now 0 — should be configured via Dashboard
- 🐞 Fixed a bug where unsupported cached config was picked over burned config
- 🆕 GridView now automatically lays out children based on their sizes

## [0.3.14] - 2025-05-13

- 🐞 Fixed scrolling issue in Markdown tables
- 🛠️ Enabled debug logs for JS in development mode

## [0.3.13] - 2025-05-12

- 🆕 Deprecated the old way of firing events — FireEvent is now an Action
- ⚡ Significantly improved performance of JS functions by resolving an intricate issue

## [0.3.12] - 2025-05-09

- - 🆕 Feature: Introduced a brand-new Markdown widget — render beautiful, rich text effortlessly
- - ✨ Enhancement: Components can now execute callbacks
- - ✨ Enhancement: TextField now supports autofocus and onSubmit action
- - ✨ Enhancement: Improved performance in the Image widget
- - 🐞 Bug Fix:Fixed an issue where reading directly from AppState did not return the latest values

## [0.3.11] - 2025-05-05

- 🐞 Bug Fix: Issue fixed where overlays would dismiss when their internal content was scrollable

## [0.3.10] - 2025-05-02

- ✨ Enhancement: Added KeepAlive option for Carousel items to improve performance with costly layouts
- ✨ Enhancement: TextField’s onTextChange is now debounced
- ✨ Enhancement: Exposed AppState for integrated environments
- ✨ Enhancement: Stream’s value is now accessible in onSuccess action

## [0.3.9] - 2025-04-29

- ⚙️ Enhancement: Improved performance in NestedScrollView
- 🐞 Bug Fix: Fixed issue where height and width in some widgets broke when using int values

## [0.3.8] - 2025-04-24

- ✨ Enhancement: Added support for onTabChange callback in TabController
- ✨ Enhancement: Expressions are now supported in complex data types
- ✨ Enhancement: SliverAppBar’s expanded and collapsed heights now support expressions
- 🐞 Bug Fix: Boolean values in AppState were not working properly
- 🐞 Bug Fix: Message Handler now propagates correctly across pages with BottomNavigation

## [0.3.7] - 2025-04-18

- ✅ AppState Support: Introduced AppState with persistent and observable values
- ✨ Carousel Enhancements: Added new dot-indicator effects
- 🎨 BottomNav Upgrades: Added support for shadow, corner radius, and image icons
- 🐞 Bug Fix: Improved stability of Flutter Stepper
- 🐞 Bug Fix: API variable names now support hyphens (-)

## [0.3.6] - 2025-03-31

- Set Environment Variables from outside
- Support for padEnds in PageView
- Support for AVIF Images
- Label, Hint, Error texts can now be expressions

## [0.3.5] - 2025-03-26

- Bug fix for failing testcase

## [0.3.4] - 2025-03-26

- Bug fixes

## [0.3.3] - 2025-03-26

- Added support for dismiss on tap inside in overlay.
- Added support for onChanged in Switch
- Bug-Fixes.

## [0.3.2] - 2025-03-26

- Added support for PageView's Controller.
- Support for 'indeterminate' in CircularProgressBar
- Bug-Fixes.

## [0.3.1] - 2025-03-10

- Added support for PageView.
- PaginatedList has now support for user-defined pageKey.
- Added support for ImagePicker.
- Bug-Fix: AnimatedSwitcher will now animate even if first & second child are of same type.

## [0.3.0] - 2025-02-18

- Added branching

## [0.2.0] - 2025-02-18

- Added branching

## [0.1.7] - 2025-01-31

- Bug fixes

## [0.1.6] - 2024-12-16

- Prepared for flutter 3.24

## [0.1.5] - 2024-12-09

- - Gridview padding removed
- - typo fix in File.

## [0.1.4] - 2024-12-02

- Added missing export in Digia UI client

## [0.1.3] - 2024-11-28

- BugFix: Rebuild Page was not working.

## [0.1.2] - 2024-11-26

- Bug Fixes in TimerController

## [0.1.1] - 2024-11-26

- Bug fixes

## [0.1.0] - 2024-11-19

- 1. SDK Revamp - Introduction of State Containers & Components
- 2. Support for Controllers and some complex objects.

## [0.0.7] - 2024-11-12

- 1. Introduction of Virtual Widgets 2) State Containers 3) Components

## [0.0.6-beta.35] - 2024-10-10

- Tab reload fix

## [0.0.6-beta.34] - 2024-10-04

- ScrollNotifier on ScrollViews
- Animated Switcher <> Animated Builder

## [0.0.6-beta.33] - 2024-09-25

- New Sliver widgets.
- Nested Scroll View
- Bug fixes

## [0.0.6-beta.32] - 2024-08-09

- Bug Fixes (Stepper Alignment)

## [0.0.6-beta.31] - 2024-08-08

- Bug Fixes (TabView reverted)

## [0.0.6-beta.30] - 2024-08-07

- Bug Fixes

## [0.0.6-beta.29] - 2024-07-26

- Support for Custom Navigator
- Bug Fixes

## [0.0.6-beta.28] - 2024-07-23

- Bug fixes in Config fetch
- Added alignment in Container (Default Props)
- Separate styles for body,span & para in HTML View.

## [0.0.6-beta.27] - 2024-07-22

- New and safe way to initialize Digia SDK.
- Refresh Indicator Component.

## [0.0.6-beta.26] - 2024-07-15

- Timer (Bug fix)

## [0.0.6-beta.25] - 2024-07-13

- Paginated ListView
- Timer
- Bug fixes

## [0.0.6-beta.24] - 2024-07-08

- Support for Action onBackPressed

## [0.0.6-beta.23] - 2023-07-03

- Bug fixes

## [0.0.6-beta.22] - 2023-06-26

- New Components
- Bug fixes

## [0.0.6-beta.21] - 2023-06-14

- Bug fixes

## [0.0.6-beta.20] - 2023-06-14

- Support for Dynamic Text Color
- Bug fixes

## [0.0.6-beta.19] - 2023-06-06

Bug fixes + Validations

## [0.0.6-beta.18] - 2023-06-04

Bug fixes + Validations

## [0.0.6-beta.17] - 2023-06-04

Bug Fixes

## [0.0.6-beta.16] - 2023-06-03

Support for Checkbox

## [0.0.6-beta.15] - 2023-05-31

Support for Checkbox

## [0.0.6-beta.14] - 2023-05-31

Support for Checkbox

## [0.0.6-beta.13] - 2023-05-31

Bug Fixes

## [0.0.6-beta.12] - 2023-05-31

Bug Fixes

## [0.0.6-beta.11] - 2023-05-30

Bug Fixes

## [0.0.6-beta.10] - 2023-05-30

Bug Fixes

## [0.0.6-beta.9] - 2023-05-30

Bug Fixes

## [0.0.6-beta.8] - 2023-05-30

Bug Fixes

## [0.0.6-beta.7] - 2023-05-30

Bug Fixes

## [0.0.6-beta.6] - 2023-05-29

Bug Fixes

## [0.0.6-beta.5] - 2023-05-29

Whats new

1. Support for pushAndRemoveUntil

## [0.0.6-beta.4] - 2023-05-29

Whats new

1. Support for popUntil
2. Added Digia analytics for apis and actions

## [0.0.6-beta.3] - 2023-05-28

Whats new

1. Now chain actions to do more
2. Get API success/failures

## [0.0.6-beta.2] - 2023-05-28

Whats new

1. Added new future builder support
2. Devtools like chucker and proxy support
3. Default base headers support for apis

## [0.0.6] - 2023-05-27

Whats new

1. Added new future builder support
2. Devtools like chucker and proxy support
3. Default base headers support for apis

## [0.0.6] - 2023-05-27

Whats new

1. Added new future builder support
2. Devtools like chucker and proxy support
3. Default base headers support for apis

## [0.0.5] - 2023-05-23

removed mixpanel support

## [0.0.4] - 2023-05-23

updated lottie version, and pop on digia message

## [0.0.3] - 2023-05-23

Third release!

## [0.0.2] - 2023-04-18

second release!

## [0.0.1] - 2023-04-18

first release!
