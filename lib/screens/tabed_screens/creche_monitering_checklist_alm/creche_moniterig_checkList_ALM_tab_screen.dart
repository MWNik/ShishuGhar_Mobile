import 'dart:convert';

import 'package:flutter/material.dart';
import '../../../custom_widget/custom_text.dart';
import '../../../database/helper/cmc_alm/creche_monitering_checkList_ALM_fields_helper.dart';
import '../../../database/helper/cmc_alm/creche_monitering_checkList_ALM_response_helper.dart';
import '../../../database/helper/translation_language_helper.dart';
import '../../../model/apimodel/form_logic_api_model.dart';
import '../../../model/apimodel/house_hold_field_item_model_api.dart';
import '../../../model/apimodel/translation_language_api_model.dart';
import '../../../model/dynamic_screen_model/options_model.dart';
import '../../../style/styles.dart';
import '../../../utils/globle_method.dart';
import '../../../utils/validate.dart';
import 'creche_monitering_checkList_ALM_tabItem_screen.dart';
import 'creche_monitering_checklist_tabItem_ALM_view_screen.dart';

class CmcALMTabSCreen extends StatefulWidget {
  String? crecheName;
  final String almguid;
  final int? creche_id;
  String? date_of_visit;
  final bool isEdit;
  final bool isViewScreen;

  CmcALMTabSCreen(
      {super.key,
      this.crecheName,
      required this.almguid,
      required this.creche_id,
      this.date_of_visit,
      required this.isEdit,
      required this.isViewScreen});

  @override
  State<CmcALMTabSCreen> createState() => _CmcALMTabSCreenState();
}

class _CmcALMTabSCreenState extends State<CmcALMTabSCreen>
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
  bool isView = false;

  double screenWidth = 0.0;
  double tabWidth = 100.0; // Approximate width of each tab
  bool tabIsScrollable = false;

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
      CustomText.shouldExit,
      CustomText.exit,
      CustomText.Cancel
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
            widget.isViewScreen?Navigator.pop(context,CustomText.itemRefresh):Validate().showExitDialog(context,translatsLabel,lng);
            return false;
          },
          child: Scaffold(
            appBar: AppBar(
              toolbarHeight: 70,
              backgroundColor: Color(0xff5979AA),
              leading: Padding(
                padding: EdgeInsets.only(left: 10),
                child: GestureDetector(
                  onTap: () {
                    widget.isViewScreen?Navigator.pop(context,CustomText.itemRefresh):Validate().showExitDialog(context,translatsLabel,lng);
                  },
                  child: Icon(
                    Icons.arrow_back_ios_sharp,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
              title: Column(
                children: [
                  Text(
                    Global.returnTrLable(
                        translatsLabel, CustomText.VisitNote, lng!),
                    style: Styles.white145,
                  ),
                  Text(
                    widget.crecheName != null ? widget.crecheName! : '',
                    style: Styles.white145,
                  )
                ],
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
                tabAlignment: tabIsScrollable ? TabAlignment.start : null,
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
          ));
    }
  }

  List<Widget> tabController() {
    List<Widget> tabItem = [];
    tabBreakItems.forEach((element) {
      Widget tabLabel = Text(
        Global.returnTrLable(translatsLabel, element.label!, lng),
      );
      tabItem.add(Container(
        width: tabIsScrollable ? null : screenWidth / tabBreakItems.length,
        padding: EdgeInsets.only(left: 10, right: 10),
        decoration: BoxDecoration(
            color: Color(0xff369A8D),
            border: Border(
                right: BorderSide(
                    color: Colors.white, width: 1, style: BorderStyle.solid))),
        child: Tab(child: tabLabel),
      ));
    });
    return tabItem;
  }

  List<Widget> tabControllerScreen() {
    List<Widget> tabItem = [];
    for (int i = 0; i < tabBreakItems.length; i++) {
      if (tabBreakItems[i].parent == 'Creche Monitoring Checklist ALM') {
        tabItem.add(isView
            ? CmcALMTabItemViewSCreen(
                creche_id: widget.creche_id.toString(),
                almguid: widget.almguid,
                tabBreakItem: tabBreakItems[i],
                screenItem: expendedItems,
                changeTab: changeTab,
                tabIndex: i,
                totalTab: tabBreakItems.length)
            : CmcALMTabItemSCreen(
                creche_id: widget.creche_id.toString(),
                almguid: widget.almguid,
                tabBreakItem: tabBreakItems[i],
                screenItem: expendedItems,
                changeTab: changeTab,
                tabIndex: i,
                totalTab: tabBreakItems.length,
                date_of_visit: widget.date_of_visit,
                isEdit: widget.isEdit,
              ));
      }
    }

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
    var alredRecord = await CmcALMTabResponseHelper()
        .getCrecheCommittieResponcewithGuid(widget.almguid!);
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
    List<String> remItem = [
      'partner_id',
      'state_id',
      'district_id',
      'block_id',
      'gp_id',
      'village_id',
      'creche_id',
    ];
    await CrecheMoniteringCheckListALMFieldsHelper()
        .getcmcALMMetaFields()
        .then((value) async {
      allItems = value;
      tabBreakItems = allItems
          .where((element) =>
              element.fieldtype == CustomText.tabBreak &&
              element.fieldname != 'hidden_section' &&
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
    tabWidth=0;
    for (int i = 0; i < tabBreakItems.length; i++) {
      final textPainter = TextPainter(
        text: TextSpan(
            text: Global.returnTrLable(translatsLabel, tabBreakItems[i].label!, lng!),
            style: Styles.white124P
        ),
        maxLines: 1, // Single line text
        textDirection: TextDirection.ltr,
      );

      // Layout the text (this step is required to calculate the width)
      textPainter.layout();
      double textWidth = textPainter.width+20;
      tabWidth=tabWidth+textWidth;
      print(textWidth);

    }
    screenWidth = MediaQuery.of(context).size.width;
    // tabIsScrollable = tabWidth * tabBreakItems.length >= screenWidth;
    tabIsScrollable = tabWidth > screenWidth;

    if (Global.validString(widget.date_of_visit)) {
      List<int> parts =
          widget.date_of_visit.toString().split('-').map(int.parse).toList();
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
