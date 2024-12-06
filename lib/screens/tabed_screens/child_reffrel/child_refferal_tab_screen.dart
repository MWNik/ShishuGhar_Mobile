import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shishughar/database/helper/child_reffrel/child_refferal_fields_helper.dart';

import '../../../custom_widget/custom_text.dart';
import '../../../database/helper/child_reffrel/child_refferal_response_helper.dart';
import '../../../database/helper/translation_language_helper.dart';
import '../../../model/apimodel/form_logic_api_model.dart';
import '../../../model/apimodel/house_hold_field_item_model_api.dart';
import '../../../model/apimodel/translation_language_api_model.dart';
import '../../../model/dynamic_screen_model/options_model.dart';
import '../../../style/styles.dart';
import '../../../utils/globle_method.dart';
import '../../../utils/validate.dart';
import 'child_referral_tabItems_view_screen.dart';
import 'child_refferal_tabitems_screen.dart';

class ChildReferralTabScreen extends StatefulWidget {
  String tabTitle;
  final String enrolChildGuid;
  final String GrowthMonitoringGUID;
  final String ChildDOB;
  final String enrollDate;
  final String child_referral_guid;
  final String childName;
  final String childId;
  final int? child_id;
  final int creche_id;
  final bool isDischarge;
  final DateTime? minDate;
  final String scheduleDate;
  final bool isEditable;

  ChildReferralTabScreen(
      {super.key,
      required this.tabTitle,
      required this.enrolChildGuid,
      required this.GrowthMonitoringGUID,
      required this.ChildDOB,
      required this.enrollDate,
      required this.child_referral_guid,
      required this.childName,
      required this.childId,
      required this.child_id,
      required this.creche_id,
      required this.isDischarge,
      required this.minDate,
      required this.scheduleDate,
      required this.isEditable});

  @override
  State<ChildReferralTabScreen> createState() => _ChildReferralTabScreenState();
}

class _ChildReferralTabScreenState extends State<ChildReferralTabScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;
  String? saveNext = CustomText.Next;
  List<HouseHoldFielItemdModel> tabBreakItems = [];
  List<Widget> tabTitleItem = [];
  List<OptionsModel> options = [];
  int tabIndex = 0;
  Map<String, List<HouseHoldFielItemdModel>> expendedItems = {};
  List<TabFormsLogic> logics = [];
  Map<String, dynamic> myMap = {};
  List<Translation> translatsLabel = [];
  void Function()? ontap;
  String lng = "en";

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    lng = (await Validate().readString(Validate.sLanguage))!;
    translatsLabel.clear();
    List<String> valueNames = [
      CustomText.Save,
      CustomText.Creches,
      CustomText.CrecheCaregiver,
      CustomText.Next,
      CustomText.back,
      widget.tabTitle
    ];
    await TranslationDataHelper()
        .callTranslateString(valueNames)
        .then((value) => translatsLabel = value);

    await callScrenControllers();
  }

  @override
  Widget build(BuildContext context) {
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
            title: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RichText(
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  text: TextSpan(children: [
                    WidgetSpan(
                      child: Text(
                        '${widget.childName} ',
                        style: Styles.white145,
                        textAlign: TextAlign.center,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    WidgetSpan(
                      child: Text(
                        '-${widget.childId}',
                        style: Styles.white145,
                        textAlign: TextAlign.center,
                        softWrap: true,
                        // overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ]),
                ),
                Text(
                  Global.returnTrLable(translatsLabel, widget.tabTitle, lng),
                  style: Styles.white126P,
                ),
              ],
            ),
            centerTitle: true,
            bottom: _isLoading
                ? null
                : TabBar(
                    indicatorColor: Colors.white,
                    unselectedLabelColor: Colors.grey.shade300,
                    unselectedLabelStyle: Styles.white124P,
                    labelColor: Colors.white,
                    controller: _tabController,
                    isScrollable: false,
                    tabs: tabController(),
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

  List<Widget> tabController() {
    List<Widget> tabItem = [];
    tabBreakItems.forEach((element) {
      bool isSelected = tabIndex == tabBreakItems.indexOf(element);
      Widget tabLabel = Text(
        Global.returnTrLable(translatsLabel, element.label!, lng),
        style: TextStyle(
            fontSize: isSelected ? 16.0 : 13.0,
            color: isSelected ? Colors.white : Colors.grey.shade300),
      );
      tabItem.add(Tab(
        child: tabLabel,
      ));
    });
    return tabItem;
  }

  void handleTabChange(int index, int previus) async {
    await checkConditionsBeforeChangingTab(index).then((value) {
      if (value) {
        tabIndex = index;
        setState(() {
          _tabController.index = tabIndex;
        });
      }
    });
  }

  Future<bool> checkConditionsBeforeChangingTab(int index) async {
    bool returnStatus = false;
    var alredRecord = await ChildReferralTabResponseHelper()
        .getChildReferralResponcewithGuid(widget.child_referral_guid);
    if (alredRecord.isNotEmpty) {
      Map<String, dynamic> responseData = jsonDecode(alredRecord[0].responces!);

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

  Future<void> callScrenControllers() async {
    List<HouseHoldFielItemdModel> allItems = [];
    List<HouseHoldFielItemdModel> tempBreakDown = [];
    List<String> remItem = ['child_id'];
    await ChildReferralFieldsHelper()
        .getChildFollowUpMetaFields()
        .then((value) async {
      allItems = value;
      tabBreakItems = allItems
          .where((element) =>
              element.fieldtype == CustomText.tabBreak &&
              element.fieldname != 'hidden_tab' &&
              element.fieldname != 'creche_info')
          .toList();
    });

    for (int i = 0; i < tabBreakItems.length; i++) {
      if (i < (tabBreakItems.length) - 1) {
        var fitems = allItems
            .where((element) => (element.idx! > tabBreakItems[i].idx! &&
                element.idx! < tabBreakItems[i + 1].idx!))
            .toList();

        var filtredItem = fitems
            .where((element) => (!(remItem.contains(element.fieldname))))
            .toList();

        expendedItems[tabBreakItems[i].name!] = filtredItem;
      } else {
        var filtredItem = allItems
            .where((element) => element.idx! > tabBreakItems[i].idx!)
            .toList();
        expendedItems[tabBreakItems[i].name!] = filtredItem;
      }
    }

    _tabController = TabController(length: tabBreakItems.length, vsync: this);
    List<String> tabLabelItems = [];
    tabBreakItems.forEach((element) {
      if (Global.validString(element.label)) {
        tabLabelItems.add(element.label!);
      }
    });
    await TranslationDataHelper()
        .callTranslateString(tabLabelItems)
        .then((value) => translatsLabel.addAll(value));
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Widget> tabControllerScreen() {
    List<Widget> tabItem = [];
    for (int i = 0; i < tabBreakItems.length; i++) {
      if (tabBreakItems[i].parent == 'Child Referral') {
        tabItem.add(widget.isEditable
            ? ChildReferralTabItemsScreen(
                enrollDate: widget.enrollDate,
                GrowthMonitoringGUID: widget.GrowthMonitoringGUID,
                ChildDOB: widget.ChildDOB,
                enrolChildGuid: widget.enrolChildGuid,
                creche_id: widget.creche_id,
                child_id: widget.child_id,
                child_referral_guid: widget.child_referral_guid,
                tabBreakItem: tabBreakItems[i],
                screenItem: expendedItems,
                changeTab: changeTab,
                isDischarge: widget.isDischarge,
                tabIndex: i,
                totalTab: tabBreakItems.length,
                scheduleDate: widget.scheduleDate,
                minDate: widget.minDate??null)
            : ChildReferralTabItemsViewScreen(
                scheduleDate: widget.scheduleDate,
                enrollDate: widget.enrollDate,
                GrowthMonitoringGUID: widget.GrowthMonitoringGUID,
                ChildDOB: widget.ChildDOB,
                enrolChildGuid: widget.enrolChildGuid,
                creche_id: widget.creche_id,
                child_id: widget.child_id,
                child_referral_guid: widget.child_referral_guid,
                tabBreakItem: tabBreakItems[i],
                screenItem: expendedItems,
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
        if (!(tabIndex == (tabBreakItems.length - 1))) {
          tabIndex++;
          _tabController.animateTo(tabIndex);
        }
      });
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
}
