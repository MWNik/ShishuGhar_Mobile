import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/custom_widget/custom_appbar.dart';
import 'package:shishughar/database/helper/dynamic_screen_helper/options_model_helper.dart';
import 'package:shishughar/database/helper/enrolled_exit_child/enrolled_exit_child_responce_helper.dart';
import 'package:shishughar/model/apimodel/house_hold_field_item_model_api.dart';
import 'package:shishughar/model/apimodel/translation_language_api_model.dart';
import 'package:shishughar/model/databasemodel/child_growth_responce_model.dart';

import '../../../custom_widget/custom_btn.dart';
import '../../../custom_widget/custom_text.dart';
import '../../../custom_widget/custom_textfield.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_custom_dropdown.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_custom_textfield_float.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_custom_yesno_checkbox.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_customdatepicker.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_customtextfield_int.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_customtextfield_new.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamin_multi_check_screen_growth.dart';
import '../../../custom_widget/single_poup_dailog.dart';
import '../../../database/helper/anthromentory/child_growth_response_helper.dart';
import '../../../database/helper/backdated_configiration_helper.dart';
import '../../../database/helper/creche_helper/creche_data_helper.dart';
import '../../../database/helper/form_logic_helper.dart';
import '../../../database/helper/height_weight_boys_girls_helper.dart';
import '../../../database/helper/translation_language_helper.dart';
import '../../../model/apimodel/form_logic_api_model.dart';
import '../../../model/apimodel/tabHeight_for_age_Boys_model.dart';
import '../../../model/apimodel/tabHeight_for_age_Girls_model.dart';
import '../../../model/apimodel/tabWeight_for_age_Boys _model.dart';
import '../../../model/apimodel/tabWeight_for_age_Girls _model.dart';
import '../../../model/apimodel/tabWeight_to_Height_Boys_model.dart';
import '../../../model/apimodel/tabWeight_to_Height_Girls_model.dart';
import '../../../model/databasemodel/backdated_configiration_model.dart';
import '../../../model/dynamic_screen_model/enrolled_child_exit_responce_model.dart';
import '../../../model/dynamic_screen_model/options_model.dart';
import '../../../style/styles.dart';
import '../../../utils/custom_three_color_circle_image.dart';
import '../../../utils/globle_method.dart';
import '../../../utils/validate.dart';
import '../../child_growth_child_chart/weight_for_age_boys_girls_screen.dart';
import '../house_hold/depending_logic.dart';

class ChildGrowthExpendedFormScreen extends StatefulWidget {
  final int creche_nameId;
  final String creche_name;
  final String cgmguid;
  DateTime? lastGrowthDate;
  DateTime? minGrowthDate;
  String? createdAt;
  bool isNew;
  bool isView;

  ChildGrowthExpendedFormScreen(
      {super.key,
        required this.creche_nameId,
        required this.creche_name,
        required this.cgmguid,
        this.lastGrowthDate,
        this.minGrowthDate,
        this.createdAt,
        required this.isNew,
        this.isView = false});

  @override
  State<ChildGrowthExpendedFormScreen> createState() =>
      _ChildGrowthExpendedFormState();
}

class _ChildGrowthExpendedFormState
    extends State<ChildGrowthExpendedFormScreen> {
  List<HouseHoldFielItemdModel> formItem = [];
  HouseHoldFielItemdModel? measurement_date;
  HouseHoldFielItemdModel? measurement_equipment;
  HouseHoldFielItemdModel? do_you_have_height_weight;
  HouseHoldFielItemdModel? measurement_taken_date;
  TextEditingController Searchcontroller = TextEditingController();
  bool _isLoading = true;
  List<Translation> translatsLabel = [];
  List<int> mesureMonths = [1, 4, 7, 10];
  List<String> hiddenItem = [
    'dob_when_measurement_taken',
    'age_months',
    'measurement_date',
    'weight_for_age',
    'weight_for_height',
    'height_for_age',
    'height_for_age_zscore',
    'weight_for_height_zscore',
    'weight_for_age_zscore',
    're_height_for_age_zscore',
    're_weight_for_height_zscore',
    're_weight_for_age_zscore',
    'height',
    'weight',
    'measurement_equipment',
    'do_you_have_height_weight',
    'measurement_taken_date'
  ];
  List<String> staticHiddenItem = [
    'partner_id',
    'state_id',
    'district_id',
    'block_id',
    'gp_id',
    'village_id',
    'creche_id',
    'child_id'
  ];
  List<String> popItems = [
    're_measurement_equipment',
    're_do_you_have_height_weight',
    're_measurement_taken_date',
    're_measurement_reason',
    're_height',
    're_weight',
    're_age_months',
    're_weight_for_age',
    're_weight_for_height',
    're_height_for_age',
    're_weight_for_age_zcore',
    're_weight_for_height_zcore',
    're_height_for_age_zcore',
    're_updated_by',
    're_updated_on',
    're_created_by',
    're_created_on',
  ];
  Map<String, dynamic> myMap = {};
  Map<String, Map<String, dynamic>> attepmtChild = {};
  DependingLogic? logic;

  List<EnrolledExitChildResponceModel> enrolledChild = [];
  List<EnrolledExitChildResponceModel> filterdData = [];
  List<OptionsModel> options = [];
  List<OptionsModel> genders = [];

  List<TabHeightforageBoysModel> tabHeightforageBoys = [];
  List<TabHeightforageGirlsModel> tHeightforageGirls = [];
  List<TabWeightforageBoysModel> tabWeightforageBoys = [];
  List<TabWeightforageGirlsModel> tabWeightforageGirls = [];
  List<TabWeightToHeightBoysModel> tabWeightToHeightBoys = [];
  List<TabWeightToHeightGirlsModel> tabWeightToHeightGirls = [];
  BackdatedConfigirationModel? backdatedConfigirationModel;

  bool recrdedUpload = false;
  String lng = 'en';
  DateTime? caMinDate;
  String userName = '';
  String? role;
  int? expends;

  @override
  void initState() {
    super.initState();
    initializeData();
  }


  Future<void> initializeData() async {
    backdatedConfigirationModel = await BackdatedConfigirationHelper().excuteBackdatedConfigirationModel(CustomText.childGrowthMonitoring);
    if(widget.lastGrowthDate!=null&&Global.validToInt(backdatedConfigirationModel?.back_dated_data_entry_allowed)>0){
      String? minDate=await Validate().callMinDate(widget.lastGrowthDate.toString(), backdatedConfigirationModel!.back_dated_data_entry_allowed!);
      if(Global.validString(minDate)){
        caMinDate=Validate().stringToDate(minDate!);
      }else caMinDate=widget.lastGrowthDate;
    }else caMinDate=widget.lastGrowthDate;
    userName = (await Validate().readString(Validate.userName))!;
    role = await Validate().readString(Validate.role);
    lng = (await Validate().readString(Validate.sLanguage))!;
    tabHeightforageBoys =
    await HeightWeightBoysGirlsHelper().callHeightForAgeBoys();
    tHeightforageGirls =
    await HeightWeightBoysGirlsHelper().callHeightForAgeGirls();
    tabWeightforageBoys =
    await HeightWeightBoysGirlsHelper().callWeightforAgeBoys();
    tabWeightforageGirls =
    await HeightWeightBoysGirlsHelper().callWeightforAgeGirls();
    tabWeightToHeightBoys =
    await HeightWeightBoysGirlsHelper().callWeightToHeightBoys();
    tabWeightToHeightGirls =
    await HeightWeightBoysGirlsHelper().callWeightToHeightGirls();
    genders = await OptionsModelHelper().getMstCommonOptions('Gender', lng);

    translatsLabel.clear();
    List<String> valueNames = [
      CustomText.Save,
      CustomText.Creches,
      CustomText.CrecheCaregiver,
      CustomText.select_here,
      CustomText.Next,
      CustomText.back,
      CustomText.zScrore,
      CustomText.Submit,
      CustomText.noEnrolledChild,
      CustomText.ok,
      CustomText.GrowthMonitoring,
      CustomText.Search,
      CustomText.Name_,
      CustomText.Severe,
      CustomText.Moderate,
      CustomText.Normal,
      CustomText.ChildId,
      CustomText.Gender,
      CustomText.ageInDays,
      CustomText.shouldExit,
      CustomText.exit,
      CustomText.Cancel,
      CustomText.TotalChildren,
      CustomText.MeasuredChildren,
      CustomText.Yes,
      CustomText.No,
      CustomText.typehere,
      CustomText.plsSelectMesureEquip,
      CustomText.plsSelectHeight,
      CustomText.plsSelectWeight,
      CustomText.plsSelectMesureDate,
      CustomText.plsSelectreason,
      CustomText.dataSaveSuc,
      CustomText.valuLesThanOrEqual,
      CustomText.valueLesThan,
      CustomText.valuGreaterThanOrEqual,
      CustomText.valuGreaterThan,
      CustomText.valuEqual,
      CustomText.plsSelectIn,
      CustomText.valuLenLessOrEqual,
      CustomText.valuLenGreaterOrEqual,
      CustomText.valuLenEqual,
      CustomText.PleaseEnterValueIn,
      CustomText.PleaseSelectAfterTimeIn,
      CustomText.PleaseSelectAfterDateIn,
      CustomText.PleaseSelectBeforTimeIn,
      CustomText.PleaseSelectBeforDateIn,
      CustomText.PleaseSelectBeforTimeInIsValidTime,
      CustomText.plsFilManForm,
      CustomText.wesUsageGraterQuatOpen,
      CustomText.leavingLesThanjoining,
      CustomText.updateMeasurement,
      CustomText.reEnter,
      CustomText.ChildAlredExitSelectValidDAte,
    ];
    await TranslationDataHelper()
        .callTranslateString(valueNames)
        .then((value) => translatsLabel.addAll(value));
    var alredRecord = await ChildGrowthResponseHelper()
        .callAnthropometryByGuid(widget.cgmguid);

    if (alredRecord.length > 0) {
      if (alredRecord.first.responces != null) {
        List<String> selectedChildItems = [];
        Map<String, dynamic> responseData =
        jsonDecode(alredRecord[0].responces!);
        var childs = responseData['anthropromatic_details'];
        if (childs != null) {
          List<Map<String, dynamic>> children =
          List<Map<String, dynamic>>.from(childs);
          children.forEach((element) {
            selectedChildItems.add(element['childenrollguid']);
          });
        }
        enrolledChild = await EnrolledExitChilrenResponceHelper()
            .enrolledChildByEnrolledGUID(
            selectedChildItems, widget.creche_nameId);
        filterdData = enrolledChild;



      }
    }

    await updateHiddenValue();
    await callScreenControler();
  }

  @override
  Widget build(BuildContext context) {
    Global.applyDisplayCutout(Color(0xff5979AA));
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          Validate().showExitDialog(context, translatsLabel, lng);
          return false;
        },
        child: _isLoading
            ? Container(
            color: Colors.white,
            child: Center(child: CircularProgressIndicator()))
            : Scaffold(
            appBar: CustomAppbar(
                text: Global.returnTrLable(
                    translatsLabel, CustomText.GrowthMonitoring, lng),
                subTitle: widget.creche_name,
                onTap: () =>
                    Validate().showExitDialog(context, translatsLabel, lng)),
            body: Column(
              children: [
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Spacer(),
                      RichText(
                        text: TextSpan(
                          text: Global.returnTrLable(translatsLabel,
                              CustomText.MeasuredChildren, lng),
                          style: Styles.black124,
                          children: [
                            TextSpan(
                              text:
                              ' : ${countMesuredChildren()}/${enrolledChild.length}',
                              style: Styles.red145,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                // SizedBox(height: 10),
                measurement_date != null
                    ? Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 20.w, vertical: 2.h),
                  child: CustomDatepickerDynamic(
                    calenderValidate: [],
                    initialvalue: myMap[measurement_date!.fieldname!],
                    fieldName: measurement_date!.fieldname,
                    isRequred: measurement_date!.reqd,
                    minDate: caMinDate,
                    maxDate: widget.minGrowthDate,
                    readable: widget.isNew,
                    onChanged: (value) {
                      myMap[measurement_date!.fieldname!] = value;
                      var logData = logic!.callDateDiffrenceLogic(
                          myMap, measurement_date!);
                      if (logData.isNotEmpty) {
                        if (logData.keys.length > 0) {
                          myMap.addEntries([
                            MapEntry(logData.keys.first,
                                logData.values.first)
                          ]);
                        }
                      }
                      callEnrollementChildList(value);
                    },
                  ),
                )
                    : SizedBox(),
                // Padding(
                //     padding: EdgeInsets.symmetric(horizontal: 20.w),
                //     child: Divider()),
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: CustomTextFieldRow(
                    controller: Searchcontroller,
                    onChanged: (value) {
                      // print(value);
                      filterDataQu(value);
                    },
                    hintText: (lng != null)
                        ? Global.returnTrLable(translatsLabel, 'Search', lng)
                        : '',
                    prefixIcon: Image.asset(
                      "assets/search.png",
                      scale: 2.4,
                    ),
                  ),
                ),
                Expanded(
                    child: Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
                      child: SingleChildScrollView(
                        // controller: _scrollScontroller,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // children: cWidget(),
                          children: cParentWidget(),
                        ),
                      ),
                    )),
                // Spacer(),
                Divider(),
                Padding(
                  padding:
                  EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: CElevatedButton(
                          color: Color(0xffF26BA3),
                          onPressed: () {
                            // ch(2);
                            Navigator.pop(context);
                          },
                          text: Global.returnTrLable(
                              translatsLabel, CustomText.back, lng)
                              .trim(),
                        ),
                      ),
                      // Row(children: [
                      role == CustomText.crecheSupervisor
                          ? SizedBox(width: 10)
                          : SizedBox(),
                      role == CustomText.crecheSupervisor
                          ? Expanded(
                        child: CElevatedButton(
                          color: Color(0xff369A8D),
                          onPressed: () {
                            // print('$attepmtChild');
                            saveMeta(1, context);
                          },
                          text: Global.returnTrLable(translatsLabel,
                              CustomText.Submit, lng)
                              .trim(),
                        ),
                      )
                          : SizedBox(),
                      // ]
                      // ),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }

  List<Widget> cWidgetInputType(
      String ChildEnrollGUID, Map<String, dynamic> cWidgetDatamap) {
    var inputItem = formItem
        .where((element) =>
    element.fieldname == 'height' || element.fieldname == 'weight')
        .toList();

    List<Widget> screenItems = [];
    if (inputItem.length > 0) {
      for (int i = 0; i < inputItem.length; i++) {
        var isvible = logic!.callDependingLogic(cWidgetDatamap, inputItem[i]);
        if (isvible) {
          screenItems.add(Expanded(
            child:
            widgetTypeWidget(inputItem[i], cWidgetDatamap, ChildEnrollGUID),
          ));
          screenItems.add(SizedBox(
            width: 10.w,
          ));
        }
        if (!isvible) {
          inputItem[i].fieldname=='height'?'':cWidgetDatamap.remove(inputItem[i].fieldname);
        }
      }
    }
    return screenItems;
  }

  List<Widget> cWidgetRadiomColor(String ChildEnrollGUID,
      Map<String, dynamic> cWidgetDatamap, String gender) {
    var inputItem = formItem
        .where((element) =>
    element.fieldname == 'weight_for_age' ||
        element.fieldname == 'weight_for_height' ||
        element.fieldname == 'height_for_age')
        .toList();
    List<Widget> screenItems = [];
    if (inputItem.length > 0 && cWidgetDatamap['do_you_have_height_weight'].toString()== '1') {
      for (int i = 0; i < inputItem.length; i++) {
        var isvible = logic!.callDependingLogic(cWidgetDatamap, inputItem[i]);
        int colorD = DependingLogic.AutoColorCreateByHeightWightNew(
            tabHeightforageBoys,
            tHeightforageGirls,
            tabWeightforageBoys,
            tabWeightforageGirls,
            tabWeightToHeightBoys,
            tabWeightToHeightGirls,
            inputItem[i].fieldname!,
            gender,cWidgetDatamap['measurement_taken_date'],
            cWidgetDatamap);

        String grothValue = DependingLogic.AutoColorCreateByHeightWightStringNew(
            tabHeightforageBoys,
            tHeightforageGirls,
            tabWeightforageBoys,
            tabWeightforageGirls,
            tabWeightToHeightBoys,
            tabWeightToHeightGirls,
            inputItem[i].fieldname!,
            gender,cWidgetDatamap['measurement_taken_date'],
            cWidgetDatamap);

        Color itemC = Color(0xffAAAAAA);
        String colorName = '';
        if (colorD == 0) {
          itemC = Color(0xffAAAAAA);
          colorName = '';
        } else if (colorD == 1) {
          itemC = Color(0xffF35858);
          colorName =
          '(${Global.returnTrLable(translatsLabel, CustomText.Severe, lng)})';
        } else if (colorD == 2) {
          itemC = Color(0xffF4B81D);
          colorName =
          '(${Global.returnTrLable(translatsLabel, CustomText.Moderate, lng)})';
        } else if (colorD == 3) {
          itemC = Color(0xff8BF649);
          colorName =
          '(${Global.returnTrLable(translatsLabel, CustomText.Normal, lng)})';
        }
        countMesuredChildren();
        cWidgetDatamap[inputItem[i].fieldname!] = colorD;
        if (isvible) {
          screenItems.add(Column(
            children: [
              Container(
                height: 25,
                width: 25,
                decoration: BoxDecoration(
                  color: itemC,
                  borderRadius: BorderRadius.circular(5.r),
                ),
              ),
              Text(
                Global.returnTrLable(
                    translatsLabel, inputItem[i].label!.trim(), lng),
                style: Styles.black85,
                strutStyle: StrutStyle(height: 1.2),
              ),
              Text(
                colorName,
                style: Styles.black12700,
              ),
              Global.validString(grothValue)
                  ? Text(
                      '($grothValue)',
                      style: Styles.red85,
                    )
                  : SizedBox(),
            ],
          ));
        }
        if (!isvible) {
          // print('remo4 ${inputItem[i].fieldname}');
          cWidgetDatamap.remove(inputItem[i].fieldname);
        }
      }
    }
    return screenItems;
  }

  Widget cWidgetInLessCheck(
      String ChildEnrollGUID, Map<String, dynamic> cWidgetDatamap) {
    var inputItem = formItem
        .where((element) => (element.fieldname == 'illness_multi' && !popItems.contains(element.fieldname)))
        .toList();
    if (inputItem.length > 0) {
      var isvible = logic!.callDependingLogic(cWidgetDatamap, inputItem[0]);
      if (isvible) {
        return widgetTypeWidget(inputItem[0], cWidgetDatamap, ChildEnrollGUID);
      } else
        return SizedBox();
    } else
      return SizedBox();
  }

  List<Widget> cWidgetInLessCheckNew(
      String ChildEnrollGUID, Map<String, dynamic> cWidgetDatamap) {
    List<Widget> screenItems = [];
    var otherItem = formItem
        .where((element) => (!hiddenItem.contains(element.fieldname) && !popItems.contains(element.fieldname)))
        .toList();
    otherItem.forEach((element) {
      var isvible = logic!.callDependingLogic(cWidgetDatamap, element);
      screenItems
          .add(widgetTypeWidget(element, cWidgetDatamap, ChildEnrollGUID));
      // screenItems.add(SizedBox(height: 5.h));
      if (!isvible) {
        // print('remo1 ${element.fieldname}');
        cWidgetDatamap.remove(element.fieldname);
        updateItemsForChildren(cWidgetDatamap, ChildEnrollGUID);
      }
    });

    return screenItems;
  }

  List<Widget> cParentWidget() {
    List<Widget> screenItems = [];
    if (filterdData.length > 0) {
      for (int i = 0; i < filterdData.length; i++) {
        Map<String, FocusNode> focusMaps = {};
        for (var elements in formItem) {
          focusMaps.addEntries([MapEntry(elements.fieldname!, FocusNode())]);
        }
        var cWidgetDatamap = attepmtChild[filterdData[i].ChildEnrollGUID];
        if (cWidgetDatamap == null) {
          var date = Validate().stringToDate(
              Global.getItemValues(filterdData[i].responces, 'child_dob'));
          int calucalteDate = 0;
          if (myMap['measurement_date'] != null) {
            var mesurmentDate =
            Validate().stringToDate(myMap['measurement_date']);
            calucalteDate =
                Validate().calculateAgeInDaysEx(date, mesurmentDate);
          } else
            calucalteDate = Validate().calculateAgeInDays(date);
          cWidgetDatamap = {};
          cWidgetDatamap['age_months'] = calucalteDate;
          cWidgetDatamap['dob_when_measurement_taken'] = Global.getItemValues(filterdData[i].responces, 'child_dob');
          cWidgetDatamap['do_you_have_height_weight'] = 1;
          if (!widget.isNew && cWidgetDatamap['measurement_taken_date']==null) {
            cWidgetDatamap['measurement_taken_date'] =
            myMap['measurement_date'];
          }
          if(Global.stringToInt(cWidgetDatamap['do_you_have_height_weight'].toString()) == 1){
            if(calucalteDate<=730){
              cWidgetDatamap['measurement_equipment']='2';
            }else cWidgetDatamap['measurement_equipment']='1';
          }
          ///default value 1
          attepmtChild[filterdData[i].ChildEnrollGUID!] = cWidgetDatamap;
        } else {
          var date = Validate().stringToDate(
              Global.getItemValues(filterdData[i].responces, 'child_dob'));
          int calucalteDate = 0;
          if (cWidgetDatamap['measurement_taken_date'] != null) {
            var mesurmentDate = Validate()
                .stringToDate(cWidgetDatamap['measurement_taken_date']);
            calucalteDate =
                Validate().calculateAgeInDaysEx(date, mesurmentDate);
          } else{
            calucalteDate = Validate().calculateAgeInDays(date);
          }

          cWidgetDatamap['age_months'] = calucalteDate;
          cWidgetDatamap['dob_when_measurement_taken'] = Global.getItemValues(filterdData[i].responces, 'child_dob');
          //    commented By Satish dafult date remove show old record to copy to new
          if (!widget.isNew && cWidgetDatamap['measurement_taken_date'] == null) {
            cWidgetDatamap['measurement_taken_date'] =
            myMap['measurement_date'];
          }
          if(Global.stringToInt(cWidgetDatamap['do_you_have_height_weight'].toString()) == 1&&cWidgetDatamap['measurement_equipment']==null){
            if(calucalteDate<=730){
            cWidgetDatamap['measurement_equipment']='2';
            }else cWidgetDatamap['measurement_equipment']='1';
          }
          attepmtChild[filterdData[i].ChildEnrollGUID!] = cWidgetDatamap;
        }

        screenItems.add(
          Padding(
            padding: EdgeInsets.only(bottom: 15),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                border: Border.all(color: Color(0xffE0E0E0)),
                borderRadius: BorderRadius.circular(10.r),
              ),
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (expends == i) {
                          expends = -1;
                        } else
                          expends = i;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomPaint(
                          size: Size(100, 100),
                          painter: StrockColorCirclePainter(
                              Global.stringToDouble(
                                  cWidgetDatamap['weight_for_age'].toString()),
                              Global.stringToDouble(
                                  cWidgetDatamap['weight_for_height']
                                      .toString()),
                              Global.stringToInt(cWidgetDatamap[
                              'do_you_have_height_weight']
                                  .toString()) ==
                                  0
                                  ? null
                                  : cWidgetDatamap[
                              'any_medical_major_illness'] !=
                                  null
                                  ? Global.stringToDouble(cWidgetDatamap[
                              'any_medical_major_illness']
                                  .toString())
                                  : null,Global.stringToDouble(
                              cWidgetDatamap['height_for_age']
                                  .toString())),
                          child: Center(
                            child: Icon(
                              Icons.person,
                              color: Colors.grey,
                              size: 40,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(
                                      text:
                                      '${Global.returnTrLable(translatsLabel, CustomText.ChildId, lng)} : ',
                                      style: Styles.black124r,
                                      children: [
                                        TextSpan(
                                            text: Global.getItemValues(
                                                filterdData[i].responces!,
                                                'child_id'),
                                            style: Styles.blue126),
                                      ])),
                              RichText(
                                  strutStyle: StrutStyle(height: 1.h),
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(
                                      text:
                                      '${Global.returnTrLable(translatsLabel, 'Name', lng)} :',
                                      style: Styles.black124r,
                                      children: [
                                        TextSpan(
                                            text: Global.getItemValues(
                                                filterdData[i].responces,
                                                'child_name'),
                                            style: Styles.blue126),
                                      ])),
                              RichText(
                                  strutStyle: StrutStyle(height: 1.h),
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(
                                      text:
                                      '${Global.returnTrLable(translatsLabel, CustomText.Gender, lng)} : ',
                                      style: Styles.black124r,
                                      children: [
                                        TextSpan(
                                            text: callGenderName(
                                                Global.getItemValues(
                                                    filterdData[i].responces,
                                                    'gender_id')),
                                            style: Styles.blue126),
                                      ])),
                              RichText(
                                  strutStyle: StrutStyle(height: 1.h),
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(
                                      text:
                                      '${Global.returnTrLable(translatsLabel, CustomText.ageInDays, lng)} : ',
                                      style: Styles.black124r,
                                      children: [
                                        TextSpan(
                                            text: cWidgetDatamap[
                                            'age_months'] !=
                                                null
                                                ? '${cWidgetDatamap['age_months']}'
                                                : '',
                                            style: Styles.blue126),
                                      ])),
                            ],
                          ),
                        ),
                        Column(
                         children: [
                           // (Global.stringToInt(cWidgetDatamap['do_you_have_height_weight'].toString()) == 1  && role == CustomText.clusterCoordinator)?
                           Row(
                             children: [
                               (Global.stringToInt(cWidgetDatamap['do_you_have_height_weight'].toString()) == 1  && role == CustomText.clusterCoordinator)?
                               GestureDetector(
                                 onTap: (){
                                   _reEnterDailog(context,
                                       filterdData[i].ChildEnrollGUID!);
                                 },
                                 child: Icon(Icons.add_circle_outline,
                                     color:Color(0xff5979AA)),
                               )
                                   :SizedBox()
                               ,SizedBox(width: 5),
                               GestureDetector(
                                 onTap: (){
                                   Navigator.of(context).push(MaterialPageRoute(
                                       builder: (BuildContext context) => WeightforAgeBoysGirlsScreen(
                                         childenrollguid:  filterdData[i].ChildEnrollGUID!,
                                         crechId: widget.creche_nameId,
                                         childId:
                                         '${Global.getItemValues(filterdData[i].responces, 'child_id')}',
                                         childName:
                                         '${Global.getItemValues(filterdData[i].responces, 'child_name')}',
                                         gender_id: Global.stringToInt(
                                           Global.getItemValues( filterdData[i].responces, 'gender_id'),
                                         ),
                                         // date_of_birth:Global.stringToDate(Global.getItemValues(enrolledItem!.responces!, 'child_dob'))!
                                       )));
                                 },
                                 child: Image.asset(
                                     "assets/growthChart.png",
                                     scale: 8,
                                     color:Color(0xff5979AA)),
                               )
                             ],
                           )

                           ,
                           SizedBox(height: 5),
                           Padding(
                             padding: EdgeInsets.symmetric(horizontal: 5),
                             child: expends == i
                                 ? Image.asset(
                               "assets/circle_arrow.png",
                               scale: 2.2,
                             )
                                 : Image.asset(
                               "assets/circle_down_arrow.png",
                               scale: 2.2,
                             ),
                           ),
                         ],
                        )
                      ],
                    ),
                  ),
                  Visibility(
                    visible: expends == i,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Divider(
                            indent: 20,
                            endIndent: 20,
                            color: Color(0xffDEDEDE),
                            thickness: 1,
                          ),
                        ),
                        do_you_have_height_weight != null
                            ? widgetTypeWidget(do_you_have_height_weight!,
                            cWidgetDatamap, filterdData[i].ChildEnrollGUID!)
                            : SizedBox(),
                        measurement_taken_date != null
                            ? widgetTypeWidget(measurement_taken_date!,
                            cWidgetDatamap, filterdData[i].ChildEnrollGUID!)
                            : SizedBox(),
                        measurement_equipment != null
                            ? widgetTypeWidget(measurement_equipment!,
                            cWidgetDatamap, filterdData[i].ChildEnrollGUID!)
                            : SizedBox(),
                        Row(
                          children: cWidgetInputType(
                              filterdData[i].ChildEnrollGUID!, cWidgetDatamap),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        cWidgetDatamap['do_you_have_height_weight'] != 0
                            ? Text(
                          Global.returnTrLable(
                              translatsLabel, CustomText.zScrore, lng),
                          style: Styles.black124,
                        )
                            : SizedBox(),
                        cWidgetDatamap['do_you_have_height_weight'] != 0
                            ? SizedBox(
                          height: 5.h,
                        )
                            : SizedBox(),
                        cWidgetDatamap['do_you_have_height_weight'] != 0
                            ? Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Color(0xffE0E0E0)),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: cWidgetRadiomColor(
                                filterdData[i].ChildEnrollGUID!,
                                cWidgetDatamap,
                                Global.getItemValues(
                                    filterdData[i].responces,
                                    'gender_id')),
                          ),
                        )
                            : SizedBox(),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5.h),
                          child: Divider(
                            indent: 20,
                            endIndent: 20,
                            color: Color(0xffDEDEDE),
                            thickness: 1,
                          ),
                        ),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: cWidgetInLessCheckNew(
                                filterdData[i].ChildEnrollGUID!,
                                cWidgetDatamap))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
        // screenItems.add(Divider(
        //   thickness: 1,
        //   color: Colors.grey,
        // ));
        // screenItems.add(SizedBox(height: 10,));
      }
    }
    return screenItems;
  }

  saveMeta(int type, BuildContext mContext) async {
    if (type == 1) {
      if (_checkValidation()) {
        if (countMesuredChildrenForSave() > 0) {
          await saveDataInData();
          bool shouldProceed = await showDialog(
            context: context,
            builder: (context) {
              return SingleButtonPopupDialog(
                  message: Global.returnTrLable(
                      translatsLabel, CustomText.dataSaveSuc, lng),
                  button:
                  Global.returnTrLable(translatsLabel, CustomText.ok, lng));
            },
          );
          if (shouldProceed) {
            if (shouldProceed == true) {
              Navigator.pop(context, 'itemRefresh');
            }
          }
          // return;

          setState(() {});
        } else
          Validate().singleButtonPopup(
              '${Global.returnTrLable(translatsLabel, CustomText.noEnrolledChild, lng)} - ${Validate().displeDateFormate(myMap['measurement_date'])}',
              Global.returnTrLable(translatsLabel, CustomText.ok, lng),
              false,
              context);
      }
    } else {
      Navigator.pop(context, 'itemRefresh');
    }
  }

  Future<void> saveDataInData() async {
    if (formItem.length > 0) {
      Map<String, dynamic> responces = {};
      formItem.forEach((element) async {
        if (myMap[element.fieldname] != null) {
          responces[element.fieldname!] = myMap[element.fieldname];
        }
      });
      List<dynamic> childValues = [];

      enrolledChild.forEach((element) {
        var item = Validate().keyesFromResponce(attepmtChild[element.ChildEnrollGUID]!);
        item['childenrollguid'] = element.ChildEnrollGUID;
        item['chhguid'] = element.CHHGUID;
        item['child_id'] = element.name;
        item['cgmguid'] = widget.cgmguid;

        // if (((Global.stringToInt(
        //     item['do_you_have_height_weight'].toString()) !=
        //     1) ||
        //     item['measurement_equipment'] == null ||
        //     item['weight'] == null &&
        //     item['height'] == null)&&
        //     isMesurement(myMap[measurement_date!.fieldname])
        // )
        if ( item['do_you_have_height_weight'].toString()!= '1')
        {
          item.remove('weight_for_age');
          item.remove('height_for_age');
          item.remove('weight_for_height');
          item.remove('weight_for_age_zscore');
          item.remove('weight_for_height_zscore');
          item.remove('height_for_age_zscore');
          item.remove('measurement_equipment');
          item.remove('measurement_taken_date');
          item.remove('dob_when_measurement_taken');
          item.remove('height');
          item.remove('weight');
          item['do_you_have_height_weight'] = 0;
          // print(item['height']);
        } else {
          var gender = Global.getItemValues(element.responces, 'gender_id');
          var weightForAge = DependingLogic.AutoColorCreateByHeightWightNew(
              tabHeightforageBoys,
              tHeightforageGirls,
              tabWeightforageBoys,
              tabWeightforageGirls,
              tabWeightToHeightBoys,
              tabWeightToHeightGirls,
              'weight_for_age',
              gender,item['measurement_taken_date'],
              item);
          var heightForAge = DependingLogic.AutoColorCreateByHeightWightNew(
              tabHeightforageBoys,
              tHeightforageGirls,
              tabWeightforageBoys,
              tabWeightforageGirls,
              tabWeightToHeightBoys,
              tabWeightToHeightGirls,
              'height_for_age',
              gender,item['measurement_taken_date'],
              item);

          var weightForHeight = DependingLogic.AutoColorCreateByHeightWightNew(
              tabHeightforageBoys,
              tHeightforageGirls,
              tabWeightforageBoys,
              tabWeightforageGirls,
              tabWeightToHeightBoys,
              tabWeightToHeightGirls,
              'weight_for_height',
              gender,item['measurement_taken_date'],
              item);

          item['weight_for_age'] = weightForAge;
          item['height_for_age'] = heightForAge;
          item['weight_for_height'] = weightForHeight;

          var weight_for_age_zscore = DependingLogic.AutoColorCreateByHeightWightStringNew(
              tabHeightforageBoys,
              tHeightforageGirls,
              tabWeightforageBoys,
              tabWeightforageGirls,
              tabWeightToHeightBoys,
              tabWeightToHeightGirls,
              'weight_for_age',
              gender,item['measurement_taken_date'],
              item);
          var height_for_age_zscore = DependingLogic.AutoColorCreateByHeightWightStringNew(
              tabHeightforageBoys,
              tHeightforageGirls,
              tabWeightforageBoys,
              tabWeightforageGirls,
              tabWeightToHeightBoys,
              tabWeightToHeightGirls,
              'height_for_age',
              gender,item['measurement_taken_date'],
              item);
          var weight_for_height_zscore = DependingLogic.AutoColorCreateByHeightWightStringNew(
              tabHeightforageBoys,
              tHeightforageGirls,
              tabWeightforageBoys,
              tabWeightforageGirls,
              tabWeightToHeightBoys,
              tabWeightToHeightGirls,
              'weight_for_height',
              gender,item['measurement_taken_date'],
              item);

          item['weight_for_age_zscore'] = weight_for_age_zscore;
          item['weight_for_height_zscore'] = weight_for_height_zscore;
          item['height_for_age_zscore'] = height_for_age_zscore;
          item['s_flag'] = 1;

        }
        childValues.add(item);
            });
      myMap['anthropromatic_details'] = childValues;
      var measurementDate = myMap['measurement_date'];
      var responcesJs = jsonEncode(myMap);
      var name = myMap['name'];
      await ChildGrowthResponseHelper().insertUpdate(
          widget.cgmguid,
          measurementDate,
          name as int?,
          widget.creche_nameId,
          responcesJs,
          myMap['created_by'],
          myMap['created_on'],myMap['updated_on'],myMap['updated_by']);
    }
  }

  bool _checkValidation() {
    var validStatus = true;
    var mesureItem=formItem.where((element)=>!popItems.contains(element.fieldname)).toList();

    if (mesureItem.length > 0) {
      if (myMap['measurement_date'] != null) {
        for (int i = 0; i < enrolledChild.length; i++) {
          var item = attepmtChild[enrolledChild[i].ChildEnrollGUID];
          for (int i = 0; i < mesureItem.length; i++) {
            if (item != null) {
              var element = mesureItem[i];
              var validationMsg = logic!.validationMessge(item, element);
              // if (isMesurement(myMap[measurement_date!.fieldname]) == false &&
              //     (element.fieldname == 'height' ||
              //         element.fieldname == 'measurement_equipment') &&
              //     Global.validString(validationMsg)) {
              //   validationMsg = '';
              // }
              if (Global.validString(validationMsg)) {
                validStatus = false;
                Validate().singleButtonPopup(
                    validationMsg!,
                    Global.returnTrLable(translatsLabel, CustomText.ok, lng),
                    false,
                    context);
                return validStatus;
              }
              if (validStatus) {
                if (element.fieldname == 'do_you_have_height_weight') {
                  var elmeItemValue = Global.validToString(
                      item['do_you_have_height_weight'].toString());
                  if (elmeItemValue == '1') {
                    String? elmeItemValue = item['measurement_equipment'];
                    var height = item['height'];
                    var weight = item['weight'];
                    var measurmenTakenDate = item['measurement_taken_date'];

                    if (!Global.validString(elmeItemValue) &&
                        Global.stringToDouble(height.toString()) > 0) {
                      validStatus = false;
                      Validate().singleButtonPopup(
                          Global.returnTrLable(translatsLabel,
                              CustomText.plsSelectMesureEquip, lng),
                          Global.returnTrLable(
                              translatsLabel, CustomText.ok, lng),
                          false,
                          context);
                      return validStatus;
                    } else if (Global.stringToDouble(height.toString()) == 0) {
                      // if (isMesurement(myMap[measurement_date!.fieldname])) {
                        validStatus = false;
                        Validate().singleButtonPopup(
                            Global.returnTrLable(translatsLabel,
                                CustomText.plsSelectHeight, lng),
                            Global.returnTrLable(
                                translatsLabel, CustomText.ok, lng),
                            false,
                            context);
                        return validStatus;
                      // }
                    } else if (Global.stringToDouble(weight.toString()) == 0) {
                      validStatus = false;
                      Validate().singleButtonPopup(
                          Global.returnTrLable(
                              translatsLabel, CustomText.plsSelectWeight, lng),
                          Global.returnTrLable(
                              translatsLabel, CustomText.ok, lng),
                          false,
                          context);
                      return validStatus;
                    } else if (!Global.validString(measurmenTakenDate)) {
                      validStatus = false;
                      Validate().singleButtonPopup(
                          Global.returnTrLable(translatsLabel,
                              CustomText.plsSelectMesureDate, lng),
                          Global.returnTrLable(
                              translatsLabel, CustomText.ok, lng),
                          false,
                          context);
                      return validStatus;
                    }
                  } else if (elmeItemValue == '2') {
                    var measurement_reason = item['measurement_reason'];
                    if (!Global.validString(measurement_reason.toString())) {
                      validStatus = false;
                      Validate().singleButtonPopup(
                          Global.returnTrLable(
                              translatsLabel, CustomText.plsSelectreason, lng),
                          Global.returnTrLable(
                              translatsLabel, CustomText.ok, lng),
                          false,
                          context);
                      return validStatus;
                    }
                  }
                }
              }
            }
          }
        }
      } else {
        Validate().singleButtonPopup(
            Global.returnTrLable(
                translatsLabel, CustomText.pleaseFillMeasurementDate, lng),
            Global.returnTrLable(translatsLabel, CustomText.ok, lng),
            false,
            context);
        return false;
      }
    } else {
      Validate().singleButtonPopup(
          Global.returnTrLable(
              translatsLabel, CustomText.DontHaveChildrenForAttender, lng),
          Global.returnTrLable(translatsLabel, CustomText.ok, lng),
          false,
          context);
      return false;
    }

    return validStatus;
  }

  Future<void> callScreenControler() async {
    List<String> defaultCommon = ['tabMulti Select Illness'];
    List<HouseHoldFielItemdModel> allItem = [];
    await ChildGrowthResponseHelper()
        .getChildHHFieldsForm('Child Growth Monitoring')
        .then((value) {
      allItem = value;
    });

    formItem = allItem
        .where((element) => !staticHiddenItem.contains(element.fieldname!))
        .toList();

    List<HouseHoldFielItemdModel> items = formItem;
    for (int i = 0; i < items.length; i++) {
      if (Global.validString(items[i].options)) {
        defaultCommon.add('tab${items[i].options!.trim()}');
      }
    }
    await OptionsModelHelper()
        .getAllMstCommonNotINOptions(defaultCommon, lng)
        .then((data) {
      options.addAll(data);
    });
    List<TabFormsLogic> logics = [];
    await FormLogicDataHelper()
        .callFormLogic('Child Growth Monitoring')
        .then((data) {
      logics.addAll(data);
    });
    await FormLogicDataHelper()
        .callFormLogic('Anthropromatic Data')
        .then((data) {
      logics.addAll(data);
    });

    var measurementDate = formItem
        .where((element) => element.fieldname == 'measurement_date')
        .toList();

    var measurementTakenDate = formItem
        .where((element) => element.fieldname == 'measurement_taken_date')
        .toList();

    var haveMesure = formItem
        .where((element) => element.fieldname == 'do_you_have_height_weight')
        .toList();

    if (haveMesure.length > 0) {
      do_you_have_height_weight = haveMesure.first;
    }

    var measurementEquipment = formItem
        .where((element) => element.fieldname == 'measurement_equipment')
        .toList();
    if (measurementDate.length > 0) {
      measurement_date = measurementDate.first;
    }
    if (measurementEquipment.length > 0) {
      measurement_equipment = measurementEquipment.first;
    }
    if (measurementTakenDate.length > 0) {
      measurement_taken_date = measurementTakenDate.first;
    }

    List<String> tranlatItems = [];
    formItem.forEach((element) {
      if (Global.validString(element.label)) {
        tranlatItems.add(element.label!);
      }
    });
    await TranslationDataHelper()
        .callTranslateString(tranlatItems)
        .then((value) => translatsLabel.addAll(value));
    logic = DependingLogic(translatsLabel, logics, lng);
    setState(() {
      _isLoading = false;
    });
  }

  widgetTypeWidget(HouseHoldFielItemdModel quesItem,
      Map<String, dynamic> itemsAnswred, String ChildEnrollGUID) {
    switch (quesItem.fieldtype) {
      case 'Link':
        List<OptionsModel> items = options
            .where((element) => element.flag == 'tab${quesItem.options}')
            .toList();
        // print("Current Link Field Type ======> ${quesItem.label}");
        return DynamicCustomDropdownField(
          hintText: Global.returnTrLable(
              translatsLabel, CustomText.select_here, lng),
          titleText:
          Global.returnTrLable(translatsLabel, quesItem.label!.trim(), lng),
          // isRequred: quesItem.fieldname == 'measurement_equipment'
          //     ? isMesurement(myMap[measurement_date!.fieldname])
          //     ? logic!.dependeOnMendotory(itemsAnswred, quesItem)
          //     : 0
          //     : logic!.dependeOnMendotory(itemsAnswred, quesItem),
          isRequred: logic!.dependeOnMendotory(itemsAnswred, quesItem),
          items: items,
          // readable: role == CustomText.crecheSupervisor
          //     ? (quesItem.fieldname == 'measurement_equipment')?
          // isMesurement(myMap[measurement_date!.fieldname])?
          // logic!.callReadableLogic(itemsAnswred, quesItem)
          //     :true
          //     :logic!.callReadableLogic(itemsAnswred, quesItem)
          //     : true,
          readable: role == CustomText.crecheSupervisor
              ?  logic!.callReadableLogic(itemsAnswred, quesItem):true,
          selectedItem: itemsAnswred[quesItem.fieldname!].toString(),
          isVisible: logic!.callDependingLogic(itemsAnswred, quesItem),
          onChanged: (value) {
            if (value != null)
              itemsAnswred[quesItem.fieldname!] = value.name;
            else
              itemsAnswred.remove(quesItem.fieldname);

            updateItemsForChildren(itemsAnswred, ChildEnrollGUID);

            setState(() {});
          },
        );
      case 'Date':
        return CustomDatepickerDynamic(
          // focusNode: _foocusNode[ChildEnrollGUID]![quesItem.fieldname],
          calenderValidate: [],
          titleText:
          Global.returnTrLable(translatsLabel, quesItem.label!.trim(), lng),
          initialvalue: itemsAnswred[quesItem.fieldname!],
          fieldName: quesItem.fieldname,
          readable: role == CustomText.crecheSupervisor
              ? logic!.callReadableLogic(itemsAnswred, quesItem)
              : true,
          isVisible: logic!.callDependingLogic(itemsAnswred, quesItem),
          isRequred: logic!.dependeOnMendotory(itemsAnswred, quesItem),
          maxDate: quesItem.fieldname == 'measurement_taken_date'
              ? widget.minGrowthDate
              : null,
          minDate: quesItem.fieldname == 'measurement_taken_date'
              ? Validate().stringToDateNull(myMap["measurement_date"]) != null
              ? Validate()
              .stringToDateNull(myMap["measurement_date"])!
              .subtract(Duration(days: 1))
              : null
              : null,
          onChanged: (value) {
            // if(quesItem.fieldname == 'measurement_taken_date'){
            //   var enrolledChildItem=filterdData .where((element) =>
            //   element.ChildEnrollGUID == ChildEnrollGUID)
            //       .toList();
            //   String? childExit;
            //   if(enrolledChildItem.isNotEmpty){
            //     childExit=Global.getItemValues(enrolledChildItem.first.responces, 'date_of_exit');
            //   }
            //   if(Global.validString(childExit)) {
            //     if(Global.stringToDate(childExit)!.isAfter(Global.stringToDate(value)!)){
            //       itemsAnswred[quesItem.fieldname!] = value;
            //       var logData = logic!.callDateDiffrenceLogic(
            //           itemsAnswred, quesItem);
            //       if (logData.isNotEmpty) {
            //         if (logData.keys.length > 0) {
            //           itemsAnswred.addEntries(
            //               [MapEntry(logData.keys.first, logData.values.first)]);
            //           updateItemsForChildren(itemsAnswred, ChildEnrollGUID);
            //         }
            //       }
            //     }
            //     else{
            //       itemsAnswred.remove(quesItem.fieldname);
            //       updateItemsForChildren(itemsAnswred, ChildEnrollGUID);
            //       Validate().singleButtonPopup(
            //           CustomText.ChildAlredExitSelectValidDAte,
            //           Global.returnTrLable(translatsLabel, CustomText.ok, lng),
            //           false,
            //           context);
            //     }
            //   } else{
            //     itemsAnswred[quesItem.fieldname!] = value;
            //     var logData = logic!.callDateDiffrenceLogic(
            //         itemsAnswred, quesItem);
            //     if (logData.isNotEmpty) {
            //       if (logData.keys.length > 0) {
            //         itemsAnswred.addEntries(
            //             [MapEntry(logData.keys.first, logData.values.first)]);
            //
            //         updateItemsForChildren(itemsAnswred, ChildEnrollGUID);
            //       }
            //     }
            //   }
            // }
            // else{
              itemsAnswred[quesItem.fieldname!] = value;
              var logData = logic!.callDateDiffrenceLogic(
                  itemsAnswred, quesItem);
              if (logData.isNotEmpty) {
                if (logData.keys.length > 0) {
                  itemsAnswred.addEntries(
                      [MapEntry(logData.keys.first, logData.values.first)]);
                  updateItemsForChildren(itemsAnswred, ChildEnrollGUID);
                }
              }
            // }

            setState(() {});
          },
        );
      case 'Data':
        return DynamicCustomTextFieldNew(
          // focusNode: _foocusNode[ChildEnrollGUID]![quesItem.fieldname],
          titleText:
          Global.returnTrLable(translatsLabel, quesItem.label!.trim(), lng),
          isRequred: logic!.dependeOnMendotory(itemsAnswred, quesItem),
          readable: role == CustomText.crecheSupervisor
              ? logic!.callReadableLogic(itemsAnswred, quesItem)
              : true,
          initialvalue: itemsAnswred[quesItem.fieldname!],
          keyboard: logic!.keyBoardLogic(quesItem.fieldname!),
          maxlength: quesItem.length,
          hintText:
          Global.returnTrLable(translatsLabel, quesItem.label!.trim(), lng),
          isVisible: logic!.callDependingLogic(itemsAnswred, quesItem),
          onChanged: (value) {
            if (value.isNotEmpty)
              itemsAnswred[quesItem.fieldname!] = value;
            else
              itemsAnswred.remove(quesItem.fieldname);

            updateItemsForChildren(itemsAnswred, ChildEnrollGUID);
          },
        );
      case 'Int':
        return DynamicCustomTextFieldInt(
          // focusNode: _foocusNode[ChildEnrollGUID]![quesItem.fieldname],
          titleText:
          Global.returnTrLable(translatsLabel, quesItem.label!.trim(), lng),
          keyboardtype: TextInputType.number,
          readable: role == CustomText.crecheSupervisor
              ? logic!.callReadableLogic(itemsAnswred, quesItem)
              : true,
          isRequred: logic!.dependeOnMendotory(itemsAnswred, quesItem),
          maxlength: quesItem.length,
          initialvalue: itemsAnswred[quesItem.fieldname!],
          isVisible: logic!.callDependingLogic(itemsAnswred, quesItem),
          onChanged: (value) {
            // print('Entered text: $value');
            if (value != null) {
              itemsAnswred[quesItem.fieldname!] = value;
              var logData =
              logic!.callAutoGeneratedValue(itemsAnswred, quesItem);
              if (logData.isNotEmpty) {
                if (logData.keys.length > 0) {
                  itemsAnswred.addEntries(
                      [MapEntry(logData.keys.first, logData.values.first)]);
                  updateItemsForChildren(itemsAnswred, ChildEnrollGUID);
                  // setState(() {});
                }
              }
            } else {
              itemsAnswred.remove(quesItem.fieldname);
              updateItemsForChildren(itemsAnswred, ChildEnrollGUID);
              // setState(() {});
            }
          },
        );
    // case 'Check':
    //   return DynamicCustomCheckboxWithLabel(
    //     label:
    //         Global.returnTrLable(translatsLabel, quesItem.label!.trim(), lng),
    //     initialValue: itemsAnswred[quesItem.fieldname!],
    //     isVisible: logic!
    //         .callDependingLogic( itemsAnswred, quesItem),
    //     onChanged: (value) {
    //       if (value > 0)
    //         itemsAnswred[quesItem.fieldname!] = value;
    //       else
    //         itemsAnswred.remove(quesItem.fieldname);
    //
    //       updateItemsForChildren(itemsAnswred, ChildEnrollGUID);
    //       setState(() {});
    //     },
    //   );
      case 'Check':
        return DynamicCustomYesNoCheckboxWithLabel(
          label:
          Global.returnTrLable(translatsLabel, quesItem.label!.trim(), lng),
          initialValue: Global.stringToIntNull(
              itemsAnswred[quesItem.fieldname].toString()),
          isRequred: logic!.dependeOnMendotory(itemsAnswred, quesItem),
          labelControlls: translatsLabel,
          lng: lng,
          readable: role == CustomText.crecheSupervisor
              ? logic!.callReadableLogic(itemsAnswred, quesItem)
              : true,
          isVisible: logic!.callDependingLogic(itemsAnswred, quesItem),
          onChanged: (value) {
            // print('yesNo $value');
            itemsAnswred[quesItem.fieldname!] = value;
            updateItemsForChildren(itemsAnswred, ChildEnrollGUID);
            setState(() {});
          },
        );
      case 'Long Text':
        return DynamicCustomTextFieldNew(
          // focusNode: _foocusNode[ChildEnrollGUID]![quesItem.fieldname],
          maxline: 3,
          titleText:
          Global.returnTrLable(translatsLabel, quesItem.label!.trim(), lng),
          isRequred: logic!.dependeOnMendotory(itemsAnswred, quesItem),
          initialvalue: itemsAnswred[quesItem.fieldname!],
          readable: role == CustomText.crecheSupervisor
              ? logic!.callReadableLogic(itemsAnswred, quesItem)
              : true,
          maxlength: quesItem.length,
          hintText:
          Global.returnTrLable(translatsLabel, quesItem.label!.trim(), lng),
          isVisible: logic!.callDependingLogic(itemsAnswred, quesItem),
          onChanged: (value) {
            if (value.isNotEmpty)
              itemsAnswred[quesItem.fieldname!] = value;
            else
              itemsAnswred.remove(quesItem.fieldname);
            updateItemsForChildren(itemsAnswred, ChildEnrollGUID);
          },
        );
      case 'Select':
        return DynamicCustomTextFieldInt(
          // focusNode: _foocusNode[ChildEnrollGUID]![quesItem.fieldname],
          titleText:
          Global.returnTrLable(translatsLabel, quesItem.label!.trim(), lng),
          keyboardtype: TextInputType.number,
          isRequred: logic!.dependeOnMendotory(itemsAnswred, quesItem),
          maxlength: quesItem.length,
          initialvalue: itemsAnswred[quesItem.fieldname!],
          readable: role == CustomText.crecheSupervisor
              ? logic!.callReadableLogic(itemsAnswred, quesItem)
              : true,
          onChanged: (value) {
            // print('Entered text: $value');
            if (value != null)
              itemsAnswred[quesItem.fieldname!] = value;
            else {
              itemsAnswred.remove(quesItem.fieldname);

              updateItemsForChildren(itemsAnswred, ChildEnrollGUID);
              setState(() {});
            }
          },
        );
      case 'Small Text':
        return DynamicCustomTextFieldNew(
          // focusNode: _foocusNode[ChildEnrollGUID]![quesItem.fieldname],
          titleText:
          Global.returnTrLable(translatsLabel, quesItem.label!.trim(), lng),
          isRequred: logic!.dependeOnMendotory(itemsAnswred, quesItem),
          maxlength: quesItem.length,
          readable: role == CustomText.crecheSupervisor
              ? logic!.callReadableLogic(itemsAnswred, quesItem)
              : true,
          initialvalue: itemsAnswred[quesItem.fieldname!],
          onChanged: (value) {
            // print('Entered text: $value');
            if (value.isNotEmpty)
              itemsAnswred[quesItem.fieldname!] = value;
            else
              itemsAnswred.remove(quesItem.fieldname);

            updateItemsForChildren(itemsAnswred, ChildEnrollGUID);
          },
        );
      case 'Float':
        return DynamicCustomTextFieldFloat(
          // focusNode: _foocusNode[ChildEnrollGUID]![quesItem.fieldname],
          hintText:
          Global.returnTrLable(translatsLabel, CustomText.typehere, lng),
          titleText:
          Global.returnTrLable(translatsLabel, quesItem.label!.trim(), lng),
          keyboardtype: TextInputType.number,
          // isRequred: quesItem.fieldname == 'height'
          //     ? (isMesurement(myMap[measurement_date!.fieldname])
          //     ? logic!.dependeOnMendotory(itemsAnswred, quesItem)
          //     : 0)
          //     : logic!.dependeOnMendotory(itemsAnswred, quesItem),
          isRequred: logic!.dependeOnMendotory(itemsAnswred, quesItem),
          maxlength: quesItem.length,
          initialvalue: itemsAnswred[quesItem.fieldname!],
          // readable: role == CustomText.crecheSupervisor
          //     ? (quesItem.fieldname == 'height')?
          // isMesurement(myMap[measurement_date!.fieldname])?
          // logic!.callReadableLogic(itemsAnswred, quesItem)
          //     :true
          //     :logic!.callReadableLogic(itemsAnswred, quesItem)
          //     : true,
          readable: role == CustomText.crecheSupervisor
              ? logic!.callReadableLogic(itemsAnswred, quesItem):
    true,
          isVisible: logic!.callDependingLogic(itemsAnswred, quesItem),
          fieldName: quesItem.fieldname!,
          onChanged: (value) {
            // print('Entered text: $value');
            if (value != null) {
              itemsAnswred[quesItem.fieldname!] = value;
              var logData =
              logic!.callAutoGeneratedValue(itemsAnswred, quesItem);
              if (logData.isNotEmpty) {
                if (logData.keys.length > 0) {
                  itemsAnswred.addEntries(
                      [MapEntry(logData.keys.first, logData.values.first)]);
                  updateItemsForChildren(itemsAnswred, ChildEnrollGUID);
                  // setState(() {});
                }
              }
            } else {
              itemsAnswred.remove(quesItem.fieldname);
              updateItemsForChildren(itemsAnswred, ChildEnrollGUID);
              // setState(() {});
            }
          },
        );
      default:
        return SizedBox();
    }
  }

  // bool isMesurement(String? mesureDate) {
  //   bool ismesure = false;
  //   if(Global.validString(mesureDate)){
  //   List<int> parts = mesureDate.toString().split('-').map(int.parse).toList();
  //   var month = parts[1];
  //   if (mesureMonths.contains(month)) {
  //     ismesure = true;
  //   }}
  //   return ismesure;
  // }

  widgetTypeWidgetinlessForMulti(HouseHoldFielItemdModel quesItem,
      Map<String, dynamic> itemsAnswred, String ChildEnrollGUID) {
    switch (quesItem.fieldtype) {
      case 'Data':
        if (quesItem.fieldname == 'illness_multi') {
          List<OptionsModel> items = options
              .where((element) => element.flag == 'tabMulti Select Illness')
              .toList();
          return DynamicMultiCheckGrowthGridView(
            items: items,
            selectedItem: itemsAnswred[quesItem.fieldname],
            titleText: Global.returnTrLable(
                translatsLabel, quesItem.label!.trim(), lng),
            isRequred: logic!.dependeOnMendotory(itemsAnswred, quesItem),
            onChanged: (value) {
              if (value != null) {
                itemsAnswred[quesItem.fieldname!] = value;
                itemsAnswred['illness_id'] = value;
              } else {
                itemsAnswred.remove(quesItem.fieldname);
                itemsAnswred.remove('illness_id');
                // itemsAnswred['illness_id'] = value;
              }

              updateItemsForChildren(itemsAnswred, ChildEnrollGUID);

              setState(() {});
            },
          );
        } else {
          return DynamicCustomTextFieldNew(
            titleText: Global.returnTrLable(
                translatsLabel, quesItem.label!.trim(), lng),
            isRequred: logic!.dependeOnMendotory(itemsAnswred, quesItem),
            initialvalue: itemsAnswred[quesItem.fieldname!],
            maxlength: quesItem.length,
            readable: logic!.callReadableLogic(itemsAnswred, quesItem),
            hintText: Global.returnTrLable(
                translatsLabel, quesItem.label!.trim(), lng),
            isVisible: logic!.callDependingLogic(itemsAnswred, quesItem),
            onChanged: (value) {
              if (value.isNotEmpty)
                itemsAnswred[quesItem.fieldname!] = value;
              else
                itemsAnswred.remove(quesItem.fieldname);

              updateItemsForChildren(itemsAnswred, ChildEnrollGUID);
            },
          );
        }
      case 'Link':
        List<OptionsModel> items = options
            .where((element) => element.flag == 'tab${quesItem.options}')
            .toList();
        return DynamicCustomDropdownField(
          hintText: Global.returnTrLable(
              translatsLabel, CustomText.select_here, lng),
          titleText:
          Global.returnTrLable(translatsLabel, quesItem.label!.trim(), lng),
          isRequred: logic!.dependeOnMendotory(itemsAnswred, quesItem),
          items: items,
          selectedItem: itemsAnswred[quesItem.fieldname!],
          isVisible: logic!.callDependingLogic(itemsAnswred, quesItem),
          onChanged: (value) {
            if (value != null)
              itemsAnswred[quesItem.fieldname!] = value.name;
            else
              itemsAnswred.remove(quesItem.fieldname);
            updateItemsForChildren(itemsAnswred, ChildEnrollGUID);

            setState(() {});
          },
        );
      case 'Date':
        return CustomDatepickerDynamic(
          calenderValidate: [],
          titleText:
          Global.returnTrLable(translatsLabel, quesItem.label!.trim(), lng),
          initialvalue: itemsAnswred[quesItem.fieldname!],
          fieldName: quesItem.fieldname,
          isRequred: logic!.dependeOnMendotory(itemsAnswred, quesItem),
          onChanged: (value) {
            itemsAnswred[quesItem.fieldname!] = value;
            var logData = logic!.callDateDiffrenceLogic(itemsAnswred, quesItem);
            if (logData.isNotEmpty) {
              if (logData.keys.length > 0) {
                itemsAnswred.addEntries(
                    [MapEntry(logData.keys.first, logData.values.first)]);

                updateItemsForChildren(itemsAnswred, ChildEnrollGUID);
              }
            }
            setState(() {});
          },
        );

      case 'Int':
        return DynamicCustomTextFieldInt(
          titleText:
          Global.returnTrLable(translatsLabel, quesItem.label!.trim(), lng),
          keyboardtype: TextInputType.number,
          isRequred: logic!.dependeOnMendotory(itemsAnswred, quesItem),
          maxlength: quesItem.length,
          initialvalue: itemsAnswred[quesItem.fieldname!],
          readable: logic!.callReadableLogic(itemsAnswred, quesItem),
          isVisible: logic!.callDependingLogic(itemsAnswred, quesItem),
          onChanged: (value) {
            // print('Entered text: $value');
            if (value != null) {
              itemsAnswred[quesItem.fieldname!] = value;
              var logData =
              logic!.callAutoGeneratedValue(itemsAnswred, quesItem);
              if (logData.isNotEmpty) {
                if (logData.keys.length > 0) {
                  itemsAnswred.addEntries(
                      [MapEntry(logData.keys.first, logData.values.first)]);
                  updateItemsForChildren(itemsAnswred, ChildEnrollGUID);
                  // setState(() {});
                }
              }
            } else {
              itemsAnswred.remove(quesItem.fieldname);
              updateItemsForChildren(itemsAnswred, ChildEnrollGUID);
              setState(() {});
            }
          },
        );
    // case 'Check':
    //   return DynamicCustomCheckboxWithLabel(
    //     label:
    //         Global.returnTrLable(translatsLabel, quesItem.label!.trim(), lng),
    //     initialValue: itemsAnswred[quesItem.fieldname!],
    //     isVisible: logic!
    //         .callDependingLogic( itemsAnswred, quesItem),
    //     onChanged: (value) {
    //       if (value > 0)
    //         itemsAnswred[quesItem.fieldname!] = value;
    //       else
    //         itemsAnswred.remove(quesItem.fieldname);
    //
    //       updateItemsForChildren(itemsAnswred, ChildEnrollGUID);
    //       setState(() {});
    //     },
    //   );
      case 'Check':
        return DynamicCustomYesNoCheckboxWithLabel(
          label:
          Global.returnTrLable(translatsLabel, quesItem.label!.trim(), lng),
          initialValue: itemsAnswred[quesItem.fieldname],
          labelControlls: translatsLabel,
          lng: lng,
          readable: logic!.callReadableLogic(itemsAnswred, quesItem),
          isVisible: logic!.callDependingLogic(itemsAnswred, quesItem),
          onChanged: (value) {
            // print('yesNo $value');
            itemsAnswred[quesItem.fieldname!] = value;
            updateItemsForChildren(itemsAnswred, ChildEnrollGUID);
            setState(() {});
          },
        );
      case 'Select':
        return DynamicCustomTextFieldInt(
          titleText:
          Global.returnTrLable(translatsLabel, quesItem.label!.trim(), lng),
          keyboardtype: TextInputType.number,
          isRequred: logic!.dependeOnMendotory(itemsAnswred, quesItem),
          maxlength: quesItem.length,
          readable: logic!.callReadableLogic(itemsAnswred, quesItem),
          initialvalue: itemsAnswred[quesItem.fieldname!],
          onChanged: (value) {
            // print('Entered text: $value');
            if (value != null)
              itemsAnswred[quesItem.fieldname!] = value;
            else {
              itemsAnswred.remove(quesItem.fieldname);

              updateItemsForChildren(itemsAnswred, ChildEnrollGUID);
              setState(() {});
            }
          },
        );
      case 'Small Text':
        return DynamicCustomTextFieldNew(
          titleText:
          Global.returnTrLable(translatsLabel, quesItem.label!.trim(), lng),
          isRequred: logic!.dependeOnMendotory(itemsAnswred, quesItem),
          maxlength: quesItem.length,
          readable: logic!.callReadableLogic(itemsAnswred, quesItem),
          initialvalue: itemsAnswred[quesItem.fieldname!],
          onChanged: (value) {
            // print('Entered text: $value');
            if (value.isNotEmpty)
              itemsAnswred[quesItem.fieldname!] = value;
            else
              itemsAnswred.remove(quesItem.fieldname);

            updateItemsForChildren(itemsAnswred, ChildEnrollGUID);
          },
        );
      case 'Float':
        return DynamicCustomTextFieldFloat(
          titleText:
          Global.returnTrLable(translatsLabel, quesItem.label!.trim(), lng),
          keyboardtype: TextInputType.number,
          isRequred: logic!.dependeOnMendotory(itemsAnswred, quesItem),
          maxlength: quesItem.length,
          initialvalue: itemsAnswred[quesItem.fieldname!],
          readable: logic!.callReadableLogic(itemsAnswred, quesItem),
          isVisible: logic!.callDependingLogic(itemsAnswred, quesItem),
          fieldName: quesItem.fieldname!,
          onChanged: (value) {
            // print('Entered text: $value');
            if (value != null) {
              itemsAnswred[quesItem.fieldname!] = value;
              var logData =
              logic!.callAutoGeneratedValue(itemsAnswred, quesItem);
              if (logData.isNotEmpty) {
                if (logData.keys.length > 0) {
                  itemsAnswred.addEntries(
                      [MapEntry(logData.keys.first, logData.values.first)]);
                  updateItemsForChildren(itemsAnswred, ChildEnrollGUID);
                  // setState(() {});
                }
              }
            } else {
              itemsAnswred.remove(quesItem.fieldname);
              updateItemsForChildren(itemsAnswred, ChildEnrollGUID);
              setState(() {});
            }
          },
        );
      default:
        return SizedBox();
    }
  }

  Future<void> updateHiddenValue() async {
    var alredRecord = await ChildGrowthResponseHelper()
        .callAnthropometryByGuid(widget.cgmguid);

    if (alredRecord.length > 0) {
      if (alredRecord.first.responces != null) {
        Map<String, dynamic> responseData =
        jsonDecode(alredRecord[0].responces!);
        var childs = responseData['anthropromatic_details'];
        if (childs != null) {
          List<Map<String, dynamic>> children = List<Map<String, dynamic>>.from(
              responseData['anthropromatic_details']);
          responseData.remove('anthropromatic_details');
          responseData.forEach((key, value) {
            myMap[key] = value;
          });
          children.forEach((element) {
            var itmelement = element;
            if (!(Global.stringToDouble(element['re_height'].toString()) > 0) &&
                !(Global.stringToDouble(element['re_weight'].toString()) > 0)) {
              itmelement.remove('re_height');
              itmelement.remove('re_weight');
            }
            if (!(Global.stringToDouble(element['height'].toString()) > 0) &&
                !(Global.stringToDouble(element['weight'].toString()) > 0)) {
              itmelement.remove('height');
              itmelement.remove('weight');
            }
            if (!(Global.stringToDouble(element['height'].toString()) > 0)) {
              itmelement.remove('height');
            }
            if (Global.stringToIntNull(
                itmelement['do_you_have_height_weight'].toString()) ==
                2) {
              itmelement['do_you_have_height_weight'] = 0;
            }
            attepmtChild[element['childenrollguid']] = itmelement;
          });
        }
        if (alredRecord[0].name != null) {
          recrdedUpload = true;
        }
        if(role==CustomText.crecheSupervisor) {
          if (responseData['created_on'] != null ||
              responseData['created_by'] != null) {
            myMap['updated_on'] = Validate().currentDateTime();
            myMap['updated_by'] = userName;
          } else {
            myMap['created_by'] = userName;
            myMap['created_on'] = Validate().currentDateTime();
          }

          ChildGrowthMetaResponseModel? lastItem=await ChildGrowthResponseHelper().callMaxAnthroResponce(widget.creche_nameId,alredRecord.first.measurement_date!);

          if(Global.validString(lastItem?.responces)) {
            Map<String, dynamic> lastRecordResponce = jsonDecode(lastItem!.responces!);
            var lastRecordChild = lastRecordResponce['anthropromatic_details'];
            if (lastRecordChild != null && childs != null ) {
              List<Map<String, dynamic>> lastRecordschildren = List<Map<String, dynamic>>.from(lastRecordResponce['anthropromatic_details']);
              lastRecordschildren.forEach((itemMap) {
                var filterItem = enrolledChild.where((element) {return element.ChildEnrollGUID == itemMap['childenrollguid'];});
                if (filterItem.length > 0) {
                  var childEnrolleGUID=filterItem.first.ChildEnrollGUID;
                  var currentChildRecord = childs.where((element) {return element['childenrollguid'] == childEnrolleGUID;});
                  if(currentChildRecord.length>0) {
                    Map<String, dynamic> childItem = attepmtChild[childEnrolleGUID!]??{};
                    if (Global.validString(childEnrolleGUID) && childItem.isNotEmpty) {
                      if (itemMap['do_you_have_height_weight'].toString() ==
                          '1' && Global.stringToDouble(
                          currentChildRecord.first['height'].toString()) < 1) {

                        itemMap.forEach((key, value) {
                          if (key == 'height'||key == 'measurement_equipment') {
                            if ((Global.stringToDouble(value.toString()) > 0)&&key == 'height') {
                              childItem[key] = value;
                            }
                            // if ((Global.stringToDouble(value.toString()) > 0)&&key == 'measurement_equipment') {
                            //   childItem[key] = value;
                            // }
                          }
                        });
                        attepmtChild[childEnrolleGUID] = childItem;
                      }
                    }
                  }
                }
              });
            }
          }
        }
        countMesuredChildren();
      } else {
        var creCheDetails = await CrecheDataHelper()
            .getCrecheResponceItem(widget.creche_nameId);
        if (creCheDetails.length > 0) {
          myMap['created_by'] = userName;
          myMap['created_on'] = alredRecord.first.created_at;
          myMap['cgmguid'] = widget.cgmguid;
          myMap['creche_id'] = widget.creche_nameId;
          myMap['partner_id'] =
              Global.getItemValues(creCheDetails[0].responces!, 'partner_id');
          myMap['state_id'] =
              Global.getItemValues(creCheDetails[0].responces!, 'state_id');
          myMap['district_id'] =
              Global.getItemValues(creCheDetails[0].responces!, 'district_id');
          myMap['block_id'] =
              Global.getItemValues(creCheDetails[0].responces!, 'block_id');
          myMap['gp_id'] =
              Global.getItemValues(creCheDetails[0].responces!, 'gp_id');
          myMap['village_id'] =
              Global.getItemValues(creCheDetails[0].responces!, 'village_id');
          // myMap['measurement_date'] = Validate().createAtToCurrentDate(widget.createdAt);
        }
      }
    } else {
      var creCheDetails =
      await CrecheDataHelper().getCrecheResponceItem(widget.creche_nameId);
      if (creCheDetails.length > 0) {
        myMap['created_by'] = userName;
        myMap['created_on'] = Validate().currentDateTime();
        myMap['cgmguid'] = widget.cgmguid;
        myMap['creche_id'] = widget.creche_nameId;
        myMap['partner_id'] =
            Global.getItemValues(creCheDetails[0].responces!, 'partner_id');
        myMap['state_id'] =
            Global.getItemValues(creCheDetails[0].responces!, 'state_id');
        myMap['district_id'] =
            Global.getItemValues(creCheDetails[0].responces!, 'district_id');
        myMap['block_id'] =
            Global.getItemValues(creCheDetails[0].responces!, 'block_id');
        myMap['gp_id'] =
            Global.getItemValues(creCheDetails[0].responces!, 'gp_id');
        myMap['village_id'] =
            Global.getItemValues(creCheDetails[0].responces!, 'village_id');
        // myMap['measurement_date'] = Validate().createAtToCurrentDate(widget.createdAt);
      }
    }
  }

  updateItemsForChildren(
      Map<String, dynamic> itemsAnswred, String ChildEnrollGUID) {
    var cWidgetDatamap = attepmtChild[ChildEnrollGUID];
    if (cWidgetDatamap == null) {
      attepmtChild[ChildEnrollGUID] = itemsAnswred;
    } else {
      itemsAnswred.forEach((key, value) {
        cWidgetDatamap[key] = value;
      });
      attepmtChild[ChildEnrollGUID] = itemsAnswred;
    }
  }

  String callGenderName(String genderId) {
    String returnValue = '';
    var items = genders
        .where((element) => element.name.toString() == genderId)
        .toList();
    if (items.length > 0) {
      returnValue = items[0].values!;
    }
    return returnValue;
  }

  int countMesuredChildren() {
    int mesuCunt = 0;
    enrolledChild.forEach((element) {
      var item = attepmtChild[element.ChildEnrollGUID];
      if (item != null) {
        if ((Global.validString(item['measurement_taken_date'])) &&
            (Global.stringToDouble(item['weight'].toString()) > 0)) {
          mesuCunt = mesuCunt + 1;
        }
      }
    });
    // print('mesuCunt $mesuCunt');
    return mesuCunt;
  }

  int countMesuredChildrenForSave() {
    int mesuCunt = 0;
    enrolledChild.forEach((element) {
      var item = attepmtChild[element.ChildEnrollGUID];
      if (item != null) {
        if (((Global.validString(item['measurement_taken_date'])) &&
            (Global.stringToDouble(item['weight'].toString()) > 0)) ||
            Global.validString(item['measurement_reason'])) {
          mesuCunt = mesuCunt + 1;
        }
      }
    });
    // print('mesuCunt $mesuCunt');
    return mesuCunt;
  }

  DateTime? callMinMeasurementGrwthDate(String? mesurementDate) {
    if (mesurementDate != null) {
      DateTime todayDate = Validate().stringToDate(Validate().currentDate());
      var sMesurementDate = Validate().stringToDateNull(mesurementDate);
      if (sMesurementDate != null) {
        var mMesureDate = DateTime(sMesurementDate.year, sMesurementDate.month);
        var sCurenntDate = DateTime(todayDate.year, todayDate.month);
        if (mMesureDate == sCurenntDate) {
          sMesurementDate = sMesurementDate.subtract(Duration(days: 10));
          if (sMesurementDate.month != todayDate.month) {
            return sMesurementDate =
                DateTime(todayDate.year, todayDate.month, 1)
                    .subtract(Duration(days: 1));
          } else
            return sMesurementDate;
        } else {
          var sMesureMentDate = sMesurementDate.subtract(Duration(days: 10));
          if (sMesurementDate.month != sMesureMentDate.month) {
            return sMesurementDate =
                DateTime(sMesureMentDate.year, sMesureMentDate.month, 1)
                    .subtract(Duration(days: 1));
          } else
            return sMesureMentDate;
        }
      }
      return null;
    } else
      return null;
  }

  DateTime? callMinMeasurementGrwthDateTemp(String? mesurementDate) {
    if (mesurementDate != null) {
      DateTime todayDate = Validate().stringToDate(Validate().currentDate());
      var sMesurementDate = Validate().stringToDateNull(mesurementDate);
      if (sMesurementDate != null) {
        var mMesureDate = DateTime(sMesurementDate.year, sMesurementDate.month);
        var sCurenntDate = DateTime(todayDate.year, todayDate.month);
        if (mMesureDate == sCurenntDate) {
          sMesurementDate = DateTime(mMesureDate.year, mMesureDate.month, 1);
          if (sMesurementDate.month != todayDate.month) {
            return sMesurementDate =
                DateTime(todayDate.year, todayDate.month, 1)
                    .subtract(Duration(days: 1));
          } else
            return sMesurementDate;
        } else {
          var sMesureMentDate = sMesurementDate.subtract(Duration(days: 10));
          if (sMesurementDate.month != sMesureMentDate.month) {
            return sMesurementDate =
                DateTime(sMesureMentDate.year, sMesureMentDate.month, 1)
                    .subtract(Duration(days: 1));
          } else
            return sMesureMentDate;
        }
      }
      return null;
    } else
      return null;
  }

  DateTime? callMaxMeasurementGrwthDate(String? mesurementDate) {
    if (mesurementDate != null) {
      DateTime todayDate = Validate().stringToDate(Validate().currentDate());
      var sMesurementDate = Validate().stringToDateNull(mesurementDate);
      if (sMesurementDate != null) {
        var mMesureDate = DateTime(sMesurementDate.year, sMesurementDate.month);
        var sCurenntDate = DateTime(todayDate.year, todayDate.month);
        if (mMesureDate == sCurenntDate) {
          sMesurementDate = sMesurementDate.add(Duration(days: 10));
          if (sMesurementDate.month != todayDate.month) {
            if (sMesurementDate.month > 12) {
              sMesurementDate = DateTime(sMesurementDate.year + 1, 1);
            }
            sMesurementDate = DateTime(todayDate.year, todayDate.month, 1);
          } else {
            if (sMesurementDate.isAfter(todayDate))
              return todayDate.add(Duration(days: 1));
            else
              return sMesurementDate;
          }
        } else {
          var sMesureMentDate = sMesurementDate.add(Duration(days: 10));
          if (sMesureMentDate.month != mMesureDate.month) {
            if (sMesurementDate.month > 12) {
              sMesurementDate = DateTime(sMesurementDate.year + 1, 1);
            } else
              sMesurementDate =
                  DateTime(sMesureMentDate.year, sMesureMentDate.month, 1);
          } else {
            sMesurementDate = sMesureMentDate;
          }
          // else {
          //
          return sMesurementDate;
          // }
        }
      }
      return null;
    } else
      return null;
  }

  Future callEnrollementChildList(String selectedDate) async {
    attepmtChild = {};
    enrolledChild = await EnrolledExitChilrenResponceHelper()
        .enrolledChildByCrecheWithDateOfExit(
        widget.creche_nameId, selectedDate);
    DateTime? dateOfMesurement = Validate().stringToDateNull(selectedDate);
    enrolledChild = enrolledChild.where((element) {
      DateTime? enrolledDate = Validate().stringToDateNull(
          Global.getItemValues(element.responces, 'date_of_enrollment'));
      if (dateOfMesurement != null && enrolledDate != null) {
        if (dateOfMesurement.isAfter(enrolledDate) ||
            dateOfMesurement == (enrolledDate)) return true;
      }
      return false;
    }).toList();

    ChildGrowthMetaResponseModel? lastItem=await ChildGrowthResponseHelper().callMaxAnthroResponce(widget.creche_nameId,selectedDate);

    if(Global.validString(lastItem?.responces)) {
      Map<String, dynamic> responseData = jsonDecode(lastItem!.responces!);
      var childs = responseData['anthropromatic_details'];
      if (childs != null) {
        List<Map<String, dynamic>> children = List<Map<String, dynamic>>.from(responseData['anthropromatic_details']);

        children.forEach((itemMap) {
          var filterItem = enrolledChild.where((element) {return element.ChildEnrollGUID == itemMap['childenrollguid'];});

          if (filterItem.length > 0) {
            var childEnrolleGUID=filterItem.first.ChildEnrollGUID;
            var cWidgetDatamap = attepmtChild[childEnrolleGUID];
            if (cWidgetDatamap == null&&Global.validString(childEnrolleGUID)) {
              if(itemMap['do_you_have_height_weight'].toString()=='1'){
                Map<String, dynamic> childItem= {};
                itemMap.forEach((key, value) {
                  if(key=='height'||key=='do_you_have_height_weight'||key=='measurement_equipment'){
                    if(key=='height' && Global.stringToDouble(value.toString())>0) {
                      childItem[key] = value;
                    }else   if(key!='height'){
                      childItem[key] = value;
                    // }else if(key=='measurement_equipment' && Global.stringToInt(value.toString())>0) {
                    //   childItem[key] = value;
                    }
                  }
                });
                attepmtChild[childEnrolleGUID!] = childItem;
              }

            }
          }
        });
      }
    }



    filterdData = enrolledChild;
    setState(() {});
  }

  filterDataQu(String entry) {
    if (entry.length > 0) {
      filterdData = enrolledChild
          .where((element) =>
          (Global.getItemValues(element.responces!, 'child_name'))
              .toLowerCase()
              .startsWith(entry.toLowerCase()))
          .toList();
    } else {
      filterdData = enrolledChild;
    }
    setState(() {});
  }


  List<Widget> cWidgetRadiomColorPop(String ChildEnrollGUID,
      Map<String, dynamic> cWidgetDatamap, String gender) {
    var inputItem = formItem
        .where((element) =>
    (element.fieldname == 're_weight_for_age' ||
        element.fieldname == 're_weight_for_height' ||
        element.fieldname == 're_height_for_age') &&
        popItems.contains(element.fieldname))
        .toList();
    List<Widget> screenItems = [];
    if (inputItem.length > 0) {
      for (int i = 0; i < inputItem.length; i++) {
        var isvible = logic!.callDependingLogic(cWidgetDatamap, inputItem[i]);
        int colorD = DependingLogic.AutoColorCreateByHeightWightNew(
            tabHeightforageBoys,
            tHeightforageGirls,
            tabWeightforageBoys,
            tabWeightforageGirls,
            tabWeightToHeightBoys,
            tabWeightToHeightGirls,
            inputItem[i].fieldname!,
            gender,cWidgetDatamap['re_measurement_taken_date'],
            cWidgetDatamap);

        String grothValue = DependingLogic.AutoColorCreateByHeightWightStringNew(
            tabHeightforageBoys,
            tHeightforageGirls,
            tabWeightforageBoys,
            tabWeightforageGirls,
            tabWeightToHeightBoys,
            tabWeightToHeightGirls,
            inputItem[i].fieldname!,
            gender,cWidgetDatamap['re_measurement_taken_date'],
            cWidgetDatamap);

        Color itemC = Color(0xffAAAAAA);
        String colorName = '';
        if (colorD == 0) {
          itemC = Color(0xffAAAAAA);
          colorName = '';
        } else if (colorD == 1) {
          itemC = Color(0xffF35858);
          colorName =
          '(${Global.returnTrLable(translatsLabel, CustomText.Severe, lng)})';
        } else if (colorD == 2) {
          itemC = Color(0xffF4B81D);
          colorName =
          '(${Global.returnTrLable(translatsLabel, CustomText.Moderate, lng)})';
        } else if (colorD == 3) {
          itemC = Color(0xff8BF649);
          colorName =
          '(${Global.returnTrLable(translatsLabel, CustomText.Normal, lng)})';
        }
        countMesuredChildren();
        cWidgetDatamap[inputItem[i].fieldname!] = colorD;
        if (isvible) {
          screenItems.add(Column(
            children: [
              Container(
                height: 25,
                width: 25,
                decoration: BoxDecoration(
                  color: itemC,
                  borderRadius: BorderRadius.circular(5.r),
                ),
              ),
              Text(
                Global.returnTrLable(
                    translatsLabel, inputItem[i].label!.trim(), lng),
                style: Styles.black85,
                strutStyle: StrutStyle(height: 1.2),
              ),
              Text(
                colorName,
                style: Styles.black12700,
              ),
              Global.validString(grothValue)
                  ? Text(
                '($grothValue)',
                style: Styles.red85,
              )
                  : SizedBox(),
            ],
          ));
        }
        if (!isvible) {
          cWidgetDatamap.remove(inputItem[i].fieldname);
        }
      }
    }
    return screenItems;
  }

  void _reEnterDailog(BuildContext context, String childEnrollGUID) {
    Map<String, dynamic> cWidgetDatamap = {};
    var parentItem = attepmtChild[childEnrollGUID];
    String? mesumentDate='';
    var childItem = filterdData
        .where((element) => element.ChildEnrollGUID == childEnrollGUID)
        .toList();

    cWidgetDatamap['re_do_you_have_height_weight'] = 1;
    cWidgetDatamap['childenrollguid'] = childEnrollGUID;

    if (parentItem != null) {
      mesumentDate = parentItem['measurement_taken_date'];
      parentItem.forEach((key, value) {
        if (popItems.contains(key)) {
          if(Global.stringToInt(parentItem['re_do_you_have_height_weight'].toString())==0
              && parentItem['re_measurement_reason']!=null){
              cWidgetDatamap[key] = value;
          }else if(Global.stringToInt(parentItem['re_do_you_have_height_weight'].toString())==1){
            cWidgetDatamap[key] = value;
          }

        }
      });
    }

    HouseHoldFielItemdModel? re_measurement_equipment;
    HouseHoldFielItemdModel? re_do_you_have_height_weight;
    HouseHoldFielItemdModel? re_measurement_taken_date;
    HouseHoldFielItemdModel? re_height;
    HouseHoldFielItemdModel? re_weight;
    HouseHoldFielItemdModel? re_measurement_reason;

    var measurementTakenDate = formItem
        .where((element) => element.fieldname == 're_measurement_taken_date')
        .toList();

    var haveMesure = formItem
        .where((element) => element.fieldname == 're_do_you_have_height_weight')
        .toList();

    var height =
    formItem.where((element) => element.fieldname == 're_height').toList();

    var weight =
    formItem.where((element) => element.fieldname == 're_weight').toList();

    if (haveMesure.length > 0) {
      re_do_you_have_height_weight = haveMesure.first;
    }

    var measurementEquipment = formItem
        .where((element) => element.fieldname == 're_measurement_equipment')
        .toList();

    var measurement_reason = formItem
        .where((element) => element.fieldname == 're_measurement_reason')
        .toList();

    if (measurementEquipment.length > 0) {
      re_measurement_equipment = measurementEquipment.first;
    }
    if (measurementTakenDate.length > 0) {
      re_measurement_taken_date = measurementTakenDate.first;
    }
    if (height.length > 0) {
      re_height = height.first;
    }
    if (weight.length > 0) {
      re_weight = weight.first;
    }
    if (measurement_reason.length > 0) {
      re_measurement_reason = measurement_reason.first;
    }

    List<OptionsModel> items = options
        .where((element) =>
    element.flag == 'tab${re_measurement_equipment!.options}')
        .toList();

    List<OptionsModel> reasonItems = options
        .where(
            (element) => element.flag == 'tab${re_measurement_reason!.options}')
        .toList();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              contentPadding: EdgeInsets.zero,
              content: Container(
                width: MediaQuery.of(context).size.width *
                    7, // 80% of screen width
                child: SingleChildScrollView(
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        Container(
                          height: 40.h,
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Color(0xff5979AA),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5.0),
                              topRight: Radius.circular(5.0),
                            ),
                          ),
                          child: Center(
                              child:
                              Text(Global.returnTrLable(translatsLabel, CustomText.updateMeasurement, lng), style: Styles.white126P)),
                        ),
                        StatefulBuilder(
                            builder: (BuildContext context, StateSetter setState) {
                              return SingleChildScrollView(
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      DynamicCustomYesNoCheckboxWithLabel(
                                        label: Global.returnTrLable(
                                            translatsLabel,
                                            re_do_you_have_height_weight?.label.toString(),
                                            lng),
                                        initialValue: Global.stringToIntNull(cWidgetDatamap[
                                        re_do_you_have_height_weight?.fieldname]
                                            .toString()),
                                        isRequred: 1,
                                        labelControlls: translatsLabel,
                                        lng: lng,
                                        readable: logic!.callReadableLogic(
                                            cWidgetDatamap, re_do_you_have_height_weight!),
                                        isVisible: logic!.callDependingLogic(
                                            cWidgetDatamap, re_do_you_have_height_weight),
                                        onChanged: (value) {
                                          cWidgetDatamap[re_do_you_have_height_weight!
                                              .fieldname!] = value;
                                          setState(() {});
                                        },
                                      ),
                                      CustomDatepickerDynamic(
                                        calenderValidate: [],
                                        minDate: Global.stringToDate(mesumentDate)?.subtract(Duration(days: 1)),
                                        titleText: Global.returnTrLable(translatsLabel,
                                            re_measurement_taken_date!.label!.trim(), lng),
                                        isVisible: logic!.callDependingLogic(
                                            cWidgetDatamap, re_measurement_taken_date),
                                        initialvalue: cWidgetDatamap[
                                        re_measurement_taken_date.fieldname!],
                                        fieldName: re_measurement_taken_date.fieldname,
                                        isRequred: logic!.dependeOnMendotory(
                                            cWidgetDatamap, re_measurement_taken_date),
                                        onChanged: (value) {
                                          cWidgetDatamap[
                                          re_measurement_taken_date!.fieldname!] = value;
                                          var logData = logic!.callDateDiffrenceLogic(
                                              cWidgetDatamap, re_measurement_taken_date);
                                          if (logData.isNotEmpty) {
                                            if (logData.keys.length > 0) {
                                              cWidgetDatamap.addEntries([
                                                MapEntry(
                                                    logData.keys.first, logData.values.first)
                                              ]);
                                  
                                            }
                                          }
                                  
                                          var date = Validate().stringToDate(
                                              Global.getItemValues(
                                                  childItem.first.responces, 'child_dob'));
                                  
                                          int calucalteDate = 0;
                                          if (cWidgetDatamap['re_measurement_taken_date'] !=
                                              null) {
                                            var mesurmentDate = Validate().stringToDate(
                                                cWidgetDatamap['re_measurement_taken_date']);
                                            calucalteDate = Validate()
                                                .calculateAgeInDaysEx(date, mesurmentDate);
                                          } else
                                            calucalteDate =
                                                Validate().calculateAgeInDays(date);
                                  
                                          cWidgetDatamap['re_age_months'] = calucalteDate;
                                  
                                          setState(() {});
                                        },
                                      ),
                                      DynamicCustomDropdownField(
                                        hintText: Global.returnTrLable(
                                            translatsLabel, CustomText.select_here, lng),
                                        titleText: Global.returnTrLable(translatsLabel,
                                            re_measurement_equipment!.label!.trim(), lng),
                                        isRequred: logic!.dependeOnMendotory(
                                            cWidgetDatamap, re_measurement_equipment),
                                        items: items,
                                        selectedItem: cWidgetDatamap[
                                        re_measurement_equipment.fieldname!],
                                        isVisible: logic!.callDependingLogic(
                                            cWidgetDatamap, re_measurement_equipment),
                                        onChanged: (value) {
                                          if (value != null)
                                            cWidgetDatamap[re_measurement_equipment!
                                                .fieldname!] = value.name;
                                          else
                                            cWidgetDatamap
                                                .remove(re_measurement_equipment!.fieldname);
                                  
                                          setState(() {});
                                        },
                                      ),
                                      DynamicCustomDropdownField(
                                        hintText: Global.returnTrLable(
                                            translatsLabel, CustomText.select_here, lng),
                                        titleText: Global.returnTrLable(translatsLabel,
                                            re_measurement_reason!.label!.trim(), lng),
                                        isRequred: logic!.dependeOnMendotory(
                                            cWidgetDatamap, re_measurement_reason),
                                        items: reasonItems,
                                        selectedItem:
                                        cWidgetDatamap[re_measurement_reason.fieldname!],
                                        isVisible: logic!.callDependingLogic(
                                            cWidgetDatamap, re_measurement_reason),
                                        onChanged: (value) {
                                          if (value != null)
                                            cWidgetDatamap[re_measurement_reason!
                                                .fieldname!] = value.name;
                                          else
                                            cWidgetDatamap
                                                .remove(re_measurement_reason!.fieldname);
                                  
                                          setState(() {});
                                        },
                                      ),
                                      Container(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            DynamicCustomTextFieldFloat(
                                              width: MediaQuery.of(context).size.width * 0.3,
                                              hintText: Global.returnTrLable(
                                                  translatsLabel, CustomText.typehere, lng),
                                              titleText: Global.returnTrLable(translatsLabel,
                                                  re_height!.label!.trim(), lng),
                                              keyboardtype: TextInputType.number,
                                              isRequred: logic!.dependeOnMendotory(
                                                  cWidgetDatamap, re_height),
                                              maxlength: re_height.length,
                                              initialvalue:
                                              cWidgetDatamap[re_height.fieldname!],
                                              readable: logic!.callReadableLogic(
                                                  cWidgetDatamap, re_height),
                                              isVisible: logic!.callDependingLogic(
                                                  cWidgetDatamap, re_height),
                                              fieldName: re_height.fieldname!,
                                              onChanged: (value) {
                                                if (value != null) {
                                                  cWidgetDatamap[re_height!.fieldname!] =
                                                      value;
                                                  var logData = logic!.callAutoGeneratedValue(
                                                      cWidgetDatamap, re_height);
                                                  if (logData.isNotEmpty) {
                                                    if (logData.keys.length > 0) {
                                                      cWidgetDatamap.addEntries([
                                                        MapEntry(logData.keys.first,
                                                            logData.values.first)
                                                      ]);
                                                    }
                                                  }
                                                } else {
                                                  cWidgetDatamap.remove(re_height?.fieldname);
                                                }
                                              },
                                            ),
                                            DynamicCustomTextFieldFloat(
                                              width: MediaQuery.of(context).size.width * 0.3,
                                              hintText: Global.returnTrLable(
                                                  translatsLabel, CustomText.typehere, lng),
                                              titleText: Global.returnTrLable(translatsLabel,
                                                  re_weight!.label!.trim(), lng),
                                              keyboardtype: TextInputType.number,
                                              isRequred: logic!.dependeOnMendotory(
                                                  cWidgetDatamap, re_weight),
                                              maxlength: re_weight.length,
                                              initialvalue:
                                              cWidgetDatamap[re_weight.fieldname!],
                                              readable: logic!.callReadableLogic(
                                                  cWidgetDatamap, re_weight),
                                              isVisible: logic!.callDependingLogic(
                                                  cWidgetDatamap, re_weight),
                                              fieldName: re_weight.fieldname!,
                                              onChanged: (value) {
                                                if (value != null) {
                                                  cWidgetDatamap[re_weight!.fieldname!] =
                                                      value;
                                                  var logData = logic!.callAutoGeneratedValue(
                                                      cWidgetDatamap, re_weight);
                                                  if (logData.isNotEmpty) {
                                                    if (logData.keys.length > 0) {
                                                      cWidgetDatamap.addEntries([
                                                        MapEntry(logData.keys.first,
                                                            logData.values.first)
                                                      ]);
                                                    }
                                                  }
                                                } else {
                                                  cWidgetDatamap.remove(re_weight!.fieldname);
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      cWidgetDatamap['re_do_you_have_height_weight'] != 0
                                          ? Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(color: Color(0xffE0E0E0)),
                                          borderRadius: BorderRadius.circular(10.r),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: cWidgetRadiomColorPop(
                                              childEnrollGUID,
                                              cWidgetDatamap,
                                              Global.getItemValues(
                                                  childItem.first.responces,
                                                  'gender_id')),
                                        ),
                                      )
                                          : SizedBox(),
                                      SizedBox(height: 20,),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: CElevatedButton(
                                                text: Global.returnTrLable(
                                                    translatsLabel, CustomText.Cancel, lng),
                                                color: Color(0xffDB4B73),
                                                onPressed: () => Navigator.of(context).pop()),
                                          ),
                                          SizedBox(width: 10),
                                          Expanded(
                                            child: CElevatedButton(
                                                text: Global.returnTrLable(
                                                    translatsLabel, CustomText.Submit, lng),
                                                color: Color(0xff369A8D),
                                                onPressed: () async {
                                                  if(checkValidateForPop(cWidgetDatamap)){
                                                    await saveDataForPop(cWidgetDatamap, childEnrollGUID,childItem.first);
                                                    Navigator.of(context).pop();
                                                  }
                                                }),
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 20,),
                                    ],
                                  ),
                                ),
                              );
                            })
                      ],
                    ),
                  ),
                ),
              ),
                )
              // ]),
        );
      },
    );
  }

  Future<void> saveDataForPop(
      Map<String, dynamic> cWidgetDatamap, String childEnrollGUID,EnrolledExitChildResponceModel enrollChildItem) async
  {
    print(cWidgetDatamap);
    var alredRecord = await ChildGrowthResponseHelper()
        .callAnthropometryByGuid(widget.cgmguid);

    if (alredRecord.length > 0) {
      if (alredRecord.first.responces != null) {
        Map<String, dynamic> responseData =
        jsonDecode(alredRecord[0].responces!);
        var childs = responseData['anthropromatic_details'];
        if (childs != null) {
          List<Map<String, dynamic>> children = List<Map<String, dynamic>>.from(
              responseData['anthropromatic_details']);
          var childItem = children
              .where((element) => element['childenrollguid'] == childEnrollGUID)
              .toList();

          if (childItem.length > 0) {
            children.remove(childItem.first);
            if (cWidgetDatamap['re_do_you_have_height_weight'].toString() ==
                '1') {
              cWidgetDatamap.remove('re_measurement_reason');
              childItem.first.remove('re_measurement_reason');

              var gender = Global.getItemValues(enrollChildItem.responces, 'gender_id');

              var weightForAge = DependingLogic.AutoColorCreateByHeightWightNew(
                  tabHeightforageBoys,
                  tHeightforageGirls,
                  tabWeightforageBoys,
                  tabWeightforageGirls,
                  tabWeightToHeightBoys,
                  tabWeightToHeightGirls,
                  're_weight_for_age',
                  gender,cWidgetDatamap['re_measurement_taken_date'],
                  cWidgetDatamap);
              var heightForAge = DependingLogic.AutoColorCreateByHeightWightNew(
                  tabHeightforageBoys,
                  tHeightforageGirls,
                  tabWeightforageBoys,
                  tabWeightforageGirls,
                  tabWeightToHeightBoys,
                  tabWeightToHeightGirls,
                  're_height_for_age',
                  gender,cWidgetDatamap['re_measurement_taken_date'],
                  cWidgetDatamap);
              var weightForHeight = DependingLogic.AutoColorCreateByHeightWightNew(
                  tabHeightforageBoys,
                  tHeightforageGirls,
                  tabWeightforageBoys,
                  tabWeightforageGirls,
                  tabWeightToHeightBoys,
                  tabWeightToHeightGirls,
                  're_weight_for_height',
                  gender,cWidgetDatamap['re_measurement_taken_date'],
                  cWidgetDatamap);

              cWidgetDatamap['re_weight_for_age'] = weightForAge;
              cWidgetDatamap['re_height_for_age'] = heightForAge;
              cWidgetDatamap['re_weight_for_height'] = weightForHeight;

              var re_weight_for_age_zscore = DependingLogic.AutoColorCreateByHeightWightStringNew(
                  tabHeightforageBoys,
                  tHeightforageGirls,
                  tabWeightforageBoys,
                  tabWeightforageGirls,
                  tabWeightToHeightBoys,
                  tabWeightToHeightGirls,
                  're_weight_for_age',
                  gender,cWidgetDatamap['re_measurement_taken_date'],
                  cWidgetDatamap);
              var re_height_for_age_zscore = DependingLogic.AutoColorCreateByHeightWightStringNew(
                  tabHeightforageBoys,
                  tHeightforageGirls,
                  tabWeightforageBoys,
                  tabWeightforageGirls,
                  tabWeightToHeightBoys,
                  tabWeightToHeightGirls,
                  're_height_for_age',
                  gender,cWidgetDatamap['re_measurement_taken_date'],
                  cWidgetDatamap);
              var re_weight_for_height_zscore = DependingLogic.AutoColorCreateByHeightWightStringNew(
                  tabHeightforageBoys,
                  tHeightforageGirls,
                  tabWeightforageBoys,
                  tabWeightforageGirls,
                  tabWeightToHeightBoys,
                  tabWeightToHeightGirls,
                  're_weight_for_height',
                  gender,cWidgetDatamap['re_measurement_taken_date'],
                  cWidgetDatamap);

              cWidgetDatamap['re_weight_for_age_zscore'] = re_weight_for_age_zscore;
              cWidgetDatamap['re_height_for_age_zscore'] = re_height_for_age_zscore;
              cWidgetDatamap['re_weight_for_height_zscore'] = re_weight_for_height_zscore;

            } else {
              cWidgetDatamap.remove('re_height');
              cWidgetDatamap.remove('re_weight');
              cWidgetDatamap.remove('re_measurement_taken_date');
              cWidgetDatamap.remove('re_measurement_equipment');
              cWidgetDatamap.remove('re_age_months');
              cWidgetDatamap.remove('re_weight_for_age');
              cWidgetDatamap.remove('re_weight_for_height');
              cWidgetDatamap.remove('re_height_for_age');

              cWidgetDatamap.remove('re_weight_for_age_zscore');
              cWidgetDatamap.remove('re_weight_for_height_zscore');
              cWidgetDatamap.remove('re_height_for_age_zscore');

              childItem.first.remove('re_height');
              childItem.first.remove('re_weight');
              childItem.first.remove('re_measurement_taken_date');
              childItem.first.remove('re_measurement_equipment');
              childItem.first.remove('re_age_months');
              childItem.first.remove('re_weight_for_age');
              childItem.first.remove('re_weight_for_height');
              childItem.first.remove('re_height_for_age');

              childItem.first.remove('re_weight_for_age_zscore');
              childItem.first.remove('re_weight_for_height_zscore');
              childItem.first.remove('re_height_for_age_zscore');
            }
            if(cWidgetDatamap['re_created_on']!=null || cWidgetDatamap['re_created_by']!=null){
              cWidgetDatamap['re_updated_by'] = userName;
              cWidgetDatamap['re_updated_on'] = Validate().currentDateTime();;
            }else{
              cWidgetDatamap['re_created_on'] = Validate().currentDateTime();;
              cWidgetDatamap['re_created_by'] = userName;
            }
            childItem.first.addAll(cWidgetDatamap);
            children.add(childItem.first);
            responseData['anthropromatic_details'] = children;
            print(responseData);

            var measurementDate = responseData['measurement_date'];
            var responcesJs = jsonEncode(responseData);
            var name = responseData['name'];
            await ChildGrowthResponseHelper().insertUpdate(
                widget.cgmguid,
                measurementDate,
                name as int?,
                widget.creche_nameId,
                responcesJs,
                myMap['created_by'],
                myMap['created_on'],myMap['updated_on'],myMap['updated_by']);
            updateHiddenValue();
          }
        }
      }
    }
  }

  bool checkValidateForPop(Map<String, dynamic> cWidgetDatamap) {
    bool validStatus=true;
    var popItem=formItem.where((element)=>popItems.contains(element.fieldname)).toList();
    for (int i = 0; i < popItem.length; i++) {

      var validationMsg = logic!.validationMessge(cWidgetDatamap, popItem[i]);

      // if (isMesurement(cWidgetDatamap['re_measurement_taken_date']) == false &&
      //     (popItem[i].fieldname == 're_height' ||
      //         popItem[i].fieldname == 're_measurement_equipment') &&
      //     Global.validString(validationMsg)) {
      //   validationMsg = '';
      // }
      if (Global.validString(validationMsg)) {
        validStatus = false;
        Validate().singleButtonPopup(
            validationMsg!,
            Global.returnTrLable(translatsLabel, CustomText.ok, lng),
            false,
            context);
        return validStatus;
      }
    }
    if(validStatus) {
      if (cWidgetDatamap['re_do_you_have_height_weight'] == null) {
        Validate().singleButtonPopup(
            Global.returnTrLable(
                translatsLabel, CustomText.pleaseSelectMeasurementTaken, lng),
            Global.returnTrLable(translatsLabel, CustomText.ok, lng),
            false,
            context);
        validStatus = false;
      }
      else
      if (cWidgetDatamap['re_do_you_have_height_weight'].toString() == '1') {
        if (!Global.validString(cWidgetDatamap['re_measurement_taken_date'])) {
          Validate().singleButtonPopup(
              Global.returnTrLable(
                  translatsLabel, CustomText.plsSelectMesureDate, lng),
              Global.returnTrLable(translatsLabel, CustomText.ok, lng),
              false,
              context);
          validStatus = false;
        } else
        if (!Global.validString(cWidgetDatamap['re_measurement_equipment'])) {
          Validate().singleButtonPopup(
              Global.returnTrLable(
                  translatsLabel, CustomText.plsSelectMesureEquip, lng),
              Global.returnTrLable(translatsLabel, CustomText.ok, lng),
              false,
              context);
          validStatus = false;
        } else
        if (Global.stringToDouble(cWidgetDatamap['re_weight'].toString()) ==
            0) {
          Validate().singleButtonPopup(
              Global.returnTrLable(
                  translatsLabel, CustomText.plsSelectWeight, lng),
              Global.returnTrLable(translatsLabel, CustomText.ok, lng),
              false,
              context);
          validStatus = false;
        }
      }
      else if (cWidgetDatamap['re_do_you_have_height_weight'].toString() ==
          '0') {
        if (!Global.validString(cWidgetDatamap['re_measurement_reason'])) {
          Validate().singleButtonPopup(
              Global.returnTrLable(
                  translatsLabel, CustomText.plsSelectreason, lng),
              Global.returnTrLable(translatsLabel, CustomText.ok, lng),
              false,
              context);
          validStatus = false;
        }
      }
    }
    return validStatus;
  }
}
