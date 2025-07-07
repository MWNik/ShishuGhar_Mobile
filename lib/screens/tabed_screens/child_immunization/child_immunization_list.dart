import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/custom_widget/custom_appbar.dart';
import 'package:shishughar/database/helper/child_immunization/child_immunization_response_helper.dart';
import 'package:shishughar/model/dynamic_screen_model/child_immunization_response_model.dart';
import 'package:shishughar/screens/tabed_screens/child_immunization/child_immunization_details_screen.dart';
import 'package:shishughar/utils/validate.dart';

import '../../../custom_widget/custom_text.dart';
import '../../../database/helper/translation_language_helper.dart';
import '../../../database/helper/vaccines_helper.dart';
import '../../../model/apimodel/translation_language_api_model.dart';
import '../../../model/databasemodel/vaccines_model.dart';
import '../../../model/dynamic_screen_model/enrolled_children_responce_model.dart';
import '../../../style/styles.dart';
import '../../../utils/globle_method.dart';
import 'child_immunization_expended_details_screen.dart';

class ChildImmunizationListing extends StatefulWidget {
  final int? enName;
  final String? creche_id;
  final String? chilenrolledGUID;
  final EnrolledChildrenResponceModel? enrolledItem;

  const ChildImmunizationListing(
      {super.key,
      required this.enName,
      required this.creche_id,
      required this.chilenrolledGUID,
      required this.enrolledItem});

  @override
  State<ChildImmunizationListing> createState() =>
      _ChildImmunizatioListingState();
}

class _ChildImmunizatioListingState extends State<ChildImmunizationListing> {
  List<ChildImmunizationResponceModel> childImmuData = [];
  List<Translation> translats = [];
  String lng = 'en';
  List<VaccineModel> vaccines = [];

  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    translats.clear();
    vaccines = await VaccinesDataHelper().callAllVaccines();
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
    fetchChildevents();
    setState(() {});
  }

  Future<void> fetchChildevents() async {
    childImmuData = await ChildImmunizationResponseHelper()
        .childEventByChild(widget.creche_id, widget.chilenrolledGUID);
    // await callDatesList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Global.applyDisplayCutout(Color(0xff5979AA));
    return SafeArea(
      child: Scaffold(
        floatingActionButton: InkWell(
          onTap: () async {
            String chilimmuGuid = '';
            // if (!(Global.validString(chilimmuGuid))) {
            //   chilimmuGuid = Validate().randomGuid();
            //   var refStatus = await Navigator.of(context).push(MaterialPageRoute(
            //       builder: (BuildContext context) =>
            //           ChildImmunizationExpendedDetailsScreen(
            //             child_immunization_guid: chilimmuGuid,
            //             chilenrolledGUID: widget.chilenrolledGUID,
            //             enName: widget.enName!,
            //             creche_id: widget.creche_id,
            //             enrolledItem: widget.enrolledItem,
            //           )));
            //   if (refStatus == 'itemRefresh') {
            //     fetchChildevents();
            //   }
            // }
          },
          child: Image.asset(
            "assets/add_btn.png",
            scale: 2.7,
            color: Color(0xff5979AA),
          ),
        ),
        appBar: CustomAppbar(
          text: Global.returnTrLable(translats, CustomText.ImmunizationList, lng),
          onTap: () => Navigator.pop(context, 'itemRefresh'),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Column(children: [
            Expanded(
              child: (childImmuData.length > 0)
                  ? ListView.builder(
                      itemCount: childImmuData.length,
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () async {
                            // var refStatus = await Navigator.of(context).push(
                            //     MaterialPageRoute(
                            //         builder: (BuildContext context) =>
                            //             ChildImmunizationExpendedDetailsScreen(
                            //               child_immunization_guid:
                            //                   childImmuData[index]
                            //                       .child_immunization_guid,
                            //               chilenrolledGUID:
                            //                   widget.chilenrolledGUID,
                            //               enName: widget.enName!,
                            //               creche_id: widget.creche_id,
                            //               enrolledItem: widget.enrolledItem,
                            //             )));
                            // if (refStatus == 'itemRefresh') {
                            //   await fetchChildevents();
                            // }
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
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${Global.returnTrLable(translats, 'Vaccines', lng).trim()} : ',
                                          style: Styles.black104,
                                        ),
                                        Text(
                                          '${Global.returnTrLable(translats, "Vaccination Date", lng).trim()} : ',
                                          style: Styles.black104,
                                          strutStyle: StrutStyle(height: 1),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 10),
                                    SizedBox(
                                      height: 10.h,
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
                                            callVaccinesName(
                                                childImmuData[index].responces!),
                                            style: Styles.blue125,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            Validate()
                                                .displeDateFormateMobileDateTimeFormate(
                                                    Global.getItemValues(
                                                        childImmuData[index]
                                                            .responces!,
                                                        'appcreated_on')),
                                            style: Styles.blue125,
                                            strutStyle: StrutStyle(height: .5),
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
            ),
          ]),
        ),
      ),
    );
  }

  String callVaccinesName(String? immuData) {
    String vacctionsData = '';
    if(immuData!=null){
      Map<String, dynamic> responcesData = jsonDecode(immuData);
      var childs = responcesData['vaccine_details'];
      List<int>  vaccienesIdes=[];
      if (childs != null) {
        List<Map<String, dynamic>> children = List<Map<String, dynamic>>.from(childs);

        children.forEach((element) {
          vaccienesIdes.add(Global.stringToInt(element['vaccine_id'].toString()));
        });
      }
      vaccines.forEach((element) {
        if(vaccienesIdes.contains(element.name)){
          if(Global.validString(vacctionsData)){
            vacctionsData='$vacctionsData,${element.vaccine!}';
          }else vacctionsData=element.vaccine!;
        }
      });

    }
    return vacctionsData;
  }
}
