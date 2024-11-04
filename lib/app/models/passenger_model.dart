class PassengerModel {
  String id;
  String? name;
  String countryCode;
  String phone;
  String referralCode;
  bool verified;
  String role;
  String rideStatus;
  List<String> languages;
  String status;
  String createdAt;

  PassengerModel({
    required this.id,
    this.name,
    required this.countryCode,
    required this.phone,
    required this.referralCode,
    required this.verified,
    required this.role,
    required this.rideStatus,
    required this.languages,
    required this.status,
    required this.createdAt,
  });

  factory PassengerModel.fromJson(Map<String, dynamic> json) {
    return PassengerModel(
      id: json['_id'],
      name: json['name'],
      countryCode: json['country_code'],
      phone: json['phone'],
      referralCode: json['referral_code'],
      verified: json['verified'],
      role: json['role'],
      rideStatus: json['ride_status'],
      languages: List<String>.from(json['languages']),
      status: json['status'],
      createdAt:
          DateTime.fromMillisecondsSinceEpoch(json['createdAt']).toString(),
    );
  }
}
