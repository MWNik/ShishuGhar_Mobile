import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shishughar/custom_widget/custom_appbar.dart';
import 'package:shishughar/custom_widget/custom_double_button_dialog.dart';
import 'package:shishughar/model/dynamic_screen_model/creche_monitering_checkList_cbm_response_model.dart';
import 'package:shishughar/utils/globle_method.dart';

import '../../../custom_widget/custom_btn.dart';
import '../../../custom_widget/custom_text.dart';
import '../../../custom_widget/dynamic_screen_widget/custom_animated_rolling_switch.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_custom_dropdown_for_filter.dart';
import '../../../database/helper/backdated_configiration_helper.dart';
import '../../../database/helper/cmc_cbm/creche_monitering_checklist_CBM_response_helper.dart';
import '../../../database/helper/dynamic_screen_helper/options_model_helper.dart';
import '../../../database/helper/translation_language_helper.dart';
import '../../../model/apimodel/translation_language_api_model.dart';
import '../../../model/databasemodel/backdated_configiration_model.dart';
import '../../../model/dynamic_screen_model/options_model.dart';
import '../../../style/styles.dart';
import '../../../utils/validate.dart';
import 'creche_monitering_checklist_CBM_tab_forAdd.dart';

class AllcmcCBMListingScreen extends StatefulWidget {
  bool? isDraft;
  AllcmcCBMListingScreen({super.key,this.isDraft});

  @override
  State<AllcmcCBMListingScreen> createState() => _cmcCBMListingScreenState();
}

class _cmcCBMListingScreenState extends State<AllcmcCBMListingScreen> {
  List<CmcCBMResponseModel> cmcCBMData = [];
  List<Translation> translats = [];
  String lng = 'en';
  String? selectedCreche;
  List<CmcCBMResponseModel> filterData = [];
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<OptionsModel> creches = [];
  bool isOnlyUnsynched = false;
  List<CmcCBMResponseModel> unsynchedList = [];
  List<CmcCBMResponseModel> allList = [];
  BackdatedConfigirationModel? backdatedConfigirationModel;
  final TextEditingController _crecheSearchController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    isOnlyUnsynched=widget.isDraft??false;
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
        .callTranslateString(valueItems)
        .then((value) => translats.addAll(value));
    creches = await OptionsModelHelper().callCrechInOptionAll('Creche');
    isLoading=false;
    await fetchCmcCBMRecords();
  }

  Future<void> fetchCmcCBMRecords() async {
    cmcCBMData = await CmcCBMTabResponseHelper().callAllCrecheMonitoring();
    unsynchedList = cmcCBMData
        .where((element) => element.is_edited == 1 || element.is_edited == 2)
        .toList();
    allList = cmcCBMData;
    filterData = isOnlyUnsynched ? unsynchedList : allList;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Global.applyDisplayCutout(Color(0xff5979AA));
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, 'itemRefresh');
          return false;
        },
        child: Scaffold(
          floatingActionButton: InkWell(
            onTap: () async {
              String cbmguid = '';
              if (!(Global.validString(cbmguid))) {
                cbmguid = Validate().randomGuid();
                var refStatus = await Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (BuildContext context) => CmcCBMTabSCreenForAdd(
                            cbmguid: cbmguid,
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
                        creches.length<=1? DynamicCustomDropdownForFilterField(
                          hintText: Global.returnTrLable(
                              translats, CustomText.Creches, lng),
                          items: creches,
                          selectedItem: selectedCreche,
                          onChanged: (value) {
                            selectedCreche = value?.name;
                          },
                        ):Container(
                          height: 35.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: Color(0xffACACAC)),
                            borderRadius: BorderRadius.circular(
                                10.r),
                          ),
                          child: TypeAheadField<OptionsModel>(
                            controller: _crecheSearchController,
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
                                  _crecheSearchController.text='';
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
                              _crecheSearchController.text = item.values ?? '';
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
                                      translats, 'Clear', lng),
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
                        Padding(
                          padding: EdgeInsets.only(top: 25),
                          child: AnimatedRollingSwitch(
                            title1: Global.returnTrLable(
                                translats, CustomText.all, lng),
                            title2: Global.returnTrLable(
                                translats, CustomText.usynchedAndDraft, lng),
                            isOnlyUnsynched: isOnlyUnsynched ?? false,
                            onChange: (value) async {
                              setState(() {
                                isOnlyUnsynched = value;
                              });
                              await fetchCmcCBMRecords();
                            },
                          ),
                        )
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
                child: isLoading? Center(
                    child: CircularProgressIndicator()):(filterData.length > 0)
                    ? ListView.builder(
                        itemCount: filterData.length,
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () async {
                              var cbmguid = filterData[index].cbmguid;
                              bool isEdited=await Validate().checkEditable(filterData[index].created_at, Validate().callEditfromCnfig(backdatedConfigirationModel));

                              if (Global.validString(cbmguid)) {
                                var refStatus = await Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            CmcCBMTabSCreenForAdd(
                                                cbmguid: cbmguid!,
                                                isEdit: true,
                                                date_of_visit:
                                                    Global.getItemValues(
                                                        cmcCBMData[index]
                                                            .responces!,
                                                        'date_of_visit'),
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
                                              '${Global.returnTrLable(translats, CustomText.Creches, lng)} : ',
                                              style: Styles.black104,
                                            ),
                                            Text(
                                              '${Global.returnTrLable(translats, CustomText.datevisit, lng).trim()} : ',
                                              strutStyle: StrutStyle(height: 1.2),
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
                                                callCreCheName(
                                                    Global.getItemValues(
                                                        filterData[index]
                                                            .responces,
                                                        'creche_id')),
                                                style: Styles.cardBlue10,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                (Global.validString(
                                                        Global.getItemValues(
                                                            filterData[index]
                                                                .responces,
                                                            'date_of_visit')))
                                                    ? Validate()
                                                        .displeDateFormate(
                                                            Global.getItemValues(
                                                                filterData[index]
                                                                    .responces!,
                                                                'date_of_visit'))
                                                    : '',
                                                style: Styles.cardBlue10,
                                                strutStyle:
                                                    StrutStyle(height: 1.2),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        (filterData[index].is_edited == 0 &&
                                                filterData[index].is_uploaded ==
                                                    1)
                                            ? Image.asset(
                                                "assets/sync.png",
                                                scale: 1.5,
                                              )
                                            : (filterData[index].is_edited == 1 &&
                                                    filterData[index]
                                                            .is_uploaded ==
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
                                                        color:
                                                            Colors.red,
                                                        shadows: [
                                                          BoxShadow(
                                                            spreadRadius: 2,
                                                            blurRadius: 4,
                                                            color: Colors
                                                                .red.shade200,
                                                          ),
                                                        ],
                                                      ),
                                                      InkWell(
                                                        onTap: () async {
                                                          showDeleteDialog(
                                                              filterData[index]);
                                                          // setState(() {});
                                                        },
                                                        child: Container(
                                                          margin: EdgeInsets.only(
                                                              left: 8
                                                                  .w), // Optional spacing from content
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(50),
                                                            color: Colors
                                                                .red.shade300,
                                                          ),
                                                          child: Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        2.w,
                                                                    vertical:
                                                                        2.h),
                                                            child: Icon(
                                                              Icons
                                                                  .delete_rounded,
                                                              color: Colors
                                                                  .white,
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
        ),
      ),
    );
  }

  showDeleteDialog(CmcCBMResponseModel record) {
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
                await CmcCBMTabResponseHelper().deleteDraftRecords(record);
                await fetchCmcCBMRecords();
                Navigator.of(context).pop(true);
                setState(() {});
              });
        });
  }

  void cleaAllFilter() {
    filterData = isOnlyUnsynched ? unsynchedList : allList;
    selectedCreche = null;
    _crecheSearchController.text='';
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

  @override
  void dispose() {
    _crecheSearchController.dispose(); // Clean up controller
    super.dispose();
  }
}
