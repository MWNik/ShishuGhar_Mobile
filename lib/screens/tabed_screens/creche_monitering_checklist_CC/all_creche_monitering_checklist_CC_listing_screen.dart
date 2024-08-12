import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/custom_widget/custom_appbar.dart';
import 'package:shishughar/utils/globle_method.dart';

import '../../../custom_widget/custom_btn.dart';
import '../../../custom_widget/custom_text.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_custom_dropdown_for_filter.dart';
import '../../../database/helper/cmc_CC/creche_monitering_checklist_CC_response_helper.dart';
import '../../../database/helper/dynamic_screen_helper/options_model_helper.dart';
import '../../../database/helper/translation_language_helper.dart';
import '../../../model/apimodel/translation_language_api_model.dart';
import '../../../model/dynamic_screen_model/creche_monitering_checklist_CC_response_model.dart';
import '../../../model/dynamic_screen_model/options_model.dart';
import '../../../style/styles.dart';
import '../../../utils/validate.dart';
import 'creche_monitering_checklist_CC_tab_forAdd.dart';
import 'creche_monitering_checklist_CC_tab_screen.dart';

class AllcmcCCListingScreen extends StatefulWidget {
  // final String? creche_id;
  // final String crecheName;

  AllcmcCCListingScreen({
    super.key,
    // required this.creche_id, required this.crecheName
  });

  @override
  State<AllcmcCCListingScreen> createState() => _cmcCCListingScreenState();
}

class _cmcCCListingScreenState extends State<AllcmcCCListingScreen> {
  List<CmcCCResponseModel> cmcCCData = [];
  List<Translation> translats = [];
  String lng = 'en';
  String? selectedCreche;
  List<CmcCCResponseModel> filterData = [];
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<OptionsModel> creches = [];

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
      CustomText.VisitNotes,
      CustomText.Creches,
      CustomText.datevisit,
      CustomText.entryTime,
      CustomText.exitTime,
      CustomText.Search,
      CustomText.clear,
      CustomText.NorecordAvailable
    ];

    await TranslationDataHelper()
        .callTranslateString(valueItems)
        .then((value) => translats.addAll(value));
    creches = await OptionsModelHelper().callCrechInOptionAll('Creche');
    await fetchCmcCCRecords();
  }

  Future<void> fetchCmcCCRecords() async {
    cmcCCData = await CmcCCTabResponseHelper().callCrechMonitoringCC();
    filterData = cmcCCData; //change
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: InkWell(
        onTap: () async {
          String ccGuid = '';
          if (!(Global.validString(ccGuid))) {
            ccGuid = Validate().randomGuid();
            var refStatus = await Navigator.of(context).push(MaterialPageRoute(
                //change
                builder: (BuildContext context) => CmcCCTabSCreenForAdd(
                      cmc_cc_guid: ccGuid,
                    isEdit:false,
                    isViewScreen:false
                    )));
            if (refStatus == 'itemRefresh') {
              await fetchCmcCCRecords();
            }
          }
        },
        child: Image.asset(
          "assets/add_btn.png",
          scale: 2.7,
          color: Color(0xff5979AA),
        ),
      ),
      key: _scaffoldKey,
      appBar: CustomAppbar(
        text: Global.returnTrLable(translats, CustomText.VisitNotes, lng),
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
                              text:
                                  Global.returnTrLable(translats, 'Clear', lng),
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
                                  translats, 'Search', lng),
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
              Expanded(child: SizedBox()),
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
            child: (filterData.length > 0) //change
                ? ListView.builder(
                    itemCount: filterData.length,
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () async {
                          var ccGuid = filterData[index].cmc_cc_guid;
                          var created_at = DateTime.parse(filterData[index].created_at.toString());
                          var date  = DateTime(created_at.year,created_at.month,created_at.day);
                          bool isViewScreen = date.add(Duration(days: 7)).isBefore(DateTime.parse(Validate().currentDate()));

                          if (Global.validString(ccGuid)) {
                            var refStatus = await Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        CmcCCTabSCreenForAdd(
                                          cmc_cc_guid: ccGuid!,
                                            isEdit:true,
                                            date_of_visit:Global.getItemValues(filterData[index].responces!, 'date_of_visit')
                                            ,isViewScreen:isViewScreen
                                        )));

                            if (refStatus == 'itemRefresh') {
                              await fetchCmcCCRecords();
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
                                          '${Global.returnTrLable(translats, CustomText.Creches, lng)} : ',
                                          style: Styles.black104,
                                          strutStyle: StrutStyle(height: 1),
                                        ),
                                        Text(
                                          '${Global.returnTrLable(translats, CustomText.datevisit, lng).trim()} : ',
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
                                            callCreCheName(Global.getItemValues(
                                                filterData[index].responces,
                                                'creche_id')),
                                            style: Styles.blue125,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            (Global.validString(
                                                    Global.getItemValues(
                                                        filterData[index]
                                                            .responces,
                                                        'date_of_visit')))
                                                ? Validate().displeDateFormate(
                                                    Global.getItemValues(
                                                        filterData[index]
                                                            .responces,
                                                        'date_of_visit'))
                                                : '',
                                            style: Styles.blue125,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    (filterData[index].is_edited == 0 &&
                                            filterData[index].is_uploaded == 1)
                                        ? Image.asset(
                                            "assets/sync.png",
                                            scale: 1.5,
                                          )
                                        : Image.asset(
                                            "assets/sync_gray.png",
                                            scale: 1.5,
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
          ),
        ]),
      ),
    );
  }

  void cleaAllFilter() {
    filterData = cmcCCData;
    selectedCreche = null;
    setState(() {});
  }

  filteredGetData(
    BuildContext mContext,
  ) async {
    if (selectedCreche != null) {
      filterData = cmcCCData.where((item) {
        var creche_id = Global.getItemValues(item.responces!, 'creche_id');
        return creche_id.toString() == selectedCreche.toString();
      }).toList();

      setState(() {});
    }
  }

  String callCreCheName(String crechName) {
    String creCheItem = '';
    var crechSelected =
        creches.where((element) => element.name == crechName).toList();
    if (crechSelected.length > 0) {
      creCheItem = crechSelected.first.values!;
    }
    return creCheItem;
  }
}
