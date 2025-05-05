# ui_sdk

Digia Ui SDK.

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
