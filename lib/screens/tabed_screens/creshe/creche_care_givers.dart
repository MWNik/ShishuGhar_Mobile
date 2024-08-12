import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/custom_widget/custom_text.dart';
import 'package:shishughar/database/helper/translation_language_helper.dart';
import 'package:shishughar/model/apimodel/house_hold_field_item_model_api.dart';
import 'package:shishughar/model/apimodel/translation_language_api_model.dart';
import 'package:shishughar/style/styles.dart';
import 'package:shishughar/utils/globle_method.dart';
import 'package:shishughar/utils/validate.dart';

import '../../../database/helper/creche_helper/creche_care_giver_helper.dart';
import '../../../model/apimodel/caregiver_responce_model.dart';
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
  List<CareGiverResponceModel> caregiverData = [];
  List<Translation> translats = [];
  List<Translation> translatsLabel = [];
  List<HouseHoldFielItemdModel> allItems = [];
  String lng = 'en';

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    var lngtr = await Validate().readString(Validate.sLanguage);
    if (lngtr != null) {
      lng = lngtr;
    }
    List<String> valueItems = [CustomText.Search, CustomText.Creches_];
    await TranslationDataHelper()
        .callTranslateString(valueItems)
        .then((value) => translatsLabel = value);
    await TranslationDataHelper()
        .callTranslateCreche()
        .then((value) => translats = value);
    fetchCrecheDataList();
  }

  Future<void> fetchCrecheDataList() async {
    caregiverData =
        await CrecheCareGiverHelper().getCareGiverResponce(widget.parentName);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: InkWell(
        onTap: () async {
          String hhGuid = '';
          if (!Global.validString(hhGuid)) {
            hhGuid = Validate().randomGuid();
            print("line $hhGuid");
            var refStatus = await Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => CreheCareGiverTab(
                    isEditable: true,
                    CGGuid: hhGuid,
                    crechedCode: widget.crechedCode,
                    parentName: widget.parentName)));
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
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(children: [
          SizedBox(
            height: 10.h,
          ),
          Expanded(
            child: ListView.builder(
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
                      var created_at = DateTime.parse(caregiverData[index].created_at.toString());
                      var date = DateTime(created_at.year,created_at.month,created_at.day);
                      bool isEditab = date.add(Duration(days: 8)).isAfter(DateTime.parse(Validate().currentDate()));

                      var refStatus = await Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  CreheCareGiverTab(
                                      isEditable: isEditab,
                                      CGGuid: caregiverData[index].CGGUID!,
                                      crechedCode: widget.crechedCode,
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
                                offset: Offset(
                                    0, 3), // Horizontal and vertical offset
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    '${Global.returnTrLable(translats, CustomText.Caregiver_Code, lng).trim()} : ',
                                    style: Styles.Grey85,
                                  ),
                                  Text(
                                    '${Global.returnTrLable(translats, CustomText.Caregiver_Name, lng).trim()} : ',
                                    style: Styles.Grey85,
                                    strutStyle: StrutStyle(height: 1),
                                  ),
                                  Text(
                                    '${Global.returnTrLable(translats, CustomText.MobileNo, lng).trim()} : ',
                                    style: Styles.Grey85,
                                    strutStyle: StrutStyle(height: 1),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      Global.getItemValues(
                                          caregiverData[index].responces!,
                                          'caregiver_code'),
                                      style: Styles.black105P,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      Global.getItemValues(
                                          caregiverData[index].responces!,
                                          'caregiver_name'),
                                      style: Styles.black105P,
                                      strutStyle: StrutStyle(height: .5),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      Global.getItemValues(
                                          caregiverData[index].responces!,
                                          'mobile_no'),
                                      style: Styles.black105P,
                                      strutStyle: StrutStyle(height: .5),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              (caregiverData[index].is_edited == 0 &&
                                      caregiverData[index].is_uploaded == 1)
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
    );
  }
}
