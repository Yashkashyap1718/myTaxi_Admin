import 'dart:convert';

import 'package:admin/app/constant/api_constant.dart';
import 'package:admin/app/constant/constants.dart';
// import 'package:admin/app/models/user_model.dart';
import 'package:admin/app/routes/app_pages.dart';
import 'package:admin/app/services/shared_preferences/app_preference.dart';
import 'package:admin/app/utils/toast.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';

import '../../../constant/show_toast.dart';

class LoginPageController extends GetxController {
  var isPasswordVisible = true.obs;
  TextEditingController emailController = TextEditingController();
  TextEditingController myemailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController mypasswordController = TextEditingController();

  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  RxString email = "".obs;
  RxString password = "".obs;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  getData() async {
    await Constant.getAdminData();
    await Constant.getCurrencyData();
    // await Constant.getLanguageData();
    email.value = await AppSharedPreference.appSharedPreference.getEmail();
    password.value =
        await AppSharedPreference.appSharedPreference.getPassword();
    if (email.value.isEmpty) {
      // final DocumentReference document = FirebaseFirestore.instance
      //     .collection(CollectionName.admin)
      //     .doc("admin");
      // document.snapshots().listen((snapshot) async {
      //   Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
      //   if (data != null) {
      //     email.value = data["email"];
      //     password.value = data["password"];
      //   }

      log('-------credentials------${email.value}-----${password.value}');
      // });
    }
  }

  void checkLogin() async {
    if (email.value == emailController.text &&
        password.value == passwordController.text) {
      await AppSharedPreference.appSharedPreference.saveIsUserLoggedIn();
      // Get.offNamed(Routes.HOME);
      Get.offAllNamed(Routes.DASHBOARD_SCREEN);
    } else {
      if (email.value != emailController.text) {
        ShowToast.errorToast("Please enter a valid email!".tr);
      }
      if (password.value != passwordController.text) {
        ShowToast.errorToast("Please enter a valid password!".tr);
      }
    }
  }

  Future<void> loginwithEmail(BuildContext context) async {
    final Map<String, String> payload = {
      "email": emailController.text,
      "password": passwordController.text,
    };

    try {
      // ShowToastDialog.showLoader("Please wait".tr);
      final response = await http.post(
        Uri.parse(baseURL + loginEndpoint),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(payload),
      );
      // print('---pay--$payload');
      //
      // log('Response Body: ${response.body}');

      log(response.body); // Log the response body for debugging
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      if (responseData['status'] == true) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", responseData['token']);
        log('Token saved: ${responseData['token']}');
        await AppSharedPreference.appSharedPreference.saveIsUserLoggedIn();

        Get.offAllNamed(Routes.DASHBOARD_SCREEN);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseData['msg']),
          ),
        );
        ShowToastDialog.closeLoader();
      } else {
        // Handle unsuccessful response
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to login: ${responseData['msg']}'),
          ),
        );
      }
    } catch (e) {
      log('Error: $e'); // Log any errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error occurred while sending request. $e'),
        ),
      );

      print(e);
    }
  }
}
