// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dui_page_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DUIPageStateCWProxy {
  DUIPageState uid(String uid);

  DUIPageState props(DUIPageProps? props);

  DUIPageState isLoading(bool isLoading);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DUIPageState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DUIPageState(...).copyWith(id: 12, name: "My name")
  /// ````
  DUIPageState call({
    String? uid,
    DUIPageProps? props,
    bool? isLoading,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDUIPageState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDUIPageState.copyWith.fieldName(...)`
class _$DUIPageStateCWProxyImpl implements _$DUIPageStateCWProxy {
  const _$DUIPageStateCWProxyImpl(this._value);

  final DUIPageState _value;

  @override
  DUIPageState uid(String uid) => this(uid: uid);

  @override
  DUIPageState props(DUIPageProps? props) => this(props: props);

  @override
  DUIPageState isLoading(bool isLoading) => this(isLoading: isLoading);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DUIPageState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DUIPageState(...).copyWith(id: 12, name: "My name")
  /// ````
  DUIPageState call({
    Object? uid = const $CopyWithPlaceholder(),
    Object? props = const $CopyWithPlaceholder(),
    Object? isLoading = const $CopyWithPlaceholder(),
  }) {
    return DUIPageState(
      uid: uid == const $CopyWithPlaceholder() || uid == null
          ? _value.uid
          // ignore: cast_nullable_to_non_nullable
          : uid as String,
      props: props == const $CopyWithPlaceholder()
          ? _value.props
          // ignore: cast_nullable_to_non_nullable
          : props as DUIPageProps?,
      isLoading: isLoading == const $CopyWithPlaceholder() || isLoading == null
          ? _value.isLoading
          // ignore: cast_nullable_to_non_nullable
          : isLoading as bool,
    );
  }
}

extension $DUIPageStateCopyWith on DUIPageState {
  /// Returns a callable class that can be used as follows: `instanceOfDUIPageState.copyWith(...)` or like so:`instanceOfDUIPageState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DUIPageStateCWProxy get copyWith => _$DUIPageStateCWProxyImpl(this);
}
