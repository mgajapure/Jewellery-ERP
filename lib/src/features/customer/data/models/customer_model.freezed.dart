// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CustomerModel {

 String get id; String get tenantId; String get digitalCustomerId; String get name; String? get nameEn; String get mobile; String? get alternateMobile; String? get address; String? get aadhaarMasked; String? get panNumber; DateTime? get dateOfBirth; String? get photoUrl; String? get qrCodeUrl; String get riskCategory; bool get isActive; int get activeGirvi; double get outstanding; DateTime get createdAt; DateTime get updatedAt; int get version;
/// Create a copy of CustomerModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomerModelCopyWith<CustomerModel> get copyWith => _$CustomerModelCopyWithImpl<CustomerModel>(this as CustomerModel, _$identity);

  /// Serializes this CustomerModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomerModel&&(identical(other.id, id) || other.id == id)&&(identical(other.tenantId, tenantId) || other.tenantId == tenantId)&&(identical(other.digitalCustomerId, digitalCustomerId) || other.digitalCustomerId == digitalCustomerId)&&(identical(other.name, name) || other.name == name)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&(identical(other.mobile, mobile) || other.mobile == mobile)&&(identical(other.alternateMobile, alternateMobile) || other.alternateMobile == alternateMobile)&&(identical(other.address, address) || other.address == address)&&(identical(other.aadhaarMasked, aadhaarMasked) || other.aadhaarMasked == aadhaarMasked)&&(identical(other.panNumber, panNumber) || other.panNumber == panNumber)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.qrCodeUrl, qrCodeUrl) || other.qrCodeUrl == qrCodeUrl)&&(identical(other.riskCategory, riskCategory) || other.riskCategory == riskCategory)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.activeGirvi, activeGirvi) || other.activeGirvi == activeGirvi)&&(identical(other.outstanding, outstanding) || other.outstanding == outstanding)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,tenantId,digitalCustomerId,name,nameEn,mobile,alternateMobile,address,aadhaarMasked,panNumber,dateOfBirth,photoUrl,qrCodeUrl,riskCategory,isActive,activeGirvi,outstanding,createdAt,updatedAt,version]);

@override
String toString() {
  return 'CustomerModel(id: $id, tenantId: $tenantId, digitalCustomerId: $digitalCustomerId, name: $name, nameEn: $nameEn, mobile: $mobile, alternateMobile: $alternateMobile, address: $address, aadhaarMasked: $aadhaarMasked, panNumber: $panNumber, dateOfBirth: $dateOfBirth, photoUrl: $photoUrl, qrCodeUrl: $qrCodeUrl, riskCategory: $riskCategory, isActive: $isActive, activeGirvi: $activeGirvi, outstanding: $outstanding, createdAt: $createdAt, updatedAt: $updatedAt, version: $version)';
}


}

/// @nodoc
abstract mixin class $CustomerModelCopyWith<$Res>  {
  factory $CustomerModelCopyWith(CustomerModel value, $Res Function(CustomerModel) _then) = _$CustomerModelCopyWithImpl;
@useResult
$Res call({
 String id, String tenantId, String digitalCustomerId, String name, String? nameEn, String mobile, String? alternateMobile, String? address, String? aadhaarMasked, String? panNumber, DateTime? dateOfBirth, String? photoUrl, String? qrCodeUrl, String riskCategory, bool isActive, int activeGirvi, double outstanding, DateTime createdAt, DateTime updatedAt, int version
});




}
/// @nodoc
class _$CustomerModelCopyWithImpl<$Res>
    implements $CustomerModelCopyWith<$Res> {
  _$CustomerModelCopyWithImpl(this._self, this._then);

  final CustomerModel _self;
  final $Res Function(CustomerModel) _then;

/// Create a copy of CustomerModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? tenantId = null,Object? digitalCustomerId = null,Object? name = null,Object? nameEn = freezed,Object? mobile = null,Object? alternateMobile = freezed,Object? address = freezed,Object? aadhaarMasked = freezed,Object? panNumber = freezed,Object? dateOfBirth = freezed,Object? photoUrl = freezed,Object? qrCodeUrl = freezed,Object? riskCategory = null,Object? isActive = null,Object? activeGirvi = null,Object? outstanding = null,Object? createdAt = null,Object? updatedAt = null,Object? version = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,tenantId: null == tenantId ? _self.tenantId : tenantId // ignore: cast_nullable_to_non_nullable
as String,digitalCustomerId: null == digitalCustomerId ? _self.digitalCustomerId : digitalCustomerId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nameEn: freezed == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String?,mobile: null == mobile ? _self.mobile : mobile // ignore: cast_nullable_to_non_nullable
as String,alternateMobile: freezed == alternateMobile ? _self.alternateMobile : alternateMobile // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,aadhaarMasked: freezed == aadhaarMasked ? _self.aadhaarMasked : aadhaarMasked // ignore: cast_nullable_to_non_nullable
as String?,panNumber: freezed == panNumber ? _self.panNumber : panNumber // ignore: cast_nullable_to_non_nullable
as String?,dateOfBirth: freezed == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as DateTime?,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,qrCodeUrl: freezed == qrCodeUrl ? _self.qrCodeUrl : qrCodeUrl // ignore: cast_nullable_to_non_nullable
as String?,riskCategory: null == riskCategory ? _self.riskCategory : riskCategory // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,activeGirvi: null == activeGirvi ? _self.activeGirvi : activeGirvi // ignore: cast_nullable_to_non_nullable
as int,outstanding: null == outstanding ? _self.outstanding : outstanding // ignore: cast_nullable_to_non_nullable
as double,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CustomerModel].
extension CustomerModelPatterns on CustomerModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CustomerModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CustomerModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CustomerModel value)  $default,){
final _that = this;
switch (_that) {
case _CustomerModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CustomerModel value)?  $default,){
final _that = this;
switch (_that) {
case _CustomerModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String tenantId,  String digitalCustomerId,  String name,  String? nameEn,  String mobile,  String? alternateMobile,  String? address,  String? aadhaarMasked,  String? panNumber,  DateTime? dateOfBirth,  String? photoUrl,  String? qrCodeUrl,  String riskCategory,  bool isActive,  int activeGirvi,  double outstanding,  DateTime createdAt,  DateTime updatedAt,  int version)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CustomerModel() when $default != null:
return $default(_that.id,_that.tenantId,_that.digitalCustomerId,_that.name,_that.nameEn,_that.mobile,_that.alternateMobile,_that.address,_that.aadhaarMasked,_that.panNumber,_that.dateOfBirth,_that.photoUrl,_that.qrCodeUrl,_that.riskCategory,_that.isActive,_that.activeGirvi,_that.outstanding,_that.createdAt,_that.updatedAt,_that.version);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String tenantId,  String digitalCustomerId,  String name,  String? nameEn,  String mobile,  String? alternateMobile,  String? address,  String? aadhaarMasked,  String? panNumber,  DateTime? dateOfBirth,  String? photoUrl,  String? qrCodeUrl,  String riskCategory,  bool isActive,  int activeGirvi,  double outstanding,  DateTime createdAt,  DateTime updatedAt,  int version)  $default,) {final _that = this;
switch (_that) {
case _CustomerModel():
return $default(_that.id,_that.tenantId,_that.digitalCustomerId,_that.name,_that.nameEn,_that.mobile,_that.alternateMobile,_that.address,_that.aadhaarMasked,_that.panNumber,_that.dateOfBirth,_that.photoUrl,_that.qrCodeUrl,_that.riskCategory,_that.isActive,_that.activeGirvi,_that.outstanding,_that.createdAt,_that.updatedAt,_that.version);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String tenantId,  String digitalCustomerId,  String name,  String? nameEn,  String mobile,  String? alternateMobile,  String? address,  String? aadhaarMasked,  String? panNumber,  DateTime? dateOfBirth,  String? photoUrl,  String? qrCodeUrl,  String riskCategory,  bool isActive,  int activeGirvi,  double outstanding,  DateTime createdAt,  DateTime updatedAt,  int version)?  $default,) {final _that = this;
switch (_that) {
case _CustomerModel() when $default != null:
return $default(_that.id,_that.tenantId,_that.digitalCustomerId,_that.name,_that.nameEn,_that.mobile,_that.alternateMobile,_that.address,_that.aadhaarMasked,_that.panNumber,_that.dateOfBirth,_that.photoUrl,_that.qrCodeUrl,_that.riskCategory,_that.isActive,_that.activeGirvi,_that.outstanding,_that.createdAt,_that.updatedAt,_that.version);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CustomerModel implements CustomerModel {
  const _CustomerModel({required this.id, required this.tenantId, required this.digitalCustomerId, required this.name, this.nameEn, required this.mobile, this.alternateMobile, this.address, this.aadhaarMasked, this.panNumber, this.dateOfBirth, this.photoUrl, this.qrCodeUrl, this.riskCategory = 'LOW', this.isActive = true, this.activeGirvi = 0, this.outstanding = 0.0, required this.createdAt, required this.updatedAt, this.version = 1});
  factory _CustomerModel.fromJson(Map<String, dynamic> json) => _$CustomerModelFromJson(json);

@override final  String id;
@override final  String tenantId;
@override final  String digitalCustomerId;
@override final  String name;
@override final  String? nameEn;
@override final  String mobile;
@override final  String? alternateMobile;
@override final  String? address;
@override final  String? aadhaarMasked;
@override final  String? panNumber;
@override final  DateTime? dateOfBirth;
@override final  String? photoUrl;
@override final  String? qrCodeUrl;
@override@JsonKey() final  String riskCategory;
@override@JsonKey() final  bool isActive;
@override@JsonKey() final  int activeGirvi;
@override@JsonKey() final  double outstanding;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override@JsonKey() final  int version;

/// Create a copy of CustomerModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomerModelCopyWith<_CustomerModel> get copyWith => __$CustomerModelCopyWithImpl<_CustomerModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CustomerModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CustomerModel&&(identical(other.id, id) || other.id == id)&&(identical(other.tenantId, tenantId) || other.tenantId == tenantId)&&(identical(other.digitalCustomerId, digitalCustomerId) || other.digitalCustomerId == digitalCustomerId)&&(identical(other.name, name) || other.name == name)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&(identical(other.mobile, mobile) || other.mobile == mobile)&&(identical(other.alternateMobile, alternateMobile) || other.alternateMobile == alternateMobile)&&(identical(other.address, address) || other.address == address)&&(identical(other.aadhaarMasked, aadhaarMasked) || other.aadhaarMasked == aadhaarMasked)&&(identical(other.panNumber, panNumber) || other.panNumber == panNumber)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.qrCodeUrl, qrCodeUrl) || other.qrCodeUrl == qrCodeUrl)&&(identical(other.riskCategory, riskCategory) || other.riskCategory == riskCategory)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.activeGirvi, activeGirvi) || other.activeGirvi == activeGirvi)&&(identical(other.outstanding, outstanding) || other.outstanding == outstanding)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,tenantId,digitalCustomerId,name,nameEn,mobile,alternateMobile,address,aadhaarMasked,panNumber,dateOfBirth,photoUrl,qrCodeUrl,riskCategory,isActive,activeGirvi,outstanding,createdAt,updatedAt,version]);

@override
String toString() {
  return 'CustomerModel(id: $id, tenantId: $tenantId, digitalCustomerId: $digitalCustomerId, name: $name, nameEn: $nameEn, mobile: $mobile, alternateMobile: $alternateMobile, address: $address, aadhaarMasked: $aadhaarMasked, panNumber: $panNumber, dateOfBirth: $dateOfBirth, photoUrl: $photoUrl, qrCodeUrl: $qrCodeUrl, riskCategory: $riskCategory, isActive: $isActive, activeGirvi: $activeGirvi, outstanding: $outstanding, createdAt: $createdAt, updatedAt: $updatedAt, version: $version)';
}


}

/// @nodoc
abstract mixin class _$CustomerModelCopyWith<$Res> implements $CustomerModelCopyWith<$Res> {
  factory _$CustomerModelCopyWith(_CustomerModel value, $Res Function(_CustomerModel) _then) = __$CustomerModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String tenantId, String digitalCustomerId, String name, String? nameEn, String mobile, String? alternateMobile, String? address, String? aadhaarMasked, String? panNumber, DateTime? dateOfBirth, String? photoUrl, String? qrCodeUrl, String riskCategory, bool isActive, int activeGirvi, double outstanding, DateTime createdAt, DateTime updatedAt, int version
});




}
/// @nodoc
class __$CustomerModelCopyWithImpl<$Res>
    implements _$CustomerModelCopyWith<$Res> {
  __$CustomerModelCopyWithImpl(this._self, this._then);

  final _CustomerModel _self;
  final $Res Function(_CustomerModel) _then;

/// Create a copy of CustomerModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? tenantId = null,Object? digitalCustomerId = null,Object? name = null,Object? nameEn = freezed,Object? mobile = null,Object? alternateMobile = freezed,Object? address = freezed,Object? aadhaarMasked = freezed,Object? panNumber = freezed,Object? dateOfBirth = freezed,Object? photoUrl = freezed,Object? qrCodeUrl = freezed,Object? riskCategory = null,Object? isActive = null,Object? activeGirvi = null,Object? outstanding = null,Object? createdAt = null,Object? updatedAt = null,Object? version = null,}) {
  return _then(_CustomerModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,tenantId: null == tenantId ? _self.tenantId : tenantId // ignore: cast_nullable_to_non_nullable
as String,digitalCustomerId: null == digitalCustomerId ? _self.digitalCustomerId : digitalCustomerId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nameEn: freezed == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String?,mobile: null == mobile ? _self.mobile : mobile // ignore: cast_nullable_to_non_nullable
as String,alternateMobile: freezed == alternateMobile ? _self.alternateMobile : alternateMobile // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,aadhaarMasked: freezed == aadhaarMasked ? _self.aadhaarMasked : aadhaarMasked // ignore: cast_nullable_to_non_nullable
as String?,panNumber: freezed == panNumber ? _self.panNumber : panNumber // ignore: cast_nullable_to_non_nullable
as String?,dateOfBirth: freezed == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as DateTime?,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,qrCodeUrl: freezed == qrCodeUrl ? _self.qrCodeUrl : qrCodeUrl // ignore: cast_nullable_to_non_nullable
as String?,riskCategory: null == riskCategory ? _self.riskCategory : riskCategory // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,activeGirvi: null == activeGirvi ? _self.activeGirvi : activeGirvi // ignore: cast_nullable_to_non_nullable
as int,outstanding: null == outstanding ? _self.outstanding : outstanding // ignore: cast_nullable_to_non_nullable
as double,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
