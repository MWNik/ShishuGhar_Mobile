import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shishughar/custom_widget/custom_btn.dart';
import 'package:shishughar/custom_widget/custom_text.dart';
import 'package:shishughar/custom_widget/dynamic_screen_widget/dynamic_custom_dropdown.dart';
import 'package:shishughar/database/helper/creche_monitoring/creche_monitoring_helper.dart';
import 'package:shishughar/database/helper/creche_monitoring/creche_monitoring_response_helper.dart';
import 'package:shishughar/database/helper/dynamic_screen_helper/options_model_helper.dart';
import 'package:shishughar/database/helper/translation_language_helper.dart';
import 'package:shishughar/model/apimodel/house_hold_field_item_model_api.dart';
import 'package:shishughar/model/apimodel/translation_language_api_model.dart';
import 'package:shishughar/model/dynamic_screen_model/options_model.dart';
import 'package:shishughar/screens/tabed_screens/creche_monitor/creche_monitor_tab_item.dart';
import 'package:shishughar/style/styles.dart';
import 'package:shishughar/utils/globle_method.dart';
import 'package:shishughar/utils/validate.dart';

import 'creche_monitor_taItem_view_screen.dart';

class CrecheMonitorTab extends StatefulWidget {
  final String cmgUid;
  final String crecheId;
  String? dateOfVisit;
  final bool isEdit;
  final bool isViewScreen;

  CrecheMonitorTab({
    super.key,
    required this.cmgUid,
    required this.crecheId,
    this.dateOfVisit,
    required this.isEdit,
    required this.isViewScreen,
  });

  @override
  State<CrecheMonitorTab> createState() => _CrecheMonitorTabState();
}

class _CrecheMonitorTabState extends State<CrecheMonitorTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  int _tabIndex = 0;
  String _language = "en";
  String? _role;
  final _parentName = "Creche Monitoring Checklist";
  List<HouseHoldFielItemdModel> _tabBreakItems = [];
  List<Translation> _translation = [];
  Map<String, List<HouseHoldFielItemdModel>> _expandedItems = {};
  bool _isLoading = true;
  bool isView = false;
  double screenWidth = 0.0;
  double tabWidth = 100.0; // Approximate width of each tab
  bool tabIsScrollable = false;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  Future<void> _initData() async {
    _language = (await Validate().readString(Validate.sLanguage))!;
    _role = (await Validate().readString(Validate.role))!;

    List<String> valueNames = [
      CustomText.Save,
      CustomText.Creches,
      CustomText.CrecheMonitor,
      CustomText.Next,
      CustomText.back,
      CustomText.shouldExit,
      CustomText.exit,
      CustomText.Cancel,
      CustomText.VisitNote
    ];

    await TranslationDataHelper()
        .callTranslateString(valueNames)
        .then((value) => _translation = value);

    await TranslationDataHelper()
        .callTranslateEnrolledChildren()
        .then((value) => _translation.addAll(value));

    await _callScreenControllers(_parentName);
  }

  Future<void> _callScreenControllers(String parentName) async {
    final allItems = await CrecheMonitoringFieldHelper()
        .getCrecheMonitorMetaFieldsByParent(_parentName);

    int hiddenTabIdx =
        allItems.indexWhere((item) => item.fieldname == 'hidden_tab');

    final hiddenTabs = <String>["creche_info", "hidden_tab"];

    _tabBreakItems = allItems
        .where((item) =>
            (item.fieldtype == CustomText.tabBreak) &&
            !hiddenTabs.contains(item.fieldname))
        .toList();

    for (int i = 0; i < _tabBreakItems.length; i++) {
      if (i < (_tabBreakItems.length) - 1) {
        final filteredItem = allItems
            .where((element) =>
                element.idx! > _tabBreakItems[i].idx! &&
                element.idx! < _tabBreakItems[i + 1].idx!)
            .toList();
        _expandedItems[_tabBreakItems[i].name!] = filteredItem;
      } else {
        final filteredItem = allItems
            .where((element) =>
                element.idx! > _tabBreakItems[i].idx! &&
                element.idx! <= hiddenTabIdx)
            .toList();
        _expandedItems[_tabBreakItems[i].name!] = filteredItem;
      }
    }

    _tabController = TabController(length: _tabBreakItems.length, vsync: this);
    tabIsScrollable = tabWidth * _tabBreakItems.length > screenWidth;
    List<String> tabLabelTranslats = [];
    _tabBreakItems.forEach((element) {
      if (Global.validString(element.label)) {
        tabLabelTranslats.add(element.label!);
      }
    });
    await TranslationDataHelper()
        .callTranslateString(tabLabelTranslats)
        .then((value) => _translation.addAll(value));

    if (Global.validString(widget.dateOfVisit)) {
      List<int> parts =
          widget.dateOfVisit.toString().split('-').map(int.parse).toList();
      var dov = DateTime(parts[0], parts[1], parts[2]);
      if (dov
          .add(Duration(days: 7))
          .isBefore(DateTime.parse(Validate().currentDate()))) {
        isView = true;
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  List<Widget> _tabControllerWidgets() {
    List<Widget> tabItem = [];

    _tabBreakItems.forEach((element) {
      tabItem.add(Container(
        width: tabIsScrollable ? null : screenWidth / _tabBreakItems.length,
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
          Global.returnTrLable(_translation, element.label!, _language),
        )),
      ));
    });
    return tabItem;
  }

  List<Widget> _tabControllerScreens() {
    List<Widget> tabItem = [];
    for (int i = 0; i < _tabBreakItems.length; i++) {
      final item = _tabBreakItems[i];

      if (item.parent == _parentName) {
        final itemToAdd = widget.isViewScreen
            ? CrecheMonitorTabItemView(
                crecheId: widget.crecheId,
                parentName: _parentName,
                cmgUid: widget.cmgUid,
                tabBreakItem: item,
                screenItem: _expandedItems,
                changeTab: changeTab,
                tabIndex: i,
                totalTab: _tabBreakItems.length,
              )
            : CrecheMonitorTabItem(
                crecheId: widget.crecheId,
                parentName: _parentName,
                cmgUid: widget.cmgUid,
                tabBreakItem: item,
                screenItem: _expandedItems,
                changeTab: changeTab,
                tabIndex: i,
                totalTab: _tabBreakItems.length,
                dateOfVisit: widget.dateOfVisit,
                isEdit: widget.isEdit,
              );

        tabItem.add(itemToAdd);
      }
    }
    return tabItem;
  }

  void changeTab(int index) {
    if (index == 0) {
      if (_tabIndex > 0) {
        _tabIndex--;
        _tabController.animateTo(_tabIndex);
      }
    } else if (_tabIndex < _tabBreakItems.length) {
      if (!(_tabIndex == (_tabBreakItems.length - 1))) {
        _tabIndex++;
        _tabController.animateTo(_tabIndex);
      }
    }
  }

  void _handleTabChange(int index) async {
    await checkConditionsBeforeChangingTab(index).then((value) {
      if (value) {
        _tabIndex = index;
        setState(() {
          _tabController.index = _tabIndex;
        });
      }
    });
  }

  Future<bool> checkConditionsBeforeChangingTab(int index) async {
    bool returnStatus = false;
    var alteredRecord = await CrecheMonitorResponseHelper()
        .getCrecheResponseWithCmgUid(widget.cmgUid);
    if (alteredRecord.isNotEmpty) {
      Map<String, dynamic> responseData =
          jsonDecode(alteredRecord[0].responces!);

      var items = _expandedItems[_tabBreakItems[index].name];
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
          var items = _expandedItems[_tabBreakItems[_tabController.index].name];
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
    return returnStatus;
  }

  Future<void> updateVerificationStatus(BuildContext mContext) async {
    var varyItem = await OptionsModelHelper()
        .getMstCommonOptions('CC Verification status', _language);
    varyItem = varyItem
        .where((element) => (element.name == '2') || (element.name == '3'))
        .toList();
    var verifiable = Global.returnTrLable(
        _translation, CustomText.Verification_status, _language);
    OptionsModel? selectedItem;
    showDialog(
        context: mContext,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(verifiable),
            content: Container(
              height: 180,
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  DynamicCustomDropdownField(
                    titleText: verifiable,
                    isRequred: 0,
                    items: varyItem,
                    onChanged: (value) async {
                      selectedItem = value;
                    },
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: CElevatedButton(
                          text: CustomText.Submit,
                          color: Color(0xff369A8D),
                          onPressed: () async {
                            if (selectedItem != null) {
                              await updateVerification(selectedItem);
                              Navigator.of(mContext).pop();
                              Validate().singleButtonPopup(
                                  Global.returnTrLable(
                                      _translation,
                                      CustomText.statusUpdateSuccssFully,
                                      _language),
                                  Global.returnTrLable(
                                      _translation, CustomText.ok, _language),
                                  true,
                                  mContext);
                            } else {
                              Validate().singleButtonPopup(
                                  Global.returnTrLable(_translation,
                                      CustomText.selectVerifyStatus, _language),
                                  Global.returnTrLable(
                                      _translation, CustomText.ok, _language),
                                  false,
                                  mContext);
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        flex: 1,
                        child: CElevatedButton(
                          text: CustomText.Cancel,
                          color: Color(0xffDB4B73),
                          onPressed: () async {
                            Navigator.of(mContext).pop();
                          },
                        ),
                      )
                    ],
                  )
                ],
              )),
            ),
          );
        });
  }

  Future<void> updateVerification(OptionsModel? value) async {
    var alteredRecord = await CrecheMonitorResponseHelper()
        .getCrecheResponseWithCmgUid(widget.cmgUid);
    if (alteredRecord.length > 0) {
      Map<String, dynamic> responseData =
          jsonDecode(alteredRecord[0].responces!);
      responseData['status'] = value!.name;
      var name = responseData['name'];
      var userName = (await Validate().readString(Validate.userName))!;
      responseData['app_updated_on'] = Validate().currentDateTime();
      responseData['app_updated_by'] = userName;
      // responseData['appcreated_by'] = userName;
      // responseData['appcreated_on'] = Validate().currentDateTime();
      String response = jsonEncode(responseData);
      await CrecheMonitorResponseHelper().insertUpdate(
          int.parse(widget.crecheId),
          widget.cmgUid,
          name,
          response,
          responseData['appcreated_on'],
          responseData['appcreated_by'],
          responseData['app_updated_by'],
          responseData['app_updated_on']);
    }
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    Global.applyDisplayCutout(Color(0xff5979AA));
    if (_isLoading) {
      return Container(
          color: Colors.white,
          child: Center(child: CircularProgressIndicator()));
    } else {
      return SafeArea(
        child: WillPopScope(
          onWillPop: () async {
            widget.isViewScreen
                ? Navigator.pop(context, CustomText.itemRefresh)
                : Validate().showExitDialog(context, _translation, _language);
            return false;
          },
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              toolbarHeight: kToolbarHeight,
              backgroundColor: Color(0xff5979AA),
              leading: Padding(
                padding: EdgeInsets.only(left: 10),
                child: GestureDetector(
                  onTap: () => widget.isViewScreen
                      ? Navigator.pop(context, CustomText.itemRefresh)
                      : Validate()
                          .showExitDialog(context, _translation, _language),
                  child: Icon(
                    Icons.arrow_back_ios_sharp,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
              title: Text(
                Global.returnTrLable(
                        _translation, CustomText.VisitNote, _language)
                    .trim(),
                style: Styles.white145,
              ),
              actions: [
                (_role == 'Cluster Coordinator')
                    ? GestureDetector(
                        onTap: () async {
                          await updateVerificationStatus(context);
                        },
                        child: Image.asset(
                          "assets/verify_icon.png",
                          scale: 1.5,
                        ),
                      )
                    : SizedBox(),
                SizedBox(
                  width: 10,
                )
              ],

              /// TabBar
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
                    _handleTabChange(index);
                  }
                },

                tabs: _tabControllerWidgets(),
              ),
            ),

            // Body
            body: Column(
              children: [
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    physics: NeverScrollableScrollPhysics(),
                    children: _tabControllerScreens(),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
