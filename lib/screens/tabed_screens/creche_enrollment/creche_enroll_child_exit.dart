import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/database/helper/dynamic_screen_helper/options_model_helper.dart';
import 'package:shishughar/model/apimodel/creche_database_responce_model.dart';

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

class CrecheEnrollChildExit extends StatefulWidget {
  final String? creche_id;
  final String? chilenrolledGUID;

  CrecheEnrollChildExit({
    super.key,
    required this.chilenrolledGUID,
    required this.creche_id,
  });

  @override
  State<CrecheEnrollChildExit> createState() => _CrecheEnrollChildExitState();
}

class _CrecheEnrollChildExitState extends State<CrecheEnrollChildExit> {
  List<Map<String, dynamic>> exitedChildHistory = [];
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
      CustomText.Village
    ];
    await TranslationDataHelper()
        .callTranslateString(valueItems)
        .then((value) => translats.addAll(value));
    reasonOfExit =
        await OptionsModelHelper().getMstCommonOptions('Reason for child exit',lng);

    await fetchChildexits();
  }

  Future<void> fetchChildexits() async {
    exitedChildHistory = await ChildExitResponceHelper()
        .exitedChildHistoryByEnrollChildGUID(widget.chilenrolledGUID);

    setState(() {});
  }


  @override
  void initState() {
    super.initState();
    initializeData();
  }

  @override
  Widget build(BuildContext context) {
    Global.applyDisplayCutout(Color(0xff5979AA));
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Column(children: [
            Expanded(
              child: (exitedChildHistory.length > 0)
                  ? ListView.builder(
                      itemCount: exitedChildHistory.length,
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () async {
                            var refStatus = await Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ExitedChildDetailView(
                                          childExitGuid: Global.getItemValues(exitedChildHistory[index]['exitResponces'], 'child_exit_guid'),
                                          chilenrolledGUID: exitedChildHistory[index]['ChildEnrollGUID'],
                                          creche_id: Global.getItemValues(exitedChildHistory[index]['responces'], 'creche_id'),
                                          childId: Global.getItemValues(exitedChildHistory[index]['responces'], 'child_id'),
                                          childName: Global.getItemValues(exitedChildHistory[index]['responces'], 'child_name'),
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
                                        Text(
                                          '${Global.returnTrLable(translats, 'Date of Exit', lng).trim()} : ',
                                          style: Styles.black104,
                                        ),
                                        Text(
                                          '${Global.returnTrLable(translats, "Age on the day of Enroll", lng).trim()} : ',
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
                                                exitedChildHistory[index]['cResponces'],
                                                'creche_name'),
                                            style: Styles.blue125,
                                            // strutStyle: StrutStyle(height: .3),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            Validate().displeDateFormate(
                                                Global.getItemValues(
                                                    exitedChildHistory[index]['exitResponces'],
                                                    'date_of_exit')),
                                            style: Styles.blue125,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            Global.getItemValues(
                                                exitedChildHistory[index]['responces'],
                                                'age_at_enrollment_in_months'),
                                            // 'age_of_exit'),
                                            style: Styles.blue125,
                                            strutStyle: StrutStyle(height: .5),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            Validate().displeDateFormate(
                                                Global.getItemValues(
                                                    exitedChildHistory[index]['responces'],
                                                    'date_of_enrollment')),
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
