import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/screens/linelistedhouseholld.dart';
import 'package:shishughar/screens/tabed_screens/creshe/creshe_tab_screen.dart';

import '../custom_widget/custom_text.dart';
import '../database/helper/creche_helper/creche_data_helper.dart';
import '../database/helper/dynamic_screen_helper/options_model_helper.dart';
import '../database/helper/translation_language_helper.dart';
import '../model/apimodel/translation_language_api_model.dart';
import '../style/styles.dart';
import '../utils/globle_method.dart';
import '../utils/validate.dart';
import 'tabed_screens/check_in/check_ins.dart';
import 'shishu_ghar_details_replica_screen.dart';
import 'tabed_screens/child_gravience/child_grievances_listing_screen.dart';

class ShishuGharDetailsBottomBar extends StatefulWidget {
  final int crecheId;
  final String crecheName;
  final String crecheCode;
  bool isUpdateImage;
  int index;
  ShishuGharDetailsBottomBar(
      {super.key, required this.crecheId, required this.index,
        required this.crecheName, required this.crecheCode, required this.isUpdateImage});

  @override
  _ShishuGharDetailsBottomBarState createState() =>
      _ShishuGharDetailsBottomBarState();
}

class _ShishuGharDetailsBottomBarState
    extends State<ShishuGharDetailsBottomBar> {
  String? lng = 'en';
  List<Translation> locationControlls = [];
  List pages = [];

  @override
  void initState() {
    super.initState();
    initializeLabel();
  }

  @override
  Widget build(BuildContext context) {
    return (locationControlls.length > 0)
        ? Scaffold(
            body: pages[widget.index],
            bottomNavigationBar: BottomNavigationBar(
              useLegacyColorScheme: true,
              showUnselectedLabels: true,
              showSelectedLabels: true,
              selectedItemColor: Colors.black,
              unselectedItemColor: Color(0xffAAAAAA),
              selectedLabelStyle: Styles.Selectedbottambar,
              unselectedLabelStyle: Styles.unSelectedbottambar,
              unselectedIconTheme: IconThemeData(color: Colors.red),
              currentIndex: widget.index,
              onTap: (index) async {
                if(index!=2) {
                  onclick(index);
                  setState(() {
                    widget.index = index;
                  });
                }
              },
              items: initBottomTab(),
            ),
          )
        : SizedBox();
  }

  Future<void> initializeLabel() async {

    pages=[
      ShishuGharDetailsReplica(crecheId:widget.crecheId),
      ShishuGharDetailsReplica(crecheId:widget.crecheId),
      ShishuGharDetailsReplica(crecheId:widget.crecheId),
      ShishuGharDetailsReplica(crecheId:widget.crecheId),
      ShishuGharDetailsReplica(crecheId:widget.crecheId),
    ];



    lng = await Validate().readString(Validate.sLanguage);

    List<String> valueNames = [
      CustomText.checkIN,
      CustomText.enrolled_children,
      CustomText.Attendance,
      CustomText.checkIN,
      CustomText.Task,
      CustomText.ShishuGharDetails,
      CustomText.Home,
      CustomText.LineListedHouseholds,
      CustomText.Grievance,
      CustomText.ProfileS
    ];

    await TranslationDataHelper()
        .callTranslateString(valueNames)
        .then((value) => locationControlls = value);

    setState(() {});
  }

  List<BottomNavigationBarItem> initBottomTab() {
    List<BottomNavigationBarItem> bottomItem = [];
    bottomItem.add(BottomNavigationBarItem(
      icon: Padding(
        padding: EdgeInsets.only(bottom: 5.h),
        child: Image.asset(
          "assets/household.png",
          scale: 4.5,
          color: widget.index == 0 ? Color(0xff5979AA) : Color(0xffAAAAAA),
        ),
      ),
      label: Global.returnTrLable(
          locationControlls, CustomText.LineListedHouseholds, lng!),
    ));
    bottomItem.add(BottomNavigationBarItem(
      icon: Padding(
        padding: EdgeInsets.only(bottom: 5.h),
        child: Image.asset(
          "assets/creche_profile/creche_profile.png",
          scale: 2.0,
          color: widget.index == 1 ? Color(0xff5979AA) : Color(0xffAAAAAA),
        ),
      ),
      label: Global.returnTrLable(
          locationControlls, CustomText.ProfileS, lng!),
    ));
    bottomItem.add(BottomNavigationBarItem(
      icon: Padding(
        padding: EdgeInsets.only(bottom: 5.h),
        child: Image.asset(
          "assets/home.png",
          scale: 2.2,
          color: widget.index == 2 ? Color(0xff5979AA) : Color(0xffAAAAAA),
        ),
      ),
      label: Global.returnTrLable(locationControlls, CustomText.Home, lng!),
    ));
    // bottomItem.add(BottomNavigationBarItem(
    //   icon: Padding(
    //     padding: EdgeInsets.only(bottom: 5.h),
    //     child: Image.asset(
    //       "assets/creche_profile/attendance.png",
    //       scale: widget.index == 2 ? 1.5 : 2.7,
    //       color: widget.index == 2 ? Color(0xff5979AA) : Color(0xffAAAAAA),
    //     ),
    //   ),
    //   label:
    //       Global.returnTrLable(locationControlls, CustomText.Attendance, lng!),
    // ));
    bottomItem.add(BottomNavigationBarItem(
      icon: Padding(
        padding: EdgeInsets.only(bottom: 5.h),
        child: Image.asset(
          "assets/creche_profile/checkIn.png",
          scale: 1.3,
          color: widget.index == 3 ? Color(0xff5979AA) : Color(0xffAAAAAA),
        ),
      ),
      label: Global.returnTrLable(locationControlls, CustomText.checkIN, lng!),
    ));
    bottomItem.add(BottomNavigationBarItem(
      icon: Padding(
        padding: EdgeInsets.only(bottom: 5.h),
        child: Image.asset(
          "assets/grievance.png",
          scale: 6.5,
          color: widget.index == 4 ? Color(0xff5979AA) : Color(0xffAAAAAA),
        ),
      ),
      label:
          Global.returnTrLable(locationControlls, CustomText.Grievance, lng!),
    ));
    return bottomItem;
  }

  Future<void> onclick(int i) async {
    String refreshStatus='';
    if (i == 0) {
       refreshStatus=await Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => LineholdlistedScreen(crecheId: widget.crecheId,)));
    } else if (i == 1) {
      refreshStatus=await  Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) =>
              CresheTabScreen(
                  name: widget.crecheId,
                  crechedCode: widget.crecheCode
                  ,isUpdate: widget.isUpdateImage
              )));
    } else if (i == 2) {
      // Navigator.of(context).push(MaterialPageRoute(
      //     builder: (BuildContext context) => ShishuGharDetailsBottomBar(
      //           nameId: widget.nameId,
      //           index: 2,
      //         )));
    } else if (i == 3) {
      refreshStatus=await Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context) => CheckIns(crechId:widget.crecheId)));
    } else if (i == 4) {
      refreshStatus=await  Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => ChildGrievancesListing(
                creche_id: widget.crecheId.toString(),
                crecheName: widget.crecheName,
              )));
    } else if (i == 5) {

    }

    if (refreshStatus == 'itemRefresh') {
      setState(() {
        widget.index = 2;
      });
    }
  }
}
