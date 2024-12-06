import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shishughar/style/styles.dart';
import 'package:shishughar/utils/globle_method.dart';

import '../../../custom_widget/custom_btn.dart';
import '../../../custom_widget/custom_text.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_custom_dropdown.dart';
import '../../../database/helper/dynamic_screen_helper/house_hold_tab_responce.dart';
import '../../../database/helper/dynamic_screen_helper/options_model_helper.dart';
import '../../../database/helper/house_field_item_helper.dart';
import '../../../database/helper/translation_language_helper.dart';
import '../../../model/apimodel/house_hold_field_item_model_api.dart';
import '../../../model/apimodel/translation_language_api_model.dart';
import '../../../model/dynamic_screen_model/options_model.dart';
import '../../../utils/validate.dart';
import '../../childrenListingScreen.dart';
import 'add_household_form_tab.dart';
import 'depending_logic.dart';

class HHTabScreen extends StatefulWidget {
  final String hhGuid;
  final int crecheId;

  HHTabScreen({super.key, required this.hhGuid, required this.crecheId});

  @override
  _HHTabScreenState createState() => _HHTabScreenState();
}

class _HHTabScreenState extends State<HHTabScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int tabIndex = 0;
  List<Widget> tabTitleItem = [];
  List<HouseHoldFielItemdModel> tabBreakItems = [];
  Map<String, List<HouseHoldFielItemdModel>> itemScreenItems = {};
  bool _isLoading = true;
  String? hhNameTitle = CustomText.hhHeadName;
  String? hhName;
  String? role;
  String? lng;
  List<Translation> labelControlls = [];
  double screenWidth = 0.0;
  double tabWidth = 100.0; // Approximate width of each tab
  bool tabIsScrollable = false;

  @override
  void initState() {
    super.initState();
    callScrenControllers('Household Form');
  }

  // @override
  // void didChangeDependencies() async {
  //   super.didChangeDependencies();
  //   await callScrenControllers('Household Form');
  // }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    } else {
      return WillPopScope(
        onWillPop: () async {
          Validate().showExitDialog(context, labelControlls, lng!);
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 60,
            backgroundColor: Color(0xff5979AA),
            leading: Padding(
              padding: EdgeInsets.only(left: 10),
              child: GestureDetector(
                onTap: () {
                  Validate().showExitDialog(context, labelControlls, lng!);
                },
                child: Icon(
                  Icons.arrow_back_ios_sharp,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
            title: RichText(
              text: TextSpan(
                children: (Global.validString(hhName))
                    ? [
                        WidgetSpan(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                Global.returnTrLable(
                                    labelControlls, CustomText.hh_detail, lng!),
                                style: Styles.white145,
                              ),
                              Text(
                                '${Global.returnTrLable(labelControlls, hhNameTitle, lng!)} : ${Global.validToString(hhName)}',
                                style: Styles.white126P,
                              ),
                              // Add additional TextSpans here if needed
                            ],
                          ),
                        ),
                      ]
                    : [
                        WidgetSpan(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                Global.returnTrLable(
                                    labelControlls, CustomText.hh_detail, lng!),
                                style: Styles.white145,
                              ),
                              // Add additional TextSpans here if needed
                            ],
                          ),
                        ),
                      ],
              ),
            ),
            centerTitle: true,
            // actions: [
            //   (role == 'Cluster Coordinator')
            //       ? GestureDetector(
            //           onTap: () async {
            //              await updateVerificationStatusRadio(context);
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

    await HouseHoldFieldHelper()
        .getHouseHoldFieldsForm(screen_type)
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
          .where((element) =>
              element.fieldname == 'children_information__3_years_tab')
          .toList();
      if (chil.length > 0) {
        tabBreakItems.add(chil[0]);
      }
    }
    _tabController = TabController(length: tabBreakItems.length, vsync: this);
    checkConditionsBeforeChangingTab(0);

    lng = await Validate().readString(Validate.sLanguage);
    List<String> valueNames = [
      'HH Detail',
      hhNameTitle!,
      CustomText.ok,
      CustomText.shouldExit,
      CustomText.exit,
      CustomText.Cancel
    ];
    tabBreakItems.forEach((element) async {
      valueNames.add(element.label!);
    });
    await TranslationDataHelper()
        .callTranslateString(valueNames)
        .then((value) => labelControlls = value);
    tabWidth = 0;
    for (int i = 0; i < tabBreakItems.length; i++) {
      final textPainter = TextPainter(
        text: TextSpan(
            text: Global.returnTrLable(
                labelControlls, tabBreakItems[i].label!, lng!),
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

    await tabController();

    setState(() {
      _isLoading = false;
    });
  }

  Future tabController() async {
    tabBreakItems.forEach((element) async {
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
        child: Tab(
            child: Text(
                Global.returnTrLable(labelControlls, element.label!, lng!))),
      ));
    });
  }

  List<Widget> tabControllerScreen() {
    List<Widget> tabItem = [];
    for (int i = 0; i < tabBreakItems.length; i++) {
      if (tabBreakItems[i].fieldname == 'children_information__3_years_tab') {
        tabItem.add(ChildrenListingScreen(hhGuid: widget.hhGuid));
      } else {
        tabItem.add(AddHouseholdScreenFromTab(
            hhGuid: widget.hhGuid,
            crecheId: widget.crecheId,
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
    checkConditionsBeforeChangingTab(index);
  }

  Future<bool> checkConditionsBeforeChangingTab(int index) async {
    bool returnStatus = false;
    var alredRecord =
        await HouseHoldTabResponceHelper().getHouseHoldResponce(widget.hhGuid);
    if (alredRecord.isNotEmpty) {
      Map<String, dynamic> responseData = jsonDecode(alredRecord[0].responces!);
      var hh = responseData['hosuehold_head_name'];
      hhName = hh;

      // if (index == 3) {
      //   var children = responseData['children__3_years'];
      //   if (children != null) return true;
      // }
      // else {
      var items = itemScreenItems[tabBreakItems[index].name];
      if (items != null && items.isNotEmpty) {
        for (int i = 0; i < items.length; i++) {
          if (responseData.containsKey(items[i].fieldname)) {
            print("Condition met for tab $index");
            returnStatus = true;
            break;
          }
        }
      }
      // }
      if (!returnStatus) {
        var nextco = (_tabController.index + 1);
        if (nextco == index) {
          var items = itemScreenItems[tabBreakItems[_tabController.index].name];
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

  void handleTabChange(int index, int previus) async {
    // bool shouldChangeTab =
    //     await checkConditionsBeforeChangingTab(_tabController.index);
    print("index $index ${_tabController.index}");
    showLoaderDialog(context);
    await checkConditionsBeforeChangingTab(index).then((value) {
      if (value) {
        tabIndex = index;
        setState(() {
          _tabController.index = tabIndex;
        });
      }
      Navigator.pop(context);
    });
    // _tabController.index = tabIndex;

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
    // setState(() {
    //   _tabController.index = tabIndex;
    // });
  }

  Future<String> callHHHeadName() async {
    var alredRecord =
        await HouseHoldTabResponceHelper().getHouseHoldResponce(widget.hhGuid);
    if (alredRecord.isNotEmpty) {
      Map<String, dynamic> responseData = jsonDecode(alredRecord[0].responces!);
      var hh = responseData['hosuehold_head_name'];
      hhName = hh;
    }
    if (hhNameTitle != null) {
      var lngtr = await Validate().readString(Validate.sLanguage);
      var hhTitle =
          await TranslationDataHelper().getTranslation(hhNameTitle!, lngtr!);
      return hhTitle;
    } else
      return "";
  }

  Future<void> updateVerificationStatus(BuildContext context) async {
    var varyItem = await OptionsModelHelper()
        .getMstCommonOptions('Verfication Status', lng!);
    varyItem = varyItem
        .where((element) => (element.name == '5') || (element.name == '4'))
        .toList();

    var lngtr = await Validate().readString(Validate.sLanguage);
    var verifiLable = await TranslationDataHelper()
        .getTranslation(CustomText.Verification_status, lngtr!);
    OptionsModel? selectItem;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(verifiLable),
          content: Container(
              height: 180,
              child: SingleChildScrollView(
                child: Column(children: [
                  DynamicCustomDropdownField(
                    titleText: verifiLable,
                    isRequred: 0,
                    items: varyItem,
                    onChanged: (value) async {
                      selectItem = value;
                    },
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: CElevatedButton(
                          text: CustomText.Cancel,
                          color: Color(0xffDB4B73),
                          onPressed: () async {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        flex: 1,
                        child: CElevatedButton(
                          text: CustomText.Submit,
                          color: Color(0xff369A8D),
                          onPressed: () async {
                            if (selectItem != null) {
                              await updateVerification(selectItem);
                              Navigator.of(context).pop();
                              Validate().singleButtonPopup(
                                  Global.returnTrLable(labelControlls,
                                      CustomText.statusUpdateSuccssFully, lng!),
                                  Global.returnTrLable(
                                      labelControlls, CustomText.ok, lng!),
                                  true,
                                  context);
                            } else {
                              Validate().singleButtonPopup(
                                  Global.returnTrLable(labelControlls,
                                      CustomText.selectVerifyStatus, lng!),
                                  Global.returnTrLable(
                                      labelControlls, CustomText.ok, lng!),
                                  false,
                                  context);
                            }
                          },
                        ),
                      )
                    ],
                  )
                ]),
              )),
        );
      },
    );
  }

  Future<void> updateVerification(OptionsModel? value) async {
    var alredRecord =
        await HouseHoldTabResponceHelper().getHouseHoldResponce(widget.hhGuid);
    if (alredRecord.length > 0) {
      Map<String, dynamic> responseData = jsonDecode(alredRecord[0].responces!);
      responseData['verification_status'] = value!.name;
      var name = responseData['name'];
      var creche_id = responseData['creche_id'];
      var userName = (await Validate().readString(Validate.userName))!;
      responseData['app_updated_on'] = Validate().currentDateTime();
      responseData['app_updated_by'] = userName;
      responseData['verified_by'] = userName;
      responseData['verified_on'] = Validate().currentDateTime();
      var responcesJs = jsonEncode(responseData);
      var dateOfVisit = responseData['date_of_visit'];
      await HouseHoldTabResponceHelper().insertUpdate(
          widget.hhGuid, dateOfVisit, name, creche_id, responcesJs, userName);
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
                SizedBox(height: 10),
                const Text("Please wait..."),
              ],
            ),
          ),
        );
      },
    );
  }

  // Future<void> updateVerificationStatusRadio(BuildContext mContext) async {
  //   var varyItem =
  //   await OptionsModelHelper().getMstCommonOptions('Verfication Status');
  //   varyItem = varyItem
  //       .where((element) => (element.name == '5') || (element.name == '4'))
  //       .toList();
  //   OptionsModel? selectItem;
  //   showDialog(
  //     context: mContext,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('Verification Label'),
  //         content: StatefulBuilder(
  //           builder: (BuildContext context, StateSetter setState) {
  //             return Container(
  //               width: double.maxFinite,
  //               child: ListView.builder(
  //                 shrinkWrap: true,
  //                 itemCount: varyItem.length,
  //                 itemBuilder: (context, i) {
  //                   return RadioListTile<OptionsModel>(
  //                     title: Text(varyItem[i].values ?? ''),
  //                     value: varyItem[i],
  //                     groupValue: selectItem,
  //                     onChanged: (value) {
  //                       setState(() {
  //                         selectItem = value;
  //                       });
  //                       print('Selected: ${value?.values}');
  //                     },
  //                     activeColor: Colors.black,
  //                   );
  //                 },
  //               ),
  //             );
  //           },
  //         ),
  //         actions: [
  //           ElevatedButton(
  //             child: Text(CustomText.Cancel,style: Styles.white104P,),
  //             style: ElevatedButton.styleFrom(
  //             backgroundColor: Color(0xffDB4B73),
  //               foregroundColor: Colors.white,
  //             ),
  //             onPressed: () {
  //               Navigator.of(mContext).pop();
  //             },
  //           ),
  //           ElevatedButton(
  //             child: Text(CustomText.Submit,style: Styles.white104P),
  //             style: ElevatedButton.styleFrom(
  //             backgroundColor: Color(0xff369A8D),
  //               foregroundColor: Colors.white,
  //             ),
  //             onPressed: () async {
  //               if(selectItem!=null){
  //                 await updateVerification(selectItem);
  //                 Navigator.of(context).pop();
  //                 Validate().singleButtonPopup(
  //                     Global.returnTrLable(labelControlls,
  //                         CustomText.statusUpdateSuccssFully, lng!),
  //                     Global.returnTrLable(
  //                         labelControlls, CustomText.ok, lng!),
  //                     true,
  //                     context);
  //               }else{
  //                 Validate().singleButtonPopup(
  //                     Global.returnTrLable(labelControlls,
  //                         CustomText.selectVerifyStatus, lng!),
  //                     Global.returnTrLable(
  //                         labelControlls, CustomText.ok, lng!),
  //                     false,
  //                     context);
  //               }
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
  Future<void> updateVerificationStatusRadio(BuildContext mContext) async {
    var varyItem = await OptionsModelHelper()
        .getMstCommonOptions('Verfication Status', lng!);
    varyItem = varyItem
        .where((element) => (element.name == '5') || (element.name == '4'))
        .toList();
    OptionsModel? selectItem;
    showDialog(
      context: mContext,
      builder: (BuildContext context) {
        return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            contentPadding: EdgeInsets.zero,
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Container(
                  width: double.maxFinite,
                  height: MediaQuery.of(context).size.height * 0.35,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          height: 40,
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Color(0xff5979AA),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5.0),
                              topRight: Radius.circular(5.0),
                            ),
                          ),
                          child: Center(
                              child: Text(CustomText.SHISHUGHAR,
                                  style: Styles.white126P)),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        Container(
                            child: Text('Verification Status',
                                style: Styles.black128)),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: varyItem.length,
                          itemBuilder: (context, i) {
                            return RadioListTile<OptionsModel>(
                              title: Text(varyItem[i].values ?? ''),
                              value: varyItem[i],
                              groupValue: selectItem,
                              onChanged: (value) {
                                setState(() {
                                  selectItem = value;
                                });
                                print('Selected: ${value?.values}');
                              },
                              activeColor: Colors.black,
                            );
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          child: Row(
                            children: [
                              Expanded(
                                child: CElevatedButton(
                                  text: Global.returnTrLable(
                                      labelControlls, CustomText.Cancel, lng!),
                                  color: Color(0xffDB4B73),
                                  onPressed: () {
                                    Navigator.of(mContext).pop();
                                  },
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: CElevatedButton(
                                  text: Global.returnTrLable(
                                      labelControlls, CustomText.Submit, lng!),
                                  color: Color(0xff369A8D),
                                  onPressed: () async {
                                    if (selectItem != null) {
                                      await updateVerification(selectItem);
                                      Navigator.of(context).pop();
                                      Validate().singleButtonPopup(
                                          Global.returnTrLable(
                                              labelControlls,
                                              CustomText
                                                  .statusUpdateSuccssFully,
                                              lng!),
                                          Global.returnTrLable(labelControlls,
                                              CustomText.ok, lng!),
                                          true,
                                          context);
                                    } else {
                                      Validate().singleButtonPopup(
                                          Global.returnTrLable(
                                              labelControlls,
                                              CustomText.selectVerifyStatus,
                                              lng!),
                                          Global.returnTrLable(labelControlls,
                                              CustomText.ok, lng!),
                                          false,
                                          context);
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                        )
                      ]));
            }));
      },
    );
  }
}
