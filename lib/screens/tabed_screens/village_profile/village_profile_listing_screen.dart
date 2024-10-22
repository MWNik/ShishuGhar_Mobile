import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/custom_widget/custom_appbar.dart';
import 'package:shishughar/custom_widget/custom_string_dropdown.dart';
import 'package:shishughar/custom_widget/custom_textfield.dart';
import 'package:shishughar/custom_widget/dynamic_screen_widget/custom_animated_rolling_switch.dart';
import 'package:shishughar/database/helper/village_profile/village_profile_response_helper.dart';
import 'package:shishughar/model/dynamic_screen_model/village_profile_response_model.dart';
import 'package:shishughar/screens/tabed_screens/village_profile/village_profile_tab_screen.dart';

import '../../../custom_widget/custom_text.dart';
import '../../../database/helper/district_data_helper.dart';
import '../../../database/helper/translation_language_helper.dart';
import '../../../database/helper/village_data_helper.dart';
import '../../../model/apimodel/translation_language_api_model.dart';
import '../../../model/databasemodel/tabDistrict_model.dart';
import '../../../style/styles.dart';
import '../../../utils/globle_method.dart';
import '../../../utils/validate.dart';

class VillageProfileListingScreen extends StatefulWidget {
  VillageProfileListingScreen({super.key});

  @override
  State<VillageProfileListingScreen> createState() =>
      _VillageProfileListingState();
}

class _VillageProfileListingState extends State<VillageProfileListingScreen> {
  TextEditingController Searchcontroller = TextEditingController();
  List<Translation> translatsLabel = [];
  List<VillageProfileResponseModel> villageProfileList = [];
  List<VillageProfileResponseModel> filteredList = [];
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isOnlyUnsynched = false;
  List<VillageProfileResponseModel> unsynchedList = [];
  List<VillageProfileResponseModel> allList = [];
  String? selectedVillage;
  String lng = 'en';
  String role = '';

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    var lngtr = await Validate().readString(Validate.sLanguage);
    role = (await Validate().readString(Validate.role))!;

    if (lngtr != null) {
      lng = lngtr;
    }
    List<String> valueItems = [
      CustomText.Search,
      CustomText.Creches_,
      CustomText.CrecheId,
      CustomText.Creche_Name,
      CustomText.state,
      CustomText.District,
      CustomText.Block,
      CustomText.GramPanchayat,
      CustomText.Village,
      CustomText.Generalfilter,
      CustomText.Locationfilter,
      CustomText.plSelect_state,
      CustomText.plSelect_district,
      CustomText.plSelect_block,
      CustomText.plSelect_geamPanchayat,
      CustomText.plSelect_village,
      CustomText.NorecordAvailable,
      CustomText.pleaseWait,
      CustomText.villageCode,
      CustomText.villageName,
      CustomText.ok,
      CustomText.all,
      CustomText.unsynched
    ];
    // await fetchStateList();
    await TranslationDataHelper()
        .callTranslateString(valueItems)
        .then((value) => translatsLabel = value);
    await fetchVillageProfileRecords();
    setState(() {});
  }

  Future<void> fetchVillageProfileRecords() async {
    villageProfileList =
        await VillageProfileResponseHelper().getAllVillageProfilerecords();
    unsynchedList =
        villageProfileList.where((element) => element.is_edited == 1).toList();
    allList = villageProfileList;
    filteredList = isOnlyUnsynched ? unsynchedList : allList;
    setState(() {});
  }

  filterDataQu(String entry) {
    var filterList = isOnlyUnsynched ? unsynchedList : allList;
    if (entry.length > 0) {
      filteredList = filterList
          .where((element) => element.village_name
              .toString()
              .toLowerCase()
              .startsWith(entry.toLowerCase()))
          .toList();
    } else
      filteredList = filterList;
    setState(() {});
    print('dd ${filteredList.length}');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, 'itemRefersh');
        return false;
      },
      child: Scaffold(
        appBar: CustomAppbar(
          text:
              Global.returnTrLable(translatsLabel, CustomText.villageList, lng),
          onTap: () {
            Navigator.pop(context, 'itemRefresh');
          },
        ),
        body: Padding(
          padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 10.h),
          child: Column(children: [
            // SizedBox(
            //   height: MediaQuery.of(context).size.height * 0.09,
            // ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 2),
              child: Row(
                children: [
                  Expanded(
                    child: CustomTextFieldRow(
                      controller: Searchcontroller,
                      onChanged: (value) {
                        print(value);
                        filterDataQu(value);
                      },
                      hintText: (lng != null)
                          ? Global.returnTrLable(translatsLabel, 'Search', lng!)
                          : '',
                      prefixIcon: Image.asset(
                        "assets/search.png",
                        scale: 2.4,
                      ),
                    ),
                  ),
                  role == CustomText.crecheSupervisor
                      ? AnimatedRollingSwitch(
                          title1: Global.returnTrLable(
                              translatsLabel, CustomText.all, lng),
                          title2: Global.returnTrLable(
                              translatsLabel, CustomText.unsynched, lng),
                          isOnlyUnsynched: isOnlyUnsynched ?? false,
                          onChange: (value) async {
                            setState(() {
                              isOnlyUnsynched = value;
                            });
                            await fetchVillageProfileRecords();
                          },
                        )
                      : SizedBox(),
                ],
              ),
            ),

            (filteredList.isNotEmpty)
                ? Expanded(
                    child: ListView.builder(
                      itemCount: filteredList.length,
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () async {
                            var refStatus = await Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        VillageProfileTabScreen(
                                            name: filteredList[index].name!,
                                            isEditable: role ==
                                                CustomText.crecheSupervisor
                                                    .trim())));
                            if (refStatus == 'itemRefresh') {
                              await fetchVillageProfileRecords();
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
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${Global.returnTrLable(translatsLabel, CustomText.villageCode, lng).trim()} :',
                                          style: Styles.black104,
                                        ),
                                        Text(
                                          '${Global.returnTrLable(translatsLabel, CustomText.villageName, lng).trim()} :',
                                          style: Styles.black104,
                                          strutStyle: StrutStyle(height: 1.2),
                                        ),
                                        // Text(
                                        //   Global.returnTrLable(translatsLabel,
                                        //           CustomText.Village, lng)
                                        //       .trim(),
                                        //   style: Styles.black104,
                                        //   strutStyle: StrutStyle(height: 1.3),
                                        // ),
                                      ],
                                    ),
                                    SizedBox(width: 10),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.06,
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
                                              filteredList[index]
                                                      .village_code ??
                                                  '',
                                              style: Styles.cardBlue10,
                                              overflow: TextOverflow.ellipsis),
                                          Text(
                                              filteredList[index]
                                                      .village_name ??
                                                  '',
                                              style: Styles.cardBlue10,
                                              strutStyle:
                                                  StrutStyle(height: 1.2),
                                              overflow: TextOverflow.ellipsis),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    (filteredList[index].is_edited == 0 &&
                                            filteredList[index].is_uploaded ==
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
                      },
                    ),
                  )
                : Expanded(
                    child: Center(
                        child: Text(Global.returnTrLable(translatsLabel,
                            CustomText.NorecordAvailable, lng)))),
            SizedBox(
              height: 10.h,
            ),
          ]),
        ),
      ),
    );
  }
}
