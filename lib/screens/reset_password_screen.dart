import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/api/reset_password_api.dart';
import 'package:shishughar/custom_widget/custom_appbar.dart';
import 'package:shishughar/custom_widget/custom_btn.dart';
import 'package:shishughar/custom_widget/custom_text.dart';
import 'package:shishughar/custom_widget/customtextfield.dart';
import 'package:shishughar/screens/login_screen.dart';
import 'package:shishughar/screens/verificationScreen.dart';
import 'package:shishughar/style/styles.dart';
import 'package:shishughar/utils/validate.dart';

import '../utils/globle_method.dart';

class ResetPaswordScreen extends StatefulWidget {
  const ResetPaswordScreen({super.key});

  @override
  State<ResetPaswordScreen> createState() => _ResetPaswordScreenState();
}

class _ResetPaswordScreenState extends State<ResetPaswordScreen> {
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Global.applyDisplayCutout(Color(0xff5979AA));
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppbar(
          text: CustomText.resetpassword,
          onTap: () {
            Navigator.pop(context);
          },
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    CustomText.resetpassword,
                    style: Styles.blue247,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.h),
                    child: Text(
                      CustomText.Newemailmustbeunique,
                      style: Styles.black126P,
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  CustomTextField(
                    titleText: CustomText.EmailAddress,
                    controller: emailController,
                    hintText: CustomText.typehere,
                    fillColor: Color(0xffF2F7FF),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    child: CElevatedButton(
                      onPressed: () async {
                        RegExp regex =
                            RegExp(r'^[\w-\m.]+@([\w-]+\.)+[\w-]{2,4}$');
                        if (emailController.text.isEmpty) {
                          Validate().singleButtonPopup("Email required",CustomText.ok,false,context);
                        } else if (!regex.hasMatch(emailController.text.trim())) {
                          Validate().singleButtonPopup("Invalid email format",CustomText.ok,false,context);
                          return;
                        } else {
                          var network = await Validate().checkNetworkConnection();

                          if (network) {
                            showLoaderDialog(context);
                            var responce = await ResetPaswordScreenApiService()
                                .getResetPaswordScreenApi(emailController.text.trim());
                            Navigator.pop(context);
                            if (responce.statusCode == 200) {
                              Validate().singleButtonPopup(
                                  Global.errorBodyToStringFromList(responce.body),CustomText.ok,
                                  true,
                                  context);
                            }
                            else {
                              Validate().singleButtonPopup(
                                  Global.errorBodyToStringFromList(responce.body),CustomText.ok,
                                  true,
                                  context);
                            }
                          }else{
                            Validate().singleButtonPopup(
                                CustomText.nointernetconnectionavailable,CustomText.ok,
                                false,
                                context);
                          }
                        }
                      },
                      text: CustomText.Submit,
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            Image.asset("assets/bottomloginImage.png"),
          ],
        ),
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
                Text("Please wait...")
              ],
            ),
          ),
        );

      },
    );
  }
}
