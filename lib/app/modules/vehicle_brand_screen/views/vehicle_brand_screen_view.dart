// ignore_for_file: deprecated_member_use

import 'dart:html' as html;

import 'package:admin/app/components/custom_button.dart';
import 'package:admin/app/components/custom_text_form_field.dart';
import 'package:admin/app/components/dialog_box.dart';
import 'package:admin/app/components/menu_widget.dart';
import 'package:admin/app/constant/constants.dart';
import 'package:admin/app/constant/show_toast.dart';
import 'package:admin/app/utils/app_colors.dart';
import 'package:admin/app/utils/app_them_data.dart';
import 'package:admin/app/utils/dark_theme_provider.dart';
import 'package:admin/app/utils/responsive.dart';
import 'package:admin/widget/common_ui.dart';
import 'package:admin/widget/container_custom.dart';
import 'package:admin/widget/global_widgets.dart';
import 'package:admin/widget/text_widget.dart';
import 'package:admin/widget/web_pagination.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../../../components/network_image_widget.dart';
import '../../../constant/api_constant.dart';
import '../../../routes/app_pages.dart';
import '../controllers/vehicle_brand_screen_controller.dart';

class VehicleBrandScreenView extends GetView<VehicleBrandScreenController> {
  const VehicleBrandScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<VehicleBrandScreenController>(
      init: VehicleBrandScreenController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: themeChange.isDarkTheme()
              ? AppThemData.greyShade950
              : AppThemData.greyShade50,
          appBar: AppBar(
            elevation: 0.0,
            toolbarHeight: 70,
            automaticallyImplyLeading: false,
            backgroundColor: themeChange.isDarkTheme()
                ? AppThemData.primaryBlack
                : AppThemData.primaryWhite,
            leadingWidth: 200,
            leading: Builder(
              builder: (BuildContext context) {
                return GestureDetector(
                  onTap: () {
                    if (!ResponsiveWidget.isDesktop(context)) {
                      Scaffold.of(context).openDrawer();
                    }
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: !ResponsiveWidget.isDesktop(context)
                        ? Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Icon(
                              Icons.menu,
                              size: 30,
                              color: themeChange.isDarkTheme()
                                  ? AppThemData.primary500
                                  : AppThemData.primary500,
                            ),
                          )
                        : SizedBox(
                            height: 45,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/image/logo.png",
                                  height: 45,
                                  color: AppThemData.primary500,
                                ),
                                spaceW(),
                                const TextCustom(
                                  title: 'My Taxi',
                                  color: AppThemData.primary500,
                                  fontSize: 30,
                                  fontFamily: AppThemeData.semiBold,
                                  fontWeight: FontWeight.w700,
                                )
                              ],
                            ),
                          ),
                  ),
                );
              },
            ),
            actions: [
              GestureDetector(
                onTap: () {
                  if (themeChange.darkTheme == 1) {
                    themeChange.darkTheme = 0;
                  } else if (themeChange.darkTheme == 0) {
                    themeChange.darkTheme = 1;
                  } else if (themeChange.darkTheme == 2) {
                    themeChange.darkTheme = 0;
                  } else {
                    themeChange.darkTheme = 2;
                  }
                },
                child: themeChange.isDarkTheme()
                    ? SvgPicture.asset(
                        "assets/icons/ic_sun.svg",
                        color: AppThemData.yellow600,
                        height: 20,
                        width: 20,
                      )
                    : SvgPicture.asset(
                        "assets/icons/ic_moon.svg",
                        color: AppThemData.blue400,
                        height: 20,
                        width: 20,
                      ),
              ),
              spaceW(),
              const LanguagePopUp(),
              spaceW(),
              ProfilePopUp()
            ],
          ),
          drawer: Drawer(
            // key: scaffoldKey,
            width: 270,
            backgroundColor: themeChange.isDarkTheme()
                ? AppThemData.primaryBlack
                : AppThemData.primaryWhite,
            child: const MenuWidget(),
          ),
          body: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (ResponsiveWidget.isDesktop(context)) ...{const MenuWidget()},
              Expanded(
                child: Padding(
                    padding: paddingEdgeInsets(),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ContainerCustom(
                              child: Column(children: [
                                ResponsiveWidget.isDesktop(context)
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                TextCustom(
                                                    title:
                                                        controller.title.value,
                                                    fontSize: 20,
                                                    fontFamily:
                                                        AppThemeData.bold),
                                                spaceH(height: 2),
                                                Row(children: [
                                                  GestureDetector(
                                                      onTap: () =>
                                                          Get.offAllNamed(Routes
                                                              .DASHBOARD_SCREEN),
                                                      child: TextCustom(
                                                          title: 'Dashboard'.tr,
                                                          fontSize: 14,
                                                          fontFamily:
                                                              AppThemeData
                                                                  .medium,
                                                          color: AppThemData
                                                              .greyShade500)),
                                                  const TextCustom(
                                                      title: ' / ',
                                                      fontSize: 14,
                                                      fontFamily:
                                                          AppThemeData.medium,
                                                      color: AppThemData
                                                          .greyShade500),
                                                  TextCustom(
                                                      title:
                                                          ' ${controller.title.value} ',
                                                      fontSize: 14,
                                                      fontFamily:
                                                          AppThemeData.medium,
                                                      color: AppThemData
                                                          .primary500)
                                                ])
                                              ]),
                                          Row(
                                            children: [
                                              NumberOfRowsDropDown(
                                                controller: controller,
                                              ),
                                              spaceW(),
                                              CustomButtonWidget(
                                                borderRadius: 10,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 22),
                                                buttonTitle: "+ Add Brand".tr,
                                                onPress: () {
                                                  controller.setDefaultData();
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          const CustomDialog());
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                TextCustom(
                                                    title:
                                                        controller.title.value,
                                                    fontSize: 20,
                                                    fontFamily:
                                                        AppThemeData.bold),
                                                spaceH(height: 2),
                                                Row(children: [
                                                  GestureDetector(
                                                      onTap: () =>
                                                          Get.offAllNamed(Routes
                                                              .DASHBOARD_SCREEN),
                                                      child: TextCustom(
                                                          title: 'Dashboard'.tr,
                                                          fontSize: 14,
                                                          fontFamily:
                                                              AppThemeData
                                                                  .medium,
                                                          color: AppThemData
                                                              .greyShade500)),
                                                  const TextCustom(
                                                      title: ' / ',
                                                      fontSize: 14,
                                                      fontFamily:
                                                          AppThemeData.medium,
                                                      color: AppThemData
                                                          .greyShade500),
                                                  TextCustom(
                                                      title:
                                                          ' ${controller.title.value} ',
                                                      fontSize: 14,
                                                      fontFamily:
                                                          AppThemeData.medium,
                                                      color: AppThemData
                                                          .primary500)
                                                ])
                                              ]),
                                          spaceH(),
                                          CustomButtonWidget(
                                            width: MediaQuery.sizeOf(context)
                                                    .width *
                                                0.7,
                                            borderRadius: 10,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 22),
                                            buttonTitle: "+ Add Brand".tr,
                                            onPress: () {
                                              controller.setDefaultData();
                                              showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      const CustomDialog());
                                            },
                                          ),
                                          spaceH(),
                                          NumberOfRowsDropDown(
                                            controller: controller,
                                          ),
                                        ],
                                      ),
                                spaceH(height: 20),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: controller.isLoading.value
                                        ? Padding(
                                            padding: paddingEdgeInsets(),
                                            child: Constant.loader(),
                                          )
                                        : controller.brandList.isEmpty
                                            ? TextCustom(
                                                title: "No Data available".tr)
                                            : DataTable(
                                                horizontalMargin: 20,
                                                columnSpacing: 30,
                                                dataRowMaxHeight: 65,
                                                headingRowHeight: 65,
                                                border: TableBorder.all(
                                                  color: themeChange
                                                          .isDarkTheme()
                                                      ? AppThemData.greyShade900
                                                      : AppThemData
                                                          .greyShade100,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                headingRowColor:
                                                    MaterialStateColor.resolveWith(
                                                        (states) => themeChange
                                                                .isDarkTheme()
                                                            ? AppThemData
                                                                .greyShade900
                                                            : AppThemData
                                                                .greyShade100),
                                                columns: [
                                                  CommonUI.dataColumnWidget(
                                                      context,
                                                      columnTitle:
                                                          "Profile Image".tr,
                                                      width: ResponsiveWidget
                                                              .isMobile(context)
                                                          ? 150
                                                          : MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.28),
                                                  CommonUI.dataColumnWidget(
                                                      context,
                                                      columnTitle: "Id".tr,
                                                      width: ResponsiveWidget
                                                              .isMobile(context)
                                                          ? 150
                                                          : MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.28),
                                                  CommonUI.dataColumnWidget(
                                                      context,
                                                      columnTitle: "Title".tr,
                                                      width: ResponsiveWidget
                                                              .isMobile(context)
                                                          ? 150
                                                          : MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.28),
                                                  CommonUI.dataColumnWidget(
                                                      context,
                                                      columnTitle: "Status".tr,
                                                      width: ResponsiveWidget
                                                              .isMobile(context)
                                                          ? 110
                                                          : MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.28),
                                                  CommonUI.dataColumnWidget(
                                                      context,
                                                      columnTitle: "Actions".tr,
                                                      width: ResponsiveWidget
                                                              .isMobile(context)
                                                          ? 80
                                                          : MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.16),
                                                ],
                                                rows: controller.brandList
                                                    .map((vehicleBrandModel) {
                                                  log("Vehicle Brand Model: $vehicleBrandModel"); // Log the model data
                                                  return DataRow(cells: [
                                                    DataCell(
                                                      Container(
                                                        alignment:
                                                            Alignment.center,
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 8,
                                                                vertical: 8),
                                                        child:
                                                            NetworkImageWidget(
                                                          imageUrl:
                                                              "$imageURL${vehicleBrandModel.image}",
                                                          borderRadius: 10,
                                                          fit: BoxFit.contain,
                                                          height: 40,
                                                          width: 100,
                                                        ),
                                                      ),
                                                    ),
                                                    DataCell(Text(
                                                      "${vehicleBrandModel.id}",
                                                      style: TextStyle(
                                                        color: MaterialStateColor.resolveWith(
                                                            (states) => themeChange
                                                                    .isDarkTheme()
                                                                ? AppThemData
                                                                    .greyShade100
                                                                : AppThemData
                                                                    .black09),
                                                      ),
                                                    )),
                                                    DataCell(Text(
                                                      "${vehicleBrandModel.title}",
                                                      style: TextStyle(
                                                        color: MaterialStateColor.resolveWith(
                                                            (states) => themeChange
                                                                    .isDarkTheme()
                                                                ? AppThemData
                                                                    .greyShade100
                                                                : AppThemData
                                                                    .black09),
                                                      ),
                                                    )),
                                                    DataCell(Text(
                                                      "${vehicleBrandModel.isEnable}",
                                                      style: TextStyle(
                                                        color: MaterialStateColor.resolveWith(
                                                            (states) => themeChange
                                                                    .isDarkTheme()
                                                                ? AppThemData
                                                                    .greyShade100
                                                                : AppThemData
                                                                    .black09),
                                                      ),
                                                    )),
                                                    DataCell(
                                                      Container(
                                                        alignment:
                                                            Alignment.center,
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 8,
                                                                vertical: 8),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            // Edit Button
                                                            InkWell(
                                                              onTap: () {
                                                                controller
                                                                    .isEditing
                                                                    .value = true;
                                                                controller
                                                                        .vehicleBrandModel
                                                                        .value
                                                                        .id =
                                                                    vehicleBrandModel
                                                                        .id;
                                                                controller
                                                                        .titleController
                                                                        .value
                                                                        .text =
                                                                    vehicleBrandModel
                                                                        .title!;
                                                                controller
                                                                        .isEnable
                                                                        .value =
                                                                    vehicleBrandModel
                                                                        .isEnable!;
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) =>
                                                                            const CustomDialog());
                                                              },
                                                              child: SvgPicture
                                                                  .asset(
                                                                "assets/icons/ic_edit.svg",
                                                                color: AppThemData
                                                                    .greyShade400,
                                                                height: 16,
                                                                width: 16,
                                                              ),
                                                            ),
                                                            spaceW(width: 20),
                                                            // Delete Button
                                                            InkWell(
                                                              onTap: () async {
                                                                bool
                                                                    confirmDelete =
                                                                    await DialogBox
                                                                        .showConfirmationDeleteDialog(
                                                                            context);
                                                                if (confirmDelete) {
                                                                  await controller
                                                                      .removeBrand(
                                                                          vehicleBrandModel);
                                                                  controller
                                                                      .getBrand();
                                                                }
                                                              },
                                                              child: SvgPicture
                                                                  .asset(
                                                                "assets/icons/ic_delete.svg",
                                                                color: AppThemData
                                                                    .greyShade400,
                                                                height: 16,
                                                                width: 16,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ]);
                                                }).toList(),
                                              ),
                                  ),
                                ),
                                spaceH(),
                                ResponsiveWidget.isMobile(context)
                                    ? SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Visibility(
                                          visible:
                                              controller.totalPage.value > 1,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: WebPagination(
                                                    currentPage: controller
                                                        .currentPage.value,
                                                    totalPage: controller
                                                        .totalPage.value,
                                                    displayItemCount: controller
                                                        .pageValue("5"),
                                                    onPageChanged: (page) {
                                                      controller.currentPage
                                                          .value = page;
                                                      controller.setPagination(
                                                          controller
                                                              .totalItemPerPage
                                                              .value);
                                                    }),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : Visibility(
                                        visible: controller.totalPage.value > 1,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: WebPagination(
                                                  currentPage: controller
                                                      .currentPage.value,
                                                  totalPage: controller
                                                      .totalPage.value,
                                                  displayItemCount:
                                                      controller.pageValue("5"),
                                                  onPageChanged: (page) {
                                                    controller.currentPage
                                                        .value = page;
                                                    controller.setPagination(
                                                        controller
                                                            .totalItemPerPage
                                                            .value);
                                                  }),
                                            ),
                                          ],
                                        ),
                                      ),
                              ]),
                            )
                          ]),
                    )),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CustomDialog extends StatelessWidget {
  const CustomDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: VehicleBrandScreenController(),
        builder: (controller) {
          return Dialog(
            backgroundColor: themeChange.isDarkTheme()
                ? AppThemData.greyShade950
                : AppThemData.greyShade50,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            alignment: Alignment.topCenter,
            // title: const TextCustom(title: 'Item Categories', fontSize: 18),
            child: SizedBox(
              width: 500,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(8.0),
                                    topRight: Radius.circular(8.0)),
                                color: themeChange.isDarkTheme()
                                    ? AppThemData.greyShade900
                                    : AppThemData.greyShade100,
                              ),
                              child: TextCustom(
                                  title: '${controller.title}', fontSize: 18))
                          .expand(),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Image Container
                        Container(
                          height: 0.18.sh,
                          width: 0.30.sw,
                          decoration: BoxDecoration(
                            color: themeChange.isDarkTheme()
                                ? AppThemData.greyShade900
                                : AppThemData.greyShade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Stack(
                            children: [
                              if (controller.imageFile.value.path.isNotEmpty)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    controller.imageFile.value.path,
                                    fit: BoxFit.contain,
                                    height: 0.18.sh,
                                    width: 0.30.sw,
                                  ),
                                ),
                              Center(
                                child: InkWell(
                                  onTap: () async {
                                    // Image picker for web
                                    html.FileUploadInputElement uploadInput =
                                        html.FileUploadInputElement();
                                    uploadInput.accept =
                                        'image/*'; // Accept all image types
                                    uploadInput.click();

                                    uploadInput.onChange.listen((e) async {
                                      final files = uploadInput.files;
                                      if (files!.isEmpty) {
                                        print(
                                            'No image selected.'); // Log message
                                        return;
                                      }

                                      final file = files[0];
                                      print(
                                          'Selected file: ${file.name}, type: ${file.type}'); // Log selected file

                                      // Optional: Check for specific image types
                                      if (![
                                        'image/png',
                                        'image/jpeg',
                                        'image/gif'
                                      ].contains(file.type)) {
                                        print(
                                            'Unsupported file type: ${file.type}'); // Log unsupported file type
                                        return;
                                      }

                                      final reader = html.FileReader();
                                      reader.readAsDataUrl(
                                          file); // Read the file as Data URL

                                      reader.onLoadEnd.listen((e) {
                                        // Update the controller with image information
                                        controller.vehicleTypeImage.value.text =
                                            file.name; // Name of the image file
                                        controller.imageURL.value =
                                            reader.result
                                                as String; // Save the data URL
                                        controller.mimeType.value =
                                            file.type; // Get mimeType
                                        controller.isImageUpdated.value =
                                            true; // Mark as updated

                                        // Log image URL for debugging
                                        print(
                                            'Image URL: ${controller.imageURL.value}');
                                      });
                                    });
                                  },
                                  child: controller.imageURL.value
                                          .isEmpty // Check for image URL instead of path
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'Upload Image'.tr,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  color:
                                                      AppThemData.greyShade500,
                                                  fontFamily:
                                                      AppThemeData.medium,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            const Icon(
                                              Icons.file_upload_outlined,
                                              color: AppThemData.greyShade500,
                                            ),
                                          ],
                                        )
                                      : Image.network(controller.imageURL
                                          .value), // Display the uploaded image
                                ),
                              ),
                            ],
                          ),
                        ),

                        Row(
                          children: [
                            Expanded(
                                child: CustomTextFormField(
                                    hintText: 'Enter Title'.tr,
                                    controller:
                                        controller.titleController.value,
                                    title: 'Title *'.tr)),
                            spaceW(width: 16),
                            Column(
                              children: [
                                TextCustom(
                                  title: 'Status'.tr,
                                  fontSize: 12,
                                ),
                                spaceH(height: 10),
                                Transform.scale(
                                  scale: 0.8,
                                  child: CupertinoSwitch(
                                    activeColor: AppThemData.primary500,
                                    value: controller.isEnable.value,
                                    onChanged: (value) {
                                      controller.isEnable.value = value;
                                    },
                                  ),
                                ),
                                spaceH(height: 16),
                              ],
                            ),
                          ],
                        ),
                        spaceH(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CustomButtonWidget(
                              buttonTitle: "Close",
                              buttonColor: themeChange.isDarkTheme()
                                  ? AppThemData.greyShade900
                                  : AppThemData.greyShade100,
                              onPress: () {
                                controller.setDefaultData();

                                Navigator.pop(context);
                              },
                            ),
                            spaceW(),
                            CustomButtonWidget(
                              buttonTitle: controller.isEditing.value
                                  ? "Edit".tr
                                  : "Save".tr,
                              onPress: () {
                                // if (Constant.isDemo) {
                                //   DialogBox.demoDialogBox();
                                // } else {
                                if (controller.titleController.value.text !=
                                    "") {
                                  controller.isEditing.value
                                      ? controller.updateBrand()
                                      : controller.addVehicleBrandAPI(
                                          controller.title.value);
                                  controller.setDefaultData();

                                  Navigator.pop(context);
                                } else {
                                  ShowToastDialog.toast(
                                      "All Fields are Required...".tr);
                                }
                                // }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
