import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/custom_widget/custom_appbar.dart';
import 'package:shishughar/screens/tabed_screens/child_gravience/graviences_tabs_screen.dart';
import 'package:shishughar/utils/validate.dart';

import '../../../custom_widget/custom_btn.dart';
import '../../../custom_widget/custom_text.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_custom_dropdown.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_custom_dropdown_for_filter.dart';
import '../../../database/helper/child_gravience/child_grievances_response_helper.dart';
import '../../../database/helper/dynamic_screen_helper/options_model_helper.dart';
import '../../../database/helper/translation_language_helper.dart';
import '../../../model/apimodel/translation_language_api_model.dart';
import '../../../model/dynamic_screen_model/child_grievances_response_model.dart';
import '../../../model/dynamic_screen_model/options_model.dart';
import '../../../style/styles.dart';
import '../../../utils/globle_method.dart';
import 'greviences_home_detail.screen.dart';


class GrievanceHomeListing extends StatefulWidget {

  const GrievanceHomeListing({
    super.key,
  });

  @override
  State<GrievanceHomeListing> createState() => _GrievanceHomeListingState();
}

class _GrievanceHomeListingState extends State<GrievanceHomeListing> {
  List<ChildGrievancesResponceModel> childGirevData = [];
  List<ChildGrievancesResponceModel> filtredGirevData = [];
  List<Translation> translats = [];
  String lng = 'en';
  List<OptionsModel> grSubjects = [];
  List<OptionsModel> grStatus = [];
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? selectedStatus;
  String? selectedCreche;
  List<OptionsModel> creches = [];

  void initState() {
    super.initState();
    initializeData();
  }

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
      CustomText.GrievanceCategory,
      CustomText.Status,
      CustomText.Description
    ];

    creches = await OptionsModelHelper().callCrechInOptionAll('Creche');
    await callmstCommons();
    await TranslationDataHelper()
        .callTranslateString(valueItems)
        .then((value) => translats.addAll(value));
    fetchChildgrievance();
    setState(() {});
  }

  Future<void> fetchChildgrievance() async {
    childGirevData =
        await ChildGrievancesTabResponceHelper().getAllChildGrievance();
    filtredGirevData = childGirevData;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: InkWell(
        onTap: () async {
          String child_grievances_guid = '';
          if (!(Global.validString(child_grievances_guid))) {
            child_grievances_guid = Validate().randomGuid();
            var refStatus = await Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => GrieviencesHomeDetailScreen(
                      child_grievances_guid: child_grievances_guid,
                    isNew:true
                    )));
            if (refStatus == 'itemRefresh') {
              fetchChildgrievance();
            }
          }
        },
        child: Image.asset(
          "assets/add_btn.png",
          scale: 2.7,
          color: Color(0xff5979AA),
        ),
      ),
      appBar: CustomAppbar(
        text: Global.returnTrLable(translats, CustomText.ChildGrievances, lng),
        // subTitle: widget.crecheName,
        onTap: () => Navigator.pop(context, 'itemRefresh'),
      ),
      endDrawer: SafeArea(
        child: Drawer(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 30),
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/filter_icon.png",
                            scale: 2.4,
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Text(
                            CustomText.Filter,
                            style: Styles.labelcontrollerfont,
                          ),
                          Spacer(),
                          InkWell(
                              onTap: () async {
                                _scaffoldKey.currentState!.closeEndDrawer();
                                // cleaAllFilter();
                              },
                              child: Image.asset(
                                'assets/cross.png',
                                color: Colors.grey,
                                scale: 4,
                              )),
                        ],
                      ),
                    ),
                    SizedBox(),
                    DynamicCustomDropdownField(
                      hintText: Global.returnTrLable(
                          translats, CustomText.Status, lng),
                      items: grStatus,
                      selectedItem: selectedStatus,
                      onChanged: (value) {
                        selectedStatus = value?.name;
                      },
                    ),
                    DynamicCustomDropdownForFilterField(
                      hintText: Global.returnTrLable(
                          translats, CustomText.Creches, lng),
                      items: creches,
                      selectedItem: selectedCreche,
                      onChanged: (value) {
                        selectedCreche = value?.name;
                      },
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Padding(
                      padding: EdgeInsets.all(3.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: CElevatedButton(
                              text: Global.returnTrLable(
                                  translats, 'Clear', lng!),
                              color: Color(0xffF26BA3),
                              onPressed: () {
                                Navigator.of(context).pop();
                                clearData();
                              },
                            ),
                          ),
                          // Spacer(),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: CElevatedButton(
                              text: Global.returnTrLable(
                                  translats, 'Search', lng!),
                              onPressed: () {
                                Navigator.of(context).pop();
                                filteredGetData(context);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
            )),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(children: [
          Row(
            children: [
              Expanded(
                child: SizedBox(),
              ),
              SizedBox(
                width: 10.w,
              ),
              GestureDetector(
                onTap: () {
                  _scaffoldKey.currentState!.openEndDrawer();
                },
                child: Image.asset(
                  "assets/filter_icon.png",
                  scale: 2.4,
                ),
              )
            ],
          ),
          Expanded(
            child: (filtredGirevData.length > 0)
                ? ListView.builder(
                    itemCount: filtredGirevData.length,
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () async {
                          var refStatus = await Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      GrieviencesHomeDetailScreen(
                                        child_grievances_guid:
                                            filtredGirevData[index]
                                                .grievance_guid!,
                                          isNew:false
                                      )));
                          if (refStatus == 'itemRefresh') {
                            await fetchChildgrievance();
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
                                        '${Global.returnTrLable(translats, CustomText.GrievanceCategory, lng).trim()} : ',
                                        style: Styles.black104,
                                      ),
                                      Text(
                                        '${Global.returnTrLable(translats, CustomText.Description, lng).trim()} : ',
                                        style: Styles.black104,
                                        strutStyle: StrutStyle(height: 1),
                                      ),
                                      Text(
                                        '${Global.returnTrLable(translats, CustomText.Status, lng).trim()} : ',
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
                                          callGravienceSubject(
                                              Global.getItemValues(
                                                  filtredGirevData[index]
                                                      .responces!,
                                                  'title')),
                                          style: Styles.blue125,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          Global.getItemValues(
                                              filtredGirevData[index]
                                                  .responces!,
                                              'description'),
                                          style: Styles.blue125,
                                          maxLines: 1,
                                          strutStyle: StrutStyle(height: .5),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          callGravienceStatus(
                                              Global.getItemValues(
                                                  filtredGirevData[index]
                                                      .responces!,
                                                  'status')),
                                          style: Styles.blue125,
                                          strutStyle: StrutStyle(height: .5),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  (filtredGirevData[index].is_edited==0 && filtredGirevData[index].is_uploaded==1)?
                                  Image.asset(
                                    "assets/sync.png",
                                    scale: 1.5,
                                  ):
                                  Image.asset(
                                    "assets/sync_gray.png",
                                    scale: 1.5,
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
    );
  }

  String callGravienceStatus(String id) {
    String returnValue = "Open";

    if (Global.validString(id)) {
      var items = grStatus.where((element) => element.name == id).toList();
      if (items.length > 0) {
        returnValue = items[0].values!;
      }
    }

    return returnValue;
  }

  String callGravienceSubject(String id) {
    String returnValue = "";

    if (Global.validString(id)) {
      var items = grSubjects.where((element) => element.name == id).toList();
      if (items.length > 0) {
        returnValue = items[0].values!;
      }
    }

    return returnValue;
  }

  Future callmstCommons() async {
    grSubjects = await OptionsModelHelper()
        .callDayOfWeekMstCommonOptions('Grievance Subject',lng);
    grStatus = await OptionsModelHelper()
        .callDayOfWeekMstCommonOptions('Grievance Status',lng);
  }

  void clearData() {
    filtredGirevData = childGirevData;
    selectedCreche = null;
    selectedStatus = null;
    setState(() {});
  }

  void filteredGetData(BuildContext context) {
    if (selectedStatus != null && selectedCreche != null) {
      filtredGirevData = childGirevData
          .where((element) =>
              Global.getItemValues(element.responces, 'status') ==
                  selectedStatus &&
              element.creche_id == Global.stringToInt(selectedCreche))
          .toList();
    }
    if (selectedCreche != null && selectedStatus == null) {
      filtredGirevData = childGirevData
          .where((element) =>
              element.creche_id == Global.stringToInt(selectedCreche))
          .toList();
    }
    if (selectedCreche == null && selectedStatus != null) {
      filtredGirevData = childGirevData
          .where((element) =>
              Global.getItemValues(element.responces, 'status') ==
              selectedStatus)
          .toList();
    }
    setState(() {});
  }
}
