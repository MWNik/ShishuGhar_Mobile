import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shishughar/database/helper/child_attendence/child_attendance_helper_responce.dart';
import 'package:shishughar/utils/globle_method.dart';

import '../../../custom_widget/custom_text.dart';
import '../../../database/helper/child_attendence/child_attendance_field_helper.dart';
import '../../../database/helper/child_attendence/child_attendence_helper.dart';
import '../../../database/helper/translation_language_helper.dart';
import '../../../model/apimodel/form_logic_api_model.dart';
import '../../../model/apimodel/house_hold_field_item_model_api.dart';
import '../../../model/apimodel/translation_language_api_model.dart';
import '../../../model/dynamic_screen_model/options_model.dart';
import '../../../style/styles.dart';
import '../../../utils/validate.dart';
import 'attendance_firm_tab_Item_view.dart';
import 'attendance_responce_helper.dart';
import 'attendance_tab_items.dart';
import 'enrolled_child_for_attendance_view.dart';
import 'enrolled_child_for_attendence.dart';

class AddAttendanceScreenFormTab extends StatefulWidget {
  final int? creche_nameId;
  final String? crexhe_name;
  final String ChildAttenGUID;
  final bool isEdit;
  List<String> existingDates;
  DateTime? lastGrowthDate;
  DateTime? minGrowthDate;
  static DateTime? maxDate;
  static DateTime? minDate;

  AddAttendanceScreenFormTab(
      {super.key,
      required this.isEdit,
      required this.creche_nameId,
      required this.ChildAttenGUID,
      required this.crexhe_name,
      this.lastGrowthDate,
      this.minGrowthDate,
      required this.existingDates});

  @override
  State<AddAttendanceScreenFormTab> createState() => _AddAttendanceState();
}

class _AddAttendanceState extends State<AddAttendanceScreenFormTab>
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
  bool isEditable = true;
  String? role;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    role = (await Validate().readString(Validate.role))!;
    AddAttendanceScreenFormTab.maxDate = widget.lastGrowthDate;
    AddAttendanceScreenFormTab.minDate = widget.minGrowthDate;
    lng = (await Validate().readString(Validate.sLanguage))!;
    translatsLabel.clear();
    List<String> valueNames = [
      CustomText.Save,
      CustomText.Creches,
      CustomText.CrecheCaregiver,
      CustomText.Next,
      CustomText.back,
      CustomText.Add_Attendance
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
                children: [
                  Text(
                    Global.returnTrLable(
                        translatsLabel, CustomText.Add_Attendance, lng!),
                    style: Styles.white145,
                  ),
                  Text(
                    widget.crexhe_name!,
                    style: Styles.white145,
                  )
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
                      isScrollable: true,
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
            body: Column(
              children: [
                Expanded(
                    child: TabBarView(
                  controller: _tabController,
                  physics: NeverScrollableScrollPhysics(),
                  children: tabControllerScreen(),
                ))
              ],
            ),
          ));
    }
  }

  List<Widget> tabControllerScreen() {
    List<Widget> tabItem = [];
    for (int i = 0; i < tabBreakItems.length; i++) {
      if (tabBreakItems[i].fieldname == 'children_attendance_tab') {
        tabItem.add(isEditable
            ? AddAttendance(
                crecheId: widget.creche_nameId!,
                ChildAttenGUID: widget.ChildAttenGUID,
                changeTab: changeTab,
              )
            : AddAttendanceView(
                crecheId: widget.creche_nameId!,
                ChildAttenGUID: widget.ChildAttenGUID,
                changeTab: changeTab,
              ));
      } else {
        tabItem.add(isEditable
            ? AttendanceTabItems(
                existingDates: widget.existingDates,
                isEdit: widget.isEdit,
                creche_name: widget.crexhe_name,
                creche_nameId: widget.creche_nameId,
                ChildAttenGUID: widget.ChildAttenGUID,
                tabBreakItem: tabBreakItems[i],
                screenItem: expendedItems,
                changeTab: changeTab,
                tabIndex: i,
                totalTab: tabBreakItems.length)
            : AttendanceTabItemsView(
                creche_name: widget.crexhe_name,
                creche_nameId: widget.creche_nameId,
                ChildAttenGUID: widget.ChildAttenGUID,
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

  Future<void> calinitialScreen() async {
    await callScrenControllers();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> callScrenControllers() async {
    List<HouseHoldFielItemdModel> allItems = [];
    List<HouseHoldFielItemdModel> tempBreakDown = [];
    List<String> remItem = [
      'attendance',
      'partner_id',
      'state_id',
      'district_id',
      'gp_id',
      'village_id',
      'creche_id',
      'block_id'
    ];
    await ChildAttendanceFieldHelper()
        .getChildAttendanceFileds()
        .then((value) async {
      allItems = value;
      tabBreakItems = allItems
          .where((element) => (element.fieldtype == CustomText.tabBreak &&
              element.fieldname != 'hiddenfield_tab'))
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
        if (!(tabBreakItems[i].fieldname == 'children_attendance_tab'))
          tempBreakDown.add(tabBreakItems[i]);
      }
    }

    tempBreakDown.forEach((element) {
      tabBreakItems.remove(element);
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
    await checkEditability();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<bool> checkConditionsBeforeChangingTab(int index) async {
    bool returnStatus = false;
    var alredRecord = await ChildAttendanceResponceHelper()
        .callAttendanceResponce(widget.ChildAttenGUID);
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
      } else if (tabBreakItems[index].fieldname == 'children_attendance_tab') {
        var alredRecord = await ChildAttendenceHelper()
            .callChildAttendencesByGuid(widget.ChildAttenGUID);
        if (alredRecord.length > 0) {
          returnStatus = true;
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

  Future<void> checkEditability() async {
    var record = await AttendanceResponnceHelper()
        .callChildrenResponce(widget.ChildAttenGUID);
    if (record.isNotEmpty) {
      // var dateInString =
      // Global.getItemValues(record[0].responces, 'date_of_attendance');
      // var parts = dateInString.split('-').map(int.parse).toList();
      // var dateOfAttendance = DateTime(parts[0], parts[1], parts[2]);
      var created_at = DateTime.parse(record[0].created_at.toString());
      var date = DateTime(created_at.year, created_at.month, created_at.day);
      // isEditable = role == CustomText.crecheSupervisor.trim()?(date
      //     .add(Duration(days: 3))
      //     .isAfter(DateTime.parse(Validate().currentDate()))):false;
      isEditable = role == CustomText.crecheSupervisor.trim()?true:false;
    }
  }
}
