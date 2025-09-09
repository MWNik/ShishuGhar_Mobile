import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shishughar/custom_widget/custom_appbar.dart';
import 'package:shishughar/custom_widget/custom_btn.dart';
import 'package:shishughar/custom_widget/custom_text.dart';
import 'package:shishughar/custom_widget/custom_textfield.dart';
import 'package:shishughar/custom_widget/dynamic_screen_widget/dynamic_custom_dropdown_for_filter.dart';
import 'package:shishughar/database/helper/child_reffrel/child_refferal_response_helper.dart';
import 'package:shishughar/database/helper/creche_helper/creche_data_helper.dart';
import 'package:shishughar/database/helper/dynamic_screen_helper/options_model_helper.dart';
import 'package:shishughar/database/helper/enrolled_exit_child/enrolled_exit_child_responce_helper.dart';
import 'package:shishughar/database/helper/translation_language_helper.dart';
import 'package:shishughar/model/apimodel/creche_database_responce_model.dart';
import 'package:shishughar/model/apimodel/translation_language_api_model.dart';
import 'package:shishughar/model/dynamic_screen_model/options_model.dart';
import 'package:shishughar/screens/tabed_screens/child_reffrel/child_refferal_tab_screen.dart';
import 'package:shishughar/style/styles.dart';
import 'package:shishughar/utils/globle_method.dart';
import 'package:shishughar/utils/validate.dart';

import '../../../custom_widget/dynamic_screen_widget/dynamic_custom_dropdown.dart';
import '../../../database/helper/backdated_configiration_helper.dart';
import '../../../model/databasemodel/backdated_configiration_model.dart';

class ReferallCompletedListForCC extends StatefulWidget {
  String? enrolledChildGUID;
  bool isHomeScreen;
  String? title;
  ReferallCompletedListForCC(
      {super.key, this.enrolledChildGUID, required this.isHomeScreen,  this.title});

  @override
  State<ReferallCompletedListForCC> createState() =>
      _ReferallCompletedListForCCState();
}

class _ReferallCompletedListForCCState
    extends State<ReferallCompletedListForCC> {
  bool isLoading = true;
  List<Map<String, dynamic>> reffral = [];
  List<Map<String, dynamic>> filteredReferral = [];
  List<Map<String, dynamic>> usynchedList = [];
  List<Map<String, dynamic>> allList = [];

  List<CresheDatabaseResponceModel> crecheData = [];
  List<Translation> translats = [];
  String lng = 'en';
  DateTime? minDate;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController Searchcontroller = TextEditingController();
  List<OptionsModel> creches = [];
  OptionsModel? selectedCreche;
  bool isOnlyUnsyched = false;
  String? role;
  String? child_name;
  String? child_id;
  BackdatedConfigirationModel? backdatedConfigirationModel;
  final TextEditingController _crecheSearchcontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  @override
  void dispose() {
    _crecheSearchcontroller.dispose();
    super.dispose();
  }

  Future<void> initializeData() async {
    role = (await Validate().readString(Validate.role))!;
    translats.clear();
    var lngtr = await Validate().readString(Validate.sLanguage);
    if (lngtr != null) {
      lng = lngtr;
    }

    backdatedConfigirationModel = await BackdatedConfigirationHelper()
        .excuteBackdatedConfigirationModel(CustomText.ChildReffrel);
    List<String> valueItems = [
      CustomText.Enrolled,
      CustomText.ChildName,
      CustomText.RelationshipChild,
      CustomText.ageInMonth,
      CustomText.hhNameS,
      CustomText.NorecordAvailable,
      CustomText.Search,
      CustomText.Village,
      CustomText.FlaggedChilderen,
      CustomText.ChildId,
      CustomText.Creche_Name,
      CustomText.DischangeDate,
      CustomText.visitDate
    ];

    await TranslationDataHelper()
        .callTranslateString(valueItems)
        .then((value) => translats.addAll(value));

    await fetchCompletedReffral();
  }

  Future<void> fetchCompletedReffral() async {
    if (Global.validString(widget.enrolledChildGUID)) {
      reffral = await ChildReferralTabResponseHelper()
          .callChildReffralsByEnrolledGUID(widget.enrolledChildGUID!);
      var childRecord = await EnrolledExitChilrenResponceHelper()
          .callChildrenResponce(widget.enrolledChildGUID!);
      child_name =
          Global.getItemValues(childRecord.first.responces, 'child_name');
      child_id = Global.getItemValues(childRecord.first.responces, 'child_id');
    } else
      reffral = await ChildReferralTabResponseHelper().callChildReffrals();
    usynchedList =
        reffral.where((element) => element['is_edited'] == 1).toList();
    allList = reffral;
    filteredReferral = isOnlyUnsyched ? usynchedList : allList;
    crecheData = await CrecheDataHelper().getCrecheResponce();
    creches = await OptionsModelHelper().callCrechInOptionAll('Creche');
    isLoading = false;
    setState(() {});
  }

  void cleaAllFilter() {
    filteredReferral = isOnlyUnsyched ? usynchedList : allList;
    selectedCreche = null;
    _crecheSearchcontroller.text = '';
    setState(() {});
  }

  filteredGetData(BuildContext context) {
    var filterList = isOnlyUnsyched ? usynchedList : allList;
    if (selectedCreche != null) {
      filteredReferral = filterList.where((element) {
        var creche_id =
            Global.getItemValues(element['enrolledResponce'], 'creche_id');
        return creche_id.toString() == selectedCreche!.name.toString();
      }).toList();
    } else {
      filteredReferral = filterList;
    }
    setState(() {});
  }

  filterDataQu(String entry) {
    var filterList = isOnlyUnsyched ? usynchedList : allList;
    if (entry.length > 0) {
      filteredReferral = filterList
          .where((element) =>
              (Global.getItemValues(element['enrolledResponce'], 'child_name'))
                  .toLowerCase()
                  .startsWith(entry.toLowerCase()))
          .toList();
    } else {
      filteredReferral = filterList;
    }
    setState(() {});
    print('cLength: ${filteredReferral.length}');
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
  Widget build(BuildContext context) {
    Global.applyDisplayCutout(Color(0xff5979AA));

    return isLoading
        ? Container(
        color: Colors.white,
        child: Center(child: CircularProgressIndicator()))
        : SafeArea(
            child: PopScope(
                canPop: false, // 👈 replaces returning false in WillPopScope
                onPopInvokedWithResult: (didPop, result) {
                  if (!didPop) {
                    Navigator.pop(context, 'itemRefresh');
                  }
                },
          child: Scaffold(
              appBar: widget.isHomeScreen
                  ? CustomAppbar(
                      text:widget.title!=null?widget.title!:Global.returnTrLable(
                          translats, CustomText.FlaggedChilderen, lng),
                      actions: [],
                  onTap: (){
                    Navigator.pop(context, CustomText.itemRefresh);
                  },
              )
                  : AppBar(
                      toolbarHeight: 60,
                      backgroundColor: Color(0xff5979AA),
                      actions: [SizedBox()],
                      leading: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context, CustomText.itemRefresh);
                          },
                          child: Icon(
                            Icons.arrow_back_ios_sharp,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          RichText(
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            text: TextSpan(children: [
                              TextSpan(
                                text: '$child_name ',
                                style: Styles.white145,
                              ),
                              TextSpan(
                                  text: ' - $child_id', style: Styles.white145)
                            ]),
                          ),
                          Text(
                              widget.title!=null?widget.title!:Global.returnTrLable(
                                  translats, CustomText.FlaggedChilderen, lng),
                              style: Styles.white126P),
                        ],
                      ),
                      centerTitle: true,
                    ),
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
                                        _scaffoldKey.currentState!
                                            .closeEndDrawer();
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
                            creches.length<=1? DynamicCustomDropdownField(
                              hintText: Global.returnTrLable(
                                  translats, CustomText.Creches, lng),
                              titleText: Global.returnTrLable(
                                  translats, CustomText.Creches, lng),
                              isRequred: 0,
                              items: creches,
                              selectedItem:  selectedCreche != null? selectedCreche?.name:null,
                              onChanged: (value) {
                                selectedCreche = value;
                              },
                            )
                                :Column(
                              crossAxisAlignment: CrossAxisAlignment
                                  .start,
                              children: [
                                Text(Global.returnTrLable(
                                    translats, CustomText.Creches, lng),
                                  style: Styles.black124,),
                                SizedBox(
                                  height: 5.h,
                                ),
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
                                    controller: _crecheSearchcontroller,
                                    suggestionsCallback: (pattern) async {
                                      try {
                                        var filItems= creches.where((
                                            element) =>
                                        element.values != null &&
                                            element.name != null &&
                                            (element.values!
                                                .toLowerCase()
                                                .contains(
                                                pattern.toLowerCase())||
                                            element.name!
                                                .toLowerCase()
                                                .contains(
                                                pattern.toLowerCase()))
                                        ).toList();
                                        if(filItems.isEmpty||pattern.isEmpty){
                                          selectedCreche=null;
                                          _crecheSearchcontroller.text='';
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
                                                translats, CustomText.Search, lng),
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
                                      selectedCreche = item;
                                      _crecheSearchcontroller.text = item.values ?? '';
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
                              ],
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
                    child: (filteredReferral.length > 0)
                        ? ListView.builder(
                            itemCount: filteredReferral.length,
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () async {
                                  var childId = Global.stringToInt(
                                      Global.getItemValues(
                                          filteredReferral[index]
                                              ['enrolledResponce'],
                                          'name'));
                                  var childIdGen =
                                      '${Global.getItemValues(filteredReferral[index]['enrolledResponce'], 'child_id')}';
                                  var childName =
                                      '${Global.getItemValues(filteredReferral[index]['enrolledResponce'], 'child_name')}';

                                  var creche_id = Global.stringToInt(
                                      Global.getItemValues(
                                          filteredReferral[index]
                                              ['enrolledResponce'],
                                          'creche_id'));
                                  var child_referral_guid =
                                      filteredReferral[index]
                                          ['child_referral_guid'];

                                  bool isEdited=await Validate().checkEditable(filteredReferral[index]['created_at'], Validate().callEditfromCnfig(backdatedConfigirationModel));
                                  bool isEditableForDischage=isEdited;
                                  if(Global.validString(Global.getItemValues(filteredReferral[index]['responces'], 'discharge_date'))
                                      && Global.getItemValues(filteredReferral[index]['responces'], 'child_status')=='2'){
                                    isEditableForDischage=await Validate().checkEditable(filteredReferral[index]['created_at'], 30);
                                  }else if(Global.getItemValues(filteredReferral[index]['responces'], 'child_status')=='1'){
                                    isEditableForDischage=true;
                                  }else isEditableForDischage=isEdited;

                                  var refStatus = await Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) => ChildReferralTabScreen(
                                          tabTitle: Global.returnTrLable(
                                              translats,
                                              CustomText.FlaggedChilderen,
                                              lng),
                                          GrowthMonitoringGUID:
                                              filteredReferral[index]['cgmguid'],
                                          enrolChildGuid: filteredReferral[index]
                                              ["childenrolledguid"],
                                          creche_id: creche_id,
                                          ChildDOB: Global.getItemValues(
                                              filteredReferral[index]
                                                  ['enrolledResponce'],
                                              'child_dob'),
                                          enrollDate: Global.getItemValues(
                                              filteredReferral[index]['enrolledResponce'],
                                              'date_of_enrollment'),
                                          child_id: childId,
                                          child_referral_guid: child_referral_guid,
                                          childName: childName,
                                          minDate: minDate,
                                          isEditable: role == CustomText.crecheSupervisor.trim() ? isEdited : false,
                                          isEditableForDischage: role == CustomText.crecheSupervisor.trim() ? isEditableForDischage : false,
                                          scheduleDate: filteredReferral[index]['date_of_referral'],
                                          childId: childIdGen,
                                          isDischarge: Global.validString(Global.getItemValues(filteredReferral[index]['responces'], 'discharge_date')))));

                                  if (refStatus == 'itemRefresh') {
                                    await fetchCompletedReffral();
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
                                                  strutStyle:
                                                      StrutStyle(height: 1.2),
                                                  style: Styles.black104,
                                                ),
                                                Text(
                                                  '${Global.returnTrLable(translats, CustomText.Creche_Name, lng).trim()} : ',
                                                  strutStyle:
                                                      StrutStyle(height: 1.2),
                                                  style: Styles.black104,
                                                ),
                                                Text(
                                                  Global.validString(
                                                          Global.getItemValues(
                                                              filteredReferral[
                                                                      index]
                                                                  ['responces'],
                                                              'discharge_date'))
                                                      ? '${Global.returnTrLable(translats, CustomText.DischangeDate, lng).trim()} : '
                                                      : '${Global.returnTrLable(translats, CustomText.visitDate, lng).trim()} : ',
                                                  strutStyle:
                                                      StrutStyle(height: 1.2),
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
                                                    Global.getItemValues(
                                                        filteredReferral[index]
                                                            ['enrolledResponce'],
                                                        'child_name'),
                                                    style: Styles.cardBlue10,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  Text(
                                                    Global.getItemValues(
                                                        filteredReferral[index]
                                                            ['enrolledResponce'],
                                                        'child_id'),
                                                    strutStyle:
                                                        StrutStyle(height: 1.2),
                                                    style: Styles.cardBlue10,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  Text(
                                                    callCrecheNameName(
                                                        Global.getItemValues(
                                                            filteredReferral[
                                                                    index][
                                                                'enrolledResponce'],
                                                            'creche_id')),
                                                    strutStyle:
                                                        StrutStyle(height: 1.2),
                                                    style: Styles.cardBlue10,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  Text(
                                                    Global.validString(
                                                            Global.getItemValues(
                                                                filteredReferral[index]
                                                                    ['responces'],
                                                                'discharge_date'))
                                                        ? Validate().displeDateFormate(
                                                            Global.getItemValues(
                                                                filteredReferral[
                                                                        index]
                                                                    ['responces'],
                                                                'discharge_date'))
                                                        : Validate().displeDateFormate(
                                                            Global.getItemValues(
                                                                filteredReferral[
                                                                        index]
                                                                    ['responces'],
                                                                'visit_date')),
                                                    strutStyle:
                                                        StrutStyle(height: 1.2),
                                                    style: Styles.cardBlue10,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            (filteredReferral[index]
                                                            ['is_edited'] ==
                                                        0 &&
                                                    filteredReferral[index]
                                                            ['is_uploaded'] ==
                                                        1)
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
                  )
                ]),
              ),
            ),
        ));
  }
}
