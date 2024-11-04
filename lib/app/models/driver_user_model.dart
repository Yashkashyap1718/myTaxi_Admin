import 'dart:convert';

import 'package:admin/app/models/location_lat_lng.dart';
import 'package:admin/app/models/positions.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

class DriverUserModel {
  String? fullName;
  String? slug;
  String? id;
  String? email;
  String? loginType;
  String? profilePic;
  String? dateOfBirth;
  String? fcmToken;
  String? countryCode;
  String? phoneNumber;
  String? walletAmount;
  String? gender;
  bool? isActive;
  bool? isVerified;
  bool? isOnline;
  // Timestamp? createdAt;
  DriverVehicleDetails? driverVehicleDetails;
  LocationLatLng? location;
  Positions? position;
  double? rotation;
  String? reviewsCount;
  String? reviewsSum;
  var createdAt;
  String? exp;

  DriverUserModel(
      {this.fullName,
      this.slug,
      this.driverVehicleDetails,
      this.location,
      this.position,
      this.id,
      this.isActive,
      this.isVerified,
      this.isOnline,
      this.dateOfBirth,
      this.email,
      this.loginType,
      this.profilePic,
      this.fcmToken,
      this.countryCode,
      this.phoneNumber,
      this.walletAmount,
      // this.createdAt,
      this.rotation,
      this.gender,
      this.reviewsCount,
      this.reviewsSum,
      this.createdAt,
      this.exp});

  DriverUserModel.fromJson(Map<String, dynamic> json) {
    fullName = json['name'];
    slug = json['slug'];
    id = json['_id'];
    email = json['email'];
    loginType = json['loginType'];
    profilePic = json['profilePic'];
    fcmToken = json['fcmToken'];
    countryCode = json['countryCode'];
    phoneNumber = json['phoneNumber'] ?? "";
    walletAmount = json['walletAmount'] ?? "0";
    createdAt = json['createdAt'];
    gender = json['gender'];
    dateOfBirth = json['dateOfBirth'] ?? '';
    isActive = json['isActive'];
    isOnline = json['isOnline'];
    driverVehicleDetails = json['driverVehicleDetails'] != null
        ? DriverVehicleDetails.fromJson(json["driverVehicleDetails"])
        : null;
    isVerified = json['verified'];
    location = json['location'] != null
        ? LocationLatLng.fromJson(json['location'])
        : LocationLatLng();
    position = json['position'] != null
        ? Positions.fromJson(json['position'])
        : Positions();
    rotation = json['rotation'];
    reviewsCount = json['reviewsCount'];
    reviewsSum = json['reviewsSum'];

    exp = json['year_of_experience'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = fullName;
    data['slug'] = slug;
    data['_id'] = id;
    data['email'] = email;
    data['loginType'] = loginType;
    data['profilePic'] = profilePic;
    data['fcmToken'] = fcmToken;
    data['countryCode'] = countryCode;
    data['phoneNumber'] = phoneNumber;
    data['walletAmount'] = walletAmount;
    data['createdAt'] = createdAt;
    data['gender'] = gender;
    data['dateOfBirth'] = dateOfBirth;
    data['isActive'] = isActive;
    data['isOnline'] = isOnline;
    data['verified'] = isVerified;
    data["driverVehicleDetails"] = driverVehicleDetails == null
        ? DriverVehicleDetails().toJson()
        : driverVehicleDetails!.toJson();
    if (location != null) {
      data['location'] = location!.toJson();
    }
    if (position != null) {
      data['position'] = position!.toJson();
    }
    data['rotation'] = rotation;
    data['reviewsCount'] = reviewsCount;
    data['reviewsSum'] = reviewsSum;

    data['year_of_experience'] = exp;
    return data;
  }
}

class DriverVehicleDetails {
  String? vehicleTypeName;
  String? vehicleTypeId;
  String? brandName;
  String? brandId;
  String? modelName;
  String? modelId;
  String? vehicleNumber;
  bool? isVerified;

  DriverVehicleDetails({
    this.vehicleTypeName,
    this.vehicleTypeId,
    this.brandName,
    this.brandId,
    this.modelName,
    this.modelId,
    this.vehicleNumber,
    this.isVerified,
  });

  factory DriverVehicleDetails.fromRawJson(String str) =>
      DriverVehicleDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DriverVehicleDetails.fromJson(Map<String, dynamic> json) =>
      DriverVehicleDetails(
        vehicleTypeName: json["vehicleTypeName"],
        vehicleTypeId: json["vehicleTypeId"],
        brandName: json["brandName"],
        brandId: json["brandId"],
        modelName: json["modelName"],
        modelId: json["modelId"],
        vehicleNumber: json["vehicleNumber"],
        isVerified: json["isVerified"],
      );

  Map<String, dynamic> toJson() => {
        "vehicleTypeName": vehicleTypeName ?? '',
        "vehicleTypeId": vehicleTypeId ?? '',
        "brandName": brandName ?? '',
        "brandId": brandId ?? '',
        "modelName": modelName ?? '',
        "modelId": modelId ?? '',
        "vehicleNumber": vehicleNumber ?? '',
        "isVerified": isVerified ?? false,
      };
}
