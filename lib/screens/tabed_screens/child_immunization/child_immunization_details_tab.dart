import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/custom_widget/custom_appbar.dart';
import 'package:shishughar/custom_widget/custom_btn.dart';
import 'package:shishughar/custom_widget/dynamic_screen_widget/dynamic_custom_dropdown.dart';
import 'package:shishughar/custom_widget/dynamic_screen_widget/dynamic_customdatepicker.dart';
import 'package:shishughar/database/helper/dynamic_screen_helper/options_model_helper.dart';
import 'package:shishughar/model/databasemodel/vaccines_model.dart';
import 'package:shishughar/model/dynamic_screen_model/enrolled_child_exit_responce_model.dart';

import '../../../custom_widget/custom_text.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_custom_checkbox.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_custom_textfield_float.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_custom_time_picker.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_custom_yesno_checkbox.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_customtextfield_int.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_customtextfield_new.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamin_multi_check_screen.dart';
import '../../../custom_widget/single_poup_dailog.dart';
import '../../../database/helper/child_immunization/child_immunization_meta_fileds_helper.dart';
import '../../../database/helper/child_immunization/child_immunization_response_helper.dart';
import '../../../database/helper/creche_helper/creche_data_helper.dart';
import '../../../database/helper/form_logic_helper.dart';
import '../../../database/helper/translation_language_helper.dart';
import '../../../database/helper/vaccines_helper.dart';
import '../../../model/apimodel/form_logic_api_model.dart';
import '../../../model/apimodel/house_hold_field_item_model_api.dart';
import '../../../model/apimodel/translation_language_api_model.dart';
import '../../../model/dynamic_screen_model/child_immunization_response_model.dart';
import '../../../model/dynamic_screen_model/enrolled_children_responce_model.dart';
import '../../../model/dynamic_screen_model/options_model.dart';
import '../../../style/styles.dart';
import '../../../utils/globle_method.dart';
import '../../../utils/validate.dart';
import '../house_hold/depending_logic.dart';

class ChildImmunizationDetailsTab extends StatefulWidget {
  final int enName;
  final String? child_immunization_guid;
  final String? chilenrolledGUID;
  final String? creche_id;
  final String? childName;
  final String? childHHID;
  final String dateOfEnrolled;
  final String childDob;
  final EnrolledExitChildResponceModel? enrolledItem;

  ChildImmunizationDetailsTab({
    super.key,
    required this.creche_id,
    required this.child_immunization_guid,
    required this.chilenrolledGUID,
    required this.enName,
    required this.enrolledItem,
    required this.childName,
    required this.dateOfEnrolled,
    required this.childHHID,
    required this.childDob,
  });

  @override
  @override
  _ChildImmunizationExpendedScreenSatet createState() =>
      _ChildImmunizationExpendedScreenSatet();
}

class _ChildImmunizationExpendedScreenSatet
    extends State<ChildImmunizationDetailsTab> {
  Map<int, dynamic> vaccinesDate = {};
  Map<int, dynamic> createAtVaccines = {};
  bool _isLoading = true;
  String? lng = 'en';
  String? role;
  List<Translation> labelControlls = [];
  List<VaccineModel> vaccinesOverdue = [];
  List<VaccineModel> vaccinesUpComming = [];
  List<VaccineModel> vaccinesCompleted = [];
  int childAgeInDays = 0;
  int tabCount = 2;
  DateTime? lastDate;

  Future<void> initializeData() async {
    bool isLoading = true;
    List<int> dateParts = widget.childDob.split('-').map(int.parse).toList();
    lastDate = DateTime(dateParts[0], dateParts[1], dateParts[2])
        .subtract(Duration(days: 1));

    lng = (await Validate().readString(Validate.sLanguage))!;
    role = (await Validate().readString(Validate.role));
    var dateTime = Global.stringToDate(
        Global.getItemValues(widget.enrolledItem!.responces!, 'child_dob'));
    childAgeInDays = Validate().calculateAgeInDays(dateTime!);
    print("childAgeInDays $childAgeInDays");

    labelControlls.clear();
    List<String> valueNames = [
      CustomText.Save,
      CustomText.Cancel,
      CustomText.back,
      CustomText.Submit,
      CustomText.Vaccinated,
      CustomText.No,
      CustomText.ok,
      CustomText.selectVaccinated,
      CustomText.Yes,
      CustomText.ChildImmunization,
      CustomText.overdue,
      CustomText.complted,
      CustomText.upcomming,
      CustomText.vaccine,
      CustomText.SiteForVaccinations,
      // CustomText.vaccine,
      CustomText.sideForVaccination,
      CustomText.vaccinationDate,
      CustomText.ChildImmunizationDetails,
      CustomText.select_here,
      CustomText.typehere,
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
        .then((value) => labelControlls.addAll(value));

    await TranslationDataHelper()
        .callTranslateEnrolledChildren()
        .then((value) => labelControlls.addAll(value));

    await callVaccinelistItem();
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabCount,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 60,
          backgroundColor: Color(0xff5979AA),
          leading: Padding(
            padding: EdgeInsets.only(left: 10),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context, 'itemRefresh');
              },
              child: Icon(
                Icons.arrow_back_ios_sharp,
                size: 20,
                color: Colors.white,
              ),
            ),
          ),
          title: RichText(
            text: TextSpan(
              children: [
                WidgetSpan(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RichText(
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        text: TextSpan(children: [
                          WidgetSpan(
                            child: Text(
                              '${widget.childName} ',
                              style: Styles.white145,
                              textAlign: TextAlign.center,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          WidgetSpan(
                            child: Text(
                              '-${widget.childHHID}',
                              style: Styles.white145,
                              textAlign: TextAlign.center,
                              softWrap: true,
                              // overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ]),
                      ),

                      Text(
                        Global.returnTrLable(labelControlls,
                            CustomText.ChildImmunizationDetails, lng!),
                        style: Styles.white126P,
                      ),
                      // Add additional TextSpans here if needed
                    ],
                  ),
                )
              ],
            ),
          ),
          centerTitle: true,
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            labelPadding: EdgeInsets.zero,

            // indicatorWeight: 4.5,
            indicatorColor: Colors.white,
            indicator: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.yellow.shade600, // Divider color
                  width: 4.5,
                  // Divider thickness
                ),
              ),
            ),

            unselectedLabelColor: Colors.transparent,
            tabs: (tabCount == 2)
                ? [
                    Container(
                      color: getBorderColorByType('overdue'),
                      width: double.infinity,
                      child: Tab(
                          child: Text(
                              Global.returnTrLable(
                                  labelControlls, CustomText.overdue, lng!),
                              style: TextStyle(color: Colors.white))),
                    ),
                    Container(
                      width: double.infinity,
                      color: getBorderColorByType('completed'),
                      child: Tab(
                          child: Text(
                              Global.returnTrLable(
                                  labelControlls, CustomText.complted, lng!),
                              style: TextStyle(color: Colors.white))),
                    ),
                  ]
                : [
                    Container(
                      color: getBorderColorByType('overdue'),
                      width: double.infinity,
                      child: Tab(
                          child: Text(
                              Global.returnTrLable(
                                  labelControlls, CustomText.overdue, lng!),
                              style: TextStyle(color: Colors.white))),
                    ),
                    Container(
                      width: double.infinity,
                      color: getBorderColorByType('completed'),
                      child: Tab(
                          child: Text(
                              Global.returnTrLable(
                                  labelControlls, CustomText.complted, lng!),
                              style: TextStyle(color: Colors.white))),
                    ),
                    Container(
                      width: double.infinity,
                      color: getBorderColorByType('upcoming'),
                      child: Tab(
                          child: Text(
                              Global.returnTrLable(
                                  labelControlls, CustomText.upcomming, lng!),
                              style: TextStyle(color: Colors.white))),
                    ),
                  ],
          ),
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: TabBarView(
                  children: (tabCount == 2)
                      ? [
                          buildVaccineList(vaccinesOverdue, 'overdue'),
                          buildVaccineList(vaccinesCompleted, 'completed'),
                        ]
                      : [
                          buildVaccineList(vaccinesOverdue, 'overdue'),
                          buildVaccineList(vaccinesCompleted, 'completed'),
                          buildVaccineList(vaccinesUpComming, 'upcoming'),
                        ],
                ),
              ),
      ),
    );
  }

  Future callVaccinelistItem() async {
    vaccinesOverdue.clear();
    vaccinesUpComming.clear();
    vaccinesCompleted.clear();
    vaccinesDate = {};
    createAtVaccines = {};
    vaccinesOverdue =
        await VaccinesDataHelper().callVaccinesByDays(childAgeInDays);
    vaccinesUpComming =
        await VaccinesDataHelper().callVaccinesByDaysUpcommin(childAgeInDays);

    var alrecords = await ChildImmunizationResponseHelper()
        .getChildEventResponcewithGuid(widget.child_immunization_guid!);
    List<String> siteOfvaccineList = [];
    vaccinesOverdue.forEach((element) {
      if (Global.validString(element.site_for_vaccinations))
        siteOfvaccineList.add(element.site_for_vaccinations!.trim());
    });
    await TranslationDataHelper()
        .callTranslateString(siteOfvaccineList)
        .then((value) => labelControlls.addAll(value));

    if (alrecords.length > 0) {
      Map<String, dynamic> responcesData = jsonDecode(alrecords[0].responces!);
      var childs = responcesData['vaccine_details'];
      if (childs != null) {
        List<Map<String, dynamic>> children =
            List<Map<String, dynamic>>.from(childs);
        List<int> completedVaccine = [];
        children.forEach((element) {
          var comVaId = Global.stringToInt(element['vaccine_id'].toString());
          completedVaccine.add(comVaId);
          if (element['vaccination_date'] != null)
            vaccinesDate[comVaId] = element['vaccination_date'];
          if (element['vaccine_created_at'] != null) {
            createAtVaccines[comVaId] = element['vaccine_created_at'];
          }
        });

        completedVaccine.forEach((coVa) {
          var inOverDueVac =
              vaccinesOverdue.where((element) => element.name == coVa).toList();
          if (inOverDueVac.length > 0) {
            vaccinesCompleted.addAll(inOverDueVac);
            vaccinesOverdue.removeWhere((element) => element.name == coVa);
          }
          var inUpComVa = vaccinesUpComming
              .where((element) => element.name == coVa)
              .toList();
          if (inUpComVa.length > 0) {
            vaccinesCompleted.addAll(inUpComVa);
            vaccinesUpComming.removeWhere((element) => element.name == coVa);
          }
        });
      }
    }
    if (vaccinesUpComming.length > 0) {
      tabCount = 3;
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future createVaccine(int vaccineId, String vaccine, String sideForVaccination,
      int type) async {
    String? vaccineDate;
    int? vaccinated;
    if (type == 1) {
      vaccineDate = vaccinesDate[vaccineId];
      if (vaccineDate != null) {
        vaccinated = 1;
      } else
        vaccinated = 0;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              contentPadding: EdgeInsets.zero,
              content: Container(
                  width: MediaQuery.of(context).size.width * 5.00,
                  height: MediaQuery.of(context).size.height * 0.65,
                  child: Column(children: <Widget>[
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
                          child: Text(CustomText.SHISHUGHAR,
                              style: Styles.white126P)),
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                        ),
                        child: Column(children: [
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.02),
                          DynamicCustomTextFieldNew(
                            titleText: Global.returnTrLable(
                                labelControlls, CustomText.vaccine, lng!),
                            isRequred: 1,
                            initialvalue: vaccine,
                            readable: true,
                            hintText: Global.returnTrLable(
                                labelControlls, CustomText.vaccine, lng!),
                            onChanged: (value) {},
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.01),
                          DynamicCustomTextFieldNew(
                            titleText: Global.returnTrLable(labelControlls,
                                CustomText.sideForVaccination, lng!),
                            isRequred: 1,
                            initialvalue: sideForVaccination,
                            readable: true,
                            hintText: Global.returnTrLable(labelControlls,
                                CustomText.sideForVaccination, lng!),
                            onChanged: (value) {},
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.01),
                          DynamicCustomYesNoCheckboxWithLabel(
                            label: Global.returnTrLable(
                                labelControlls, CustomText.Vaccinated, lng!),
                            initialValue: vaccinated,
                            labelControlls: labelControlls,
                            lng: lng!,
                            isRequred: 1,
                            onChanged: (value) {
                              vaccinated = value;
                              if (vaccinated == 1) {
                                if (type == 1) {
                                  vaccineDate = vaccinesDate[vaccineId];
                                } else
                                  vaccineDate = Validate().currentDate();
                              }
                              setState(() {});
                            },
                          ),
                          vaccinated == 1
                              ? SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.01)
                              : SizedBox(),
                          vaccinated == 1
                              ? CustomDatepickerDynamic(
                                  isRequred: 1,
                                  calenderValidate: [],
                                  initialvalue: vaccineDate,
                                  minDate: lastDate,
                                  readable: false,
                                  onChanged: (value) {
                                    vaccineDate = value;
                                  },
                                  titleText: Global.returnTrLable(
                                      labelControlls,
                                      CustomText.vaccinationDate,
                                      lng!),
                                )
                              : SizedBox(),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.02),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.01,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: CElevatedButton(
                                    text: Global.returnTrLable(
                                        labelControlls, 'Cancel', lng!),
                                    color: Color(0xffDB4B73),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.01),
                                Expanded(
                                  child: CElevatedButton(
                                    text: Global.returnTrLable(labelControlls,
                                        CustomText.Submit, lng!),
                                    color: Color(0xff369A8D),
                                    onPressed: () async {
                                      if (vaccinated != null) {
                                        if (vaccinated == 1 &&
                                            Global.validString(vaccineDate)) {
                                          Navigator.of(context).pop();
                                          await saveVaccineIte(vaccineId,
                                              vaccineDate!, vaccinated!);
                                        } else if (vaccinated == 0) {
                                          Navigator.of(context).pop();
                                          await saveVaccineIte(
                                              vaccineId, null, vaccinated!);
                                        } else
                                          Validate().singleButtonPopup(
                                              Global.returnTrLable(
                                                  labelControlls,
                                                  CustomText
                                                      .selectVacinationDate,
                                                  lng!),
                                              Global.returnTrLable(
                                                  labelControlls,
                                                  CustomText.ok,
                                                  lng!),
                                              false,
                                              context);
                                      } else
                                        Validate().singleButtonPopup(
                                            Global.returnTrLable(
                                                labelControlls,
                                                CustomText.selectVaccinated,
                                                lng!),
                                            Global.returnTrLable(labelControlls,
                                                CustomText.ok, lng!),
                                            false,
                                            context);
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.02),
                        ])),
                  ])));
        });
      },
    );
  }

  Future saveVaccineIte(
      int vaccineId, String? vaccineDate, int vaccinated) async {
    var userName = (await Validate().readString(Validate.userName))!;
    var alrecords = await ChildImmunizationResponseHelper()
        .getChildEventResponcewithGuid(widget.child_immunization_guid!);
    Map<String, dynamic> vaccineDetails = {};
    if (alrecords.length > 0) {
      Map<String, dynamic> responcesData = jsonDecode(alrecords[0].responces!);
      var childs = responcesData['vaccine_details'];
      List<Map<String, dynamic>> children = [];
      if (childs != null) {
        children = List<Map<String, dynamic>>.from(childs);
        if (children.length > 0) {
          var exitsItem = children
              .where((element) =>
                  element['vaccine_id'].toString() == vaccineId.toString())
              .toList();
          if (exitsItem.length > 0) {
            if (vaccinated == 1) {
              exitsItem[0]['vaccination_date'] = vaccineDate;
            } else
              exitsItem[0].remove('vaccination_date');
            exitsItem[0]['vaccinated'] = vaccinated;
          } else {
            Map<String, dynamic> childItem = {};
            childItem['vaccine_id'] = '$vaccineId';
            if (vaccinated == 1) {
              childItem['vaccination_date'] = vaccineDate;
            }
            childItem['vaccinated'] = vaccinated;
            childItem['vaccine_created_at'] = Validate().currentDateTime();
            children.add(childItem);
          }
        } else {
          Map<String, dynamic> childItem = {};
          childItem['vaccine_id'] = '$vaccineId';
          if (vaccinated == 1) {
            childItem['vaccination_date'] = vaccineDate;
          }
          childItem['vaccine_created_at'] = Validate().currentDateTime();
          childItem['vaccinated'] = vaccinated;
          children.add(childItem);
        }
      } else {
        Map<String, dynamic> childItem = {};
        childItem['vaccine_id'] = '$vaccineId';
        if (vaccinated == 1) {
          childItem['vaccination_date'] = vaccineDate;
        }
        childItem['vaccinated'] = vaccinated;
        childItem['vaccine_created_at'] = Validate().currentDateTime();
        children.add(childItem);
      }
      responcesData.forEach((key, value) {
        vaccineDetails[key] = value;
      });

      if (responcesData['appcreated_on'] != null ||
          responcesData['app_created_by'] != null) {
        vaccineDetails['app_updated_on'] = Validate().currentDateTime();
        vaccineDetails['app_updated_by'] = userName;
      } else {
        vaccineDetails['appcreated_by'] = userName;
        vaccineDetails['appcreated_on'] = Validate().currentDateTime();
      }
      vaccineDetails['vaccine_details'] = children;
      var name = alrecords[0].name;
      if (name != null) {
        vaccineDetails['name'] = name;
      }
    } else {
      var creCheDetails = await CrecheDataHelper()
          .getCrecheResponceItem(Global.stringToInt(widget.creche_id));
      if (creCheDetails.length > 0) {
        vaccineDetails['childenrolledguid'] = widget.chilenrolledGUID;
        vaccineDetails['appcreated_by'] = userName;
        vaccineDetails['appcreated_on'] = Validate().currentDateTime();
        vaccineDetails['child_id'] = widget.enName;
        vaccineDetails['creche_id'] = widget.creche_id.toString();
        vaccineDetails['partner_id'] =
            Global.getItemValues(creCheDetails[0].responces!, 'partner_id');
        vaccineDetails['state_id'] =
            Global.getItemValues(creCheDetails[0].responces!, 'state_id');
        vaccineDetails['district_id'] =
            Global.getItemValues(creCheDetails[0].responces!, 'district_id');
        vaccineDetails['block_id'] =
            Global.getItemValues(creCheDetails[0].responces!, 'block_id');
        vaccineDetails['gp_id'] =
            Global.getItemValues(creCheDetails[0].responces!, 'gp_id');
        vaccineDetails['village_id'] =
            Global.getItemValues(creCheDetails[0].responces!, 'village_id');
        vaccineDetails['child_immunization_guid'] =
            widget.child_immunization_guid;
        List<Map<String, dynamic>> children = [];
        Map<String, dynamic> childItem = {};
        childItem['vaccine_id'] = '$vaccineId';
        if (vaccinated == 1) {
          childItem['vaccination_date'] = vaccineDate;
        }
        childItem['vaccinated'] = vaccinated;
        childItem['vaccine_created_at'] = Validate().currentDateTime();
        children.add(childItem);
        vaccineDetails['vaccine_details'] = children;
      }
    }

    var responcesJs = jsonEncode(vaccineDetails);
    print("responcesJs $responcesJs");
    if (vaccineDetails.isNotEmpty) {
      var immulizerItem = ChildImmunizationResponceModel(
          child_immunization_guid: widget.child_immunization_guid,
          childenrolledguid: widget.chilenrolledGUID,
          name: vaccineDetails['name'],
          creche_id: Global.stringToInt(widget.creche_id),
          responces: responcesJs,
          is_uploaded: 0,
          is_edited: 1,
          is_deleted: 0,
          created_at: vaccineDetails['appcreated_on'],
          created_by: vaccineDetails['appcreated_by'],
          update_at: vaccineDetails['app_updated_on'],
          updated_by: vaccineDetails['app_updated_by']);
      await ChildImmunizationResponseHelper().inserts(immulizerItem);

      bool shouldProceed = await showDialog(
        context: context,
        builder: (context) {
          return SingleButtonPopupDialog(
              message: Global.returnTrLable(
                  labelControlls, CustomText.dataSaveSuc, lng!),
              button:
                  Global.returnTrLable(labelControlls, CustomText.ok, lng!));
        },
      );
      if (shouldProceed) {
        await initializeData();
      }
    }
  }

  Color getBorderColorByType(String type) {
    switch (type) {
      case 'overdue':
        return Color(0xfffd8989);
      case 'completed':
        return Color(0xff84d775);
      case 'upcoming':
        return Color(0xff69bec0);
      default:
        return Colors.black;
    }
  }

  Color getColorByType(String type) {
    switch (type) {
      case 'overdue':
        return Color(0xfffd8989);
      case 'completed':
        return Color(0xff84d775);
      case 'upcoming':
        return Color(0xff69bec0);
      default:
        return Colors.black;
    }
  }

  Widget buildVaccineList(List<VaccineModel> vaccines, String type) {
    return ListView(
      children: [
        if (vaccines.isNotEmpty) ...[
          // Text(
          //   Global.returnTrLable(labelControlls, CustomText.overdue, lng!),
          //   style: Styles.black123,
          // ),
          SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of columns
              crossAxisSpacing: 10.0, // Spacing between columns
              mainAxisSpacing: 10.0, // Spacing between rows
              childAspectRatio: 2.0, // Aspect ratio of the grid items
            ),
            itemCount: vaccines.length,
            itemBuilder: (context, index) {
              return GridTile(
                child: GestureDetector(
                  onTap: () async {
                    if (role == CustomText.crecheSupervisor) {
                      if (type == 'overdue') {
                        await createVaccine(
                          vaccines[index].name!,
                          vaccines[index].vaccine!,
                          vaccines[index].site_for_vaccinations!,
                          0,
                        );
                      } else if (type == 'completed') {
                        print(type);
                        if (Global.validString(
                            createAtVaccines[vaccines[index].name!])) {
                          var editDate = DateTime.parse(
                                  createAtVaccines[vaccines[index].name!])
                              .add(Duration(days: 16));
                          var currentDate =
                              DateTime.parse(Validate().currentDateTime());
                          var date = await Validate().readString(Validate.date);
                          var applicableDate =
                              Validate().stringToDate(date ?? "2024-12-31");
                          print(date);
                          if (currentDate.isBefore(applicableDate)
                              ? true
                              : editDate.isAfter(currentDate)) {
                            await createVaccine(
                                vaccines[index].name!,
                                vaccines[index].vaccine!,
                                vaccines[index].site_for_vaccinations!,
                                1);
                          }
                        }
                      }
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xff5A5A5A).withOpacity(0.2),
                          offset: Offset(0, 3),
                          blurRadius: 6,
                          spreadRadius: 0,
                        ),
                      ],
                      color: getColorByType(type),
                      border: Border.all(color: getBorderColorByType(type)),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('${vaccines[index].vaccine}',
                            style: Styles.black123),
                        Text(
                            '${Global.returnTrLable(labelControlls, vaccines[index].site_for_vaccinations, lng!)}',
                            style: Styles.black123),
                        if (type == 'completed')
                          Text(
                              vaccinesDate[vaccines[index].name] != null
                                  ? '${CustomText.DateS} : ${Validate().displeDateFormate(vaccinesDate[vaccines[index].name])}'
                                  : '${CustomText.Vaccinated} : ${CustomText.No}',
                              style: Styles.black123),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    initializeData();
  }
}
