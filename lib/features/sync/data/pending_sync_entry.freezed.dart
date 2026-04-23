// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pending_sync_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PendingSyncEntry {

 String get id; String get noteId; double? get lat; double? get lng; DateTime get capturedAt; int get retries; DateTime? get syncedAt;
/// Create a copy of PendingSyncEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PendingSyncEntryCopyWith<PendingSyncEntry> get copyWith => _$PendingSyncEntryCopyWithImpl<PendingSyncEntry>(this as PendingSyncEntry, _$identity);

  /// Serializes this PendingSyncEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PendingSyncEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.noteId, noteId) || other.noteId == noteId)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.capturedAt, capturedAt) || other.capturedAt == capturedAt)&&(identical(other.retries, retries) || other.retries == retries)&&(identical(other.syncedAt, syncedAt) || other.syncedAt == syncedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,noteId,lat,lng,capturedAt,retries,syncedAt);

@override
String toString() {
  return 'PendingSyncEntry(id: $id, noteId: $noteId, lat: $lat, lng: $lng, capturedAt: $capturedAt, retries: $retries, syncedAt: $syncedAt)';
}


}

/// @nodoc
abstract mixin class $PendingSyncEntryCopyWith<$Res>  {
  factory $PendingSyncEntryCopyWith(PendingSyncEntry value, $Res Function(PendingSyncEntry) _then) = _$PendingSyncEntryCopyWithImpl;
@useResult
$Res call({
 String id, String noteId, double? lat, double? lng, DateTime capturedAt, int retries, DateTime? syncedAt
});




}
/// @nodoc
class _$PendingSyncEntryCopyWithImpl<$Res>
    implements $PendingSyncEntryCopyWith<$Res> {
  _$PendingSyncEntryCopyWithImpl(this._self, this._then);

  final PendingSyncEntry _self;
  final $Res Function(PendingSyncEntry) _then;

/// Create a copy of PendingSyncEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? noteId = null,Object? lat = freezed,Object? lng = freezed,Object? capturedAt = null,Object? retries = null,Object? syncedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,noteId: null == noteId ? _self.noteId : noteId // ignore: cast_nullable_to_non_nullable
as String,lat: freezed == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double?,lng: freezed == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double?,capturedAt: null == capturedAt ? _self.capturedAt : capturedAt // ignore: cast_nullable_to_non_nullable
as DateTime,retries: null == retries ? _self.retries : retries // ignore: cast_nullable_to_non_nullable
as int,syncedAt: freezed == syncedAt ? _self.syncedAt : syncedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [PendingSyncEntry].
extension PendingSyncEntryPatterns on PendingSyncEntry {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PendingSyncEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PendingSyncEntry() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PendingSyncEntry value)  $default,){
final _that = this;
switch (_that) {
case _PendingSyncEntry():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PendingSyncEntry value)?  $default,){
final _that = this;
switch (_that) {
case _PendingSyncEntry() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String noteId,  double? lat,  double? lng,  DateTime capturedAt,  int retries,  DateTime? syncedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PendingSyncEntry() when $default != null:
return $default(_that.id,_that.noteId,_that.lat,_that.lng,_that.capturedAt,_that.retries,_that.syncedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String noteId,  double? lat,  double? lng,  DateTime capturedAt,  int retries,  DateTime? syncedAt)  $default,) {final _that = this;
switch (_that) {
case _PendingSyncEntry():
return $default(_that.id,_that.noteId,_that.lat,_that.lng,_that.capturedAt,_that.retries,_that.syncedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String noteId,  double? lat,  double? lng,  DateTime capturedAt,  int retries,  DateTime? syncedAt)?  $default,) {final _that = this;
switch (_that) {
case _PendingSyncEntry() when $default != null:
return $default(_that.id,_that.noteId,_that.lat,_that.lng,_that.capturedAt,_that.retries,_that.syncedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PendingSyncEntry implements PendingSyncEntry {
  const _PendingSyncEntry({required this.id, required this.noteId, this.lat, this.lng, required this.capturedAt, this.retries = 0, this.syncedAt});
  factory _PendingSyncEntry.fromJson(Map<String, dynamic> json) => _$PendingSyncEntryFromJson(json);

@override final  String id;
@override final  String noteId;
@override final  double? lat;
@override final  double? lng;
@override final  DateTime capturedAt;
@override@JsonKey() final  int retries;
@override final  DateTime? syncedAt;

/// Create a copy of PendingSyncEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PendingSyncEntryCopyWith<_PendingSyncEntry> get copyWith => __$PendingSyncEntryCopyWithImpl<_PendingSyncEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PendingSyncEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PendingSyncEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.noteId, noteId) || other.noteId == noteId)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.capturedAt, capturedAt) || other.capturedAt == capturedAt)&&(identical(other.retries, retries) || other.retries == retries)&&(identical(other.syncedAt, syncedAt) || other.syncedAt == syncedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,noteId,lat,lng,capturedAt,retries,syncedAt);

@override
String toString() {
  return 'PendingSyncEntry(id: $id, noteId: $noteId, lat: $lat, lng: $lng, capturedAt: $capturedAt, retries: $retries, syncedAt: $syncedAt)';
}


}

/// @nodoc
abstract mixin class _$PendingSyncEntryCopyWith<$Res> implements $PendingSyncEntryCopyWith<$Res> {
  factory _$PendingSyncEntryCopyWith(_PendingSyncEntry value, $Res Function(_PendingSyncEntry) _then) = __$PendingSyncEntryCopyWithImpl;
@override @useResult
$Res call({
 String id, String noteId, double? lat, double? lng, DateTime capturedAt, int retries, DateTime? syncedAt
});




}
/// @nodoc
class __$PendingSyncEntryCopyWithImpl<$Res>
    implements _$PendingSyncEntryCopyWith<$Res> {
  __$PendingSyncEntryCopyWithImpl(this._self, this._then);

  final _PendingSyncEntry _self;
  final $Res Function(_PendingSyncEntry) _then;

/// Create a copy of PendingSyncEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? noteId = null,Object? lat = freezed,Object? lng = freezed,Object? capturedAt = null,Object? retries = null,Object? syncedAt = freezed,}) {
  return _then(_PendingSyncEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,noteId: null == noteId ? _self.noteId : noteId // ignore: cast_nullable_to_non_nullable
as String,lat: freezed == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double?,lng: freezed == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double?,capturedAt: null == capturedAt ? _self.capturedAt : capturedAt // ignore: cast_nullable_to_non_nullable
as DateTime,retries: null == retries ? _self.retries : retries // ignore: cast_nullable_to_non_nullable
as int,syncedAt: freezed == syncedAt ? _self.syncedAt : syncedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
