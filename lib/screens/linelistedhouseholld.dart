import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shishughar/custom_widget/custom_appbar.dart';
import 'package:shishughar/custom_widget/custom_btn.dart';
import 'package:shishughar/custom_widget/custom_text.dart';
import 'package:shishughar/custom_widget/dynamic_screen_widget/dynamic_custom_dropdown.dart';
import 'package:shishughar/database/helper/dynamic_screen_helper/house_hold_tab_responce.dart';
import 'package:shishughar/database/helper/mst_common_helper.dart';
import 'package:shishughar/database/helper/translation_language_helper.dart';
import 'package:shishughar/model/apimodel/translation_language_api_model.dart';
import 'package:shishughar/model/databasemodel/mst_cammon_model.dart';
import 'package:shishughar/model/dynamic_screen_model/house_hold_tab_responce_model.dart';
import 'package:shishughar/screens/tabed_screens/house_hold/hh_tabview_screen.dart';
import 'package:shishughar/style/styles.dart';
import 'package:http/src/response.dart';
import '../api/verification_status_update_api.dart';
import '../custom_widget/custom_radio_btn.dart';
import '../custom_widget/custom_string_dropdown.dart';
import '../custom_widget/custom_textfield.dart';
import '../custom_widget/dynamic_screen_widget/dynamic_customdatepicker.dart';
import '../custom_widget/single_poup_dailog.dart';
import '../database/helper/block_data_helper.dart';
import '../database/helper/district_data_helper.dart';
import '../database/helper/dynamic_screen_helper/options_model_helper.dart';
import '../database/helper/gram_panchayat_data_helper.dart';
import '../database/helper/state_data_helper.dart';
import '../database/helper/village_data_helper.dart';
import '../model/databasemodel/tabBlock_model.dart';
import '../model/databasemodel/tabDistrict_model.dart';
import '../model/databasemodel/tabGramPanchayat_model.dart';
import '../model/databasemodel/tabVillage_model.dart';
import '../model/databasemodel/tabstate_model.dart';
import '../model/dynamic_screen_model/options_model.dart';
import '../utils/globle_method.dart';
import '../utils/validate.dart';



class LineholdlistedScreen extends StatefulWidget {

  final int crecheId;
  const LineholdlistedScreen({super.key,required this.crecheId});

  @override
  State<LineholdlistedScreen> createState() => _LineholdlistedScreenState();
}

class _LineholdlistedScreenState extends State<LineholdlistedScreen> {
  TextEditingController Searchcontroller = TextEditingController();

  List<HouseHoldTabResponceMosdel> hhdata = [];
  List<HouseHoldTabResponceMosdel> filterData = [];
  String hhGuid=Validate().randomGuid();
  String? village;
  String? role;
  String? lng;
  String? selectedOdour;
  List<Translation> hhlistingControlls = [];
  List<OptionsModel> statushhdata = [];
  // TextEditingController StartDatecontroller = TextEditingController();
  String? calEndDate;
  String? calStartDate;
  List<MstCommonOtherModel> verificationStatus = [];

  OptionsModel? selectedState;
  OptionsModel? selectedDistrict;
  OptionsModel? selectedBlock;
  OptionsModel? selectedGramPanchayat;
  OptionsModel? selectedVillage;

  List<OptionsModel> mstStates = [];
  List<OptionsModel> mstDistrict = [];
  List<OptionsModel> mstBlock = [];
  List<OptionsModel> mstGP = [];
  List<OptionsModel> mstVillage = [];


  List<TabState> states = [];
  List<TabDistrict> district = [];
  List<TabBlock> block = [];
  List<TabGramPanchayat> gramPanchayat = [];
  List<TabVillage> villages = [];
  List<TabVillage> villagesItemms = [];


  List<int> stateIdList = [];
  List<int> districtIdList = [];
  List<int> blockIdList = [];
  List<int> panchayatIdList = [];
  List<int> villageIdList = [];

  String GeneralFilter = 'General Filter';

  String? _selectedItem;
  List<OptionsModel> statusListItem = [];
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void validateDates() {

    if (calStartDate!=null && calEndDate!=null) {
      DateFormat inputFormata = DateFormat('yyyy-MM-dd');
      DateTime startDate = inputFormata.parse(calStartDate!);
      DateTime endDate = inputFormata.parse(calEndDate!);

      if (startDate.isAfter(endDate)) {
        calStartDate=null;
        // StartDatecontroller.clear();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                contentPadding: EdgeInsets.zero,
                content: Container(
                    width: MediaQuery.of(context).size.width * 5.00,
                    height: MediaQuery.of(context).size.height * 0.20,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            height: 40.h,
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Color(0xff5979AA),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5.0),
                                topRight: Radius.circular(5.0),
                              ),
                            ),
                            child: Center(
                                child: Text(
                                    CustomText.SHISHUGHAR, style: Styles.white126P)),
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: MediaQuery.of(context).size.width * 0.05,
                                  right:
                                  MediaQuery.of(context).size.width * 0.05),
                              child: Text(
                                  Global.returnTrLable(hhlistingControlls,
                                      CustomText.startDateMsg, lng!),
                                  style: Styles.black3125,
                                  textAlign: TextAlign.center)),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 70, vertical: 10),
                            child: CElevatedButton(
                              text: Global.returnTrLable(
                                  hhlistingControlls, CustomText.ok, lng!),
                              color: Color(0xff369A8D),
                              onPressed: () {
                                Navigator.of(context).pop(true);
                              },
                            ),
                          )
                        ])),
                );
          },
        );
      }
      else if (endDate.isBefore(startDate)) {
        // If end date is before start date, show error message for end date
        calStartDate=null;
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                contentPadding: EdgeInsets.zero,
                content: Container(
                    width: MediaQuery.of(context).size.width * 5.00,
                    height: MediaQuery.of(context).size.height * 0.20,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            height: 40.h,
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Color(0xff5979AA),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5.0),
                                topRight: Radius.circular(5.0),
                              ),
                            ),
                            child: Center(
                                child: Text(
                                    CustomText.SHISHUGHAR,
                                    style: Styles.white126P)),
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: MediaQuery.of(context).size.width * 0.05,
                                  right:
                                  MediaQuery.of(context).size.width * 0.05),
                              child: Text(
                                  Global.returnTrLable(hhlistingControlls,
                                      CustomText.endDateMsg, lng!),
                                  style: Styles.black3125,
                                  textAlign: TextAlign.center)),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 70, vertical: 10),
                            child: CElevatedButton(
                              text: Global.returnTrLable(
                                  hhlistingControlls, CustomText.ok, lng!),
                              color: Color(0xff369A8D),
                              onPressed: () {
                                Navigator.of(context).pop(true);
                              },
                            ),
                          )
                        ])),
                );
          },
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchHhDataList();
  }
/*hhdata= allData.where((element) =>
    !((Global.stringToInt(getItemValues(element.responces!,'verification_status'))==4))
    ).toList();*/

  Future<void> fetchHhDataList() async {
    lng = await Validate().readString(Validate.sLanguage);
    calEndDate=Global.initCurrentDate();
    var panchayatId = await Validate().readInt(Validate.panchayatId);
    role = await Validate().readString(Validate.role);
    filterData.clear();
    hhdata.clear();
    var allData = await HouseHoldTabResponceHelper().getHouseHoldItemsMapByCreche(widget.crecheId);
      if(role == 'CRP'){
      hhdata= allData.where((element) =>
      getItemValues(element.responces!,'gp_id')==panchayatId.toString()
      ).toList();
    }else if(role == 'Cluster Coordinator'){
      hhdata = allData;
    }else  hhdata = allData;


    filterData=hhdata;
    if(filterData.isNotEmpty && filterData.length>0) {
      stateIdList = await _fetchSpecificElement(filterData, 'state_id');
      districtIdList = await _fetchSpecificElement(filterData, 'district_id');
      blockIdList = await _fetchSpecificElement(filterData, 'block_id');
      panchayatIdList = await _fetchSpecificElement(filterData, 'gp_id');
      villageIdList = await _fetchSpecificElement(filterData, 'village_id');
    }
    await fetchStateList();

    await   setWidgetText();
    statushhdata = await OptionsModelHelper().getMstCommonOptions('Verfication Status',lng!);
    villagesItemms=await VillageDataHelper().getTabVillageList();
    if(role == 'Cluster Coordinator'){
      statusListItem=statushhdata.where((element) => (element.name=='3') ||(element.name=='5') || (element.name=='4')).toList();
    }else{
      statusListItem=statushhdata;
    }
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
        floatingActionButton: (role == 'Creche Supervisor')
            ? InkWell(
          onTap: () async {
            String hhGuid = '';
            if (!Global.validString(hhGuid)) {
              hhGuid = Validate().randomGuid();
              print("line $hhGuid");
              var refStatus = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => HHTabScreen(
                      hhGuid: hhGuid,
                      crecheId:widget.crecheId
                  ),
                ),
              );
              if (refStatus == 'itemRefresh') {
                await fetchHhDataList();
              }
            }
          },
          child: Image.asset(
            "assets/add_btn.png",
            scale: 2.7,
            color: Color(0xff5979AA),
          ),
        )
            : null,

        appBar: CustomAppbar(
          text: (lng!=null)?(village!=null)?Global.returnTrLable(hhlistingControlls,CustomText.HHlist, lng!) + '-' + village.toString():Global.returnTrLable(hhlistingControlls,CustomText.HHlist, lng!):'',
          onTap: () {
            Navigator.pop(context, 'itemRefresh');
          },
        ),
        endDrawer: SafeArea(
          child: Drawer(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: (lng != null)
                    ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 30.h,
                      ),
                      Row(
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
                      (role == 'Cluster Coordinator' ||
                          role == 'CRP' ||
                          role == 'Creche Supervisor')
                          ? Row(
                        children: [
                          Expanded(
                            child: CustomRadioButton(
                              value: "General Filter",
                              groupValue: GeneralFilter,
                              onChanged: (value) {
                                setState(() {
                                  GeneralFilter = value!;
                                });
                              },
                              label: Global.returnTrLable(
                                  hhlistingControlls,
                                  CustomText.Generalfilter,
                                  lng!),
                            ),
                          ),
                          Expanded(
                            child: CustomRadioButton(
                              value: "Location Filter",
                              groupValue: GeneralFilter,
                              onChanged: (value) {
                                setState(() {
                                  GeneralFilter = value!;
                                });
                              },
                              label: Global.returnTrLable(
                                  hhlistingControlls,
                                  CustomText.Locationfilter,
                                  lng!),
                            ),
                          ),
                        ],
                      )
                          : SizedBox(),
                      if (GeneralFilter == "General Filter") ...[
                        // DynamicCustomDropdownField(
                        //   titleText: Global.returnTrLable(
                        //       hhlistingControlls, 'Status', lng!),
                        //   items: statusListItem,
                        //   selectedItem: _selectedItem,
                        //   hintText: CustomText.Selecthere,
                        //   onChanged: (value) {
                        //     if (value != null)
                        //       String selectedId = value.name!;
                        //     setState(() {
                        //       _selectedItem = value?.name!;
                        //     });
                        //
                        //     //    filterDataByCriteria();
                        //   },
                        // ),
                        CustomDatepickerDynamic(
                          initialvalue: calStartDate,
                          isRequred: 0,
                            calenderValidate:[],
                          titleText: Global.returnTrLable(
                              hhlistingControlls, 'Start Date', lng!),
                          onChanged: (value) {
                            calStartDate = value;
                            validateDates();
                          },
                        ),
                        CustomDatepickerDynamic(
                          fieldName: 'date_of_visit',
                          initialvalue: calEndDate,
                          calenderValidate:[],
                          titleText: Global.returnTrLable(
                              hhlistingControlls, 'End Date', lng!),
                          onChanged: (value) {
                            calEndDate = value;
                            // setState(() {});

                            validateDates();
                          },
                        ),
                      ]
                      else ...[
                        DynamicCustomDropdownField(
                        
                          titleText: Global.returnTrLable(
                              hhlistingControlls, CustomText.state, lng!),
                          items: mstStates,
                          isRequred: 0,
                          selectedItem: selectedState!=null?selectedState?.name:null,
                          onChanged: (value) async {
                            selectedState = value;
                            selectedDistrict = null;
                            selectedBlock = null;
                            selectedGramPanchayat = null;
                            selectedVillage = null;
                            mstDistrict=Global.callDistrict(district, lng!, selectedState);
                            if(mstDistrict.length==1){
                              selectedDistrict=mstDistrict.first;
                            }
                            setState(() {
                            });
                          },
                        ),
                        DynamicCustomDropdownField(
                          
                          titleText: Global.returnTrLable(
                              hhlistingControlls,
                              CustomText.District,
                              lng!),
                          items: mstDistrict,
                          isRequred: 0,
                          selectedItem: selectedDistrict!=null?selectedDistrict?.name:null,
                          onChanged: (value) async {
                            selectedDistrict = value;
                            selectedBlock = null;
                            selectedGramPanchayat = null;
                            selectedVillage = null;
                            mstBlock=Global.callBlocks(block, lng!, selectedDistrict);
                            if(mstBlock.length==1){
                              selectedBlock=mstBlock.first;
                            }
                            setState(() {
                              // Update blockList based on selectedDistrict
                              // blockList = // data from database based on selectedDistrict;
                            });
                          },
                        ),
                        DynamicCustomDropdownField(
                          
                          titleText: Global.returnTrLable(
                              hhlistingControlls, CustomText.Block, lng!),
                          items: mstBlock,
                          isRequred: 0,
                          selectedItem: selectedBlock!=null?selectedBlock?.name:null,
                          onChanged: (value) async {
                            selectedBlock = value;
                            selectedGramPanchayat = null;
                            selectedVillage = null;
                            mstGP=Global.callGramPanchyats(gramPanchayat, lng!, selectedBlock);
                            if(mstGP.length==1){
                              selectedGramPanchayat=mstGP.first;
                            }
                            setState(() {
                              // Update gramPanchayatList based on selectedBlock
                              // gramPanchayatList = // data from database based on selectedBlock;
                            });
                          },
                        ),
                        DynamicCustomDropdownField(
                
                          isRequred: 0,
                          titleText: Global.returnTrLable(
                              hhlistingControlls,
                              CustomText.GramPanchayat,
                              lng!),
                          items: mstGP,
                          selectedItem: selectedGramPanchayat!=null?selectedGramPanchayat?.name:null,
                          onChanged: (value) async {
                            selectedGramPanchayat = value;
                            selectedVillage = null;
                            mstVillage=Global.callFiltersVillages(villages, lng!, selectedGramPanchayat);

                            if(mstVillage.length==1){
                              selectedVillage=mstVillage.first;
                            }
                            setState(() {
                            });
                          },
                        ),
                        DynamicCustomDropdownField(
                       
                          titleText: Global.returnTrLable(
                              hhlistingControlls, CustomText.Village, lng!),
                          isRequred: 0,
                          items: mstVillage,
                          selectedItem: selectedVillage!=null?selectedVillage?.name:null,
                          onChanged: (value) {
                            setState(() {
                              selectedVillage = value;
                            });
                          },
                        ),
                      ],
                      SizedBox(
                        height: 10.h,
                      ),
                      Padding(
                        padding: EdgeInsets.all(3),
                        child: Row(
                          children: [
                            Expanded(
                              child: CElevatedButton(
                                text: Global.returnTrLable(
                                    hhlistingControlls, 'Clear', lng!),
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
                                    hhlistingControlls, 'Search', lng!),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  filteredgetData(context);
                                },
                              ),
                            ) ,
                          ],
                        ),
                      ),
                    ])
                    : SizedBox(),
              )),
        ),
        body:  Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: CustomTextFieldRow(
                      controller: Searchcontroller,
                      onChanged:(value) {
                        print(value);
                        filterDataQu(value);
                      },
                      hintText: (lng!=null)?Global.returnTrLable(hhlistingControlls, 'Search', lng!):'',
                      prefixIcon: Image.asset(
                        "assets/search.png",
                        scale: 2.4,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  InkWell(
                    onTap: () {
                      _scaffoldKey.currentState!.openEndDrawer();
                      // showDialog(
                      //   context: context,
                      //   builder: (BuildContext context) {
                      //     return StatefulBuilder(builder:
                      //         (BuildContext context, StateSetter setState) {
                      //       return AlertDialog(
                      //         shape: RoundedRectangleBorder(
                      //           borderRadius: BorderRadius.circular(10.0),
                      //         ),
                      //         contentPadding: EdgeInsets.zero,
                      //         content: Container(
                      //             width: MediaQuery.of(context).size.width * 5.00,
                      //             height: GeneralFilter == "General Filter"
                      //                 ? MediaQuery.of(context).size.height * .5
                      //                 : MediaQuery.of(context).size.height * .7,
                      //             child: Column(
                      //                 mainAxisAlignment:
                      //                 MainAxisAlignment.spaceBetween,
                      //                 children: <Widget>[
                      //                   Container(
                      //                     height: 40.h,
                      //                     padding: EdgeInsets.all(5),
                      //                     decoration: BoxDecoration(
                      //                       color: Color(0xff112A74),
                      //                       borderRadius: BorderRadius.only(
                      //                         topLeft: Radius.circular(5.0),
                      //                         topRight: Radius.circular(5.0),
                      //                       ),
                      //                     ),
                      //                     child: Center(
                      //                         child: Text(CustomText.SHISHUGHAR,
                      //                             style: Styles.white126P)),
                      //                   ),
                      //                   Padding(
                      //                     padding: EdgeInsets.symmetric(
                      //                       horizontal: 10.w,
                      //                     ),
                      //                     child: Column(
                      //                       children: [
                      //                         (role == 'Cluster Coordinator' || role == 'CRP'|| role == 'Creche Supervisor')?Row(
                      //                           children: [
                      //                             Expanded(
                      //                               child: CustomRadioButton(
                      //                                 value: "General Filter",
                      //                                 groupValue: GeneralFilter,
                      //                                 onChanged: (value) {
                      //                                   setState(() {
                      //                                     GeneralFilter = value!;
                      //                                   });
                      //                                 },
                      //                                 label: Global.returnTrLable(hhlistingControlls, CustomText.Generalfilter, lng!),
                      //                               ),
                      //                             ),
                      //                             Expanded(
                      //                               child: CustomRadioButton(
                      //                                 value: "Location Filter",
                      //                                 groupValue: GeneralFilter,
                      //                                 onChanged: (value) {
                      //                                   setState(() {
                      //                                     GeneralFilter = value!;
                      //                                   });
                      //                                 },
                      //                                 label: Global.returnTrLable(hhlistingControlls, CustomText.Locationfilter, lng!),
                      //                               ),
                      //                             ),
                      //                           ],
                      //                         ):SizedBox(),
                      //                         if (GeneralFilter ==
                      //                             "General Filter") ...[
                      //                           DynamicCustomDropdownField(
                      //                             titleText: Global.returnTrLable(
                      //                                 hhlistingControlls,
                      //                                 'Status',
                      //                                 lng!),
                      //                             items: statusListItem,
                      //                             selectedItem: _selectedItem,
                      //                             hintText: CustomText.Selecthere,
                      //                             onChanged: (value) {
                      //                               if (value != null)
                      //                                 String selectedId =
                      //                                 value.name!;
                      //                               setState(() {
                      //                                 _selectedItem =
                      //                                 value?.name!;
                      //                               });
                      //
                      //                               //    filterDataByCriteria();
                      //                             },
                      //                           ),
                      //                           CustomDatepickerDynamic(
                      //                             initialvalue:calStartDate,
                      //                             isRequred:0,
                      //                             titleText: Global.returnTrLable(
                      //                                 hhlistingControlls,
                      //                                 'Start Date',
                      //                                 lng!),
                      //                             onChanged: (value) {
                      //                               calStartDate=value;
                      //                               validateDates();
                      //                             },
                      //                           ),
                      //                           CustomDatepickerDynamic(
                      //                             fieldName: 'date_of_visit',
                      //                             initialvalue:calEndDate,
                      //                             titleText: Global.returnTrLable(
                      //                                 hhlistingControlls,
                      //                                 'End Date',
                      //                                 lng!),
                      //                             onChanged: (value) {
                      //                               calEndDate=value;
                      //                               // setState(() {});
                      //
                      //                               validateDates();
                      //                             },
                      //                           ),
                      //                         ]else ...[
                      //                           CustomDropdownFieldString(
                      //                             titleText: Global.returnTrLable(
                      //                                 hhlistingControlls,
                      //                                 CustomText.state,
                      //                                 lng!),
                      //                             items: stateList,
                      //                             isRequred: 0,
                      //                             selectedItem: selectedState,
                      //                             onChanged: (value) async {
                      //                               selectedState = value;
                      //                               selectedDistrict = null;
                      //                               selectedBlock = null;
                      //                               selectedGramPanchayat = null;
                      //                               selectedVillage = null;
                      //                               var stateId = states
                      //                                   .firstWhere((element) =>
                      //                               element.value ==
                      //                                   selectedState)
                      //                                   .name;
                      //                               DistrictDataHelper
                      //                               districtdata =
                      //                               DistrictDataHelper();
                      //                               List<TabDistrict> tempdistrict = [];
                      //                               if(districtIdList.isNotEmpty && districtIdList.length>0){
                      //                                 tempdistrict = await districtdata.getDistrictListByDistrictId(districtIdList);
                      //                               }else {
                      //                                 tempdistrict = await districtdata.getTabDistrictList();
                      //                               }
                      //                               district = tempdistrict
                      //                                   .where((element) =>
                      //                               element.stateId ==
                      //                                   stateId.toString())
                      //                                   .toList();
                      //                               districtList.clear();
                      //                               district.forEach((element) {
                      //                                 districtList
                      //                                     .add(element.value!);
                      //                               });
                      //                               setState(() {
                      //                                 // Update districtList based on selectedState
                      //                                 // districtList = // data from database based on selectedState;
                      //                               });
                      //                             },
                      //                           ),
                      //                           CustomDropdownFieldString(
                      //                             titleText: Global.returnTrLable(
                      //                                 hhlistingControlls,
                      //                                 CustomText.District,
                      //                                 lng!),
                      //                             items: districtList,
                      //                             isRequred: 0,
                      //                             selectedItem: selectedDistrict,
                      //                             onChanged: (value) async {
                      //                               selectedDistrict = value;
                      //                               selectedBlock = null;
                      //                               selectedGramPanchayat = null;
                      //                               selectedVillage = null;
                      //                               var districtId = district
                      //                                   .firstWhere((element) =>
                      //                               element.value ==
                      //                                   selectedDistrict)
                      //                                   .name;
                      //                               BlockDataHelper blockdata =
                      //                               BlockDataHelper();
                      //                               if(blockIdList.isNotEmpty && blockIdList.length>0){
                      //                                 block = await blockdata.getBlockListByBlockId(blockIdList);
                      //                               }else {
                      //                                 block = await blockdata
                      //                                     .getTabBlockList();
                      //                               }
                      //                               block = block
                      //                                   .where((element) =>
                      //                               element.districtId ==
                      //                                   districtId.toString())
                      //                                   .toList();
                      //                               blockList.clear();
                      //                               block.forEach((element) {
                      //                                 blockList
                      //                                     .add(element.value!);
                      //                               });
                      //                               setState(() {
                      //                                 // Update blockList based on selectedDistrict
                      //                                 // blockList = // data from database based on selectedDistrict;
                      //                               });
                      //                             },
                      //                           ),
                      //                           CustomDropdownFieldString(
                      //                             titleText: Global.returnTrLable(
                      //                                 hhlistingControlls,
                      //                                 CustomText.Block,
                      //                                 lng!),
                      //                             items: blockList,
                      //                             isRequred: 0,
                      //                             selectedItem: selectedBlock,
                      //                             onChanged: (value) async {
                      //                               selectedBlock = value;
                      //                               selectedGramPanchayat = null;
                      //                               selectedVillage = null;
                      //                               var blockId = block
                      //                                   .firstWhere((element) =>
                      //                               element.value ==
                      //                                   selectedBlock)
                      //                                   .name;
                      //                               GramPanchayatDataHelper
                      //                               gramPanchayatdata =
                      //                               GramPanchayatDataHelper();
                      //                               if(panchayatIdList.isNotEmpty && panchayatIdList.length>0){
                      //                                 gramPanchayat = await gramPanchayatdata
                      //                                     .getGramPanchayatListByPanchayatId(panchayatIdList);
                      //                               }else {
                      //                                 gramPanchayat = await gramPanchayatdata
                      //                                     .getTabGramPanchayatList();
                      //                               }
                      //
                      //                               gramPanchayat = gramPanchayat
                      //                                   .where((element) =>
                      //                               element.blockId ==
                      //                                   blockId.toString())
                      //                                   .toList();
                      //                               gramPanchayatList.clear();
                      //                               gramPanchayat
                      //                                   .forEach((element) {
                      //                                 gramPanchayatList
                      //                                     .add(element.value!);
                      //                               });
                      //                               setState(() {
                      //                                 // Update gramPanchayatList based on selectedBlock
                      //                                 // gramPanchayatList = // data from database based on selectedBlock;
                      //                               });
                      //                             },
                      //                           ),
                      //                           CustomDropdownFieldString(
                      //                             isRequred: 0,
                      //                             titleText: Global.returnTrLable(
                      //                                 hhlistingControlls,
                      //                                 CustomText.GramPanchayat,
                      //                                 lng!),
                      //                             items: gramPanchayatList,
                      //                             selectedItem:
                      //                             selectedGramPanchayat,
                      //                             onChanged: (value) async {
                      //                               selectedGramPanchayat = value;
                      //                               selectedVillage = null;
                      //                               var gramPanchyatId = gramPanchayat
                      //                                   .firstWhere((element) =>
                      //                               element.value ==
                      //                                   selectedGramPanchayat)
                      //                                   .name;
                      //                               VillageDataHelper
                      //                               villagetdata =
                      //                               VillageDataHelper();
                      //                               if(villageIdList.isNotEmpty && villageIdList.length>0){
                      //                                 villages = await villagetdata
                      //                                     .getVillageListByVillageId(villageIdList);
                      //                               }else {
                      //                                 villages = await villagetdata
                      //                                     .getTabVillageList();
                      //                               }
                      //                               villages = villages
                      //                                   .where((element) =>
                      //                               element.gpId ==
                      //                                   gramPanchyatId
                      //                                       .toString())
                      //                                   .toList();
                      //                               villageList.clear();
                      //                               villages.forEach((element) {
                      //                                 villageList
                      //                                     .add(element.value!);
                      //                               });
                      //                               setState(() {
                      //                                 // Update villageList based on selectedGramPanchayat
                      //                                 // villageList = // data from database based on selectedGramPanchayat;
                      //                               });
                      //                             },
                      //                           ),
                      //                           CustomDropdownFieldString(
                      //                             titleText: Global.returnTrLable(
                      //                                 hhlistingControlls,
                      //                                 CustomText.Village,
                      //                                 lng!),
                      //                             isRequred: 0,
                      //                             items: villageList,
                      //                             selectedItem: selectedVillage,
                      //                             onChanged: (value) {
                      //                               setState(() {
                      //                                 selectedVillage = value;
                      //                               });
                      //                             },
                      //                           ),
                      //                         ]
                      //
                      //
                      //                       ],
                      //                     ),
                      //                   ),
                      //                   Padding(
                      //                     padding: EdgeInsets.symmetric(
                      //                       horizontal: 20,
                      //                     ),
                      //                     child: Row(
                      //                       children: [
                      //                         Expanded(
                      //                           child: CElevatedButton(
                      //                             text: Global.returnTrLable(hhlistingControlls, 'Search', lng!),
                      //                             color: Color(0xffDB4B73),
                      //                             onPressed: () {
                      //                               Navigator.of(context).pop();
                      //                               filteredgetData(context);
                      //                             },
                      //                           ),
                      //                         ),
                      //                         SizedBox(width: 10),
                      //                         Expanded(
                      //                           child: CElevatedButton(
                      //                             text: Global.returnTrLable(hhlistingControlls,'Cancel', lng!),
                      //                             color: Color(0xFF42A5F5),
                      //                             onPressed: () {
                      //                               cleaAllFilter();
                      //                               Navigator.of(context).pop();
                      //                             },
                      //                           ),
                      //                         )
                      //                       ],
                      //                     ),
                      //                   ),
                      //                   SizedBox(height: 10),
                      //                 ])),
                      //       );
                      //     }
                      //     );
                      //   },
                      // );
                    },
                    child: Image.asset(
                      "assets/filter_icon.png",
                      scale: 2.4,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:[
                  SizedBox(),
                  Text(
                  lng!=null?
                  Global.returnTrLable(
                      hhlistingControlls,
                     CustomText.totalHH,
                      lng!) +
                      " : ${filterData.length}":CustomText.totalHH+ " : ${filterData.length}",
                  style: Styles.black127P,
                  strutStyle: StrutStyle(height: 1.2),textAlign: TextAlign.left
                ),
      ]
              ),
              (filterData.length > 0)? Expanded(
                child: ListView.builder(
                  itemCount: filterData.length,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () async {
                        // Handle item tap here
                        print('Item $index tapped');
                        var refStatus = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                HHTabScreen(
                                    hhGuid: filterData[index].HHGUID!,
                                    crecheId:widget.crecheId
                                ),
                          ),
                        );
                        if (refStatus == 'itemRefresh') {
                          await fetchHhDataList();
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
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 8.h,
                            ),
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
                                      Global.returnTrLable(
                                          hhlistingControlls,
                                          CustomText.hhID,
                                          lng!) +
                                          " : ",
                                      style: Styles.black104,
                                    ),
                                    Text(
                                      Global.returnTrLable(
                                          hhlistingControlls,
                                          CustomText.RespondentName,
                                          lng!) +
                                          " : ",
                                      style: Styles.black104,
                                    ),
                                    Text(
                                      Global.returnTrLable(
                                          hhlistingControlls,
                                          CustomText.hhNameS,
                                          lng!) +
                                          " : ",
                                      style: Styles.black104,
                                      strutStyle: StrutStyle(height: 1.2),
                                    ),
                                    Text(
                                      Global.returnTrLable(
                                          hhlistingControlls,
                                          CustomText.datevisit,
                                          lng!) +
                                          " : ",
                                      style: Styles.black104,
                                      strutStyle: StrutStyle(height: 1.2),
                                    ),
                                    Text(
                                      Global.returnTrLable(
                                          hhlistingControlls,
                                          CustomText.Village,
                                          lng!) +
                                          " : ",
                                      style: Styles.black104,
                                      strutStyle: StrutStyle(height: 1.2),
                                    ),
                                    Text(
                                      Global.returnTrLable(
                                          hhlistingControlls,
                                          CustomText.Status,
                                          lng!) +
                                          " : ",
                                      style: Styles.black104,
                                      strutStyle: StrutStyle(height: 1.2),
                                    ),

                                  ],
                                ),
                                SizedBox(width: 10),
                                SizedBox(
                                  height: 65.h,
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
                                          getItemValues(
                                              filterData[index].responces!,
                                              'hhid'),
                                          style: Styles.blue125,overflow:TextOverflow.ellipsis),
                                      Text(
                                          getItemValues(
                                              filterData[index].responces!,
                                              'respondent_name'),
                                          style: Styles.blue125,overflow:TextOverflow.ellipsis),
                                      Text(
                                          getItemValues(
                                              filterData[index].responces!,
                                              'hosuehold_head_name'),
                                          style: Styles.blue125,overflow:TextOverflow.ellipsis),
                                      Text(
                                          Validate().displeDateFormate(getItemValues(
                                              filterData[index].responces!,
                                              'date_of_visit')),
                                          style: Styles.blue125,
                                          strutStyle: StrutStyle(height: .5),overflow:TextOverflow.ellipsis
                                      ),
                                      Text(
                                          callVillageName(
                                              filterData[index].responces!),
                                          style: Styles.blue125,
                                          strutStyle: StrutStyle(height: .5),overflow:TextOverflow.ellipsis
                                      ),
                                      Text(
                                          getfindStatusValues(getItemValues(
                                              filterData[index].responces!,
                                              'verification_status')),
                                          style: Styles.blue125,
                                          strutStyle: StrutStyle(height: .5),overflow:TextOverflow.ellipsis
                                      ),

                                    ],
                                  ),
                                ),
                                SizedBox(width: 5),
                                (filterData[index].is_edited==0 && filterData[index].is_uploaded==1)?
                                Image.asset(
                                  "assets/sync.png",
                                  scale: 1.5,
                                ):
                                Image.asset(
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
                ),
              ):
              /*(lng!=null)?(village!=null)?Global.returnTrLable(hhlistingControlls,'HH List', lng!)*/
              Expanded(child: Center(child: Text((lng!=null)?Global.returnTrLable(hhlistingControlls,CustomText.NorecordAvailable, lng!):''))),
              SizedBox(
                height: 10.h,
              ),
            ],
          ),
        )
        ,
      ),
    );
  }

  void cleaAllFilter() {
    selectedVillage = null;
    selectedGramPanchayat = null;
    calEndDate = null;
    calStartDate = null;
    filterData = hhdata;
    _selectedItem=null;
    setState((){});
    }


  String getItemValues(String response, String key){
    String returnValue="";
    Map<String, dynamic> itemresponse = jsonDecode(response);
    var value = itemresponse[key];
    if(value != null){
      returnValue = value.toString();
    }
    return returnValue;
  }


  String getfindStatusValues(String id){
    String returnValue="";

    if(Global.validString(id)){
      var reltionvl = statushhdata.where((element) => element.name == id).toList();
      if(reltionvl.length > 0){
        returnValue = reltionvl[0].values!;
      }
    }

    return returnValue;
  }

  // callVerificationStatusData() async {
  //   var network = await Validate().checkNetworkConnection();
  //   var villageId =await Validate().readInt(Validate.villageId);
  //   if (network) {
  //     showLoaderDialog(context);
  //     var userName = await Validate().readString( Validate.userName);
  //     var password = await Validate().readString( Validate.Password);
  //     var token = await Validate().readString( Validate.appToken);
  //     await VerificationStatusUpdateApi().callVerificationStatusApi(villageId.toString(),userName!,password!,token!).then((
  //         value) async =>
  //     await updateResponces(value));
  //     Navigator.pop(context);
  //     await fetchHhDataList();
  //
  //   } else {
  //     Validate().singleButtonPopup(
  //         Global.returnTrLable(hhlistingControlls, CustomText.nointernetconnectionavailable, lng!),
  //         Global.returnTrLable(hhlistingControlls, CustomText.ok, lng!),
  //         false, context);
  //   }
  // }

  Future<void> updateResponces(Response value) async {
    try {
      Map<String, dynamic> resultMap = jsonDecode(value.body);
      print(" responce $resultMap");
      await HouseHoldTabResponceHelper().updateUploadedHHDataItem(resultMap);

    } catch(e) {
      print("exp ${e.toString()}");
    }
  }


  showLoaderDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                SizedBox(height: 10.h),
                Text(Global.returnTrLable(
                    hhlistingControlls, CustomText.pleaseWait, lng!)),
              ],
            ),
          ),
        );
      },
    );
  }
  filterDataQu(String entry){
    if(entry.length>0) {
      filterData = hhdata.where((element) =>
      (getItemValues(
          element.responces!,
          'hosuehold_head_name')).toLowerCase().startsWith(entry.toLowerCase()) ||(getItemValues(
          element.responces!,'respondent_name')).toLowerCase().startsWith(entry.toLowerCase())
      ).toList();
    }else filterData=hhdata;
    setState(() {});
    print('dd ${filterData.length}');
  }


  Future<void> setWidgetText()async {
    // lng = await Validate().readString(Validate.sLanguage);
    // role = await Validate().readString(Validate.role);
    List<String> valueNames = [CustomText.RespondentName,CustomText.hhNameS, CustomText.datevisit,CustomText.Status, CustomText.StartDate,CustomText.EndDate,CustomText.Search,CustomText.Cancel,CustomText.HHlist, CustomText.state,CustomText.District,
      CustomText.Block,CustomText.GramPanchayat,CustomText.Village,CustomText.Generalfilter,CustomText.Locationfilter,
      CustomText.plSelect_state,CustomText.plSelect_district,CustomText.plSelect_block,
      CustomText.plSelect_geamPanchayat,CustomText.plSelect_village,CustomText.NorecordAvailable,
      CustomText.ok,CustomText.error,CustomText.startDateMsg,
      CustomText.endDateMsg,CustomText.pleaseWait,CustomText.nointernetconnectionavailable,
      CustomText.ok, CustomText.pleaseSelectStartDate,CustomText.Selecthere];
    await TranslationDataHelper()
        .callTranslateString(valueNames)
        .then((value) => hhlistingControlls = value);

    setState(() {});
  }

  filteredgetData(
      BuildContext mContext,
      ) async {
    if (GeneralFilter == 'General Filter') {
      String? selectedStatus = _selectedItem;

      filterData = hhdata.where((item) {
        String status = getItemValues(item.responces!, 'verification_status');
        String dateOfVisit = getItemValues(item.responces!, 'date_of_visit');
        print("$status");

        if ((selectedStatus != null && selectedStatus.isNotEmpty) &&
            (calStartDate != null && calEndDate != null)) {
          DateFormat inputFormata = DateFormat('yyyy-MM-dd');
          DateTime itemDate = inputFormata.parse(dateOfVisit);
          DateTime sdate = inputFormata.parse(calStartDate!);
          DateTime edate = inputFormata.parse(calEndDate!);

          if (status == selectedStatus &&
              (!itemDate.isBefore(sdate) && !itemDate.isAfter(edate))) {
            return true;
          } else {
            return false;
          }
        } else if (selectedStatus != null && selectedStatus.isNotEmpty) {
          if (status == selectedStatus) {
            return true;
          } else {
            return false;
          }
        } else if (calStartDate != null && calEndDate != null) {
          DateFormat inputFormata = DateFormat('yyyy-MM-dd');
          DateTime itemDate = inputFormata.parse(dateOfVisit);
          DateTime sdate = inputFormata.parse(calStartDate!);
          DateTime edate = inputFormata.parse(calEndDate!);

          if (itemDate.isBefore(sdate) || itemDate.isAfter(edate)) {
            return false;
          } else {
            return true;
          }
        }

        return true;
      }).toList();
    }
    // else {
    //   return await showDialog(
    //     context: mContext,
    //     builder: (mContext) {
    //       return SingleButtonPopupDialog(
    //           message: Global.returnTrLable(
    //               hhlistingControlls, CustomText.pleaseSelectStartDate, lng!),
    //           button: Global.returnTrLable(
    //               hhlistingControlls, CustomText.ok, lng!));
    //     },
    //   );
    // }
    else if (GeneralFilter == 'Location Filter') {
      // if (selectedState == null) {
      //   Validate().singleButtonPopup(
      //       Global.returnTrLable(
      //           hhlistingControlls, CustomText.plSelect_state, lng!),
      //       Global.returnTrLable(hhlistingControlls, CustomText.ok, lng!),
      //       false,
      //       context);
      // } else if (selectedDistrict == null) {
      //   Validate().singleButtonPopup(
      //       Global.returnTrLable(
      //           hhlistingControlls, CustomText.plSelect_district, lng!),
      //       Global.returnTrLable(hhlistingControlls, CustomText.ok, lng!),
      //       false,
      //       context);
      // } else if (selectedBlock == null) {
      //   Validate().singleButtonPopup(
      //       Global.returnTrLable(
      //           hhlistingControlls, CustomText.plSelect_block, lng!),
      //       Global.returnTrLable(hhlistingControlls, CustomText.ok, lng!),
      //       false,
      //       context);
      // } else if (selectedGramPanchayat == null) {
      //   Validate().singleButtonPopup(
      //       Global.returnTrLable(
      //           hhlistingControlls, CustomText.plSelect_geamPanchayat, lng!),
      //       Global.returnTrLable(hhlistingControlls, CustomText.ok, lng!),
      //       false,
      //       context);
      // } else if (selectedVillage == null) {
      //   Validate().singleButtonPopup(
      //       Global.returnTrLable(
      //           hhlistingControlls, CustomText.plSelect_village, lng!),
      //       Global.returnTrLable(hhlistingControlls, CustomText.ok, lng!),
      //       false,
      //       context);
      // } else {
      if (selectedGramPanchayat != null && selectedVillage != null) {
          filterData = hhdata.where((item) {
            var viItem = getItemValues(item.responces!, 'village_id');
            var grItem = getItemValues(item.responces!, 'gp_id');
            return viItem.toString() == selectedVillage?.name.toString() &&
                grItem.toString() == selectedGramPanchayat?.name.toString();
          }).toList();
      }
      else if (selectedGramPanchayat != null) {
        filterData = hhdata.where((item) {
          var grItem = getItemValues(item.responces!, 'gp_id');
          return grItem.toString() == selectedGramPanchayat?.name.toString();
        }).toList();
      } else if (selectedVillage != null) {
        filterData = hhdata.where((item) {
          var viItem = Global.getItemValues(item.responces!, 'village_id');
          return viItem.toString() == selectedVillage?.name.toString();
        }).toList();
      }
    }
    setState(() {});
  }




  Future<void> fetchStateList() async {

    StateDataHelper databaseHelper = StateDataHelper();
    if (stateIdList.isNotEmpty && stateIdList.length > 0) {
      states = await databaseHelper.getStateListByStateId(stateIdList);
    } else {
      states = await databaseHelper.getTabStateList();
    }
    if (districtIdList.isNotEmpty && districtIdList.length > 0) {
      district= await DistrictDataHelper().getDistrictListByDistrictId(districtIdList);
    }else district= await DistrictDataHelper().getTabDistrictList();


    if (blockIdList.isNotEmpty && blockIdList.length > 0) {
      block= await BlockDataHelper().getBlockListByBlockId(blockIdList);
    }else block= await BlockDataHelper().getTabBlockList();


    if (panchayatIdList.isNotEmpty && panchayatIdList.length > 0) {
      gramPanchayat= await GramPanchayatDataHelper().getGramPanchayatListByPanchayatId(panchayatIdList);
    }else gramPanchayat= await GramPanchayatDataHelper().getTabGramPanchayatList();


    if (villageIdList.isNotEmpty && villageIdList.length > 0) {
      villages= await VillageDataHelper().getVillageListByVillageId(villageIdList);
    }else villages= await VillageDataHelper().getTabVillageList();

    mstStates=Global.callSatates(states, lng!);

    if(mstStates.length==1){
      selectedState=mstStates.first;
      mstDistrict=Global.callDistrict(district, lng!,selectedState);
    }
    if(mstDistrict.length==1){
      selectedDistrict=mstDistrict.first;
      mstBlock=Global.callBlocks(block, lng!,selectedDistrict);
    }
    if(mstBlock.length==1){
      selectedBlock=mstBlock.first;
      mstGP=Global.callGramPanchyats(gramPanchayat, lng!,selectedBlock);
    }
    if(mstGP.length==1){
      selectedGramPanchayat=mstGP.first;
      mstVillage=Global.callFiltersVillages(villages, lng!,selectedGramPanchayat);
    }

    setState(() {});
  }


  Future<List<int>> _fetchSpecificElement(List<HouseHoldTabResponceMosdel> hhDataList,String key) async {
    List<int> _specificElementList = [];
    // Parse the JSON data
    for (int i = 0; i < hhDataList.length; i++ ) {
      String response = hhDataList[i].responces!;
      Map<String, dynamic> parsedJson = json.decode(response);

      // Extract the specific element
      int itemName = int.parse(parsedJson[key]);
      if(itemName != null){
        if (!_specificElementList.contains(itemName)) {
          _specificElementList.add(itemName);
        }
      }

    }
    return _specificElementList;
  }

  String callVillageName(String crecheItem) {
    String returnValue = '';
    var items = villagesItemms
        .where((element) =>
    element.name.toString()==Global.getItemValues(crecheItem, 'village_id'))
        .toList();
    if (items.length > 0) {
      returnValue = items[0].value!;
    }
    return returnValue;
  }
}
