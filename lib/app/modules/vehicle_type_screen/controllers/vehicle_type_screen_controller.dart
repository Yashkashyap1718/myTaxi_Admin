import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:admin/app/constant/api_constant.dart';
import 'package:admin/app/models/vehicle_type_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constant/constants.dart';
import '../../../constant/show_toast.dart';

class VehicleTypeScreenController extends GetxController {
  Rx<TextEditingController> vehicleTitle = TextEditingController().obs;
  Rx<TextEditingController> minimumCharge = TextEditingController().obs;
  Rx<TextEditingController> minimumChargeWithKm = TextEditingController().obs;
  Rx<TextEditingController> perKm = TextEditingController().obs;
  Rx<TextEditingController> person = TextEditingController().obs;

  RxList<VehicleTypeModel> vehicleTypeList = <VehicleTypeModel>[].obs;
  Rx<TextEditingController> vehicleTypeImage = TextEditingController().obs;

  RxString title = "VehicleType".obs;
  RxBool isEnable = false.obs;
  Rx<File> imageFile = File('').obs;
  RxString mimeType = 'image/png'.obs;
  RxBool isLoading = false.obs;
  RxBool isEditing = false.obs;
  RxBool isImageUpdated = false.obs;
  RxString imageURL = "".obs;
  RxString editingId = "".obs;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  // getData() async {
  //   isLoading(true);
  //   vehicleTypeList.clear();
  //   // Fetch data logic here...
  //   isLoading(false);
  // }

  getData() async {
    isLoading(true);
    vehicleTypeList.clear(); // Clear the existing list before fetching new data
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    log('----token--from--getData---$token');
    try {
      final response = await http.get(
        Uri.parse(
            baseURL + vehicleTypeListEndpoint), // Replace with your endpoint
        headers: {
          "Content-Type": "application/json",
          "token": token ?? "",
        },
      );

      // log("Fetching vehicle types: ${response.statusCode}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        // log("Full API Response: $responseData"); // Log the entire response

        // Check if the API response indicates success
        if (responseData["status"] == true) {
          // Extract the 'data' field which contains the list of vehicle types
          final List<dynamic> data = responseData["data"];
          vehicleTypeList.addAll(
              data.map((json) => VehicleTypeModel.fromJson(json)).toList());
          // log("Vehicle types fetched: ${vehicleTypeList.length}");
        } else {
          // Show the message from the API if fetching vehicle types failed
          ShowToastDialog.toast(
              "Failed to fetch vehicle types: ${responseData["msg"]}");
        }
      } else {
        ShowToastDialog.toast(
            "Failed to fetch vehicle types. Status code: ${response.statusCode}");
      }
    } catch (e) {
      log("Error fetching vehicle types: $e");
      ShowToastDialog.toast("An error occurred while fetching vehicle types.");
    } finally {
      isLoading(false);
    }
  }

  setDefaultData() {
    vehicleTitle.value.text = "";
    minimumCharge.value.text = "";
    minimumChargeWithKm.value.text = "";
    vehicleTypeImage.value.clear();

    perKm.value.text = "";
    person.value.text = "";
    isEditing.value = false;
    imageFile.value = File('');
    mimeType.value = 'image/png';
    editingId.value = '';
    isEditing.value = false;
    isImageUpdated.value = false;
    imageURL.value = '';
  }

  Future<void> addVehicleTypeViaAPI() async {
    isLoading(true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    log('----token--from--addvehicle---$token');

    // Initialize the base64Image variable
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

    // Prepare the request body
    final body = {
      "name": vehicleTitle.value.text,
      "fare_per_km": double.tryParse(perKm.value.text) ?? 0,
      "fare_minimum_charges_within_km":
          double.tryParse(minimumChargeWithKm.value.text) ?? 0,
      "fare_minimum_charges": double.tryParse(minimumCharge.value.text) ?? 0,
      "persons": int.tryParse(person.value.text) ?? 0,
      "logo": base64Image != null ? "data:image/png;base64,$base64Image" : null,
    };

    // Send the POST request
    try {
      final response = await http.post(
        Uri.parse(baseURL + vehicleTypeAddEndpoint),
        headers: {
          "Content-Type": "application/json",
          "token": token ?? "",
        },
        body: jsonEncode(body),
      );

      // log("Request body: $body");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData["status"] == true) {
          ShowToastDialog.toast(responseData["msg"]);
          getData(); // Refresh data if needed
        } else {
          ShowToastDialog.toast("Failed to add vehicle type.");
        }
      } else {
        ShowToastDialog.toast("Error: ${response.statusCode}");
      }
    } catch (e) {
      log("Error in addVehicleTypeViaAPI: $e");
      ShowToastDialog.toast("An error occurred while adding vehicle type.");
    } finally {
      isLoading(false);
    }
  }

  // Other existing methods...

  updateVehicleType() async {
    isLoading(true);
    String docId = editingId.value;
    // Update vehicle type logic here...
    await getData();
    isLoading(false);
  }

  addVehicleTyep() async {
    isLoading(true);
    String docId = Constant.getRandomString(20);
    // Add vehicle type logic here...
    await getData();
    isLoading(false);
  }

  removeVehicleTypeModel(VehicleTypeModel vehicleTypeModel) async {
    isLoading(true);
    // Remove vehicle type logic here...
    await getData();
    isLoading(false);
  }
}
