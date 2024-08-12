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

class ChildImmunizationDetails extends StatefulWidget {
  final int enName;
  final String? child_immunization_guid;
  final String? chilenrolledGUID;
  final String? creche_id;
  final String? childName;
  final String? childHHID;
  final EnrolledChildrenResponceModel? enrolledItem;

  ChildImmunizationDetails(
      {super.key,
      required this.creche_id,
      required this.child_immunization_guid,
      required this.chilenrolledGUID,
      required this.enName,
      required this.enrolledItem,
      required this.childName,
      required this.childHHID});

  @override
  _ChildImmunizationExpendedScreenSatet createState() =>
      _ChildImmunizationExpendedScreenSatet();
}

class _ChildImmunizationExpendedScreenSatet
    extends State<ChildImmunizationDetails> {
  Map<int, dynamic> vaccinesDate = {};
  bool _isLoading = true;
  String? lng = 'en';
  List<Translation> labelControlls = [];
  List<VaccineModel> vaccinesOverdue = [];
  List<VaccineModel> vaccinesUpComming = [];
  List<VaccineModel> vaccinesCompleted = [];
  int childAgeInDays = 0;

  Future<void> initializeData() async {
    lng = (await Validate().readString(Validate.sLanguage))!;
    var dateTime = Global.stringToDate(
        Global.getItemValues(widget.enrolledItem!.responces!, 'child_dob'));
    childAgeInDays = Validate().calculateAgeInDays(dateTime!);
    print("childAgeInDays $childAgeInDays");

    labelControlls.clear();
    List<String> valueNames = [
      CustomText.Save,
      CustomText.Creches,
      CustomText.CrecheCaregiver,
      CustomText.Next,
      CustomText.back,
      CustomText.Submit
    ];
    await TranslationDataHelper()
        .callTranslateString(valueNames)
        .then((value) => labelControlls = value);

    await TranslationDataHelper()
        .callTranslateEnrolledChildren()
        .then((value) => labelControlls.addAll(value));

    await callVaccinelistItem();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: InkWell(
      //   onTap: () async {
      //     // var refStatus = await Navigator.of(context).push(
      //     //   MaterialPageRoute(
      //     //     builder: (BuildContext context) => HHTabScreen(hhGuid: hhGuid),
      //     //   ),
      //     // );
      //     // if (refStatus == 'itemRefresh') {
      //     //   await fetchHhDataList();
      //     // }
      //   },
      //   child: Image.asset(
      //     "assets/add_btn.png",
      //     scale: 2.7,
      //     color: Color(0xff5979AA),
      //   ),
      // ),
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
                    Text(
                      '${widget.childName} ${widget.childHHID}',
                      style: Styles.white145,
                    ),
                    // Text(
                    //   '${widget.childHHID}',
                    //   style: Styles.white126P,
                    // ),
                    // Add additional TextSpans here if needed
                  ],
                ),
              )
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: ListView(
                children: [
                  if (vaccinesOverdue.isNotEmpty) ...[
                    vaccinesOverdue.length > 0
                        ? Text(
                            Global.returnTrLable(
                                labelControlls, CustomText.overdue, lng!),
                            style: Styles.black123)
                        : SizedBox(),
                    vaccinesOverdue.length > 0
                        ? SizedBox(
                            height: 10,
                          )
                        : SizedBox(),
                    vaccinesOverdue.length > 0
                        ? GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // Number of columns
                              crossAxisSpacing: 10.0, // Spacing between columns
                              mainAxisSpacing: 10.0, // Spacing between rows
                              childAspectRatio:
                                  2.0, // Aspect ratio of the grid items
                            ),
                            itemCount: vaccinesOverdue.length,
                            itemBuilder: (context, index) {
                              return GridTile(
                                child: GestureDetector(
                                    onTap: () async {
                                     await createVaccine(vaccinesOverdue[index].name!,vaccinesOverdue[index].vaccine!,
                                          vaccinesOverdue[index].site_for_vaccinations!);
                                    },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0xff5A5A5A).withOpacity(
                                              0.2), // Shadow color with opacity
                                          offset: Offset(0,
                                              3), // Horizontal and vertical offset
                                          blurRadius: 6, // Blur radius
                                          spreadRadius: 0, // Spread radius
                                        ),
                                      ],
                                      color: Color(0xffffdedd),
                                      border:
                                          Border.all(color: Color(0xfffccbca)),
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${vaccinesOverdue[index].vaccine}',
                                          style: Styles.black123,
                                        ),
                                        Text(
                                          '${vaccinesOverdue[index].site_for_vaccinations}',
                                          style: Styles.black123,
                                        ),
                                        // Text(
                                        //   '${CustomText.childAgeInDays} : ${vaccinesOverdue[index].days}',
                                        //   style: Styles.black123,
                                        // ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        : SizedBox(),
                  ],
                  SizedBox(
                    height: 10,
                  ),
                  if (vaccinesCompleted.isNotEmpty) ...[
                    vaccinesCompleted.length > 0
                        ? Text(
                            Global.returnTrLable(
                                labelControlls, CustomText.complted, lng!),
                            style: Styles.black123)
                        : SizedBox(),
                    vaccinesCompleted.length > 0
                        ? SizedBox(
                            height: 10,
                          )
                        : SizedBox(),
                    vaccinesCompleted.length > 0
                        ? GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // Number of columns
                              crossAxisSpacing: 10.0, // Spacing between columns
                              mainAxisSpacing: 10.0, // Spacing between rows
                              childAspectRatio:
                                  2.0, // Aspect ratio of the grid items
                            ),
                            itemCount: vaccinesCompleted.length,
                            itemBuilder: (context, index) {
                              return GridTile(
                                child: Container(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0xff5A5A5A).withOpacity(
                                            0.2), // Shadow color with opacity
                                        offset: Offset(0,
                                            3), // Horizontal and vertical offset
                                        blurRadius: 6, // Blur radius
                                        spreadRadius: 0, // Spread radius
                                      ),
                                    ],
                                    color: Color(0xff8BF649),
                                    border:
                                        Border.all(color: Color(0xff3b9802)),
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${vaccinesCompleted[index].vaccine}',
                                        style: Styles.black123,
                                      ),
                                      Text(
                                        '${vaccinesCompleted[index].site_for_vaccinations}',
                                        style: Styles.black123,
                                      ),
                                      Text(
                                        '${CustomText.Date}${Validate().displeDateFormate(vaccinesDate[vaccinesCompleted[index].name])}',
                                        style: Styles.black123,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        : SizedBox(),
                  ],
                  SizedBox(
                    height: 10,
                  ),
                  if (vaccinesUpComming.isNotEmpty) ...[
                    vaccinesUpComming.length > 0
                        ? Text(
                            Global.returnTrLable(
                                labelControlls, CustomText.upcomming, lng!),
                            style: Styles.black123)
                        : SizedBox(),
                    vaccinesUpComming.length > 0
                        ? SizedBox(
                            height: 10,
                          )
                        : SizedBox(),
                    vaccinesUpComming.length > 0
                        ? GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // Number of columns
                              crossAxisSpacing: 10.0, // Spacing between columns
                              mainAxisSpacing: 10.0, // Spacing between rows
                              childAspectRatio:
                                  2.0, // Aspect ratio of the grid items
                            ),
                            itemCount: vaccinesUpComming.length,
                            itemBuilder: (context, index) {
                              return GridTile(
                                child: GestureDetector(
                                  onTap: () async {
                                    await createVaccine(vaccinesUpComming[index].name!,vaccinesUpComming[index].vaccine!,
                                        vaccinesUpComming[index].site_for_vaccinations!);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0xff5A5A5A).withOpacity(
                                              0.2), // Shadow color with opacity
                                          offset: Offset(0,
                                              3), // Horizontal and vertical offset
                                          blurRadius: 6, // Blur radius
                                          spreadRadius: 0, // Spread radius
                                        ),
                                      ],
                                      color: Color(0xffeae9e9),
                                      border:
                                          Border.all(color: Color(0xffb6b6b6)),
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${vaccinesUpComming[index].vaccine}',
                                          style: Styles.black123,
                                        ),
                                        Text(
                                          '${vaccinesUpComming[index].site_for_vaccinations}',
                                          style: Styles.black123,
                                        ),
                                        // Text(
                                        //   '${CustomText.childAgeInDays} : ${vaccinesUpComming[index].days}',
                                        //   style: Styles.black123,
                                        // ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        : SizedBox(),
                  ]
                ],
              ),
            ),
    );
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    initializeData();
  }

  Future callVaccinelistItem() async {
    vaccinesOverdue.clear();
    vaccinesUpComming.clear();
    vaccinesCompleted.clear();
    vaccinesOverdue =
        await VaccinesDataHelper().callVaccinesByDays(childAgeInDays);
    vaccinesUpComming =
        await VaccinesDataHelper().callVaccinesByDaysUpcommin(childAgeInDays);

    var alrecords = await ChildImmunizationResponseHelper()
        .getChildEventResponcewithGuid(widget.child_immunization_guid!);
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
          vaccinesDate[comVaId] = element['vaccination_date'];
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

    setState(() {
      _isLoading = false;
    });
  }

  Future createVaccine(int vaccineId,String vaccine,String sideForVaccination) async {
    String? vaccineDate=null;
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
                  height: MediaQuery.of(context).size.height * 0.55,
                  child: Column(
                      children: <Widget>[
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
                              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                              DynamicCustomTextFieldNew(
                                titleText:
                                Global.returnTrLable(labelControlls, CustomText.vaccine, lng!),
                                isRequred: 1,
                                initialvalue: vaccine,
                                readable: true,
                                hintText:
                                Global.returnTrLable(labelControlls, CustomText.vaccine, lng!),
                                onChanged: (value) {
                                },
                              ),
                              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                              DynamicCustomTextFieldNew(
                                titleText:
                                Global.returnTrLable(labelControlls, CustomText.sideForVaccination, lng!),
                                isRequred: 1,
                                initialvalue: sideForVaccination,
                                readable: true,
                                hintText:
                                Global.returnTrLable(labelControlls, CustomText.sideForVaccination, lng!),
                                onChanged: (value) {
                                },
                              ),
                              SizedBox(height:  MediaQuery.of(context).size.height * 0.01),
                              CustomDatepickerDynamic(
                              fieldName: 'vaccination_date',
                              isRequred: 1,
                              calenderValidate: [],
                              readable: false,
                              onChanged: (value) {
                                vaccineDate=value;
                              },
                              titleText:
                              Global.returnTrLable(labelControlls, CustomText.vaccinationDate, lng!),
                            ),
                              SizedBox(height:  MediaQuery.of(context).size.height * 0.02),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal:  MediaQuery.of(context).size.width * 0.01,
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
                                    SizedBox(width:  MediaQuery.of(context).size.width * 0.01),
                                    Expanded(
                                      child: CElevatedButton(
                                        text: Global.returnTrLable(
                                            labelControlls, CustomText.Submit, lng!),
                                        color: Color(0xFF42A5F5),
                                        onPressed: () async {
                                          if(Global.validString(vaccineDate)){
                                            Navigator.of(context).pop();
                                            await saveVaccineIte(vaccineId,vaccineDate!);
                                          }else Validate().singleButtonPopup(Global.returnTrLable(labelControlls,
                                              CustomText.selectVacinationDate, lng!), Global.returnTrLable(labelControlls,
                                              CustomText.ok, lng!), false, context);

                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height:  MediaQuery.of(context).size.height * 0.02),
                            ])),
                      ])));
        });
      },
    );
  }


  Future saveVaccineIte(int vaccineId,String vaccineDate) async{

    var  userName = (await Validate().readString(Validate.userName))!;
      var alrecords = await ChildImmunizationResponseHelper()
          .getChildEventResponcewithGuid(widget.child_immunization_guid!);
    Map<String, dynamic> vaccineDetails={};
    if (alrecords.length > 0) {

        Map<String, dynamic> responcesData = jsonDecode(alrecords[0].responces!);
        var childs = responcesData['vaccine_details'];
        List<Map<String, dynamic>> children =[];
        if (childs != null) {
          children = List<Map<String, dynamic>>.from(childs);
          if(children.length>0){
            Map<String, dynamic> childItem={};
            childItem['vaccine_id']='$vaccineId';
            childItem['vaccination_date']=vaccineDate;
            children.add(childItem);
          }else{
            Map<String, dynamic> childItem={};
            childItem['vaccine_id']='$vaccineId';
            childItem['vaccination_date']=vaccineDate;
            children.add(childItem);
          }

        }
        else{
          Map<String, dynamic> childItem={};
          childItem['vaccine_id']='$vaccineId';
          childItem['vaccination_date']=vaccineDate;
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
        vaccineDetails['vaccine_details']=children;
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
          vaccineDetails['child_immunization_guid'] = widget.child_immunization_guid;
          List<Map<String, dynamic>> children =[];
          Map<String, dynamic> childItem={};
          childItem['vaccine_id']='$vaccineId';
          childItem['vaccination_date']=vaccineDate;
          children.add(childItem);
          vaccineDetails['vaccine_details']=children;
        }
      }

    var responcesJs = jsonEncode(vaccineDetails);
    print("responcesJs $responcesJs");
    if(vaccineDetails.isNotEmpty){
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
      await ChildImmunizationResponseHelper().inserts(
          immulizerItem);
    }
    await callVaccinelistItem();

  }


}
