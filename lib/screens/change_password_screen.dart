import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shishughar/api/change_password_api.dart';
import 'package:shishughar/custom_widget/custom_appbar.dart';
import 'package:shishughar/custom_widget/custom_btn.dart';
import 'package:shishughar/custom_widget/custom_text.dart';
import 'package:shishughar/custom_widget/customtextfield.dart';
import 'package:shishughar/style/styles.dart';
import 'package:shishughar/utils/globle_method.dart';
import 'package:shishughar/utils/validate.dart';

import '../database/helper/translation_language_helper.dart';
import '../model/apimodel/translation_language_api_model.dart';
import 'login_screen.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  String? lngtr;
  List<Translation> locationControlls = [];
  TextEditingController oldpasswordController = TextEditingController();
  TextEditingController newpasswordController = TextEditingController();
  TextEditingController confirmpasswordcontroller = TextEditingController();
  bool isNewPasswordInvalid = false;
  bool isConfirmPasswordDisabled = false;
  bool isConfirmPasswordInvalid = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppbar(
        text: lngtr != null
            ? Global.returnTrLable(
                locationControlls, CustomText.ChangePassword, lngtr!)
            : "",
        onTap: () {
          Navigator.pop(context);
        },
      ),
      body: SafeArea(
        child: lngtr != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                    ),
                    child: Text(
                      Global.returnTrLable(locationControlls,
                          CustomText.Createnewpassword, lngtr!),
                      style: Styles.blue247,
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
                    child: Text(
                      Global.returnTrLable(locationControlls,
                          CustomText.Newpasswordmustbeunique, lngtr!),
                      style: Styles.black126P,
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
                    child: Column(
                      children: [
                        CustomTextField(
                          controller: oldpasswordController,
                          hintText: Global.returnTrLable(locationControlls,
                              CustomText.oldPassword, lngtr!),
                          fillColor: Color(0xffF2F7FF),
                          // maxlength: 16,
                        ),
                        CustomTextField(
                          controller: newpasswordController,
                          hintText: Global.returnTrLable(locationControlls,
                              CustomText.NewPassword, lngtr!),
                          fillColor: Color(0xffF2F7FF),
                          maxlength: 16,
                          onChanged: (value) {
                            if (value.length > 16) {
                              Validate().singleButtonPopup(
                                  'Invalid Password',
                                  Global.returnTrLable(
                                      locationControlls, CustomText.ok, lngtr!),
                                  false,
                                  context);
                              setState(() {
                                isNewPasswordInvalid = true;
                                isConfirmPasswordDisabled = true;
                              });
                            } else {
                              setState(() {
                                isNewPasswordInvalid = false;
                                isConfirmPasswordDisabled = false;
                              });
                            }
                          },
                          // Add a decoration to change the border color based on isNewPasswordInvalid
                          isInvalid: isNewPasswordInvalid,
                        ),
                        CustomTextField(
                          maxlength: 16,
                          controller: confirmpasswordcontroller,
                          hintText: Global.returnTrLable(locationControlls,
                              CustomText.confirmPassword, lngtr!),
                          fillColor: Color(0xffF2F7FF),
                          enabled: !isConfirmPasswordDisabled,
                          onChanged: (value) {
                            if (value.length > 16) {
                              Validate().singleButtonPopup(
                                  'Invalid Password',
                                  Global.returnTrLable(
                                      locationControlls, CustomText.ok, lngtr!),
                                  false,
                                  context);
                              setState(() {
                                isConfirmPasswordInvalid = true;
                              });
                            } else {
                              setState(() {
                                isConfirmPasswordInvalid = false;
                              });
                            }
                          },
                          isInvalid: isConfirmPasswordInvalid,
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    child: CElevatedButton(
                      onPressed: () async {
                        var oldPassword =
                            await Validate().readString(Validate.Password);
                        if (oldpasswordController.text
                            .toString()
                            .trim()
                            .isEmpty) {
                          Validate().singleButtonPopup(
                              Global.returnTrLable(locationControlls,
                                  CustomText.oldpasswordRequred, lngtr!),
                              Global.returnTrLable(
                                  locationControlls, CustomText.ok, lngtr!),
                              false,
                              context);
                        } else if (!(oldpasswordController.text
                                .toString()
                                .trim() ==
                            oldPassword)) {
                          Validate().singleButtonPopup(
                              Global.returnTrLable(locationControlls,
                                  CustomText.oldpasswordisNotMatch, lngtr!),
                              Global.returnTrLable(
                                  locationControlls, CustomText.ok, lngtr!),
                              false,
                              context);
                        } else if (newpasswordController.text
                            .toString()
                            .trim()
                            .isEmpty) {
                          Validate().singleButtonPopup(
                              Global.returnTrLable(locationControlls,
                                  CustomText.newPasswordRequred, lngtr!),
                              Global.returnTrLable(
                                  locationControlls, CustomText.ok, lngtr!),
                              false,
                              context);
                        } else if (newpasswordController.text.trim() ==
                            oldpasswordController.text.toString().trim()) {
                          Validate().singleButtonPopup(
                              Global.returnTrLable(locationControlls,
                                  CustomText.oldAndNewPassword, lngtr!),
                              Global.returnTrLable(
                                  locationControlls, CustomText.ok, lngtr!),
                              false,
                              context);
                        } else if (!(newpasswordController.text.trim() ==
                            confirmpasswordcontroller.text.trim())) {
                          Validate().singleButtonPopup(
                              Global.returnTrLable(locationControlls,
                                  CustomText.newAndConfrom, lngtr!),
                              Global.returnTrLable(
                                  locationControlls, CustomText.ok, lngtr!),
                              false,
                              context);
                        } else if (isNewPasswordInvalid ||
                            isConfirmPasswordInvalid) {
                          Validate().singleButtonPopup(
                              Global.returnTrLable(locationControlls,
                                  'Invalid Password', lngtr!),
                              Global.returnTrLable(
                                  locationControlls, CustomText.ok, lngtr!),
                              false,
                              context);
                        } else {
                          showLoaderDialog(context);
                          var responce = await ChangePaswordApiService()
                              .getChangePaswordApi(
                                  confirmpasswordcontroller.text
                                      .toString()
                                      .trim(),
                                  oldpasswordController.text.toString());
                          if (responce.statusCode == 200) {
                            // Navigator.pop(context);
                            Map<String, dynamic> resultMap =
                                jsonDecode(responce.body);
                            var currentPassword =
                                resultMap['Response'].toString();
                            if (Global.validString(currentPassword)) {
                              Navigator.pop(context);
                              Validate().saveString(
                                  Validate.Password,
                                  confirmpasswordcontroller.text
                                      .toString()
                                      .trim());

                              Validate().singleButtonPopup(
                                  Global.returnTrLable(
                                      locationControlls,
                                      CustomText.passwordChangeSuccfull,
                                      lngtr!),
                                  Global.returnTrLable(
                                      locationControlls, CustomText.ok, lngtr!),
                                  true,
                                  context);
                              // Navigator.pop(context);
                              // Navigator.pop(context);
                            } else {
                              Navigator.pop(context);
                              Validate().singleButtonPopup(
                                  Global.returnTrLable(
                                      locationControlls,
                                      CustomText.passwordChangeNoChanges,
                                      lngtr!),
                                  Global.returnTrLable(
                                      locationControlls, CustomText.ok, lngtr!),
                                  false,
                                  context);
                            }
                          } else if (responce.statusCode == 401) {
                            Navigator.pop(context);
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            await prefs.remove(Validate.Password);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content:
                              Text(Global.returnTrLable(locationControlls, CustomText.token_expired, lngtr!))),
                            );
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (mContext) => LoginScreen(),
                                ));
                            // Validate().singleButtonPopup(
                            //     Global.returnTrLable(locationControlls,
                            //         CustomText.token_expired, lngtr!),
                            //     Global.returnTrLable(
                            //         locationControlls, CustomText.ok, lngtr!),
                            //     false,
                            //     context);
                          } else {
                            Navigator.pop(context);
                            Validate().singleButtonPopup(
                                Global.errorBodyToStringFromList(responce.body),
                                CustomText.ok,
                                true,
                                context);
                          }
                        }
                      },
                      text: lngtr != null
                          ? Global.returnTrLable(locationControlls,
                              CustomText.resetpassword, lngtr!)
                          : "",
                    ),
                  ),
                  Image.asset("assets/bottomloginImage.png"),
                ],
              )
            : SizedBox(),
      ),
    );
  }

  showLoaderDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                SizedBox(height: 10.h),
                Text(Global.returnTrLable(
                    locationControlls, CustomText.pleaseWait, lngtr!)),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> initializeData() async {
    lngtr = await Validate().readString(Validate.sLanguage);
    List<String> valueNames = [
      CustomText.ChangePassword,
      CustomText.oldPassword,
      CustomText.Createnewpassword,
      CustomText.Newpasswordmustbeunique,
      CustomText.NewPassword,
      CustomText.NewPassword,
      CustomText.nointernetconnectionavailable,
      CustomText.ok,
      CustomText.pleaseWait,
      CustomText.token_expired,
      CustomText.resetpassword,
      CustomText.oldpasswordRequred,
      CustomText.oldpasswordisNotMatch,
      CustomText.newPasswordRequred,
      CustomText.confromPasswordRequred,
      CustomText.oldAndNewPassword,
      CustomText.newAndConfrom,
      CustomText.confirmPassword,
      CustomText.passwordChangeSuccfull,
    ];
    await TranslationDataHelper()
        .callTranslateString(valueNames)
        .then((value) => locationControlls = value);

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initializeData();
  }
}
