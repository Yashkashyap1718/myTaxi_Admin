import 'dart:convert';

import 'package:admin/app/constant/api_constant.dart';
import 'package:admin/app/constant/constants.dart';
import 'package:admin/app/models/driver_user_model.dart';
import 'package:admin/app/models/verify_driver_model.dart';
import 'package:admin/app/utils/toast.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../constant/show_toast.dart';

class VerifyDocumentScreenController extends GetxController {
  RxString title = "Verify Document".tr.obs;
  RxBool isLoading = true.obs;

  RxBool isLoadingVehicleDetails = false.obs;
  RxList<VerifyDriverModel> verifyDriverList = <VerifyDriverModel>[].obs;
  RxList<VerifyDocumentModel> verifyDocumentList = <VerifyDocumentModel>[].obs;
  Rx<VerifyDriverModel> verifyDriverModel = VerifyDriverModel().obs;
  Rx<DriverUserModel> driverUserModel = DriverUserModel().obs;
  RxList<VerifyDriverModel> tempList = <VerifyDriverModel>[].obs;
  // RxList<DriverUserModel> tempList = <DriverUserModel>[].obs;
  Rx<DriverUserModel> driverUserDetails = DriverUserModel().obs;
  RxList<DriverUserModel> driverList = <DriverUserModel>[].obs;

  var currentPage = 1.obs;
  var startIndex = 1.obs;
  var endIndex = 1.obs;
  var totalPage = 1.obs;
  RxList<VerifyDriverModel> currentPageVerifyDriver = <VerifyDriverModel>[].obs;

  Rx<TextEditingController> dateFiledController = TextEditingController().obs;

  RxBool isVerify = false.obs;
  RxString editingVerifyDocumentId = "".obs;

  @override
  void onInit() {
    totalItemPerPage.value = Constant.numOfPageIemList.first;
    getData();

    getDriverData();
    dateFiledController.value.text =
        "${DateFormat('yyyy-MM-dd').format(selectedDate.value.start)} to ${DateFormat('yyyy-MM-dd').format(selectedDate.value.end)}";
    super.onInit();
  }

  getData() async {
    isLoading.value = true;
    // tempList.value = await FireStoreUtils.getVerifyDriverModel();
    // verifyDriverList.value = await FireStoreUtils.getVerifyDriverModel();
    setPagination(totalItemPerPage.value);
    isLoading.value = false;
  }

  getDriverData() async {
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

  // Function to update document status
  Future<void> verifyDocumentStatus(
      String userId, String documentId, String status) async {
    isLoading.value = true;

    final body = jsonEncode(
        {"user_id": userId, "document_id": documentId, "status": status});

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");
      final response =
          await http.put(Uri.parse(baseURL + verifyDocumentsEndpoint),
              headers: {
                "Content-Type": "application/json",
                "token": token ?? "",
              },
              body: body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == true) {
          ShowToast.successToast(
              data['msg'] ?? "Document status updated successfully.");
          // Handle any additional logic, like updating local state or UI if needed
          getData(); // Refresh data if required
        } else {
          ShowToast.errorToast(
              data['msg'] ?? "Failed to update document status.");
        }
      } else {
        ShowToast.errorToast(
            "Failed to update document status. Please try again.");
      }
    } catch (e) {
      ShowToast.errorToast("An error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }

  removeVerifyDocument(VerifyDriverModel verifyDriverModel) async {
    isLoading = true.obs;
    // await FirebaseFirestore.instance.collection(CollectionName.verifyDriver).doc(verifyDriverModel.driverId).delete().then((value) {
    //   ShowToastDialog.toast("Verify Document deleted...!".tr);
    // }).catchError((error) {
    //   ShowToastDialog.toast("Something went wrong".tr);
    // });
    isLoading = false.obs;
  }

  Rx<DateTimeRange> selectedDate = DateTimeRange(
          start: DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day, 0, 0, 0),
          end: DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day, 23, 59, 0))
      .obs;

  setPagination(String page) {
    totalItemPerPage.value = page;
    int itemPerPage = pageValue(page);
    totalPage.value = (verifyDriverList.length / itemPerPage).ceil();
    startIndex.value = (currentPage.value - 1) * itemPerPage;
    endIndex.value = (currentPage.value * itemPerPage) > verifyDriverList.length
        ? verifyDriverList.length
        : (currentPage.value * itemPerPage);
    if (endIndex.value < startIndex.value) {
      currentPage.value = 1;
      setPagination(page);
    } else {
      currentPageVerifyDriver.value =
          verifyDriverList.sublist(startIndex.value, endIndex.value);
    }
    isLoading.value = false;
    update();
  }

  RxString totalItemPerPage = '0'.obs;
  int pageValue(String data) {
    if (data == 'All') {
      return verifyDriverList.length;
    } else {
      return int.parse(data);
    }
  }

  // updateVerifyStatus(VerifyDocumentModel verifyDocumentModel) async {
  // var id = verifyDriverModel.value.verifyDocument!.documentId.toString();

  // int index = verifyDriverModel.value.verifyDocument!.indexWhere((element) => element.documentId == verifyDocumentModel.documentId);
  //
  // if (index != -1) {
  //   verifyDocumentList[index] = VerifyDocumentModel(
  //       documentId: verifyDocumentModel.documentId,
  //       isVerify: verifyDocumentModel.isVerify,
  //       documentImage: verifyDocumentModel.documentImage,
  //       dob: verifyDocumentModel.dob,
  //       name: verifyDocumentModel.name,
  //       number: verifyDocumentModel.number);
  //
  //   verifyDriverModel.value.verifyDocument = verifyDocumentList;
  // }
  //   bool isSaved = await FireStoreUtils.updateVerifyDocuments(verifyDriverModel.value,editingVerifyDocumentId);
  //
  //   if (isSaved) {
  //     getData();
  //     ShowToast.successToast("Status Update");
  //   }
  // }

  saveData() async {
    isLoading.value = true;
    int trueCount = 0;
    for (var element in verifyDocumentList) {
      updateVerifyStatus(element);
      if (element.isVerify == true) {
        trueCount++;
      }

      // print('list ${element.name}');
      // print('list ${element.documentId}');
    }

    driverUserDetails.update((val) {
      val!.isVerified = trueCount == verifyDocumentList.length;
      if (trueCount == verifyDocumentList.length) {
        if (driverUserDetails.value.driverVehicleDetails!.isVerified == true) {
          val.isVerified = true;
        } else {
          val.isVerified = false;
        }
      } else {
        val.isVerified = false;
      }
    });

    if (driverUserDetails.value.driverVehicleDetails!.isVerified == true) {
      trueCount++;
    }

    // await FireStoreUtils.updateDriver(driverUserDetails.value);
    isLoading.value = false;
    ShowToast.successToast("Status Update".tr);
    // print('after changes${driverUserDetails.value.driverVehicleDetails!.isVerified} ');
  }

  updateVerifyStatus(VerifyDocumentModel verifyDocumentModel) async {
    // bool isSaved = await FireStoreUtils.updateVerifyDocuments(
    //     verifyDriverModel.value, verifyDriverModel.value.driverId);

    // if (isSaved) {
    //   getData();
    // }
  }

  getDriverDetails(driverId) async {
    isLoadingVehicleDetails = true.obs;
    // await FireStoreUtils.getDriverByDriverID(driverId.toString()).then((value) {
    //   if (value != null) {
    //     DriverUserModel driverUserModel = value;
    //     driverUserDetails.value = driverUserModel;

    //     driverUserModel.isVerified = verifyDocumentList
    //             .where((element) => element.isVerify == false)
    //             .isEmpty
    //         ? true
    //         : false;
    //     // FireStoreUtils.updateDriver(driverUserModel!);
    //   }
    // });
    isLoadingVehicleDetails(false);
  }
}
