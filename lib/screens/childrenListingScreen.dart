import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/custom_widget/custom_text.dart';
import 'package:shishughar/database/helper/dynamic_screen_helper/house_hold_children_helper.dart';
import 'package:shishughar/database/helper/translation_language_helper.dart';
import 'package:shishughar/model/apimodel/translation_language_api_model.dart';
import 'package:shishughar/model/databasemodel/hh_children_show_model.dart';
import 'package:shishughar/model/dynamic_screen_model/house_hold_children_model.dart';
import 'package:shishughar/style/styles.dart';
import 'package:shishughar/utils/validate.dart';

import '../database/database_helper.dart';
import '../database/helper/dynamic_screen_helper/house_hold_tab_responce.dart';
import '../database/helper/dynamic_screen_helper/options_model_helper.dart';
import '../model/dynamic_screen_model/options_model.dart';
import '../utils/globle_method.dart';
import 'tabed_screens/house_hold/add_household_childred_form_expeded.dart';

class ChildrenListingScreen extends StatefulWidget {
  final String hhGuid;
  const ChildrenListingScreen({super.key, required this.hhGuid});

  @override
  State<ChildrenListingScreen> createState() => _ChildrenListingScreenState();
}

class _ChildrenListingScreenState extends State<ChildrenListingScreen> {
  bool _isLoading = true;
  List<HouseHoldChildrenModel> hhChilddata = [];
  List<OptionsModel> relationChilddata = [];
  List<Translation> childListingControlls = [];
  String? lng;
  String? role;
  @override
  void initState() {
    super.initState();
    setLabelText();
    fetchHhChildrenDataList();
  }

  Future<void> fetchHhChildrenDataList() async {
    HouseHoldChildrenHelperHelper databaseHelper =
        HouseHoldChildrenHelperHelper();
    hhChilddata = await databaseHelper.getHouseHoldChildren(widget.hhGuid);
    role = await Validate().readString(Validate.role);
    OptionsModelHelper optionHelper = OptionsModelHelper();
    relationChilddata =
        await optionHelper.getMstCommonOptions('Relation', lng!);
    var checkChil = await checkChildrenLimit(hhChilddata.length);
    if (role == 'Creche Supervisor') {
      // if (!checkChil) {   for status child count > family under age 3 year in family tab
      var alredRecord = await HouseHoldTabResponceHelper()
          .getHouseHoldResponce(widget.hhGuid);
      if (alredRecord.length > 0) {
        if (alredRecord[0].is_edited == 1) {
          var responce = jsonDecode(alredRecord[0].responces!);
          responce['verification_status'] = '2';
          var jsonReso = jsonEncode(responce);
          await HouseHoldTabResponceHelper()
              .updateResponce(jsonReso, widget.hhGuid);
        }
      }
      // }
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Global.applyDisplayCutout(Color(0xff5979AA));
    if (_isLoading)
      return Center(child: CircularProgressIndicator());
    else {
      return SafeArea(
        child: Scaffold(
          floatingActionButton: InkWell(
            onTap: () async {
              String cHHGUID = '';

              if (!Global.validString(cHHGUID)) {
                // var checkChil = await checkChildrenLimit(hhChilddata.length);
                // if (checkChil) {
                cHHGUID = Validate().randomGuid();
                print("childes $cHHGUID");
                var refStatus = await Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            AddHouseholdScreenChildrenFromExpended(
                                hhGuid: widget.hhGuid,
                                cHHGuid: cHHGUID,
                                dobisReadable: false)));
                if (refStatus == 'itemRefresh') {
                  await fetchHhChildrenDataList();
                }
                // } else {
                //   Validate().singleButtonPopup(Global.returnTrLable(childListingControlls,
                //       'Can not add children more than ${hhChilddata.length}', lng!),
                //       Global.returnTrLable(childListingControlls, CustomText.ok, lng!), false, context);

                // }
              }
            },
            child: Image.asset(
              "assets/add_btn.png",
              scale: 2.7,
              color: Color(0xff5979AA),
            ),
          ),
          body: hhChilddata.length > 0
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  child: ListView.builder(
                      itemCount: hhChilddata.length,
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () async {
                            print('Item $index tapped');
                            var isEditable=await Validate().checkEditable(hhChilddata[index].created_at,15);
                            var refStatus = await Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        AddHouseholdScreenChildrenFromExpended(
                                            hhGuid: hhChilddata[index].HHGUID!,
                                            cHHGuid: hhChilddata[index].CHHGUID!,
                                            dobisReadable:isEditable)));
                            if (refStatus == 'itemRefresh') {
                              await fetchHhChildrenDataList();
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
                                child:
                                    // Row(
                                    //   mainAxisAlignment: MainAxisAlignment.start,
                                    //   crossAxisAlignment: CrossAxisAlignment.center,
                                    //   children: [
                                    //     index % 3 == 0
                                    //         ? Image.asset(
                                    //       "assets/childicon.png",
                                    //       scale: 2.8,
                                    //     )
                                    //         : index % 3 == 1
                                    //         ? Image.asset(
                                    //       "assets/cyanchild.png",
                                    //       scale: 2.8,
                                    //     )
                                    //         : Image.asset(
                                    //       "assets/yellowchild.png",
                                    //       scale: 2.8,
                                    //     ),
                                    //     SizedBox(
                                    //       width: 10.w,
                                    //     ),
                                    //     Expanded(
                                    //       child: Column(
                                    //         crossAxisAlignment: CrossAxisAlignment.start,
                                    //         children: [
                                    //           RichText(
                                    //               overflow: TextOverflow.ellipsis,
                                    //               text: TextSpan(
                                    //                   text: Global.returnTrLable(childListingControlls, 'Child Name',lng!)+ " : ",
                                    //                   style: Styles.Grey104,
                                    //                   children: [
                                    //                     TextSpan(
                                    //                         text: getItemValues(hhChilddata[index].responces!,'child_name'),
                                    //                         style: Styles.black125),
                                    //                   ])),
                                    //           RichText(
                                    //               strutStyle: StrutStyle(height: 1.h),
                                    //               overflow: TextOverflow.ellipsis,
                                    //               text: TextSpan(
                                    //                   text: Global.returnTrLable(childListingControlls, 'Relationship with child',lng!)+ " : ",
                                    //                   style: Styles.Grey104,
                                    //                   children: [
                                    //                     TextSpan(
                                    //                         text: getfindRelationValues(getItemValues(hhChilddata[index].responces!,'relationship_with_child')),
                                    //                         style: Styles.black125),
                                    //                   ])),
                                    //           Row(
                                    //             children: [
                                    //               RichText(
                                    //                   strutStyle: StrutStyle(height: 1.h),
                                    //                   overflow: TextOverflow.ellipsis,
                                    //                   text: TextSpan(
                                    //                       text: Global.returnTrLable(childListingControlls, 'Child Age (In Months)',lng!)+ " : ",
                                    //                       style: Styles.Grey104,
                                    //                       children: [
                                    //                         TextSpan(
                                    //                             text: getItemValues(hhChilddata[index].responces!,'child_age'),
                                    //                             style: Styles.black125),
                                    //                       ])),
                                    //             ],
                                    //           ),
                                    //           // RichText(
                                    //           //     overflow: TextOverflow.ellipsis,
                                    //           //     text: TextSpan(
                                    //           //         text: CustomText.LastMeasurement,
                                    //           //         style: Styles.black64,
                                    //           //         children: [
                                    //           //           TextSpan(
                                    //           //               text: " Dec 1, 2023",
                                    //           //               style: Styles.black66),
                                    //           //         ]))
                                    //         ],
                                    //       ),
                                    //     ),
                                    //     // Spacer(),
                                    //     // Column(
                                    //     //   mainAxisAlignment: MainAxisAlignment.end,
                                    //     //   children: [
                                    //     //     index % 2 == 0
                                    //     //         ? Image.asset(
                                    //     //       "assets/verify.png",
                                    //     //       scale: 2.2,
                                    //     //     )
                                    //     //         : Image.asset(
                                    //     //       "assets/greyverify.png",
                                    //     //       scale: 3.7,
                                    //     //     ),
                                    //     //   ],
                                    //     // )
                                    //   ],
                                    // ),
                                    Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // index % 3 == 0
                                    //     ? Image.asset(
                                    //   "assets/childicon.png",
                                    //   scale: 2.8,
                                    // )
                                    //     : index % 3 == 1
                                    //     ? Image.asset(
                                    //   "assets/cyanchild.png",
                                    //   scale: 2.8,
                                    // )
                                    //     : Image.asset(
                                    //   "assets/yellowchild.png",
                                    //   scale: 2.8,
                                    // ),
                                    // SizedBox(
                                    //   width: 10.w,
                                    // ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          Global.returnTrLable(
                                                  childListingControlls,
                                                  'Child Name',
                                                  lng!) +
                                              " : ",
                                          style: Styles.black104,
                                        ),
                                        Text(
                                          callChildWithRelationText(
                                                  Global.returnTrLable(
                                                      childListingControlls,
                                                      'Relationship with child',
                                                      lng!)) +
                                              " : ",
                                          style: Styles.black104,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          strutStyle: StrutStyle(height: 1.2),
                                        ),
                                        Text(
                                          Global.returnTrLable(
                                                  childListingControlls,
                                                  'Child Age (In Months)',
                                                  lng!) +
                                              " : ",
                                          style: Styles.black104,
                                          strutStyle: StrutStyle(height: 1.2),
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
                                            getItemValues(
                                                hhChilddata[index].responces!,
                                                'child_name'),
                                            style: Styles.cardBlue10,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                              getfindRelationValues(getItemValues(
                                                  hhChilddata[index].responces!,
                                                  'relationship_with_child')),
                                              strutStyle: StrutStyle(height: 1.2),
                                              style: Styles.cardBlue10,
                                              overflow: TextOverflow.ellipsis),
                                          SizedBox(height: 8),
                                          Text(
                                              Global.validString(getItemValues(
                                                      hhChilddata[index]
                                                          .responces!,
                                                      'child_dob'))
                                                  ? Validate()
                                                      .calculateAgeInMonths(
                                                          Validate().stringToDate(
                                                              getItemValues(
                                                                  hhChilddata[
                                                                          index]
                                                                      .responces!,
                                                                  'child_dob')))
                                                      .toString()
                                                  : getItemValues(
                                                      hhChilddata[index]
                                                          .responces!,
                                                      'child_age'),
                                              strutStyle: StrutStyle(height: 1.2),
                                              style: Styles.cardBlue10,
                                              overflow: TextOverflow.ellipsis),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    (hhChilddata[index].is_edited == 0 &&
                                            hhChilddata[index].is_uploaded == 1)
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
                )
              : Center(
                  child: Text(Global.returnTrLable(childListingControlls,
                      CustomText.NorecordAvailable, lng!))),
        ),
      );
    }
  }

  String getItemValues(String response, String key) {
    String returnValue = "";
    Map<String, dynamic> itemresponse = jsonDecode(response);
    var value = itemresponse[key];
    if (value != null) {
      returnValue = value.toString();
    }
    return returnValue;
  }

  String getfindRelationValues(String id) {
    String returnValue = "";

    if (Global.validString(id)) {
      var reltionvl =
          relationChilddata.where((element) => element.name == id).toList();
      if (reltionvl.length > 0) {
        returnValue = reltionvl[0].values!;
      }
    }

    return returnValue;
  }

  Future<bool> checkChildrenLimit(int totalChildren) async {
    var alredRecord =
        await HouseHoldTabResponceHelper().getHouseHoldResponce(widget.hhGuid);
    var children__3_years = 0;
    if (alredRecord.length > 0) {
      Map<String, dynamic> responseData = jsonDecode(alredRecord[0].responces!);

      children__3_years = responseData['children__3_years'];
    }
    if (children__3_years > totalChildren) {
      return true;
    } else
      return false;
  }

  Future<void> setLabelText() async {
    lng = await Validate().readString(Validate.sLanguage);
    List<String> valueNames = [
      'Child Name',
      'Relationship with child',
      'Child Age (In Months)',
      'Can not add children more than',
      CustomText.ok,
      CustomText.NorecordAvailable
    ];

    await TranslationDataHelper()
        .callTranslateString(valueNames)
        .then((value) => childListingControlls = value);

    setState(() {});
  }

  String callChildWithRelationText(String item) {
    String retuValue = item;
    var slip = Global.splitData(item, '(');
    if (slip.length > 1) {
      retuValue = '${slip[0]}\n(${slip[1]}';
    }
    return retuValue;
  }

}
