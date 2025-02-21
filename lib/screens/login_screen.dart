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
import 'package:shishughar/database/database_helper.dart';
import 'package:shishughar/database/helper/auth_login_helper.dart';
import 'package:shishughar/database/helper/block_data_helper.dart';
import 'package:shishughar/database/helper/district_data_helper.dart';
import 'package:shishughar/database/helper/gram_panchayat_data_helper.dart';
import 'package:shishughar/database/helper/mapping_login_helper.dart';
import 'package:shishughar/database/helper/master_stock_helper.dart';
import 'package:shishughar/database/helper/partner_stock_helper.dart';

import 'package:shishughar/database/helper/state_data_helper.dart';
import 'package:shishughar/database/helper/village_data_helper.dart';
import 'package:shishughar/model/apimodel/device_change_model.dart';
import 'package:shishughar/model/databasemodel/auth_model.dart';
import 'package:shishughar/model/apimodel/login_model.dart';
import 'package:shishughar/model/databasemodel/tabBlock_model.dart';
import 'package:shishughar/model/databasemodel/tabDistrict_model.dart';
import 'package:shishughar/model/databasemodel/tabGramPanchayat_model.dart';
import 'package:shishughar/model/databasemodel/tabVillage_model.dart';
import 'package:shishughar/model/databasemodel/tabstate_model.dart';
import 'package:shishughar/screens/reset_password_screen.dart';
import 'package:shishughar/style/styles.dart';
import 'package:shishughar/utils/device_services.dart';
import 'package:shishughar/utils/secure_storage.dart';
import 'package:shishughar/utils/validate.dart';
import 'package:toast/toast.dart';
import '../api/creche_data_api.dart';
import '../api/form_logic_api.dart';
import '../api/language_translation_api.dart';
import '../api/village_profile_meta_api.dart';
import '../custom_widget/double_button_dailog.dart';
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
import 'package:http/http.dart';

import 'dashboardscreen_new.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();

}

class _LoginScreenState extends State<LoginScreen> with WidgetsBindingObserver {
  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  String selectedlanguages = 'English';
  bool _isPasswordVisible = true;
  DateTime pre_backpress = DateTime.now();
  String? savedUsername;
  bool _keyboardVisible = false;
  String appVersionName = '';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FocusNode _focusNode = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  List<Translation> translats = [];

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
    _focusNode.dispose();
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
        key: _scaffoldKey,
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
                                      groupValue: selectedlanguages,
                                      onChanged: (value) {
                                        Validate().saveString(
                                            Validate.sLanguage, 'en');
                                        setState(() {
                                          selectedlanguages = value!;
                                        });
                                      },
                                      label: CustomText.English,
                                    ),
                                    Spacer(),
                                    CustomRadioButton(
                                      value: 'Hindi',
                                      groupValue: selectedlanguages,
                                      onChanged: (value) {
                                        Validate().saveString(
                                            Validate.sLanguage, 'hi');
                                        setState(() {
                                          selectedlanguages = value!;
                                        });
                                      },
                                      label: CustomText.Hindi,
                                    ),
                                    Spacer(),
                                    CustomRadioButton(
                                      value: 'Odiya',
                                      groupValue: selectedlanguages,
                                      onChanged: (value) {
                                        Validate().saveString(
                                            Validate.sLanguage, 'od');
                                        setState(() {
                                          selectedlanguages = value!;
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
                                focusNode: _focusNode,
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
                                focusNode: _focusNode2,
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
                                  } else if (passwordcontroller.text.isEmpty) {
                                    Validate().singleButtonPopup(
                                        'Password required',
                                        'ok',
                                        false,
                                        context);
                                  } else {
                                    if (_focusNode.hasFocus) {
                                      _focusNode.unfocus();
                                    }
                                    if (_focusNode2.hasFocus) {
                                      _focusNode2.unfocus();
                                    }
                                    await newLoginFlow(mobileController.text,
                                        passwordcontroller.text, context);
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
                                          text: " $appVersionName",
                                          style: Styles.black126P),
                                      Constants.baseUrl ==
                                              'https://uat.shishughar.in/api/'
                                          ? TextSpan(
                                              text: "  (UAT)",
                                              style: Styles.red125)
                                          : Constants.baseUrl ==
                                                  'https://shishughar.in/api/'
                                              ? TextSpan(
                                                  text: "",
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
      if (master.tabMasterStock != null) {
        await MasterStockHelper().insert(master.tabMasterStock!);
      }
      if (master.tabPartnerStock != null) {
        await PartnerStockHelper().insert(master.tabPartnerStock!);
      }
    }
  }

  Future<void> initLoginAuth(BuildContext mContext, LoginApiModel loginApiModel,
      String enterdUserName, String userName, String password) async {
    ////master user auth
    if (loginApiModel.fullName != null) {
      Validate().saveString(Validate.fullName, loginApiModel.fullName!);
    }
    if (loginApiModel.auth!.houseHoldNumber != null) {
      Validate()
          .saveInt(Validate.household, loginApiModel.auth!.houseHoldNumber!);
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
    }
  }

  Future<void> callApiLogicData(BuildContext mContext, String userName,
      String password, String token, String userRole) async {
    var logisResponce =
        await FormLogicApiService().fetchLogicData(userName, password, token);
    if (logisResponce.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(logisResponce.body);
      await initFormLogic(FormLogicApiModel.fromJson(responseData));
      await callMasterData(mContext, userName, password, token, userRole);
    } else {
      Navigator.pop(mContext);
      Validate().singleButtonPopup(
          Global.errorBodyToString(logisResponce.body, 'message'),
          'ok',
          false,
          context);
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
      if (userRole == CustomText.crecheSupervisor)
        await getCrecheData(mContext, userName, password, token, userRole);
      else
        await getCrecheDataCC(mContext, userName, password, token, userRole);
    } else {
      Navigator.pop(mContext);
      Validate().singleButtonPopup(
          Global.errorBodyToString(msterDataResponse.body, 'message'),
          'ok',
          false,
          context);
    }
  }

  Future<void> initTranslation(List<Translation>? translations) async {
    if (translations != null) {
      await TranslationDataHelper().insertTranslationLanguage(translations);
    } else {
      print("Not Insert translation data into the database");
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

  Future<void> getCrecheDataCC(BuildContext mContext, String userName,
      String password, String appToken, String userRole) async {
    var villageList = await VillageDataHelper().getTabVillageList();
    String villageListString = '';
    villageList.forEach((element) {
      if (Global.validString(villageListString)) {
        villageListString = '$villageListString,${element.name}';
      } else
        villageListString = '${element.name}';
    });
    var response = await CrecehDataDownloadApi().crechedatadownloadapiCC(
        villageListString, userName, password, appToken);
    if (response.statusCode == 200) {
      Map<String, dynamic> resultMap = jsonDecode(response.body);
      await CrecheDataHelper().downloadCrecheData(resultMap);
      await callVillageProfiledataCC(
          mContext, userName, password, appToken, userRole, villageListString);
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
        Validate().saveString(Validate.loginName, mobileController.text.trim());
        Validate().saveString(Validate.userName, userName);
        Validate().saveString(Validate.Password, password);
        SecureStorage.writeStringValue(Validate.Password, password);
        Validate().saveString(Validate.appToken, appToken);
        Validate().saveString(
            Validate.msterDownloadDateTime, Validate().currentDateTime());
        Navigator.pop(mContext);

        Navigator.pushReplacement(
            mContext,
            MaterialPageRoute(
              builder: (context) => DashboardScreen(index: 0),
            ));
      } else if (response.statusCode == 401) {
        Navigator.pop(mContext);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove(Validate.Password);
        ScaffoldMessenger.of(mContext).showSnackBar(
          SnackBar(content: Text(CustomText.token_expired)),
        );
        Navigator.pushReplacement(
            mContext,
            MaterialPageRoute(
              builder: (context) => LoginScreen(),
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

  callVillageProfiledataCC(
      BuildContext mContext,
      String userName,
      String password,
      String appToken,
      String userRole,
      String villageListString) async {
    var network = await Validate().checkNetworkConnection();
    if (network) {
      var response = await VillageProfileMetaApi().VillageProfileDownloadApiCC(
          villageListString, userName, password, appToken);
      if (response.statusCode == 200) {
        await updateVillageProfiledata(response);
        Validate().saveString(Validate.loginName, mobileController.text.trim());
        Validate().saveString(Validate.userName, userName);
        Validate().saveString(Validate.Password, password);
        SecureStorage.writeStringValue(Validate.Password, password);
        Validate().saveString(Validate.appToken, appToken);
        Validate().saveString(
            Validate.msterDownloadDateTime, Validate().currentDateTime());
        Navigator.pop(mContext);

        Navigator.pushReplacement(
            mContext,
            MaterialPageRoute(
              builder: (context) => DashboardScreen(index: 0),
            ));
      } else if (response.statusCode == 401) {
        Navigator.pop(mContext);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove(Validate.Password);
        ScaffoldMessenger.of(mContext).showSnackBar(
          SnackBar(content: Text(CustomText.token_expired)),
        );
        Navigator.pushReplacement(
            mContext,
            MaterialPageRoute(
              builder: (context) => LoginScreen(),
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

  Future<void> callApiTranslateData(
      LoginApiModel loginApiModel,
      String deviceId,
      BuildContext mContext,
      String userName,
      String password,
      String token,
      String enterdUserName) async {
    var translateResponce =
        await TranslationService().translateApi(userName, password, token);
    if (translateResponce.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(translateResponce.body);
      List<Translation>? translationList =
          TranslationModel.fromJson(responseData).translation;
      if (loginApiModel.auth!.isDeviceChanged == 1) {
        Navigator.pop(mContext);
        bool shouldProceed =
            await LoginToNewDevice(mContext, deviceId, translationList);
        if (shouldProceed) {
          await deviceChangeApiCall(mContext, deviceId, loginApiModel, userName,
              password, token, enterdUserName, translationList);
        }
      } else {
        var userName = await Validate().readString(Validate.loginName);
        if (userName != null) {
          Navigator.pop(mContext);
          Validate().saveString(Validate.Password, password);
          Validate().saveString(Validate.appToken, token);
          Navigator.pushReplacement(
              mContext,
              MaterialPageRoute(
                builder: (context) => DashboardScreen(
                  index: 0,
                ),
              ));
        } else {
          await initTranslation(translationList);
          await initLoginAuth(mContext, loginApiModel, enterdUserName,
              loginApiModel.auth!.username!, passwordcontroller.text.trim());
        }
      }
    } else {
      Navigator.pop(mContext);
      Validate().singleButtonPopup(
          Global.errorBodyToString(translateResponce.body, 'message'),
          'Ok',
          false,
          context);
    }
  }

  Future newLoginFlow(
      String username, String pass, BuildContext mContext) async {
    showLoaderDialog(mContext);
    String? deviceId = await DeviceService.gteDeviceInfo();

    var loginResponse = await LoginApiService().loginUser(
        username, pass, Global.validToString(deviceId), appVersionName);
    if (loginResponse.statusCode == 200) {
      LoginApiModel loginApiModel =
          LoginApiModel.fromJson(json.decode(loginResponse.body));
      await setUpLogin(loginApiModel, username, pass,
          Global.validToString(deviceId), mContext);
    } else {
      var lang = 'en';
      if (selectedlanguages == 'Hindi') {
        lang = 'hi';
      } else if (selectedlanguages == 'Odiya') {
        lang = 'od';
      }
      var errorString = Global.errorBodyToString(loginResponse.body, 'message');
      List<String> valueNames = [errorString, CustomText.ok];

      await TranslationDataHelper()
          .callTranslateString(valueNames)
          .then((value) => translats.addAll(value));
      print(
          "TRANSLATED ERROR STRING ====> ${Global.returnTrLable(translats, errorString, lang)}");
      Navigator.pop(mContext);
      Validate().singleButtonPopup(
          Global.returnTrLable(translats, errorString, lang),
          Global.returnTrLable(translats, CustomText.ok, lang),
          false,
          mContext);
    }
  }

  Future setUpLogin(LoginApiModel loginApiModel, String enterdUserName,
      String pass, String deviceId, BuildContext mContext) async {
    if (loginApiModel.auth != null) {
      if (loginApiModel.auth!.apiKey != null) {
        var key = loginApiModel.auth!.apiKey!;
        var secret = loginApiModel.auth!.apiSecret!;
        var token = 'token ' + key + ':' + secret;
        var oUserName = loginApiModel.auth!.username!;
        var backDateDataEntry = loginApiModel.auth!.backDateDataEntry!;
         Validate().saveString(Validate.date, backDateDataEntry);
        if (selectedlanguages == 'English') {
          Validate().saveString(Validate.sLanguage, 'en');
        } else if (selectedlanguages == 'Hindi') {
          Validate().saveString(Validate.sLanguage, 'hi');
        } else if (selectedlanguages == 'Odiya') {
          Validate().saveString(Validate.sLanguage, 'od');
        }

        await callApiTranslateData(loginApiModel, deviceId, mContext, oUserName,
            pass, token, enterdUserName);
      } else {
        Navigator.pop(mContext);
        Validate().singleButtonPopup(
            'Login information is not valid.', 'ok', false, mContext);
      }
    } else {
      Navigator.pop(mContext);
      Validate().singleButtonPopup(
          'Login information is not valid.', 'Ok', false, mContext);
    }
  }

  Future<void> deviceChangeApiCall(
      BuildContext mContext,
      String deviceId,
      LoginApiModel loginApiModel,
      String userName,
      String password,
      String token,
      String enterdUserName,
      List<Translation>? translates) async {
    showLoaderDialog(mContext);
    var deviceChangeResponse = await LoginApiService()
        .changeDeviceId(userName, password, deviceId, appVersionName);

    if (deviceChangeResponse.statusCode == 200) {
      DeviceChangeModel deviceChangeModel =
          DeviceChangeModel.fromJson(json.decode(deviceChangeResponse.body));
      if (deviceChangeModel.statusCode != null &&
          deviceChangeModel.statusCode!.statusCode == 200) {
        SharedPreferences pref = await SharedPreferences.getInstance();
        await pref.clear();
        await DatabaseHelper().deleteAllRecords();
        if (selectedlanguages == 'English') {
          Validate().saveString(Validate.sLanguage, 'en');
        } else if (selectedlanguages == 'Hindi') {
          Validate().saveString(Validate.sLanguage, 'hi');
        } else if (selectedlanguages == 'Odiya') {
          Validate().saveString(Validate.sLanguage, 'od');
        }
        await initTranslation(translates);
        await initLoginAuth(mContext, loginApiModel, enterdUserName,
            loginApiModel.auth!.username!, passwordcontroller.text.trim());
      } else {
        Navigator.pop(mContext);
        Validate().singleButtonPopup(
            Global.errorBodyToString(deviceChangeResponse.body, 'message'),
            'Ok',
            false,
            context);
      }
    } else {
      Navigator.pop(mContext);
      Validate().singleButtonPopup(
          Global.errorBodyToString(deviceChangeResponse.body, 'message'),
          'ok',
          false,
          context);
    }
  }

  Future<bool> LoginToNewDevice(BuildContext mContext, String deviceId,
      List<Translation>? labelControlls) async {
    var lng = await Validate().readString(Validate.sLanguage);
    var shouldProceed = await showDialog(
      context: mContext,
      builder: (context) {
        return DoubleButtonDailog(
          posButton: Global.returnTrLable(
              labelControlls!, CustomText.LogIn, Global.validToString(lng)),
          negButton: Global.returnTrLable(
              labelControlls, CustomText.Cancel, Global.validToString(lng)),
          message: Global.returnTrLable(labelControlls,
              CustomText.deviceChangeMsg, Global.validToString(lng)),
        );
      },
    );
    return shouldProceed;
  }
}
