import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/custom_widget/custom_appbar.dart';
import 'package:shishughar/screens/tabed_screens/anthrometory/child_growth_listing_screen.dart';
import 'package:shishughar/screens/tabed_screens/anthrometory/child_growth_listing_screen_cc.dart';
import 'package:shishughar/screens/tabed_screens/attendence/attendance_listed_screen.dart';
import 'package:shishughar/screens/tabed_screens/cashbook/cashbook_listing_Tab_screen.dart';
import 'package:shishughar/screens/tabed_screens/child_exit/child_exit_listing_Tab_screen.dart';
import 'package:shishughar/screens/tabed_screens/creche_commite_meeting/creche_committe_listing_screen.dart';
import 'package:shishughar/screens/tabed_screens/creche_monitering_checkList_cbm/creche_monitering_checklist_CBM_listing_screen.dart';
import 'package:shishughar/screens/tabed_screens/creche_monitering_checklist_CC/creche_monitering_checklist_CC_listing_screen.dart';
import 'package:shishughar/screens/tabed_screens/creche_monitering_checklist_alm/creche_monitering_checklist_ALM_listing_screen.dart';
import 'package:shishughar/screens/tabed_screens/creche_monitor/creche_monitor_listing_screen.dart';
import 'package:shishughar/screens/tabed_screens/enrolled_children/children_enrolled_for_cc_listed.dart';
import 'package:shishughar/screens/tabed_screens/enrolled_exit_child/enrolled_exit_child_listing_tab.dart';
import 'package:shishughar/screens/tabed_screens/stock/stock_tab_listing_screen.dart';
// import 'package:shishughar/screens/tabed_screens/stock/stock_tab_listing_screen.dart';

import '../custom_widget/custom_text.dart';
import '../database/helper/creche_helper/creche_data_helper.dart';
import '../database/helper/dynamic_screen_helper/options_model_helper.dart';
import '../database/helper/enrolled_exit_child/enrolled_exit_child_responce_helper.dart';
import '../database/helper/translation_language_helper.dart';
import '../model/apimodel/creche_database_responce_model.dart';
import '../model/apimodel/translation_language_api_model.dart';
import '../style/styles.dart';
import '../utils/globle_method.dart';
import '../utils/validate.dart';

class ShishuGharDetailsReplica extends StatefulWidget {
  final int crecheId;
  ShishuGharDetailsReplica({super.key, required this.crecheId});

  @override
  _ShishuGharDetailsReplicaState createState() =>
      _ShishuGharDetailsReplicaState();
}

class _ShishuGharDetailsReplicaState extends State<ShishuGharDetailsReplica> {
  String? lng = 'en';
  List<Translation> locationControlls = [];
  CresheDatabaseResponceModel? responce;
  List<String> image = [];
  List<String> text = [];
  String? state;
  String? district;
  String? block;
  String? gp;
  String? village;
  String? supName;
  String? crechName;
  String? role;
  @override
  void initState() {
    super.initState();
    initializeLabel();
  }

  Future<void> getCrecheResponce() async {
    var items = await CrecheDataHelper().getCrecheResponceItem(widget.crecheId);
    if (items.length > 0) {
      responce = items[0];
      Map<String, dynamic> responseData = jsonDecode(responce!.responces!);
      crechName = Global.getItemValues(responce!.responces!, 'creche_name');
      if (Global.validString(
          Global.getItemValues(responce!.responces!, 'state_id'))) {
        var states = await OptionsModelHelper()
            .getLocationData('State', responseData, lng!);
        if (states.length > 0) {
          state = states[0].values;
        }
      }
      if (Global.validString(
          Global.getItemValues(responce!.responces!, 'district_id'))) {
        var districts = await OptionsModelHelper()
            .getLocationData('District', responseData, lng!);
        if (districts.length > 0) {
          district = districts[0].values;
        }
      }
      if (Global.validString(
          Global.getItemValues(responce!.responces!, 'block_id'))) {
        var blocks = await OptionsModelHelper()
            .getLocationData('Block', responseData, lng!);
        if (blocks.length > 0) {
          block = blocks[0].values;
        }
      }
      if (Global.validString(
          Global.getItemValues(responce!.responces!, 'gp_id'))) {
        var gps = await OptionsModelHelper()
            .getLocationData('Gram Panchayat', responseData, lng!);
        if (gps.length > 0) {
          gp = gps[0].values;
        }
      }

      if (Global.validString(
          Global.getItemValues(responce!.responces!, 'village_id'))) {
        var villages = await OptionsModelHelper()
            .getLocationData('Village', responseData, lng!);
        if (villages.length > 0) {
          village = villages[0].values;
        }
      }

      if (Global.validString(
          Global.getItemValues(responce!.responces!, 'supervisor_id'))) {
        var villages = await OptionsModelHelper()
            .getPartnerMstCommonOptions('User', responseData);
        if (villages.length > 0) {
          supName = villages[0].values;
        }
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        text: Global.returnTrLable(
            locationControlls, CustomText.ShishuGharDetails, lng!),
        onTap: () => Navigator.pop(context),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            GestureDetector(
              child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Color(0xffE7F0FF)),
                        borderRadius: BorderRadius.circular(10.r)),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                  '${Global.returnTrLable(locationControlls, CustomText.Creche_Name, lng!)} :',
                                  style: Styles.black104),
                              Text(
                                '${Global.returnTrLable(locationControlls, CustomText.Village, lng!)} :',
                                style: Styles.black104,
                                strutStyle: StrutStyle(height: 1.2),
                              ),
                              Text(
                                '${Global.returnTrLable(locationControlls, CustomText.GramPanchayat, lng!)} :',
                                style: Styles.black104,
                                strutStyle: StrutStyle(height: 1.2),
                              ),
                              Text(
                                '${Global.returnTrLable(locationControlls, CustomText.Block, lng!)} :',
                                style: Styles.black104,
                                strutStyle: StrutStyle(height: 1.2),
                              ),
                              Text(
                                '${Global.returnTrLable(locationControlls, CustomText.District, lng!)} :',
                                style: Styles.black104,
                                strutStyle: StrutStyle(height: 1.2),
                              ),
                              Text(
                                '${Global.returnTrLable(locationControlls, CustomText.State, lng!)} :',
                                style: Styles.black104,
                                strutStyle: StrutStyle(height: 1.2),
                              ),
                              Text(
                                '${Global.returnTrLable(locationControlls, CustomText.Supervisor, lng!)} :',
                                style: Styles.black104,
                                strutStyle: StrutStyle(height: 1.2),
                              ),
                            ],
                          ),
                          SizedBox(width: 10),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.14,
                            width: 2,
                            child: VerticalDivider(
                              color: Color(0xffE6E6E6),
                            ),
                          ),
                          SizedBox(width: 10),
                          responce != null
                              ? Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        Global.getItemValues(
                                            responce!.responces!,
                                            'creche_name'),
                                        style: Styles.cardBlue10,
                                      ),
                                      Text(
                                        village != null ? '$village' : '',
                                        style: Styles.cardBlue10,
                                        strutStyle: StrutStyle(height: 1.2),
                                      ),
                                      Text(
                                        gp != null ? '$gp' : '',
                                        style: Styles.cardBlue10,
                                        strutStyle: StrutStyle(height: 1.2),
                                      ),
                                      Text(
                                        block != null ? '$block' : '',
                                        style: Styles.cardBlue10,
                                        strutStyle: StrutStyle(height: 1.2),
                                      ),
                                      Text(
                                        district != null ? '$district' : '',
                                        style: Styles.cardBlue10,
                                        strutStyle: StrutStyle(height: 1.2),
                                      ),
                                      Text(
                                        state != null ? '$state' : '',
                                        style: Styles.cardBlue10,
                                        strutStyle: StrutStyle(height: 1.2),
                                      ),
                                      Text(
                                        supName != null ? '$supName' : '',
                                        style: Styles.cardBlue10,
                                        strutStyle: StrutStyle(height: 1.2),
                                      ),
                                    ],
                                  ),
                                )
                              : SizedBox(),
                        ],
                      ),
                    ),
                  )),
            ),
            SizedBox(height: 7.h),
            Expanded(
                child: GridView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        mainAxisExtent: 90.h),
                    itemCount: text.length,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (ctx, i) {
                      return InkWell(
                        onTap: () async {
                          await onclick(i, image[i]);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xff5A5A5A).withOpacity(
                                      0.1), // Shadow color with opacity
                                  offset: Offset(
                                      0, 1), // Horizontal and vertical offset
                                  blurRadius: 5, // Blur radius
                                  spreadRadius: 0, // Spread radius
                                ),
                              ],
                              color: Color(0xffF2F7FF),
                              borderRadius: BorderRadius.circular(5.r),
                              border: Border.all(
                                color: Color(0xffE7F0FF),
                              )),
                          height: 168.h,
                          width: 146.w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Visibility(
                                      visible: true,
                                      child: Stack(
                                        children: [
                                          SizedBox(
                                            height: 40,
                                            width: 40,
                                            child: Image.asset(
                                              image[i],
                                              filterQuality: FilterQuality.high,
                                              scale: 0.7,
                                              color: Color(0xff5979AA),
                                            ),
                                          )
                                        ],
                                      )),
                                  SizedBox(
                                    height: i == 3 || i == 5 ? 12.h : 15.h,
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 7),
                                    child: Text(
                                      Global.returnTrLable(
                                          locationControlls, text[i], lng!),
                                      style: Styles.listlablefont,
                                      textAlign: TextAlign.center,
                                      // overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  )
                                ],
                              ))
                            ],
                          ),
                        ),
                      );
                    }))
          ],
        ),
      ),
    );
  }

  Future<void> initializeLabel() async {
    lng = await Validate().readString(Validate.sLanguage);
    role = await Validate().readString(Validate.role);
    image = [
      'assets/creche_profile/enrolled_child_new.png',
      'assets/creche_profile/child_exit.png',
      'assets/creche_profile/committee.png',
      'assets/creche_profile/attendance.png',
      'assets/creche_profile/anatomy.png',
      'assets/creche_profile/notes.png',
      'assets/creche_profile/casebook.png',
      'assets/creche_profile/stock.png',
    ];

    text = [
      CustomText.enrolled_children,
      CustomText.child_exit,
      CustomText.creche_committee_meeting,
      CustomText.Attendance,
      CustomText.GrowthMonitoring,
      CustomText.VisitNote,
      CustomText.Cashbook,
      CustomText.Stock,
    ];

    List<String> valueNames = [
      ...text,
      CustomText.Creche_Name,
      CustomText.Village,
      CustomText.GramPanchayat,
      CustomText.Supervisor,
      CustomText.state,
      CustomText.District,
      CustomText.Block,
      CustomText.Opened_On,
      CustomText.ShishuGharDetails,
      CustomText.DontHaveChildrenForAttender,
      CustomText.DontHaveChildrenForAnthropometry
    ];

    await TranslationDataHelper()
        .callTranslateString(valueNames)
        .then((value) => locationControlls = value);
    await getCrecheResponce();
    setState(() {});
  }

  Future<void> onclick(int i, String imsgeItem) async {
    if (i == 0) {
      // if (role == CustomText.crecheSupervisor.trim() ||
      //     role == CustomText.clusterCoordinator.trim()) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => EnrolledExitChildListingTab(
              creCheId: widget.crecheId,
              village_id:
                  Global.getItemValues(responce!.responces!, 'village_id'))));
      // }
    } else if (i == 1) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => ChildExitListingTabScreen(
              creche_id: widget.crecheId.toString())));
    } else if (i == 2) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => CrecheCommitteListingScreen(
              creche_id: widget.crecheId.toString(), crecheName: crechName!)));
    } else if (i == 3) {
      var items = await EnrolledExitChilrenResponceHelper()
          .enrolledChildByCreche(widget.crecheId);
      if (items.length > 0) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => AttendanceListedScreen(
                  creche_nameId: widget.crecheId,
                  creche_name: crechName,
                )));
      } else
        Validate().singleButtonPopup(CustomText.DontHaveChildrenForAttender,
            CustomText.ok, false, context);
    } else if (i == 4) {
      var items = await EnrolledExitChilrenResponceHelper()
          .enrolledChildByCreche(widget.crecheId);
      if (items.length > 0) {
        if (role == CustomText.crecheSupervisor) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => ChildGrowthListingScreen(
                    creche_nameId: widget.crecheId,
                    creche_name: crechName!,
                  )));
        } else {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => ChildGrowthListingScreenCC(
                    creche_nameId: widget.crecheId,
                    creche_name: crechName!,
                  )));
        }
      } else
        Validate().singleButtonPopup(
            CustomText.DontHaveChildrenForAnthropometry,
            CustomText.ok,
            false,
            context);
    } else if (i == 5) {
      if (role == CustomText.crecheSupervisor) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => CrecheMonitorListingScreen(
                  crecheId: widget.crecheId.toString(),
                  crecheName: crechName!,
                )));
      } else if (role == CustomText.clusterCoordinator) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => cmcCCListingScreen(
                  creche_id: widget.crecheId.toString(),
                  crecheName: crechName!,
                )));
      } else if (role == CustomText.alm.trim()) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => cmcALMListingScreen(
                  creche_id: widget.crecheId.toString(),
                  crecheName: crechName!,
                )));
      } else if (role == CustomText.cbm.trim()) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => cmcCBMListingScreen(
                  creche_id: widget.crecheId.toString(),
                  crecheName: crechName!,
                )));
      }
    } else if (i == 6) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => CashBookListingTabScreen(
                creche_id: widget.crecheId.toString(),
              )));
    } else if (i == 7) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => StockTabListingScreen(
                creche_id: widget.crecheId.toString(),
              )));
    }
  }
}
