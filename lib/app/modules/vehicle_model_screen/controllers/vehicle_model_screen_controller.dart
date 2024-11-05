import 'dart:convert';
import 'dart:io';

import 'package:admin/app/constant/constants.dart';
import 'package:admin/app/models/brand_model.dart';
import 'package:admin/app/models/model_vehicle_model.dart';
import 'package:flutter/foundation.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';

import '../../../constant/api_constant.dart';
import '../../../constant/show_toast.dart';
import '../../vehicle_brand_screen/controllers/vehicle_brand_screen_controller.dart';

class VehicleModelScreenController extends GetxController {
  RxString title = "Vehicle Model".tr.obs;

  RxBool isLoading = true.obs;
  RxList<ModelVehicleModel> vehicleModelList = <ModelVehicleModel>[].obs;
  RxList<ModelVehicleModel> tempList = <ModelVehicleModel>[].obs;
  Rx<ModelVehicleModel> modelVehicleModel = ModelVehicleModel().obs;
  RxList<BrandModel> vehicleBrandList = <BrandModel>[].obs;
  Rx<BrandModel> selectedVehicleBrand = BrandModel().obs;
  Rx<TextEditingController> vehicleModelImage = TextEditingController().obs;
  RxBool isImageUpdated = false.obs;
  RxString mimeType = 'image/png'.obs;
  Rx<String> vehicleBrandId = "".obs;
  RxString imageURL = "".obs;
  Rx<File> imageFile = File('').obs;
  var currentPage = 1.obs;
  var startIndex = 1.obs;
  var endIndex = 1.obs;
  var totalPage = 1.obs;
  RxList<ModelVehicleModel> currentPageVehicleModel = <ModelVehicleModel>[].obs;

  Rx<TextEditingController> titleController = TextEditingController().obs;
  final VehicleBrandScreenController brandController =
      Get.put(VehicleBrandScreenController());
  RxBool isEditing = false.obs;
  RxBool isEnable = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit(); // Ensure super.onInit() is called first
    print("*******abc***********$vehicleBrandList"); // Debug statement
    totalItemPerPage.value = Constant.numOfPageIemList.first;
    await brandController.getBrand();
    vehicleBrandList.assignAll(brandController.brandList);
    // vehicleBrandList.value = await VehicleBrandScreenController().getBrand();

    await getVehicleModelAPI(); // Make sure to await this if needed
    print("getVehicleModelAPI has been called."); // Debug statement
  }

  // getVehicleModel() async {
  //   isLoading.value = true;
  //   // await FireStoreUtils.countVehicleModel();
  //   await setPagination(totalItemPerPage.value);
  //   isLoading.value = false;
  // }

  // get Vehicle Model
  Future<void> getVehicleModelAPI() async {
    try {
      isLoading.value = true; // Start loading
      vehicleModelList.clear(); // Clear the existing list
      print("Fetching vehicle models..."); // Debug statement

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");
      print("Token retrieved: $token"); // Debug statement

      final response = await http.get(
        Uri.parse(baseURL + vehicleModelListEndpoint),
        headers: {
          "Content-Type": "application/json",
          "token": token.toString(),
        },
      );

      print(
          "HTTP GET request sent to: ${baseURL + vehicleModelListEndpoint}"); // Debug statement
      print("Response status code: ${response.statusCode}"); // Debug statement

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print("API Response: $responseData"); // Debug statement

        // Check if the API response indicates success
        if (responseData["status"] == true) {
          final List<dynamic> data = responseData["data"];
          print("Data fetched: $data"); // Debug statement

          vehicleModelList.addAll(
            data.map((json) => ModelVehicleModel.fromJson(json)).toList(),
          );
          print(
              "Vehicle model list updated. Count: ${vehicleModelList.length}"); // Debug statement
        } else {
          ShowToastDialog.toast(
              "Failed to fetch vehicle models: ${responseData["msg"]}");
          print("API Error Message: ${responseData["msg"]}"); // Debug statement
        }
      } else {
        ShowToastDialog.toast(
            "Failed to fetch vehicle models. Status code: ${response.statusCode}");
        print(
            "Failed HTTP request with status code: ${response.statusCode}"); // Debug statement
      }
    } catch (e) {
      log("Error fetching vehicle models: $e");
      ShowToastDialog.toast("An error occurred while fetching vehicle models.");
      print("Exception caught: $e"); // Debug statement
    } finally {
      isLoading.value = false; // Stop loading
      print("Finished fetching vehicle models."); // Debug statement
    }
  }

  // add vehicle model
  // Function to add a vehicle model
  Future<void> addVehicleBrandModel(String vehicleBrandId) async {
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
      print("Preparing to add a new vehicle model..."); // Debug statement

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");
      print("Token retrieved: $token"); // Debug statement

      // Prepare the request body
      final body = jsonEncode({
        "vehicle_brand_id": vehicleBrandId,
        "name": titleController.value.text,
        "logo":
            base64Image != null ? "data:image/png;base64,$base64Image" : null,
      });
      print("Request body: $body"); // Debug statement

      // Make the POST request
      final response = await http.post(
        Uri.parse(baseURL + addVehicleBrandModelEndpoint),
        headers: {
          "Content-Type": "application/json",
          "token": token.toString(),
        },
        body: body,
      );

      print(
          "HTTP POST request sent to: ${baseURL + addVehicleBrandModelEndpoint}"); // Debug statement
      print("Response status code: ${response.statusCode}"); // Debug statement

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print("API Response: $responseData"); // Debug statement

        if (responseData["status"] == true) {
          ShowToastDialog.toast(
              "Vehicle model added successfully!"); // Notify success
          print("Vehicle model added successfully!"); // Debug statement
          await getVehicleModelAPI(); // Refresh the vehicle model list
        } else {
          ShowToastDialog.toast(
              "Failed to add vehicle model: ${responseData["msg"]}");
          print("API Error Message: ${responseData["msg"]}"); // Debug statement
        }
      } else {
        ShowToastDialog.toast(
            "Failed to add vehicle model. Status code: ${response.statusCode}");
        print(
            "Failed HTTP request with status code: ${response.statusCode}"); // Debug statement
      }
    } catch (e) {
      log("Error adding vehicle model: $e");
      ShowToastDialog.toast("An error occurred while adding vehicle model.");
      print("Exception caught: $e"); // Debug statement
    } finally {
      isLoading.value = false; // Stop loading
      print("Finished adding vehicle model."); // Debug statement
    }
  }

  // setPagination(String page) {
  //   totalItemPerPage.value = page;
  //   int itemPerPage = pageValue(page);
  //   totalPage.value = (vehicleModelList.length / itemPerPage).ceil();
  //   startIndex.value = (currentPage.value - 1) * itemPerPage;
  //   endIndex.value = (currentPage.value * itemPerPage) > vehicleModelList.length ? vehicleModelList.length : (currentPage.value * itemPerPage);
  //   if (endIndex.value < startIndex.value) {
  //     currentPage.value = 1;
  //     setPagination(page);
  //   } else {
  //     currentPageVehicleModel.value = vehicleModelList.sublist(startIndex.value, endIndex.value);
  //   }
  //   isLoading.value = false;
  //   update();
  // }

  setPagination(String page) async {
    isLoading.value = true;
    totalItemPerPage.value = page;
    int itemPerPage = pageValue(page);
    totalPage.value = (Constant.vehicleModelLength! / itemPerPage).ceil();
    startIndex.value = (currentPage.value - 1) * itemPerPage;
    endIndex.value =
        (currentPage.value * itemPerPage) > Constant.vehicleModelLength!
            ? Constant.vehicleModelLength!
            : (currentPage.value * itemPerPage);
    if (endIndex.value < startIndex.value) {
      currentPage.value = 1;
      setPagination(page);
    } else {
      try {
        // List<ModelVehicleModel> currentPageVehicleModelData =
        //     await FireStoreUtils.getVehicleModel(currentPage.value, itemPerPage, selectedVehicleBrand.value.id != null ? selectedVehicleBrand.value.id.toString() : "");
        // currentPageVehicleModel.value = currentPageVehicleModelData;
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
      return vehicleModelList.length;
    } else {
      return int.parse(data);
    }
  }

  setDefaultData() {
    titleController.value.text = "";
    vehicleBrandId.value = "";
    isEnable.value = false;
    isEditing.value = false;
    selectedVehicleBrand.value = BrandModel();
  }

  updateVehicleModel() async {
    modelVehicleModel.value.id = modelVehicleModel.value.id;
    modelVehicleModel.value.brandId = vehicleBrandId.value;
    modelVehicleModel.value.isEnable = isEnable.value;
    modelVehicleModel.value.name = titleController.value.text;
    // await FireStoreUtils.updateVehicleModel(modelVehicleModel.value);
    await getVehicleModelAPI();
  }

  addVehicleModel() async {
    modelVehicleModel.value.id = Constant.getRandomString(20);
    modelVehicleModel.value.brandId = vehicleBrandId.value;
    modelVehicleModel.value.isEnable = isEnable.value;
    modelVehicleModel.value.name = titleController.value.text;
    // await FireStoreUtils.addVehicleModel(modelVehicleModel.value);
    await getVehicleModelAPI();
  }

  removeVehicleModel(ModelVehicleModel modelVehicleModel) async {
    // await FirebaseFirestore.instance.collection(CollectionName.vehicleModel).doc(modelVehicleModel.id).delete().then((value) {
    //   ShowToastDialog.toast("Model deleted...!".tr);
    // }).catchError((error) {
    //   ShowToastDialog.toast("Something went wrong".tr);
    // });
  }
}
