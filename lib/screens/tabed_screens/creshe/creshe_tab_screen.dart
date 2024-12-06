import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shishughar/database/helper/translation_language_helper.dart';
import 'package:shishughar/model/apimodel/creche_database_responce_model.dart';
import 'package:shishughar/model/apimodel/translation_language_api_model.dart';
import 'package:shishughar/utils/intent_utils.dart';
import 'package:shishughar/utils/validate.dart';
import 'package:shishughar/custom_widget/custom_text.dart';
import 'package:shishughar/database/helper/creche_data_helper.dart';
import 'package:shishughar/model/apimodel/house_hold_field_item_model_api.dart';
import 'package:shishughar/style/styles.dart';
import 'package:shishughar/utils/globle_method.dart';

import '../../../database/helper/creche_helper/creche_data_helper.dart';
import 'creche_care_givers.dart';
import 'creche_screen_item.dart';

class CresheTabScreen extends StatefulWidget {
  final int name;
  final String crechedCode;
  final bool isUpdate;
  CresheTabScreen(
      {super.key,
      required this.name,
      required this.crechedCode,
      required this.isUpdate});

  @override
  _CresheTabScreenState createState() => _CresheTabScreenState();
}

class _CresheTabScreenState extends State<CresheTabScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int tabIndex = 0;
  List<Widget> tabTitleItem = [];
  List<HouseHoldFielItemdModel> tabBreakItems = [];
  Map<String, List<HouseHoldFielItemdModel>> itemScreenItems = {};
  bool _isLoading = true;
  String? role;
  String? lng;
  List<Translation> labelControlls = [];
  double? lat;
  double? long;
  double screenWidth = 0.0;
  double tabWidth = 100.0; // Approximate width of each tab
  bool tabIsScrollable = false;

  @override
  void initState() {
    super.initState();
    callScrenControllers(CustomText.Creches);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    } else {
      return WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, 'itemRefresh');
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 40,
            backgroundColor: Color(0xff5979AA),
            leading: Padding(
              padding: EdgeInsets.only(left: 10),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context, 'itemRefresh');
                },
                child: Icon(
                  Icons.arrow_back_ios_sharp,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: InkWell(
                  onTap: () async {
                    if (lat != null && long != null) {
                      await IntentUtils.launchGoogleMaps(lat!, long!);
                    } else {
                      Validate().singleButtonPopup(
                          Global.returnTrLable(labelControlls,
                              CustomText.locationNotAvailable, lng!),
                          Global.returnTrLable(
                              labelControlls, CustomText.ok, lng!),
                          false,
                          context);
                    }
                  },
                  child: Icon(
                    lat != null && long != null
                        ? Icons.place
                        : Icons.place_outlined,
                    color: Colors.white,
                  ),
                ),
              )
            ],
            title: Text(
              lng != null
                  ? Global.returnTrLable(
                      labelControlls, CustomText.CrecheProfileView, lng!)
                  : "",
              style: Styles.white145,
            ),
            centerTitle: true,
            bottom: _isLoading
                ? null
                : TabBar(
                    indicatorColor: Color(0xffF26BA3),
                    unselectedLabelColor: Colors.grey.shade300,
                    unselectedLabelStyle: Styles.white124P,
                    labelColor: Colors.white,
                    controller: _tabController,
                    isScrollable: tabIsScrollable,
                    labelPadding: EdgeInsets.zero,
                    // tabAlignment: TabAlignment.start,
                    tabAlignment: tabIsScrollable ? TabAlignment.start : null,
                    tabs: tabTitleItem,
                    onTap: (index) {
                      if (_tabController.indexIsChanging) {
                        _tabController.index = _tabController.previousIndex;

                        handleTabChange(index, _tabController.previousIndex);
                      } else {
                        print("object 1 $index");
                        return;
                      }
                    },
                  ),
          ),
          body: Column(
            children: [
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  physics: NeverScrollableScrollPhysics(),
                  children: tabControllerScreen(),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Future<void> callScrenControllers(screen_type) async {
    List<HouseHoldFielItemdModel> allItems = [];
    List<HouseHoldFielItemdModel> tempBreakDown = [];
    role = await Validate().readString(Validate.role);
    await CrecheFieldHelper()
        .getCrecheFieldsForm(screen_type)
        .then((value) async {
      allItems = value;
      tabBreakItems = allItems
          .where((element) => element.fieldtype == 'Tab Break')
          .toList();
    });

    for (int i = 0; i < tabBreakItems.length; i++) {
      List<HouseHoldFielItemdModel> temp = [];
      int idxI = tabBreakItems[i].idx!;
      idxI = idxI + 1;
      temp = allItems
          .where(
              (element) => element.fieldtype == 'Table' && element.idx == idxI)
          .toList();
      if (temp.length > 0) {
        tempBreakDown.add(tabBreakItems[i]);
      }
    }

    tempBreakDown.forEach((element) {
      tabBreakItems.remove(element);
    });

    // for children

    print("expendedItemsItem ${tabBreakItems}");
    for (int i = 0; i < tabBreakItems.length; i++) {
      if (i < (tabBreakItems.length) - 1) {
        var filtredItem = allItems
            .where((element) =>
                element.idx! > tabBreakItems[i].idx! &&
                element.idx! < tabBreakItems[i + 1].idx!)
            .toList();
        itemScreenItems[tabBreakItems[i].name!] = filtredItem;
      } else {
        var filtredItem = allItems
            .where((element) => element.idx! > tabBreakItems[i].idx!)
            .toList();
        itemScreenItems[tabBreakItems[i].name!] = filtredItem;
      }
    }
    if (tempBreakDown.length > 0) {
      var chil = tempBreakDown
          .where((element) => element.fieldname == 'caregiver_details')
          .toList();
      if (chil.length > 0) {
        tabBreakItems.add(chil[0]);
      }
    }

    await tabController();
    _tabController = TabController(length: tabBreakItems.length, vsync: this);
    tabIsScrollable = tabWidth * tabBreakItems.length > screenWidth;

    // _tabController.addListener(handleTabChange);
    await fetchLatLong();
    await setLabelTextData();
    setState(() {
      _isLoading = false;
    });
  }

  Future tabController() async {
    tabBreakItems.forEach((element) async {
      lng = await Validate().readString(Validate.sLanguage);
      var verifiLable =
          await TranslationDataHelper().getTranslation(element.label!, lng!);
      tabTitleItem.add(Container(
        width: tabIsScrollable ? null : screenWidth / tabBreakItems.length,
        // padding: EdgeInsets.only(left: 10, right: 10),
        padding: EdgeInsets.only(
            left: tabIsScrollable ? 10 : 0, right: tabIsScrollable ? 10 : 0),
        decoration: BoxDecoration(
            color: Color(0xff369A8D),
            border: Border(
                right: BorderSide(
                    color: Colors.white, width: 1, style: BorderStyle.solid))),
        child: Tab(child: Text(verifiLable)),
      ));
    });
  }

  List<Widget> tabControllerScreen() {
    List<Widget> tabItem = [];
    for (int i = 0; i < tabBreakItems.length; i++) {
      if (tabBreakItems[i].fieldname == 'caregiver_details') {
        tabItem.add(CrecheCareGivers(
          parentName: widget.name,
          crechedCode: widget.crechedCode,
        ));
      } else {
        tabItem.add(CrecheScreenItem(
            name: widget.name,
            isUpdate: widget.isUpdate,
            tabBreakItem: tabBreakItems[i],
            screenItem: itemScreenItems,
            changeTab: changeTab,
            tabIndex: i,
            totalTab: tabBreakItems.length));
      }
    }

    return tabItem;
  }

  void changeTab(int index) {
    if (index == 0) {
      if (tabIndex > 0) {
        setState(() {
          tabIndex--;
          _tabController.animateTo(tabIndex);
        });
      }
    } else if (tabIndex < tabBreakItems.length) {
      setState(() {
        tabIndex++;
        _tabController.animateTo(tabIndex);
      });
    }
  }

  Future<void> setLabelTextData() async {
    lng = await Validate().readString(Validate.sLanguage);
    List<String> valueNames = [
      CustomText.CrecheProfileView,
      CustomText.location,
      CustomText.ok
    ];
    // tabBreakItems.forEach((element){
    //   valueNames.add(element.label!);
    // });
    await TranslationDataHelper()
        .callTranslateString(valueNames)
        .then((value) => labelControlls = value);
  }

  void handleTabChange(int index, int previus) async {
    // bool shouldChangeTab =
    await checkConditionsBeforeChangingTab(index).then((value) {
      if (value) {
        tabIndex = index;
        setState(() {
          _tabController.index = tabIndex;
        });
      }
      // Navigator.pop(context);
    });
    // if (!shouldChangeTab) {
    //   // If conditions are not met, revert back to the previous tab index
    //   _tabController.index = tabIndex;
    //   // setState(() {
    //   //   _tabController.index = tabIndex;
    //   // });
    // }
    // else {
    //   // If conditions are met, update the tabIndex
    //   tabIndex = _tabController.index;
    //
    // }
    // setState(() {});
  }

  Future<bool> checkConditionsBeforeChangingTab(int index) async {
    bool returnStatus = false;
    if (index == 1) {
      var alredRecord =
          await CrecheDataHelper().getCrecheResponceItem(widget.name);
      if (alredRecord.isNotEmpty) {
        Map<String, dynamic> responseData =
            jsonDecode(alredRecord[0].responces!);
        var items = itemScreenItems[itemScreenItems.keys.first];
        if (items != null && items.isNotEmpty) {
          for (int i = 0; i < items.length; i++) {
            if (responseData.containsKey(items[i].fieldname)) {
              print("Condition met for tab $index");
              returnStatus = true;
              break;
            }
          }
        }
      }
    } else
      returnStatus = true;

    // if (alredRecord.isNotEmpty) {
    //   Map<String, dynamic> responseData = jsonDecode(alredRecord[0].responces!);
    //   var items = itemScreenItems[tabBreakItems[index].name];
    //   if (items != null && items.isNotEmpty) {
    //     for (int i = 0; i < items.length; i++) {
    //       if (responseData.containsKey(items[i].fieldname)) {
    //         print("Condition met for tab $index");
    //         returnStatus = true;
    //         break;
    //       }
    //     }
    //   }
    //   if(!returnStatus) {
    //     var nextco = (_tabController.index + 1);
    //     if (nextco == index) {
    //       var items = itemScreenItems[tabBreakItems[_tabController.index].name];
    //       for (int i = 0; i < items!.length; i++) {
    //         if (responseData.containsKey(items[i].fieldname)) {
    //           print("Condition met for tab $index");
    //           returnStatus = true;
    //           break;
    //         }
    //       }
    //     }
    //   }
    // }else returnStatus= true;
    // Return false if conditions are not met
    return returnStatus;
  }

  Future<void> fetchLatLong() async {
    List<CresheDatabaseResponceModel> crecheRecord =
        await CrecheDataHelper().getCrecheResponceItem(widget.name);
    if (crecheRecord.isNotEmpty) {
      lat = Global.stringToDouble(
          Global.getItemValues(crecheRecord.first.responces, 'latitude'));
      long = Global.stringToDouble(
          Global.getItemValues(crecheRecord.first.responces, 'longitude'));
    }
  }
}
