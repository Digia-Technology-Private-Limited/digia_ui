// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dui_page_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DUIPageStateCWProxy {
  DUIPageState pageUid(String pageUid);

  DUIPageState props(DUIPageProps props);

  DUIPageState pageArgs(Map<String, dynamic>? pageArgs);

  DUIPageState isLoading(bool isLoading);

  DUIPageState dataSource(Object? dataSource);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DUIPageState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DUIPageState(...).copyWith(id: 12, name: "My name")
  /// ````
  DUIPageState call({
    String? pageUid,
    DUIPageProps? props,
    Map<String, dynamic>? pageArgs,
    bool? isLoading,
    Object? dataSource,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDUIPageState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDUIPageState.copyWith.fieldName(...)`
class _$DUIPageStateCWProxyImpl implements _$DUIPageStateCWProxy {
  const _$DUIPageStateCWProxyImpl(this._value);

  final DUIPageState _value;

  @override
  DUIPageState pageUid(String pageUid) => this(pageUid: pageUid);

  @override
  DUIPageState props(DUIPageProps props) => this(props: props);

  @override
  DUIPageState pageArgs(Map<String, dynamic>? pageArgs) =>
      this(pageArgs: pageArgs);

  @override
  DUIPageState isLoading(bool isLoading) => this(isLoading: isLoading);

  @override
  DUIPageState dataSource(Object? dataSource) => this(dataSource: dataSource);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DUIPageState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DUIPageState(...).copyWith(id: 12, name: "My name")
  /// ````
  DUIPageState call({
    Object? pageUid = const $CopyWithPlaceholder(),
    Object? props = const $CopyWithPlaceholder(),
    Object? pageArgs = const $CopyWithPlaceholder(),
    Object? isLoading = const $CopyWithPlaceholder(),
    Object? dataSource = const $CopyWithPlaceholder(),
  }) {
    return DUIPageState(
      pageUid: pageUid == const $CopyWithPlaceholder() || pageUid == null
          ? _value.pageUid
          // ignore: cast_nullable_to_non_nullable
          : pageUid as String,
      props: props == const $CopyWithPlaceholder() || props == null
          ? _value.props
          // ignore: cast_nullable_to_non_nullable
          : props as DUIPageProps,
      pageArgs: pageArgs == const $CopyWithPlaceholder()
          ? _value.pageArgs
          // ignore: cast_nullable_to_non_nullable
          : pageArgs as Map<String, dynamic>?,
      isLoading: isLoading == const $CopyWithPlaceholder() || isLoading == null
          ? _value.isLoading
          // ignore: cast_nullable_to_non_nullable
          : isLoading as bool,
      dataSource: dataSource == const $CopyWithPlaceholder()
          ? _value.dataSource
          // ignore: cast_nullable_to_non_nullable
          : dataSource,
    );
  }
}

extension $DUIPageStateCopyWith on DUIPageState {
  /// Returns a callable class that can be used as follows: `instanceOfDUIPageState.copyWith(...)` or like so:`instanceOfDUIPageState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DUIPageStateCWProxy get copyWith => _$DUIPageStateCWProxyImpl(this);
}
