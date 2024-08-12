import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/custom_widget/custom_btn.dart';
import 'package:shishughar/custom_widget/custom_textfield.dart';
import 'package:shishughar/custom_widget/dynamic_screen_widget/dynamic_custom_dropdown_for_filter.dart';
import 'package:shishughar/database/helper/dynamic_screen_helper/options_model_helper.dart';
import 'package:shishughar/model/dynamic_screen_model/options_model.dart';
import 'package:shishughar/utils/globle_method.dart';

import '../../../custom_widget/custom_text.dart';
import '../../../database/helper/creche_helper/creche_data_helper.dart';
import '../../../database/helper/follow_up/child_followUp_response_helper.dart';
import '../../../database/helper/translation_language_helper.dart';
import '../../../model/apimodel/creche_database_responce_model.dart';
import '../../../model/apimodel/translation_language_api_model.dart';
import '../../../style/styles.dart';
import '../../../utils/validate.dart';
import 'child_followUp_tab_screen.dart';

class CompletedChildFollowUpsAllListingScreen extends StatefulWidget {

  final String tabTitle;



  const CompletedChildFollowUpsAllListingScreen(
      {super.key,
        required this.tabTitle,
      });

  @override
  State<CompletedChildFollowUpsAllListingScreen> createState() =>
      _ChildFollowUpsListingScreenState();
}

class _ChildFollowUpsListingScreenState
    extends State<CompletedChildFollowUpsAllListingScreen> {
  List<Map<String, dynamic>> followUpsList = [];
  List<Map<String, dynamic>> filteredFollowUp = [];

  List<Translation> translats = [];
  String lng = 'en';
  List<CresheDatabaseResponceModel> crecheData = [];
  String? selectedCreche;

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<OptionsModel> creches = [];
  TextEditingController Searchcontroller = TextEditingController();

  @override
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
      CustomText.Creches
    ];

    await TranslationDataHelper()
        .callTranslateString(valueItems)
        .then((value) => translats.addAll(value));

    await fetchFollowUpList();
  }

  Future<void> fetchFollowUpList() async {

    followUpsList = await ChildFollowUpTabResponseHelper()
        .callCompletedFolllwupsAllChild();
    filteredFollowUp = followUpsList;
    crecheData = await CrecheDataHelper().getCrecheResponce();
    creches =
    await OptionsModelHelper().callCrechInOptionAll('Creche');
    setState(() {

    });
    print(followUpsList);
  }
  void cleaAllFilter() {
    filteredFollowUp  = followUpsList;
    selectedCreche = null;

    setState((){});
  }
  filteredGetData(
      BuildContext mContext,
      ) async {
    if (selectedCreche != null) {
      filteredFollowUp = followUpsList.where((item) {
        var creche_id = Global.getItemValues(item['enrResponces']!, 'creche_id');
        return creche_id.toString() == selectedCreche.toString();
      }).toList();

      setState((){});
    }

  }

  filterDataQu(String entry) {
    if (entry.length > 0) {
      filteredFollowUp = followUpsList
          .where((element) =>
          (Global.getItemValues(element['enrResponces'],'child_name'))
              .toLowerCase()
              .startsWith(entry.toLowerCase()) )
          .toList();
    } else {
      filteredFollowUp = followUpsList;
    }
    setState(() {});
    print('cLength: ${filteredFollowUp.length}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: CustomChildAppbar(
      //   text: Global.returnTrLable(translats, CustomText.FollowUps, lng),
      //   subTitle1: widget.childName,
      //   subTitle2: widget.childId,
      //   onTap: () => Navigator.pop(context, 'itemRefresh'),
      // ),
      key: _scaffoldKey,
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
                                  translats, CustomText.clear, lng),
                              color: Color(0xffF26BA3),
                              onPressed: () {
                                Navigator.of(context).pop();
                                cleaAllFilter();
                              },
                            ),
                          ),
                          // Spacer(),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: CElevatedButton(
                              text: Global.returnTrLable(
                                  translats, CustomText.Search, lng),
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
        padding: EdgeInsets.symmetric(horizontal: 21.w, vertical: 10.h),
        child: Column(children: [
          Row(
            children: [
              Expanded(
                child: CustomTextFieldRow(
                  controller: Searchcontroller,
                  onChanged: (value) {
                    print(value);
                    filterDataQu(value);
                  },
                  hintText: Global.returnTrLable(
                      translats, CustomText.Search, lng),
                  prefixIcon: Image.asset(
                    "assets/search.png",
                    scale: 2.4,
                  ),
                ),),
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
            child: (filteredFollowUp.length > 0)
                ? ListView.builder(
                itemCount: filteredFollowUp.length,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () async {
                      var child_followup_guid =
                      filteredFollowUp[index]['child_followup_guid'];

                      var currentDate =
                      DateTime.parse(Validate().currentDate());
                      bool isEditable = currentDate.isBefore(DateTime.parse(
                          filteredFollowUp[index]['created_at']
                              .toString())
                          .add(Duration(days: 7)));
                      var dateString = filteredFollowUp[index]
                      ['schedule_date']!;
                      var parts = dateString.toString().split('-').map(int.parse).toList();
                      var date = DateTime(parts[0], parts[1], parts[2]);
                      var backDate = DateTime.parse(Validate().currentDate()).subtract(Duration(days: 7));
                      var backDateSD = date.subtract(Duration(days: 7));
                      if (Global.validString(child_followup_guid)) {
                        var refStatus = await Navigator.of(context)
                            .push(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                ChildFollowUpTabScreen(
                                  tabTitle: widget.tabTitle,
                                  child_referral_guid: filteredFollowUp[index]['child_referral_guid'],
                                  discharge_date: Global.getItemValues(filteredFollowUp[index]['responces'],'discharge_date'),
                                  followup_visit_date: filteredFollowUp[index]['followup_visit_date'],
                                  schedule_date: filteredFollowUp[index]['schedule_date'],
                                  enrollChildGuid:  Global.getItemValues(filteredFollowUp[index]['enrResponces'], 'childenrollguid'),
                                  creche_id: Global.stringToInt(Global.getItemValues(filteredFollowUp[index]['enrResponces'], 'creche_id')),
                                  child_id: Global.stringToInt(
                                      Global.getItemValues(filteredFollowUp[index]['enrResponces'], 'name')),
                                  child_followup_guid: child_followup_guid!,
                                  childId:Global.getItemValues(filteredFollowUp[index]['enrResponces'], 'child_id'),
                                  childName:Global.getItemValues(filteredFollowUp[index]['enrResponces'], 'child_name'),
                                  minDate: backDate.isBefore(backDateSD)?backDateSD:backDate,
                                  isEditable: isEditable,
                                )));

                        if (refStatus == 'itemRefresh') {
                          await fetchFollowUpList();
                        }
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
                            border:
                            Border.all(color: Color(0xffE7F0FF)),
                            borderRadius:
                            BorderRadius.circular(10.r)),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 8.h),
                          child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                  MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${Global.returnTrLable(translats, CustomText.ChildName, lng).trim()} : ',
                                      style: Styles.black104,
                                    ),
                                    Text(
                                      '${Global.returnTrLable(translats, CustomText.ChildId, lng).trim()} : ',
                                      style: Styles.black104,
                                    ),
                                    Text(
                                      '${Global.returnTrLable(translats, CustomText.Creches, lng).trim()} : ',
                                      style: Styles.black104,
                                    ),
                                    Text(
                                      '${Global.returnTrLable(translats, CustomText.schduleDate, lng).trim()} : ',
                                      style: Styles.black104,
                                    ),
                                    Text(
                                      '${Global.returnTrLable(translats, CustomText.followup_visit_date, lng).trim()} : ',
                                      style: Styles.black104,
                                    ),
                                    Text(
                                      '${Global.returnTrLable(translats, CustomText.weight, lng).trim()} : ',
                                      style: Styles.black104,
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
                                        Global.getItemValues(filteredFollowUp[index]['enrResponces'], 'child_name'),
                                        style: Styles.blue125,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        Global.getItemValues(filteredFollowUp[index]['enrResponces'], 'child_id'),
                                        style: Styles.blue125,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        callCrecheNameName(
                                            Global.getItemValues(
                                                filteredFollowUp[index]['enrResponces'],
                                                'creche_id')),
                                        style: Styles.blue125,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        Validate().displeDateFormate(
                                            filteredFollowUp[index]
                                            ['schedule_date']!),
                                        style: Styles.blue125,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        Validate().displeDateFormate(
                                            Global.getItemValues(
                                                filteredFollowUp[index]['responces'],
                                                'followup_visit_date')),
                                        style: Styles.blue125,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        Global.getItemValues(
                                            filteredFollowUp[index]['responces'],
                                            'weight'),
                                        style: Styles.blue125,
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
                              ]),
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


  String  calldateOfRefferl(String? responce){
    String date='';
    if(responce!=null){
      var itemDate=Global.getItemValues(responce,'followup_visit_date');
      if(Global.validString(itemDate)){
        date=Validate().displeDateFormate(itemDate);
      }
    }
    return date;
  }

  String callCrecheNameName(String nameId) {
    String returnValue = '';
    var items = crecheData
        .where((element) => element.name == Global.stringToInt(nameId))
        .toList();
    if (items.length > 0) {
      returnValue = Global.getItemValues(items[0].responces!, 'creche_name');
    }
    return returnValue;
  }
}
