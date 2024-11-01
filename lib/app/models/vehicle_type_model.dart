class VehicleTypeModel {
  final String id;
  final String name;
  final String slug;
  final String term;
  final String type;
  final String parent;
  final String image;
  final String status;
  final int persons;
  final Charges charges;
  final int createdAt;
  final int updatedAt;

  VehicleTypeModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.term,
    required this.type,
    required this.parent,
    required this.image,
    required this.status,
    required this.persons,
    required this.charges,
    required this.createdAt,
    required this.updatedAt,
  });

  factory VehicleTypeModel.fromJson(Map<String, dynamic> json) =>
      VehicleTypeModel(
        id: json["_id"],
        name: json["name"],
        slug: json["slug"],
        term: json["term"],
        type: json["type"],
        parent: json["parent"],
        image: json["image"],
        status: json["status"],
        persons: json["persons"],
        charges: Charges.fromJson(json["charges"]),
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "slug": slug,
        "term": term,
        "type": type,
        "parent": parent,
        "image": image,
        "status": status,
        "persons": persons,
        "charges": charges.toJson(),
        "createdAt": createdAt,
        "updatedAt": updatedAt,
      };
}

class Charges {
  final int farePerKm;
  final int fareMinimumChargesWithinKm;
  final int fareMinimumCharges;

  Charges({
    required this.farePerKm,
    required this.fareMinimumChargesWithinKm,
    required this.fareMinimumCharges,
  });

  factory Charges.fromJson(Map<String, dynamic> json) => Charges(
        farePerKm: json["fare_per_km"],
        fareMinimumChargesWithinKm: json["fare_minimum_charges_within_km"],
        fareMinimumCharges: json["fare_minimum_charges"],
      );

  Map<String, dynamic> toJson() => {
        "fare_per_km": farePerKm,
        "fare_minimum_charges_within_km": fareMinimumChargesWithinKm,
        "fare_minimum_charges": fareMinimumCharges,
      };
}
