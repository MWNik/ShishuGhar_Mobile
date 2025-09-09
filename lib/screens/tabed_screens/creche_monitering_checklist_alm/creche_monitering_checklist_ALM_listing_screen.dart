import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/custom_widget/custom_appbar.dart';
import 'package:shishughar/custom_widget/custom_double_button_dialog.dart';
import 'package:shishughar/utils/globle_method.dart';

import '../../../custom_widget/custom_text.dart';
import '../../../custom_widget/dynamic_screen_widget/custom_animated_rolling_switch.dart';
import '../../../database/helper/backdated_configiration_helper.dart';
import '../../../database/helper/cmc_alm/creche_monitering_checkList_ALM_response_helper.dart';
import '../../../database/helper/translation_language_helper.dart';
import '../../../model/apimodel/translation_language_api_model.dart';
import '../../../model/databasemodel/backdated_configiration_model.dart';
import '../../../model/dynamic_screen_model/creche_Monitering_checkList_ALM_response_model.dart';
import '../../../style/styles.dart';
import '../../../utils/validate.dart';
import 'creche_moniterig_checkList_ALM_tab_screen.dart';

class cmcALMListingScreen extends StatefulWidget {
  final String? creche_id;
  final String crecheName;

  cmcALMListingScreen(
      {super.key, required this.creche_id, required this.crecheName});

  @override
  State<cmcALMListingScreen> createState() => _cmcALMListingScreenState();
}

class _cmcALMListingScreenState extends State<cmcALMListingScreen> {
  List<CmcALMResponseModel> cmcALMData = [];
  List<Translation> translats = [];
  String lng = 'en';
  bool isOnlyUnsyched = false;
  List<CmcALMResponseModel> usynchedList = [];
  List<CmcALMResponseModel> allList = [];
  BackdatedConfigirationModel? backdatedConfigirationModel;
  bool isLoading = true;


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

    backdatedConfigirationModel = await BackdatedConfigirationHelper().excuteBackdatedConfigirationModel(CustomText.cmcDoctype);

    List<String> valueItems = [
      CustomText.Enrolled,
      CustomText.ChildName,
      CustomText.RelationshipChild,
      CustomText.ageInMonth,
      CustomText.hhNameS,
      CustomText.NorecordAvailable,
      CustomText.Search,
      CustomText.datevisit,
      CustomText.Village,
      CustomText.EntryTime,
      CustomText.ExitTime,
      CustomText.all,
      CustomText.usynchedAndDraft,
      CustomText.areSureToDelete,
      CustomText.Cancel,
      CustomText.delete,
      CustomText.VisitNotes
    ];

    await TranslationDataHelper()
        .callTranslateString(valueItems)
        .then((value) => translats.addAll(value));

    await fetchCmcCBMRecords();
    isLoading=false;
    setState(() {});
  }

  Future<void> fetchCmcCBMRecords() async {
    cmcALMData = await CmcALMTabResponseHelper()
        .childALMChild(Global.stringToInt(widget.creche_id));
    usynchedList = cmcALMData
        .where((element) => element.is_edited == 1 || element.is_edited == 2)
        .toList();
    allList = cmcALMData;
    cmcALMData = isOnlyUnsyched ? usynchedList : allList;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      floatingActionButton: InkWell(
        onTap: () async {
          String cmgUid = '';
          if (!(Global.validString(cmgUid))) {
            cmgUid = Validate().randomGuid();
            var refStatus = await Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => CmcALMTabSCreen(
                    almguid: cmgUid,
                    crecheName: widget.crecheName,
                    creche_id: Global.stringToInt(
                      widget.creche_id,
                    ),
                    isEdit: false,
                    isViewScreen: false)));

            if (refStatus == 'itemRefresh') {
              await fetchCmcCBMRecords();
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
        text: Global.returnTrLable(translats, CustomText.VisitNotes, lng),
        subTitle: widget.crecheName,
        onTap: () => Navigator.pop(context, 'itemRefresh'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 21.w, vertical: 10.h),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AnimatedRollingSwitch(
                title1: Global.returnTrLable(translats, CustomText.all, lng),
                title2: Global.returnTrLable(
                    translats, CustomText.usynchedAndDraft, lng),
                isOnlyUnsynched: isOnlyUnsyched,
                onChange: (value) async {
                  setState(() {
                    isOnlyUnsyched = value;
                  });
                  await fetchCmcCBMRecords();
                },
              )
            ],
          ),
          Expanded(
            child: isLoading? Center(
                child: CircularProgressIndicator()):(cmcALMData.length > 0)
                ? ListView.builder(
                    itemCount: cmcALMData.length,
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () async {
                          var cbmguid = cmcALMData[index].almguid;
                          bool isEdited=await Validate().checkEditable(cmcALMData[index].created_at, Validate().callEditfromCnfig(backdatedConfigirationModel));
                          if (Global.validString(cbmguid)) {
                            var refStatus = await Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        CmcALMTabSCreen(
                                            almguid: cbmguid!,
                                            crecheName: widget.crecheName,
                                            creche_id: Global.stringToInt(
                                              widget.creche_id,
                                            ),
                                            date_of_visit: Global.getItemValues(
                                                cmcALMData[index].responces!,
                                                'date_of_visit'),
                                            isEdit: true,
                                            isViewScreen:isEdited==true?false:true)));

                            if (refStatus == 'itemRefresh') {
                              await fetchCmcCBMRecords();
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
                                        // Text(
                                        //   '${Global.returnTrLable(translats, CustomText.Creches, lng)} : ',
                                        //   style: Styles.black104,
                                        //   strutStyle: StrutStyle(height: 1),
                                        // ),
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
                                          // Text(
                                          //   widget.creche_id!,
                                          //   style: Styles.blue125,
                                          //   overflow: TextOverflow.ellipsis,
                                          // ),
                                          Text(
                                            Global.getItemValues(
                                                cmcALMData[index].responces!,
                                                'date_of_visit'),
                                            style: Styles.cardBlue10,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    (cmcALMData[index].is_edited == 0 &&
                                            cmcALMData[index].is_uploaded == 1)
                                        ? Image.asset(
                                            "assets/sync.png",
                                            scale: 1.5,
                                          )
                                        : (cmcALMData[index].is_edited == 1 &&
                                                cmcALMData[index].is_uploaded ==
                                                    0)
                                            ? Image.asset(
                                                "assets/sync_gray.png",
                                                scale: 1.5,
                                              )
                                            : Row(
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .error_outline_outlined,
                                                    color: Colors.red,
                                                    shadows: [
                                                      BoxShadow(
                                                        spreadRadius: 2,
                                                        blurRadius: 4,
                                                        color:
                                                            Colors.red.shade200,
                                                      ),
                                                    ],
                                                  ),
                                                  InkWell(
                                                    onTap: () async {
                                                      showDeleteDialog(
                                                          cmcALMData[index]);
                                                      // setState(() {});
                                                    },
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                          left: 8
                                                              .w), // Optional spacing from content
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                        color: Colors.red,
                                                      ),
                                                      child: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 2.w,
                                                                vertical: 2.h),
                                                        child: Icon(
                                                          Icons.delete_rounded,
                                                          color: Colors.white,
                                                          size: 16,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
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

  showDeleteDialog(CmcALMResponseModel record) {
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
                await CmcALMTabResponseHelper().deleteDraftRecords(record);
                await fetchCmcCBMRecords();
                Navigator.of(context).pop(true);
                setState(() {});
              });
        });
  }
}
