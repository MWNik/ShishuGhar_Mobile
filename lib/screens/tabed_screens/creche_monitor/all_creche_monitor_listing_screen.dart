import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/custom_widget/custom_appbar.dart';
import 'package:shishughar/custom_widget/custom_text.dart';
import 'package:shishughar/custom_widget/dynamic_screen_widget/custom_animated_rolling_switch.dart';
import 'package:shishughar/database/helper/creche_monitoring/creche_monitoring_response_helper.dart';
import 'package:shishughar/screens/tabed_screens/creche_monitor/creche_monitor_tab.dart';
import 'package:shishughar/utils/globle_method.dart';
import 'package:shishughar/utils/validate.dart';
import '../../../custom_widget/custom_btn.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_custom_dropdown.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_custom_dropdown_for_filter.dart';
import '../../../database/helper/dynamic_screen_helper/options_model_helper.dart';
import '../../../database/helper/translation_language_helper.dart';
import '../../../model/apimodel/translation_language_api_model.dart';
import '../../../model/dynamic_screen_model/creche_monitor_response_model.dart';
import '../../../model/dynamic_screen_model/options_model.dart';
import '../../../style/styles.dart';
import 'creche_monitor_tab_forAdd.dart';

class AllCrecheMonitorListingScreen extends StatefulWidget {
  const AllCrecheMonitorListingScreen({
    super.key,
  });

  @override
  State<AllCrecheMonitorListingScreen> createState() =>
      _CrecheMonitorListingScreenState();
}

class _CrecheMonitorListingScreenState
    extends State<AllCrecheMonitorListingScreen> {
  List<CrecheMonitorResponseModel> crecheMonitorData = [];
  List<CrecheMonitorResponseModel> filterData = [];
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<OptionsModel> creches = [];
  List<Translation> translatsLabel = [];
  String lng = 'en';
  String? selectedCreche;
  bool isOnlyUnsynched = false;
  List<CrecheMonitorResponseModel> unsynchedList = [];
  List<CrecheMonitorResponseModel> allList = [];

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    lng = (await Validate().readString(Validate.sLanguage))!;
    List<String> valueItems = [
      CustomText.VisitNotes,
      CustomText.Creches,
      CustomText.datevisit,
      CustomText.entryTime,
      CustomText.exitTime,
      CustomText.Search,
      CustomText.clear,
      CustomText.NorecordAvailable,
      CustomText.all,
      CustomText.usynchedAndDraft
    ];
    await TranslationDataHelper()
        .callTranslateString(valueItems)
        .then((value) => translatsLabel = value);
    creches = await OptionsModelHelper().callCrechInOptionAll('Creche');
    await fetchCMCdata();

    setState(() {});
  }

  Future<void> fetchCMCdata() async {
    crecheMonitorData =
        await CrecheMonitorResponseHelper().callCrecheMonitoringResponse();
    unsynchedList = crecheMonitorData
        .where((element) => element.is_edited == 1 || element.is_edited == 2)
        .toList();
    allList = crecheMonitorData;
    filterData = isOnlyUnsynched ? unsynchedList : allList;
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
        floatingActionButton: InkWell(
          onTap: () async {
            String cmgUid = '';
            if (!(Global.validString(cmgUid))) {
              cmgUid = Validate().randomGuid();
              final allowRefresh = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => CrecheMonitorTabForAdd(
                    cmgUid: cmgUid,
                    isEdit: false,
                    isViewScreen: false,
                  ),
                ),
              );
              if (allowRefresh == 'itemRefresh') {
                fetchCMCdata();
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
          text:
              Global.returnTrLable(translatsLabel, CustomText.VisitNotes, lng),
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
                            translatsLabel, CustomText.Creches, lng),
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
                                    translatsLabel, 'Clear', lng),
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
                                    translatsLabel, 'Search', lng),
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
                              translatsLabel, CustomText.all, lng),
                          title2: Global.returnTrLable(
                              translatsLabel, CustomText.usynchedAndDraft, lng),
                          isOnlyUnsynched: isOnlyUnsynched ?? false,
                          onChange: (value) async {
                            setState(() {
                              isOnlyUnsynched = value;
                            });
                            await fetchCMCdata();
                          },
                        ),
                      )
                    ]),
              )),
        ),
        // body
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
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
              child: filterData.length > 0
                  ? ListView.builder(
                      itemCount: filterData.length,
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        final responce = filterData[index].responces;

                        return GestureDetector(
                          onTap: () async {
                            final cmgUid = filterData[index].cmguid;
                            var created_at = DateTime.parse(
                                filterData[index].created_at.toString());
                            var date = DateTime(created_at.year,
                                created_at.month, created_at.day);
                            bool isViewScreen = date
                                .add(Duration(days: 7))
                                .isBefore(
                                    DateTime.parse(Validate().currentDate()));

                            final allowRefresh =
                                await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    CrecheMonitorTabForAdd(
                                  cmgUid: cmgUid!,
                                  dateOfVisit: Global.getItemValues(
                                      filterData[index].responces,
                                      'date_of_visit'),
                                  isEdit: true,
                                  isViewScreen: isViewScreen,
                                ),
                              ),
                            );

                            if (allowRefresh == 'itemRefresh') {
                              fetchCMCdata();
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 5.h),
                            child: Container(
                              decoration: BoxDecoration(
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
                                          '${Global.returnTrLable(translatsLabel, CustomText.Creches, lng)} : ',
                                          style: Styles.black104,
                                        ),
                                        Text(
                                          '${Global.returnTrLable(translatsLabel, CustomText.datevisit, lng)} : ',
                                          style: Styles.black104,
                                          strutStyle: StrutStyle(height: 1.2),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 10),
                                    SizedBox(
                                      height: 20.h,
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
                                                responce!, 'creche_id')),
                                            style: Styles.cardBlue10,
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
                                                        responce!,
                                                        'date_of_visit'))
                                                : '',
                                            style: Styles.cardBlue10,
                                            strutStyle: StrutStyle(height: 1.2),
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
                                        : (filterData[index].is_edited == 1 &&
                                                filterData[index].is_uploaded ==
                                                    0)
                                            ? Image.asset(
                                                "assets/sync_gray.png",
                                                scale: 1.5,
                                              )
                                            : Icon(
                                                Icons.error_outline_outlined,
                                                color: Colors.red.shade700,
                                                shadows: [
                                                  BoxShadow(
                                                      spreadRadius: 2,
                                                      blurRadius: 4,
                                                      color:
                                                          Colors.red.shade200)
                                                ],
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
                          translatsLabel, CustomText.NorecordAvailable, lng))),
            ),
          ]),
        ),
      ),
    );
  }

  void cleaAllFilter() {
    filterData = isOnlyUnsynched ? unsynchedList : allList;
    selectedCreche = null;
    setState(() {});
  }

  filteredGetData(
    BuildContext mContext,
  ) async {
    var filterList = isOnlyUnsynched ? unsynchedList : allList;
    if (selectedCreche != null) {
      filterData = filterList.where((item) {
        var creche_id = Global.getItemValues(item.responces!, 'creche_id');
        return creche_id.toString() == selectedCreche.toString();
      }).toList();
    } else {
      filterData = filterList;
    }
    setState(() {});
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
