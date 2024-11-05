class BrandModel {
  String? id;
  String? title;
  String? image;
  bool? isEnable;

  BrandModel({this.id, this.title, this.image, this.isEnable});

  @override
  String toString() {
    return 'BrandModel{id: $id, title: $title, image: $image, isEnable: $isEnable}';
  }

  BrandModel.fromJson(Map<String, dynamic> json) {
    id = json['_id']; // Correctly mapping the API response
    title = json['name'];
    image = json["image"];
    isEnable = json['status'] == "Active"; // Map status to a boolean
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['name'] = title;
    data["image"] = image;
    data['status'] = isEnable! ? "Active" : "Inactive";
    return data;
  }
}
