## Getting Started

Few things to get started:

### Step 1: Add Pre-Commit Hook:
 - Linux / MacOS: `ln -s pre-commit.bash .git/hooks/pre-commit`
 - Windows: `mklink pre-commit.bash .git/hooks/pre-commit`

### Step 2: Install [derry]([https://pub.dev/packages/rps](https://pub.dev/packages/derry)).
(Derry is a script manager for Dart.)

1. `dart pub global activate derry`
2. Add `$HOME/.pub-cache/bin` to PATH: `export PATH=$PATH:$HOME/.pub-cache/bin`
3. For running a script, do: `derry build`

