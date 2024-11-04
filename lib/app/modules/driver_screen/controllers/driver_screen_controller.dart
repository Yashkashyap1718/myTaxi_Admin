// import 'dart:convert';
// import 'dart:io';
//
// import 'package:admin/app/constant/api_constant.dart';
// import 'package:admin/app/constant/constants.dart';
// import 'package:admin/app/models/driver_user_model.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:nb_utils/nb_utils.dart';
//
// import '../../../constant/show_toast.dart';
//
// class DriverScreenController extends GetxController {
//   RxString title = "Driver".tr.obs;
//
//   RxBool isLoading = true.obs;
//   RxBool isSearchEnable = true.obs;
//
//   RxList<DriverUserModel> driverList = <DriverUserModel>[].obs;
//   RxList<DriverUserModel> tempList = <DriverUserModel>[].obs;
//   RxString selectedSearchType = "Name".obs;
//   RxString selectedSearchTypeForData = "slug".obs;
//   List<String> searchType = [
//     "Name",
//     "Phone",
//     "Email",
//   ];
//
//   var currentPage = 1.obs;
//   var startIndex = 1.obs;
//   var endIndex = 1.obs;
//   var totalPage = 1.obs;
//   Rx<TextEditingController> searchController = TextEditingController().obs;
//
//   RxList<DriverUserModel> currentPageDriver = <DriverUserModel>[].obs;
//   Rx<TextEditingController> userNameController = TextEditingController().obs;
//   Rx<TextEditingController> emailController = TextEditingController().obs;
//   Rx<TextEditingController> phoneNumberController = TextEditingController().obs;
//   Rx<TextEditingController> imageController = TextEditingController().obs;
//   Rx<TextEditingController> dateFiledController = TextEditingController().obs;
//   Rx<DriverUserModel> driverModel = DriverUserModel().obs;
//   Rx<File> imagePath = File('').obs;
//   RxString mimeType = 'image/png'.obs;
//   Rx<Uint8List> imagePickedFileBytes = Uint8List(0).obs;
//   RxBool uploading = false.obs;
//   RxString editingId = ''.obs;
//
//   @override
//   void onInit() {
//     log("DriverScreenController initialized");
//     totalItemPerPage.value = Constant.numOfPageIemList.first;
//     getData();
//     dateFiledController.value.text =
//         "${DateFormat('yyyy-MM-dd').format(selectedDate.value.start)} to ${DateFormat('yyyy-MM-dd').format(selectedDate.value.end)}";
//     super.onInit();
//   }
//
//   getSearchType() async {
//     isLoading.value = true;
//     if (selectedSearchType.value == "Phone") {
//       selectedSearchTypeForData.value = "phoneNumber";
//     } else if (selectedSearchType.value == "Email") {
//       selectedSearchTypeForData.value = "email";
//     } else {
//       selectedSearchTypeForData.value = "slug";
//     }
//     isLoading.value = false;
//   }
//
//   removeDriver(DriverUserModel driverUserModel) async {
//     isLoading = true.obs;
//     // await FirebaseFirestore.instance.collection(CollectionName.drivers).doc(driverUserModel.id).delete().then((value) {
//     //   ShowToastDialog.toast("Driver deleted...!".tr);
//     // }).catchError((error) {
//     //   ShowToastDialog.toast("Something went wrong".tr);
//     // });
//     // await FirebaseFirestore.instance.collection(CollectionName.verifyDriver).doc(driverUserModel.id).delete().then((value) {
//     //   log("Verify Document Deleted...!");
//     // }).catchError((error) {
//     //   log("Error : $error");
//     // });
//     isLoading = false.obs;
//   }
//
//   getUser() async {
//     isLoading.value = true;
//     // await FireStoreUtils.countDrivers();
//     // tempList.value = await FireStoreUtils.getDriver();
//     // driverList.value = await FireStoreUtils.getDriver();
//     setPagination(totalItemPerPage.value);
//     isLoading.value = false;
//   }
//
//   Rx<DateTimeRange> selectedDate = DateTimeRange(
//           start: DateTime(DateTime.now().year, DateTime.now().month,
//               DateTime.now().day, 0, 0, 0),
//           end: DateTime(DateTime.now().year, DateTime.now().month,
//               DateTime.now().day, 23, 59, 0))
//       .obs;
//
//   setPagination(String page) async {
//     isLoading.value = true;
//     totalItemPerPage.value = page;
//     int itemPerPage = pageValue(page);
//     totalPage.value = (Constant.driverLength! / itemPerPage).ceil();
//     startIndex.value = (currentPage.value - 1) * itemPerPage;
//     endIndex.value = (currentPage.value * itemPerPage) > Constant.driverLength!
//         ? Constant.driverLength!
//         : (currentPage.value * itemPerPage);
//     if (endIndex.value < startIndex.value) {
//       currentPage.value = 1;
//       setPagination(page);
//     } else {
//       try {
//         getData(); // List<DriverUserModel> currentPageDriverData = await FireStoreUtils.getDriver(currentPage.value, itemPerPage, searchController.value.text, selectedSearchTypeForData.value);
//         // currentPageDriver.value = currentPageDriverData;
//       } catch (error) {
//         log(error.toString());
//       }
//     }
//     update();
//     isLoading.value = false;
//   }
//   // setPagination(String page) {
//   //   totalItemPerPage.value = page;
//   //   int itemPerPage = pageValue(page);
//   //   totalPage.value = (driverList.length / itemPerPage).ceil();
//   //   startIndex.value = (currentPage.value - 1) * itemPerPage;
//   //   endIndex.value = (currentPage.value * itemPerPage) > driverList.length ? driverList.length : (currentPage.value * itemPerPage);
//   //   if (endIndex.value < startIndex.value) {
//   //     currentPage.value = 1;
//   //     setPagination(page);
//   //   } else {
//   //     currentPageDriver.value = driverList.sublist(startIndex.value, endIndex.value);
//   //   }
//   //   isLoading.value = false;
//   //   update();
//   // }
//
//   RxString totalItemPerPage = '0'.obs;
//   int pageValue(String data) {
//     if (data == 'All') {
//       return Constant.driverLength!;
//     } else {
//       return int.parse(data);
//     }
//   }
//
//   getArgument(DriverUserModel driverUserModel) {
//     driverModel.value = driverUserModel;
//     userNameController.value.text = driverModel.value.fullName!;
//     phoneNumberController.value.text =
//         "${driverModel.value.countryCode!} ${driverModel.value.phoneNumber!}";
//     emailController.value.text = driverModel.value.email!;
//     imageController.value.text = driverModel.value.profilePic!;
//     editingId.value = driverModel.value.id!;
//   }
//
//   pickPhoto() async {
//     try {
//       uploading.value = true;
//       ImagePicker picker = ImagePicker();
//       final img =
//           await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
//
//       File imageFile = File(img!.path);
//
//       imageController.value.text = img.name;
//       imagePath.value = imageFile;
//       imagePickedFileBytes.value = await img.readAsBytes();
//       mimeType.value = "${img.mimeType}";
//       uploading.value = false;
//     } catch (e) {
//       uploading.value = false;
//     }
//   }
//
//   getData() async {
//     isLoading(true);
//     driverList.clear();
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString("token");
//
//     log('----token--from--getData---$token');
//     try {
//       final response = await http.get(
//         Uri.parse(baseURL + driverListEndpoint),
//         headers: {
//           "Content-Type": "application/json",
//           "token": token ?? "",
//         },
//       );
//
//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//         if (responseData["status"] == true) {
//           final List<dynamic> data = responseData["data"];
//           driverList.addAll(
//               data.map((json) => DriverUserModel.fromJson(json)).toList());
//           log("Vehicle types fetched: ${driverList.length}");
//         } else {
//           // Show the message from the API if fetching vehicle types failed
//           ShowToastDialog.toast(
//               "Failed to fetch vehicle types: ${responseData["msg"]}");
//         }
//       } else {
//         ShowToastDialog.toast(
//             "Failed to fetch vehicle types. Status code: ${response.statusCode}");
//       }
//     } catch (e) {
//       log("Error fetching vehicle types: $e");
//       ShowToastDialog.toast("An error occurred while fetching vehicle types.");
//     } finally {
//       isLoading(false);
//     }
//   }
// }

import 'dart:convert';
import 'dart:io';

import 'package:admin/app/constant/api_constant.dart';
import 'package:admin/app/constant/constants.dart';
import 'package:admin/app/models/driver_user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../constant/show_toast.dart';

class DriverScreenController extends GetxController {
  RxString title = "Driver".tr.obs;
  RxBool isLoading = true.obs;
  RxBool isSearchEnable = true.obs;

  RxList<DriverUserModel> driverList = <DriverUserModel>[].obs;
  RxList<DriverUserModel> tempList = <DriverUserModel>[].obs;
  RxString selectedSearchType = "Name".obs;
  RxString selectedSearchTypeForData = "slug".obs;

  List<String> searchType = ["Name", "Phone", "Email"];
  var currentPage = 1.obs;
  var startIndex = 1.obs;
  var endIndex = 1.obs;
  var totalPage = 1.obs;
  Rx<TextEditingController> searchController = TextEditingController().obs;

  RxList<DriverUserModel> currentPageDriver = <DriverUserModel>[].obs;
  Rx<TextEditingController> userNameController = TextEditingController().obs;
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> phoneNumberController = TextEditingController().obs;
  Rx<TextEditingController> imageController = TextEditingController().obs;
  Rx<TextEditingController> dateFiledController = TextEditingController().obs;
  Rx<DriverUserModel> driverModel = DriverUserModel().obs;

  Rx<File> imagePath = File('').obs;
  RxString mimeType = 'image/png'.obs;
  Rx<Uint8List> imagePickedFileBytes = Uint8List(0).obs;
  RxBool uploading = false.obs;
  RxString editingId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    log("DriverScreenController initialized");

    // Initializing date range for filtering data
    dateFiledController.value.text =
        "${DateFormat('yyyy-MM-dd').format(selectedDate.value.start)} to ${DateFormat('yyyy-MM-dd').format(selectedDate.value.end)}";

    // Setting initial page values and calling getData to load drivers
    totalItemPerPage.value = Constant.numOfPageIemList.first;
    getData();
  }

  Rx<DateTimeRange> selectedDate = DateTimeRange(
          start: DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day),
          end: DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day, 23, 59, 0))
      .obs;

  RxString totalItemPerPage = '0'.obs;

  getData() async {
    isLoading(true);
    driverList.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    if (token == null) {
      log("Token is null, unable to fetch data.");
      ShowToastDialog.toast("Authentication token missing.");
      isLoading(false);
      return;
    }

    log('Fetching driver data with token: $token');
    try {
      final response = await http.get(
        Uri.parse(baseURL + driverListEndpoint),
        headers: {
          "Content-Type": "application/json",
          "token": token,
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData["status"] == true) {
          final List<dynamic> data = responseData["data"];
          driverList.addAll(
              data.map((json) => DriverUserModel.fromJson(json)).toList());
          log("Driver data fetched: ${driverList.length}");

          // Populate currentPageDriver based on pagination after fetching data
          await setPagination(totalItemPerPage.value);
        } else {
          ShowToastDialog.toast("Failed to fetch data: ${responseData["msg"]}");
        }
      } else {
        ShowToastDialog.toast("Error: Status code ${response.statusCode}");
      }
    } catch (e) {
      log("Error fetching driver data: $e");
      ShowToastDialog.toast("An error occurred while fetching driver data.");
    } finally {
      isLoading(false);
    }
  }

  removeDriver(DriverUserModel driverUserModel) async {
    isLoading = true.obs;
//     // await FirebaseFirestore.instance.collection(CollectionName.drivers).doc(driverUserModel.id).delete().then((value) {
//     //   ShowToastDialog.toast("Driver deleted...!".tr);
//     // }).catchError((error) {
//     //   ShowToastDialog.toast("Something went wrong".tr);
//     // });
//     // await FirebaseFirestore.instance.collection(CollectionName.verifyDriver).doc(driverUserModel.id).delete().then((value) {
//     //   log("Verify Document Deleted...!");
//     // }).catchError((error) {
//     //   log("Error : $error");
//     // });
    isLoading = false.obs;
  }

  /// Handle pagination for driver list
  /// Handle pagination for driver list
  setPagination(String page) async {
    isLoading(true);

    // Set items per page and calculate total pages
    totalItemPerPage.value = page;
    int itemPerPage = pageValue(page);
    totalPage.value = (driverList.length / itemPerPage).ceil();

    // Calculate start and end indices for the current page
    startIndex.value = (currentPage.value - 1) * itemPerPage;
    endIndex.value = startIndex.value + itemPerPage;

    // Adjust endIndex if it goes beyond the length of the driverList
    if (endIndex.value > driverList.length) {
      endIndex.value = driverList.length;
    }

    // Populate currentPageDriver with the items for the current page
    currentPageDriver.value =
        driverList.sublist(startIndex.value, endIndex.value);

    log("Current page drivers: ${currentPageDriver.length}"); // Log for debugging

    update();
    isLoading(false);
  }

  int pageValue(String data) {
    if (data == 'All') {
      return Constant.driverLength!;
    } else {
      return int.parse(data);
    }
  }

  getUser() async {
    isLoading.value = true;
//     // await FireStoreUtils.countDrivers();
//     // tempList.value = await FireStoreUtils.getDriver();
//     // driverList.value = await FireStoreUtils.getDriver();
    setPagination(totalItemPerPage.value);
    isLoading.value = false;
  }

  /// Update the search type based on user selection
  getSearchType() async {
    isLoading.value = true;
    if (selectedSearchType.value == "Phone") {
      selectedSearchTypeForData.value = "phoneNumber";
    } else if (selectedSearchType.value == "Email") {
      selectedSearchTypeForData.value = "email";
    } else {
      selectedSearchTypeForData.value = "slug";
    }
    isLoading.value = false;
  }

  /// Get arguments for selected driver user
  getArgument(DriverUserModel driverUserModel) {
    driverModel.value = driverUserModel;
    userNameController.value.text = driverModel.value.fullName!;
    phoneNumberController.value.text =
        "${driverModel.value.countryCode!} ${driverModel.value.phoneNumber!}";
    emailController.value.text = driverModel.value.email!;
    imageController.value.text = driverModel.value.profilePic!;
    editingId.value = driverModel.value.id!;
  }

  /// Pick photo from gallery
  pickPhoto() async {
    try {
      uploading.value = true;
      ImagePicker picker = ImagePicker();
      final img =
          await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);

      if (img != null) {
        File imageFile = File(img.path);
        imageController.value.text = img.name;
        imagePath.value = imageFile;
        imagePickedFileBytes.value = (await img.readAsBytes());
        mimeType.value = "${img.mimeType}";
      }
      uploading.value = false;
    } catch (e) {
      uploading.value = false;
      log("Error picking image: $e");
    }
  }
}
