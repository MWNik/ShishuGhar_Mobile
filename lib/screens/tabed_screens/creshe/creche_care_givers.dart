import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/custom_widget/custom_text.dart';
import 'package:shishughar/database/helper/translation_language_helper.dart';
import 'package:shishughar/model/apimodel/house_hold_field_item_model_api.dart';
import 'package:shishughar/model/apimodel/translation_language_api_model.dart';
import 'package:shishughar/style/styles.dart';
import 'package:shishughar/utils/globle_method.dart';
import 'package:shishughar/utils/validate.dart';

import '../../../custom_widget/dynamic_screen_widget/custom_animated_rolling_switch.dart';
import '../../../database/helper/backdated_configiration_helper.dart';
import '../../../database/helper/creche_helper/creche_care_giver_helper.dart';
import '../../../model/apimodel/caregiver_responce_model.dart';
import '../../../model/databasemodel/backdated_configiration_model.dart';
import 'creche_care_giver_tab.dart';

class CrecheCareGivers extends StatefulWidget {
  final int parentName;
  final String crechedCode;

  CrecheCareGivers(
      {super.key, required this.parentName, required this.crechedCode});

  @override
  _CrecheCareGiversState createState() => _CrecheCareGiversState();
}

class _CrecheCareGiversState extends State<CrecheCareGivers> {
  bool _isLoading = true;
  List<CareGiverResponceModel> caregiverData = [];
  List<Translation> translats = [];
  List<Translation> translatsLabel = [];
  List<HouseHoldFielItemdModel> allItems = [];
  String lng = 'en';
  String? role;
  bool isOnlyUnsynched = false;
  List<CareGiverResponceModel> unsynchedList = [];
  List<CareGiverResponceModel> allList = [];
  BackdatedConfigirationModel? backdatedConfigirationModel;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    role = (await Validate().readString(Validate.role))!;
    var lngtr = await Validate().readString(Validate.sLanguage);
    if (lngtr != null) {
      lng = lngtr;
    }
    backdatedConfigirationModel = await BackdatedConfigirationHelper()
        .excuteBackdatedConfigirationModel(CustomText.crecheCaregiver);

    List<String> valueItems = [
      CustomText.Search,
      CustomText.Creches_,
      CustomText.all,
      CustomText.unsynched,
      CustomText.NorecordAvailable
    ];
    await TranslationDataHelper()
        .callTranslateString(valueItems)
        .then((value) => translatsLabel.addAll(value));
    await TranslationDataHelper()
        .callTranslateCreche()
        .then((value) => translats.addAll(value));
    fetchCrecheDataList();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> fetchCrecheDataList() async {
    caregiverData =
        await CrecheCareGiverHelper().getCareGiverResponce(widget.parentName);
    unsynchedList =
        caregiverData.where((element) => element.is_edited == 1).toList();
    allList = caregiverData;
    caregiverData = isOnlyUnsynched ? unsynchedList : allList;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Global.applyDisplayCutout(Color(0xff5979AA));
    if (_isLoading)
      return Center(
        child: CircularProgressIndicator(),
      );
    else {
      return SafeArea(
        child: Scaffold(
          floatingActionButton: role == CustomText.crecheSupervisor.trim()
              ? InkWell(
                  onTap: () async {
                    String hhGuid = '';
                    if (!Global.validString(hhGuid)) {
                      hhGuid = Validate().randomGuid();
                      String? minDate;
                      if(Global.validToInt(backdatedConfigirationModel?.back_dated_data_entry_allowed)>0){
                        minDate=await Validate().requredOnlyMinimum(null, backdatedConfigirationModel!.back_dated_data_entry_allowed!);
                      }

                      print("line $hhGuid");
                      var refStatus = await Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  CreheCareGiverTab(
                                      isEditable: true,
                                      CGGuid: hhGuid,
                                      crechedCode: widget.crechedCode,
                                      parentName: widget.parentName,
                                      minDate: minDate
                                  )));
                      if (refStatus == 'itemRefresh') {
                        await fetchCrecheDataList();
                      }
                    }
                  },
                  child: Image.asset(
                    "assets/add_btn.png",
                    scale: 2.7,
                    color: Color(0xff5979AA),
                  ),
                )
              : SizedBox(),
          body: Padding(
            padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 10.h),
            child: Column(children: [
              role == CustomText.crecheSupervisor
                  ? Align(
                      alignment: Alignment.topRight,
                      child: AnimatedRollingSwitch(
                        title1: Global.returnTrLable(
                            translatsLabel, CustomText.all, lng),
                        title2: Global.returnTrLable(
                            translatsLabel, CustomText.unsynched, lng),
                        isOnlyUnsynched: isOnlyUnsynched ?? false,
                        onChange: (value) async {
                          setState(() {
                            isOnlyUnsynched = value;
                          });
                          await fetchCrecheDataList();
                        },
                      ),
                    )
                  : SizedBox(),
              Expanded(
                child: caregiverData.isEmpty
                    ? Center(
                        child: Text(Global.returnTrLable(
                            translatsLabel, CustomText.NorecordAvailable, lng)))
                    : ListView.builder(
                        itemCount: caregiverData.length,
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () async {
                              // Handle item tap here
                              // print('Item $index tapped');
                              // String? hhGuid = '';
                              // if(Global.validString(caregiverData[index].CGGUID)){
                              //   hhGuid=caregiverData[index].CGGUID!;
                              // }else if (!Global.validString(hhGuid)) {
                              //   hhGuid = Validate().randomGuid();
                              //   print("line $hhGuid");
                              // }
                              // var created_at = DateTime.parse(
                              //     caregiverData[index].created_at.toString());
                              // var date = DateTime(created_at.year,
                              //     created_at.month, created_at.day);
                              // bool isEditab = date.add(Duration(days: 8)).isAfter(
                              //     DateTime.parse(Validate().currentDate()));
                              // var backDate =
                              //     await Validate().readString(Validate.date);
                              //
                              // var applicableDate = Validate()
                              //     .stringToDate(backDate ?? "2024-12-31");
                              // var now = DateTime.parse(Validate().currentDate());

                              bool isEdited=await Validate().checkEditable(caregiverData[index].created_at, Validate().callEditfromCnfig(backdatedConfigirationModel));
                              String? minDate;
                              if(Global.validToInt(backdatedConfigirationModel?.back_dated_data_entry_allowed)>0){
                                minDate=await Validate().requredOnlyMinimum(null, backdatedConfigirationModel!.back_dated_data_entry_allowed!);
                              }
                              bool isUnEditable=false;
                              if(isEdited && role == CustomText.crecheSupervisor){
                                isUnEditable=isEdited;
                              }
                              var refStatus = await Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          CreheCareGiverTab(
                                              isEditable: isUnEditable,
                                              CGGuid:
                                                  caregiverData[index].CGGUID!,
                                              crechedCode: widget.crechedCode,
                                              minDate: minDate,
                                              parentName:
                                                  caregiverData[index].parent!)));
                              if (refStatus == 'itemRefresh') {
                                await fetchCrecheDataList();
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 5.h),
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
                                    color: Colors.white,
                                    border: Border.all(color: Color(0xffE7F0FF)),
                                    borderRadius: BorderRadius.circular(10.r)),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.w, vertical: 8.h),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      // Container(
                                      //   decoration: BoxDecoration(
                                      //     shape: BoxShape.circle,
                                      //     border: Border.all(
                                      //       color: Colors.black, // Color of the stroke
                                      //       width: 2, // Width of the stroke
                                      //     ),
                                      //   ),
                                      //   child: ClipOval(
                                      //     child: Global.validString(
                                      //         Global.getItemValues(
                                      //             caregiverData[index].responces!,
                                      //             'caregiver_img'))
                                      //     //     ? Image.memory(
                                      //     //   base64Decode(Global.getItemValues(
                                      //     //       caregiverData[index].responces!,
                                      //     //       'caregiver_img')),
                                      //     //   width: 50,
                                      //     //   height: 50,
                                      //     //   fit: BoxFit.cover,
                                      //     // )
                                      //         ? Image.file(
                                      //         File(Global.getItemValues( caregiverData[index].responces!,'caregiver_img')),
                                      //       // base64Decode(Global.getItemValues(
                                      //       //     caregiverData[index].responces!,
                                      //       //     'caregiver_img')),
                                      //       width: 50,
                                      //       height: 50,
                                      //       fit: BoxFit.cover,
                                      //     )
                                      //         :
                                      //     Image.asset("assets/person.png",
                                      //         width: 50,
                                      //         height: 50,
                                      //         fit: BoxFit.cover),
                                      //   ),
                                      // ),
                                      // SizedBox(width: 10.w),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${Global.returnTrLable(translats, CustomText.Caregiver_Code, lng).trim()} : ',
                                            style: Styles.black104,
                                          ),
                                          Text(
                                            '${Global.returnTrLable(translats, CustomText.Caregiver_Name, lng).trim()} : ',
                                            style: Styles.black104,
                                            strutStyle: StrutStyle(height: 1.2),
                                          ),
                                          Text(
                                            '${Global.returnTrLable(translats, CustomText.MobileNo, lng).trim()} : ',
                                            style: Styles.black104,
                                            strutStyle: StrutStyle(height: 1.2),
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 10),
                                      SizedBox(
                                        height: 30.h,
                                        width: 2,
                                        child: VerticalDivider(
                                          color: Color(0xffE6E6E6),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              Global.getItemValues(
                                                  caregiverData[index].responces!,
                                                  'caregiver_code'),
                                              style: Styles.cardBlue10,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              Global.getItemValues(
                                                  caregiverData[index].responces!,
                                                  'caregiver_name'),
                                              style: Styles.cardBlue10,
                                              strutStyle: StrutStyle(height: 1.2),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              Global.getItemValues(
                                                  caregiverData[index].responces!,
                                                  'mobile_no'),
                                              style: Styles.cardBlue10,
                                              strutStyle: StrutStyle(height: 1.2),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                      (caregiverData[index].is_edited == 0 &&
                                              caregiverData[index].is_uploaded ==
                                                  1)
                                          ? Image.asset(
                                              "assets/sync.png",
                                              scale: 1.5,
                                            )
                                          : Image.asset(
                                              "assets/sync_gray.png",
                                              scale: 1.5,
                                            )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
              ),
              SizedBox(
                height: 10.h,
              ),
            ]),
          ),
        ),
      );
    }
  }
}
