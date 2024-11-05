import 'dart:convert';
import 'dart:io';

import 'package:admin/app/constant/api_constant.dart';
import 'package:admin/app/constant/constants.dart';
import 'package:admin/app/constant/show_toast.dart';
import 'package:admin/app/models/brand_model.dart';
import 'package:flutter/foundation.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';

class VehicleBrandScreenController extends GetxController {
  RxString title = "Vehicle Brand".tr.obs;

  RxBool isLoading = true.obs;
  RxList<BrandModel> vehicleBrandList = <BrandModel>[].obs;
  Rx<BrandModel> vehicleBrandModel = BrandModel().obs;

  var currentPage = 1.obs;
  var startIndex = 1.obs;
  var endIndex = 1.obs;
  var totalPage = 1.obs;
  RxString imageURL = "".obs;
  Rx<File> imageFile = File('').obs;
  RxBool isImageUpdated = false.obs;
  RxString mimeType = 'image/png'.obs;
  Rx<TextEditingController> vehicleTypeImage = TextEditingController().obs;

  RxList<BrandModel> currentPageVehicleBrand = <BrandModel>[].obs;

  Rx<TextEditingController> titleController = TextEditingController().obs;
  RxBool isEditing = false.obs;
  RxBool isEnable = false.obs;

  RxList<BrandModel> brandList = <BrandModel>[].obs;

  @override
  void onInit() {
    totalItemPerPage.value = Constant.numOfPageIemList.first;
    getBrand();
    super.onInit();
  }

  getBrand() async {
    isLoading(true);
    brandList.clear(); // Clear existing data before fetching

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    try {
      final response = await http.get(
        Uri.parse(baseURL + vehicleBrandListEndpoint), // Construct the full URL
        headers: {
          "Content-Type": "application/json",
          "token": token.toString(),
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // Check if the API response indicates success
        if (responseData["status"] == true) {
          // Extract the 'data' field which contains the list of brands
          final List<dynamic> data = responseData["data"];

          // Clear the list and map the data to BrandModel
          brandList.addAll(
            data.map((json) => BrandModel.fromJson(json)).toList(),
          );
          // ShowToastDialog.toast("Vehicle brands fetched successfully!".tr);
          // log("Vehicle brands fetched: ${brandList.length}");

          // Update the current page vehicle brand
          // currentPageVehicleBrand.value =
          //     brandList; // Directly assigning all brands for now
        } else {
          ShowToastDialog.toast(
              "Failed to fetch brands: ${responseData["msg"]}");
        }
      } else {
        ShowToastDialog.toast(
            "Failed to fetch brands. Status code: ${response.statusCode}");
      }
    } catch (e) {
      // log("Error fetching vehicle brands: $e");
      ShowToastDialog.toast("An error occurred while fetching vehicle brands.");
    } finally {
      isLoading(false);
    }
  }

  // getBrand() async {
  //   isLoading.value = true;
  //   // await FireStoreUtils.countVehicleBrand();
  //
  //   // vehicleBrandList.value = await FireStoreUtils.getVehicleBrand();
  //   setPagination(totalItemPerPage.value);
  //   isLoading.value = false;
  // }

  // Method to fetch brand data from API

  // setPagination(String page) {
  //   totalItemPerPage.value = page;
  //   int itemPerPage = pageValue(page);
  //   totalPage.value = (vehicleBrandList.length / itemPerPage).ceil();
  //   startIndex.value = (currentPage.value - 1) * itemPerPage;
  //   endIndex.value = (currentPage.value * itemPerPage) > vehicleBrandList.length ? vehicleBrandList.length : (currentPage.value * itemPerPage);
  //   if (endIndex.value < startIndex.value) {
  //     currentPage.value = 1;
  //     setPagination(page);
  //   } else {
  //     currentPageVehicleBrand.value = vehicleBrandList.sublist(startIndex.value, endIndex.value);
  //   }
  //   isLoading.value = false;
  //   update();
  // }
  setPagination(String page) async {
    isLoading.value = true;
    totalItemPerPage.value = page;
    int itemPerPage = pageValue(page);
    totalPage.value = (Constant.vehicleBrandLength! / itemPerPage).ceil();
    startIndex.value = (currentPage.value - 1) * itemPerPage;
    endIndex.value =
        (currentPage.value * itemPerPage) > Constant.vehicleBrandLength!
            ? Constant.vehicleBrandLength!
            : (currentPage.value * itemPerPage);
    if (endIndex.value < startIndex.value) {
      currentPage.value = 1;
      setPagination(page);
    } else {
      try {
        // List<BrandModel> currentPageVehicleBrandData = await FireStoreUtils.getVehicleBrand(currentPage.value, itemPerPage);
        // currentPageVehicleBrand.value = currentPageVehicleBrandData;
      } catch (error) {
        log(error.toString());
      }
    }
    update();
    isLoading.value = false;
  }

  RxString totalItemPerPage = '0'.obs;

  int pageValue(String data) {
    if (data == 'All') {
      return vehicleBrandList.length;
    } else {
      return int.parse(data);
    }
  }

  setDefaultData() {
    titleController.value.text = "";

    isEnable.value = false;
    isEditing.value = false;
  }

  updateBrand() async {
    vehicleBrandModel.value.id = vehicleBrandModel.value.id;
    vehicleBrandModel.value.isEnable = isEnable.value;
    vehicleBrandModel.value.title = titleController.value.text;

    // await FireStoreUtils.addVehicleBrand(vehicleBrandModel.value);
    await getBrand();
  }

  addBrand() async {
    vehicleBrandModel.value.id = Constant.getRandomString(20);
    vehicleBrandModel.value.isEnable = isEnable.value;
    vehicleBrandModel.value.title = titleController.value.text;

    // await FireStoreUtils.addVehicleBrand(vehicleBrandModel.value);
    await getBrand();
  }

  removeBrand(BrandModel vehicleBrandModel) async {
    //   await FirebaseFirestore.instance.collection(CollectionName.vehicleModel).where("brandId", isEqualTo: vehicleBrandModel.id).get().then((value) {
    //     for (var element in value.docs) {
    //       FirebaseFirestore.instance.collection(CollectionName.vehicleModel).doc(ModelVehicleModel.fromJson(element.data()).brandId).delete();
    //     }
    //   }).catchError((error) {
    //     log(error.toString());
    //   });
    //   await FirebaseFirestore.instance.collection(CollectionName.vehicleBrand).doc(vehicleBrandModel.id).delete().then(
    //     (value) {
    //       ShowToastDialog.toast("Brand deleted...!".tr);
    //     },
    //   ).catchError((error) {
    //     ShowToastDialog.toast("Something went wrong".tr);
    //   });
  }

  // Function to add a brand
  Future<void> addVehicleBrandAPI(String textValue) async {
    isLoading(true);
    String? base64Image;

    // Handle image selection for web
    if (kIsWeb && imageURL.value.isNotEmpty) {
      base64Image = imageURL.value
          .split(',')
          .last; // Extract base64 part if using data URL
    } else if (imageFile.value.path.isNotEmpty && !kIsWeb) {
      try {
        List<int> imageBytes = await imageFile.value.readAsBytes();
        base64Image = base64Encode(imageBytes);
        // log("Encoded image: $base64Image");
      } catch (e) {
        log("Error reading image file: $e");
        ShowToastDialog.toast("Failed to read image file.");
      }
    } else {
      log("No image selected or unsupported on the web.");
    }
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");
      log('---token form brand----$token');

      // log('token------${token}');
      final response = await http.post(
        Uri.parse(baseURL + addVehicleBrandEndpoint),
        headers: {
          'token': token
              .toString(), // Assuming you use Bearer token for authorization
        },
        body: jsonEncode({
          "name": textValue,
          "logo":
              base64Image != null ? "data:image/png;base64,$base64Image" : null,
          "status": "isEnable",
        }),
      );

      // log('----body----${jsonEncode({
      //       "name": textValue,
      //       "logo": base64Image != null
      //           ? "data:image/png;base64,$base64Image"
      //           : null,
      //       "status": "isEnable",
      //     })}');
      if (response.statusCode == 200) {
        // log('----addVehicleBrandAPI----${response.body}');
        // Brand added successfully
        ShowToastDialog.toast("Brand added successfully!".tr);
        await getBrand(); // Refresh the brand list
      } else {
        // Handle errors here
        ShowToastDialog.toast("Failed to add brand: ${response.body}".tr);
      }
    } catch (error) {
      // log("Error adding brand: $error");
      ShowToastDialog.toast("An error occurred: $error".tr);
    } finally {
      isLoading(false);
    }
  }
}
