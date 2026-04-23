// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'note.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Note {

 String get id; String get recipientId; String get pdfPath; String get thumbnailPath; int get pageCount; NoteStatus get status; DateTime get createdAt; String get observations; String get codigoBarras; List<NoteHistoryEntry> get history; List<String> get imagePaths; bool get isOfflineDraft; DeliveryReceipt? get deliveryReceipt; DateTime? get updatedAt;
/// Create a copy of Note
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NoteCopyWith<Note> get copyWith => _$NoteCopyWithImpl<Note>(this as Note, _$identity);

  /// Serializes this Note to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Note&&(identical(other.id, id) || other.id == id)&&(identical(other.recipientId, recipientId) || other.recipientId == recipientId)&&(identical(other.pdfPath, pdfPath) || other.pdfPath == pdfPath)&&(identical(other.thumbnailPath, thumbnailPath) || other.thumbnailPath == thumbnailPath)&&(identical(other.pageCount, pageCount) || other.pageCount == pageCount)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.observations, observations) || other.observations == observations)&&(identical(other.codigoBarras, codigoBarras) || other.codigoBarras == codigoBarras)&&const DeepCollectionEquality().equals(other.history, history)&&const DeepCollectionEquality().equals(other.imagePaths, imagePaths)&&(identical(other.isOfflineDraft, isOfflineDraft) || other.isOfflineDraft == isOfflineDraft)&&(identical(other.deliveryReceipt, deliveryReceipt) || other.deliveryReceipt == deliveryReceipt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,recipientId,pdfPath,thumbnailPath,pageCount,status,createdAt,observations,codigoBarras,const DeepCollectionEquality().hash(history),const DeepCollectionEquality().hash(imagePaths),isOfflineDraft,deliveryReceipt,updatedAt);

@override
String toString() {
  return 'Note(id: $id, recipientId: $recipientId, pdfPath: $pdfPath, thumbnailPath: $thumbnailPath, pageCount: $pageCount, status: $status, createdAt: $createdAt, observations: $observations, codigoBarras: $codigoBarras, history: $history, imagePaths: $imagePaths, isOfflineDraft: $isOfflineDraft, deliveryReceipt: $deliveryReceipt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $NoteCopyWith<$Res>  {
  factory $NoteCopyWith(Note value, $Res Function(Note) _then) = _$NoteCopyWithImpl;
@useResult
$Res call({
 String id, String recipientId, String pdfPath, String thumbnailPath, int pageCount, NoteStatus status, DateTime createdAt, String observations, String codigoBarras, List<NoteHistoryEntry> history, List<String> imagePaths, bool isOfflineDraft, DeliveryReceipt? deliveryReceipt, DateTime? updatedAt
});


$DeliveryReceiptCopyWith<$Res>? get deliveryReceipt;

}
/// @nodoc
class _$NoteCopyWithImpl<$Res>
    implements $NoteCopyWith<$Res> {
  _$NoteCopyWithImpl(this._self, this._then);

  final Note _self;
  final $Res Function(Note) _then;

/// Create a copy of Note
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? recipientId = null,Object? pdfPath = null,Object? thumbnailPath = null,Object? pageCount = null,Object? status = null,Object? createdAt = null,Object? observations = null,Object? codigoBarras = null,Object? history = null,Object? imagePaths = null,Object? isOfflineDraft = null,Object? deliveryReceipt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,recipientId: null == recipientId ? _self.recipientId : recipientId // ignore: cast_nullable_to_non_nullable
as String,pdfPath: null == pdfPath ? _self.pdfPath : pdfPath // ignore: cast_nullable_to_non_nullable
as String,thumbnailPath: null == thumbnailPath ? _self.thumbnailPath : thumbnailPath // ignore: cast_nullable_to_non_nullable
as String,pageCount: null == pageCount ? _self.pageCount : pageCount // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as NoteStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,observations: null == observations ? _self.observations : observations // ignore: cast_nullable_to_non_nullable
as String,codigoBarras: null == codigoBarras ? _self.codigoBarras : codigoBarras // ignore: cast_nullable_to_non_nullable
as String,history: null == history ? _self.history : history // ignore: cast_nullable_to_non_nullable
as List<NoteHistoryEntry>,imagePaths: null == imagePaths ? _self.imagePaths : imagePaths // ignore: cast_nullable_to_non_nullable
as List<String>,isOfflineDraft: null == isOfflineDraft ? _self.isOfflineDraft : isOfflineDraft // ignore: cast_nullable_to_non_nullable
as bool,deliveryReceipt: freezed == deliveryReceipt ? _self.deliveryReceipt : deliveryReceipt // ignore: cast_nullable_to_non_nullable
as DeliveryReceipt?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of Note
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeliveryReceiptCopyWith<$Res>? get deliveryReceipt {
    if (_self.deliveryReceipt == null) {
    return null;
  }

  return $DeliveryReceiptCopyWith<$Res>(_self.deliveryReceipt!, (value) {
    return _then(_self.copyWith(deliveryReceipt: value));
  });
}
}


/// Adds pattern-matching-related methods to [Note].
extension NotePatterns on Note {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Note value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Note() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Note value)  $default,){
final _that = this;
switch (_that) {
case _Note():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Note value)?  $default,){
final _that = this;
switch (_that) {
case _Note() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String recipientId,  String pdfPath,  String thumbnailPath,  int pageCount,  NoteStatus status,  DateTime createdAt,  String observations,  String codigoBarras,  List<NoteHistoryEntry> history,  List<String> imagePaths,  bool isOfflineDraft,  DeliveryReceipt? deliveryReceipt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Note() when $default != null:
return $default(_that.id,_that.recipientId,_that.pdfPath,_that.thumbnailPath,_that.pageCount,_that.status,_that.createdAt,_that.observations,_that.codigoBarras,_that.history,_that.imagePaths,_that.isOfflineDraft,_that.deliveryReceipt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String recipientId,  String pdfPath,  String thumbnailPath,  int pageCount,  NoteStatus status,  DateTime createdAt,  String observations,  String codigoBarras,  List<NoteHistoryEntry> history,  List<String> imagePaths,  bool isOfflineDraft,  DeliveryReceipt? deliveryReceipt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Note():
return $default(_that.id,_that.recipientId,_that.pdfPath,_that.thumbnailPath,_that.pageCount,_that.status,_that.createdAt,_that.observations,_that.codigoBarras,_that.history,_that.imagePaths,_that.isOfflineDraft,_that.deliveryReceipt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String recipientId,  String pdfPath,  String thumbnailPath,  int pageCount,  NoteStatus status,  DateTime createdAt,  String observations,  String codigoBarras,  List<NoteHistoryEntry> history,  List<String> imagePaths,  bool isOfflineDraft,  DeliveryReceipt? deliveryReceipt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Note() when $default != null:
return $default(_that.id,_that.recipientId,_that.pdfPath,_that.thumbnailPath,_that.pageCount,_that.status,_that.createdAt,_that.observations,_that.codigoBarras,_that.history,_that.imagePaths,_that.isOfflineDraft,_that.deliveryReceipt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Note implements Note {
  const _Note({required this.id, this.recipientId = '', required this.pdfPath, required this.thumbnailPath, required this.pageCount, required this.status, required this.createdAt, this.observations = '', this.codigoBarras = '', final  List<NoteHistoryEntry> history = const [], final  List<String> imagePaths = const [], this.isOfflineDraft = false, this.deliveryReceipt, this.updatedAt}): _history = history, _imagePaths = imagePaths;
  factory _Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);

@override final  String id;
@override final  String recipientId;
@override final  String pdfPath;
@override final  String thumbnailPath;
@override final  int pageCount;
@override final  NoteStatus status;
@override final  DateTime createdAt;
@override@JsonKey() final  String observations;
@override@JsonKey() final  String codigoBarras;
 final  List<NoteHistoryEntry> _history;
@override@JsonKey() List<NoteHistoryEntry> get history {
  if (_history is EqualUnmodifiableListView) return _history;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_history);
}

 final  List<String> _imagePaths;
@override@JsonKey() List<String> get imagePaths {
  if (_imagePaths is EqualUnmodifiableListView) return _imagePaths;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_imagePaths);
}

@override@JsonKey() final  bool isOfflineDraft;
@override final  DeliveryReceipt? deliveryReceipt;
@override final  DateTime? updatedAt;

/// Create a copy of Note
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NoteCopyWith<_Note> get copyWith => __$NoteCopyWithImpl<_Note>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NoteToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Note&&(identical(other.id, id) || other.id == id)&&(identical(other.recipientId, recipientId) || other.recipientId == recipientId)&&(identical(other.pdfPath, pdfPath) || other.pdfPath == pdfPath)&&(identical(other.thumbnailPath, thumbnailPath) || other.thumbnailPath == thumbnailPath)&&(identical(other.pageCount, pageCount) || other.pageCount == pageCount)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.observations, observations) || other.observations == observations)&&(identical(other.codigoBarras, codigoBarras) || other.codigoBarras == codigoBarras)&&const DeepCollectionEquality().equals(other._history, _history)&&const DeepCollectionEquality().equals(other._imagePaths, _imagePaths)&&(identical(other.isOfflineDraft, isOfflineDraft) || other.isOfflineDraft == isOfflineDraft)&&(identical(other.deliveryReceipt, deliveryReceipt) || other.deliveryReceipt == deliveryReceipt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,recipientId,pdfPath,thumbnailPath,pageCount,status,createdAt,observations,codigoBarras,const DeepCollectionEquality().hash(_history),const DeepCollectionEquality().hash(_imagePaths),isOfflineDraft,deliveryReceipt,updatedAt);

@override
String toString() {
  return 'Note(id: $id, recipientId: $recipientId, pdfPath: $pdfPath, thumbnailPath: $thumbnailPath, pageCount: $pageCount, status: $status, createdAt: $createdAt, observations: $observations, codigoBarras: $codigoBarras, history: $history, imagePaths: $imagePaths, deliveryReceipt: $deliveryReceipt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$NoteCopyWith<$Res> implements $NoteCopyWith<$Res> {
  factory _$NoteCopyWith(_Note value, $Res Function(_Note) _then) = __$NoteCopyWithImpl;
@override @useResult
$Res call({
 String id, String recipientId, String pdfPath, String thumbnailPath, int pageCount, NoteStatus status, DateTime createdAt, String observations, String codigoBarras, List<NoteHistoryEntry> history, List<String> imagePaths, bool isOfflineDraft, DeliveryReceipt? deliveryReceipt, DateTime? updatedAt
});


@override $DeliveryReceiptCopyWith<$Res>? get deliveryReceipt;

}
/// @nodoc
class __$NoteCopyWithImpl<$Res>
    implements _$NoteCopyWith<$Res> {
  __$NoteCopyWithImpl(this._self, this._then);

  final _Note _self;
  final $Res Function(_Note) _then;

/// Create a copy of Note
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? recipientId = null,Object? pdfPath = null,Object? thumbnailPath = null,Object? pageCount = null,Object? status = null,Object? createdAt = null,Object? observations = null,Object? codigoBarras = null,Object? history = null,Object? imagePaths = null,Object? isOfflineDraft = null,Object? deliveryReceipt = freezed,Object? updatedAt = freezed,}) {
  return _then(_Note(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,recipientId: null == recipientId ? _self.recipientId : recipientId // ignore: cast_nullable_to_non_nullable
as String,pdfPath: null == pdfPath ? _self.pdfPath : pdfPath // ignore: cast_nullable_to_non_nullable
as String,thumbnailPath: null == thumbnailPath ? _self.thumbnailPath : thumbnailPath // ignore: cast_nullable_to_non_nullable
as String,pageCount: null == pageCount ? _self.pageCount : pageCount // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as NoteStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,observations: null == observations ? _self.observations : observations // ignore: cast_nullable_to_non_nullable
as String,codigoBarras: null == codigoBarras ? _self.codigoBarras : codigoBarras // ignore: cast_nullable_to_non_nullable
as String,history: null == history ? _self._history : history // ignore: cast_nullable_to_non_nullable
as List<NoteHistoryEntry>,imagePaths: null == imagePaths ? _self._imagePaths : imagePaths // ignore: cast_nullable_to_non_nullable
as List<String>,isOfflineDraft: null == isOfflineDraft ? _self.isOfflineDraft : isOfflineDraft // ignore: cast_nullable_to_non_nullable
as bool,deliveryReceipt: freezed == deliveryReceipt ? _self.deliveryReceipt : deliveryReceipt // ignore: cast_nullable_to_non_nullable
as DeliveryReceipt?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of Note
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeliveryReceiptCopyWith<$Res>? get deliveryReceipt {
    if (_self.deliveryReceipt == null) {
    return null;
  }

  return $DeliveryReceiptCopyWith<$Res>(_self.deliveryReceipt!, (value) {
    return _then(_self.copyWith(deliveryReceipt: value));
  });
}
}

// dart format on
