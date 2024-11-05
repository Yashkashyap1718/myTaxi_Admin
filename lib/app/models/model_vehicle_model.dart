// class ModelVehicleModel {
//   String? id;
//   String? brandId;
//   String? title;
//   bool? isEnable;
//
//   ModelVehicleModel({this.id, this.brandId,this.title, this.isEnable});
//
//   ModelVehicleModel.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     brandId = json['brandId'];
//     title = json['title'];
//     isEnable = json['isEnable'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['brandId'] = brandId;
//     data['title'] = title;
//     data['isEnable'] = isEnable;
//     return data;
//   }
// }

class ModelVehicleModel {
  String? id; // Corresponds to "_id" in the API response
  String? brandId;
  String? name; // Changed from title to name
  bool? isEnable;
  Charges? charges; // New nested class
  String? slug;
  String? term;
  String? type;
  String? parent;
  String? image;
  String? status;
  int? persons;
  int? createdAt;
  int? updatedAt;
  int? v; // Corresponds to "__v" in the API response

  ModelVehicleModel({
    this.id,
    this.brandId,
    this.name,
    this.isEnable,
    this.charges,
    this.slug,
    this.term,
    this.type,
    this.parent,
    this.image,
    this.status,
    this.persons,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  ModelVehicleModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    brandId = json[
        'brandId']; // Ensure this matches your actual field in the API if applicable
    name = json['name'];
    isEnable = json['isEnable'];
    charges =
        json['charges'] != null ? Charges.fromJson(json['charges']) : null;
    slug = json['slug'];
    term = json['term'];
    type = json['type'];
    parent = json['parent'];
    image = json['image'];
    status = json['status'];
    persons = json['persons'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['brandId'] =
        brandId; // Ensure this matches your actual field in the API if applicable
    data['name'] = name;
    data['isEnable'] = isEnable;
    if (charges != null) {
      data['charges'] = charges!.toJson();
    }
    data['slug'] = slug;
    data['term'] = term;
    data['type'] = type;
    data['parent'] = parent;
    data['image'] = image;
    data['status'] = status;
    data['persons'] = persons;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = v;
    return data;
  }
}

class Charges {
  double? farePerKm;
  double? fareMinimumChargesWithinKm;
  double? fareMinimumCharges;

  Charges({
    this.farePerKm,
    this.fareMinimumChargesWithinKm,
    this.fareMinimumCharges,
  });

  Charges.fromJson(Map<String, dynamic> json) {
    farePerKm = json['fare_per_km'] != null
        ? (json['fare_per_km'] as num).toDouble()
        : null;
    fareMinimumChargesWithinKm = json['fare_minimum_charges_within_km'] != null
        ? (json['fare_minimum_charges_within_km'] as num).toDouble()
        : null;
    fareMinimumCharges = json['fare_minimum_charges'] != null
        ? (json['fare_minimum_charges'] as num).toDouble()
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fare_per_km'] = farePerKm;
    data['fare_minimum_charges_within_km'] = fareMinimumChargesWithinKm;
    data['fare_minimum_charges'] = fareMinimumCharges;
    return data;
  }
}
