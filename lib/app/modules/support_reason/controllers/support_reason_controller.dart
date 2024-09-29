import 'package:admin/app/constant/collection_name.dart';
import 'package:admin/app/constant/constants.dart';
import 'package:admin/app/constant/show_toast.dart';
import 'package:admin/app/models/support_reason_model.dart';
import 'package:admin/app/utils/fire_store_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SupportReasonController extends GetxController {
  RxString title = "Support Reason".tr.obs;
  Rx<TextEditingController> supportReasonController =
      TextEditingController().obs;
  Rx<SupportReasonModel> supportReasonModel = SupportReasonModel().obs;
  RxList<SupportReasonModel> supportReasonList = <SupportReasonModel>[].obs;

  RxBool isEditing = false.obs;
  RxBool isLoading = false.obs;

  List<String> type = ["customer", "driver"];
  RxString selectedType = "customer".obs;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  getData() async {
    isLoading(true);
    supportReasonList.clear();
    List<SupportReasonModel>? data = await FireStoreUtils.getSupportReason();
    supportReasonList.addAll(data!);
    isLoading(false);
  }

  setDefaultData() {
    selectedType = "customer".obs;
    supportReasonController.value.text = "";
    isEditing = false.obs;
    isLoading = false.obs;
  }

  addSupportReason() async {
    isLoading.value = true;
    supportReasonModel.value.id = Constant.getRandomString(20);
    supportReasonModel.value.reason = supportReasonController.value.text;
    supportReasonModel.value.type = selectedType.value;
    await FireStoreUtils.addSupportReason(supportReasonModel.value);
    await getData();
    isLoading = false.obs;
  }

  updateSupportReason() async {
    supportReasonModel.value.reason = supportReasonController.value.text;
    supportReasonModel.value.type = selectedType.value;
    await FireStoreUtils.updateSupportReason(supportReasonModel.value);
    await getData();
  }

  removeSupportReason(SupportReasonModel supportReasonModel) async {
    isLoading.value = true;
    await FirebaseFirestore.instance
        .collection(CollectionName.supportReason)
        .doc(supportReasonModel.id)
        .delete()
        .then((value) {
      ShowToastDialog.toast("Support Reason Deleted..".tr);
    }).catchError((error) {
      ShowToastDialog.toast("Something went wrong".tr);
    });
    isLoading.value = false;
  }
}
