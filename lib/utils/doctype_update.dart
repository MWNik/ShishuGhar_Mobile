import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shishughar/api/attendance_meta_api.dart';
import 'package:shishughar/api/cashBook_expenses_api.dart';
import 'package:shishughar/api/cashbook_receipt_api.dart';
import 'package:shishughar/api/child_Grievances_meta_api.dart';
import 'package:shishughar/api/child_enrolled_exit_api.dart';
import 'package:shishughar/api/child_event_meta_api.dart';
import 'package:shishughar/api/child_exit_meta_api.dart';
import 'package:shishughar/api/child_followup_meta_api.dart';
import 'package:shishughar/api/child_growth_meta_api.dart';
import 'package:shishughar/api/child_health_meta_api.dart';
import 'package:shishughar/api/child_hh_meta_api.dart';
import 'package:shishughar/api/child_immunization_meta_api.dart';
import 'package:shishughar/api/child_referral_meta_api.dart';
import 'package:shishughar/api/creche_Monitering_checkList_alm_api.dart';
import 'package:shishughar/api/creche_checkIn_api.dart';
import 'package:shishughar/api/creche_committie_meta_api.dart';
import 'package:shishughar/api/creche_monetering_checkList_cbm_api.dart';
import 'package:shishughar/api/creche_monitering_checklist_cc_api.dart';
import 'package:shishughar/api/creche_monitoring_api.dart';
import 'package:shishughar/api/form_logic_api.dart';
import 'package:shishughar/api/house_hold_fields_api.dart';
import 'package:shishughar/api/requisition_api.dart';
import 'package:shishughar/api/stock_api.dart';
import 'package:shishughar/api/village_profile_meta_api.dart';
import 'package:shishughar/custom_widget/custom_text.dart';
import 'package:shishughar/database/database_helper.dart';
import 'package:shishughar/database/helper/anthromentory/child_growth_meta_fields_helper.dart';
import 'package:shishughar/database/helper/cashbook/expences/cashbook_excepnces_meta_fileds_helper.dart';
import 'package:shishughar/database/helper/check_in/checkin_meta_helper.dart';
import 'package:shishughar/database/helper/child_attendence/child_attendance_field_helper.dart';
import 'package:shishughar/database/helper/child_event/child_event_meta_fields_helper.dart';
import 'package:shishughar/database/helper/child_exit/child_exit_meta_fields_helper.dart';
import 'package:shishughar/database/helper/child_gravience/child_grievances_field_helper.dart';
import 'package:shishughar/database/helper/child_health/child_health_meta_fields_helper.dart';
import 'package:shishughar/database/helper/child_immunization/child_immunization_meta_fileds_helper.dart';
import 'package:shishughar/database/helper/child_reffrel/child_refferal_fields_helper.dart';
import 'package:shishughar/database/helper/cmc_CC/creche_monitering_checklist_CC_fields_helper.dart';
import 'package:shishughar/database/helper/cmc_alm/creche_monitering_checkList_ALM_fields_helper.dart';
import 'package:shishughar/database/helper/cmc_cbm/creche_monitering_checklist_CBM_fields_helper.dart';
import 'package:shishughar/database/helper/creche_comite_meeting/creche_committe_fields_meta_helper.dart';
import 'package:shishughar/database/helper/creche_data_helper.dart';
import 'package:shishughar/database/helper/creche_monitoring/creche_monitoring_helper.dart';
import 'package:shishughar/database/helper/enrolled_children/enrolled_children_field_helper.dart';
import 'package:shishughar/database/helper/enrolled_exit_child/enrolled_exit_children_field_helper.dart';
import 'package:shishughar/database/helper/follow_up/child_followUp_fields_helper.dart';
import 'package:shishughar/database/helper/form_logic_helper.dart';
import 'package:shishughar/database/helper/house_field_item_helper.dart';
import 'package:shishughar/database/helper/requisition/requisition_fields_helper.dart';
import 'package:shishughar/database/helper/stock/stock_fields_helper.dart';
import 'package:shishughar/database/helper/village_profile/village_profiile_fileds_helper.dart';
import 'package:shishughar/model/apimodel/cashbook_expenses_fields_meta_model.dart';
import 'package:shishughar/model/apimodel/cashbook_receipt_fields_meta_model.dart';
import 'package:shishughar/model/apimodel/checkin_fields_meta_model.dart';
import 'package:shishughar/model/apimodel/child_Immunization_meta_fields_model.dart';
import 'package:shishughar/model/apimodel/child_attendance_field_model.dart';
import 'package:shishughar/model/apimodel/child_event_meta_fields_model.dart';
import 'package:shishughar/model/apimodel/child_exit_meta_fields_model.dart';
import 'package:shishughar/model/apimodel/child_followUp_meta_fields_model.dart';
import 'package:shishughar/model/apimodel/child_grievances_fields_model.dart';
import 'package:shishughar/model/apimodel/child_growth_meta_model.dart';
import 'package:shishughar/model/apimodel/child_health_meta_data_Api_Model.dart';
import 'package:shishughar/model/apimodel/child_referral_fields_model.dart';
import 'package:shishughar/model/apimodel/cmc_CC_Meta_fields_model.dart';
import 'package:shishughar/model/apimodel/cmc_cbm_meta_fields%20_model.dart';
import 'package:shishughar/model/apimodel/creche_committe_meta_fields_model.dart';
import 'package:shishughar/model/apimodel/creche_data_model.dart';
import 'package:shishughar/model/apimodel/creche_monitering_checklist_alm_fields_model.dart';
import 'package:shishughar/model/apimodel/creche_monitoring_meta_model.dart';
import 'package:shishughar/model/apimodel/enrolled_children_field_model.dart';
import 'package:shishughar/model/apimodel/enrolled_exit_field_model.dart';
import 'package:shishughar/model/apimodel/form_logic_api_model.dart';
import 'package:shishughar/model/apimodel/house_hold_field_model_api.dart';
import 'package:shishughar/model/apimodel/requisition_fields_meta_model.dart';
import 'package:shishughar/model/apimodel/stock_fields_meta_model.dart';
import 'package:shishughar/model/apimodel/translation_language_api_model.dart';
import 'package:shishughar/model/apimodel/village_profile_meta_fields_model.dart';
import 'package:shishughar/screens/login_screen.dart';
import 'package:shishughar/utils/globle_method.dart';
import 'package:shishughar/utils/secure_storage.dart';
import 'package:shishughar/utils/validate.dart';

class DoctypeUpdate {
  List<Translation> locationControlls;
  String lng;
  String role;
  bool mt;
  DoctypeUpdate(
      {required this.mt,
      required this.locationControlls,
      required this.lng,
      required this.role});
  int totalApiCount = 27;
  int downloadedApi = 0;
  late StateSetter dialogSetState;
  int loadingText = 0;

  Future<bool> callFieldData(BuildContext context) async {
    downloadedApi = 6;
    var network = await Validate().checkNetworkConnection();

    if (network) {
      // if (only == false)
      showLoaderDialog(context);
      var userName = await Validate().readString(Validate.userName);
      // var password = await Validate().readString(Validate.Password);
      var password = await SecureStorage.readStringValue(Validate.Password);
      var token = await Validate().readString(Validate.appToken);
      var response = await HouseHoldFieldsApiService()
          .houseHoldFieldsData(userName!, password!, token!);
      if (response.statusCode == 200) {
        HouseHoldFieldModel houseHoldFieldModel =
            HouseHoldFieldModel.fromJson(jsonDecode(response.body));
        await callInsertHouseHoldFields(houseHoldFieldModel);

        Validate().saveString(Validate.householdForm,
            houseHoldFieldModel.tabHousehold_Form!.modified!);
        Validate().saveString(Validate.householdChildForm,
            houseHoldFieldModel.tabHousehold_Child_Form!.modified!);
        Validate().saveString(
            Validate.doctypeUpdateTimeStamp, DateTime.now().toString());
        await callApiLogicData(userName, password, token, context);
        return true;
      }
      else if (response.statusCode == 401) {
        Navigator.pop(context);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove(Validate.Password);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(Global.returnTrLable(
                  locationControlls, CustomText.token_expired, lng!))),
        );
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (mContext) => LoginScreen(),
            ));
        return false;
      }
      else {
        Navigator.pop(context);
        Validate().singleButtonPopup(
            Global.errorBodyToString(response.body, 'message'),
            Global.returnTrLable(locationControlls, CustomText.ok, lng!),
            false,
            context);
        return false;
      }
    } else {
      Validate().singleButtonPopup(
          Global.returnTrLable(locationControlls,
              CustomText.nointernetconnectionavailable, lng!),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          context);
      return false;
    }
  }

  Future<void> callInsertHouseHoldFields(HouseHoldFieldModel items) async {
    await DatabaseHelper.database!.delete('tabhouseholdfield');
    if (items.tabHousehold_Form != null) {
      print("dataCount ${items.tabHousehold_Form!.fields!.length}");
      await HouseHoldFieldHelper()
          .insertHouseHoldField(items.tabHousehold_Form!.fields!);
    }
    if (items.tabHousehold_Child_Form != null) {
      print("dataCount Child ${items.tabHousehold_Child_Form!.fields!.length}");
      await HouseHoldFieldHelper()
          .insertHouseHoldField(items.tabHousehold_Child_Form!.fields!);
    }
  }

  Future<void> callApiLogicData(String userName, String password, String token,
      BuildContext context) async {
    downloadedApi = 7;
    updateLoadingText(dialogSetState);

    var logisResponce =
        await FormLogicApiService().fetchLogicData(userName, password, token);

    if (logisResponce.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(logisResponce.body);
      await initFormLogic(FormLogicApiModel.fromJson(responseData));

      await callEnrooledChildrenDataApi(userName, password, token, context);
    } else if (logisResponce.statusCode == 401) {
      Navigator.pop(context);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(Validate.Password);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(Global.returnTrLable(
                locationControlls, CustomText.token_expired, lng!))),
      );
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (mContext) => LoginScreen(),
          ));
    } else {
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.errorBodyToString(logisResponce.body, 'message'),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          context);
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

  Future<void> callEnrooledChildrenDataApi(String userName, String password,
      String token, BuildContext context) async {
    downloadedApi = 8;
    updateLoadingText(dialogSetState);
    var child_data = await ChildEnrolledDataMetaApi()
        .callChildHHMeta(userName, password, token);

    if (child_data.statusCode == 200) {
      EnrolledChildrenFieldModel childMetaModel =
          EnrolledChildrenFieldModel.fromJson(jsonDecode(child_data.body));

      Validate().saveString(Validate.childProfilemodifiedDate,
          childMetaModel.tabChild_HH_Meta_Form!.modified!);

      await callInsertEnrolledChildrendHHFields(childMetaModel);

      await callEnrolledExitMetaApi(userName, password, token, context);
    } else if (child_data.statusCode == 401) {
      Navigator.pop(context);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(Validate.Password);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(Global.returnTrLable(
                locationControlls, CustomText.token_expired, lng!))),
      );
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (mContext) => LoginScreen(),
          ));
    } else {
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.errorBodyToString(child_data.body, 'message'),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          context);
    }
  }

  Future<void> callInsertEnrolledChildrendHHFields(
      EnrolledChildrenFieldModel items) async {
    await DatabaseHelper.database!.delete('tabchildprofilefield');
    if (items.tabChild_HH_Meta_Form != null) {
      print("dataCount ChildHH${items.tabChild_HH_Meta_Form!.fields!.length}");
      await EnrolledChildrenFieldHelper()
          .insertsChildrenEnrolledField(items.tabChild_HH_Meta_Form!.fields!);
    }
    if (items.tabEntitlement_child_table != null) {
      print(
          "dataCount Child${items.tabEntitlement_child_table!.fields!.length}");
      await EnrolledChildrenFieldHelper().insertsChildrenEnrolledField(
          items.tabEntitlement_child_table!.fields!);
    }
    if (items.tabSpecially_abled_child_table != null) {
      print(
          "dataCount Child${items.tabSpecially_abled_child_table!.fields!.length}");
      await EnrolledChildrenFieldHelper().insertsChildrenEnrolledField(
          items.tabSpecially_abled_child_table!.fields!);
    }
  }

  Future<void> callEnrolledExitMetaApi(String userName, String password,
      String token, BuildContext context) async {
    downloadedApi = 9;
    updateLoadingText(dialogSetState);
    var child_data = await ChildEnrolledExitApi()
        .callChildEnrolledExitMetaApi(userName, password, token);

    if (child_data.statusCode == 200) {
      EnrolledExitChildrenFieldModel childMetaModel =
          EnrolledExitChildrenFieldModel.fromJson(jsonDecode(child_data.body));

      Validate().saveString(Validate.childEnrolledExitmodifiedData,
          childMetaModel.tabChild_Enrollment_and_Exit!.modified!);

      await callInsertEnrolledExitCMeta(childMetaModel);

      await callCreshDataApi(userName, password, token, context);
    } else if (child_data.statusCode == 401) {
      Navigator.pop(context);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(Validate.Password);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(Global.returnTrLable(
                locationControlls, CustomText.token_expired, lng!))),
      );
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (mContext) => LoginScreen(),
          ));
    } else {
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.errorBodyToString(child_data.body, 'message'),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          context);
    }
  }

  Future<void> callInsertEnrolledExitCMeta(
      EnrolledExitChildrenFieldModel items) async {
    await DatabaseHelper.database!.delete('tab_enrolled_exit_meta');
    if (items.tabChild_Enrollment_and_Exit != null) {
      await EnrolledExitChildrenFieldHelper().insertsEnrolledExitField(
          items.tabChild_Enrollment_and_Exit!.fields!);
    }
  }

  Future<void> callCreshDataApi(String userName, String password, String token,
      BuildContext context) async {
    downloadedApi = 10;
    updateLoadingText(dialogSetState);
    var cresheData = await HouseHoldFieldsApiService()
        .syncCrecheData(userName, password, token);
    if (cresheData.statusCode == 200) {
      CrecheFieldModel houseHoldFieldModel =
          CrecheFieldModel.fromJson(jsonDecode(cresheData.body));

      Validate().saveString(Validate.creChemodifiedDate,
          houseHoldFieldModel.tabCreche!.modified!);

      await callInsertCrecheFields(houseHoldFieldModel);

      await callAttendanceData(userName, password, token, context);
    } else if (cresheData.statusCode == 401) {
      Navigator.pop(context);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(Validate.Password);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(Global.returnTrLable(
                locationControlls, CustomText.token_expired, lng!))),
      );
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (mContext) => LoginScreen(),
          ));
    } else {
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.errorBodyToString(cresheData.body, 'message'),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          context);
    }
  }

  Future<void> callInsertCrecheFields(CrecheFieldModel items) async {
    await DatabaseHelper.database!.delete('tabCrechefield');
    if (items.tabCreche != null) {
      print("dataCount ${items.tabCreche!.fields!.length}");
      await CrecheFieldHelper().insertCrecheField(items.tabCreche!.fields!);
    }
    if (items.tabCreche_caregiver != null) {
      print("dataCount Creche ${items.tabCreche_caregiver!.fields!.length}");
      await CrecheFieldHelper()
          .insertCrecheField(items.tabCreche_caregiver!.fields!);
    }
  }

  callAttendanceData(String userName, String password, String token,
      BuildContext context) async {
    downloadedApi = 11;
    updateLoadingText(dialogSetState);
    var responce =
        await AttendanceMetaApi().callAttendanceData(userName, password, token);
    if (responce.statusCode == 200) {
      ChildAttendanceFieldModel attendanceData =
          ChildAttendanceFieldModel.fromJson(jsonDecode(responce.body));

      await callInsertChildAttendance(attendanceData);
      Validate().saveString(Validate.ChildAttendeceUpdateDate,
          attendanceData.tabChild_Attendance!.modified!);

      await callAnthropomertryData(userName, password, token, context);
    } else if (responce.statusCode == 401) {
      Navigator.pop(context);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(Validate.Password);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(Global.returnTrLable(
                locationControlls, CustomText.token_expired, lng!))),
      );
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (mContext) => LoginScreen(),
          ));
    } else {
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.errorBodyToString(responce.body, 'message'),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          context);
    }
  }

  Future<void> callInsertChildAttendance(
      ChildAttendanceFieldModel items) async {
    await DatabaseHelper.database!.delete('tabChildAttendance');
    if (items.tabChild_Attendance != null) {
      await ChildAttendanceFieldHelper()
          .insertChildAttendanceField(items.tabChild_Attendance!.fields!);
    }
    if (items.tabChild_Attendance_List != null) {
      await ChildAttendanceFieldHelper()
          .insertChildAttendanceField(items.tabChild_Attendance_List!.fields!);
    }
  }

  callAnthropomertryData(String userName, String password, String token,
      BuildContext context) async {
    downloadedApi = 12;
    updateLoadingText(dialogSetState);
    var responce = await ChildGrowthMetaApi()
        .callChildGrowthMeta(userName, password, token);
    if (responce.statusCode == 200) {
      ChildGrowthMetaFieldsModel childGrowthMetaFields =
          ChildGrowthMetaFieldsModel.fromJson(jsonDecode(responce.body));

      // Validate().saveString(Validate.ChildAntroUpdateDate,
      //     childGrowthMetaFields.tabChild_Growth_Meta!.modified!);

      await callInsertAnthropomertry(childGrowthMetaFields);

      callChildEventData(userName, password, token, context);
    } else if (responce.statusCode == 401) {
      Navigator.pop(context);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(Validate.Password);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(Global.returnTrLable(
                locationControlls, CustomText.token_expired, lng!))),
      );
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (mContext) => LoginScreen(),
          ));
    } else {
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.errorBodyToString(responce.body, 'message'),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          context);
    }
  }

  Future<void> callInsertAnthropomertry(
      ChildGrowthMetaFieldsModel items) async {
    await DatabaseHelper.database!.delete('tabChildGrowthMeta');
    if (items.tabChild_Growth_Meta != null) {
      await ChildGrowthMetaFieldsHelper()
          .insertChildGrowthMeta(items.tabChild_Growth_Meta!.fields!);
    }
    if (items.tabAnthropromatic_Data != null) {
      await ChildGrowthMetaFieldsHelper()
          .insertChildGrowthMeta(items.tabAnthropromatic_Data!.fields!);
    }
  }

  callChildEventData(String userName, String password, String token,
      BuildContext context) async {
    downloadedApi = 13;
    updateLoadingText(dialogSetState);
    var responce =
        await ChildEventMetaApi().callChildEventMeta(userName, password, token);
    if (responce.statusCode == 200) {
      ChildEventMetaFieldsModel childEventMetaFields =
          ChildEventMetaFieldsModel.fromJson(jsonDecode(responce.body));

      await callInsertChildEvent(childEventMetaFields);

      Validate().saveString(Validate.childEventUpdateDate,
          childEventMetaFields.tabChild_Event_Meta!.modified!);

      await callChildImmunizationData(userName, password, token, context);
    } else if (responce.statusCode == 401) {
      Navigator.pop(context);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(Validate.Password);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(Global.returnTrLable(
                locationControlls, CustomText.token_expired, lng!))),
      );
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (mContext) => LoginScreen(),
          ));
    } else {
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.errorBodyToString(responce.body, 'message'),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          context);
    }
  }

  Future<void> callInsertChildEvent(ChildEventMetaFieldsModel items) async {
    await DatabaseHelper.database!.delete('tab_child_event');
    if (items.tabChild_Event_Meta != null) {
      await ChildEventMetaFieldsHelper()
          .insertChildEventMeta(items.tabChild_Event_Meta!.fields!);
    }
  }

  callChildImmunizationData(String userName, String password, String token,
      BuildContext context) async {
    downloadedApi = 14;
    updateLoadingText(dialogSetState);
    var responce = await ChildImmunizationMetaApi()
        .callChildImmunizationMeta(userName, password, token);
    if (responce.statusCode == 200) {
      ChildImmunizationMetaFieldsModel childImmunizationMetaFields =
          ChildImmunizationMetaFieldsModel.fromJson(jsonDecode(responce.body));

      await callInsertChildImmunization(childImmunizationMetaFields);
      Validate().saveString(Validate.ChildImmunizationUpdateDate,
          childImmunizationMetaFields.tabChild_Immunization_Meta!.modified!);

      await callChildHealthData(userName, password, token, context);
    } else if (responce.statusCode == 401) {
      Navigator.pop(context);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(Validate.Password);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(Global.returnTrLable(
                locationControlls, CustomText.token_expired, lng!))),
      );
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (mContext) => LoginScreen(),
          ));
    } else {
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.errorBodyToString(responce.body, 'message'),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          context);
    }
  }

  Future<void> callInsertChildImmunization(
      ChildImmunizationMetaFieldsModel items) async {
    await DatabaseHelper.database!.delete('tab_child_immunization');
    if (items.tabChild_Immunization_Meta != null) {
      await ChildImmunizationMetaFieldsHelper().insertChildImmunizationMeta(
          items.tabChild_Immunization_Meta!.fields!);
    }
    if (items.tabChild_Vaccine_Details != null) {
      await ChildImmunizationMetaFieldsHelper()
          .insertChildImmunizationMeta(items.tabChild_Vaccine_Details!.fields!);
    }
  }

  callChildHealthData(String userName, String password, String token,
      BuildContext context) async {
    downloadedApi = 15;
    updateLoadingText(dialogSetState);
    var responce = await ChildHealthDataMetaApi()
        .callChildHealthMeta(userName, password, token);
    if (responce.statusCode == 200) {
      ChildHelthMetaFieldsModel childHealthMetaFields =
          ChildHelthMetaFieldsModel.fromJson(jsonDecode(responce.body));

      await callInsertChildHealth(childHealthMetaFields);
      Validate().saveString(Validate.ChildHealthUpdateDate,
          childHealthMetaFields.tabChild_Health_Meta!.modified!);

      callChildExitMeta(userName, password, token, context);
    } else if (responce.statusCode == 401) {
      Navigator.pop(context);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(Validate.Password);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(Global.returnTrLable(
                locationControlls, CustomText.token_expired, lng!))),
      );
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (mContext) => LoginScreen(),
          ));
    } else {
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.errorBodyToString(responce.body, 'message'),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          context);
    }
  }

  Future<void> callInsertChildHealth(ChildHelthMetaFieldsModel items) async {
    await DatabaseHelper.database!.delete('tab_child_health');
    if (items.tabChild_Health_Meta != null) {
      await ChildHealthMetaFieldsHelper()
          .insertChildHealthMeta(items.tabChild_Health_Meta!.fields!);
    }
  }

  callChildExitMeta(String userName, String password, String token,
      BuildContext context) async {
    downloadedApi = 16;
    updateLoadingText(dialogSetState);
    var responce =
        await ChildExitMetaApi().callChidExitMeta(userName, password, token);
    if (responce.statusCode == 200) {
      ChildExitMetaFieldsModel childExitMetaFields =
          ChildExitMetaFieldsModel.fromJson(jsonDecode(responce.body));

      await callInsertChildExit(childExitMetaFields);

      Validate().saveString(Validate.childExitUpdatedDate,
          childExitMetaFields.tabChild_Exit_Meta!.modified!);

      await callChildGrievancesMeta(userName, password, token, context);
    } else if (responce.statusCode == 401) {
      Navigator.pop(context);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(Validate.Password);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(Global.returnTrLable(
                locationControlls, CustomText.token_expired, lng!))),
      );
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (mContext) => LoginScreen(),
          ));
    } else {
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.errorBodyToString(responce.body, 'message'),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          context);
    }
  }

  Future<void> callInsertChildExit(ChildExitMetaFieldsModel items) async {
    await DatabaseHelper.database!.delete('tab_child_exit');
    if (items.tabChild_Exit_Meta != null) {
      await ChildExitMetaFieldsHelper()
          .insertChildExitMeta(items.tabChild_Exit_Meta!.fields!);
    }
  }

  callChildGrievancesMeta(String userName, String password, String token,
      BuildContext context) async {
    downloadedApi = 17;
    updateLoadingText(dialogSetState);
    var responce = await ChildGrievancesMetaApi()
        .callChildGrievancesMeta(userName, password, token);
    if (responce.statusCode == 200) {
      ChildGrievancesMetaFieldsModel childExitMetaFields =
          ChildGrievancesMetaFieldsModel.fromJson(jsonDecode(responce.body));

      await callInsertChildGrievances(childExitMetaFields);

      Validate().saveString(Validate.childGravienceUpdatedDate,
          childExitMetaFields.tabChild_Grievances_Meta!.modified!);

      await callChildReffrelMeta(userName, password, token, context);
    } else if (responce.statusCode == 401) {
      Navigator.pop(context);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(Validate.Password);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(Global.returnTrLable(
                locationControlls, CustomText.token_expired, lng!))),
      );
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (mContext) => LoginScreen(),
          ));
    } else {
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.errorBodyToString(responce.body, 'message'),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          context);
    }
  }

  Future<void> callInsertChildGrievances(
      ChildGrievancesMetaFieldsModel items) async {
    await DatabaseHelper.database!.delete('tab_child_grievances');
    if (items.tabChild_Grievances_Meta != null) {
      await ChildGrievancesMetaFieldsHelper()
          .insertChildGrievancesMeta(items.tabChild_Grievances_Meta!.fields!);
    }
  }

  callChildReffrelMeta(String userName, String password, String token,
      BuildContext context) async {
    downloadedApi = 18;
    updateLoadingText(dialogSetState);
    var responce = await ChildReferralMetaApi()
        .callChildReferralMeta(userName, password, token);
    if (responce.statusCode == 200) {
      ChildReferralMetaFieldsModel childFollowUpMetaFields =
          ChildReferralMetaFieldsModel.fromJson(jsonDecode(responce.body));

      await callInsertChildReferral(childFollowUpMetaFields);

      Validate().saveString(Validate.childReferralUpdatedDate,
          childFollowUpMetaFields.tabChild_referral_Meta!.modified!);

      await callChildFollowUpMeta(userName, password, token, context);
    } else if (responce.statusCode == 401) {
      Navigator.pop(context);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(Validate.Password);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(Global.returnTrLable(
                locationControlls, CustomText.token_expired, lng!))),
      );
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (mContext) => LoginScreen(),
          ));
    } else {
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.errorBodyToString(responce.body, 'message'),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          context);
    }
  }

  Future<void> callInsertChildReferral(
      ChildReferralMetaFieldsModel items) async {
    await DatabaseHelper.database!.delete('tab_child_referral');
    if (items.tabChild_referral_Meta != null) {
      await ChildReferralFieldsHelper()
          .insertChildFollowUpMeta(items.tabChild_referral_Meta!.fields!);
    }

    if (items.tabDiagnosis_child_table != null) {
      await ChildReferralFieldsHelper()
          .insertChildFollowUpMeta(items.tabDiagnosis_child_table!.fields!);
    }

    if (items.tabReferral_child_table != null) {
      await ChildReferralFieldsHelper()
          .insertChildFollowUpMeta(items.tabReferral_child_table!.fields!);
    }

    if (items.tabTreatment_child_table != null) {
      await ChildReferralFieldsHelper()
          .insertChildFollowUpMeta(items.tabTreatment_child_table!.fields!);
    }

    if (items.tabTreatment_NRC_child_table != null) {
      await ChildReferralFieldsHelper()
          .insertChildFollowUpMeta(items.tabTreatment_NRC_child_table!.fields!);
    }
  }

  callChildFollowUpMeta(String userName, String password, String token,
      BuildContext context) async {
    downloadedApi = 19;
    updateLoadingText(dialogSetState);
    var responce = await ChildFollowUpMetaApi()
        .callChildFollowUpMeta(userName, password, token);
    if (responce.statusCode == 200) {
      ChildFollowUpMetaFieldsModel childFollowUpMetaFields =
          ChildFollowUpMetaFieldsModel.fromJson(jsonDecode(responce.body));

      await callInsertChildFollowUp(childFollowUpMetaFields);

      Validate().saveString(Validate.childFollowUpUpdatedDate,
          childFollowUpMetaFields.tabChild_FollowUp_Meta!.modified!);

      await callCrecheCommitteMeta(userName, password, token, context);
    } else if (responce.statusCode == 401) {
      Navigator.pop(context);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(Validate.Password);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(Global.returnTrLable(
                locationControlls, CustomText.token_expired, lng!))),
      );
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (mContext) => LoginScreen(),
          ));
    } else {
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.errorBodyToString(responce.body, 'message'),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          context);
    }
  }

  Future<void> callInsertChildFollowUp(
      ChildFollowUpMetaFieldsModel items) async {
    await DatabaseHelper.database!.delete('tab_child_followup');
    if (items.tabChild_FollowUp_Meta != null) {
      await ChildFollowUpFieldsHelper()
          .insertChildFollowUpMeta(items.tabChild_FollowUp_Meta!.fields!);
    }
  }

  callCrecheCommitteMeta(String userName, String password, String token,
      BuildContext context) async {
    downloadedApi = 20;
    updateLoadingText(dialogSetState);
    var responce = await CrecheCommitteeMeetingMetaApi()
        .callCrecheCommitteeMeetingMeta(userName, password, token);
    if (responce.statusCode == 200) {
      CrecheCommitteFieldsMetaModel crecheCommitteMetaFields =
          CrecheCommitteFieldsMetaModel.fromJson(jsonDecode(responce.body));

      await callInsertCrecheCommitte(crecheCommitteMetaFields);

      Validate().saveString(Validate.crecheCommitteUpdateDate,
          crecheCommitteMetaFields.tabChild_creche_committe_Meta!.modified!);

      await callCashBookExpensesMetaApi(userName, password, token, context);
    } else if (responce.statusCode == 401) {
      Navigator.pop(context);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(Validate.Password);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(Global.returnTrLable(
                locationControlls, CustomText.token_expired, lng!))),
      );
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (mContext) => LoginScreen(),
          ));
    } else {
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.errorBodyToString(responce.body, 'message'),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          context);
    }
  }

  Future<void> callInsertCrecheCommitte(
      CrecheCommitteFieldsMetaModel items) async {
    await DatabaseHelper.database!.delete('tab_creche_committe');
    if (items.tabChild_creche_committe_Meta != null) {
      await CrecheCommitteFieldsMetaHelper().insertCrecheCommitteMeta(
          items.tabChild_creche_committe_Meta!.fields!);
    }
    if (items.tabAttendees_child_table != null) {
      await CrecheCommitteFieldsMetaHelper()
          .insertCrecheCommitteMeta(items.tabAttendees_child_table!.fields!);
    }
  }

  callCashBookExpensesMetaApi(String userName, String password, String token,
      BuildContext context) async {
    downloadedApi = 21;
    updateLoadingText(dialogSetState);
    var responce = await CashBookExpensesApi()
        .callCashBookExpensesMeta(userName, password, token);
    if (responce.statusCode == 200) {
      CashBookExpensesFieldsMetaModel cashbookExpensesMetaFields =
          CashBookExpensesFieldsMetaModel.fromJson(jsonDecode(responce.body));

      await callInsertCashBookExpensesMeta(cashbookExpensesMetaFields);

      Validate().saveString(Validate.cashbookExpencesMetaUpdateDate,
          cashbookExpensesMetaFields.tab_cashbook_expenses!.modified!);

      await checkinFieldsMeta(userName, password, token, context);
    } else if (responce.statusCode == 401) {
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.returnTrLable(
              locationControlls, CustomText.token_expired, lng!),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          context);
    } else {
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.errorBodyToString(responce.body, 'message'),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          context);
    }
  }

  Future<void> callInsertCashBookExpensesMeta(
      CashBookExpensesFieldsMetaModel items) async {
    await DatabaseHelper.database!.delete('tab_cashbook_expences_fields');
    if (items.tab_cashbook_expenses != null) {
      await CashbookExpencesMetaFieldsHelper()
          .insertCashBookMeta(items.tab_cashbook_expenses!.fields!);
    }
  }

  checkinFieldsMeta(String userName, String password, String token,
      BuildContext context) async {
    downloadedApi = 22;
    updateLoadingText(dialogSetState);
    var responce =
        await CrecheCheckInApi().checkInMeta(userName, password, token);
    if (responce.statusCode == 200) {
      CheckInFieldsMetaModel checkInMetaFields =
          CheckInFieldsMetaModel.fromJson(jsonDecode(responce.body));

      await callInsertCheckInFields(checkInMetaFields);

      Validate().saveString(Validate.chechInUpdateDate,
          checkInMetaFields.tab_checkin_meta!.modified!);

      // await callCashBookReceiptMetaApi(userName, password, token);

      await villageProfileMetaApi(userName, password, token, context);
    } else if (responce.statusCode == 401) {
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.returnTrLable(
              locationControlls, CustomText.token_expired, lng!),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          context);
    } else {
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.errorBodyToString(responce.body, 'message'),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          context);
    }
  }

  Future<void> callInsertCheckInFields(CheckInFieldsMetaModel items) async {
    await DatabaseHelper.database!.delete('tab_checkin_meta');
    if (items.tab_checkin_meta != null) {
      await CheckInMetaHelper().insertCheckin(items.tab_checkin_meta!.fields!);
    }
    if (items.tab_visit_purpose != null) {
      await CheckInMetaHelper().insertCheckin(items.tab_visit_purpose!.fields!);
    }
  }

  villageProfileMetaApi(String userName, String password, String token,
      BuildContext context) async {
    downloadedApi = 23;
    updateLoadingText(dialogSetState);
    var responce = await VillageProfileMetaApi()
        .callVillageProfileMeta(userName, password, token);
    if (responce.statusCode == 200) {
      VillageProfileMetaFieldsModel villageProfileMetaFields =
          VillageProfileMetaFieldsModel.fromJson(jsonDecode(responce.body));

      await callInsertVillageProfileMeta(villageProfileMetaFields);

      Validate().saveString(Validate.villageProfileUpdateDate,
          villageProfileMetaFields.tab_village!.modified!);

      await stockMetaData(userName, password, token, context);
      // await callCashBookReceiptMetaApi(userName, password, token);
    } else if (responce.statusCode == 401) {
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.returnTrLable(
              locationControlls, CustomText.token_expired, lng!),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          context);
    } else {
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.errorBodyToString(responce.body, 'message'),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          context);
    }
  }

  Future<void> callInsertVillageProfileMeta(
      VillageProfileMetaFieldsModel items) async {
    await DatabaseHelper.database!.delete('tab_village_profile_meta');
    if (items.tab_village != null) {
      await VillageProfileFieldsHelper()
          .insertVillageProfile(items.tab_village!.fields!);
    }
    if (items.tab_demographic_detail != null) {
      await VillageProfileFieldsHelper()
          .insertVillageProfile(items.tab_demographic_detail!.fields!);
    }
    if (items.tab_caste_child != null) {
      await VillageProfileFieldsHelper()
          .insertVillageProfile(items.tab_caste_child!.fields!);
    }
  }

  stockMetaData(String userName, String password, String token,
      BuildContext context) async {
    downloadedApi = 24;
    updateLoadingText(dialogSetState);
    var responce = await StockApi().stockMetaApi(userName, password, token);
    if (responce.statusCode == 200) {
      StockFieldsMetaModel villageProfileMetaFields =
          StockFieldsMetaModel.fromJson(jsonDecode(responce.body));

      await calllInsertStockMetaData(villageProfileMetaFields);

      Validate().saveString(Validate.stockmetaUpdateDate,
          villageProfileMetaFields.tab_stock_meta!.modified!);

      await requisitionMetaData(userName, password, token, context);
    } else if (responce.statusCode == 401) {
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.returnTrLable(
              locationControlls, CustomText.token_expired, lng!),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          context);
    } else {
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.errorBodyToString(responce.body, 'message'),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          context);
    }
  }

  Future<void> calllInsertStockMetaData(StockFieldsMetaModel items) async {
    await DatabaseHelper.database!.delete('tabCreche_stock_fields');
    if (items.tab_stock_meta != null) {
      await StockFieldHelper().insertStock(items.tab_stock_meta!.fields!);
    }
    if (items.tabStock_child_table != null) {
      await StockFieldHelper().insertStock(items.tabStock_child_table!.fields!);
    }
  }

  requisitionMetaData(String userName, String password, String token,
      BuildContext context) async {
    downloadedApi = 25;
    updateLoadingText(dialogSetState);
    var responce =
        await RequisitionApi().requisitionMetaApi(userName, password, token);
    if (responce.statusCode == 200) {
      RequisitionFieldsMetaModel requisitionMetaFields =
          RequisitionFieldsMetaModel.fromJson(jsonDecode(responce.body));

      await callInsertRequisitionMetaData(requisitionMetaFields);

      Validate().saveString(Validate.requisitionMetaUpdateDate,
          requisitionMetaFields.tab_requisition_meta!.modified!);

      await callCashBookReceiptMetaApi(userName, password, token, context);
    } else if (responce.statusCode == 401) {
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.returnTrLable(
              locationControlls, CustomText.token_expired, lng!),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          context);
    } else {
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.errorBodyToString(responce.body, 'message'),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          context);
    }
  }

  Future<void> callInsertRequisitionMetaData(
      RequisitionFieldsMetaModel items) async {
    await DatabaseHelper.database!.delete('tabCreche_requisition_fields');
    if (items.tab_requisition_meta != null) {
      await RequisitionFieldsHelper()
          .insertRequsiition(items.tab_requisition_meta!.fields!);
    }
    if (items.tab_requisition_child_table != null) {
      await RequisitionFieldsHelper()
          .insertRequsiition(items.tab_requisition_child_table!.fields!);
    }
  }

  callCashBookReceiptMetaApi(String userName, String password, String token,
      BuildContext context) async {
    downloadedApi = 26;
    updateLoadingText(dialogSetState);
    var responce = await CashBookReceiptApi()
        .callCashBookReceiptMeta(userName, password, token);
    if (responce.statusCode == 200) {
      CashBookReceiptFieldsMetaModel cashbookReceiptMetaFields =
          CashBookReceiptFieldsMetaModel.fromJson(jsonDecode(responce.body));

      await callInsertCashBookreceiptMeta(cashbookReceiptMetaFields);

      // Validate().saveString(Validate.cashbookRecieptMetaUpdateDate,
      //     cashbookReceiptMetaFields.tab_cashbook_receipt!.modified!);
      if (role == 'Cluster Coordinator') {
        await callCMCCCMetaApi(userName, password, token, context);
      } else if (role == 'Creche Supervisor') {
        await crecheMonitoringApiMeta(userName, password, token, context);
      } else if (role == 'Accounts and Logistics Manager') {
        await callCMCALMMetaApi(userName, password, token, context);
      } else {
        await callCMCCBMMetaApi(userName, password, token, context);
      }
      // Navigator.pop(context);
    } else if (responce.statusCode == 401) {
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.returnTrLable(
              locationControlls, CustomText.token_expired, lng!),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          context);
    } else {
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.errorBodyToString(responce.body, 'message'),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          context);
    }
  }

  Future<void> callInsertCashBookreceiptMeta(
      CashBookReceiptFieldsMetaModel items) async {
    await DatabaseHelper.database!.delete('tab_cashbook_receipts_fields');
    if (items.tab_cashbook_receipt != null) {
      await CashbookExpencesMetaFieldsHelper()
          .insertCashBookReceipt(items.tab_cashbook_receipt!.fields!);
    }
  }

  callCMCCCMetaApi(String userName, String password, String token,
      BuildContext context) async {
    downloadedApi = 27;
    updateLoadingText(dialogSetState);
    var responce = await CrecheMonetringCheckListCCApi()
        .cmcCCMetaApi(userName, password, token);
    if (responce.statusCode == 200) {
      CmcCCMetaFieldsModel cmcCCMEtaFields =
          CmcCCMetaFieldsModel.fromJson(jsonDecode(responce.body));

      await callInsertcmcCCData(cmcCCMEtaFields);
      Navigator.pop(context);
      Validate().saveString(
          Validate.doctypeUpdateTimeStamp, DateTime.now().toString());

      Validate().singleButtonPopup(
          Global.returnTrLable(
              locationControlls, CustomText.doctypeUpdated, lng),
          Global.returnTrLable(locationControlls, CustomText.ok, lng),
          false,
          context);
    } else if (responce.statusCode == 401) {
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.returnTrLable(
              locationControlls, CustomText.token_expired, lng!),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          context);
    } else {
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.errorBodyToString(responce.body, 'message'),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          context);
    }
  }

  Future<void> callInsertcmcCCData(CmcCCMetaFieldsModel items) async {
    await DatabaseHelper.database!.delete('tabCreche_Monitering_CheckList_CC');
    if (items.tabCreche_Monitoring_CheckList_CC != null) {
      await CrecheMoniteringCheckListCCFieldsHelper()
          .insertcmcCCMeta(items.tabCreche_Monitoring_CheckList_CC!.fields!);
    }
  }

  Future<void> crecheMonitoringApiMeta(String userName, String password,
      String token, BuildContext context) async {
    downloadedApi = 27;
    updateLoadingText(dialogSetState);
    final response = await CrecheMonitoringApi()
        .getMetaData(username: userName, password: password, appToken: token);

    if (response.statusCode == 200) {
      final childExitMetaFields =
          CrecheMonitoringMetaModel.fromJson(jsonDecode(response.body));

      await callInsertCrecheMonitoringMeta(childExitMetaFields);
      Navigator.pop(context);
      Validate().saveString(
          Validate.doctypeUpdateTimeStamp, DateTime.now().toString());

      Validate().singleButtonPopup(
          Global.returnTrLable(
              locationControlls, CustomText.master_data_download, lng),
          Global.returnTrLable(locationControlls, CustomText.ok, lng),
          false,
          context);
    } else if (response.statusCode == 401) {
      Navigator.pop(context);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(Validate.Password);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(Global.returnTrLable(
                locationControlls, CustomText.token_expired, lng!))),
      );
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (mContext) => LoginScreen(),
          ));
    } else {
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.errorBodyToString(response.body, 'message'),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          context);
    }
  }

  Future<void> callInsertCrecheMonitoringMeta(
      CrecheMonitoringMetaModel items) async {
    await DatabaseHelper.database!.delete('tabCrecheMonitorMeta');

    if (items.meta == null) return;

    await CrecheMonitoringFieldHelper()
        .insertCrecheMonitorFields(items.meta!.fields!);
  }

  callCMCALMMetaApi(String userName, String password, String token,
      BuildContext context) async {
    downloadedApi = 27;
    updateLoadingText(dialogSetState);
    var responce = await CrecheMonetringCheckListALMApi()
        .cmcALMMetaApi(userName, password, token);
    if (responce.statusCode == 200) {
      CmcALMMetaFieldsModel cmcALMMEtaFields =
          CmcALMMetaFieldsModel.fromJson(jsonDecode(responce.body));

      await callInsertcmcALMData(cmcALMMEtaFields);
      Navigator.pop(context);
      Validate().saveString(
          Validate.doctypeUpdateTimeStamp, DateTime.now().toString());

      Validate().singleButtonPopup(
          Global.returnTrLable(
              locationControlls, CustomText.doctypeUpdated, lng),
          Global.returnTrLable(locationControlls, CustomText.ok, lng),
          false,
          context);
    } else if (responce.statusCode == 401) {
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.returnTrLable(
              locationControlls, CustomText.token_expired, lng!),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          context);
    } else {
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.errorBodyToString(responce.body, 'message'),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          context);
    }
  }

  Future<void> callInsertcmcALMData(CmcALMMetaFieldsModel items) async {
    await DatabaseHelper.database!.delete('tabCreche_Monitering_CheckList_ALM');
    if (items.tabCreche_Monitoring_CheckList_ALM != null) {
      await CrecheMoniteringCheckListALMFieldsHelper()
          .insertcmcALMMeta(items.tabCreche_Monitoring_CheckList_ALM!.fields!);
    }
  }

  callCMCCBMMetaApi(String userName, String password, String token,
      BuildContext context) async {
    downloadedApi = 27;
    updateLoadingText(dialogSetState);
    var responce = await CrecheMonetringCheckListCBMApi()
        .cmcCBMMetaApi(userName, password, token);
    if (responce.statusCode == 200) {
      CmcCBMMetaFieldsModel cmcCBMMEtaFields =
          CmcCBMMetaFieldsModel.fromJson(jsonDecode(responce.body));

      await callInsertcmcCBMData(cmcCBMMEtaFields);
      Navigator.pop(context);
      Validate().saveString(
          Validate.doctypeUpdateTimeStamp, DateTime.now().toString());

      Validate().singleButtonPopup(
          Global.returnTrLable(
              locationControlls, CustomText.doctypeUpdated, lng),
          Global.returnTrLable(locationControlls, CustomText.ok, lng),
          false,
          context);
    } else if (responce.statusCode == 401) {
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.returnTrLable(
              locationControlls, CustomText.token_expired, lng!),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          context);
    } else {
      Navigator.pop(context);
      Validate().singleButtonPopup(
          Global.errorBodyToString(responce.body, 'message'),
          Global.returnTrLable(locationControlls, CustomText.ok, lng!),
          false,
          context);
    }
  }

  Future<void> callInsertcmcCBMData(CmcCBMMetaFieldsModel items) async {
    await DatabaseHelper.database!.delete('tabCreche_Monitering_CheckList_CMB');
    if (items.tabCreche_Monitoring_CheckList_CBM != null) {
      await CrecheMoniteringCheckListCMBFieldsHelper()
          .insertcmcCBMMeta(items.tabCreche_Monitoring_CheckList_CBM!.fields!);
    }
  }

  void updateLoadingText(StateSetter setState) {
    if (mt) {
      setState(() {
        loadingText = ((downloadedApi / totalApiCount) * 100).toInt();
      });
    }
  }

  showLoaderDialog(BuildContext mContext) {
    loadingText = ((downloadedApi / totalApiCount) * 100).toInt();
    showDialog(
      barrierDismissible: false,
      context: mContext,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            dialogSetState = setState;
            return AlertDialog(
                content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                SizedBox(height: 10.h),
                Text(
                    '${Global.returnTrLable(locationControlls, CustomText.pleaseWait, lng)} (${(loadingText)}/100)%'),
              ],
            ));
          }),
        );
      },
    );
  }
}
