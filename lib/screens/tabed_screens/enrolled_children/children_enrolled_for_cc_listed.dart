import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/custom_widget/dynamic_screen_widget/custom_animated_rolling_switch.dart';
import 'package:shishughar/database/helper/enrolled_exit_child/enrolled_exit_child_responce_helper.dart';
import 'package:shishughar/database/helper/translation_language_helper.dart';
import 'package:shishughar/model/apimodel/translation_language_api_model.dart';
import 'package:shishughar/style/styles.dart';
import 'package:shishughar/utils/globle_method.dart';
import 'package:shishughar/utils/validate.dart';

import '../../../custom_widget/custom_appbar.dart';
import '../../../custom_widget/custom_btn.dart';
import '../../../custom_widget/custom_text.dart';
import '../../../custom_widget/custom_textfield.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_custom_dropdown.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_custom_dropdown_for_filter.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_customtextfield_int.dart';
import '../../../database/helper/dynamic_screen_helper/options_model_helper.dart';
import '../../../database/helper/enrolled_children/enrolled_children_responce_helper.dart';
import '../../../database/helper/village_data_helper.dart';
import '../../../model/databasemodel/tabVillage_model.dart';
import '../../../model/dynamic_screen_model/options_model.dart';
import '../../enrolled_child_details_screen_new.dart';
import 'enrolled_children_tab.dart';

class EnrolledChildrenForCC extends StatefulWidget {
  // final String creCheName;

  const EnrolledChildrenForCC({
    super.key,
    // required this.creCheName
  });

  @override
  _EnrolledChildrenListedScreenState createState() =>
      _EnrolledChildrenListedScreenState();
}

class _EnrolledChildrenListedScreenState extends State<EnrolledChildrenForCC> {
  TextEditingController Searchcontroller = TextEditingController();
  List<Map<String, dynamic>> childHHData = [];
  List<Map<String, dynamic>> filterData = [];
  List<TabVillage> villages = [];
  List<Translation> translats = [];
  String lng = 'en';
  String? selectedItemDrop;
  String? selectedCreche;
  int? ageLimit;
  bool isVisible = false;
  List<OptionsModel> genderList = [];
  List<OptionsModel> creches = [];
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int? maxAgeLimit;
  int? minAgeLimit;
  bool isOnlyUnsyched = false;
  List<Map<String, dynamic>> usynchedList = [];
  List<Map<String, dynamic>> allList = [];

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
    genderList = await OptionsModelHelper().getMstCommonOptions('Gender', lng);

    creches = await OptionsModelHelper().callCrechInOptionAll('Creche');
    List<String> valueItems = [
      CustomText.Enrolled,
      CustomText.ChildName,
      CustomText.RelationshipChild,
      CustomText.ageInMonth,
      CustomText.hhNameS,
      CustomText.NorecordAvailable,
      CustomText.Search,
      CustomText.Village,
      CustomText.ageInMonthEn,
      CustomText.all,
      CustomText.unsynched,
      CustomText.careGiverName,
      CustomText.ChildId
    ];
    await TranslationDataHelper()
        .callTranslateString(valueItems)
        .then((value) => translats.addAll(value));
    villageValue();
    await fetchChildHHDataList();
    setState(() {});
  }

  Future<void> fetchChildHHDataList() async {
    childHHData =
        await EnrolledExitChilrenResponceHelper().callEnrollChildrenAll();
    usynchedList =
        childHHData.where((element) => element['is_edited'] == 1).toList();
    allList = childHHData;
    filterData = isOnlyUnsyched ? usynchedList : allList;
    Searchcontroller.text = '';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, 'itemRefresh');
        return false;
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: CustomAppbar(
          text: Global.returnTrLable(
              translats, CustomText.enrolled_children, lng),
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
                      // DynamicCustomTextFieldInt(
                      //   initialvalue: ageLimit,
                      //   hintText:
                      //   Global.returnTrLable(translats, CustomText.ageInMonthEn, lng),
                      //   onChanged: (value) {
                      //     ageLimit = value;
                      //   },
                      // ),
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
                        hintText: Global.returnTrLable(
                            translats, CustomText.Gender, lng),
                        items: genderList,
                        selectedItem: selectedItemDrop,
                        onChanged: (value) {
                          selectedItemDrop = value?.name;
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
                                  cleaAllFilter();
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
                      Padding(
                        padding: EdgeInsets.only(top: 25),
                        child: AnimatedRollingSwitch(
                          title1: Global.returnTrLable(
                              translats, CustomText.all, lng),
                          title2: Global.returnTrLable(
                              translats, CustomText.unsynched, lng),
                          isOnlyUnsynched: isOnlyUnsyched,
                          onChange: (value) async {
                            setState(() {
                              isOnlyUnsyched = value;
                            });
                            await fetchChildHHDataList();
                          },
                        ),
                      )
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
              child: (filterData.length > 0)
                  ? ListView.builder(
                      itemCount: filterData.length,
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () async {
                            var selectedItem = filterData[index];
                            // Validate().saveInt(Validate.crecheSelectedItem,
                            //     Global.stringToInt(Global.getItemValues(selectedItem['responces'], 'creche_id'))
                            //         );
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    EnrolledChildDetailScreen(
                                        CHHGUID: selectedItem['CHHGUID'],
                                        crechId: Global.stringToInt(
                                            Global.getItemValues(
                                                selectedItem['responces'],
                                                'creche_id')),
                                        HHname: Global.stringToInt(
                                            selectedItem['HHname'].toString()),
                                        enName: Global.stringToInt(
                                            selectedItem['name'].toString()),
                                        EnrolledChilGUID:
                                            selectedItem['ChildEnrollGUID'])));
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
                                          '${Global.returnTrLable(translats, CustomText.ChildName, lng).trim()} : ',
                                          style: Styles.black104,
                                        ),
                                        Text(
                                          '${Global.returnTrLable(translats, CustomText.ChildId, lng).trim()} : ',
                                          style: Styles.black104,
                                          strutStyle: StrutStyle(height: 1.2),
                                        ),
                                        Text(
                                          '${Global.returnTrLable(translats, CustomText.careGiverName, lng).trim()} : ',
                                          style: Styles.black104,
                                          strutStyle: StrutStyle(height: 1.2),
                                        ),
                                        Text(
                                          '${Global.returnTrLable(translats, CustomText.ageInMonth, lng).trim()} : ',
                                          style: Styles.black104,
                                          strutStyle: StrutStyle(height: 1.2),
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
                                                filterData[index]['responces'],
                                                'child_name'),
                                            style: Styles.cardBlue10,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            Global.getItemValues(
                                                filterData[index]['responces'],
                                                'child_id'),
                                            style: Styles.cardBlue10,
                                            strutStyle: StrutStyle(height: 1.2),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            Global.getItemValues(
                                                filterData[index]['responces'],
                                                'name_of_primary_caregiver'),
                                            style: Styles.cardBlue10,
                                            strutStyle: StrutStyle(height: 1.2),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            Global.getItemValues(
                                                filterData[index]['responces'],
                                                'age_at_enrollment_in_months'),
                                            style: Styles.cardBlue10,
                                            strutStyle: StrutStyle(height: 1.2),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            callVillageName(filterData[index]
                                                ['hhResponce']),
                                            style: Styles.cardBlue10,
                                            strutStyle: StrutStyle(height: 1.2),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    (filterData[index]['is_edited'] == 0 &&
                                            filterData[index]['is_uploaded'] ==
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

  filterDataQu(String entry) {
    var filterList = isOnlyUnsyched ? usynchedList : allList;
    if (entry.length > 0) {
      filterData = filterList
          .where((element) =>
              (Global.getItemValues(
                      element['responces'], 'name_of_primary_caregiver'))
                  .toLowerCase()
                  .startsWith(entry.toLowerCase()) ||
              (Global.getItemValues(element['responces'], 'child_name'))
                  .toLowerCase()
                  .startsWith(entry.toLowerCase()))
          .toList();
    } else
      filterData = filterList;
    setState(() {});
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

  Future<String?> villageValue() async {
    villages = await VillageDataHelper().getTabVillageList();
    // villageList = villages
    //     .map((model) => OptionsModel(
    //     name: model.name.toString(),
    //     values: model.value,
    //     flag: 'tabBlock'))
    //     .toList();
    setState(() {});
  }

  filteredGetData(BuildContext context) async {
    var filterList = isOnlyUnsyched ? usynchedList : allList;
    if (selectedItemDrop != null &&
        maxAgeLimit != null &&
        minAgeLimit != null &&
        selectedCreche != null) {
      filterData = filterList.where((element) {
        var ViItem = Global.getItemValues(element['responces'], 'gender_id');
        var creche_id = Global.getItemValues(element['responces'], 'creche_id');
        var ageItem = int.parse(Global.getItemValues(
            element['responces'], 'age_at_enrollment_in_months'));
        return ViItem == selectedItemDrop &&
            creche_id == selectedCreche &&
            ageItem <= maxAgeLimit! &&
            ageItem >= minAgeLimit!;
      }).toList();
    } else if (selectedItemDrop != null &&
        maxAgeLimit == null &&
        selectedCreche == null &&
        minAgeLimit == null) {
      filterData = filterList.where((element) {
        var ViItem = Global.getItemValues(element['responces'], 'gender_id');
        return ViItem == selectedItemDrop;
      }).toList();
    } else if (selectedItemDrop == null &&
        maxAgeLimit != null &&
        selectedCreche == null &&
        minAgeLimit != null) {
      filterData = filterList.where((element) {
        // var ViItem = Global.getItemValues(element['responces'], 'gender_id');
        var ageItem = int.parse(Global.getItemValues(
            element['responces'], 'age_at_enrollment_in_months'));
        return ageItem <= maxAgeLimit! && ageItem >= minAgeLimit!;
      }).toList();
    } else if (maxAgeLimit != null &&
        selectedItemDrop == null &&
        selectedCreche == null &&
        minAgeLimit == null) {
      filterData = filterList.where((element) {
        var ageItem = int.parse(Global.getItemValues(
            element['responces'], 'age_at_enrollment_in_months'));
        return ageItem <= maxAgeLimit!;
      }).toList();
    } else if (minAgeLimit != null &&
        selectedItemDrop == null &&
        selectedCreche == null &&
        maxAgeLimit == null) {
      filterData = filterList.where((element) {
        var ageItem = int.parse(Global.getItemValues(
            element['responces'], 'age_at_enrollment_in_months'));
        return ageItem >= minAgeLimit!;
      }).toList();
    } else if (minAgeLimit == null &&
        selectedItemDrop == null &&
        selectedCreche != null &&
        maxAgeLimit == null) {
      filterData = filterList.where((element) {
        var creche_id = Global.getItemValues(element['responces'], 'creche_id');
        return creche_id == selectedCreche!;
      }).toList();
    } else if (minAgeLimit == null &&
        selectedItemDrop != null &&
        selectedCreche != null &&
        maxAgeLimit == null) {
      filterData = filterList.where((element) {
        var creche_id = Global.getItemValues(element['responces'], 'creche_id');
        var genedr = Global.getItemValues(element['responces'], 'gender_id');
        return creche_id == selectedCreche! && genedr == selectedItemDrop;
      }).toList();
    } else if (minAgeLimit != null &&
        selectedItemDrop == null &&
        selectedCreche != null &&
        maxAgeLimit == null) {
      filterData = filterList.where((element) {
        var creche_id = Global.getItemValues(element['responces'], 'creche_id');
        var ageItem = int.parse(Global.getItemValues(
            element['responces'], 'age_at_enrollment_in_months'));
        return ageItem >= minAgeLimit! && creche_id == selectedCreche!;
      }).toList();
    } else if (minAgeLimit != null &&
        selectedItemDrop != null &&
        selectedCreche != null &&
        maxAgeLimit == null) {
      filterData = filterList.where((element) {
        var genedr = Global.getItemValues(element['responces'], 'gender_id');
        var creche_id = Global.getItemValues(element['responces'], 'creche_id');
        var ageItem = int.parse(Global.getItemValues(
            element['responces'], 'age_at_enrollment_in_months'));
        return ageItem >= minAgeLimit! &&
            creche_id == selectedCreche! &&
            genedr == selectedItemDrop!;
      }).toList();
    } else if (maxAgeLimit != null &&
        selectedItemDrop != null &&
        selectedCreche != null &&
        minAgeLimit == null) {
      filterData = filterList.where((element) {
        var genedr = Global.getItemValues(element['responces'], 'gender_id');
        var creche_id = Global.getItemValues(element['responces'], 'creche_id');
        var ageItem = int.parse(Global.getItemValues(
            element['responces'], 'age_at_enrollment_in_months'));
        return ageItem <= maxAgeLimit! &&
            creche_id == selectedCreche! &&
            genedr == selectedItemDrop!;
      }).toList();
    } else if (minAgeLimit != null &&
        selectedItemDrop == null &&
        selectedCreche != null &&
        maxAgeLimit != null) {
      filterData = filterList.where((element) {
        var creche_id = Global.getItemValues(element['responces'], 'creche_id');
        var ageItem = int.parse(Global.getItemValues(
            element['responces'], 'age_at_enrollment_in_months'));
        return ageItem <= maxAgeLimit! &&
            ageItem >= minAgeLimit! &&
            creche_id == selectedCreche!;
      }).toList();
    } else if (minAgeLimit != null &&
        maxAgeLimit != null &&
        selectedItemDrop != null &&
        selectedCreche == null) {
      filterData = filterList.where((element) {
        var genedr = Global.getItemValues(element['responces'], 'gender_id');
        var ageItem = int.parse(Global.getItemValues(
            element['responces'], 'age_at_enrollment_in_months'));
        return ageItem <= maxAgeLimit! &&
            ageItem >= minAgeLimit! &&
            selectedItemDrop == genedr;
      }).toList();
    } else {
      filterData = filterList;
    }
    setState(() {});
  }

  void cleaAllFilter() {
    filterData = isOnlyUnsyched ? usynchedList : allList;
    selectedItemDrop = null;
    Searchcontroller.text = '';
    selectedCreche = null;
    maxAgeLimit = null;
    minAgeLimit = null;
    setState(() {});
  }
}
