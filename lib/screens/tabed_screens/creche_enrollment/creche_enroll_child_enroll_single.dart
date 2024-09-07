import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/database/helper/dynamic_screen_helper/options_model_helper.dart';
import 'package:shishughar/model/apimodel/creche_database_responce_model.dart';
import 'package:shishughar/screens/tabed_screens/child_exit/child_exit_details_screen.dart';
import 'package:shishughar/screens/tabed_screens/child_exit/exit_enrolld_child/exit_enrolled_child_tab.dart';

import '../../../custom_widget/custom_appbar.dart';
import '../../../custom_widget/custom_text.dart';
import '../../../database/helper/child_exit/child_exit_response_Helper.dart';
import '../../../database/helper/creche_helper/creche_data_helper.dart';
import '../../../database/helper/enrolled_children/enrolled_children_responce_helper.dart';
import '../../../database/helper/translation_language_helper.dart';
import '../../../model/apimodel/translation_language_api_model.dart';
import '../../../model/databasemodel/child_exit_response_model.dart';
import '../../../model/dynamic_screen_model/enrolled_children_responce_model.dart';
import '../../../model/dynamic_screen_model/options_model.dart';
import '../../../style/styles.dart';
import '../../../utils/globle_method.dart';
import '../../../utils/validate.dart';
import '../child_exit/exited_child_detail_view_screen.dart';
import 'enrolled_children_tab_item_details_only_view.dart';

class CrecheEnrollChildEnrollSingleScreen extends StatefulWidget {
  final String? creche_id;
  final String? chilenrolledGUID;

  CrecheEnrollChildEnrollSingleScreen({
    super.key,
    required this.chilenrolledGUID,
    required this.creche_id,
  });

  @override
  State<CrecheEnrollChildEnrollSingleScreen> createState() =>
      _CrecheEnrollChildEnrollScreenState();
}

class _CrecheEnrollChildEnrollScreenState
    extends State<CrecheEnrollChildEnrollSingleScreen> {
  List<Map<String, dynamic>> crecheEnrollChild = [];
  String? crecheName;

  List<Translation> translats = [];
  String lng = 'en';
  List<OptionsModel> reasonOfExit = [];
  bool currentDate = false;
  DateTime? lastDate;
  DateTime? maxDate;

  List<dynamic>? childenrollId;

  Future<void> initializeData() async {

    translats.clear();
    var lngtr = await Validate().readString(Validate.sLanguage);
    if (lngtr != null) {
      lng = lngtr;
    }

    List<String> valueItems = [
      CustomText.Enrolled,
      CustomText.ChildName,
      CustomText.RelationshipChild,
      CustomText.ageInMonth,
      CustomText.hhNameS,
      CustomText.NorecordAvailable,
      CustomText.Search,
      CustomText.Village,
      CustomText.creche_enrollement
    ];
    await TranslationDataHelper()
        .callTranslateString(valueItems)
        .then((value) => translats.addAll(value));
    reasonOfExit =
        await OptionsModelHelper().getMstCommonOptions('Reason for child exit',lng);
    await fetchChildexits();
    print(crecheEnrollChild.length);
  }

  Future<void> fetchChildexits() async {
    crecheEnrollChild.clear();
   await CrecheDataHelper()
        .callCrechEnrolledByChildGUID(widget.chilenrolledGUID!).then((data) {
      crecheEnrollChild.addAll(data);
    });
   
   await ChildExitResponceHelper()
        .exitedChildHistoryByEnrollChildGUID(widget.chilenrolledGUID)
       .then((data) {
     crecheEnrollChild.addAll(data);
   });

    print("successs");
    setState(() {});
  }


  @override
  void initState() {
    super.initState();
    initializeData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        text: Global.returnTrLable(translats, CustomText.creche_enrollement, lng),
        onTap: () => Navigator.pop(context, 'itemRefresh'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(children: [
          Expanded(
            child: (crecheEnrollChild.length > 0)
                ? ListView.builder(
                    itemCount: crecheEnrollChild.length,
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () async {
                            var refStatus = await Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                    crecheEnrollChild[index]['date_of_exit']!=null?
                                    // ExitedChildDetailView(
                                    //       childExitGuid: Global.getItemValues(
                                    //           crecheEnrollChild[index]['exitResponces'],
                                    //           'child_exit_guid'),
                                    //       chilenrolledGUID: crecheEnrollChild[index]['ChildEnrollGUID'],
                                    //       creche_id: widget.creche_id,
                                    //   childId: Global.getItemValues(
                                    //           crecheEnrollChild[index]['responces'],
                                    //           'child_id'),
                                    //   childName: Global.getItemValues(
                                    //           crecheEnrollChild[index]['responces'],
                                    //           'child_name'),
                                    //     ):
  //                                   
                                    ExitEnrolledChilrenTab(
                                      CHHGUID: crecheEnrollChild[index]['CHHGUID'],
                                      HHGUID: Global.getItemValues(crecheEnrollChild[index]['responces'], 'hhguid'),
                                      EnrolledChilGUID: crecheEnrollChild[index]['ChildEnrollGUID'],
                                      HHname: crecheEnrollChild[index]['HHname'],
                                      ChildName: Global.getItemValues(crecheEnrollChild[index]['responces'], 'child_name'),
                                      crecheId: crecheEnrollChild[index]['creche_id'],
                                      isNew: 0,
                                      isImageUpdate: false,
                                      isEditable: false,
                                    ):
                                    EnrolledChilrenTabItemView(
                                      cHHGuid: crecheEnrollChild[index]['CHHGUID'],
                                      HHname: Global.stringToInt(crecheEnrollChild[index]['HHname'].toString()),
                                      EnrolledChilGUID: crecheEnrollChild[index]['ChildEnrollGUID'],
                                      crecheId: Global.stringToInt(widget.creche_id),
                                    )));
                            if (refStatus == 'itemRefresh') {
                              await fetchChildexits();
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
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${Global.returnTrLable(translats, 'Creche Name', lng).trim()} : ',
                                        style: Styles.black104,
                                        strutStyle: StrutStyle(height: 1),
                                      ),
                                      crecheEnrollChild[index]['date_of_exit']!=null?
                                      Text(
                                        '${Global.returnTrLable(translats, 'Date of Exit', lng).trim()} : ',
                                        style: Styles.black104,
                                      ):SizedBox(),
                                      Text(
                                        '${Global.returnTrLable(translats, "Age on the month of Enroll", lng).trim()} : ',
                                        style: Styles.black104,
                                        strutStyle: StrutStyle(height: 1),
                                      ),
                                      Text(
                                        '${Global.returnTrLable(translats, 'Date of Enrollment', lng).trim()} : ',
                                        style: Styles.black104,
                                        strutStyle: StrutStyle(height: 1),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 10),
                                  SizedBox(
                                    height: 35.h,
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
                                          crecheEnrollChild[index]['exitResponces']!=null?Global.getItemValues(
                                              crecheEnrollChild[index]['cResponces'],
                                              'creche_name'):Global.getItemValues(
                                              crecheEnrollChild[index]['crResponces'],
                                              'creche_name'),
                                          style: Styles.blue125,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        crecheEnrollChild[index]['date_of_exit']!=null? Text(
                                            Validate().displeDateFormate(crecheEnrollChild[index]['date_of_exit']),
                                          style: Styles.blue125,
                                          overflow: TextOverflow.ellipsis,
                                        ):SizedBox(),
                                        Text(
                                          Global.getItemValues(
                                              crecheEnrollChild[index]['responces'],
                                              'age_at_enrollment_in_months'),
                                          style: Styles.blue125,
                                          strutStyle: StrutStyle(height: .5),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          Global.validString(Global.getItemValues(
                                              crecheEnrollChild[index]['responces'],
                                              'date_of_enrollment'))?Validate().displeDateFormate(
                                              Global.getItemValues(
                                                  crecheEnrollChild[index]['responces'],
                                                  'date_of_enrollment')):'',
                                          style: Styles.blue125,
                                          // strutStyle: StrutStyle(height: .3),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Column(
                                    children: [
                                      SizedBox(
                                        height: 30.h,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    })
                : Center(
                    child: Text(Global.returnTrLable(
                        translats, CustomText.NorecordAvailable, lng)),
                  ),
          )
        ]),
      ),
    );
  }

  String getReasonOfExit(String reasonId) {
    String reason = '';
    var items = reasonOfExit
        .where((element) => element.name.toString() == reasonId)
        .toList();
    if (items.length > 0) {
      reason = items[0].values!;
    }
    return reason;
  }


}
