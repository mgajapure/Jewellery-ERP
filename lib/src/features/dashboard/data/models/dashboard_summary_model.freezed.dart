// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_summary_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DashboardSummaryModel {

 int get activeGirvi; int get dueToday; int get overdue; double get collectionsToday; double get loanExposure; double get goldRate;
/// Create a copy of DashboardSummaryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardSummaryModelCopyWith<DashboardSummaryModel> get copyWith => _$DashboardSummaryModelCopyWithImpl<DashboardSummaryModel>(this as DashboardSummaryModel, _$identity);

  /// Serializes this DashboardSummaryModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardSummaryModel&&(identical(other.activeGirvi, activeGirvi) || other.activeGirvi == activeGirvi)&&(identical(other.dueToday, dueToday) || other.dueToday == dueToday)&&(identical(other.overdue, overdue) || other.overdue == overdue)&&(identical(other.collectionsToday, collectionsToday) || other.collectionsToday == collectionsToday)&&(identical(other.loanExposure, loanExposure) || other.loanExposure == loanExposure)&&(identical(other.goldRate, goldRate) || other.goldRate == goldRate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,activeGirvi,dueToday,overdue,collectionsToday,loanExposure,goldRate);

@override
String toString() {
  return 'DashboardSummaryModel(activeGirvi: $activeGirvi, dueToday: $dueToday, overdue: $overdue, collectionsToday: $collectionsToday, loanExposure: $loanExposure, goldRate: $goldRate)';
}


}

/// @nodoc
abstract mixin class $DashboardSummaryModelCopyWith<$Res>  {
  factory $DashboardSummaryModelCopyWith(DashboardSummaryModel value, $Res Function(DashboardSummaryModel) _then) = _$DashboardSummaryModelCopyWithImpl;
@useResult
$Res call({
 int activeGirvi, int dueToday, int overdue, double collectionsToday, double loanExposure, double goldRate
});




}
/// @nodoc
class _$DashboardSummaryModelCopyWithImpl<$Res>
    implements $DashboardSummaryModelCopyWith<$Res> {
  _$DashboardSummaryModelCopyWithImpl(this._self, this._then);

  final DashboardSummaryModel _self;
  final $Res Function(DashboardSummaryModel) _then;

/// Create a copy of DashboardSummaryModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? activeGirvi = null,Object? dueToday = null,Object? overdue = null,Object? collectionsToday = null,Object? loanExposure = null,Object? goldRate = null,}) {
  return _then(_self.copyWith(
activeGirvi: null == activeGirvi ? _self.activeGirvi : activeGirvi // ignore: cast_nullable_to_non_nullable
as int,dueToday: null == dueToday ? _self.dueToday : dueToday // ignore: cast_nullable_to_non_nullable
as int,overdue: null == overdue ? _self.overdue : overdue // ignore: cast_nullable_to_non_nullable
as int,collectionsToday: null == collectionsToday ? _self.collectionsToday : collectionsToday // ignore: cast_nullable_to_non_nullable
as double,loanExposure: null == loanExposure ? _self.loanExposure : loanExposure // ignore: cast_nullable_to_non_nullable
as double,goldRate: null == goldRate ? _self.goldRate : goldRate // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardSummaryModel].
extension DashboardSummaryModelPatterns on DashboardSummaryModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardSummaryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardSummaryModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardSummaryModel value)  $default,){
final _that = this;
switch (_that) {
case _DashboardSummaryModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardSummaryModel value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardSummaryModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int activeGirvi,  int dueToday,  int overdue,  double collectionsToday,  double loanExposure,  double goldRate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardSummaryModel() when $default != null:
return $default(_that.activeGirvi,_that.dueToday,_that.overdue,_that.collectionsToday,_that.loanExposure,_that.goldRate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int activeGirvi,  int dueToday,  int overdue,  double collectionsToday,  double loanExposure,  double goldRate)  $default,) {final _that = this;
switch (_that) {
case _DashboardSummaryModel():
return $default(_that.activeGirvi,_that.dueToday,_that.overdue,_that.collectionsToday,_that.loanExposure,_that.goldRate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int activeGirvi,  int dueToday,  int overdue,  double collectionsToday,  double loanExposure,  double goldRate)?  $default,) {final _that = this;
switch (_that) {
case _DashboardSummaryModel() when $default != null:
return $default(_that.activeGirvi,_that.dueToday,_that.overdue,_that.collectionsToday,_that.loanExposure,_that.goldRate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DashboardSummaryModel implements DashboardSummaryModel {
  const _DashboardSummaryModel({this.activeGirvi = 0, this.dueToday = 0, this.overdue = 0, this.collectionsToday = 0.0, this.loanExposure = 0.0, this.goldRate = 0.0});
  factory _DashboardSummaryModel.fromJson(Map<String, dynamic> json) => _$DashboardSummaryModelFromJson(json);

@override@JsonKey() final  int activeGirvi;
@override@JsonKey() final  int dueToday;
@override@JsonKey() final  int overdue;
@override@JsonKey() final  double collectionsToday;
@override@JsonKey() final  double loanExposure;
@override@JsonKey() final  double goldRate;

/// Create a copy of DashboardSummaryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardSummaryModelCopyWith<_DashboardSummaryModel> get copyWith => __$DashboardSummaryModelCopyWithImpl<_DashboardSummaryModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardSummaryModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardSummaryModel&&(identical(other.activeGirvi, activeGirvi) || other.activeGirvi == activeGirvi)&&(identical(other.dueToday, dueToday) || other.dueToday == dueToday)&&(identical(other.overdue, overdue) || other.overdue == overdue)&&(identical(other.collectionsToday, collectionsToday) || other.collectionsToday == collectionsToday)&&(identical(other.loanExposure, loanExposure) || other.loanExposure == loanExposure)&&(identical(other.goldRate, goldRate) || other.goldRate == goldRate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,activeGirvi,dueToday,overdue,collectionsToday,loanExposure,goldRate);

@override
String toString() {
  return 'DashboardSummaryModel(activeGirvi: $activeGirvi, dueToday: $dueToday, overdue: $overdue, collectionsToday: $collectionsToday, loanExposure: $loanExposure, goldRate: $goldRate)';
}


}

/// @nodoc
abstract mixin class _$DashboardSummaryModelCopyWith<$Res> implements $DashboardSummaryModelCopyWith<$Res> {
  factory _$DashboardSummaryModelCopyWith(_DashboardSummaryModel value, $Res Function(_DashboardSummaryModel) _then) = __$DashboardSummaryModelCopyWithImpl;
@override @useResult
$Res call({
 int activeGirvi, int dueToday, int overdue, double collectionsToday, double loanExposure, double goldRate
});




}
/// @nodoc
class __$DashboardSummaryModelCopyWithImpl<$Res>
    implements _$DashboardSummaryModelCopyWith<$Res> {
  __$DashboardSummaryModelCopyWithImpl(this._self, this._then);

  final _DashboardSummaryModel _self;
  final $Res Function(_DashboardSummaryModel) _then;

/// Create a copy of DashboardSummaryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? activeGirvi = null,Object? dueToday = null,Object? overdue = null,Object? collectionsToday = null,Object? loanExposure = null,Object? goldRate = null,}) {
  return _then(_DashboardSummaryModel(
activeGirvi: null == activeGirvi ? _self.activeGirvi : activeGirvi // ignore: cast_nullable_to_non_nullable
as int,dueToday: null == dueToday ? _self.dueToday : dueToday // ignore: cast_nullable_to_non_nullable
as int,overdue: null == overdue ? _self.overdue : overdue // ignore: cast_nullable_to_non_nullable
as int,collectionsToday: null == collectionsToday ? _self.collectionsToday : collectionsToday // ignore: cast_nullable_to_non_nullable
as double,loanExposure: null == loanExposure ? _self.loanExposure : loanExposure // ignore: cast_nullable_to_non_nullable
as double,goldRate: null == goldRate ? _self.goldRate : goldRate // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
