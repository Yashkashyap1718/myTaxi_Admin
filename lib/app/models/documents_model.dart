class DocumentsModel {
  final String id;
  late final bool? isEnable;
  final bool isTwoSide;
  final String title;

  DocumentsModel({
    required this.id,
    this.isEnable,
    required this.isTwoSide,
    required this.title,
  });

  // Factory constructor to create an instance from a JSON map
  factory DocumentsModel.fromJson(Map<String, dynamic> json) => DocumentsModel(
        id: json["_id"] ?? "", // Map '_id' from the API response to 'id'
        isEnable: json["status"] ==
            "Active", // Assuming 'status' indicates enablement
        isTwoSide: json["side"] == 2, // Assuming side 2 means it's two-sided
        title:
            json["name"] ?? "", // Map 'name' from the API response to 'title'
      );

  // Method to convert the object to a JSON map (if needed)
  Map<String, dynamic> toJson() => {
        "_id": id,
        "status": isEnable == true ? "Active" : "Inactive",
        "side": isTwoSide ? 2 : 1,
        "name": title,
      };
}
