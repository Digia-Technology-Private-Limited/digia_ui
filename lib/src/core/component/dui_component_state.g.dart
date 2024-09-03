// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dui_component_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DUIComponentStateCWProxy {
  DUIComponentState componentUid(String componentUid);

  DUIComponentState props(DUIComponentProps props);

  DUIComponentState componentArgs(Map<String, dynamic>? componentArgs);

  DUIComponentState isLoading(bool isLoading);

  DUIComponentState widgetVars(Map<String, Map<String, Function>> widgetVars);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DUIComponentState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DUIComponentState(...).copyWith(id: 12, name: "My name")
  /// ````
  DUIComponentState call({
    String? componentUid,
    DUIComponentProps? props,
    Map<String, dynamic>? componentArgs,
    bool? isLoading,
    Map<String, Map<String, Function>>? widgetVars,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDUIComponentState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDUIComponentState.copyWith.fieldName(...)`
class _$DUIComponentStateCWProxyImpl implements _$DUIComponentStateCWProxy {
  const _$DUIComponentStateCWProxyImpl(this._value);

  final DUIComponentState _value;

  @override
  DUIComponentState componentUid(String componentUid) =>
      this(componentUid: componentUid);

  @override
  DUIComponentState props(DUIComponentProps props) => this(props: props);

  @override
  DUIComponentState componentArgs(Map<String, dynamic>? componentArgs) =>
      this(componentArgs: componentArgs);

  @override
  DUIComponentState isLoading(bool isLoading) => this(isLoading: isLoading);

  @override
  DUIComponentState widgetVars(Map<String, Map<String, Function>> widgetVars) =>
      this(widgetVars: widgetVars);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DUIComponentState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DUIComponentState(...).copyWith(id: 12, name: "My name")
  /// ````
  DUIComponentState call({
    Object? componentUid = const $CopyWithPlaceholder(),
    Object? props = const $CopyWithPlaceholder(),
    Object? componentArgs = const $CopyWithPlaceholder(),
    Object? isLoading = const $CopyWithPlaceholder(),
    Object? widgetVars = const $CopyWithPlaceholder(),
  }) {
    return DUIComponentState(
      componentUid:
          componentUid == const $CopyWithPlaceholder() || componentUid == null
              ? _value.componentUid
              // ignore: cast_nullable_to_non_nullable
              : componentUid as String,
      props: props == const $CopyWithPlaceholder() || props == null
          ? _value.props
          // ignore: cast_nullable_to_non_nullable
          : props as DUIComponentProps,
      componentArgs: componentArgs == const $CopyWithPlaceholder()
          ? _value.componentArgs
          // ignore: cast_nullable_to_non_nullable
          : componentArgs as Map<String, dynamic>?,
      isLoading: isLoading == const $CopyWithPlaceholder() || isLoading == null
          ? _value.isLoading
          // ignore: cast_nullable_to_non_nullable
          : isLoading as bool,
      widgetVars:
          widgetVars == const $CopyWithPlaceholder() || widgetVars == null
              ? _value.widgetVars
              // ignore: cast_nullable_to_non_nullable
              : widgetVars as Map<String, Map<String, Function>>,
    );
  }
}

extension $DUIComponentStateCopyWith on DUIComponentState {
  /// Returns a callable class that can be used as follows: `instanceOfDUIComponentState.copyWith(...)` or like so:`instanceOfDUIComponentState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DUIComponentStateCWProxy get copyWith =>
      _$DUIComponentStateCWProxyImpl(this);
}
