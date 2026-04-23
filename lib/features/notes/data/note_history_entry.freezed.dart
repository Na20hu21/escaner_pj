// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'note_history_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NoteHistoryEntry {

 String get id; DateTime get timestamp; String get userId; String get userName; NoteEvent get event; NoteStatus? get fromStatus; NoteStatus? get toStatus; String? get reason; String? get observations;// Auditoría de edición (solo supervisores pueden editar entradas)
 DateTime? get editedAt; String? get editedByName;
/// Create a copy of NoteHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NoteHistoryEntryCopyWith<NoteHistoryEntry> get copyWith => _$NoteHistoryEntryCopyWithImpl<NoteHistoryEntry>(this as NoteHistoryEntry, _$identity);

  /// Serializes this NoteHistoryEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NoteHistoryEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.event, event) || other.event == event)&&(identical(other.fromStatus, fromStatus) || other.fromStatus == fromStatus)&&(identical(other.toStatus, toStatus) || other.toStatus == toStatus)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.observations, observations) || other.observations == observations)&&(identical(other.editedAt, editedAt) || other.editedAt == editedAt)&&(identical(other.editedByName, editedByName) || other.editedByName == editedByName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,timestamp,userId,userName,event,fromStatus,toStatus,reason,observations,editedAt,editedByName);

@override
String toString() {
  return 'NoteHistoryEntry(id: $id, timestamp: $timestamp, userId: $userId, userName: $userName, event: $event, fromStatus: $fromStatus, toStatus: $toStatus, reason: $reason, observations: $observations, editedAt: $editedAt, editedByName: $editedByName)';
}


}

/// @nodoc
abstract mixin class $NoteHistoryEntryCopyWith<$Res>  {
  factory $NoteHistoryEntryCopyWith(NoteHistoryEntry value, $Res Function(NoteHistoryEntry) _then) = _$NoteHistoryEntryCopyWithImpl;
@useResult
$Res call({
 String id, DateTime timestamp, String userId, String userName, NoteEvent event, NoteStatus? fromStatus, NoteStatus? toStatus, String? reason, String? observations, DateTime? editedAt, String? editedByName
});




}
/// @nodoc
class _$NoteHistoryEntryCopyWithImpl<$Res>
    implements $NoteHistoryEntryCopyWith<$Res> {
  _$NoteHistoryEntryCopyWithImpl(this._self, this._then);

  final NoteHistoryEntry _self;
  final $Res Function(NoteHistoryEntry) _then;

/// Create a copy of NoteHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? timestamp = null,Object? userId = null,Object? userName = null,Object? event = null,Object? fromStatus = freezed,Object? toStatus = freezed,Object? reason = freezed,Object? observations = freezed,Object? editedAt = freezed,Object? editedByName = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,event: null == event ? _self.event : event // ignore: cast_nullable_to_non_nullable
as NoteEvent,fromStatus: freezed == fromStatus ? _self.fromStatus : fromStatus // ignore: cast_nullable_to_non_nullable
as NoteStatus?,toStatus: freezed == toStatus ? _self.toStatus : toStatus // ignore: cast_nullable_to_non_nullable
as NoteStatus?,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,observations: freezed == observations ? _self.observations : observations // ignore: cast_nullable_to_non_nullable
as String?,editedAt: freezed == editedAt ? _self.editedAt : editedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,editedByName: freezed == editedByName ? _self.editedByName : editedByName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [NoteHistoryEntry].
extension NoteHistoryEntryPatterns on NoteHistoryEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NoteHistoryEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NoteHistoryEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NoteHistoryEntry value)  $default,){
final _that = this;
switch (_that) {
case _NoteHistoryEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NoteHistoryEntry value)?  $default,){
final _that = this;
switch (_that) {
case _NoteHistoryEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DateTime timestamp,  String userId,  String userName,  NoteEvent event,  NoteStatus? fromStatus,  NoteStatus? toStatus,  String? reason,  String? observations,  DateTime? editedAt,  String? editedByName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NoteHistoryEntry() when $default != null:
return $default(_that.id,_that.timestamp,_that.userId,_that.userName,_that.event,_that.fromStatus,_that.toStatus,_that.reason,_that.observations,_that.editedAt,_that.editedByName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DateTime timestamp,  String userId,  String userName,  NoteEvent event,  NoteStatus? fromStatus,  NoteStatus? toStatus,  String? reason,  String? observations,  DateTime? editedAt,  String? editedByName)  $default,) {final _that = this;
switch (_that) {
case _NoteHistoryEntry():
return $default(_that.id,_that.timestamp,_that.userId,_that.userName,_that.event,_that.fromStatus,_that.toStatus,_that.reason,_that.observations,_that.editedAt,_that.editedByName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DateTime timestamp,  String userId,  String userName,  NoteEvent event,  NoteStatus? fromStatus,  NoteStatus? toStatus,  String? reason,  String? observations,  DateTime? editedAt,  String? editedByName)?  $default,) {final _that = this;
switch (_that) {
case _NoteHistoryEntry() when $default != null:
return $default(_that.id,_that.timestamp,_that.userId,_that.userName,_that.event,_that.fromStatus,_that.toStatus,_that.reason,_that.observations,_that.editedAt,_that.editedByName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NoteHistoryEntry implements NoteHistoryEntry {
  const _NoteHistoryEntry({required this.id, required this.timestamp, required this.userId, required this.userName, required this.event, this.fromStatus, this.toStatus, this.reason, this.observations, this.editedAt, this.editedByName});
  factory _NoteHistoryEntry.fromJson(Map<String, dynamic> json) => _$NoteHistoryEntryFromJson(json);

@override final  String id;
@override final  DateTime timestamp;
@override final  String userId;
@override final  String userName;
@override final  NoteEvent event;
@override final  NoteStatus? fromStatus;
@override final  NoteStatus? toStatus;
@override final  String? reason;
@override final  String? observations;
// Auditoría de edición (solo supervisores pueden editar entradas)
@override final  DateTime? editedAt;
@override final  String? editedByName;

/// Create a copy of NoteHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NoteHistoryEntryCopyWith<_NoteHistoryEntry> get copyWith => __$NoteHistoryEntryCopyWithImpl<_NoteHistoryEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NoteHistoryEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NoteHistoryEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.event, event) || other.event == event)&&(identical(other.fromStatus, fromStatus) || other.fromStatus == fromStatus)&&(identical(other.toStatus, toStatus) || other.toStatus == toStatus)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.observations, observations) || other.observations == observations)&&(identical(other.editedAt, editedAt) || other.editedAt == editedAt)&&(identical(other.editedByName, editedByName) || other.editedByName == editedByName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,timestamp,userId,userName,event,fromStatus,toStatus,reason,observations,editedAt,editedByName);

@override
String toString() {
  return 'NoteHistoryEntry(id: $id, timestamp: $timestamp, userId: $userId, userName: $userName, event: $event, fromStatus: $fromStatus, toStatus: $toStatus, reason: $reason, observations: $observations, editedAt: $editedAt, editedByName: $editedByName)';
}


}

/// @nodoc
abstract mixin class _$NoteHistoryEntryCopyWith<$Res> implements $NoteHistoryEntryCopyWith<$Res> {
  factory _$NoteHistoryEntryCopyWith(_NoteHistoryEntry value, $Res Function(_NoteHistoryEntry) _then) = __$NoteHistoryEntryCopyWithImpl;
@override @useResult
$Res call({
 String id, DateTime timestamp, String userId, String userName, NoteEvent event, NoteStatus? fromStatus, NoteStatus? toStatus, String? reason, String? observations, DateTime? editedAt, String? editedByName
});




}
/// @nodoc
class __$NoteHistoryEntryCopyWithImpl<$Res>
    implements _$NoteHistoryEntryCopyWith<$Res> {
  __$NoteHistoryEntryCopyWithImpl(this._self, this._then);

  final _NoteHistoryEntry _self;
  final $Res Function(_NoteHistoryEntry) _then;

/// Create a copy of NoteHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? timestamp = null,Object? userId = null,Object? userName = null,Object? event = null,Object? fromStatus = freezed,Object? toStatus = freezed,Object? reason = freezed,Object? observations = freezed,Object? editedAt = freezed,Object? editedByName = freezed,}) {
  return _then(_NoteHistoryEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,event: null == event ? _self.event : event // ignore: cast_nullable_to_non_nullable
as NoteEvent,fromStatus: freezed == fromStatus ? _self.fromStatus : fromStatus // ignore: cast_nullable_to_non_nullable
as NoteStatus?,toStatus: freezed == toStatus ? _self.toStatus : toStatus // ignore: cast_nullable_to_non_nullable
as NoteStatus?,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,observations: freezed == observations ? _self.observations : observations // ignore: cast_nullable_to_non_nullable
as String?,editedAt: freezed == editedAt ? _self.editedAt : editedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,editedByName: freezed == editedByName ? _self.editedByName : editedByName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
