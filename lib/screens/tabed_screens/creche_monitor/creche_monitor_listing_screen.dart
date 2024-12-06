import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/custom_widget/custom_appbar.dart';
import 'package:shishughar/custom_widget/custom_double_button_dialog.dart';
import 'package:shishughar/custom_widget/custom_text.dart';
import 'package:shishughar/custom_widget/dynamic_screen_widget/custom_animated_rolling_switch.dart';
import 'package:shishughar/database/helper/creche_monitoring/creche_monitoring_response_helper.dart';
import 'package:shishughar/database/helper/translation_language_helper.dart';
import 'package:shishughar/model/apimodel/translation_language_api_model.dart';
import 'package:shishughar/screens/tabed_screens/creche_monitor/creche_monitor_tab.dart';
import 'package:shishughar/utils/globle_method.dart';
import 'package:shishughar/utils/validate.dart';
import '../../../model/dynamic_screen_model/creche_monitor_response_model.dart';
import '../../../style/styles.dart';

class CrecheMonitorListingScreen extends StatefulWidget {
  final String? crecheId;
  final String crecheName;

  CrecheMonitorListingScreen({
    super.key,
    required this.crecheId,
    required this.crecheName,
  });

  @override
  State<CrecheMonitorListingScreen> createState() =>
      _CrecheMonitorListingScreenState();
}

class _CrecheMonitorListingScreenState
    extends State<CrecheMonitorListingScreen> {
  List<CrecheMonitorResponseModel> crecheMonitorData = [];
  List<CrecheMonitorResponseModel> filterData = [];
  List<CrecheMonitorResponseModel> unsynchedList = [];
  List<CrecheMonitorResponseModel> allList = [];
  String lng = 'en';
  List<Translation> translats = [];
  bool isOnlyUnsynched = false;
  DateTime applicableDate = Validate().stringToDate(Validate.date);
  DateTime now = DateTime.parse(Validate().currentDate());

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    var date = await Validate().readString(Validate.date);
    applicableDate = Validate().stringToDate(date ?? "2024-12-31");
    lng = (await Validate().readString(Validate.sLanguage))!;
    List<String> valueNames = [
      CustomText.VisitNotes,
      CustomText.Creches,
      CustomText.datevisit,
      CustomText.entryTime,
      CustomText.exitTime,
      CustomText.Search,
      CustomText.clear,
      CustomText.NorecordAvailable,
      CustomText.all,
      CustomText.usynchedAndDraft,
      CustomText.areSureToDelete,
      CustomText.Cancel,
      CustomText.delete
    ];

    await TranslationDataHelper()
        .callTranslateString(valueNames)
        .then((value) => translats.addAll(value));
    print(widget.crecheId);
    await fetchCmcData();

    setState(() {});
  }

  Future<void> fetchCmcData() async {
    crecheMonitorData = await CrecheMonitorResponseHelper()
        .getCrecheResponseWithCrecheId(widget.crecheId);
    unsynchedList = crecheMonitorData
        .where((element) => element.is_edited == 1 || element.is_edited == 2)
        .toList();
    allList = crecheMonitorData;
    filterData = isOnlyUnsynched ? unsynchedList : allList;
    setState(() {});
  }

  /// Navigate to Form Screen
  Future<void> _navigateToFormPage(String? cmgUid, String? dateOfVisit,
      bool isEdit, bool isViewScreen) async {
    // get allowRefresh
    final allowRefresh = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => CrecheMonitorTab(
          cmgUid: cmgUid ?? "",
          crecheId: widget.crecheId ?? "0",
          dateOfVisit: dateOfVisit,
          isEdit: isEdit,
          isViewScreen: isViewScreen,
        ),
      ),
    );

    if (allowRefresh == 'itemRefresh') {
      initializeData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: InkWell(
        onTap: () async {
          String cmgUid = '';
          if (!(Global.validString(cmgUid))) {
            cmgUid = Validate().randomGuid();
            _navigateToFormPage(cmgUid, null, false, false);
          }
        },
        child: Image.asset(
          "assets/add_btn.png",
          scale: 2.7,
          color: Color(0xff5979AA),
        ),
      ),

      // appBar
      appBar: CustomAppbar(
        text: Global.returnTrLable(translats, CustomText.VisitNotes, lng),
        subTitle: widget.crecheName,
        onTap: () => Navigator.pop(context),
      ),

      // body
      body: Padding(
        padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 10.h),
        child: Column(children: [
          Align(
            alignment: Alignment.topLeft,
            child: AnimatedRollingSwitch(
              title1: Global.returnTrLable(translats, CustomText.all, lng),
              title2: Global.returnTrLable(
                  translats, CustomText.usynchedAndDraft, lng),
              isOnlyUnsynched: isOnlyUnsynched ?? false,
              onChange: (value) async {
                setState(() {
                  isOnlyUnsynched = value;
                });
                await fetchCmcData();
              },
            ),
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
                      var selectedItem = filterData[index];

                      return GestureDetector(
                        onTap: () async {
                          var created_at = DateTime.parse(
                              selectedItem.created_at.toString());
                          var date = DateTime(created_at.year, created_at.month,
                              created_at.day);
                          bool isViewScreen = date
                              .add(Duration(days: 7))
                              .isBefore(
                                  DateTime.parse(Validate().currentDate()));
                          final cmgUid = selectedItem.cmguid;
                          await _navigateToFormPage(
                              cmgUid,
                              Global.getItemValues(responce!, 'date_of_visit'),
                              true,
                              now.isBefore(applicableDate)
                                  ? false
                                  : isViewScreen);
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
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      // Text(
                                      //   '${CustomText.Creches} : ',
                                      //   style: Styles.black104,
                                      //   strutStyle: StrutStyle(height: 1),
                                      // ),
                                      Text(
                                        '${Global.returnTrLable(translats, CustomText.datevisit, lng)} : ',
                                        style: Styles.black104,
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
                                        // Text(
                                        //   widget.crecheName,
                                        //   style: Styles.blue125,
                                        //   overflow: TextOverflow.ellipsis,
                                        // ),
                                        Text(
                                          Global.validString(
                                                  Global.getItemValues(
                                                      responce!,
                                                      'date_of_visit'))
                                              ? Validate().displeDateFormate(
                                                  Global.getItemValues(
                                                      responce!,
                                                      'date_of_visit'))
                                              : '',
                                          style: Styles.cardBlue10,
                                          strutStyle: StrutStyle(height: .5),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        // Text(
                                        //   Global.getItemValues(responce, 'exit_time'),
                                        //   style: Styles.blue125,
                                        //   strutStyle:
                                        //   StrutStyle(height: .5),
                                        //   overflow: TextOverflow.ellipsis,
                                        // ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  (selectedItem.is_edited == 0 &&
                                          selectedItem.is_uploaded == 1)
                                      ? Image.asset(
                                          "assets/sync.png",
                                          scale: 1.5,
                                        )
                                      : (selectedItem.is_edited == 1 &&
                                              selectedItem.is_uploaded == 0)
                                          ? Image.asset(
                                              "assets/sync_gray.png",
                                              scale: 1.5,
                                            )
                                          : Row(
                                              children: [
                                                Icon(
                                                  Icons.error_outline_outlined,
                                                  color: Colors.red,
                                                  shadows: [
                                                    BoxShadow(
                                                        spreadRadius: 2,
                                                        blurRadius: 4,
                                                        color:
                                                            Colors.red.shade200)
                                                  ],
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    showDeleteDialog(
                                                        selectedItem);
                                                  },
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        left: 8
                                                            .w), // Optional spacing from content
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                      color: Colors.red,
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 2.w,
                                                              vertical: 2.h),
                                                      child: Icon(
                                                        Icons.delete_rounded,
                                                        color: Colors.white,
                                                        size: 16,
                                                      ),
                                                    ),
                                                  ),
                                                )
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
                : Center(child: Text(CustomText.NorecordAvailable)),
          ),
        ]),
      ),
    );
  }

  showDeleteDialog(CrecheMonitorResponseModel record) {
    showDialog(
        context: context,
        builder: (context) {
          return CustomDoubleButton(
              message: Global.returnTrLable(
                  translats, CustomText.areSureToDelete, lng),
              posButton:
                  Global.returnTrLable(translats, CustomText.delete, lng),
              negButton:
                  Global.returnTrLable(translats, CustomText.Cancel, lng),
              onPositive: () async {
                await CrecheMonitorResponseHelper().deleteDraftRecords(record);
                await fetchCmcData();
                Navigator.of(context).pop(true);
                setState(() {});
              });
        });
  }
}
