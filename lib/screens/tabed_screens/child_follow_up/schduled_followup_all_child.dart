import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shishughar/custom_widget/custom_btn.dart';
import 'package:shishughar/custom_widget/custom_textfield.dart';
import 'package:shishughar/custom_widget/dynamic_screen_widget/dynamic_custom_dropdown_for_filter.dart';
import 'package:shishughar/database/helper/dynamic_screen_helper/options_model_helper.dart';
import 'package:shishughar/utils/globle_method.dart';

import '../../../custom_widget/custom_text.dart';
import '../../../database/helper/backdated_configiration_helper.dart';
import '../../../database/helper/creche_helper/creche_data_helper.dart';
import '../../../database/helper/follow_up/child_followUp_response_helper.dart';
import '../../../database/helper/translation_language_helper.dart';
import '../../../model/apimodel/creche_database_responce_model.dart';
import '../../../model/apimodel/translation_language_api_model.dart';
import '../../../model/databasemodel/backdated_configiration_model.dart';
import '../../../model/dynamic_screen_model/options_model.dart';
import '../../../style/styles.dart';
import '../../../utils/validate.dart';
import 'child_followUp_tab_screen.dart';

class SchudleFollowUpsAllListingScreen extends StatefulWidget {
  final String tabTitle;

  const SchudleFollowUpsAllListingScreen({
    super.key,
    required this.tabTitle,
  });

  @override
  State<SchudleFollowUpsAllListingScreen> createState() =>
      _ChildFollowUpsListingScreenState();
}

class _ChildFollowUpsListingScreenState
    extends State<SchudleFollowUpsAllListingScreen> {
  List<Map<String, dynamic>> followUpsList = [];
  List<Map<String, dynamic>> filteredFollowUp = [];
  List<Translation> translats = [];
  String lng = 'en';
  String? selectedCreche;
  final TextEditingController _controller = TextEditingController();
  List<CresheDatabaseResponceModel> crecheData = [];
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<OptionsModel> creches = [];
  TextEditingController Searchcontroller = TextEditingController();
  DateTime applicableDate = Validate().stringToDate('2024-12-31');
  var now = DateTime.parse(Validate().currentDate());
  BackdatedConfigirationModel? backdatedConfigirationModel;

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
    var date = await Validate().readString(Validate.date);
    applicableDate = Validate().stringToDate(date ?? "2024-12-31");
    backdatedConfigirationModel = await BackdatedConfigirationHelper()
        .excuteBackdatedConfigirationModel(CustomText.childFollowUp);
    List<String> valueItems = [
      CustomText.Enrolled,
      CustomText.ChildName,
      CustomText.RelationshipChild,
      CustomText.ageInMonth,
      CustomText.hhNameS,
      CustomText.NorecordAvailable,
      CustomText.Search,
      CustomText.Village,
      CustomText.height,
      CustomText.weight,
      CustomText.schduleDate,
      CustomText.Filter,
      CustomText.clear,
      CustomText.Creches,
      CustomText.ChildId
    ];

    await TranslationDataHelper()
        .callTranslateString(valueItems)
        .then((value) => translats.addAll(value));
    crecheData = await CrecheDataHelper().getCrecheResponce();
    creches = await OptionsModelHelper().callCrechInOptionAll('Creche');
    await callFolloupData();
  }

  void cleaAllFilter() {
    filteredFollowUp = followUpsList;
    selectedCreche = null;
    _controller.text = '';
    setState(() {});
  }

  filteredGetData(
    BuildContext mContext,
  ) async {
    if (selectedCreche != null) {
      filteredFollowUp = followUpsList.where((item) {
        var creche_id =
            Global.getItemValues(item['enrResponces']!, 'creche_id');
        return creche_id.toString() == selectedCreche.toString();
      }).toList();

      setState(() {});
    }
  }

  filterDataQu(String entry) {
    if (entry.length > 0) {
      filteredFollowUp = followUpsList
          .where((element) =>
              (Global.getItemValues(element['enrResponces'], 'child_name'))
                  .toLowerCase()
                  .startsWith(entry.toLowerCase()))
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
                            Global.returnTrLable(
                                translats, CustomText.Filter, lng),
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
                    creches.length<=1?DynamicCustomDropdownForFilterField(
                      hintText: Global.returnTrLable(
                          translats, CustomText.Creches, lng),
                      items: creches,
                      selectedItem: selectedCreche,
                      onChanged: (value) {
                        selectedCreche = value?.name;
                      },
                    ):
                    Container(
                      height: 35.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            color: Color(0xffACACAC)),
                        borderRadius: BorderRadius.circular(
                            10.r),
                      ),
                      child: TypeAheadField<OptionsModel>(
                        controller: _controller,
                        suggestionsCallback: (pattern) async {
                          try {
                            var filItems= creches.where((
                                element) =>
                            element.values != null &&
                                element.name != null &&
                                element.values!
                                    .toLowerCase()
                                    .contains(
                                    pattern.toLowerCase())||
                                element.name!
                                    .toLowerCase()
                                    .contains(
                                    pattern.toLowerCase())
                            ).toList();
                            if(filItems.isEmpty||pattern.isEmpty){
                              selectedCreche=null;
                              _controller.text='';
                            }
                            return filItems;
                          } catch (e) {
                            debugPrint('TypeAhead error: $e');
                            return [];
                          }
                        },
                        builder: (context, controller,
                            focusNode) {
                          return TextField(
                              controller: controller,
                              focusNode: focusNode,
                              style:  Styles.black124,
                              // autofocus: true,
                              decoration: InputDecoration(
                                hintText: Global.returnTrLable(
                                    translats, CustomText.creche, lng),
                                contentPadding: EdgeInsets
                                    .all(10),
                                border: InputBorder.none,
                                fillColor: Colors.white,
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors
                                          .transparent),
                                  borderRadius: BorderRadius
                                      .circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors
                                          .transparent),
                                  borderRadius: BorderRadius
                                      .circular(10),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors
                                          .transparent),
                                  borderRadius: BorderRadius
                                      .circular(10),
                                ),
                              )
                          );
                        },
                        itemBuilder: (context, item) {
                          return ListTile(
                            title: Text(item.values!),
                            subtitle: Text(item.name!),
                          );
                        },
                        onSelected: (item) {
                          selectedCreche=item.name ?? null;
                          _controller.text = item.values ?? '';
                          print('itm $item');
                        },
                        offset: Offset(0, 12),
                        constraints: BoxConstraints(
                            maxHeight: 500),
                        hideOnUnfocus: true,
                        showOnFocus: true,
                        hideWithKeyboard: false,
                        loadingBuilder: (context) =>
                        const Text('Loading...'),
                        errorBuilder: (context,
                            error) => const Text('Error!'),
                        emptyBuilder: (context) =>
                        const Text('No items found!'),
                      ),
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
                  hintText:
                      Global.returnTrLable(translats, CustomText.Search, lng),
                  prefixIcon: Image.asset(
                    "assets/search.png",
                    scale: 2.4,
                  ),
                ),
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
                          if (Global.validString(child_followup_guid)) {
                            var followUpDate = filteredFollowUp[index]
                            ['followup_visit_date']
                                .split('-')
                                .map(int.parse)
                                .toList();

                            var date = DateTime(followUpDate[0],
                                followUpDate[1], followUpDate[2]);

                            if (date.subtract(Duration(days: Global.validToInt(backdatedConfigirationModel?.back_dated_data_entry_allowed)>0?backdatedConfigirationModel!.back_dated_data_entry_allowed!:7)).isBefore(
                                DateTime.parse(Validate().currentDate())) &&
                                date.isAfter(
                                    DateTime.parse(Validate().currentDate())
                                        .subtract(Duration(days: Global.validToInt(backdatedConfigirationModel?.back_dated_data_entry_allowed)>0?backdatedConfigirationModel!.back_dated_data_entry_allowed!+1:8)))) {
                              // if(date.isAfter(DateTime.parse(Validate().currentDate()).subtract(Duration(days: 8))))

                              // if (date.subtract(Duration(days: 1)).isBefore(
                              //     DateTime.parse(Validate().currentDate()))) {
                              var backDate = now.isBefore(applicableDate)
                                  ? DateTime(1992)
                                    : Global.validToInt(backdatedConfigirationModel?.back_dated_data_entry_allowed)>0?DateTime.parse(Validate().currentDate())
                              .subtract(Duration(days: backdatedConfigirationModel!.back_dated_data_entry_allowed!)):DateTime(1992);
                              var backDateSD = Global.validToInt(backdatedConfigirationModel?.back_dated_data_entry_allowed)>0?date.subtract(Duration(days: backdatedConfigirationModel!.back_dated_data_entry_allowed!)):date.subtract(Duration(days: 7));
                              var refStatus = await Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) => ChildFollowUpTabScreen(
                                      tabTitle: widget.tabTitle,
                                      child_referral_guid:
                                      filteredFollowUp[index]
                                      ['child_referral_guid'],
                                      discharge_date: "",
                                      followup_visit_date:
                                      filteredFollowUp[index]
                                      ['followup_visit_date'],
                                      schedule_date: filteredFollowUp[index]
                                      ['followup_visit_date'],
                                      enrollChildGuid: Global.getItemValues(
                                          filteredFollowUp[index]
                                          ['enrResponces'],
                                          'childenrollguid'),
                                      creche_id: Global.stringToInt(
                                          Global.getItemValues(filteredFollowUp[index]['enrResponces'], 'creche_id')),
                                      child_id: Global.stringToInt(Global.getItemValues(filteredFollowUp[index]['enrResponces'], 'name')),
                                      child_followup_guid: child_followup_guid!,
                                      childId: Global.getItemValues(filteredFollowUp[index]['enrResponces'], 'child_id'),
                                      childName: Global.getItemValues(filteredFollowUp[index]['enrResponces'], 'child_name'),
                                      minDate: backDate.isBefore(backDateSD) ? backDateSD : backDate,
                                      isEditable: true)));
                              if (refStatus == 'itemRefresh') {
                                await callFolloupData();
                              }
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${Global.returnTrLable(translats, CustomText.ChildName, lng).trim()} : ',
                                          style: Styles.black104,
                                        ),
                                        Text(
                                          '${Global.returnTrLable(translats, CustomText.ChildId, lng).trim()} : ',
                                          strutStyle: StrutStyle(height: 1.2),
                                          style: Styles.black104,
                                        ),
                                        Text(
                                          '${Global.returnTrLable(translats, CustomText.Creches, lng).trim()} : ',
                                          strutStyle: StrutStyle(height: 1.2),
                                          style: Styles.black104,
                                        ),
                                        Text(
                                          '${Global.returnTrLable(translats, CustomText.schduleDate, lng).trim()} : ',
                                          strutStyle: StrutStyle(height: 1.2),
                                          style: Styles.black104,
                                        ),
                                        // Text(
                                        //   '${Global.returnTrLable(translats, CustomText.height, lng).trim()} : ',
                                        //   style: Styles.black104,
                                        // ),
                                        // Text(
                                        //   '${Global.returnTrLable(translats, CustomText.weight, lng).trim()} : ',
                                        //   style: Styles.black104,
                                        // ),
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
                                                filteredFollowUp[index]
                                                    ['enrResponces'],
                                                'child_name'),
                                            style: Styles.cardBlue10,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            Global.getItemValues(
                                                filteredFollowUp[index]
                                                    ['enrResponces'],
                                                'child_id'),
                                            style: Styles.cardBlue10,
                                            strutStyle: StrutStyle(height: 1.2),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            callCrecheNameName(
                                                Global.getItemValues(
                                                    filteredFollowUp[index]
                                                        ['enrResponces'],
                                                    'creche_id')),
                                            style: Styles.cardBlue10,
                                            strutStyle: StrutStyle(height: 1.2),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            Validate().displeDateFormate(
                                                filteredFollowUp[index]
                                                    ['followup_visit_date']!),
                                            style: Styles.cardBlue10,
                                            strutStyle: StrutStyle(height: 1.2),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          // Text(
                                          //   Global.getItemValues(
                                          //       filteredFollowUp[index]['responces'],
                                          //       'height'),
                                          //   style: Styles.blue125,
                                          //   overflow: TextOverflow.ellipsis,
                                          // ),
                                          // Text(
                                          //   Global.getItemValues(
                                          //       filteredFollowUp[index]['responces'],
                                          //       'weight'),
                                          //   style: Styles.blue125,
                                          //   overflow: TextOverflow.ellipsis,
                                          // ),
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

  String calldateOfRefferl(String? responce) {
    String date = '';
    if (responce != null) {
      var itemDate = Global.getItemValues(responce, 'followup_visit_date');
      if (Global.validString(itemDate)) {
        date = Validate().displeDateFormate(itemDate);
      }
    }
    return date;
  }

  Future callFolloupData() async {
    followUpsList =
        await ChildFollowUpTabResponseHelper().allChildSchduledFollowp();
    filteredFollowUp = followUpsList;
    setState(() {});
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

  @override
  void dispose() {
    _controller.dispose(); // Clean up controller
    super.dispose();
  }

}
