import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/custom_widget/custom_appbar.dart';
import 'package:shishughar/database/helper/dynamic_screen_helper/options_model_helper.dart';
import 'package:shishughar/database/helper/enrolled_exit_child/enrolled_exit_child_responce_helper.dart';
import 'package:shishughar/model/apimodel/house_hold_field_item_model_api.dart';
import 'package:shishughar/model/apimodel/translation_language_api_model.dart';

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
import '../../../model/dynamic_screen_model/enrolled_child_exit_responce_model.dart';
import '../../../model/dynamic_screen_model/options_model.dart';
import '../../../style/styles.dart';
import '../../../utils/custom_three_color_circle_image.dart';
import '../../../utils/globle_method.dart';
import '../../../utils/validate.dart';
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
    'age_months',
    'measurement_date',
    'weight_for_age',
    'weight_for_height',
    'height_for_age',
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
  bool recrdedUpload = false;
  String lng = 'en';
  String userName = '';
  String? role;
  int? expends;
  // Map<String, Map<String, FocusNode>> _foocusNode = {};
  // ScrollController _scrollScontroller = ScrollController();

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  // @override
  // void dispose() {
  //   _scrollScontroller.dispose();
  //   _foocusNode.forEach((_, childMap) {
  //     childMap.forEach((_, focusNode) => focusNode.dispose());
  //   });
  //   super.dispose();
  // }

  Future<void> initializeData() async {
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
      'Search',
      'Name',
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
      CustomText.leavingLesThanjoining
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
    return WillPopScope(
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
                        // Expanded(
                        //   child: RichText(
                        //     text: TextSpan(
                        //       text: Global.returnTrLable(translatsLabel,
                        //           CustomText.TotalChildren, lng),
                        //       style: Styles.black124,
                        //       children: [
                        //         TextSpan(
                        //           text: ' : ${enrolledChild.length}',
                        //           style: Styles.red145,
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
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
                            minDate: widget.lastGrowthDate,
                            maxDate: widget.minGrowthDate,
                            // minDate: callMinMeasurementGrwthDate(  for back dated entery
                            //     myMap[measurement_date!.fieldname!] != null
                            //         ? myMap[measurement_date!.fieldname!]
                            //         : Validate().currentDate())!.subtract(Duration(days: 1)),
                            // maxDate: callMaxMeasurementGrwthDate(
                            //     myMap[measurement_date!.fieldname!] != null
                            //         ? myMap[measurement_date!.fieldname!]
                            //         : Validate()
                            //             .currentDate()), //widget.minGrowthDate,
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
                          ? Global.returnTrLable(translatsLabel, 'Search', lng!)
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
    );
  }

  List<Widget> cWidgetInputType(
      String ChildEnrollGUID, Map<String, dynamic> cWidgetDatamap) {
    // var cWidgetDatamap = attepmtChild[ChildEnrollGUID];
    // if (cWidgetDatamap == null) {
    //   cWidgetDatamap = {};
    //   attepmtChild[ChildEnrollGUID] = cWidgetDatamap;
    // }
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
          // print('remo3 ${inputItem[i].fieldname}');
          cWidgetDatamap.remove(inputItem[i].fieldname);
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
    if (inputItem.length > 0) {
      for (int i = 0; i < inputItem.length; i++) {
        var isvible = logic!.callDependingLogic(cWidgetDatamap, inputItem[i]);
        int colorD = DependingLogic.AutoColorCreateByHeightWight(
            tabHeightforageBoys,
            tHeightforageGirls,
            tabWeightforageBoys,
            tabWeightforageGirls,
            tabWeightToHeightBoys,
            tabWeightToHeightGirls,
            inputItem[i].fieldname!,
            gender,
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
                style: Styles.red85,
              ),
              // Global.validString(grothValue)
              //     ? Text(
              //         '($grothValue)',
              //         style: Styles.red85,
              //       )
              //     : SizedBox(),
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
    // var cWidgetDatamap = attepmtChild[ChildEnrollGUID];
    // if (cWidgetDatamap == null) {
    //   cWidgetDatamap = {};
    //   attepmtChild[ChildEnrollGUID] = cWidgetDatamap;
    // }
    var inputItem = formItem
        .where((element) => element.fieldname == 'illness_multi')
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
    // var cWidgetDatamap = attepmtChild[ChildEnrollGUID];
    // if (cWidgetDatamap == null) {
    //   cWidgetDatamap = {};
    //   attepmtChild[ChildEnrollGUID] = cWidgetDatamap;
    // }
    List<Widget> screenItems = [];
    // var inputItem = formItem
    //     .where((element) => element.fieldname == 'illness_multi')
    //     .toList();
    // if (inputItem.length > 0) {
    //   var isvible = logic!
    //       .callDependingLogic( cWidgetDatamap, inputItem[0]);
    //   if (isvible) {
    //     // screenItems.add(Text(
    //     //   Global.returnTrLable(translatsLabel, inputItem[0].label!.trim(), lng),
    //     //   style: Styles.black124,
    //     // ));
    //     // screenItems.add(SizedBox(
    //     //   height: 10.h,
    //     // ));
    //     screenItems.add(widgetTypeWidgetinlessForMulti(
    //         inputItem[0], cWidgetDatamap, ChildEnrollGUID));
    //   } else
    //     screenItems.add(SizedBox());
    // } else
    //   screenItems.add(SizedBox());
    // screenItems.add(SizedBox(
    //   height: 10,
    // ));
    var otherItem = formItem
        .where((element) => (!hiddenItem.contains(element.fieldname)))
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
        // _foocusNode.addEntries(
        //     [MapEntry(enrolledChild[i].ChildEnrollGUID!, focusMaps)]);
        // _scrollScontroller.addListener(() {
        //   if (_scrollScontroller.position.isScrollingNotifier.value) {
        //     _foocusNode.forEach((_, childMap) {
        //       childMap.forEach((_, focusNode) => focusNode.unfocus());
        //     });
        //   }
        // });
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
          cWidgetDatamap['do_you_have_height_weight'] = 1;
          if (!widget.isNew) {
            cWidgetDatamap['measurement_taken_date'] =
                myMap['measurement_date'];
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
          } else
            calucalteDate = Validate().calculateAgeInDays(date);
          cWidgetDatamap['age_months'] = calucalteDate;
          if (!widget.isNew) {
            cWidgetDatamap['measurement_taken_date'] =
                myMap['measurement_date'];
          }
          attepmtChild[filterdData[i].ChildEnrollGUID!] = cWidgetDatamap;
        }

        screenItems.add(
          Padding(
            padding: EdgeInsets.only(bottom: 15),
            child: Container(
              // height: expends == i
              //     ? MediaQuery.of(context).size.height * 0.5
              //     : 50.h,
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
                                      : null),
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
        var item = Validate()
            .keyesFromResponce(attepmtChild[element.ChildEnrollGUID]!);
        if (item != null) {
          item['childenrollguid'] = element.ChildEnrollGUID;
          item['chhguid'] = element.CHHGUID;
          item['child_id'] = element.name;
          item['cgmguid'] = widget.cgmguid;
          if (((Global.stringToInt(
                          item['do_you_have_height_weight'].toString()) !=
                      1) ||
                  item['measurement_equipment'] == null ||
                  item['weight'] == null ||
                  item['height'] == null) &&
              isMesurement(myMap[measurement_date!.fieldname])) {
            item.remove('weight_for_age');
            item.remove('height_for_age');
            item.remove('weight_for_height');
            item.remove('measurement_equipment');
            item.remove('measurement_taken_date');
            item.remove('height');
            item.remove('weight');
            item['do_you_have_height_weight'] = 0;
            // print(item['height']);
          } else {
            var gender = Global.getItemValues(element.responces, 'gender_id');
            var weightForAge = DependingLogic.AutoColorCreateByHeightWight(
                tabHeightforageBoys,
                tHeightforageGirls,
                tabWeightforageBoys,
                tabWeightforageGirls,
                tabWeightToHeightBoys,
                tabWeightToHeightGirls,
                'weight_for_age',
                gender,
                item);
            var heightForAge = DependingLogic.AutoColorCreateByHeightWight(
                tabHeightforageBoys,
                tHeightforageGirls,
                tabWeightforageBoys,
                tabWeightforageGirls,
                tabWeightToHeightBoys,
                tabWeightToHeightGirls,
                'height_for_age',
                gender,
                item);

            var weightForHeight = DependingLogic.AutoColorCreateByHeightWight(
                tabHeightforageBoys,
                tHeightforageGirls,
                tabWeightforageBoys,
                tabWeightforageGirls,
                tabWeightToHeightBoys,
                tabWeightToHeightGirls,
                'weight_for_height',
                gender,
                item);

            item['weight_for_age'] = weightForAge;
            item['height_for_age'] = heightForAge;
            item['weight_for_height'] = weightForHeight;
          }
          childValues.add(item);
        }
      });
      myMap['anthropromatic_details'] = childValues;
      var measurementDate = myMap['measurement_date'];
      var responcesJs = jsonEncode(myMap);
      var name = myMap['name'];
      // print("itemsDetails $responcesJs");
      await ChildGrowthResponseHelper().insertUpdate(
          widget.cgmguid,
          measurementDate,
          name as int?,
          widget.creche_nameId,
          responcesJs,
          userName,
          myMap['created_on']);
    }
  }

  bool _checkValidation() {
    // List<int> parts = myMap[measurement_date!.fieldname]
    //     .toString()
    //     .split('-')
    //     .map(int.parse)
    //     .toList();
    // var month = parts[1];
    // List<int> measureMonths = [1, 4, 7, 10];
    var validStatus = true;
    if (formItem.length > 0) {
      if (myMap['measurement_date'] != null) {
        for (int i = 0; i < enrolledChild.length; i++) {
          var item = attepmtChild[enrolledChild[i].ChildEnrollGUID];
          for (int i = 0; i < formItem.length; i++) {
            if (item != null) {
              var element = formItem[i];
              var validationMsg = logic!.validationMessge(item, element);
              if (isMesurement(myMap[measurement_date!.fieldname]) == false &&
                  (element.fieldname == 'height' ||
                      element.fieldname == 'measurement_equipment') &&
                  Global.validString(validationMsg)) {
                validationMsg = '';
              }
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
                      if (isMesurement(myMap[measurement_date!.fieldname])) {
                        validStatus = false;
                        Validate().singleButtonPopup(
                            Global.returnTrLable(translatsLabel,
                                CustomText.plsSelectHeight, lng),
                            Global.returnTrLable(
                                translatsLabel, CustomText.ok, lng),
                            false,
                            context);
                        return validStatus;
                      }
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
              translatsLabel, CustomText.select_here, lng!),
          titleText:
              Global.returnTrLable(translatsLabel, quesItem.label!.trim(), lng),
          isRequred: quesItem.fieldname == 'measurement_equipment'
              ? isMesurement(myMap[measurement_date!.fieldname])
                  ? logic!.dependeOnMendotory(itemsAnswred, quesItem)
                  : 0
              : logic!.dependeOnMendotory(itemsAnswred, quesItem),
          items: items,
          readable: role == CustomText.crecheSupervisor
              ? logic!.callReadableLogic(itemsAnswred, quesItem)
              : true,
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
          isRequred: quesItem.fieldname == 'height'
              ? (isMesurement(myMap[measurement_date!.fieldname])
                  ? logic!.dependeOnMendotory(itemsAnswred, quesItem)
                  : 0)
              : logic!.dependeOnMendotory(itemsAnswred, quesItem),
          maxlength: quesItem.length,
          initialvalue: itemsAnswred[quesItem.fieldname!],
          readable: role == CustomText.crecheSupervisor
              ? logic!.callReadableLogic(itemsAnswred, quesItem)
              : true,
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

  bool isMesurement(String mesureDate) {
    bool ismesure = false;
    List<int> parts = mesureDate.toString().split('-').map(int.parse).toList();
    var month = parts[1];
    if (mesureMonths.contains(month)) {
      ismesure = true;
    }
    return ismesure;
  }

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
              translatsLabel, CustomText.select_here, lng!),
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
            if (!(Global.stringToDouble(element['height'].toString()) > 0) &&
                !(Global.stringToDouble(element['weight'].toString()) > 0)) {
              itmelement.remove('height');
              itmelement.remove('weight');
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

        if (responseData['created_on'] != null ||
            responseData['created_by'] != null) {
          myMap['updated_on'] = Validate().currentDateTime();
          myMap['updated_by'] = userName;
        } else {
          myMap['created_by'] = userName;
          myMap['created_on'] = Validate().currentDateTime();
          countMesuredChildren();
        }
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
}
