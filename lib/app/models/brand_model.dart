class BrandModel {
  String? id;
  String? title;
  bool? isEnable;

  BrandModel({this.id, this.title, this.isEnable});

  @override
  String toString() {
    return 'BrandModel{id: $id, title: $title, isEnable: $isEnable}';
  }

  BrandModel.fromJson(Map<String, dynamic> json) {
    id = json['_id']; // Correctly mapping the API response
    title = json['name'];
    isEnable = json['status'] == "Active"; // Map status to a boolean
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['name'] = title;
    data['status'] = isEnable! ? "Active" : "Inactive";
    return data;
  }
}
