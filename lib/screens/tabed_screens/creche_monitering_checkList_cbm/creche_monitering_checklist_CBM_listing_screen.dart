import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/custom_widget/custom_appbar.dart';
import 'package:shishughar/model/dynamic_screen_model/creche_monitering_checkList_cbm_response_model.dart';
import 'package:shishughar/utils/globle_method.dart';

import '../../../custom_widget/custom_text.dart';
import '../../../database/helper/cmc_cbm/creche_monitering_checklist_CBM_response_helper.dart';
import '../../../database/helper/translation_language_helper.dart';
import '../../../model/apimodel/translation_language_api_model.dart';
import '../../../style/styles.dart';
import '../../../utils/validate.dart';
import 'creche_Monitering_CBM_tab_screen.dart';

class cmcCBMListingScreen extends StatefulWidget {
  final String? creche_id;
  final String? crecheName;

  cmcCBMListingScreen({super.key, required this.creche_id,
    required this.crecheName});

  @override
  State<cmcCBMListingScreen> createState() => _cmcCBMListingScreenState();
}

class _cmcCBMListingScreenState extends State<cmcCBMListingScreen> {
  List<CmcCBMResponseModel> cmcCBMData = [];
  List<Translation> translats = [];
  String lng = 'en';

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
      CustomText.EntryTime,
      CustomText.ExitTime,
    ];

    await TranslationDataHelper()
        .callTranslateString(valueItems)
        .then((value) => translats.addAll(value));

    await fetchCmcCBMRecords();
    setState(() {});
  }

  Future<void> fetchCmcCBMRecords() async {
    cmcCBMData = await CmcCBMTabResponseHelper()
        .childCBMChild(Global.stringToInt(widget.creche_id));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: InkWell(
        onTap: () async {
          String cmbGUid = '';
          if (!(Global.validString(cmbGUid))) {
            cmbGUid = Validate().randomGuid();
            var refStatus = await Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        CmcCBMTabSCreen(
                          cbmguid: cmbGUid,
                          crecheName: widget.crecheName!,
                          creche_id: Global.stringToInt(
                              widget.creche_id,
                          ),
                          isEdit: false,
                          isViewScreen: false,
                        )));

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
        subTitle:widget.crecheName,
        onTap: () => Navigator.pop(context, 'itemRefresh'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 21.w, vertical: 10.h),
        child: Column(children: [
          Expanded(
            child: (cmcCBMData.length > 0)
                ? ListView.builder(
                    itemCount: cmcCBMData.length,
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () async {
                          var cbmguid = cmcCBMData[index].cbmguid;
                          if (Global.validString(cbmguid)) {
                            var created_at = DateTime.parse(cmcCBMData[index].created_at.toString());
                            var date  = DateTime(created_at.year,created_at.month,created_at.day);
                            bool isViewScreen = date.add(Duration(days: 7)).isBefore(DateTime.parse(Validate().currentDate()));
                            var refStatus = await Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        CmcCBMTabSCreen(
                                          crecheName: widget.crecheName!,
                                          cbmguid: cbmguid!,
                                          creche_id: Global.stringToInt(
                                              widget.creche_id),
                                          isEdit: true,
                                            isViewScreen: isViewScreen,
                                            date_of_visit:Global.getItemValues(cmcCBMData[index].responces!, 'date_of_visit')
                                        )));

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
                                        Text(
                                          '${Global.returnTrLable(translats, CustomText.Creche, lng).trim()} : ',
                                          style: Styles.black104,
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
                                            widget.creche_id!,
                                            style: Styles.blue125,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            Global.getItemValues(cmcCBMData[index].responces!, 'date_of_visit'),
                                            style: Styles.blue125,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    (cmcCBMData[index].is_edited==0 && cmcCBMData[index].is_uploaded==1)?
                                    Image.asset(
                                      "assets/sync.png",
                                      scale: 1.5,
                                    ):
                                    Image.asset(
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
}
