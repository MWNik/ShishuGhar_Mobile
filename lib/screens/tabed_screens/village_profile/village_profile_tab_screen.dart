import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shishughar/custom_widget/custom_text.dart';
import 'package:shishughar/database/helper/translation_language_helper.dart';
import 'package:shishughar/database/helper/village_profile/village_profiile_fileds_helper.dart';
import 'package:shishughar/database/helper/village_profile/village_profile_response_helper.dart';
import 'package:shishughar/model/apimodel/translation_language_api_model.dart';
import 'package:shishughar/screens/tabed_screens/village_profile/village_profile_demografical/vilage-profile_demografical_listing_screen.dart';
import 'package:shishughar/utils/validate.dart';
import '../../../model/apimodel/form_logic_api_model.dart';
import '../../../model/apimodel/house_hold_field_item_model_api.dart';
import '../../../model/dynamic_screen_model/options_model.dart';
import '../../../style/styles.dart';
import '../../../utils/globle_method.dart';
import 'village_profile_tabItem_screen.dart';
// import 'enrolled_chilren_tab_item.dart';

class VillageProfileTabScreen extends StatefulWidget {
  final int name;
  final bool isEditable;

  const VillageProfileTabScreen({
    super.key,
    required this.name,
    required this.isEditable,
  });

  @override
  _VillageProfileTabScreenState createState() =>
      _VillageProfileTabScreenState();
}

class _VillageProfileTabScreenState extends State<VillageProfileTabScreen>
    with TickerProviderStateMixin {
  bool _isLoading = true;
  String? saveNext = CustomText.Next;
  List<HouseHoldFielItemdModel> tabBreakItems = [];
  late TabController _tabController;
  List<OptionsModel> options = [];
  int tabIndex = 0;
  Map<String, List<HouseHoldFielItemdModel>> expendedItems = {};
  List<TabFormsLogic> logics = [];
  Map<String, dynamic> myMap = {};
  List<Translation> translatsLabel = [];
  void Function()? ontap;
  String lng = "en";
  String? role;
  double screenWidth = 0.0;
  double tabWidth = 100.0; // Approximate width of each tab
  bool tabIsScrollable = false;

  Future<void> initializeData() async {
    lng = (await Validate().readString(Validate.sLanguage))!;
    role = (await Validate().readString(Validate.role))!;
    translatsLabel.clear();
    List<String> valueNames = [
      CustomText.Save,
      CustomText.Creches,
      CustomText.CrecheCaregiver,
      CustomText.Next,
      CustomText.back,
      CustomText.villageProfile
    ];
    await TranslationDataHelper()
        .callTranslateString(valueNames)
        .then((value) => translatsLabel = value);

    await TranslationDataHelper()
        .callTranslateEnrolledChildren()
        .then((value) => translatsLabel.addAll(value));
    await callScrenControllers();
  }

  @override
  Widget build(BuildContext context) {
    Global.applyDisplayCutout(Color(0xff5979AA));
    screenWidth = MediaQuery.of(context).size.width;
    if (_isLoading) {
      return Container(
          color: Colors.white,
          child: Center(child: CircularProgressIndicator()));
    } else {
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 60,
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
            title: Text(
                Global.returnTrLable(
                    translatsLabel, CustomText.villageProfile, lng),
                style: Styles.white145),
            // actions: [
            //   (role == 'Cluster Coordinator')
            //       ? GestureDetector(
            //           onTap: () async {
            //             await updateVerificationStatus(context);
            //           },
            //           child: Image.asset(
            //             "assets/verify_icon.png",
            //             scale: 1.5,
            //           ),
            //         )
            //       : SizedBox(),
            //   SizedBox(
            //     width: 10,
            //   )
            // ],
            centerTitle: true,
            bottom: TabBar(
              indicatorColor: Color(0xffF26BA3),
              unselectedLabelColor: Colors.grey.shade300,
              unselectedLabelStyle: Styles.white124P,
              labelColor: Colors.white,
              controller: _tabController,
              isScrollable: tabIsScrollable,
              labelPadding: EdgeInsets.zero,
              // tabAlignment: TabAlignment.start,
              tabAlignment: tabIsScrollable ? TabAlignment.start : null,
              onTap: (index) {
                if (_tabController.indexIsChanging) {
                  _tabController.index = _tabController.previousIndex;
                  print("object $index");
                  handleTabChange(index);
                } else {
                  print("object 1 $index");
                  return;
                }
              },

              tabs: tabController(),
            ),
          ),
          body: Column(children: [
            Expanded(
                child: TabBarView(
              controller: _tabController,
              physics: NeverScrollableScrollPhysics(),
              children: tabControllerScreen(),
            ))
          ]),
        ),
      );
    }
  }

  List<Widget> tabControllerScreen() {
    List<Widget> tabItem = [];
    for (int i = 0; i < tabBreakItems.length; i++) {
      if (tabBreakItems[i].fieldname != 'demographical_profile') {
        tabItem.add(VillageProfileTbaItem(
            vName: widget.name,
            isEditable: widget.isEditable,
            tabBreakItem: tabBreakItems[i],
            screenItem: expendedItems,
            changeTab: changeTab,
            tabIndex: i,
            totalTab: tabBreakItems.length));
      } else {
        tabItem.add(DemograficalListingScreen(
            vName: widget.name, isEditable: widget.isEditable));
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
        if (!(tabIndex == (tabBreakItems.length - 1))) {
          tabIndex++;
          _tabController.animateTo(tabIndex);
        }
      });
    }
  }

  int getCurrentTab() {
    return tabIndex;
  }

  List<Widget> tabController() {
    List<Widget> tabItem = [];
    tabBreakItems.forEach((element) {
      tabItem.add(Container(
        width: tabIsScrollable ? null : screenWidth / tabBreakItems.length,
        // padding: EdgeInsets.only(left: 10, right: 10),
        padding: EdgeInsets.only(
            left: tabIsScrollable ? 10 : 0, right: tabIsScrollable ? 10 : 0),
        decoration: BoxDecoration(
            color: Color(0xff369A8D),
            border: Border(
                right: BorderSide(
                    color: Colors.white, width: 1, style: BorderStyle.solid))),
        child: Tab(
            child: Text(
          Global.returnTrLable(translatsLabel, element.label!, lng),
        )),
      ));
    });
    return tabItem;
  }

  // Future<void> calinitialScreen() async {
  //   await callScrenControllers();
  //   setState(() {
  //     _isLoading = false;
  //   });
  // }

  Future<void> callScrenControllers() async {
    List<HouseHoldFielItemdModel> allItems = [];
    var lngtr = await Validate().readString(Validate.sLanguage);
    if (lngtr != null) {
      lng = lngtr;
    }
    List<HouseHoldFielItemdModel> tempBreakDown = [];
    await VillageProfileFieldsHelper()
        .getVillageProfilebyParent('Village')
        .then((value) async {
      allItems = value;
      tabBreakItems = allItems
          .where((element) => element.fieldtype == CustomText.tabBreak)
          .toList();
    });

    for (int i = 0; i < tabBreakItems.length; i++) {
      // List<HouseHoldFielItemdModel> temp = [];
      // int idxI = tabBreakItems[i].idx!;
      // idxI = idxI + 1;
      // temp = allItems
      //     .where(
      //         (element) => element.fieldtype == 'Table' && element.idx == idxI)
      //     .toList();
      // if (temp.length > 0) {
      // if (!(tabBreakItems[i].fieldname == 'demographical_profile'))
      tempBreakDown.add(tabBreakItems[i]);
      // }
    }

    // tempBreakDown.forEach((element) {
    //   tabBreakItems.remove(element);
    // });

    // for children

    print("expendedItemsItem ${tabBreakItems}");
    for (int i = 0; i < tabBreakItems.length; i++) {
      if (tabBreakItems[i].fieldname == 'demographical_profile') {
        var filtredItem = allItems
            .where((element) => element.parent! == 'Demographic Details')
            .toList();
        expendedItems[tabBreakItems[i].name!] = filtredItem;
      } else {
        if (i < (tabBreakItems.length) - 1) {
          var filtredItem = allItems
              .where((element) =>
                  element.idx! > tabBreakItems[i].idx! &&
                  element.idx! < tabBreakItems[i + 1].idx!)
              .toList();
          expendedItems[tabBreakItems[i].name!] = filtredItem;
        } else {
          var filtredItem = allItems
              .where((element) => element.idx! > tabBreakItems[i].idx!)
              .toList();
          expendedItems[tabBreakItems[i].name!] = filtredItem;
        }
      }
    }

    _tabController = TabController(length: tabBreakItems.length, vsync: this);
    tabIsScrollable = tabWidth * tabBreakItems.length > screenWidth;

    // _tabController.addListener(handleTabChange);
    List<String> tabLabelItems = [];
    tabBreakItems.forEach((element) {
      if (Global.validString(element.label)) {
        tabLabelItems.add(element.label!);
      }
    });
    await TranslationDataHelper()
        .callTranslateString(tabLabelItems)
        .then((value) => translatsLabel.addAll(value));
    tabWidth = 0;
    for (int i = 0; i < tabBreakItems.length; i++) {
      final textPainter = TextPainter(
        text: TextSpan(
            text: Global.returnTrLable(
                translatsLabel, tabBreakItems[i].label!, lng),
            style: Styles.white124P),
        maxLines: 1, // Single line text
        textDirection: TextDirection.ltr,
      );

      // Layout the text (this step is required to calculate the width)
      textPainter.layout();
      double textWidth = textPainter.width + 20;
      tabWidth = tabWidth + textWidth;
      print(textWidth);
    }
    screenWidth = MediaQuery.of(context).size.width;
    // tabIsScrollable = tabWidth * tabBreakItems.length >= screenWidth;
    tabIsScrollable = tabWidth > screenWidth;

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<bool> checkConditionsBeforeChangingTab(int index) async {
    bool returnStatus = false;
    var alredRecord = await VillageProfileResponseHelper()
        .getVillageProfilebyName(widget.name);
    if (alredRecord.isNotEmpty) {
      Map<String, dynamic> responseData = jsonDecode(alredRecord[0].responces!);
      // EnrolledChilrenTab.childName=responseData['child_name'];
      var items = expendedItems[tabBreakItems[index].name];
      if (items != null && items.isNotEmpty) {
        for (int i = 0; i < items.length; i++) {
          if (responseData.containsKey(items[i].fieldname)) {
            print("Condition met for tab $index");
            returnStatus = true;
            break;
          }
        }
      }
      if (!returnStatus) {
        var nextco = (_tabController.index + 1);
        if (nextco == index) {
          var items = expendedItems[tabBreakItems[_tabController.index].name];
          for (int i = 0; i < items!.length; i++) {
            if (responseData.containsKey(items[i].fieldname)) {
              print("Condition met for tab $index");
              returnStatus = true;
              break;
            }
          }
        }
      }
    }
    // Return false if conditions are not met
    return returnStatus;
  }

  void handleTabChange(int index) async {
    // bool shouldChangeTab =
    // await checkConditionsBeforeChangingTab(_tabController.index);
    // if (!shouldChangeTab) {
    //   // If conditions are not met, revert back to the previous tab index
    //   setState(() {
    //     _tabController.index = tabIndex;
    //   });
    // } else {
    //   // If conditions are met, update the tabIndex
    //   setState(() {
    //     tabIndex = _tabController.index;
    //   });
    // }

    // showLoaderDialog(context);
    await checkConditionsBeforeChangingTab(index).then((value) {
      if (value) {
        tabIndex = index;
        setState(() {
          _tabController.index = tabIndex;
        });
      }
      // Navigator.pop(context);
    });
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
                SizedBox(height: 10),
                const Text("Please wait..."),
              ],
            ),
          ),
        );
      },
    );
  }

  // Future<void> updateVerificationStatus(BuildContext mContext) async {
  //   var varyItem = await OptionsModelHelper()
  //       .getMstCommonOptions('CC Verification status');
  //   varyItem = varyItem
  //       .where((element) => (element.name == '2') || (element.name == '3'))
  //       .toList();
  //   var verifiable = Global.returnTrLable(
  //       translatsLabel, CustomText.Verification_status, lng);
  //   OptionsModel? selectedItem;
  //   showDialog(
  //       context: mContext,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: Text(verifiable),
  //           content: Container(
  //             height: 180,
  //             child: SingleChildScrollView(
  //                 child: Column(
  //               children: [
  //                 DynamicCustomDropdownField(
  //                   titleText: verifiable,
  //                   isRequred: 0,
  //                   items: varyItem,
  //                   onChanged: (value) async {
  //                     selectedItem = value;
  //                   },
  //                 ),
  //                 SizedBox(height: 5),
  //                 Row(
  //                   children: [
  //                     Expanded(
  //                       flex: 1,
  //                       child: CElevatedButton(
  //                         text: CustomText.Submit,
  //                         color: Color(0xff369A8D),
  //                         onPressed: () async {
  //                           if (selectedItem != null) {
  //                             await updateVerification(selectedItem);
  //                             Navigator.of(mContext).pop();
  //                             Validate().singleButtonPopup(
  //                                 Global.returnTrLable(translatsLabel,
  //                                     CustomText.statusUpdateSuccssFully, lng!),
  //                                 Global.returnTrLable(
  //                                     translatsLabel, CustomText.ok, lng!),
  //                                 true,
  //                                 mContext);
  //                           } else {
  //                             Validate().singleButtonPopup(
  //                                 Global.returnTrLable(translatsLabel,
  //                                     CustomText.selectVerifyStatus, lng!),
  //                                 Global.returnTrLable(
  //                                     translatsLabel, CustomText.ok, lng!),
  //                                 false,
  //                                 mContext);
  //                           }
  //                         },
  //                       ),
  //                     ),
  //                     SizedBox(
  //                       width: 5,
  //                     ),
  //                     Expanded(
  //                       flex: 1,
  //                       child: CElevatedButton(
  //                         text: CustomText.Cancel,
  //                         color: Color(0xffDB4B73),
  //                         onPressed: () async {
  //                           Navigator.of(mContext).pop();
  //                         },
  //                       ),
  //                     )
  //                   ],
  //                 )
  //               ],
  //             )),
  //           ),
  //         );
  //       });
  // }

  // Future<void> updateVerification(OptionsModel? value) async {
  //   var alredRecord = await EnrolledChilrenResponceHelper()
  //       .callChildrenResponce(widget.EnrolledChilGUID);
  //   if (alredRecord.length > 0) {
  //     Map<String, dynamic> responseData = jsonDecode(alredRecord[0].responces!);
  //     responseData['status'] = value!.name;
  //     var name = responseData['name'];
  //     var userName = (await Validate().readString(Validate.userName))!;
  //     responseData['app_updated_on'] = Validate().currentDateTime();
  //     responseData['app_updated_by'] = userName;
  //     responseData['verified_by'] = userName;
  //     responseData['verified_on'] = Validate().currentDateTime();
  //     var responcesJs = jsonEncode(responseData);
  //     await EnrolledChilrenResponceHelper().insertUpdate(
  //         widget.EnrolledChilGUID,
  //         widget.CHHGUID,
  //         widget.HHname,
  //         name,
  //         responcesJs,
  //         responseData['appcreated_on'],responseData['appcreated_by'],
  //         responseData['app_updated_on'],responseData['app_updated_by']);
  //   }
  // }
}
