import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shishughar/api/login_api_service.dart';
import 'package:shishughar/api/master_api.dart';
import 'package:shishughar/custom_widget/custom_btn.dart';
import 'package:shishughar/custom_widget/custom_radio_btn.dart';
import 'package:shishughar/custom_widget/custom_text.dart';
import 'package:shishughar/custom_widget/custom_textfield.dart';
import 'package:shishughar/database/helper/auth_login_helper.dart';
import 'package:shishughar/database/helper/block_data_helper.dart';
import 'package:shishughar/database/helper/district_data_helper.dart';
import 'package:shishughar/database/helper/gram_panchayat_data_helper.dart';
import 'package:shishughar/database/helper/mapping_login_helper.dart';
import 'package:shishughar/database/helper/state_data_helper.dart';
import 'package:shishughar/database/helper/village_data_helper.dart';
import 'package:shishughar/model/databasemodel/auth_model.dart';
import 'package:shishughar/model/apimodel/login_model.dart';
import 'package:shishughar/model/databasemodel/tabBlock_model.dart';
import 'package:shishughar/model/databasemodel/tabDistrict_model.dart';
import 'package:shishughar/model/databasemodel/tabGramPanchayat_model.dart';
import 'package:shishughar/model/databasemodel/tabVillage_model.dart';
import 'package:shishughar/model/databasemodel/tabstate_model.dart';
import 'package:shishughar/screens/reset_password_screen.dart';
import 'package:shishughar/style/styles.dart';
import 'package:shishughar/utils/validate.dart';
import 'package:toast/toast.dart';
import '../api/creche_data_api.dart';
import '../api/form_logic_api.dart';
import '../api/language_translation_api.dart';
import '../api/village_profile_meta_api.dart';
import '../database/helper/creche_helper/creche_data_helper.dart';
import '../database/helper/form_logic_helper.dart';
import '../database/helper/height_weight_boys_girls_helper.dart';
import '../database/helper/mst_common_helper.dart';
import '../database/helper/mst_supervisor_helper.dart';
import '../database/helper/translation_language_helper.dart';
import '../database/helper/vaccines_helper.dart';
import '../database/helper/village_profile/village_profile_response_helper.dart';
import '../model/apimodel/form_logic_api_model.dart';
import '../model/apimodel/mapping_login_model.dart';
import '../model/apimodel/master_data_model.dart';
import '../model/apimodel/mater_data_other_model.dart';
import '../model/apimodel/translation_language_api_model.dart';
import '../utils/constants.dart';
import '../utils/globle_method.dart';
import 'dashboardscreen_new.dart';
import 'package:http/http.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with WidgetsBindingObserver {
  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  String EnglishType = 'English';
  bool _isPasswordVisible = true;
  DateTime pre_backpress = DateTime.now();
  String? savedUsername;
  bool _keyboardVisible = false;
  String appVersionName = '';

  @override
  void initState() {
    super.initState();
    _loadSavedUsername();

    WidgetsBinding.instance.addObserver(this);
  }

  Future<void> _getAppVersionName() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appVersionName = packageInfo.version;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final value = WidgetsBinding.instance.window.viewInsets.bottom;
    setState(() {
      _keyboardVisible = value > 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return WillPopScope(
      onWillPop: () async {
        final timegap = DateTime.now().difference(pre_backpress);
        final cantExit = timegap >= Duration(seconds: 2);
        pre_backpress = DateTime.now();
        if (cantExit) {
          final message = 'Press back button again to exit';
          Toast.show(message, duration: 3, backgroundColor: Colors.black);

          return false;
        } else {
          // Fluttertoast.cancel();
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          toolbarHeight: 0,
          systemOverlayStyle:
              SystemUiOverlayStyle(statusBarColor: Color(0xffDFDFDF)),
        ),
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          reverse: true,
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/toploginImage.png",
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Container(
                        child: Column(
                          children: [
                            (_keyboardVisible)
                                ? Flexible(
                                    child: SizedBox(
                                        height: 181.h,
                                        width: 280.w,
                                        child: Image.asset(
                                            "assets/loginlogo.png")),
                                  )
                                : SizedBox(
                                    height: 181.h,
                                    width: 280.w,
                                    child: Image.asset("assets/loginlogo.png")),
                            Flexible(
                              child: Text(
                                CustomText.SHISHUGHAR,
                                style: Styles.blue207P,
                              ),
                            ),
                            Flexible(
                              child: Divider(
                                thickness: 1.5,
                                indent: 70.w,
                                endIndent: 70.w,
                                color: Color(0xffDFDFDF),
                              ),
                            ),
                            Flexible(
                              child: Text(
                                CustomText.hindiSHISHUGHAR,
                                style: Styles.blue207P,
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Flexible(
                              child: Text(
                                CustomText.SishuGharManagementSystem,
                                style: Styles.black127P,
                              ),
                            ),
                            Flexible(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 50.w, vertical: 10.h),
                                child: Row(
                                  children: [
                                    CustomRadioButton(
                                      value: 'English',
                                      groupValue: EnglishType,
                                      onChanged: (value) {
                                        Validate().saveString(
                                            Validate.sLanguage, 'en');
                                        setState(() {
                                          EnglishType = value!;
                                        });
                                      },
                                      label: CustomText.English,
                                    ),
                                    Spacer(),
                                    CustomRadioButton(
                                      value: 'Hindi',
                                      groupValue: EnglishType,
                                      onChanged: (value) {
                                        Validate().saveString(
                                            Validate.sLanguage, 'hi');
                                        setState(() {
                                          EnglishType = value!;
                                        });
                                      },
                                      label: CustomText.Hindi,
                                    ),
                                    Spacer(),
                                    CustomRadioButton(
                                      value: 'Odiya',
                                      groupValue: EnglishType,
                                      onChanged: (value) {
                                        Validate().saveString(
                                            Validate.sLanguage, 'od');
                                        setState(() {
                                          EnglishType = value!;
                                        });
                                      },
                                      label: CustomText.Odiya,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: (_keyboardVisible) ? 15.w : 7.w),
                              child: CustomTextFieldRow(
                                controller: mobileController,
                                keyboardtype: TextInputType.text,
                                enabled: savedUsername == null ? true : false,
                                // maxlength: 20,
                                hintText: CustomText.Email,
                                prefixIcon: Image.asset(
                                  "assets/mobile.png",
                                  scale: 3.2,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: (_keyboardVisible) ? 15.w : 7.w),
                              child: CustomTextFieldRow(
                                maxlength: 20,
                                controller: passwordcontroller,
                                hintText: CustomText.Password,
                                prefixIcon: Image.asset(
                                  "assets/key.png",
                                  scale: 3.2,
                                ),
                                suffixIcon: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                  },
                                  child: Icon(
                                    _isPasswordVisible == true
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.grey,
                                    size: 20.sp,
                                  ),
                                ),
                                obscureText: _isPasswordVisible,
                              ),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () {},
                                    child: Visibility(
                                      visible: false,
                                      // Set this to false to hide the Text widget
                                      child: Text(
                                        CustomText.LoginwithOTP,
                                        style: Styles.black105P,
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ResetPaswordScreen(),
                                          ));
                                    },
                                    child: Text(
                                      CustomText.ForgotPassword,
                                      style: Styles.blue105P,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: (_keyboardVisible) ? 10.h : 30.h,
                            ),
                            CElevatedButton(
                              onPressed: () async {
                                var network =
                                    await Validate().checkNetworkConnection();
                                if (network) {
                                  if (mobileController.text.isEmpty) {
                                    Validate().singleButtonPopup(
                                        'User name required',
                                        'ok',
                                        false,
                                        context);
                                    // ScaffoldMessenger.of(context).showSnackBar(
                                    //     const SnackBar(
                                    //         content:
                                    //             Text("User name required")));
                                  } else if (passwordcontroller.text.isEmpty) {
                                    Validate().singleButtonPopup(
                                        'Password required',
                                        'ok',
                                        false,
                                        context);
                                    // ScaffoldMessenger.of(context).showSnackBar(
                                    //     const SnackBar(
                                    //         content:
                                    //             Text("Password required")));
                                  } else {
                                    showLoaderDialog(context);
                                    var userName = await Validate()
                                        .readString(Validate.loginName);
                                    if (userName != null) {
                                      var loginResponse =
                                          await LoginApiService().loginUser(
                                              mobileController.text.trim(),
                                              passwordcontroller.text.trim());

                                      if (loginResponse.statusCode == 200) {
                                        LoginApiModel loginApiModel =
                                            LoginApiModel.fromJson(json
                                                .decode(loginResponse.body));

                                        if (loginApiModel.auth != null) {
                                          if (loginApiModel.auth!.apiKey !=
                                              null) {
                                            if (EnglishType == 'English') {
                                              Validate().saveString(
                                                  Validate.sLanguage, 'en');
                                            } else if (EnglishType == 'Hindi') {
                                              Validate().saveString(
                                                  Validate.sLanguage, 'hi');
                                            } else if (EnglishType == 'Odiya') {
                                              Validate().saveString(
                                                  Validate.sLanguage, 'od');
                                            }
                                            var key =
                                                loginApiModel.auth!.apiKey!;
                                            var secret =
                                                loginApiModel.auth!.apiSecret!;
                                            var token =
                                                'token ' + key + ':' + secret;

                                            Validate().saveString(
                                                Validate.userName,
                                                loginApiModel.auth!.username!);
                                            Validate().saveString(
                                                Validate.loginName,
                                                mobileController.text.trim());
                                            Validate().saveString(
                                                Validate.Password,
                                                passwordcontroller.text.trim());
                                            Validate().saveString(
                                                Validate.appToken, token);
                                            Validate().saveString(Validate.role,
                                                loginApiModel.auth!.role!);
                                            Navigator.pop(context);
                                            // if (loginApiModel.auth!.role ==
                                            //     'Cluster Coordinator') {
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (mContext) =>
                                                      DashboardScreen(
                                                    index: 0,
                                                  ),
                                                ));
                                            // } else {
                                            //   Navigator.pushReplacement(
                                            //       context,
                                            //       MaterialPageRoute(
                                            //         builder: (mContext) =>
                                            //             LocationScreen(),
                                            //       ));
                                            // }
                                          }
                                        } else {
                                          Navigator.pop(context);
                                          Validate().singleButtonPopup(
                                              'Internal Server Error!',
                                              'ok',
                                              false,
                                              context);
                                          // ScaffoldMessenger.of(context)
                                          //     .showSnackBar(const SnackBar(
                                          //         content: Text(
                                          //             "Internal Server Error!")));
                                        }
                                      } else {
                                        Navigator.pop(context);
                                        Validate().singleButtonPopup(
                                            Global.errorBodyToString(
                                                loginResponse.body, 'message'),
                                            'ok',
                                            false,
                                            context);
                                        // ScaffoldMessenger.of(context)
                                        //     .showSnackBar(SnackBar(
                                        //         content: Text(
                                        //             Global.errorBodyToString(
                                        //                 loginResponse.body,
                                        //                 'message'))));
                                      }
                                    } else {
                                      var loginResponse =
                                          await LoginApiService().loginUser(
                                              mobileController.text.trim(),
                                              passwordcontroller.text.trim());

                                      if (loginResponse.statusCode == 200) {
                                        Validate().saveString(
                                            Validate.loginName,
                                            mobileController.text.trim());
                                        LoginApiModel loginApiModel =
                                            LoginApiModel.fromJson(json
                                                .decode(loginResponse.body));

                                        if (loginApiModel != null) {
                                          if (loginApiModel.auth != null) {
                                            if (loginApiModel.auth!.apiKey !=
                                                null) {
                                              await initLoginAuth(
                                                  context,
                                                  loginApiModel,
                                                  loginApiModel.auth!.username!,
                                                  passwordcontroller.text
                                                      .trim());
                                            }
                                          }
                                        } else {
                                          Navigator.pop(context);
                                          Validate().singleButtonPopup(
                                              'Internal Server Error!',
                                              'ok',
                                              false,
                                              context);
                                          // ScaffoldMessenger.of(context)
                                          //     .showSnackBar(const SnackBar(
                                          //         content: Text(
                                          //             "Internal Server Error!")));
                                        }
                                      } else {
                                        Navigator.pop(context);
                                        Validate().singleButtonPopup(
                                            Global.errorBodyToString(
                                                loginResponse.body, 'message'),
                                            'ok',
                                            false,
                                            context);
                                        // ScaffoldMessenger.of(context)
                                        //     .showSnackBar(SnackBar(
                                        //         content: Text(
                                        //             Global.errorBodyToString(
                                        //                 loginResponse.body,
                                        //                 'message'))));
                                      }
                                    }
                                  }
                                } else {
                                  Validate().singleButtonPopup(
                                      CustomText.nointernetconnectionavailable,
                                      CustomText.ok,
                                      false,
                                      context);
                                }
                              },
                              text: CustomText.LogIn,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            // Center(
                            //   child: RichText(
                            //     text: TextSpan(
                            //       text: CustomText.Version,
                            //       style: Styles.black124,
                            //       children: <TextSpan>[
                            //         TextSpan(
                            //             text: "$appVersionName", style: Styles.black126P),
                            //         Constants.baseUrl=='https://uat.shishughar.in/api/'?
                            //         TextSpan(text: "  (UAT)", style: Styles.red125)
                            //             :Constants.baseUrl=='https://shishughar.in/api/'?
                            //             TextSpan(  text: "  (PROD)", style: Styles.red125) :
                            //         TextSpan(  text: "  (DEV)", style: Styles.red125),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                            Center(
                              child: GestureDetector(
                                onTap: () async {
                                  await Validate().createDbBackup();
                                },
                                child: RichText(
                                  text: TextSpan(
                                    text: CustomText.Version,
                                    style: Styles.black124,
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: "$appVersionName",
                                          style: Styles.black126P),
                                      Constants.baseUrl ==
                                              'https://uat.shishughar.in/api/'
                                          ? TextSpan(
                                              text: "  (UAT)",
                                              style: Styles.red125)
                                          : Constants.baseUrl ==
                                                  'https://shishughar.in/api/'
                                              ? TextSpan(
                                                  text: " ",
                                                  style: Styles.red125)
                                              : TextSpan(
                                                  text: "  (DEV)",
                                                  style: Styles.red125),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(
                                    bottom: (_keyboardVisible) ? 15.h : 7.h)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: EdgeInsets.only(
                  //       bottom: MediaQuery.of(context).viewInsets.bottom),
                  // ),
                  Image.asset("assets/bottomloginImage.png"),
                ],
              ),
            ),
          ),
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

  initMasterData(MasterDataModel master) async {
    if (master != null) {
      List<TabState> stateList = master.tabState!;

      await StateDataHelper().insertMasterStates(stateList);

      List<TabBlock> blockList = master.tabBlock!;

      await BlockDataHelper().insertMasterBlock(blockList);

      List<TabDistrict> districtList = master.tabDistrict!;

      await DistrictDataHelper().insertMasterDistrict(districtList);

      List<TabVillage> villageList = master.tabVillage!;

      await VillageDataHelper().insertMasterVillage(villageList);

      List<TabGramPanchayat> gramPanchayatList = master.tabGramPanchayat!;

      await GramPanchayatDataHelper()
          .insertMasterGramPanchayat(gramPanchayatList);

      if (master.tabSuperVisor != null) {
        await MstSuperVisorHelper().inserts(master.tabSuperVisor!);
      }
      /////////Height Weight for age
      if (master.tabHeightforAgeBoys != null) {
        await HeightWeightBoysGirlsHelper()
            .insertHeightForAgeBoys(master.tabHeightforAgeBoys!);
      }

      if (master.tabHeightforAgeGirls != null) {
        await HeightWeightBoysGirlsHelper()
            .insertHeightForAgeGirls(master.tabHeightforAgeGirls!);
      }

      if (master.tabWeightforAgeBoys != null) {
        await HeightWeightBoysGirlsHelper()
            .insertWeightForAgeBoys(master.tabWeightforAgeBoys!);
      }

      if (master.tabWeightforAgeGirls != null) {
        await HeightWeightBoysGirlsHelper()
            .insertWeightForAgeGirls(master.tabWeightforAgeGirls!);
      }
      if (master.tabWeightToHeightBoys != null) {
        await HeightWeightBoysGirlsHelper()
            .insertWeightToHeightBoys(master.tabWeightToHeightBoys!);
      }

      if (master.tabWeightToHeightGirls != null) {
        await HeightWeightBoysGirlsHelper()
            .insertWeightToHeightGirls(master.tabWeightToHeightGirls!);
      }

      if (master.tabVaccines != null) {
        await VaccinesDataHelper().insert(master.tabVaccines!);
      }

    }
  }

  Future<void> initLoginAuth(BuildContext mContext, LoginApiModel loginApiModel,
      String userName, String password) async {
    ////master user auth
    if (EnglishType == 'English') {
      Validate().saveString(Validate.sLanguage, 'en');
    } else if (EnglishType == 'Hindi') {
      Validate().saveString(Validate.sLanguage, 'hi');
    } else if (EnglishType == 'Odiya') {
      Validate().saveString(Validate.sLanguage, 'od');
    }
    if (loginApiModel.fullName != null) {
      Validate().saveString(Validate.fullName, loginApiModel.fullName!);
    }
    var userRole = "";
    var key = loginApiModel.auth!.apiKey!;
    var secret = loginApiModel.auth!.apiSecret!;
    var token = 'token ' + key + ':' + secret;

    List<Mapping> mappingList = loginApiModel.auth!.mapping!;

    if (mappingList.isNotEmpty) {
      await MappingLoginDataHelper().insertMappingLoginData(mappingList);
    }
    AuthModel tabusermodel = AuthModel(
        username: loginApiModel.auth!.username,
        role: loginApiModel.auth!.role,
        partner: loginApiModel.auth!.partner,
        password: password);

    if (tabusermodel != null) {
      userRole = loginApiModel.auth!.role!;
      Validate().saveString(Validate.role, userRole);
      Validate().saveString(Validate.mobile_no, loginApiModel.auth!.mobile_no!);
      await AuthLoginDataHelper().insert(tabusermodel);
    }

    ////master other data
    var masterOtherDataResponse = await MasterApiService()
        .fetchmasterOtherData(userName, password, token);
    if (masterOtherDataResponse.statusCode == 200) {
      MstCommonModel mstCommonModel =
          MstCommonModel.fromJson(json.decode(masterOtherDataResponse.body));

      await MstCommonHelper().insertMstCommonData(mstCommonModel.tabCommon!);

      await callApiLogicData(mContext, userName, password, token, userRole);
    } else {
      Navigator.pop(mContext);
      Validate().singleButtonPopup(
          Global.errorBodyToString(masterOtherDataResponse.body, 'message'),
          'ok',
          false,
          context);
      // ScaffoldMessenger.of(mContext).showSnackBar(SnackBar(
      //     content: Text(Global.errorBodyToString(
      //         masterOtherDataResponse.body, 'message'))));
    }
  }

  Future<void> callApiLogicData(BuildContext mContext, String userName,
      String password, String token, String userRole) async {
    var logisResponce =
        await FormLogicApiService().fetchLogicData(userName, password, token);

    if (logisResponce.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(logisResponce.body);
      await initFormLogic(FormLogicApiModel.fromJson(responseData));
      await callApiTranslateData(mContext, userName, password, token, userRole);
    } else {
      Navigator.pop(mContext);
      Validate().singleButtonPopup(
          Global.errorBodyToString(logisResponce.body, 'message'),
          'ok',
          false,
          context);
      // ScaffoldMessenger.of(mContext).showSnackBar(SnackBar(
      //     content:
      //         Text(Global.errorBodyToString(logisResponce.body, 'message'))));
    }
  }

  Future<void> callApiTranslateData(BuildContext mContext, String userName,
      String password, String token, String userRole) async {
    var translateResponce =
        await TranslationService().translateApi(userName, password, token);

    if (translateResponce.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(translateResponce.body);
      await initTranslation(TranslationModel.fromJson(responseData));
      await getCrecheData(mContext, userName, password, token, userRole);
    } else {
      Navigator.pop(mContext);
      Validate().singleButtonPopup(
          Global.errorBodyToString(translateResponce.body, 'message'),
          'ok',
          false,
          context);
      // ScaffoldMessenger.of(mContext).showSnackBar(SnackBar(
      //     content: Text(
      //         Global.errorBodyToString(translateResponce.body, 'message'))));
    }
  }

  Future<void> callMasterData(BuildContext mContext, String userName,
      String password, String token, String userRole) async {
    var msterDataResponse =
        await MasterApiService().fetchmasterData(userName, password, token);

    if (msterDataResponse.statusCode == 200) {
      MasterDataModel masterDataApiModel =
          MasterDataModel.fromJson(json.decode(msterDataResponse.body));
      await initMasterData(masterDataApiModel);
      Navigator.pop(mContext);
      Validate().saveString(Validate.userName, userName);
      Validate().saveString(Validate.Password, password);
      Validate().saveString(Validate.appToken, token);
      Validate().saveString(
          Validate.msterDownloadDateTime, Validate().currentDateTime());
      // if (userRole == 'Creche Supervisor') {
      //   Navigator.pushReplacement(
      //       mContext,
      //       MaterialPageRoute(
      //         builder: (mContext) => LocationScreen(),
      //       ));
      // } else {
      Navigator.pushReplacement(
          mContext,
          MaterialPageRoute(
            builder: (mContext) => DashboardScreen(index: 0),
          ));
      // }
    } else {
      Navigator.pop(mContext);
      Validate().singleButtonPopup(
          Global.errorBodyToString(msterDataResponse.body, 'message'),
          'ok',
          false,
          context);
      // ScaffoldMessenger.of(mContext).showSnackBar(SnackBar(
      //     content: Text(
      //         Global.errorBodyToString(msterDataResponse.body, 'message'))));
    }
  }

  Future<void> initTranslation(TranslationModel? translationModel) async {
    if (translationModel != null) {
      List<Translation>? translationList = translationModel.translation;
      if (translationList != null) {
        print("Insert translation data into the database");
        await TranslationDataHelper()
            .insertTranslationLanguage(translationList);
      } else {
        print("Not Insert translation data into the database");
      }
    }
  }

  Future<void> initFormLogic(FormLogicApiModel? formLogicApiModel) async {
    if (formLogicApiModel != null) {
      List<TabFormsLogic>? formLogicList = formLogicApiModel.tabFormsLogic;
      if (formLogicList != null) {
        print("Insert formlogic data into the database");
        await FormLogicDataHelper().insertFormLogic(formLogicList);
      } else {
        print("Not Insert formlogic data into the database");
      }
    }
  }

  _loadSavedUsername() async {
    await _getAppVersionName();
    savedUsername = await Validate().readString(Validate.loginName);

    var password = await Validate().readString(Validate.Password);

    if (savedUsername != null) {
      setState(() {
        mobileController.text = savedUsername.toString();
      });
    } else if (password != null) {
      passwordcontroller.text = password;
    } else {
      print("Not saved");
    }
  }

  // @override
  // void initState() {
  //   super.initState();
  //   _loadSavedUsername();
  // }

  Future<void> getCrecheData(BuildContext mContext, String userName,
      String password, String appToken, String userRole) async {
    var response = await CrecehDataDownloadApi()
        .crechedatadownloadapi(userName, password, appToken);
    if (response.statusCode == 200) {
      Map<String, dynamic> resultMap = jsonDecode(response.body);
      await CrecheDataHelper().downloadCrecheData(resultMap);
      await callVillageProfiledata(
          mContext, userName, password, appToken, userRole);
    } else {
      Navigator.pop(mContext);
      Validate().singleButtonPopup(
          Global.errorBodyToString(response.body, 'message'),
          'ok',
          false,
          context);
      // ScaffoldMessenger.of(mContext).showSnackBar(SnackBar(
      //     content: Text(Global.errorBodyToString(response.body, 'message'))));
    }
  }

  callVillageProfiledata(BuildContext mContext, String userName,
      String password, String appToken, String userRole) async {
    var network = await Validate().checkNetworkConnection();
    if (network) {
      var response = await VillageProfileMetaApi()
          .VillageProfileDownloadApi(userName, password, appToken);
      if (response.statusCode == 200) {
        await updateVillageProfiledata(response);
        await callMasterData(mContext, userName, password, appToken, userRole);
      } else if (response.statusCode == 401) {
        Navigator.pop(mContext);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove(Validate.Password);
        ScaffoldMessenger.of(mContext).showSnackBar(
          SnackBar(content: Text(CustomText.token_expired)),
        );
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (mContext) => LoginScreen(),
            ));
      } else {
        Navigator.pop(mContext);
        Validate().singleButtonPopup(
            Global.errorBodyToString(response.body, 'message'),
            CustomText.ok,
            false,
            mContext);
      }
    } else {
      Navigator.pop(mContext);
      Validate().singleButtonPopup(CustomText.nointernetconnectionavailable,
          CustomText.ok, false, mContext);
    }
  }

  Future<void> updateVillageProfiledata(Response value) async {
    try {
      Map<String, dynamic> resultMap = jsonDecode(value.body);
      print(" responce $resultMap");
      await VillageProfileResponseHelper()
          .villageProfileDataDownload(resultMap);
    } catch (e) {
      print("THE PROBLEM IS HERE: ${e.toString()}");
    }
  }
}
