import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/custom_widget/custom_appbar.dart';
import 'package:shishughar/custom_widget/custom_text.dart';
import 'package:shishughar/database/helper/enrolled_exit_child/enrolled_exit_child_responce_helper.dart';
import 'package:shishughar/model/apimodel/translation_language_api_model.dart';
import 'package:shishughar/model/dynamic_screen_model/enrolled_child_exit_responce_model.dart';
import 'package:shishughar/screens/tabed_screens/anthrometory/child_growth_listing_screen_in_child.dart';
import 'package:shishughar/screens/tabed_screens/child_event/child_event_listing_screen.dart';
import 'package:shishughar/screens/tabed_screens/child_follow_up/child_followUp_completed_list_forChild_CC.dart';
import 'package:shishughar/screens/tabed_screens/child_follow_up/follow_up_tab_screen_for_child.dart';
import 'package:shishughar/screens/tabed_screens/child_health/child_health_listing_screen.dart';
import 'package:shishughar/screens/tabed_screens/child_immunization/child_immunization_details_tab.dart';
import 'package:shishughar/screens/tabed_screens/child_reffrel/referral_completed_listing_CC.dart';
import 'package:shishughar/screens/tabed_screens/child_reffrel/reffral_tab_screen.dart';
import 'package:shishughar/screens/tabed_screens/creche_enrollment/creche_enroll_child_enroll_single.dart';
import 'package:shishughar/screens/tabed_screens/enrolled_exit_child/enrolled_exit_child_tab.dart';
import 'package:shishughar/style/styles.dart';
import 'package:shishughar/utils/globle_method.dart';
import 'package:shishughar/utils/validate.dart';

import '../database/helper/backdated_configiration_helper.dart';
import '../database/helper/child_immunization/child_immunization_response_helper.dart';
import '../database/helper/child_reffrel/child_refferal_response_helper.dart';
import '../database/helper/creche_helper/creche_data_helper.dart';
import '../database/helper/dynamic_screen_helper/house_hold_tab_responce.dart';
import '../database/helper/dynamic_screen_helper/options_model_helper.dart';
import '../database/helper/translation_language_helper.dart';
import '../model/databasemodel/backdated_configiration_model.dart';
import '../model/dynamic_screen_model/child_referral_response_model.dart';
import 'child_growth_child_chart/weight_for_age_boys_girls_screen.dart';

class EnrolledChildDetailScreen extends StatefulWidget {

  final String CHHGUID;
  final String EnrolledChilGUID;
  final int HHname;
  final int enName;
  final int crechId;

  const EnrolledChildDetailScreen({
    super.key,
    required this.CHHGUID,
    required this.crechId,
    required this.HHname,
    required this.enName,
    required this.EnrolledChilGUID,
  });

  @override
  State<EnrolledChildDetailScreen> createState() =>
      _EnrolledChildDetailScreenState();
}

class _EnrolledChildDetailScreenState extends State<EnrolledChildDetailScreen> {
  List<Translation> labelControlls = [];
  EnrolledExitChildResponceModel? enrolledItem;
  String lng = "en";
  String supName = "";
  String gender = "";
  String hhName = "";
  String crechName = "";
  int? enName;
  String? role;
  String? date;
  String? crecheOpeningDate;
  String? crecheClosingDate;
  int _currentIndex = 0;
  List image = [
    'assets/childperson.png',
    'assets/creche_profile/creche_enrollment_new.png',
    'assets/growthmonitoring.png',
    'assets/creche_profile/flagged_children_new.png',
    'assets/creche_profile/child_followUp_new.png',
    'assets/growthChart.png',
    'assets/childimmunizationdetail.png',
    'assets/creche_profile/health_detail_new.png',
    'assets/childeventdetail.png',
  ];
  List<String> text = [
    CustomText.ChildProfile,
    CustomText.creche_enrollement,
    CustomText.anthropomertry,
    CustomText.childReferral,
    CustomText.FollowUps,
    CustomText.GrowthChart,
    CustomText.ChildImmunizationDetails,
    CustomText.ChildHealthDetail,
    CustomText.ChildEventDetail,
  ];
  BackdatedConfigirationModel? backdatedConfigirationModel;


  List<BottomNavigationBarItem> initBottomBar() {
    List<BottomNavigationBarItem> bottomItem = [];
    bottomItem.add(BottomNavigationBarItem(
      icon: Padding(
        padding: EdgeInsets.only(bottom: 5.h),
        child: Image.asset(
          "assets/home.png",
          scale: 2.7,
          color: _currentIndex == 0 ? Color(0xff5979AA) : Color(0xffAAAAAA),
        ),
      ),
      label: 'Home',
    ));
    bottomItem.add(BottomNavigationBarItem(
      icon: Padding(
        padding: EdgeInsets.only(bottom: 5.h),
        child: Image.asset(
          "assets/childenrolled.png",
          scale: 2.7,
          color: _currentIndex == 1 ? Color(0xff5979AA) : Color(0xffAAAAAA),
        ),
      ),
      label: 'Enrolled Child',
    ));
    bottomItem.add(BottomNavigationBarItem(
      icon: Padding(
        padding: EdgeInsets.only(bottom: 5.h),
        child: Image.asset(
          "assets/dashboard.png",
          scale: 4,
          color: _currentIndex == 2 ? Color(0xff5979AA) : Color(0xffAAAAAA),
        ),
      ),
      label: 'Dashboard',
    ));
    bottomItem.add(BottomNavigationBarItem(
      icon: Padding(
        padding: EdgeInsets.only(bottom: 5.h),
        child: Image.asset(
          "assets/report_ic.png",
          scale: 4,
          color: _currentIndex == 3 ? Color(0xff5979AA) : Color(0xffAAAAAA),
        ),
      ),
      label: 'Report',
    ));
    bottomItem.add(BottomNavigationBarItem(
      icon: Padding(
        padding: EdgeInsets.only(bottom: 10.h),
        child: Image.asset(
          "assets/more.png",
          scale: 2.3,
          color: _currentIndex == 4 ? Color(0xff5979AA) : Color(0xffAAAAAA),
        ),
      ),
      label: 'More',
    ));

    return bottomItem;
  }

  @override
  Widget build(BuildContext context) {
    Global.applyDisplayCutout(Color(0xff5979AA));
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, 'itemRefresh');
          return false;
        },
        child: Scaffold(
          appBar: CustomAppbar(
            text: Global.returnTrLable(
                labelControlls, CustomText.ChildDetails, lng),
            onTap: () {
              Navigator.pop(context, 'itemRefresh');
            },
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 15.w,
            ),
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
                                    '${Global.returnTrLable(labelControlls, CustomText.ChildId, lng)} :',
                                    style: Styles.black104),
                                Text(
                                  '${Global.returnTrLable(labelControlls, CustomText.ChildName, lng)} :',
                                  style: Styles.black104,
                                  strutStyle: StrutStyle(height: 1.2),
                                ),
                                Text(
                                  '${Global.returnTrLable(labelControlls, CustomText.ageInMonth, lng)} :',
                                  style: Styles.black104,
                                  strutStyle: StrutStyle(height: 1.2),
                                ),
                                Text(
                                  '${Global.returnTrLable(labelControlls, CustomText.Gender, lng)} :',
                                  style: Styles.black104,
                                  strutStyle: StrutStyle(height: 1.2),
                                ),
                                Text(
                                  '${Global.returnTrLable(labelControlls, CustomText.Creche_Name, lng)} :',
                                  style: Styles.black104,
                                  strutStyle: StrutStyle(height: 1.2),
                                ),
                                Text(
                                  '${Global.returnTrLable(labelControlls, CustomText.hhNameS, lng)} :',
                                  style: Styles.black104,
                                  strutStyle: StrutStyle(height: 1.2),
                                ),
                                Text(
                                  '${Global.returnTrLable(labelControlls, CustomText.DateofEnrollement, lng)} :',
                                  style: Styles.black104,
                                  strutStyle: StrutStyle(height: 1.2),
                                ),
                                Text(
                                  '${Global.returnTrLable(labelControlls, CustomText.Supervisor, lng)} :',
                                  style: Styles.black104,
                                  strutStyle: StrutStyle(height: 1.2),
                                ),
                              ],
                            ),
                            SizedBox(width: 10),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.15,
                              width: 2,
                              child: VerticalDivider(
                                color: Color(0xffE6E6E6),
                              ),
                            ),
                            SizedBox(width: 10),
                            enrolledItem != null
                                ? Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          Global.getItemValues(
                                              enrolledItem!.responces!,
                                              'child_id'),
                                          style: Styles.cardBlue10,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          Global.getItemValues(
                                              enrolledItem!.responces!,
                                              'child_name'),
                                          style: Styles.cardBlue10,
                                          overflow: TextOverflow.ellipsis,
                                          strutStyle: StrutStyle(height: 1.2),
                                        ),
                                        Text(
                                          // Global.getItemValues(
                                          //     enrolledItem!.responces!,
                                          //     'age_at_enrollment_in_months'),
                                          Global.validString(Global.getItemValues(
                                                  enrolledItem!.responces!,
                                                  'child_dob'))
                                              ? Validate()
                                                  .calculateAgeInMonths(Validate()
                                                      .stringToDate(
                                                          Global.getItemValues(
                                                              enrolledItem!
                                                                  .responces!,
                                                              'child_dob')))
                                                  .toString()
                                              : Global.getItemValues(
                                                  enrolledItem!.responces!,
                                                  'age_at_enrollment_in_months'),
                                          style: Styles.cardBlue10,
                                          overflow: TextOverflow.ellipsis,
                                          strutStyle: StrutStyle(height: 1.2),
                                        ),
                                        Text(
                                          gender,
                                          style: Styles.cardBlue10,
                                          strutStyle: StrutStyle(height: 1.2),
                                        ),
                                        Text(
                                          crechName,
                                          style: Styles.cardBlue10,
                                          strutStyle: StrutStyle(height: 1.2),
                                        ),
                                        Text(
                                          hhName,
                                          style: Styles.cardBlue10,
                                          overflow: TextOverflow.ellipsis,
                                          strutStyle: StrutStyle(height: 1.2),
                                        ),
                                        Text(
                                          Global.validString(Global.getItemValues(
                                                  enrolledItem!.responces!,
                                                  'date_of_enrollment'))
                                              ? Validate().displeDateFormate(
                                                  Global.getItemValues(
                                                      enrolledItem!.responces!,
                                                      'date_of_enrollment'))
                                              : '',
                                          style: Styles.cardBlue10,
                                          strutStyle: StrutStyle(height: 1.2),
                                        ),
                                        Text(
                                          supName,
                                          style: Styles.cardBlue10,
                                          overflow: TextOverflow.ellipsis,
                                          strutStyle: StrutStyle(height: 1.2),
                                        ),
                                      ],
                                    ),
                                  )
                                : SizedBox(),
                          ],
                        ),
                      ),
                    ),
                  ),
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
                        itemCount: image.length,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (ctx, i) {
                          return InkWell(
                            onTap: () async {
                              if (i == 0) {
                                await onclick(i, image[i]);
                              } else if (Global.validToInt(
                                      enrolledItem?.is_edited) !=
                                  2) {
                                await onclick(i, image[i]);
                              } else
                                Validate().singleButtonPopup(
                                    Global.returnTrLable(labelControlls,
                                        CustomText.childDarftMsg, lng),
                                    Global.returnTrLable(
                                        labelControlls, CustomText.ok, lng),
                                    false,
                                    context);
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
                                                  filterQuality:
                                                      FilterQuality.high,
                                                  scale: 0.7,
                                                  color: Color(0xff5979AA),
                                                ),
                                              )
                                            ],
                                          )),
                                      SizedBox(
                                        height: 15.h,
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 7),
                                        child: Text(
                                          text[i],
                                          style: Styles.listlablefont,
                                          textAlign: TextAlign.center,
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
          // bottomNavigationBar: BottomNavigationBar(
          //   useLegacyColorScheme: true,
          //   showUnselectedLabels: true,
          //   showSelectedLabels: true,
          //   selectedItemColor: Colors.black,
          //   unselectedItemColor: Color(0xffAAAAAA),
          //   selectedLabelStyle: Styles.Selectedbottambar,
          //   unselectedLabelStyle: Styles.unSelectedbottambar,
          //   unselectedIconTheme: IconThemeData(color: Colors.red),
          //   currentIndex: _currentIndex,
          //   onTap: (index) {
          //     setState(() {
          //       _currentIndex = index;
          //     });
          //   },
          //   items: initBottomBar(),
          // ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    iniData();
  }

  // bool checkEditable() {
  //   bool returnStatus = true;
  //   if (enrolledItem != null && Global.validString(enrolledItem!.created_at)) {
  //     var creation = DateTime.parse(enrolledItem!.created_at.toString());
  //     var datePart = DateTime(creation.year, creation.month, creation.day);
  //     var now = DateTime.now();
  //     var nowDatePart = DateTime(now.year, now.month, now.day);
  //     returnStatus = datePart.add(Duration(days: 15)).isAfter(nowDatePart);
  //   }
  //
  //   var applicableDate = Validate().stringToDate(date ?? "2024-12-31");
  //   var now = DateTime.parse(Validate().currentDate());
  //
  //   return now.isBefore(applicableDate) ? true : returnStatus;
  // }

  Future<void> onclick(int i, String imsgeItem) async {
    print("Role =======> $role");
    if (i == 0) {
      bool isEdit = await  Validate().checkEditable(enrolledItem!.created_at,Validate().callEditfromCnfig(backdatedConfigirationModel));

      String? minDate = await callDateOfExit(enrolledItem!.CHHGUID!);
      EnrolledExitChilrenTab.childName =
          Global.getItemValues(enrolledItem!.responces!, 'child_name');
      // EnrolledExitChilrenTab.childName = '';
      var refstatus = await Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => EnrolledExitChilrenTab(
              openingDate:Global.validToString(crecheOpeningDate),
              closingDate:Global.validToString(crecheClosingDate),
              isEditable: role == CustomText.crecheSupervisor ? isEdit : false,
              CHHGUID: widget.CHHGUID,
              HHGUID: Global.getItemValues(enrolledItem!.responces!, 'hhguid'),
              HHname: widget.HHname,
              EnrolledChilGUID: widget.EnrolledChilGUID,
              crecheId: widget.crechId,
              isNew: 1,
              childId:
                  '${Global.getItemValues(enrolledItem!.responces!, 'child_id')}',
              // childId: '',
              minDate: minDate,
              isImageUpdate: Global.validString(Global.getItemValues(
                  enrolledItem!.responces!, 'image_field')))));
      if (refstatus == CustomText.itemRefresh) {
        await iniData();
      }
    }
    else if (i == 1) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => CrecheEnrollChildEnrollSingleScreen(
              creche_id:
                  Global.getItemValues(enrolledItem!.responces, 'creche_id'),
              chilenrolledGUID: widget.EnrolledChilGUID,
              childId:
                  '${Global.getItemValues(enrolledItem!.responces!, 'child_id')}',
              childName:
                  '${Global.getItemValues(enrolledItem!.responces!, 'child_name')}')));
    }
    else if (i == 2) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => ChildGrowthListingScreenInChild(
            childEnrollment: widget.EnrolledChilGUID,
            creche_nameId: Global.stringToInt(
                Global.getItemValues(enrolledItem!.responces, 'creche_id')),
            childId:
                '${Global.getItemValues(enrolledItem!.responces!, 'child_id')}',
            gender:
                '${Global.getItemValues(enrolledItem!.responces!, 'gender_id')}',
            childName:
                '${Global.getItemValues(enrolledItem!.responces!, 'child_name')}'),
      ));
    }
    else if (i == 3) {
      if (role == CustomText.crecheSupervisor.trim()) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => ReffralTabScreen(
                childId:
                    '${Global.getItemValues(enrolledItem!.responces!, 'child_id')}',
                childName:
                    '${Global.getItemValues(enrolledItem!.responces!, 'child_name')}',
                tabTitle: Global.returnTrLable(
                    labelControlls, CustomText.childReferral, lng),
                enrolledChildGUID: widget.EnrolledChilGUID)));
      }
      // else if (role == CustomText.clusterCoordinator.trim()) {
      else {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext content) => ReferallCompletedListForCC(
                  isHomeScreen: false,
                  enrolledChildGUID: widget.EnrolledChilGUID,
                  title: Global.returnTrLable(
                      labelControlls, CustomText.childReferral, lng),
                )));
      }
    }
    else if (i == 4) {
      if (role == CustomText.crecheSupervisor.trim()) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => FollowUpTabScreenForChild(
                  childenrollguid: widget.EnrolledChilGUID,
                  tabTitle: Global.returnTrLable(
                      labelControlls, CustomText.FollowUps, lng),
                  childId:
                      '${Global.getItemValues(enrolledItem!.responces!, 'child_id')}',
                  childName:
                      '${Global.getItemValues(enrolledItem!.responces!, 'child_name')}',
                  creche_id: Global.stringToInt(Global.getItemValues(
                      enrolledItem!.responces, 'creche_id')),
                  childNameId: enrolledItem?.name,
                )));
      }
      // else if (role == CustomText.clusterCoordinator.trim()) {
      else {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => ChildFollowUpCompletedForChildCC(
                  tabTitle: Global.returnTrLable(
                      labelControlls, CustomText.FollowUps, lng),
                  childenrollguid: widget.EnrolledChilGUID,
                  creche_id: Global.stringToInt(Global.getItemValues(
                      enrolledItem!.responces, 'creche_id')),
                  childNameId: enrolledItem?.name,
                  childId:
                      '${Global.getItemValues(enrolledItem!.responces!, 'child_id')}',
                  childName:
                      '${Global.getItemValues(enrolledItem!.responces!, 'child_name')}',
                )));
      }
    }
    else if (i == 5) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => WeightforAgeBoysGirlsScreen(
                childenrollguid: widget.EnrolledChilGUID,
                crechId: widget.crechId,
                childId:
                    '${Global.getItemValues(enrolledItem!.responces!, 'child_id')}',
                childName:
                    '${Global.getItemValues(enrolledItem!.responces!, 'child_name')}',
                gender_id: Global.stringToInt(
                  Global.getItemValues(enrolledItem!.responces!, 'gender_id'),
                ),
                // date_of_birth:Global.stringToDate(Global.getItemValues(enrolledItem!.responces!, 'child_dob'))!
              )));
    }
    else if (i == 6) {
      var childImmuData = await ChildImmunizationResponseHelper()
          .childEventByChild(
              Global.getItemValues(enrolledItem!.responces, 'creche_id'),
              widget.EnrolledChilGUID);
      if (childImmuData.length > 0) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => ChildImmunizationDetailsTab(
                enName: widget.enName,
                chilenrolledGUID: widget.EnrolledChilGUID,
                child_immunization_guid:
                    childImmuData[0].child_immunization_guid,
                creche_id:
                    Global.getItemValues(enrolledItem!.responces, 'creche_id'),
                childName: Global.getItemValues(
                    enrolledItem!.responces!, 'child_name'),
                childHHID:
                    Global.getItemValues(enrolledItem!.responces!, 'child_id'),
                childDob:
                    Global.getItemValues(enrolledItem!.responces!, 'child_dob'),
                enrolledItem: enrolledItem,
                dateOfEnrolled: Global.getItemValues(
                    enrolledItem!.responces!, 'date_of_enrollment'))));
      } else {
        String chilimmuGuid = '';
        if (!(Global.validString(chilimmuGuid))) {
          chilimmuGuid = Validate().randomGuid();
        }
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => ChildImmunizationDetailsTab(
                enName: widget.enName,
                chilenrolledGUID: widget.EnrolledChilGUID,
                child_immunization_guid: chilimmuGuid,
                childName: Global.getItemValues(
                    enrolledItem!.responces!, 'child_name'),
                childHHID:
                    Global.getItemValues(enrolledItem!.responces!, 'child_id'),
                creche_id:
                    Global.getItemValues(enrolledItem!.responces, 'creche_id'),
                enrolledItem: enrolledItem,
                childDob:
                    Global.getItemValues(enrolledItem!.responces!, 'child_dob'),
                dateOfEnrolled: Global.getItemValues(
                    enrolledItem!.responces!, 'date_of_enrollment'))));
      }
    } else if (i == 7) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => ChildHealthListing(
                enName: widget.enName,
                chilenrolledGUID: widget.EnrolledChilGUID,
                creche_id:
                    Global.getItemValues(enrolledItem!.responces, 'creche_id'),
                dateofEnrollment: Global.getItemValues(
                    enrolledItem!.responces!, 'date_of_enrollment'),
                childId:
                    '${Global.getItemValues(enrolledItem!.responces!, 'child_id')}',
                childName:
                    '${Global.getItemValues(enrolledItem!.responces!, 'child_name')}',
              )));
    } else if (i == 8) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => ChildEventListingScreen(
                enName: widget.enName,
                chilenrolledGUID: widget.EnrolledChilGUID,
                dateOfEnrollment: Global.getItemValues(
                    enrolledItem!.responces!, 'date_of_enrollment'),
                creche_id:
                    Global.getItemValues(enrolledItem!.responces, 'creche_id'),
                childId:
                    '${Global.getItemValues(enrolledItem!.responces!, 'child_id')}',
                childName:
                    '${Global.getItemValues(enrolledItem!.responces!, 'child_name')}',
              )));
    }
  }

  iniData() async {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    var alredRecord = await EnrolledExitChilrenResponceHelper()
        .callChildrenResponce(widget.EnrolledChilGUID);
    var genderList =
        await OptionsModelHelper().getMstCommonOptions('Gender', lng);

    var lngtr = await Validate().readString(Validate.sLanguage);
    var creches = await CrecheDataHelper().getCrecheResponceItem(widget.crechId);
    if(creches.length>0){
      crecheOpeningDate=Global.getItemValues(creches.first.responces, 'creche_opening_date');
      crecheClosingDate=Global.getItemValues(creches.first.responces, 'creche_closing_date');
    }

    date = await Validate().readString(Validate.date);
    if (lngtr != null) {
      lng = lngtr;
    }
    if (alredRecord.length > 0) {
      enrolledItem = alredRecord[0];
      enName = enrolledItem!.name;
      //gender
      var gItem = genderList
          .where((element) =>
              element.name ==
              Global.getItemValues(enrolledItem!.responces!, 'gender_id'))
          .toList();
      if (gItem.length > 0) {
        gender = gItem[0].values!;
      }

      //HHName
      if (Global.validString(enrolledItem!.CHHGUID)) {
        var hhRe = await HouseHoldTabResponceHelper()
            .callHouHoldByChildGuid(enrolledItem!.CHHGUID!);
        if (hhRe.isNotEmpty) {
          var res = hhRe['responces'];
          hhName = Global.getItemValues(res, 'hosuehold_head_name');
          print('hhNamee $hhName');
        }
      }
      //creCheName
      var crechId = Global.getItemValues(enrolledItem!.responces!, 'creche_id');
      if (Global.validString(crechId)) {
        var items = await CrecheDataHelper()
            .getCrecheResponceItem(Global.stringToInt(crechId));
        if (items.length > 0) {
          crechName = Global.getItemValues(items[0].responces!, 'creche_name');

          //Supervisor
          if (Global.validString(
              Global.getItemValues(items[0].responces!, 'supervisor_id'))) {
            var suprs = await OptionsModelHelper().getPartnerMstCommonOptions(
                'User', jsonDecode(items[0].responces!));
            if (suprs.length > 0) {
              supName = suprs[0].values!;
            }
          }
        }
      }
    }
    backdatedConfigirationModel = await BackdatedConfigirationHelper().excuteBackdatedConfigirationModel(CustomText.enrollExitChild);
    await setLabelTextData();
    setState(() {});
  }

  Future<void> setLabelTextData() async {
    role = (await Validate().readString(Validate.role))!;
    List<String> valueNames = [
      CustomText.fllowUp,
      CustomText.FollowUps,
      CustomText.ChildDetails,
      CustomText.ChildId,
      CustomText.ChildName,
      CustomText.ageInMonth,
      CustomText.Gender,
      CustomText.Creche_Name,
      CustomText.hhHeadName,
      CustomText.DateofEnrollement,
      CustomText.Supervisor,
      CustomText.ChildProfile,
      CustomText.ChildHealthDetail,
      CustomText.ChildImmunizationDetails,
      CustomText.ChildEventDetail,
      CustomText.child_exit,
      CustomText.Grievance,
      CustomText.IssueSubmit,
      CustomText.creche_enrollement,
      CustomText.GrowthChart,
      CustomText.hhNameS,
      CustomText.anthropomertry,
      CustomText.childDarftMsg,
      ...text
    ];
    await TranslationDataHelper()
        .callTranslateString(valueNames)
        .then((value) => labelControlls.addAll(value));
    text = [
      Global.returnTrLable(labelControlls, CustomText.ChildProfile, lng),
      Global.returnTrLable(labelControlls, CustomText.creche_enrollement, lng),
      Global.returnTrLable(labelControlls, CustomText.anthropomertry, lng),
      Global.returnTrLable(labelControlls, CustomText.childReferral, lng),
      Global.returnTrLable(labelControlls, CustomText.FollowUps, lng),
      Global.returnTrLable(labelControlls, CustomText.GrowthChart, lng),
      Global.returnTrLable(
          labelControlls, CustomText.ChildImmunizationDetails, lng),
      Global.returnTrLable(labelControlls, CustomText.ChildHealthDetail, lng),
      Global.returnTrLable(labelControlls, CustomText.ChildEventDetail, lng),
    ];
  }

  Future<ChildReferralTabResponceModel?> childReffrealItems(
      String enrollGUID) async {
    ChildReferralTabResponceModel? itemRe = null;
    List<ChildReferralTabResponceModel> reffrals =
        await ChildReferralTabResponseHelper()
            .callReffralByGUID(widget.EnrolledChilGUID);
    Map<DateTime, String> datesListString = {};
    if (reffrals.isNotEmpty) {
      reffrals.forEach((element) {
        var date = Global.validString(
                Global.getItemValues(element.responces!, 'discharge_date'))
            ? Global.getItemValues(element.responces!, 'discharge_date')
            : Global.getItemValues(element.responces!, 'visit_date');
        if (Global.validString(date)) {
          List<int> dateParts = date.split('-').map(int.parse).toList();
          datesListString[DateTime(dateParts[0], dateParts[1], dateParts[2])] =
              element.child_referral_guid!;
        }
      });
      if (datesListString.isNotEmpty) {
        var lastDate = datesListString.keys.reduce(
            (value, element) => value.isAfter(element) ? value : element);
        var latestItem = datesListString[lastDate];
        var lastItem = reffrals
            .where((element) => element.child_referral_guid == latestItem)
            .toList();
        if (lastItem.length > 0) {
          itemRe = lastItem.first;
        }
      }
    }
    return itemRe;
  }

  Future<String?> callDateOfExit(String CHHGUID) async {
    String? maxDateOfExit=await EnrolledExitChilrenResponceHelper().maxDateOfExit(CHHGUID);
    if(Global.validToInt(backdatedConfigirationModel?.back_dated_data_entry_allowed)>0){
      return await Validate().callMinDate(maxDateOfExit, backdatedConfigirationModel!.back_dated_data_entry_allowed!);
    }else return null;

  }
}
