import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shishughar/custom_widget/custom_appbar.dart';
import 'package:shishughar/custom_widget/custom_btn.dart';
import 'package:shishughar/custom_widget/custom_text.dart';
import 'package:shishughar/database/helper/block_data_helper.dart';
import 'package:shishughar/database/helper/district_data_helper.dart';
import 'package:shishughar/database/helper/gram_panchayat_data_helper.dart';
import 'package:shishughar/database/helper/state_data_helper.dart';
import 'package:shishughar/database/helper/translation_language_helper.dart';
import 'package:shishughar/database/helper/village_data_helper.dart';
import 'package:shishughar/model/apimodel/translation_language_api_model.dart';
import 'package:shishughar/model/databasemodel/tabBlock_model.dart';
import 'package:shishughar/model/databasemodel/tabDistrict_model.dart';
import 'package:shishughar/model/databasemodel/tabGramPanchayat_model.dart';
import 'package:shishughar/model/databasemodel/tabVillage_model.dart';
import 'package:shishughar/model/databasemodel/tabstate_model.dart';
import 'package:shishughar/screens/dashboardscreen.dart';
import 'package:shishughar/style/styles.dart';
import 'package:shishughar/utils/globle_method.dart';
import 'package:shishughar/utils/validate.dart';

import '../custom_widget/custom_string_dropdown.dart';
import '../database/helper/creche_helper/creche_data_helper.dart';
import '../model/apimodel/creche_database_responce_model.dart';
import 'dashboardscreen_new.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  String? selectedState;
  String? selectedDistrict;
  String? selectedBlock;
  String? selectedGramPanchayat;
  String? selectedVillage;
  String? selectedCrche;


  int? selectedStateID;
  int? selectedDistrictID;
  int? selectedBlockID;
  int? selectedGramPanchayatID;
  int? selectedVillageID;
  int? CrecheIdName;
  String? selectedCrcheID;

  String? lng;

  String? userrole;
  List<String> stateList = [];
  List<String> districtList = [];
  List<String> blockList = [];
  List<String> gramPanchayatList = [];
  List<String> villageList = [];
  List<String> crecheLocationWiseString = [];

  List<TabState> states = [];
  List<TabDistrict> district = [];
  List<TabBlock> block = [];
  List<TabGramPanchayat> gramPanchayat = [];
  List<TabVillage> village = [];
  List<CresheDatabaseResponceModel> crecheLocationWise = [];
  List<Translation> locationControlls = [];

  getuserrole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userrole = prefs.getString(Validate.role);
  }

  @override
  void initState() {
    super.initState();
    initializeData();
    fetchStateList();
    getuserrole();
  }

  Future<void> fetchStateList() async {
    await getInitLocation();
    StateDataHelper databaseHelper = StateDataHelper();
    states = await databaseHelper.getTabStateList();

    states.forEach((element) {
      stateList.add(element.value!);
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (selectedState != null &&
            selectedDistrict != null &&
            selectedBlock != null &&
            selectedGramPanchayat != null &&
            selectedVillage != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => DashboardScreen(
                      index: 0,
                    )),
          );
        } else {
          if (userrole == "CRP") {
            if (selectedGramPanchayat != null) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => DashboardScreen(
                          index: 0,
                        )),
              );
            }
          }
        }
        return true;
      },
      child: Scaffold(
        appBar: CustomAppbar(
          text: (lng != null)
              ? Global.returnTrLable(
                  locationControlls, CustomText.checkIN, lng!)
              : '',
          onTap: () {
            if (selectedState != null &&
                selectedDistrict != null &&
                selectedBlock != null &&
                selectedGramPanchayat != null &&
                selectedVillage != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DashboardScreen(
                          index: 0,
                        )),
              );
            } else {
              if (userrole == "CRP") {
                if (selectedGramPanchayat != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DashboardScreen(
                              index: 0,
                            )),
                  );
                }
              }
            }
          },
        ),
        body: (lng != null)
            ? SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10.h),
                      Text(
                        (lng != null)
                            ? Global.returnTrLable(
                                locationControlls, CustomText.checkIN, lng!)
                            : '',
                        style: Styles.red145,
                      ),
                      SizedBox(height: 10.h),
                      CustomDropdownFieldString(
                        titleText: Global.returnTrLable(
                            locationControlls, CustomText.state, lng!),
                        items: stateList,
                        isRequred: 1,
                        selectedItem: selectedState,
                        onChanged: (value) async {
                          selectedState = value;
                          selectedDistrict = null;
                          selectedBlock = null;
                          selectedGramPanchayat = null;
                          selectedVillage = null;
                          selectedStateID = states
                              .firstWhere(
                                  (element) => element.value == selectedState)
                              .name;
                          DistrictDataHelper districtdata =
                              DistrictDataHelper();
                          List<TabDistrict> tempdistrict =
                              await districtdata.getTabDistrictList();
                          district = tempdistrict
                              .where((element) =>
                                  element.stateId == selectedStateID.toString())
                              .toList();
                          districtList.clear();
                          district.forEach((element) {
                            districtList.add(element.value!);
                          });
                          setState(() {
                            // Update districtList based on selectedState
                            // districtList = // data from database based on selectedState;
                          });
                        },
                      ),
                      CustomDropdownFieldString(
                        titleText: Global.returnTrLable(
                            locationControlls, CustomText.District, lng!),
                        items: districtList,
                        isRequred: 1,
                        selectedItem: selectedDistrict,
                        onChanged: (value) async {
                          selectedDistrict = value;
                          selectedBlock = null;
                          selectedGramPanchayat = null;
                          selectedVillage = null;
                          selectedDistrictID = district
                              .firstWhere((element) =>
                                  element.value == selectedDistrict)
                              .name;
                          BlockDataHelper blockdata = BlockDataHelper();
                          block = await blockdata.getTabBlockList();
                          block = block
                              .where((element) =>
                                  element.districtId ==
                                  selectedDistrictID.toString())
                              .toList();
                          blockList.clear();
                          block.forEach((element) {
                            blockList.add(element.value!);
                          });
                          setState(() {
                            // Update blockList based on selectedDistrict
                            // blockList = // data from database based on selectedDistrict;
                          });
                        },
                      ),
                      CustomDropdownFieldString(
                        titleText: Global.returnTrLable(
                            locationControlls, CustomText.Block, lng!),
                        items: blockList,
                        isRequred: 1,
                        selectedItem: selectedBlock,
                        onChanged: (value) async {
                          selectedBlock = value;
                          selectedGramPanchayat = null;
                          selectedVillage = null;
                          selectedBlockID = block
                              .firstWhere(
                                  (element) => element.value == selectedBlock)
                              .name;
                          GramPanchayatDataHelper gramPanchayatdata =
                              GramPanchayatDataHelper();
                          gramPanchayat =
                              await gramPanchayatdata.getTabGramPanchayatList();
                          gramPanchayat = gramPanchayat
                              .where((element) =>
                                  element.blockId == selectedBlockID.toString())
                              .toList();
                          gramPanchayatList.clear();
                          gramPanchayat.forEach((element) {
                            gramPanchayatList.add(element.value!);
                          });
                          setState(() {
                            // Update gramPanchayatList based on selectedBlock
                            // gramPanchayatList = // data from database based on selectedBlock;
                          });
                        },
                      ),
                      CustomDropdownFieldString(
                        isRequred: 1,
                        titleText: Global.returnTrLable(
                            locationControlls, CustomText.GramPanchayat, lng!),
                        items: gramPanchayatList,
                        selectedItem: selectedGramPanchayat,
                        onChanged: (value) async {
                          selectedGramPanchayat = value;
                          selectedVillage = null;
                          selectedGramPanchayatID = gramPanchayat
                              .firstWhere((element) =>
                                  element.value == selectedGramPanchayat)
                              .name;
                          VillageDataHelper villagetdata = VillageDataHelper();
                          village = await villagetdata.getTabVillageList();
                          village = village
                              .where((element) =>
                                  element.gpId ==
                                  selectedGramPanchayatID.toString())
                              .toList();
                          villageList.clear();
                          village.forEach((element) {
                            villageList.add(element.value!);
                          });
                          setState(() {
                            // Update villageList based on selectedGramPanchayat
                            // villageList = // data from database based on selectedGramPanchayat;
                          });
                        },
                      ),
                      userrole == "CRP"
                          ? SizedBox()
                          : Column(
                              children: [
                                CustomDropdownFieldString(
                                  titleText: Global.returnTrLable(
                                      locationControlls,
                                      CustomText.Village,
                                      lng!),
                                  isRequred: 1,
                                  items: villageList,
                                  selectedItem: selectedVillage,
                                  onChanged: (value) async {
                                    selectedVillage = value;
                                    selectedCrche=null;
                                    selectedCrcheID=null;
                                    selectedVillageID = village
                                        .firstWhere((element) =>
                                            (element.value == selectedVillage &&
                                                element.gpId ==
                                                    selectedGramPanchayatID
                                                        .toString()))
                                        .name;
                                    crecheLocationWise = await CrecheDataHelper().getCrecheResponce();
                                    crecheLocationWise= crecheLocationWise.where((element) =>
                                    Global.getItemValues(element.responces!,'village_id')==selectedVillageID.toString()).toList();
                                    crecheLocationWiseString.clear();
                                    crecheLocationWise.forEach((element) {
                                      crecheLocationWiseString
                                          .add(Global.getItemValues(element.responces!, 'creche_name'));
                                      if(selectedCrcheID!=null){
                                        if(Global.getItemValues(element.responces!, 'creche_id')==selectedCrcheID){
                                          selectedCrche=Global.getItemValues(element.responces!, 'creche_name');
                                        }
                                      }
                                    });
                                    setState(() {});
                                  },
                                ),
                                CustomDropdownFieldString(
                                  titleText: Global.returnTrLable(
                                      locationControlls,
                                      CustomText.Creches,
                                      lng!),
                                  isRequred: checkMendotoryCreche(),
                                  items: crecheLocationWiseString,
                                  selectedItem: selectedCrche,
                                  onChanged: (value) {
                                    selectedCrche = value;
                                 var selecteCrecheItem=    crecheLocationWise
                                        .firstWhere((element) =>
                                     (Global.getItemValues(element.responces!, 'creche_name') == selectedCrche));
                                    selectedCrcheID=Global.getItemValues(selecteCrecheItem.responces!, 'creche_id');
                                    CrecheIdName=selecteCrecheItem.name;
                                    setState(() {});
                                  },
                                )
                              ],
                            ),
                      SizedBox(height: 30.h),
                      CElevatedButton(
                        onPressed: () async {
                          if (selectedState == null) {
                            Validate().singleButtonPopup(
                                Global.returnTrLable(locationControlls, CustomText.plSelect_state, lng!),
                                Global.returnTrLable(locationControlls, CustomText.ok, lng!),
                                false,
                                context);
                          } else if (selectedDistrict == null) {
                            Validate().singleButtonPopup(
                                Global.returnTrLable(locationControlls, CustomText.plSelect_district, lng!),
                                Global.returnTrLable(locationControlls, CustomText.ok, lng!),
                                false,
                                context);
                          } else if (selectedBlock == null) {
                            Validate().singleButtonPopup(
                                Global.returnTrLable(locationControlls, CustomText.plSelect_block, lng!),
                                Global.returnTrLable(locationControlls, CustomText.ok, lng!),
                                false,
                                context);
                          } else if (selectedGramPanchayat == null) {
                            Validate().singleButtonPopup(
                                Global.returnTrLable(locationControlls, CustomText.plSelect_geamPanchayat, lng!),
                                Global.returnTrLable(locationControlls, CustomText.ok, lng!),
                                false,
                                context);
                          } else if (selectedVillage == null) {
                            if (userrole == 'CRP') {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setString(Validate.state, selectedState!);
                              prefs.setString(
                                  Validate.district, selectedDistrict!);
                              prefs.setString(Validate.block, selectedBlock!);
                              prefs.setString(Validate.gramPanchayat,
                                  selectedGramPanchayat!);

                              prefs.setInt(Validate.stateID, selectedStateID!);
                              prefs.setInt(
                                  Validate.districtID, selectedDistrictID!);
                              prefs.setInt(Validate.blockID, selectedBlockID!);

                              gramPanchayat.forEach((element) {
                                if (element.value == selectedGramPanchayat) {
                                  prefs.setInt(
                                      Validate.panchayatId, element.name!);
                                }
                              });
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DashboardScreen(
                                      index: 0,
                                    ),
                                  ));
                            }
                            else {
                              Validate().singleButtonPopup(
                                  Global.returnTrLable(locationControlls, CustomText.plSelect_village, lng!),
                                  Global.returnTrLable(locationControlls, CustomText.ok, lng!),
                                  false,
                                  context);
                            }
                          }
                           else if (selectedCrche == null) {
                            if (checkMendotoryCreche()==0) {
                              SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                              prefs.setString(Validate.state, selectedState!);
                              prefs.setString(
                                  Validate.district, selectedDistrict!);
                              prefs.setString(Validate.block, selectedBlock!);
                              prefs.setString(
                                  Validate.gramPanchayat, selectedGramPanchayat!);
                              prefs.setString(Validate.village, selectedVillage!);

                              prefs.setInt(Validate.stateID, selectedStateID!);
                              prefs.setInt(
                                  Validate.districtID, selectedDistrictID!);
                              prefs.setInt(Validate.blockID, selectedBlockID!);
                              prefs.setInt(Validate.gramPanchayatID,
                                  selectedGramPanchayatID!);
                              await prefs.remove(Validate.CrcheID);
                              await prefs.remove(Validate.CrecheIdName);
                              await prefs.remove(Validate.CrecheSName);
                              village.forEach((element) {
                                if (element.value == selectedVillage &&
                                    element.gpId ==
                                        selectedGramPanchayatID.toString()) {
                                  prefs.setInt(Validate.villageId, element.name!);
                                }
                              });
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DashboardScreen(
                                      index: 0,
                                    ),
                                  ));
                            }
                            else {
                              Validate().singleButtonPopup(
                                  Global.returnTrLable(locationControlls, CustomText.plSelect_creche, lng!),
                                  Global.returnTrLable(locationControlls, CustomText.ok, lng!),
                                  false,
                                  context);
                            }
                          }
                          else {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.setString(Validate.state, selectedState!);
                            prefs.setString(
                                Validate.district, selectedDistrict!);
                            prefs.setString(Validate.block, selectedBlock!);
                            prefs.setString(
                                Validate.gramPanchayat, selectedGramPanchayat!);
                            prefs.setString(Validate.village, selectedVillage!);

                            prefs.setInt(Validate.stateID, selectedStateID!);
                            prefs.setInt(
                                Validate.districtID, selectedDistrictID!);
                            prefs.setInt(Validate.blockID, selectedBlockID!);
                            prefs.setInt(Validate.gramPanchayatID,
                                selectedGramPanchayatID!);
                            prefs.setString(Validate.CrcheID, selectedCrcheID!);
                            prefs.setInt(Validate.CrecheIdName, CrecheIdName!);
                            prefs.setString(Validate.CrecheSName, selectedCrche!);

                            village.forEach((element) {
                              if (element.value == selectedVillage &&
                                  element.gpId ==
                                      selectedGramPanchayatID.toString()) {
                                prefs.setInt(Validate.villageId, element.name!);
                              }
                            });

                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DashboardScreen(
                                    index: 0,
                                  ),
                                ));
                          }
                        },
                        text: Global.returnTrLable(
                            locationControlls, CustomText.checkIN, lng!),
                      )
                    ],
                  ),
                ),
              )
            : SizedBox(),
      ),
    );
  }

  getInitLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    selectedState = prefs.getString(Validate.state);
    selectedDistrict = prefs.getString(Validate.district);
    selectedBlock = prefs.getString(Validate.block);
    selectedGramPanchayat = prefs.getString(Validate.gramPanchayat);
    selectedVillage = prefs.getString(Validate.village);
    selectedVillageID = prefs.getInt(Validate.villageId);
    selectedCrcheID = prefs.getString(Validate.CrcheID);
    CrecheIdName = prefs.getInt(Validate.CrecheIdName);

    if (selectedState != null) {
      // Update districtList based on selectedState
      StateDataHelper databaseHelper = StateDataHelper();
      List<TabState> tempstate = await databaseHelper.getTabStateList();
      selectedStateID = tempstate
          .firstWhere((element) => element.value == selectedState)
          .name;

      DistrictDataHelper districtdata = DistrictDataHelper();
      List<TabDistrict> tempdistrict = await districtdata.getTabDistrictList();
      district = tempdistrict
          .where((element) => element.stateId == selectedStateID.toString())
          .toList();
      districtList.clear();
      district.forEach((element) {
        districtList.add(element.value!);
      });
    }

    if (selectedDistrict != null) {
      // Update blockList based on selectedDistrict
      selectedDistrictID = district
          .firstWhere((element) => element.value == selectedDistrict)
          .name;
      BlockDataHelper blockdata = BlockDataHelper();
      block = await blockdata.getTabBlockList();
      block = block
          .where(
              (element) => element.districtId == selectedDistrictID.toString())
          .toList();
      blockList.clear();
      block.forEach((element) {
        blockList.add(element.value!);
      });
    }

    if (selectedBlock != null) {
      // Update gramPanchayatList based on selectedBlock
      selectedBlockID =
          block.firstWhere((element) => element.value == selectedBlock).name;
      GramPanchayatDataHelper gramPanchayatdata = GramPanchayatDataHelper();
      gramPanchayat = await gramPanchayatdata.getTabGramPanchayatList();
      gramPanchayat = gramPanchayat
          .where((element) => element.blockId == selectedBlockID.toString())
          .toList();
      gramPanchayatList.clear();
      gramPanchayat.forEach((element) {
        gramPanchayatList.add(element.value!);
      });
    }

    if (selectedGramPanchayat != null) {
      // Update villageList based on selectedGramPanchayat
      selectedGramPanchayatID = gramPanchayat
          .firstWhere((element) => element.value == selectedGramPanchayat)
          .name;
      VillageDataHelper villagetdata = VillageDataHelper();
      village = await villagetdata.getTabVillageList();
      village = village
          .where(
              (element) => element.gpId == selectedGramPanchayatID.toString())
          .toList();
      villageList.clear();
      village.forEach((element) {
        villageList.add(element.value!);
      });
    }

    if (selectedVillageID != null) {
      // Update creche based on selected Village wise
      selectedGramPanchayatID = gramPanchayat
          .firstWhere((element) => element.value == selectedGramPanchayat)
          .name;
      crecheLocationWise = await CrecheDataHelper().getCrecheResponce();
      crecheLocationWise= crecheLocationWise.where((element) =>
      Global.getItemValues(element.responces!,'village_id')==selectedVillageID.toString()).toList();
      crecheLocationWiseString.clear();
      crecheLocationWise.forEach((element) {
        crecheLocationWiseString
            .add(Global.getItemValues(element.responces!, 'creche_name'));
        if(selectedCrcheID!=null){
          if(Global.getItemValues(element.responces!, 'creche_id')==selectedCrcheID){
            selectedCrche=Global.getItemValues(element.responces!, 'creche_name');
          }
        }
      });

    }

    // setState(() {});
  }

  Future<void> initializeData() async {
    lng = await Validate().readString(Validate.sLanguage);
    /*role = await Validate().readString(Validate.role);*/
    List<String> valueNames = [
      CustomText.checkIN,
      CustomText.state,
      CustomText.District,
      CustomText.Block,
      CustomText.GramPanchayat,
      CustomText.Village,
      CustomText.plSelect_state,
      CustomText.plSelect_district,
      CustomText.plSelect_block,
      CustomText.plSelect_geamPanchayat,
      CustomText.plSelect_village,
      CustomText.Creches,
      CustomText.plSelect_creche,
      CustomText.ok
    ];
    await TranslationDataHelper()
        .callTranslateString(valueNames)
        .then((value) => locationControlls = value);

    setState(() {});
  }

  int checkMendotoryCreche(){
      if(selectedVillageID!=null && selectedGramPanchayatID!=null){
        var items=crecheLocationWise.where((element) => 
        Global.getItemValues(element.responces!, 'gp_id')==selectedGramPanchayatID.toString() &&
            Global.getItemValues(element.responces!, 'village_id')==selectedVillageID.toString()
        ).toList();
        if(items.length>0){
          return 1;
        }
      }
      return 0;
  }
}

// var dislist =  DatabaseHelper.database!.rawQuery('SELECT * FROM TABLE tabGender Whare state_id=$stateId;');
