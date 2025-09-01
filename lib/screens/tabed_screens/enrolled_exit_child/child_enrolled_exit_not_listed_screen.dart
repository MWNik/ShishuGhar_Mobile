import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/custom_widget/dynamic_screen_widget/custom_animated_rolling_switch.dart';
import 'package:shishughar/database/helper/translation_language_helper.dart';
import 'package:shishughar/model/apimodel/translation_language_api_model.dart';
import 'package:shishughar/style/styles.dart';
import 'package:shishughar/utils/globle_method.dart';
import 'package:shishughar/utils/validate.dart';

import '../../../custom_widget/custom_btn.dart';
import '../../../custom_widget/custom_text.dart';
import '../../../custom_widget/custom_textfield.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_custom_dropdown.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_customtextfield_int.dart';
import '../../../database/helper/backdated_configiration_helper.dart';
import '../../../database/helper/creche_helper/creche_data_helper.dart';
import '../../../database/helper/dynamic_screen_helper/options_model_helper.dart';
import '../../../database/helper/enrolled_exit_child/enrolled_exit_child_responce_helper.dart';
import '../../../database/helper/village_data_helper.dart';
import '../../../model/databasemodel/backdated_configiration_model.dart';
import '../../../model/databasemodel/tabVillage_model.dart';
import '../../../model/dynamic_screen_model/options_model.dart';
import '../../enrolled_child_terms_condition.dart';
import 'enrolled_exit_child_tab.dart';

class NotEnrolledExitChildrenListedScreen extends StatefulWidget {
  final int crecheId;
  final String village_id;

  const NotEnrolledExitChildrenListedScreen(
      {super.key,
      required this.crecheId,
      required this.village_id,
      });

  @override
  _NotEnrolledChildrenListedScreenState createState() =>
      _NotEnrolledChildrenListedScreenState();
}

class _NotEnrolledChildrenListedScreenState
    extends State<NotEnrolledExitChildrenListedScreen> {
  TextEditingController Searchcontroller = TextEditingController();
  List<Map<String, dynamic>> childHHData = [];
  List<Map<String, dynamic>> filterData = [];
  List<OptionsModel> relationChilddata = [];
  List<TabVillage> villages = [];
  List<Translation> translats = [];
  String lng = 'en';
  String? selectedVillage;
  List<OptionsModel> villageList = [];
  String? selectedItem;
  String? crecheOpeningDate;
  String? crecheClosingDate;

  bool isDropdownActivated = false;
  int? ageLimit;
  List<OptionsModel> genderList = [];
  bool _isOverlayVisible = false;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int? maxAgeLimit;
  int? minAgeLimit;
  bool isOnlyUnsynched = false;
  bool isExited = false;
  List<Map<String, dynamic>> unsynchedList = [];
  String? role;
  List<Map<String, dynamic>> allList = [];
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
    var creches = await CrecheDataHelper().getCrecheResponceItem(widget.crecheId);
    if(creches.length>0){
      crecheOpeningDate=Global.getItemValues(creches.first.responces, 'creche_opening_date');
      crecheClosingDate=Global.getItemValues(creches.first.responces, 'creche_closing_date');
    }
    role = (await Validate().readString(Validate.role))!;
    genderList = await OptionsModelHelper().getMstCommonOptions('Gender', lng);
    backdatedConfigirationModel = await BackdatedConfigirationHelper().excuteBackdatedConfigirationModel(CustomText.enrollExitChild);
    relationChilddata =
        await OptionsModelHelper().getMstCommonOptions('Relation', lng);
    List<String> valueItems = [
      CustomText.Enrolled,
      CustomText.ChildName,
      CustomText.RelationshipChild,
      CustomText.ageInMonth,
      CustomText.NorecordAvailable,
      CustomText.hhNameS,
      CustomText.minAgeInMonthEn,
      CustomText.maxAgeInMonthEn,
      CustomText.Search,
      CustomText.clear,
      CustomText.Village,
      CustomText.ageInMonthEn,
      CustomText.childCount,
      CustomText.all,
      CustomText.unsynched,
      CustomText.freshChild,
      CustomText.exitedChild,
      CustomText.Dob,
      CustomText.Filter,
      CustomText.minAgeInMonthEn,
      CustomText.maxAgeInMonthEn,
      CustomText.clear,
      CustomText.Gender,
      CustomText.childDobIsNotValidForEnrolled,
      CustomText.ok,
      CustomText.crecheOpeningDateMsg,
      CustomText.crecheOpeningDateNotMatchMsg,
      CustomText.crecheOpeningDateAfterDate,
      CustomText.crecheClosingDateMsg,
      CustomText.crecheNotopenBefore,
    ];
    await TranslationDataHelper()
        .callTranslateString(valueItems)
        .then((value) => translats.addAll(value));


    villageValue();
    fetchChildHHDataList();
    setState(() {});
  }

  String getGender(int gender_id) {
    var result = genderList
        .where((element) => Global.stringToInt(element.name) == gender_id)
        .toList();
    return result.first.values!;
  }

  Future<void> fetchChildHHDataList() async {
    if (isExited) {
      childHHData = await EnrolledExitChilrenResponceHelper()
          .getNotEnrollChildrenExited(widget.village_id, widget.crecheId);
    } else {
      childHHData = await EnrolledExitChilrenResponceHelper()
          .getNotEnrollChildren(widget.village_id, widget.crecheId);
    }

    childHHData = childHHData.where((element) {
      var isdobavail =
          Global.getItemValues(element['responces'], 'is_dob_available');
      return Global.stringToInt(isdobavail.toString()) == 1;
    }).toList();

    allList = childHHData;
    unsynchedList =
        childHHData.where((element) => element['is_edited'] == 1).toList();
    filterData = isOnlyUnsynched ? unsynchedList : allList;
    Searchcontroller.text = '';
    selectedItem = null;

    setState(() {});
  }

  filteredGetData(BuildContext context) async {
    var filteredList = isOnlyUnsynched ? unsynchedList : allList;
    if (selectedItem != null && maxAgeLimit != null && minAgeLimit != null) {
      filterData = filteredList.where((element) {
        var ViItem = Global.getItemValues(element['responces'], 'gender_id');
        // var ageItem =
        //     int.parse(Global.getItemValues(element['responces'], 'child_age'));
        var ageItem= Validate()
            .calculateAgeInMonths(Validate().stringToDate(
            Global.getItemValues(
                element[
                'responces'],
                'child_dob')));
        return ViItem == selectedItem &&
            ageItem <= maxAgeLimit! &&
            ageItem >= minAgeLimit!;
      }).toList();
    } else if (selectedItem != null &&
        maxAgeLimit == null &&
        minAgeLimit == null) {
      filterData = filteredList.where((element) {
        var ViItem = Global.getItemValues(element['responces'], 'gender_id');
        return ViItem == selectedItem;
      }).toList();
    } else if (selectedItem == null &&
        maxAgeLimit != null &&
        minAgeLimit != null) {
      filterData = filteredList.where((element) {
        // var ViItem = Global.getItemValues(element['responces'], 'gender_id');
        // var ageItem =
        //     int.parse(Global.getItemValues(element['responces'], 'child_age'));
        var ageItem= Validate()
            .calculateAgeInMonths(Validate().stringToDate(
            Global.getItemValues(
                element[
                'responces'],
                'child_dob')));
        return ageItem <= maxAgeLimit! && ageItem >= minAgeLimit!;
      }).toList();
    } else if (maxAgeLimit != null &&
        selectedItem == null &&
        minAgeLimit == null) {
      filterData = filteredList.where((element) {
        // var ageItem =
        //     int.parse(Global.getItemValues(element['responces'], 'child_age'));
        var ageItem= Validate()
            .calculateAgeInMonths(Validate().stringToDate(
            Global.getItemValues(
                element[
                'responces'],
                'child_dob')));
        return ageItem <= maxAgeLimit!;
      }).toList();
    } else if (minAgeLimit != null &&
        selectedItem == null &&
        maxAgeLimit == null) {
      filterData = filteredList.where((element) {
        // var ageItem =
        //     int.parse(Global.getItemValues(element['responces'], 'child_age'));
        var ageItem= Validate()
            .calculateAgeInMonths(Validate().stringToDate(
            Global.getItemValues(
                element[
                'responces'],
                'child_dob')));
        return ageItem >= minAgeLimit!;
      }).toList();
    } else {
      filterData = filteredList;
    }
    setState(() {});
  }

  void toggleOverlayVisibility() {
    setState(() {
      _isOverlayVisible =
          !_isOverlayVisible; // Toggle the visibility of the overlay
    });
  }

  void toggleDropDown() {
    setState(() {
      isDropdownActivated = !isDropdownActivated;
    });
  }

  @override
  Widget build(BuildContext context) {
    Global.applyDisplayCutout(Color(0xff5979AA));
    return SafeArea(
      child: Scaffold(
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
                      // DynamicCustomCheckboxWithLabel(
                      //   label: Global.returnTrLable(translats, CustomText.unsynched, lng),
                      //   onChanged: (value) {

                      //   }),
                      SizedBox(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: DynamicCustomTextFieldInt(
                              // width: MediaQuery.of(context).size.width * 0.36,
                              initialvalue: minAgeLimit,
                              hintText: Global.returnTrLable(
                                  translats, CustomText.minAgeInMonthEn, lng),
                              // isRequred: 1,
                              onChanged: (value) {
                                minAgeLimit = value;
                              },
                            ),
                          ),
                          Expanded(
                            child: DynamicCustomTextFieldInt(
                              // width: MediaQuery.of(context).size.width * 0.36,
                              initialvalue: maxAgeLimit,
                              hintText: Global.returnTrLable(
                                  translats, CustomText.maxAgeInMonthEn, lng),
                              onChanged: (value) {
                                maxAgeLimit = value;
                              },
                            ),
                          )
                        ],
                      ),
                      DynamicCustomDropdownField(
                        // height: MediaQuery.of(context).size.height * 0.2,
                        // width: MediaQuery.of(context).size.width * 0.4,
                        hintText: Global.returnTrLable(
                            translats, CustomText.Gender, lng),
                        // isRequred: 1,
                        items: genderList,
                        selectedItem: selectedItem,
                        onChanged: (value) {
                          selectedItem = value?.name;
                          print('selectedVillage $selectedItem');
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
                      role == CustomText.crecheSupervisor
                          ? Padding(
                              padding: EdgeInsets.only(top: 25),
                              child: AnimatedRollingSwitch(
                                title1: Global.returnTrLable(
                                    translats, CustomText.all, lng),
                                title2: Global.returnTrLable(
                                    translats, CustomText.unsynched, lng),
                                isOnlyUnsynched: isOnlyUnsynched ?? false,
                                onChange: (value) async {
                                  setState(() {
                                    isOnlyUnsynched = value;
                                  });
                                  await fetchChildHHDataList();
                                },
                              ),
                            )
                          : SizedBox()
                    ]),
              )),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
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
                )),
                SizedBox(
                  width: 10.w,
                ),
                InkWell(
                  onTap: () {
                    _scaffoldKey.currentState!.openEndDrawer();
                  },
                  child: Image.asset(
                    "assets/filter_icon.png",
                    scale: 2.4,
                  ),
                )

                // InkWell(
                //   onTap: () {
                //     showOverlay(context);
                //     toggleOverlayVisibility();
                //   },
                //   child: Image.asset(
                //     "assets/filter_icon.png",
                //     scale: 2.4,
                //   ),
                // )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  role == CustomText.crecheSupervisor
                      ? AnimatedRollingSwitch(
                          title1: Global.returnTrLable(
                              translats, CustomText.freshChild, lng),
                          title2: Global.returnTrLable(
                              translats, CustomText.exitedChild, lng),
                          isOnlyUnsynched: isExited ?? false,
                          onChange: (value) async {
                            setState(() {
                              isExited = value;
                            });
                            await fetchChildHHDataList();
                          },
                        )
                      : SizedBox(),
                  Text(
                    '${Global.returnTrLable(translats, CustomText.childCount, lng)}: ${filterData.length}',
                    style: Styles.black12700,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 4.h,
            ),
            Expanded(
              child: (filterData.length > 0)
                  ? ListView.builder(
                      itemCount: filterData.length,
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        var selectedItem = filterData[index];
                        return GestureDetector(
                          onTap: () async {
                            if (role == CustomText.crecheSupervisor) {
                              if (crechedOpeningDate()) {
                                if (crechedCloseDate()) {
                                  String refStatus = '';
                                  String enrolledChildGuid = '';
                                  if (isDateInRange(Validate().stringToDate(
                                      Global.getItemValues(
                                          selectedItem['responces'],
                                          'child_dob')))) {
                                    String? minDate = await callDateOfExit(
                                        Global.getItemValues(
                                            selectedItem['responces'],
                                            'hhcguid'));
                                    if (!Global.validString(enrolledChildGuid)) {
                                      enrolledChildGuid = Validate().randomGuid();
                                      EnrolledExitChilrenTab.childName =
                                          Global.getItemValues(
                                              selectedItem['responces'],
                                              'child_name');
                                       refStatus = await Navigator.of(context).push(MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              EnrolledChildTermsCondition(
                                                  openingDate: Global.validToString(crecheOpeningDate),
                                                  closingDate: Global.validToString(crecheClosingDate),
                                                  isEditable: role ==
                                                          CustomText.crecheSupervisor
                                                              .trim()
                                                      ? true
                                                      : false,
                                                  CHHGUID: Global.getItemValues(
                                                      selectedItem['responces'],
                                                      'hhcguid'),
                                                  HHGUID: Global.getItemValues(
                                                      selectedItem['hhResponce'],
                                                      'hhguid'),
                                                  HHname: Global.stringToInt(
                                                      selectedItem['name'].toString()),
                                                  EnrolledChilGUID: enrolledChildGuid,
                                                  crecheId: widget.crecheId,
                                                  minDate: minDate,
                                                  isNew: 0,
                                                  isImageUpdate: false)));
                                    }
                                    if (refStatus == 'itemRefresh') {
                                      await fetchChildHHDataList();
                                    }
                                  } else
                                    Validate().singleButtonPopup(
                                        Global.returnTrLable(
                                            translats,
                                            CustomText
                                                .childDobIsNotValidForEnrolled,
                                            lng),
                                        Global.returnTrLable(
                                            translats, CustomText.ok, lng),
                                        false,
                                        context);
                                }
                                else {
                                  Validate().singleButtonPopup(
                                      Global.returnTrLable(translats,
                                          CustomText.crecheClosingDateMsg, lng),
                                      Global.returnTrLable(
                                          translats, CustomText.ok, lng),
                                      false,
                                      context);
                                }
                              }
                              else {
                                Validate().singleButtonPopup(
                                    Global.validString(crecheOpeningDate)?Global.returnTrLable(translats,
                                        CustomText.crecheNotopenBefore, lng):Global.returnTrLable(translats,
                                        CustomText.crecheOpeningDateMsg, lng),
                                    Global.returnTrLable(
                                        translats, CustomText.ok, lng),
                                    false,
                                    context);
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
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${Global.returnTrLable(translats, CustomText.ChildName, lng).trim()} : ',
                                          style: Styles.black104,
                                        ),
                                        Text(
                                          '${Global.returnTrLable(translats, CustomText.hhNameS, lng).trim()} : ',
                                          style: Styles.black104,
                                          strutStyle: StrutStyle(height: 1.2),
                                        ),
                                        Text(
                                          '${Global.returnTrLable(translats, CustomText.Gender, lng).trim()} : ',
                                          style: Styles.black104,
                                          strutStyle: StrutStyle(height: 1),
                                        ),
                                        Text(
                                          '${Global.returnTrLable(translats, CustomText.Dob, lng).trim()} : ',
                                          style: Styles.black104,
                                          strutStyle: StrutStyle(height: 1),
                                        ),
                                        Text(
                                          '${Global.returnTrLable(translats, CustomText.Village, lng).trim()} : ',
                                          style: Styles.black104,
                                          strutStyle: StrutStyle(height: 1.2),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 10),
                                    SizedBox(
                                      height: 40.h,
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
                                                selectedItem['responces'],
                                                'child_name'),
                                            style: Styles.cardBlue10,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            Global.getItemValues(
                                                selectedItem['hhResponce'],
                                                'hosuehold_head_name'),
                                            style: Styles.cardBlue10,
                                            strutStyle: StrutStyle(height: 1.2),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            Global.stringToInt(
                                                        Global.getItemValues(
                                                            selectedItem[
                                                                'responces'],
                                                            'gender_id')) >
                                                    0
                                                ? getGender(Global.stringToInt(
                                                    Global.getItemValues(
                                                        selectedItem['responces'],
                                                        'gender_id')))
                                                : '',
                                            style: Styles.cardBlue10,
                                            strutStyle: StrutStyle(height: .5),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            Validate().displeDateFormate(
                                                Global.getItemValues(
                                                    selectedItem['responces'],
                                                    "child_dob")),
                                            style: Styles.cardBlue10,
                                            strutStyle: StrutStyle(height: .5),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            callVillageName(
                                                selectedItem['hhResponce']),
                                            style: Styles.cardBlue10,
                                            strutStyle: StrutStyle(height: 1.2),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    (selectedItem['is_edited'] == 0 &&
                                            selectedItem['is_uploaded'] == 1)
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
                    )
                  : Center(
                      child: Text(Global.returnTrLable(
                          translats, CustomText.NorecordAvailable, lng)),
                    ),
            ),
            SizedBox(height: 10.h)
          ]),
        ),
      ),
    );
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

  filterDataQu(String entry) {
    var filteredList = isOnlyUnsynched ? unsynchedList : allList;
    if (entry.length > 0) {
      filterData = filteredList
          .where((element) =>
              (Global.getItemValues(
                      element['hhResponce'], 'hosuehold_head_name'))
                  .toLowerCase()
                  .startsWith(entry.toLowerCase()) ||
              (Global.getItemValues(element['responces'], 'child_name'))
                  .toLowerCase()
                  .startsWith(entry.toLowerCase()))
          .toList();
    } else
      filterData = filteredList;
    setState(() {});
  }

  Future<String?> villageValue() async {
    villages = await VillageDataHelper().getTabVillageList();
    villageList = villages
        .map((model) => OptionsModel(
            name: model.name.toString(), values: model.value, flag: 'tabBlock'))
        .toList();
    setState(() {});
    return null;
  }

  String callVillageName(String crecheItem) {
    String returnValue = '';
    var items = villages
        .where((element) =>
            element.name ==
            int.parse(Global.getItemValues(crecheItem, 'village_id')))
        .toList();
    if (items.length > 0) {
      returnValue = items[0].value!;
    }
    return returnValue;
  }

  filteredgetData(BuildContext context) async {
    if (selectedVillage == null) {
      Validate().singleButtonPopup(
          Global.returnTrLable(translats, CustomText.plSelect_village, lng),
          Global.returnTrLable(translats, CustomText.ok, lng),
          false,
          context);
    } else {
      filterData = childHHData.where((item) {
        var viItem = Global.getItemValues(item['hhResponce'], 'village_id');
        return viItem.toString() == selectedVillage.toString();
      }).toList();
      setState(() {});
    }
  }

  void cleaAllFilter() {
    filterData = isOnlyUnsynched ? unsynchedList : allList;
    selectedItem = null;
    selectedVillage = null;
    Searchcontroller.text = '';
    maxAgeLimit = null;
    minAgeLimit = null;
    setState(() {});
  }

  Future<String?> callDateOfExit(String CHHGUID) async {
    String? maxDateOfExit=await EnrolledExitChilrenResponceHelper().maxDateOfExit(CHHGUID);
    if(Global.validToInt(backdatedConfigirationModel?.back_dated_data_entry_allowed)>0){
      return await Validate().callMinDate(maxDateOfExit, backdatedConfigirationModel!.back_dated_data_entry_allowed!);
    }else return null;

  }

  bool isDateInRange(DateTime targetDate) {
    // Get the current date
    DateTime currentDate = DateTime.now();

    // Calculate the difference in months
    int differenceInMonths = (currentDate.year - targetDate.year) * 12 +
        currentDate.month -
        targetDate.month;

    // Check if the difference is between 6 and 36 months
    return differenceInMonths >= 6 && differenceInMonths <= 36;
  }

  bool crechedCloseDate() {
    DateTime? closingDate = Global.stringToDate(crecheClosingDate);
    if (closingDate != null) {
      return closingDate.isAfter(DateTime.now()) ||
          closingDate.isAtSameMomentAs(DateTime.now());
    } else
      return true;
  }

  bool crechedOpeningDate() {
    DateTime? openningDate = Global.stringToDate(crecheOpeningDate);
    if (openningDate != null) {
      return DateTime.now().isAfter(openningDate) ||
          openningDate.isAtSameMomentAs(DateTime.now());
    } else return false;
  }
}
