import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shishughar/custom_widget/custom_appbar.dart';
import 'package:shishughar/custom_widget/custom_text.dart';
import 'package:shishughar/database/helper/translation_language_helper.dart';
import '../custom_widget/custom_btn.dart';
import '../custom_widget/dynamic_screen_widget/dynamic_customtextfield_new.dart';
import '../model/apimodel/translation_language_api_model.dart';
import '../utils/globle_method.dart';
import '../utils/validate.dart';

class UserDetailsScreen extends StatefulWidget {
  bool isEdit;

  UserDetailsScreen({super.key, required this.isEdit});

  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen>
    with WidgetsBindingObserver {
  String? selecteditem;
  String? userName;
  String? email;
  String? role;
  String? mobile_no;
  List<Translation> translatsLabel = [];
  String? lng;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        text: lng != null
            ? Global.returnTrLable(translatsLabel, CustomText.MyProfile, lng!)
            : CustomText.MyProfile,
        onTap: () {
          Navigator.pop(context, 'itemRefresh');
        },
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: (lng != null && email != null)
            ? Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        SizedBox(height: 3.h),
                        DynamicCustomTextFieldNew(
                          titleText: Global.returnTrLable(
                              translatsLabel, CustomText.UserName, lng!),
                          readable: true,
                          initialvalue: userName,
                          // isRequred: 1,
                          onChanged: (value) {
                            print('Entered text: $value');
                          },
                        ),
                        DynamicCustomTextFieldNew(
                          titleText: Global.returnTrLable(
                              translatsLabel, CustomText.role, lng!),
                          readable: true,
                          hintText: CustomText.typehere,
                          initialvalue: role,
                          // isRequred: 1,
                          onChanged: (value) {
                            print('Entered text: $value');
                          },
                        ),
                        DynamicCustomTextFieldNew(
                          titleText: Global.returnTrLable(translatsLabel,
                              CustomText.email, lng!),
                          readable: true,
                          hintText: CustomText.typehere,
                          initialvalue: email,
                          // isRequred: 1,
                          onChanged: (value) {
                            print('Entered text: $value');
                          },
                        ),
                        DynamicCustomTextFieldNew(
                          titleText: Global.returnTrLable(translatsLabel,
                              CustomText.mobileNumber, lng!),
                          readable: true,
                          hintText: CustomText.role,
                          initialvalue: mobile_no,
                          // isRequred: 1,
                          onChanged: (value) {
                            print('Entered text: $value');
                          },
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: CElevatedButton(
                                color: Color(0xffF26BA3),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                text: Global.returnTrLable(
                                        translatsLabel, CustomText.back, lng!)
                                    .trim(),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                      ],
                    ),
                  ],
                ),
              )
            : SizedBox(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    initData();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  initData() async {
    lng = await Validate().readString(Validate.sLanguage);
    List<String> valueItems = [
      CustomText.UserName,
      CustomText.MyProfile,
      CustomText.role,
      CustomText.email,
      CustomText.mobileNumber,
      CustomText.back,
      // CustomText.,
    ];
    await TranslationDataHelper()
        .callTranslateString(valueItems)
        .then((value) => translatsLabel = value);

    showLoaderDialog(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      email = prefs.getString(Validate.userName);
      userName = prefs.getString(Validate.fullName);
      role = prefs.getString(Validate.role);
      mobile_no = prefs.getString(Validate.mobile_no);
      print(userName);
      if (email != null) {
        Navigator.pop(context);
      }
      setState(() {});
    } catch (e) {
      print("error");
    }
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
                    translatsLabel, CustomText.pleaseWait, lng!)),
              ],
            ),
          ),
        );
      },
    );
  }
}
