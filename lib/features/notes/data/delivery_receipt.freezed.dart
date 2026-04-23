// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'delivery_receipt.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DeliveryReceipt {

 String get signaturePngPath; String get receiverName; String get receiverDni; bool get isThirdParty; DateTime get capturedAt; double? get lat; double? get lng;
/// Create a copy of DeliveryReceipt
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeliveryReceiptCopyWith<DeliveryReceipt> get copyWith => _$DeliveryReceiptCopyWithImpl<DeliveryReceipt>(this as DeliveryReceipt, _$identity);

  /// Serializes this DeliveryReceipt to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeliveryReceipt&&(identical(other.signaturePngPath, signaturePngPath) || other.signaturePngPath == signaturePngPath)&&(identical(other.receiverName, receiverName) || other.receiverName == receiverName)&&(identical(other.receiverDni, receiverDni) || other.receiverDni == receiverDni)&&(identical(other.isThirdParty, isThirdParty) || other.isThirdParty == isThirdParty)&&(identical(other.capturedAt, capturedAt) || other.capturedAt == capturedAt)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,signaturePngPath,receiverName,receiverDni,isThirdParty,capturedAt,lat,lng);

@override
String toString() {
  return 'DeliveryReceipt(signaturePngPath: $signaturePngPath, receiverName: $receiverName, receiverDni: $receiverDni, isThirdParty: $isThirdParty, capturedAt: $capturedAt, lat: $lat, lng: $lng)';
}


}

/// @nodoc
abstract mixin class $DeliveryReceiptCopyWith<$Res>  {
  factory $DeliveryReceiptCopyWith(DeliveryReceipt value, $Res Function(DeliveryReceipt) _then) = _$DeliveryReceiptCopyWithImpl;
@useResult
$Res call({
 String signaturePngPath, String receiverName, String receiverDni, bool isThirdParty, DateTime capturedAt, double? lat, double? lng
});




}
/// @nodoc
class _$DeliveryReceiptCopyWithImpl<$Res>
    implements $DeliveryReceiptCopyWith<$Res> {
  _$DeliveryReceiptCopyWithImpl(this._self, this._then);

  final DeliveryReceipt _self;
  final $Res Function(DeliveryReceipt) _then;

/// Create a copy of DeliveryReceipt
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? signaturePngPath = null,Object? receiverName = null,Object? receiverDni = null,Object? isThirdParty = null,Object? capturedAt = null,Object? lat = freezed,Object? lng = freezed,}) {
  return _then(_self.copyWith(
signaturePngPath: null == signaturePngPath ? _self.signaturePngPath : signaturePngPath // ignore: cast_nullable_to_non_nullable
as String,receiverName: null == receiverName ? _self.receiverName : receiverName // ignore: cast_nullable_to_non_nullable
as String,receiverDni: null == receiverDni ? _self.receiverDni : receiverDni // ignore: cast_nullable_to_non_nullable
as String,isThirdParty: null == isThirdParty ? _self.isThirdParty : isThirdParty // ignore: cast_nullable_to_non_nullable
as bool,capturedAt: null == capturedAt ? _self.capturedAt : capturedAt // ignore: cast_nullable_to_non_nullable
as DateTime,lat: freezed == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double?,lng: freezed == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [DeliveryReceipt].
extension DeliveryReceiptPatterns on DeliveryReceipt {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeliveryReceipt value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeliveryReceipt() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeliveryReceipt value)  $default,){
final _that = this;
switch (_that) {
case _DeliveryReceipt():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeliveryReceipt value)?  $default,){
final _that = this;
switch (_that) {
case _DeliveryReceipt() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String signaturePngPath,  String receiverName,  String receiverDni,  bool isThirdParty,  DateTime capturedAt,  double? lat,  double? lng)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeliveryReceipt() when $default != null:
return $default(_that.signaturePngPath,_that.receiverName,_that.receiverDni,_that.isThirdParty,_that.capturedAt,_that.lat,_that.lng);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String signaturePngPath,  String receiverName,  String receiverDni,  bool isThirdParty,  DateTime capturedAt,  double? lat,  double? lng)  $default,) {final _that = this;
switch (_that) {
case _DeliveryReceipt():
return $default(_that.signaturePngPath,_that.receiverName,_that.receiverDni,_that.isThirdParty,_that.capturedAt,_that.lat,_that.lng);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String signaturePngPath,  String receiverName,  String receiverDni,  bool isThirdParty,  DateTime capturedAt,  double? lat,  double? lng)?  $default,) {final _that = this;
switch (_that) {
case _DeliveryReceipt() when $default != null:
return $default(_that.signaturePngPath,_that.receiverName,_that.receiverDni,_that.isThirdParty,_that.capturedAt,_that.lat,_that.lng);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DeliveryReceipt implements DeliveryReceipt {
  const _DeliveryReceipt({required this.signaturePngPath, required this.receiverName, required this.receiverDni, required this.isThirdParty, required this.capturedAt, this.lat, this.lng});
  factory _DeliveryReceipt.fromJson(Map<String, dynamic> json) => _$DeliveryReceiptFromJson(json);

@override final  String signaturePngPath;
@override final  String receiverName;
@override final  String receiverDni;
@override final  bool isThirdParty;
@override final  DateTime capturedAt;
@override final  double? lat;
@override final  double? lng;

/// Create a copy of DeliveryReceipt
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeliveryReceiptCopyWith<_DeliveryReceipt> get copyWith => __$DeliveryReceiptCopyWithImpl<_DeliveryReceipt>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeliveryReceiptToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeliveryReceipt&&(identical(other.signaturePngPath, signaturePngPath) || other.signaturePngPath == signaturePngPath)&&(identical(other.receiverName, receiverName) || other.receiverName == receiverName)&&(identical(other.receiverDni, receiverDni) || other.receiverDni == receiverDni)&&(identical(other.isThirdParty, isThirdParty) || other.isThirdParty == isThirdParty)&&(identical(other.capturedAt, capturedAt) || other.capturedAt == capturedAt)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,signaturePngPath,receiverName,receiverDni,isThirdParty,capturedAt,lat,lng);

@override
String toString() {
  return 'DeliveryReceipt(signaturePngPath: $signaturePngPath, receiverName: $receiverName, receiverDni: $receiverDni, isThirdParty: $isThirdParty, capturedAt: $capturedAt, lat: $lat, lng: $lng)';
}


}

/// @nodoc
abstract mixin class _$DeliveryReceiptCopyWith<$Res> implements $DeliveryReceiptCopyWith<$Res> {
  factory _$DeliveryReceiptCopyWith(_DeliveryReceipt value, $Res Function(_DeliveryReceipt) _then) = __$DeliveryReceiptCopyWithImpl;
@override @useResult
$Res call({
 String signaturePngPath, String receiverName, String receiverDni, bool isThirdParty, DateTime capturedAt, double? lat, double? lng
});




}
/// @nodoc
class __$DeliveryReceiptCopyWithImpl<$Res>
    implements _$DeliveryReceiptCopyWith<$Res> {
  __$DeliveryReceiptCopyWithImpl(this._self, this._then);

  final _DeliveryReceipt _self;
  final $Res Function(_DeliveryReceipt) _then;

/// Create a copy of DeliveryReceipt
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? signaturePngPath = null,Object? receiverName = null,Object? receiverDni = null,Object? isThirdParty = null,Object? capturedAt = null,Object? lat = freezed,Object? lng = freezed,}) {
  return _then(_DeliveryReceipt(
signaturePngPath: null == signaturePngPath ? _self.signaturePngPath : signaturePngPath // ignore: cast_nullable_to_non_nullable
as String,receiverName: null == receiverName ? _self.receiverName : receiverName // ignore: cast_nullable_to_non_nullable
as String,receiverDni: null == receiverDni ? _self.receiverDni : receiverDni // ignore: cast_nullable_to_non_nullable
as String,isThirdParty: null == isThirdParty ? _self.isThirdParty : isThirdParty // ignore: cast_nullable_to_non_nullable
as bool,capturedAt: null == capturedAt ? _self.capturedAt : capturedAt // ignore: cast_nullable_to_non_nullable
as DateTime,lat: freezed == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double?,lng: freezed == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
