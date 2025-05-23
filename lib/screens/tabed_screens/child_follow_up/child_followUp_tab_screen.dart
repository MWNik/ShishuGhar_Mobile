import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shishughar/database/helper/follow_up/child_followUp_fields_helper.dart';
import '../../../custom_widget/custom_text.dart';
import '../../../database/helper/follow_up/child_followUp_response_helper.dart';
import '../../../database/helper/translation_language_helper.dart';
import '../../../model/apimodel/form_logic_api_model.dart';
import '../../../model/apimodel/house_hold_field_item_model_api.dart';
import '../../../model/apimodel/translation_language_api_model.dart';
import '../../../model/dynamic_screen_model/options_model.dart';
import '../../../style/styles.dart';
import '../../../utils/globle_method.dart';
import '../../../utils/validate.dart';
import 'child_followup_tab_items_screen.dart';
import 'child_followup_tab_items_view_screen.dart';

class ChildFollowUpTabScreen extends StatefulWidget {
  String tabTitle;
  final String enrollChildGuid;
  final String child_referral_guid;
  final String discharge_date;
  final String followup_visit_date;
  final String schedule_date;
  final String child_followup_guid;
  final String childName;
  final String childId;
  final int? child_id;
  final int creche_id;
  final bool isEditable;
  final DateTime? minDate;

  ChildFollowUpTabScreen(
      {super.key,
      required this.tabTitle,
      required this.enrollChildGuid,
      required this.child_referral_guid,
      required this.followup_visit_date,
      required this.schedule_date,
      required this.discharge_date,
      required this.child_followup_guid,
      required this.child_id,
      required this.creche_id,
      required this.childName,
      required this.childId,
      required this.minDate,
      required this.isEditable});

  @override
  State<ChildFollowUpTabScreen> createState() => _ChildFollowUpTabScreenState();
}

class _ChildFollowUpTabScreenState extends State<ChildFollowUpTabScreen>
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
      CustomText.FollowUpDetail,
      CustomText.Next,
      CustomText.back
    ];
    await TranslationDataHelper()
        .callTranslateString(valueNames)
        .then((value) => translatsLabel = value);

    await callScrenControllers();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
          color: Colors.white,
          child: Center(child: CircularProgressIndicator()));
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
                  widget.tabTitle,
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
    var alredRecord = await ChildFollowUpTabResponseHelper()
        .getChildFollowUpResponcewithGuid(widget.child_followup_guid);
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
    await ChildFollowUpFieldsHelper()
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

  List<Widget> tabControllerScreen() {
    List<Widget> tabItem = [];
    for (int i = 0; i < tabBreakItems.length; i++) {
      if (tabBreakItems[i].parent == 'Child Follow up') {
        tabItem.add(widget.isEditable
            ? ChildFollowupTabItemsScreen(
                discharge_date: widget.discharge_date,
                followup_visit_date: widget.followup_visit_date,
                schedule_date: widget.schedule_date,
                child_referral_guid: widget.child_referral_guid,
                enrolChildGuid: widget.enrollChildGuid,
                creche_id: widget.creche_id,
                child_id: widget.child_id,
                child_followup_guid: widget.child_followup_guid,
                tabBreakItem: tabBreakItems[i],
                screenItem: expendedItems,
                changeTab: changeTab,
                tabIndex: i,
                minDate: widget.minDate,
                totalTab: tabBreakItems.length)
            : ChildFollowupTabItemsViewScreen(
                discharge_date: widget.discharge_date,
                followup_visit_date: widget.followup_visit_date,
                schedule_date: widget.schedule_date,
                child_referral_guid: widget.child_referral_guid,
                enrolChildGuid: widget.enrollChildGuid,
                creche_id: widget.creche_id,
                child_id: widget.child_id,
                child_followup_guid: widget.child_followup_guid,
                tabBreakItem: tabBreakItems[i],
                screenItem: expendedItems,
                changeTab: changeTab,
                tabIndex: i,
                totalTab: tabBreakItems.length));
      }
    }

    return tabItem;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
