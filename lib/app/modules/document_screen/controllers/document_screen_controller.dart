import 'dart:convert';

import 'package:admin/app/constant/show_toast.dart';
import 'package:admin/app/models/documents_model.dart';
import 'package:admin/app/modules/document_screen/views/document_screen_view.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';

import '../../../constant/api_constant.dart';

class DocumentScreenController extends GetxController {
  RxString title = "Document".tr.obs;

  Rx<TextEditingController> documentNameController =
      TextEditingController().obs;
  Rx<SideAt> documentSide = SideAt.isOneSide.obs;
  RxBool isEditing = false.obs;
  RxBool isLoading = false.obs;
  RxBool isActive = false.obs;
  Rx<String> editingId = "".obs;
  RxList<DocumentsModel> documentsList = <DocumentsModel>[].obs;

  @override
  Future<void> onInit() async {
    // await getData();
    await getDocumentsAPI();
    super.onInit();
  }

  getDocumentsAPI() async {
    isLoading(true);
    documentsList.clear();
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");

      log('token------${token}');
      final response = await http.get(
        Uri.parse(baseURL + documentListEndpoint),
        headers: {
          'token': token.toString(),
        },
      );

      if (response.statusCode == 200) {
        // log('----document list fetched----${response.body}');

        // Parse JSON response
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        // Check if 'data' exists and is a list
        if (jsonResponse['data'] is List) {
          List<dynamic> data = jsonResponse['data'];

          // Map each item in 'data' to a DocumentsModel
          documentsList.addAll(
            data.map((json) => DocumentsModel.fromJson(json)).toList(),
          );

          ShowToastDialog.toast("Documents fetched successfully!".tr);
        } else {
          log("Data field is not a list or is missing.");
          ShowToastDialog.toast("Invalid response format.".tr);
        }
      } else {
        log("----------Failed to fetch documents---${response.body}");
        ShowToastDialog.toast("Failed to fetch documents: ${response.body}".tr);
      }
    } catch (error) {
      log("Error fetching documents: $error");
      ShowToastDialog.toast("An error occurred: $error".tr);
    } finally {
      isLoading(false);
    }
  }

  getData() async {
    isLoading(true);
    documentsList.clear();
    getDocumentsAPI();
    // List<DocumentsModel> data = await FireStoreUtils.getDocument();
    // documentsList.addAll(data);
    isLoading(false);
  }

  // Function to add a Documnets
  Future<void> addDocumentsAPI(String text) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");

      log('token------${token}');
      final response = await http.post(
        Uri.parse(baseURL + addDocumentEndpoint),
        headers: {
          'token': token.toString(),
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "name": text,
          "side": documentSide.value == SideAt.isTwoSide ? true : false,
        }),
      );

      if (response.statusCode == 200) {
        log('----add--docs----${response.body}');
        ShowToastDialog.toast("Documents added successfully!".tr);
      } else {
        log("----------Failed to add Documents---${response.body}");
        ShowToastDialog.toast("Failed to add Documents: ${response.body}".tr);
      }
    } catch (error) {
      log("Error adding Documents: $error");
      ShowToastDialog.toast("An error occurred: $error".tr);
    }
  }

  setDefaultData() {
    documentNameController.value.text = "";
    editingId.value = "";
    documentSide = SideAt.isOneSide.obs;
    isActive.value = false;
    isEditing.value = false;
  }

  updateDocument() async {
    isEditing = true.obs;
    // await FireStoreUtils.addDocument(DocumentsModel(
    //     id: editingId.value,
    //     isEnable: isActive.value,
    //     isTwoSide: documentSide.value == SideAt.isTwoSide ? true : false,
    //     title: documentNameController.value.text));
    await getData();
    isEditing = false.obs;
  }

  addDocument() async {
    isLoading = true.obs;
    // await FireStoreUtils.addDocument(DocumentsModel(
    //     id: Constant.getRandomString(20),
    //     isEnable: isActive.value,
    //     isTwoSide: documentSide.value == SideAt.isTwoSide ? true : false,
    //     title: documentNameController.value.text));
    await getData();
    isLoading = false.obs;
  }

  removeDocument(DocumentsModel documentsModel) async {
    isLoading = true.obs;

    // await FirebaseFirestore.instance.collection(CollectionName.documents).doc(documentsModel.id).delete().then((value) {
    //   ShowToastDialog.toast("Document deleted...!".tr);
    // }).catchError((error) {
    //   ShowToastDialog.toast("Something went wrong".tr);
    // });
    await getData();
    isLoading = false.obs;
  }
}
