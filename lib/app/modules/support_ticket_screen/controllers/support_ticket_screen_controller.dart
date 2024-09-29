import 'package:admin/app/constant/constants.dart';
import 'package:admin/app/models/support_ticket_model.dart';
import 'package:admin/app/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SupportTicketScreenController extends GetxController {
  RxBool isLoading = true.obs;
  RxString title = "Support Ticket".tr.obs;

  RxList<SupportTicketModel> supportTicketList = <SupportTicketModel>[].obs;
  RxList<SupportTicketModel> currentPageSupportTicketList = <SupportTicketModel>[].obs;

  Rx<TextEditingController> notesController = TextEditingController().obs;

  var currentPage = 1.obs;
  var startIndex = 1.obs;
  var endIndex = 1.obs;
  var totalPage = 1.obs;

  @override
  void onInit() {
    totalItemPerPage.value = Constant.numOfPageIemList.first;
    getData();
    super.onInit();
  }

  getData() async {
    isLoading(true);
    supportTicketList.value = (await FireStoreUtils.getSupportTicket())!;
    // supportTicketList.clear();
    // List<SupportTicketModel>? data = await FireStoreUtils.getSupportTicket();
    // supportTicketList.addAll(data!);
    setPagination(totalItemPerPage.value);
    isLoading(false);
  }

  setPagination(String page) {
    totalItemPerPage.value = page;
    int itemPerPage = pageValue(page);
    totalPage.value = (supportTicketList.length / itemPerPage).ceil();
    startIndex.value = (currentPage.value - 1) * itemPerPage;
    endIndex.value =
        (currentPage.value * itemPerPage) > supportTicketList.length ? supportTicketList.length : (currentPage.value * itemPerPage);
    if (endIndex.value < startIndex.value) {
      currentPage.value = 1;
      setPagination(page);
    } else {
      currentPageSupportTicketList.value = supportTicketList.sublist(startIndex.value, endIndex.value);
    }
    isLoading.value = false;
    update();
  }

  RxString totalItemPerPage = '0'.obs;

  int pageValue(String data) {
    if (data == 'All') {
      return supportTicketList.length;
    } else {
      return int.parse(data);
    }
  }
}
