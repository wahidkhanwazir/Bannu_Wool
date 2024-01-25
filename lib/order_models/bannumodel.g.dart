// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bannumodel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BanuModel _$BanuModelFromJson(Map<String, dynamic> json) => BanuModel(
      name: json['name'] as String?,
      contactNo: json['contactNo'] as int?,
      totalAmount: json['totalAmount'] as int?,
      totalItems: json['totalItems'] as int?,
      address: json['address'] as String?,
      province: json['province'] as String?,
      city: json['city'] as String?,
      district: json['district'] as String?,
      items: json['items'] as List<dynamic>,
      orderComplete: json['orderComplete'] as bool?,
      userId: json['userId'] as String?,
      currentDate: DateTime.parse(json['currentDate'] as String),
    );

Map<String, dynamic> _$BanuModelToJson(BanuModel instance) => <String, dynamic>{
      'name': instance.name,
      'contactNo': instance.contactNo,
      'totalAmount': instance.totalAmount,
      'totalItems': instance.totalItems,
      'province': instance.province,
      'district': instance.district,
      'city': instance.city,
      'address': instance.address,
      'items': instance.items,
      'orderComplete': instance.orderComplete,
      'userId': instance.userId,
      'currentDate': instance.currentDate?.toIso8601String(),
    };
