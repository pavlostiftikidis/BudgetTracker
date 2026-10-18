// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Account {

 String get id; String get name; AccountType get type; int get openingBalanceCents; ColorKey get colorKey;/// Credit card: balance may go negative and is shown in coral.
 bool get isCredit; int? get creditLimitCents;/// Day of month the card statement is due ("λήξη 5 Νοε").
 int? get statementDay;/// Last four digits shown as "••4417".
 String? get last4;/// Savings target ("Στόχος €5.000 · 65%").
 int? get goalCents; bool get archived; int get sortOrder;
/// Create a copy of Account
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountCopyWith<Account> get copyWith => _$AccountCopyWithImpl<Account>(this as Account, _$identity);

  /// Serializes this Account to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Account;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Account&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.openingBalanceCents, _this.openingBalanceCents) || other.openingBalanceCents == _this.openingBalanceCents)&&(identical(other.colorKey, _this.colorKey) || other.colorKey == _this.colorKey)&&(identical(other.isCredit, _this.isCredit) || other.isCredit == _this.isCredit)&&(identical(other.creditLimitCents, _this.creditLimitCents) || other.creditLimitCents == _this.creditLimitCents)&&(identical(other.statementDay, _this.statementDay) || other.statementDay == _this.statementDay)&&(identical(other.last4, _this.last4) || other.last4 == _this.last4)&&(identical(other.goalCents, _this.goalCents) || other.goalCents == _this.goalCents)&&(identical(other.archived, _this.archived) || other.archived == _this.archived)&&(identical(other.sortOrder, _this.sortOrder) || other.sortOrder == _this.sortOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Account;
  return Object.hash(runtimeType,_this.id,_this.name,_this.type,_this.openingBalanceCents,_this.colorKey,_this.isCredit,_this.creditLimitCents,_this.statementDay,_this.last4,_this.goalCents,_this.archived,_this.sortOrder);
}

@override
String toString() {
  final _this = this as Account;
  return 'Account(id: ${_this.id}, name: ${_this.name}, type: ${_this.type}, openingBalanceCents: ${_this.openingBalanceCents}, colorKey: ${_this.colorKey}, isCredit: ${_this.isCredit}, creditLimitCents: ${_this.creditLimitCents}, statementDay: ${_this.statementDay}, last4: ${_this.last4}, goalCents: ${_this.goalCents}, archived: ${_this.archived}, sortOrder: ${_this.sortOrder})';
}


}

/// @nodoc
abstract mixin class $AccountCopyWith<$Res>  {
  factory $AccountCopyWith(Account value, $Res Function(Account) _then) = _$AccountCopyWithImpl;
@useResult
$Res call({
 String id, String name, AccountType type, int openingBalanceCents, ColorKey colorKey, bool isCredit, int? creditLimitCents, int? statementDay, String? last4, int? goalCents, bool archived, int sortOrder
});




}
/// @nodoc
class _$AccountCopyWithImpl<$Res>
    implements $AccountCopyWith<$Res> {
  _$AccountCopyWithImpl(this._self, this._then);

  final Account _self;
  final $Res Function(Account) _then;

/// Create a copy of Account
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? type = null,Object? openingBalanceCents = null,Object? colorKey = null,Object? isCredit = null,Object? creditLimitCents = freezed,Object? statementDay = freezed,Object? last4 = freezed,Object? goalCents = freezed,Object? archived = null,Object? sortOrder = null,}) {
  return _then(Account(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AccountType,openingBalanceCents: null == openingBalanceCents ? _self.openingBalanceCents : openingBalanceCents // ignore: cast_nullable_to_non_nullable
as int,colorKey: null == colorKey ? _self.colorKey : colorKey // ignore: cast_nullable_to_non_nullable
as ColorKey,isCredit: null == isCredit ? _self.isCredit : isCredit // ignore: cast_nullable_to_non_nullable
as bool,creditLimitCents: freezed == creditLimitCents ? _self.creditLimitCents : creditLimitCents // ignore: cast_nullable_to_non_nullable
as int?,statementDay: freezed == statementDay ? _self.statementDay : statementDay // ignore: cast_nullable_to_non_nullable
as int?,last4: freezed == last4 ? _self.last4 : last4 // ignore: cast_nullable_to_non_nullable
as String?,goalCents: freezed == goalCents ? _self.goalCents : goalCents // ignore: cast_nullable_to_non_nullable
as int?,archived: null == archived ? _self.archived : archived // ignore: cast_nullable_to_non_nullable
as bool,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Account].
extension AccountPatterns on Account {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Account value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Account() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Account value)  $default,){
final _that = this;
switch (_that) {
case _Account():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Account value)?  $default,){
final _that = this;
switch (_that) {
case _Account() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  AccountType type,  int openingBalanceCents,  ColorKey colorKey,  bool isCredit,  int? creditLimitCents,  int? statementDay,  String? last4,  int? goalCents,  bool archived,  int sortOrder)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Account() when $default != null:
return $default(_that.id,_that.name,_that.type,_that.openingBalanceCents,_that.colorKey,_that.isCredit,_that.creditLimitCents,_that.statementDay,_that.last4,_that.goalCents,_that.archived,_that.sortOrder);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  AccountType type,  int openingBalanceCents,  ColorKey colorKey,  bool isCredit,  int? creditLimitCents,  int? statementDay,  String? last4,  int? goalCents,  bool archived,  int sortOrder)  $default,) {final _that = this;
switch (_that) {
case _Account():
return $default(_that.id,_that.name,_that.type,_that.openingBalanceCents,_that.colorKey,_that.isCredit,_that.creditLimitCents,_that.statementDay,_that.last4,_that.goalCents,_that.archived,_that.sortOrder);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  AccountType type,  int openingBalanceCents,  ColorKey colorKey,  bool isCredit,  int? creditLimitCents,  int? statementDay,  String? last4,  int? goalCents,  bool archived,  int sortOrder)?  $default,) {final _that = this;
switch (_that) {
case _Account() when $default != null:
return $default(_that.id,_that.name,_that.type,_that.openingBalanceCents,_that.colorKey,_that.isCredit,_that.creditLimitCents,_that.statementDay,_that.last4,_that.goalCents,_that.archived,_that.sortOrder);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Account extends Account {
  const _Account({required this.id, required this.name, required this.type, this.openingBalanceCents = 0, this.colorKey = ColorKey.sky, this.isCredit = false, this.creditLimitCents, this.statementDay, this.last4, this.goalCents, this.archived = false, this.sortOrder = 0}): super._();
  factory _Account.fromJson(Map<String, dynamic> json) => _$AccountFromJson(json);

@override final  String id;
@override final  String name;
@override final  AccountType type;
@override@JsonKey() final  int openingBalanceCents;
@override@JsonKey() final  ColorKey colorKey;
/// Credit card: balance may go negative and is shown in coral.
@override@JsonKey() final  bool isCredit;
@override final  int? creditLimitCents;
/// Day of month the card statement is due ("λήξη 5 Νοε").
@override final  int? statementDay;
/// Last four digits shown as "••4417".
@override final  String? last4;
/// Savings target ("Στόχος €5.000 · 65%").
@override final  int? goalCents;
@override@JsonKey() final  bool archived;
@override@JsonKey() final  int sortOrder;

/// Create a copy of Account
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountCopyWith<_Account> get copyWith => __$AccountCopyWithImpl<_Account>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AccountToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Account&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.openingBalanceCents, openingBalanceCents) || other.openingBalanceCents == openingBalanceCents)&&(identical(other.colorKey, colorKey) || other.colorKey == colorKey)&&(identical(other.isCredit, isCredit) || other.isCredit == isCredit)&&(identical(other.creditLimitCents, creditLimitCents) || other.creditLimitCents == creditLimitCents)&&(identical(other.statementDay, statementDay) || other.statementDay == statementDay)&&(identical(other.last4, last4) || other.last4 == last4)&&(identical(other.goalCents, goalCents) || other.goalCents == goalCents)&&(identical(other.archived, archived) || other.archived == archived)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,type,openingBalanceCents,colorKey,isCredit,creditLimitCents,statementDay,last4,goalCents,archived,sortOrder);
}

@override
String toString() {
    return 'Account(id: $id, name: $name, type: $type, openingBalanceCents: $openingBalanceCents, colorKey: $colorKey, isCredit: $isCredit, creditLimitCents: $creditLimitCents, statementDay: $statementDay, last4: $last4, goalCents: $goalCents, archived: $archived, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class _$AccountCopyWith<$Res> implements $AccountCopyWith<$Res> {
  factory _$AccountCopyWith(_Account value, $Res Function(_Account) _then) = __$AccountCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, AccountType type, int openingBalanceCents, ColorKey colorKey, bool isCredit, int? creditLimitCents, int? statementDay, String? last4, int? goalCents, bool archived, int sortOrder
});




}
/// @nodoc
class __$AccountCopyWithImpl<$Res>
    implements _$AccountCopyWith<$Res> {
  __$AccountCopyWithImpl(this._self, this._then);

  final _Account _self;
  final $Res Function(_Account) _then;

/// Create a copy of Account
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? type = null,Object? openingBalanceCents = null,Object? colorKey = null,Object? isCredit = null,Object? creditLimitCents = freezed,Object? statementDay = freezed,Object? last4 = freezed,Object? goalCents = freezed,Object? archived = null,Object? sortOrder = null,}) {
  return _then(_Account(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AccountType,openingBalanceCents: null == openingBalanceCents ? _self.openingBalanceCents : openingBalanceCents // ignore: cast_nullable_to_non_nullable
as int,colorKey: null == colorKey ? _self.colorKey : colorKey // ignore: cast_nullable_to_non_nullable
as ColorKey,isCredit: null == isCredit ? _self.isCredit : isCredit // ignore: cast_nullable_to_non_nullable
as bool,creditLimitCents: freezed == creditLimitCents ? _self.creditLimitCents : creditLimitCents // ignore: cast_nullable_to_non_nullable
as int?,statementDay: freezed == statementDay ? _self.statementDay : statementDay // ignore: cast_nullable_to_non_nullable
as int?,last4: freezed == last4 ? _self.last4 : last4 // ignore: cast_nullable_to_non_nullable
as String?,goalCents: freezed == goalCents ? _self.goalCents : goalCents // ignore: cast_nullable_to_non_nullable
as int?,archived: null == archived ? _self.archived : archived // ignore: cast_nullable_to_non_nullable
as bool,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$TxnCategory {

 String get id; String get name; CategoryKind get kind; ColorKey get colorKey; IconKey get iconKey; int? get monthlyLimitCents; int get sortOrder; bool get archived;
/// Create a copy of TxnCategory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TxnCategoryCopyWith<TxnCategory> get copyWith => _$TxnCategoryCopyWithImpl<TxnCategory>(this as TxnCategory, _$identity);

  /// Serializes this TxnCategory to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TxnCategory;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TxnCategory&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.colorKey, _this.colorKey) || other.colorKey == _this.colorKey)&&(identical(other.iconKey, _this.iconKey) || other.iconKey == _this.iconKey)&&(identical(other.monthlyLimitCents, _this.monthlyLimitCents) || other.monthlyLimitCents == _this.monthlyLimitCents)&&(identical(other.sortOrder, _this.sortOrder) || other.sortOrder == _this.sortOrder)&&(identical(other.archived, _this.archived) || other.archived == _this.archived));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TxnCategory;
  return Object.hash(runtimeType,_this.id,_this.name,_this.kind,_this.colorKey,_this.iconKey,_this.monthlyLimitCents,_this.sortOrder,_this.archived);
}

@override
String toString() {
  final _this = this as TxnCategory;
  return 'TxnCategory(id: ${_this.id}, name: ${_this.name}, kind: ${_this.kind}, colorKey: ${_this.colorKey}, iconKey: ${_this.iconKey}, monthlyLimitCents: ${_this.monthlyLimitCents}, sortOrder: ${_this.sortOrder}, archived: ${_this.archived})';
}


}

/// @nodoc
abstract mixin class $TxnCategoryCopyWith<$Res>  {
  factory $TxnCategoryCopyWith(TxnCategory value, $Res Function(TxnCategory) _then) = _$TxnCategoryCopyWithImpl;
@useResult
$Res call({
 String id, String name, CategoryKind kind, ColorKey colorKey, IconKey iconKey, int? monthlyLimitCents, int sortOrder, bool archived
});




}
/// @nodoc
class _$TxnCategoryCopyWithImpl<$Res>
    implements $TxnCategoryCopyWith<$Res> {
  _$TxnCategoryCopyWithImpl(this._self, this._then);

  final TxnCategory _self;
  final $Res Function(TxnCategory) _then;

/// Create a copy of TxnCategory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? kind = null,Object? colorKey = null,Object? iconKey = null,Object? monthlyLimitCents = freezed,Object? sortOrder = null,Object? archived = null,}) {
  return _then(TxnCategory(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as CategoryKind,colorKey: null == colorKey ? _self.colorKey : colorKey // ignore: cast_nullable_to_non_nullable
as ColorKey,iconKey: null == iconKey ? _self.iconKey : iconKey // ignore: cast_nullable_to_non_nullable
as IconKey,monthlyLimitCents: freezed == monthlyLimitCents ? _self.monthlyLimitCents : monthlyLimitCents // ignore: cast_nullable_to_non_nullable
as int?,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,archived: null == archived ? _self.archived : archived // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [TxnCategory].
extension TxnCategoryPatterns on TxnCategory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TxnCategory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TxnCategory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TxnCategory value)  $default,){
final _that = this;
switch (_that) {
case _TxnCategory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TxnCategory value)?  $default,){
final _that = this;
switch (_that) {
case _TxnCategory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  CategoryKind kind,  ColorKey colorKey,  IconKey iconKey,  int? monthlyLimitCents,  int sortOrder,  bool archived)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TxnCategory() when $default != null:
return $default(_that.id,_that.name,_that.kind,_that.colorKey,_that.iconKey,_that.monthlyLimitCents,_that.sortOrder,_that.archived);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  CategoryKind kind,  ColorKey colorKey,  IconKey iconKey,  int? monthlyLimitCents,  int sortOrder,  bool archived)  $default,) {final _that = this;
switch (_that) {
case _TxnCategory():
return $default(_that.id,_that.name,_that.kind,_that.colorKey,_that.iconKey,_that.monthlyLimitCents,_that.sortOrder,_that.archived);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  CategoryKind kind,  ColorKey colorKey,  IconKey iconKey,  int? monthlyLimitCents,  int sortOrder,  bool archived)?  $default,) {final _that = this;
switch (_that) {
case _TxnCategory() when $default != null:
return $default(_that.id,_that.name,_that.kind,_that.colorKey,_that.iconKey,_that.monthlyLimitCents,_that.sortOrder,_that.archived);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TxnCategory extends TxnCategory {
  const _TxnCategory({required this.id, required this.name, required this.kind, required this.colorKey, required this.iconKey, this.monthlyLimitCents, this.sortOrder = 0, this.archived = false}): super._();
  factory _TxnCategory.fromJson(Map<String, dynamic> json) => _$TxnCategoryFromJson(json);

@override final  String id;
@override final  String name;
@override final  CategoryKind kind;
@override final  ColorKey colorKey;
@override final  IconKey iconKey;
@override final  int? monthlyLimitCents;
@override@JsonKey() final  int sortOrder;
@override@JsonKey() final  bool archived;

/// Create a copy of TxnCategory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TxnCategoryCopyWith<_TxnCategory> get copyWith => __$TxnCategoryCopyWithImpl<_TxnCategory>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TxnCategoryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TxnCategory&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.colorKey, colorKey) || other.colorKey == colorKey)&&(identical(other.iconKey, iconKey) || other.iconKey == iconKey)&&(identical(other.monthlyLimitCents, monthlyLimitCents) || other.monthlyLimitCents == monthlyLimitCents)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.archived, archived) || other.archived == archived));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,kind,colorKey,iconKey,monthlyLimitCents,sortOrder,archived);
}

@override
String toString() {
    return 'TxnCategory(id: $id, name: $name, kind: $kind, colorKey: $colorKey, iconKey: $iconKey, monthlyLimitCents: $monthlyLimitCents, sortOrder: $sortOrder, archived: $archived)';
}


}

/// @nodoc
abstract mixin class _$TxnCategoryCopyWith<$Res> implements $TxnCategoryCopyWith<$Res> {
  factory _$TxnCategoryCopyWith(_TxnCategory value, $Res Function(_TxnCategory) _then) = __$TxnCategoryCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, CategoryKind kind, ColorKey colorKey, IconKey iconKey, int? monthlyLimitCents, int sortOrder, bool archived
});




}
/// @nodoc
class __$TxnCategoryCopyWithImpl<$Res>
    implements _$TxnCategoryCopyWith<$Res> {
  __$TxnCategoryCopyWithImpl(this._self, this._then);

  final _TxnCategory _self;
  final $Res Function(_TxnCategory) _then;

/// Create a copy of TxnCategory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? kind = null,Object? colorKey = null,Object? iconKey = null,Object? monthlyLimitCents = freezed,Object? sortOrder = null,Object? archived = null,}) {
  return _then(_TxnCategory(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as CategoryKind,colorKey: null == colorKey ? _self.colorKey : colorKey // ignore: cast_nullable_to_non_nullable
as ColorKey,iconKey: null == iconKey ? _self.iconKey : iconKey // ignore: cast_nullable_to_non_nullable
as IconKey,monthlyLimitCents: freezed == monthlyLimitCents ? _self.monthlyLimitCents : monthlyLimitCents // ignore: cast_nullable_to_non_nullable
as int?,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,archived: null == archived ? _self.archived : archived // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$Txn {

 String get id; TxnKind get kind;/// Always positive; [kind] says which way the money moved.
 int get amountCents; String get accountId; DateTime get date; DateTime get createdAt; DateTime get updatedAt;/// Destination account, transfers only.
 String? get toAccountId;/// Null for transfers.
 String? get categoryId;/// Merchant or short title ("Σκλαβενίτης"); falls back to the category.
 String? get title; String? get note; String? get recurringRuleId;/// "yyyy-MM-dd" of the recurring occurrence this was created for.
 String? get occurrenceKey; String? get receiptPath; DateTime? get deletedAt;
/// Create a copy of Txn
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TxnCopyWith<Txn> get copyWith => _$TxnCopyWithImpl<Txn>(this as Txn, _$identity);

  /// Serializes this Txn to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Txn;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Txn&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.amountCents, _this.amountCents) || other.amountCents == _this.amountCents)&&(identical(other.accountId, _this.accountId) || other.accountId == _this.accountId)&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.toAccountId, _this.toAccountId) || other.toAccountId == _this.toAccountId)&&(identical(other.categoryId, _this.categoryId) || other.categoryId == _this.categoryId)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.note, _this.note) || other.note == _this.note)&&(identical(other.recurringRuleId, _this.recurringRuleId) || other.recurringRuleId == _this.recurringRuleId)&&(identical(other.occurrenceKey, _this.occurrenceKey) || other.occurrenceKey == _this.occurrenceKey)&&(identical(other.receiptPath, _this.receiptPath) || other.receiptPath == _this.receiptPath)&&(identical(other.deletedAt, _this.deletedAt) || other.deletedAt == _this.deletedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Txn;
  return Object.hash(runtimeType,_this.id,_this.kind,_this.amountCents,_this.accountId,_this.date,_this.createdAt,_this.updatedAt,_this.toAccountId,_this.categoryId,_this.title,_this.note,_this.recurringRuleId,_this.occurrenceKey,_this.receiptPath,_this.deletedAt);
}

@override
String toString() {
  final _this = this as Txn;
  return 'Txn(id: ${_this.id}, kind: ${_this.kind}, amountCents: ${_this.amountCents}, accountId: ${_this.accountId}, date: ${_this.date}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, toAccountId: ${_this.toAccountId}, categoryId: ${_this.categoryId}, title: ${_this.title}, note: ${_this.note}, recurringRuleId: ${_this.recurringRuleId}, occurrenceKey: ${_this.occurrenceKey}, receiptPath: ${_this.receiptPath}, deletedAt: ${_this.deletedAt})';
}


}

/// @nodoc
abstract mixin class $TxnCopyWith<$Res>  {
  factory $TxnCopyWith(Txn value, $Res Function(Txn) _then) = _$TxnCopyWithImpl;
@useResult
$Res call({
 String id, TxnKind kind, int amountCents, String accountId, DateTime date, DateTime createdAt, DateTime updatedAt, String? toAccountId, String? categoryId, String? title, String? note, String? recurringRuleId, String? occurrenceKey, String? receiptPath, DateTime? deletedAt
});




}
/// @nodoc
class _$TxnCopyWithImpl<$Res>
    implements $TxnCopyWith<$Res> {
  _$TxnCopyWithImpl(this._self, this._then);

  final Txn _self;
  final $Res Function(Txn) _then;

/// Create a copy of Txn
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? kind = null,Object? amountCents = null,Object? accountId = null,Object? date = null,Object? createdAt = null,Object? updatedAt = null,Object? toAccountId = freezed,Object? categoryId = freezed,Object? title = freezed,Object? note = freezed,Object? recurringRuleId = freezed,Object? occurrenceKey = freezed,Object? receiptPath = freezed,Object? deletedAt = freezed,}) {
  return _then(Txn(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TxnKind,amountCents: null == amountCents ? _self.amountCents : amountCents // ignore: cast_nullable_to_non_nullable
as int,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,toAccountId: freezed == toAccountId ? _self.toAccountId : toAccountId // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,recurringRuleId: freezed == recurringRuleId ? _self.recurringRuleId : recurringRuleId // ignore: cast_nullable_to_non_nullable
as String?,occurrenceKey: freezed == occurrenceKey ? _self.occurrenceKey : occurrenceKey // ignore: cast_nullable_to_non_nullable
as String?,receiptPath: freezed == receiptPath ? _self.receiptPath : receiptPath // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Txn].
extension TxnPatterns on Txn {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Txn value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Txn() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Txn value)  $default,){
final _that = this;
switch (_that) {
case _Txn():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Txn value)?  $default,){
final _that = this;
switch (_that) {
case _Txn() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  TxnKind kind,  int amountCents,  String accountId,  DateTime date,  DateTime createdAt,  DateTime updatedAt,  String? toAccountId,  String? categoryId,  String? title,  String? note,  String? recurringRuleId,  String? occurrenceKey,  String? receiptPath,  DateTime? deletedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Txn() when $default != null:
return $default(_that.id,_that.kind,_that.amountCents,_that.accountId,_that.date,_that.createdAt,_that.updatedAt,_that.toAccountId,_that.categoryId,_that.title,_that.note,_that.recurringRuleId,_that.occurrenceKey,_that.receiptPath,_that.deletedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  TxnKind kind,  int amountCents,  String accountId,  DateTime date,  DateTime createdAt,  DateTime updatedAt,  String? toAccountId,  String? categoryId,  String? title,  String? note,  String? recurringRuleId,  String? occurrenceKey,  String? receiptPath,  DateTime? deletedAt)  $default,) {final _that = this;
switch (_that) {
case _Txn():
return $default(_that.id,_that.kind,_that.amountCents,_that.accountId,_that.date,_that.createdAt,_that.updatedAt,_that.toAccountId,_that.categoryId,_that.title,_that.note,_that.recurringRuleId,_that.occurrenceKey,_that.receiptPath,_that.deletedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  TxnKind kind,  int amountCents,  String accountId,  DateTime date,  DateTime createdAt,  DateTime updatedAt,  String? toAccountId,  String? categoryId,  String? title,  String? note,  String? recurringRuleId,  String? occurrenceKey,  String? receiptPath,  DateTime? deletedAt)?  $default,) {final _that = this;
switch (_that) {
case _Txn() when $default != null:
return $default(_that.id,_that.kind,_that.amountCents,_that.accountId,_that.date,_that.createdAt,_that.updatedAt,_that.toAccountId,_that.categoryId,_that.title,_that.note,_that.recurringRuleId,_that.occurrenceKey,_that.receiptPath,_that.deletedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Txn extends Txn {
  const _Txn({required this.id, required this.kind, required this.amountCents, required this.accountId, required this.date, required this.createdAt, required this.updatedAt, this.toAccountId, this.categoryId, this.title, this.note, this.recurringRuleId, this.occurrenceKey, this.receiptPath, this.deletedAt}): super._();
  factory _Txn.fromJson(Map<String, dynamic> json) => _$TxnFromJson(json);

@override final  String id;
@override final  TxnKind kind;
/// Always positive; [kind] says which way the money moved.
@override final  int amountCents;
@override final  String accountId;
@override final  DateTime date;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
/// Destination account, transfers only.
@override final  String? toAccountId;
/// Null for transfers.
@override final  String? categoryId;
/// Merchant or short title ("Σκλαβενίτης"); falls back to the category.
@override final  String? title;
@override final  String? note;
@override final  String? recurringRuleId;
/// "yyyy-MM-dd" of the recurring occurrence this was created for.
@override final  String? occurrenceKey;
@override final  String? receiptPath;
@override final  DateTime? deletedAt;

/// Create a copy of Txn
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TxnCopyWith<_Txn> get copyWith => __$TxnCopyWithImpl<_Txn>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TxnToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Txn&&(identical(other.id, id) || other.id == id)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.amountCents, amountCents) || other.amountCents == amountCents)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.date, date) || other.date == date)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.toAccountId, toAccountId) || other.toAccountId == toAccountId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.title, title) || other.title == title)&&(identical(other.note, note) || other.note == note)&&(identical(other.recurringRuleId, recurringRuleId) || other.recurringRuleId == recurringRuleId)&&(identical(other.occurrenceKey, occurrenceKey) || other.occurrenceKey == occurrenceKey)&&(identical(other.receiptPath, receiptPath) || other.receiptPath == receiptPath)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,kind,amountCents,accountId,date,createdAt,updatedAt,toAccountId,categoryId,title,note,recurringRuleId,occurrenceKey,receiptPath,deletedAt);
}

@override
String toString() {
    return 'Txn(id: $id, kind: $kind, amountCents: $amountCents, accountId: $accountId, date: $date, createdAt: $createdAt, updatedAt: $updatedAt, toAccountId: $toAccountId, categoryId: $categoryId, title: $title, note: $note, recurringRuleId: $recurringRuleId, occurrenceKey: $occurrenceKey, receiptPath: $receiptPath, deletedAt: $deletedAt)';
}


}

/// @nodoc
abstract mixin class _$TxnCopyWith<$Res> implements $TxnCopyWith<$Res> {
  factory _$TxnCopyWith(_Txn value, $Res Function(_Txn) _then) = __$TxnCopyWithImpl;
@override @useResult
$Res call({
 String id, TxnKind kind, int amountCents, String accountId, DateTime date, DateTime createdAt, DateTime updatedAt, String? toAccountId, String? categoryId, String? title, String? note, String? recurringRuleId, String? occurrenceKey, String? receiptPath, DateTime? deletedAt
});




}
/// @nodoc
class __$TxnCopyWithImpl<$Res>
    implements _$TxnCopyWith<$Res> {
  __$TxnCopyWithImpl(this._self, this._then);

  final _Txn _self;
  final $Res Function(_Txn) _then;

/// Create a copy of Txn
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? kind = null,Object? amountCents = null,Object? accountId = null,Object? date = null,Object? createdAt = null,Object? updatedAt = null,Object? toAccountId = freezed,Object? categoryId = freezed,Object? title = freezed,Object? note = freezed,Object? recurringRuleId = freezed,Object? occurrenceKey = freezed,Object? receiptPath = freezed,Object? deletedAt = freezed,}) {
  return _then(_Txn(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TxnKind,amountCents: null == amountCents ? _self.amountCents : amountCents // ignore: cast_nullable_to_non_nullable
as int,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,toAccountId: freezed == toAccountId ? _self.toAccountId : toAccountId // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,recurringRuleId: freezed == recurringRuleId ? _self.recurringRuleId : recurringRuleId // ignore: cast_nullable_to_non_nullable
as String?,occurrenceKey: freezed == occurrenceKey ? _self.occurrenceKey : occurrenceKey // ignore: cast_nullable_to_non_nullable
as String?,receiptPath: freezed == receiptPath ? _self.receiptPath : receiptPath // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$RecurringRule {

 String get id;/// Name shown in the list ("Ενοίκιο").
 String get title; TxnKind get kind; int get amountCents; String get accountId; Frequency get frequency; DateTime get startDate; DateTime get nextDueDate; DateTime get createdAt; DateTime get updatedAt; String? get categoryId; String? get note;/// Months for [Frequency.everyNMonths], weeks for weekly, years for
/// yearly; 1 for monthly.
 int get interval;/// Anchor day for month-based frequencies (clamped in short months).
 int? get dayOfMonth;/// 1 = Monday … 7 = Sunday, weekly only.
 int? get weekday; bool get active;
/// Create a copy of RecurringRule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecurringRuleCopyWith<RecurringRule> get copyWith => _$RecurringRuleCopyWithImpl<RecurringRule>(this as RecurringRule, _$identity);

  /// Serializes this RecurringRule to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RecurringRule;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecurringRule&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.amountCents, _this.amountCents) || other.amountCents == _this.amountCents)&&(identical(other.accountId, _this.accountId) || other.accountId == _this.accountId)&&(identical(other.frequency, _this.frequency) || other.frequency == _this.frequency)&&(identical(other.startDate, _this.startDate) || other.startDate == _this.startDate)&&(identical(other.nextDueDate, _this.nextDueDate) || other.nextDueDate == _this.nextDueDate)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.categoryId, _this.categoryId) || other.categoryId == _this.categoryId)&&(identical(other.note, _this.note) || other.note == _this.note)&&(identical(other.interval, _this.interval) || other.interval == _this.interval)&&(identical(other.dayOfMonth, _this.dayOfMonth) || other.dayOfMonth == _this.dayOfMonth)&&(identical(other.weekday, _this.weekday) || other.weekday == _this.weekday)&&(identical(other.active, _this.active) || other.active == _this.active));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RecurringRule;
  return Object.hash(runtimeType,_this.id,_this.title,_this.kind,_this.amountCents,_this.accountId,_this.frequency,_this.startDate,_this.nextDueDate,_this.createdAt,_this.updatedAt,_this.categoryId,_this.note,_this.interval,_this.dayOfMonth,_this.weekday,_this.active);
}

@override
String toString() {
  final _this = this as RecurringRule;
  return 'RecurringRule(id: ${_this.id}, title: ${_this.title}, kind: ${_this.kind}, amountCents: ${_this.amountCents}, accountId: ${_this.accountId}, frequency: ${_this.frequency}, startDate: ${_this.startDate}, nextDueDate: ${_this.nextDueDate}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, categoryId: ${_this.categoryId}, note: ${_this.note}, interval: ${_this.interval}, dayOfMonth: ${_this.dayOfMonth}, weekday: ${_this.weekday}, active: ${_this.active})';
}


}

/// @nodoc
abstract mixin class $RecurringRuleCopyWith<$Res>  {
  factory $RecurringRuleCopyWith(RecurringRule value, $Res Function(RecurringRule) _then) = _$RecurringRuleCopyWithImpl;
@useResult
$Res call({
 String id, String title, TxnKind kind, int amountCents, String accountId, Frequency frequency, DateTime startDate, DateTime nextDueDate, DateTime createdAt, DateTime updatedAt, String? categoryId, String? note, int interval, int? dayOfMonth, int? weekday, bool active
});




}
/// @nodoc
class _$RecurringRuleCopyWithImpl<$Res>
    implements $RecurringRuleCopyWith<$Res> {
  _$RecurringRuleCopyWithImpl(this._self, this._then);

  final RecurringRule _self;
  final $Res Function(RecurringRule) _then;

/// Create a copy of RecurringRule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? kind = null,Object? amountCents = null,Object? accountId = null,Object? frequency = null,Object? startDate = null,Object? nextDueDate = null,Object? createdAt = null,Object? updatedAt = null,Object? categoryId = freezed,Object? note = freezed,Object? interval = null,Object? dayOfMonth = freezed,Object? weekday = freezed,Object? active = null,}) {
  return _then(RecurringRule(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TxnKind,amountCents: null == amountCents ? _self.amountCents : amountCents // ignore: cast_nullable_to_non_nullable
as int,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,frequency: null == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as Frequency,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,nextDueDate: null == nextDueDate ? _self.nextDueDate : nextDueDate // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,interval: null == interval ? _self.interval : interval // ignore: cast_nullable_to_non_nullable
as int,dayOfMonth: freezed == dayOfMonth ? _self.dayOfMonth : dayOfMonth // ignore: cast_nullable_to_non_nullable
as int?,weekday: freezed == weekday ? _self.weekday : weekday // ignore: cast_nullable_to_non_nullable
as int?,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [RecurringRule].
extension RecurringRulePatterns on RecurringRule {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecurringRule value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecurringRule() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecurringRule value)  $default,){
final _that = this;
switch (_that) {
case _RecurringRule():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecurringRule value)?  $default,){
final _that = this;
switch (_that) {
case _RecurringRule() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  TxnKind kind,  int amountCents,  String accountId,  Frequency frequency,  DateTime startDate,  DateTime nextDueDate,  DateTime createdAt,  DateTime updatedAt,  String? categoryId,  String? note,  int interval,  int? dayOfMonth,  int? weekday,  bool active)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecurringRule() when $default != null:
return $default(_that.id,_that.title,_that.kind,_that.amountCents,_that.accountId,_that.frequency,_that.startDate,_that.nextDueDate,_that.createdAt,_that.updatedAt,_that.categoryId,_that.note,_that.interval,_that.dayOfMonth,_that.weekday,_that.active);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  TxnKind kind,  int amountCents,  String accountId,  Frequency frequency,  DateTime startDate,  DateTime nextDueDate,  DateTime createdAt,  DateTime updatedAt,  String? categoryId,  String? note,  int interval,  int? dayOfMonth,  int? weekday,  bool active)  $default,) {final _that = this;
switch (_that) {
case _RecurringRule():
return $default(_that.id,_that.title,_that.kind,_that.amountCents,_that.accountId,_that.frequency,_that.startDate,_that.nextDueDate,_that.createdAt,_that.updatedAt,_that.categoryId,_that.note,_that.interval,_that.dayOfMonth,_that.weekday,_that.active);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  TxnKind kind,  int amountCents,  String accountId,  Frequency frequency,  DateTime startDate,  DateTime nextDueDate,  DateTime createdAt,  DateTime updatedAt,  String? categoryId,  String? note,  int interval,  int? dayOfMonth,  int? weekday,  bool active)?  $default,) {final _that = this;
switch (_that) {
case _RecurringRule() when $default != null:
return $default(_that.id,_that.title,_that.kind,_that.amountCents,_that.accountId,_that.frequency,_that.startDate,_that.nextDueDate,_that.createdAt,_that.updatedAt,_that.categoryId,_that.note,_that.interval,_that.dayOfMonth,_that.weekday,_that.active);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RecurringRule extends RecurringRule {
  const _RecurringRule({required this.id, required this.title, required this.kind, required this.amountCents, required this.accountId, required this.frequency, required this.startDate, required this.nextDueDate, required this.createdAt, required this.updatedAt, this.categoryId, this.note, this.interval = 1, this.dayOfMonth, this.weekday, this.active = true}): super._();
  factory _RecurringRule.fromJson(Map<String, dynamic> json) => _$RecurringRuleFromJson(json);

@override final  String id;
/// Name shown in the list ("Ενοίκιο").
@override final  String title;
@override final  TxnKind kind;
@override final  int amountCents;
@override final  String accountId;
@override final  Frequency frequency;
@override final  DateTime startDate;
@override final  DateTime nextDueDate;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  String? categoryId;
@override final  String? note;
/// Months for [Frequency.everyNMonths], weeks for weekly, years for
/// yearly; 1 for monthly.
@override@JsonKey() final  int interval;
/// Anchor day for month-based frequencies (clamped in short months).
@override final  int? dayOfMonth;
/// 1 = Monday … 7 = Sunday, weekly only.
@override final  int? weekday;
@override@JsonKey() final  bool active;

/// Create a copy of RecurringRule
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecurringRuleCopyWith<_RecurringRule> get copyWith => __$RecurringRuleCopyWithImpl<_RecurringRule>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RecurringRuleToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecurringRule&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.amountCents, amountCents) || other.amountCents == amountCents)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.frequency, frequency) || other.frequency == frequency)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.nextDueDate, nextDueDate) || other.nextDueDate == nextDueDate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.note, note) || other.note == note)&&(identical(other.interval, interval) || other.interval == interval)&&(identical(other.dayOfMonth, dayOfMonth) || other.dayOfMonth == dayOfMonth)&&(identical(other.weekday, weekday) || other.weekday == weekday)&&(identical(other.active, active) || other.active == active));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,title,kind,amountCents,accountId,frequency,startDate,nextDueDate,createdAt,updatedAt,categoryId,note,interval,dayOfMonth,weekday,active);
}

@override
String toString() {
    return 'RecurringRule(id: $id, title: $title, kind: $kind, amountCents: $amountCents, accountId: $accountId, frequency: $frequency, startDate: $startDate, nextDueDate: $nextDueDate, createdAt: $createdAt, updatedAt: $updatedAt, categoryId: $categoryId, note: $note, interval: $interval, dayOfMonth: $dayOfMonth, weekday: $weekday, active: $active)';
}


}

/// @nodoc
abstract mixin class _$RecurringRuleCopyWith<$Res> implements $RecurringRuleCopyWith<$Res> {
  factory _$RecurringRuleCopyWith(_RecurringRule value, $Res Function(_RecurringRule) _then) = __$RecurringRuleCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, TxnKind kind, int amountCents, String accountId, Frequency frequency, DateTime startDate, DateTime nextDueDate, DateTime createdAt, DateTime updatedAt, String? categoryId, String? note, int interval, int? dayOfMonth, int? weekday, bool active
});




}
/// @nodoc
class __$RecurringRuleCopyWithImpl<$Res>
    implements _$RecurringRuleCopyWith<$Res> {
  __$RecurringRuleCopyWithImpl(this._self, this._then);

  final _RecurringRule _self;
  final $Res Function(_RecurringRule) _then;

/// Create a copy of RecurringRule
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? kind = null,Object? amountCents = null,Object? accountId = null,Object? frequency = null,Object? startDate = null,Object? nextDueDate = null,Object? createdAt = null,Object? updatedAt = null,Object? categoryId = freezed,Object? note = freezed,Object? interval = null,Object? dayOfMonth = freezed,Object? weekday = freezed,Object? active = null,}) {
  return _then(_RecurringRule(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TxnKind,amountCents: null == amountCents ? _self.amountCents : amountCents // ignore: cast_nullable_to_non_nullable
as int,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,frequency: null == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as Frequency,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,nextDueDate: null == nextDueDate ? _self.nextDueDate : nextDueDate // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,interval: null == interval ? _self.interval : interval // ignore: cast_nullable_to_non_nullable
as int,dayOfMonth: freezed == dayOfMonth ? _self.dayOfMonth : dayOfMonth // ignore: cast_nullable_to_non_nullable
as int?,weekday: freezed == weekday ? _self.weekday : weekday // ignore: cast_nullable_to_non_nullable
as int?,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$AppSettings {

 int get monthlyIncomeCents; PaydayKind get paydayKind; int get paydayDay; String get currency;/// Shown as initials in the Home avatar.
 String? get displayName;
/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppSettingsCopyWith<AppSettings> get copyWith => _$AppSettingsCopyWithImpl<AppSettings>(this as AppSettings, _$identity);

  /// Serializes this AppSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AppSettings;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppSettings&&(identical(other.monthlyIncomeCents, _this.monthlyIncomeCents) || other.monthlyIncomeCents == _this.monthlyIncomeCents)&&(identical(other.paydayKind, _this.paydayKind) || other.paydayKind == _this.paydayKind)&&(identical(other.paydayDay, _this.paydayDay) || other.paydayDay == _this.paydayDay)&&(identical(other.currency, _this.currency) || other.currency == _this.currency)&&(identical(other.displayName, _this.displayName) || other.displayName == _this.displayName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AppSettings;
  return Object.hash(runtimeType,_this.monthlyIncomeCents,_this.paydayKind,_this.paydayDay,_this.currency,_this.displayName);
}

@override
String toString() {
  final _this = this as AppSettings;
  return 'AppSettings(monthlyIncomeCents: ${_this.monthlyIncomeCents}, paydayKind: ${_this.paydayKind}, paydayDay: ${_this.paydayDay}, currency: ${_this.currency}, displayName: ${_this.displayName})';
}


}

/// @nodoc
abstract mixin class $AppSettingsCopyWith<$Res>  {
  factory $AppSettingsCopyWith(AppSettings value, $Res Function(AppSettings) _then) = _$AppSettingsCopyWithImpl;
@useResult
$Res call({
 int monthlyIncomeCents, PaydayKind paydayKind, int paydayDay, String currency, String? displayName
});




}
/// @nodoc
class _$AppSettingsCopyWithImpl<$Res>
    implements $AppSettingsCopyWith<$Res> {
  _$AppSettingsCopyWithImpl(this._self, this._then);

  final AppSettings _self;
  final $Res Function(AppSettings) _then;

/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? monthlyIncomeCents = null,Object? paydayKind = null,Object? paydayDay = null,Object? currency = null,Object? displayName = freezed,}) {
  return _then(AppSettings(
monthlyIncomeCents: null == monthlyIncomeCents ? _self.monthlyIncomeCents : monthlyIncomeCents // ignore: cast_nullable_to_non_nullable
as int,paydayKind: null == paydayKind ? _self.paydayKind : paydayKind // ignore: cast_nullable_to_non_nullable
as PaydayKind,paydayDay: null == paydayDay ? _self.paydayDay : paydayDay // ignore: cast_nullable_to_non_nullable
as int,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AppSettings].
extension AppSettingsPatterns on AppSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppSettings value)  $default,){
final _that = this;
switch (_that) {
case _AppSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppSettings value)?  $default,){
final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int monthlyIncomeCents,  PaydayKind paydayKind,  int paydayDay,  String currency,  String? displayName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
return $default(_that.monthlyIncomeCents,_that.paydayKind,_that.paydayDay,_that.currency,_that.displayName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int monthlyIncomeCents,  PaydayKind paydayKind,  int paydayDay,  String currency,  String? displayName)  $default,) {final _that = this;
switch (_that) {
case _AppSettings():
return $default(_that.monthlyIncomeCents,_that.paydayKind,_that.paydayDay,_that.currency,_that.displayName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int monthlyIncomeCents,  PaydayKind paydayKind,  int paydayDay,  String currency,  String? displayName)?  $default,) {final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
return $default(_that.monthlyIncomeCents,_that.paydayKind,_that.paydayDay,_that.currency,_that.displayName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppSettings extends AppSettings {
  const _AppSettings({this.monthlyIncomeCents = 0, this.paydayKind = PaydayKind.first, this.paydayDay = 1, this.currency = 'EUR', this.displayName}): super._();
  factory _AppSettings.fromJson(Map<String, dynamic> json) => _$AppSettingsFromJson(json);

@override@JsonKey() final  int monthlyIncomeCents;
@override@JsonKey() final  PaydayKind paydayKind;
@override@JsonKey() final  int paydayDay;
@override@JsonKey() final  String currency;
/// Shown as initials in the Home avatar.
@override final  String? displayName;

/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppSettingsCopyWith<_AppSettings> get copyWith => __$AppSettingsCopyWithImpl<_AppSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppSettings&&(identical(other.monthlyIncomeCents, monthlyIncomeCents) || other.monthlyIncomeCents == monthlyIncomeCents)&&(identical(other.paydayKind, paydayKind) || other.paydayKind == paydayKind)&&(identical(other.paydayDay, paydayDay) || other.paydayDay == paydayDay)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.displayName, displayName) || other.displayName == displayName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,monthlyIncomeCents,paydayKind,paydayDay,currency,displayName);
}

@override
String toString() {
    return 'AppSettings(monthlyIncomeCents: $monthlyIncomeCents, paydayKind: $paydayKind, paydayDay: $paydayDay, currency: $currency, displayName: $displayName)';
}


}

/// @nodoc
abstract mixin class _$AppSettingsCopyWith<$Res> implements $AppSettingsCopyWith<$Res> {
  factory _$AppSettingsCopyWith(_AppSettings value, $Res Function(_AppSettings) _then) = __$AppSettingsCopyWithImpl;
@override @useResult
$Res call({
 int monthlyIncomeCents, PaydayKind paydayKind, int paydayDay, String currency, String? displayName
});




}
/// @nodoc
class __$AppSettingsCopyWithImpl<$Res>
    implements _$AppSettingsCopyWith<$Res> {
  __$AppSettingsCopyWithImpl(this._self, this._then);

  final _AppSettings _self;
  final $Res Function(_AppSettings) _then;

/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? monthlyIncomeCents = null,Object? paydayKind = null,Object? paydayDay = null,Object? currency = null,Object? displayName = freezed,}) {
  return _then(_AppSettings(
monthlyIncomeCents: null == monthlyIncomeCents ? _self.monthlyIncomeCents : monthlyIncomeCents // ignore: cast_nullable_to_non_nullable
as int,paydayKind: null == paydayKind ? _self.paydayKind : paydayKind // ignore: cast_nullable_to_non_nullable
as PaydayKind,paydayDay: null == paydayDay ? _self.paydayDay : paydayDay // ignore: cast_nullable_to_non_nullable
as int,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
