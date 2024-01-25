
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
part 'bannumodel.g.dart';

@JsonSerializable()
class BanuModel {
  final String? name;
  final int? contactNo;
  final int? totalAmount;
  final int? totalItems;
  final String? province;
  final String? district;
  final String? city;
  final String? address;
  final List items;
  final bool? orderComplete;
  final String? userId;
  final DateTime? currentDate;

  BanuModel({
    this.name,
    this.contactNo,
    this.totalAmount,
    this.totalItems,
    this.address,
    this.province,
    this.city,
    this.district,
    required this.items,
    this.orderComplete,
    this.userId,
    required this.currentDate,

  });
  factory BanuModel.fromJson(Map<String,dynamic> json)=> _$BanuModelFromJson(json);
  Map<String,dynamic> toJson()=> _$BanuModelToJson(this);

  static CollectionReference<BanuModel> collection() {
    return FirebaseFirestore.instance.collection('Banu_Wool').withConverter<BanuModel>(
        fromFirestore: (snapshot, _) => BanuModel.fromJson(snapshot.data()!),
        toFirestore: (info, _) => info.toJson());
  }

  static DocumentReference<BanuModel> doc({required String clothId}) {
    return FirebaseFirestore.instance.doc('Banu_Wool/$clothId').withConverter<BanuModel>(
        fromFirestore: (snapshot, _) => BanuModel.fromJson(snapshot.data()!),
        toFirestore: (info, _) => info.toJson());
  }
}
