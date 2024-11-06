import 'dart:convert';

import 'package:admin/app/constant/api_constant.dart';
import 'package:admin/app/constant/booking_status.dart';
import 'package:admin/app/constant/constants.dart';
import 'package:admin/app/models/admin_model.dart';
import 'package:admin/app/models/booking_model.dart';
import 'package:admin/app/models/language_model.dart';
import 'package:admin/app/models/user_model.dart';
import 'package:admin/app/models/vehicle_type_model.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http; // For making HTTP requests
import 'package:nb_utils/nb_utils.dart';

import '../../../constant/show_toast.dart';
import '../../../models/driver_user_model.dart';
import '../../../models/passenger_model.dart';

class DashboardScreenController extends GetxController {
  GlobalKey<ScaffoldState> scaffoldKeyDrawer = GlobalKey<ScaffoldState>();
  RxBool isDrawerOpen = false.obs;

  void toggleDrawer() {
    GlobalKey<ScaffoldState> scaffoldKey = scaffoldKeyDrawer;
    scaffoldKey.currentState?.openDrawer();
  }

  RxBool isLoading = true.obs;
  RxBool isUserData = true.obs;

  RxInt totalBookingPlaced = 0.obs;
  RxInt totalBookingActive = 0.obs;
  RxInt totalBookingCompleted = 0.obs;

  RxInt totalBookingCanceled = 0.obs;

  RxInt totalBookings = 0.obs;
  RxInt totalCab = 0.obs;
  RxDouble totalEarnings = 0.0.obs;

  RxDouble todayTotalEarnings = 0.0.obs;
  RxDouble monthlyEarning = 0.0.obs;

  RxList<LanguageModel> languageList = <LanguageModel>[].obs;
  Rx<LanguageModel> selectedLanguage = LanguageModel().obs;
  Rx<TextEditingController> searchController = TextEditingController().obs;
  Rx<AdminModel> admin = AdminModel().obs;

  RxList<VehicleTypeModel> vehicleTypeList = <VehicleTypeModel>[].obs;
  List<ChartData>? bookingChartData;
  List<ChartData>? usersChartData;
  List<ChartDataCircle>? usersCircleChartData;
  var monthlyUserCount = List<int>.filled(12, 0).obs;

  RxBool isLoadingBookingChart = true.obs;
  RxBool isLoadingUserChart = true.obs;
  RxList<UserModel> userList = <UserModel>[].obs;
  RxList<BookingModel> bookingList = <BookingModel>[].obs;
  RxList<BookingModel> recentBookingList = <BookingModel>[].obs;
  RxList<PassengerModel> passengersList = <PassengerModel>[].obs;
  RxList<DriverUserModel> driverList = <DriverUserModel>[].obs;
  List<ChartDataCircle> chartDataCircle = [];
  List<SalesStatistic> salesStatistic = [];
  RxInt todayService = 0.obs;
  RxInt totalService = 0.obs;
  RxInt totalUser = 0.obs;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  getData() async {
    isUserData = true.obs;
    Constant.getAdminData();
    getProfile();
    Constant.getCurrencyData();
    // Constant.getLanguageData();
    // bookingList.value = await FireStoreUtils.getRecentBooking("All");
    await fetchPassengers();
    getDriverData();
    await getAllStatisticData();
    await getTodayStatisticData();

    // await getLanguage();
    recentBookingList.value = bookingList.sublist(0, 5);
    // userList.value = await FireStoreUtils.getRecentUsers();
    // totalCab.value = await FireStoreUtils.countDrivers();
    // totalUser.value = await FireStoreUtils.countUsers();
    bookingChartData = List.filled(12, ChartData("", 0));
    usersChartData = List.filled(12, ChartData("", 0));
    usersCircleChartData =
        List.filled(12, ChartDataCircle("", 0, Colors.amber));
    late RxList<ChartDataCircle> chartData;
    getBookingData();
    isUserData = false.obs;
    chartData = <ChartDataCircle>[].obs;
  }

  Future<void> fetchPassengers() async {
    isLoading.value = true;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    if (token == null) {
      ShowToastDialog.toast("Authentication token missing.");
      isLoading.value = false;
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(baseURL + customerListEndpoint),
        headers: {
          "Content-Type": "application/json",
          "token": token,
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData["status"] == true) {
          List<dynamic> data = responseData["data"];
          passengersList.clear();
          passengersList.addAll(
              data.map((json) => PassengerModel.fromJson(json)).toList());

          // Set totalUser equal to the length of passengersList
          totalUser.value = passengersList.length;

          log("Passengers data fetched: ${passengersList.length}");
        } else {
          ShowToastDialog.toast(
              "Failed to fetch passengers: ${responseData["msg"]}");
        }
      } else {
        ShowToastDialog.toast("Error: Status code ${response.statusCode}");
      }
    } catch (e) {
      log("Error fetching passengers: $e");
      ShowToastDialog.toast("An error occurred while fetching passengers.");
    } finally {
      isLoading.value = false;
    }
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

          totalCab.value = passengersList.length;
          log("Driver data fetched: ${driverList.length}");
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

  Future<String?> getTokenFromLocalStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token'); // Returns the saved token
  }

  // Function to store profile data in SharedPreferences
  Future<void> saveProfileData(Map<String, dynamic> profileData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Save each field or save the whole map as a JSON string
    String profileJson = jsonEncode(profileData);
    await prefs.setString('profile_data', profileJson);

    log('Profile data saved locally.');
  }

// Function to fetch profile data
  Future<void> getProfile() async {
    final String url = baseURL + previewProfileEndpoint;

    try {
      String? token = await getTokenFromLocalStorage();

      // Send GET request with the token in headers
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "token": token!,
        },
      );

      // Log the status code for debugging
      // log('Response status: ${response.statusCode}');
      //
      // // Log the full response body for debugging
      // log('Response body: ${response.body}');

      // Check if the response status code is 200 (OK)
      if (response.statusCode == 200) {
        // Parse the response body
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        // Check if the status is true
        if (responseData['status'] == true) {
          // Extract profile data
          final Map<String, dynamic> profileData = responseData['data'];
// Store profile data locally
          await saveProfileData(profileData);

          // log('Profile data stored locally.');
          // // Log profile information for debugging
          // log('Profile name: ${profileData['name']}');
          // log('Profile email: ${profileData['email']}');
          // log('Profile phone: ${profileData['phone']}');
          // log('Profile role: ${profileData['role']}');
          // You can access other fields from profileData here
        } else {
          log('Failed to fetch profile: ${responseData['msg']}');
        }
      } else {
        // Handle non-200 responses
        log('Failed to fetch profile. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Log any errors
      log('Error fetching profile: $e');
    }
  }

  // tempMethod() async {
  //   List<DriverUserModel> tempuserList = [];
  //
  //   await FireStoreUtils.fireStore.collection(CollectionName.drivers).get().then(
  //     (value) {
  //       for (var element in value.docs) {
  //         DriverUserModel userModel = DriverUserModel.fromJson(element.data());
  //         tempuserList.add(userModel);
  //       }
  //     },
  //   );
  //   tempuserList.forEach(
  //     (element) {
  //       DriverUserModel userModel = element;
  //       userModel.slug = userModel.fullName.toSlug(delimiter: "-");
  //       FireStoreUtils.updateDriver(userModel);
  //     },
  //   );
  // }

  getTodayStatisticData() async {
    for (var booking in bookingList) {
      // if (Constant.timestampToDate(booking.createAt!) ==
      //     Constant.timestampToDate(Timestamp.now())) {
      //   if (booking.bookingStatus == BookingStatus.bookingCompleted) {
      //     todayTotalEarnings.value += Constant.calculateFinalAmount(booking);
      //   }
      // }
    }
  }

  getAllStatisticData() async {
    totalBookings.value = bookingList.length;
    totalService.value = bookingList
        .where((element) =>
            element.bookingStatus == BookingStatus.bookingCompleted)
        .length;
    totalBookingPlaced.value = bookingList
        .where(
            (element) => element.bookingStatus == BookingStatus.bookingPlaced)
        .length;
    totalBookingActive.value = bookingList
        .where((element) =>
            element.bookingStatus == BookingStatus.bookingAccepted ||
            element.bookingStatus == BookingStatus.bookingOngoing ||
            element.bookingStatus == BookingStatus.bookingCompleted ||
            element.bookingStatus == BookingStatus.bookingCancelled ||
            element.bookingStatus == BookingStatus.bookingPlaced)
        .length;
    totalBookingCompleted.value = bookingList
        .where((element) =>
            element.bookingStatus == BookingStatus.bookingCompleted)
        .length;
    totalBookingCanceled.value = bookingList
        .where((element) =>
            element.bookingStatus == BookingStatus.bookingCancelled)
        .length;

    for (var booking in bookingList) {
      if (booking.bookingStatus == BookingStatus.bookingCompleted) {
        totalEarnings.value += Constant.calculateFinalAmount(booking);
      }
    }
    salesStatistic = [
      SalesStatistic("Total Earning", totalEarnings.value, Colors.green),
    ];

    chartDataCircle = [
      ChartDataCircle('Total Service', totalService.value, Colors.blue),
      ChartDataCircle('Total Booking', totalBookings.value, Colors.purple),
      ChartDataCircle('Total Users', totalCab.value, Colors.green),
      ChartDataCircle(
          'Booking Placed', totalBookingPlaced.value, Colors.yellow),
      ChartDataCircle('Booking Active', totalBookingActive.value, Colors.brown),
      ChartDataCircle(
          'Booking Completed', totalBookingCompleted.value, Colors.deepOrange),
      ChartDataCircle(
          'Booking Canceled', totalBookingCanceled.value, Colors.red),
    ];
  }

  getBookingData() async {
    List<Future<void>> monthDataFutures = [
      getBookingMonthWiseData("01", 0, "JAN"),
      getBookingMonthWiseData("02", 1, "FEB"),
      getBookingMonthWiseData("03", 2, "MAR"),
      getBookingMonthWiseData("04", 3, "APR"),
      getBookingMonthWiseData("05", 4, "MAY"),
      getBookingMonthWiseData("06", 5, "JUN"),
      getBookingMonthWiseData("07", 6, "JUL"),
      getBookingMonthWiseData("08", 7, "AUG"),
      getBookingMonthWiseData("09", 8, "SEP"),
      getBookingMonthWiseData("10", 9, "OCT"),
      getBookingMonthWiseData("11", 10, "NOV"),
      getBookingMonthWiseData("12", 11, "DEC"),
    ];

    await Future.wait(monthDataFutures);
    isLoadingBookingChart.value = false;
  }

  getBookingMonthWiseData(
      String monthValue, int index, String monthName) async {
    int month = int.parse(monthValue);
    DateTime firstDayOfMonth = DateTime(DateTime.now().year, month, 1);
    DateTime lastDayOfMonth =
        DateTime(DateTime.now().year, month + 1, 0, 23, 59, 59);

    List<BookingModel> bookingHistory = [];

    try {
      // QuerySnapshot value = await FirebaseFirestore.instance
      //     .collection(CollectionName.bookings)
      //     .where("createAt",
      //         isGreaterThanOrEqualTo: firstDayOfMonth,
      //         isLessThanOrEqualTo: lastDayOfMonth)
      //     .where("bookingStatus", isEqualTo: "booking_completed")
      //     .get();

      // for (var element in value.docs) {
      //   Map<String, dynamic>? elementData =
      //       element.data() as Map<String, dynamic>?;
      //   // bookingChartData
      //   if (elementData != null) {
      //     BookingModel orderHistoryModel = BookingModel.fromJson(elementData);
      //     bookingHistory.add(orderHistoryModel);
      //   }
      // }
      // monthlyEarning.value = 0.0;
      // for (var monthSubtotal in bookingHistory) {
      //   monthlyEarning.value += double.parse(monthSubtotal.subTotal.toString());
      // }

      bookingChartData![index] = ChartData(monthName, monthlyEarning.value);
    } catch (e) {
      print('Error getting month-wise data: $e');
    }
  }

  // getLanguage() async {
  //   isLoading = true.obs;
  //   admin.value = Constant.adminModel!;
  //   await FireStoreUtils.getLanguage().then((value) {
  //     languageList.value = value;
  //     for (var element in languageList) {
  //       if (element.code == "en") {
  //         selectedLanguage.value = element;
  //         continue;
  //       } else {
  //         selectedLanguage.value = languageList.first;
  //       }
  //     }
  //   }).catchError((error) {
  //     log('error in getLanguage type ${error.toString()}');
  //   });

  //   isLoading = false.obs;
  // }
}

class ChartData {
  ChartData(this.x, this.y);

  final String x;
  final double y;
}

class ChartDataCircle {
  ChartDataCircle(this.x, this.y, [this.color]);

  final String x;
  final int y;
  final Color? color;
}

class SalesStatistic {
  SalesStatistic(this.x, this.y, [this.color]);

  final String x;
  final double y;
  final Color? color;
}
