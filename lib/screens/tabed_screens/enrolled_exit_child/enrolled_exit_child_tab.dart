import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shishughar/custom_widget/custom_text.dart';
import 'package:shishughar/database/helper/enrolled_exit_child/enrolled_exit_child_responce_helper.dart';
import 'package:shishughar/database/helper/enrolled_exit_child/enrolled_exit_children_field_helper.dart';
import 'package:shishughar/database/helper/translation_language_helper.dart';
import 'package:shishughar/model/apimodel/translation_language_api_model.dart';
import 'package:shishughar/utils/validate.dart';
import '../../../custom_widget/custom_btn.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_custom_dropdown.dart';
import '../../../database/helper/dynamic_screen_helper/options_model_helper.dart';
import '../../../database/helper/enrolled_children/enrolled_children_field_helper.dart';
import '../../../database/helper/enrolled_children/enrolled_children_responce_helper.dart';
import '../../../model/apimodel/form_logic_api_model.dart';
import '../../../model/apimodel/house_hold_field_item_model_api.dart';
import '../../../model/dynamic_screen_model/options_model.dart';
import '../../../style/styles.dart';
import '../../../utils/globle_method.dart';
import '../enrolled_children/enrolled_chilren_tab_item.dart';
import 'enrolled_exit_chilren_tab_item.dart';

class EnrolledExitChilrenTab extends StatefulWidget {
  final String CHHGUID;
  final String HHGUID;
  final String EnrolledChilGUID;
  final int HHname;
  final int crecheId;
  final int isNew;
  static String? childName;
  final bool isImageUpdate;
  final bool isEditable;
  String? minDate;
  String? childId;

  EnrolledExitChilrenTab(
      {super.key,
      required this.CHHGUID,
      required this.HHGUID,
      required this.HHname,
      required this.crecheId,
      required this.EnrolledChilGUID,
      required this.isNew,
      required this.isImageUpdate,
      required this.isEditable,
      this.minDate,
      this.childId});

  @override
  _EnrolledChilrenTabState createState() => _EnrolledChilrenTabState();
}

class _EnrolledChilrenTabState extends State<EnrolledExitChilrenTab>
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
  int? isUploaded = 0;

  Future<void> initializeData() async {
    lng = (await Validate().readString(Validate.sLanguage))!;
    role = (await Validate().readString(Validate.role))!;
    translatsLabel.clear();
    List<String> valueNames = [
      CustomText.Save,
      CustomText.Creches,
      CustomText.CrecheCaregiver,
      CustomText.Next,
      CustomText.back
    ];
    await TranslationDataHelper()
        .callTranslateString(valueNames)
        .then((value) => translatsLabel = value);

    await TranslationDataHelper()
        .callTranslateEnrolledChildren()
        .then((value) => translatsLabel.addAll(value));

    await callScrenControllers('Child Profile');
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    } else {
      return Scaffold(
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
                  EnrolledExitChilrenTab.childName != null
                      ? TextSpan(
                          text: '${EnrolledExitChilrenTab.childName!}',
                          style: Styles.white145)
                      : TextSpan(text: ''),
                  Global.validString(widget.childId)
                      ? TextSpan(
                          text:
                              ' ${EnrolledExitChilrenTab.childName != null ? '-' : ''} ${widget.childId}',
                          style: Styles.white145)
                      : TextSpan(text: '')
                ]),
              )
            ],
          ),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: Colors.white,
            unselectedLabelColor: Colors.grey.shade300,
            unselectedLabelStyle: Styles.white124P,
            labelColor: Colors.white,
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
            controller: _tabController,
            isScrollable: true,
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
      );
    }
  }

  List<Widget> tabControllerScreen() {
    List<Widget> tabItem = [];
    for (int i = 0; i < tabBreakItems.length; i++) {
      if (tabBreakItems[i].parent == 'Child Profile') {
        tabItem.add(EnrolledChilrenTabItem(
          isEditable: widget.isEditable,
          EnrolledChilGUID: widget.EnrolledChilGUID,
          HHGUID: widget.HHGUID,
          cHHGuid: widget.CHHGUID,
          isImageUpdate: widget.isImageUpdate,
          crecheId: widget.crecheId,
          tabBreakItem: tabBreakItems[i],
          screenItem: expendedItems,
          changeTab: changeTab,
          minDate: widget.minDate,
          tabIndex: i,
          isNew: widget.isNew,
          totalTab: tabBreakItems.length,
          isUploaded: isUploaded,
        ));
      } else if (tabBreakItems[i].parent == 'Child Enrollment and Exit') {
        tabItem.add(EnrolledExitChildTabItem(
          isForExit: false,
          isEditable: widget.isEditable,
          EnrolledChilGUID: widget.EnrolledChilGUID,
          cHHGuid: widget.CHHGUID,
          isImageUpdate: widget.isImageUpdate,
          crecheId: widget.crecheId,
          HHname: widget.HHname,
          tabBreakItem: tabBreakItems[i],
          screenItem: expendedItems,
          changeTab: changeTab,
          minDate: widget.minDate,
          tabIndex: i,
          isNew: widget.isNew,
          screenType: 'Child Enrollment and Exit',
          totalTab: tabBreakItems.length,
          isUploaded: isUploaded,
        ));
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

  Future<void> callScrenControllers(screen_type) async {
    List<HouseHoldFielItemdModel> allItems = [];
    var lngtr = await Validate().readString(Validate.sLanguage);
    if (lngtr != null) {
      lng = lngtr;
    }
    List<HouseHoldFielItemdModel> tempBreakDown = [];
    await EnrolledExitChildrenFieldHelper()
        .callEnrolledExitMeta()
        .then((value) async {
      allItems = value;
      // tabBreakItems = allItems
      //     .where((element) => element.fieldtype == CustomText.tabBreak)
      //     .toList();
    });

    await EnrolledChildrenFieldHelper()
        .getChildHHFieldsForm(screen_type)
        .then((value) async {
      allItems.addAll(value);
      var tabsItems = allItems
          .where((element) => element.fieldtype == CustomText.tabBreak)
          .toList();
      tabBreakItems = tabsItems;
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
    var childProfile =
        allItems.where((element) => element.parent == 'Child Profile').toList();
    var childEnrolled = allItems
        .where((element) => element.parent == 'Child Enrollment and Exit')
        .toList();
    for (int i = 0; i < tabBreakItems.length; i++) {
      if (i < (tabBreakItems.length) - 1) {
        if (tabBreakItems[i].parent == 'Child Enrollment and Exit') {
          expendedItems[tabBreakItems[i].name!] = childEnrolled;
        } else {
          var filtredItem = childProfile
              .where((element) =>
                  element.idx! > tabBreakItems[i].idx! &&
                  element.idx! < tabBreakItems[i + 1].idx!)
              .toList();
          expendedItems[tabBreakItems[i].name!] = filtredItem;
        }
      } else {
        if (tabBreakItems[i].parent == 'Child Enrollment and Exit') {
          expendedItems[tabBreakItems[i].name!] = childEnrolled;
        } else {
          var filtredItem = childProfile
              .where((element) => element.idx! > tabBreakItems[i].idx!)
              .toList();
          expendedItems[tabBreakItems[i].name!] = filtredItem;
        }
      }
    }

    _tabController = TabController(length: tabBreakItems.length, vsync: this);
    // _tabController.addListener(handleTabChange);

    var record = await EnrolledExitChilrenResponceHelper()
        .callChildrenResponce(widget.EnrolledChilGUID);
    if (record.isNotEmpty) {
      isUploaded = record.first.is_uploaded;
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    initializeData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<bool> checkConditionsBeforeChangingTab(int index) async {
    bool returnStatus = false;
    var alredRecord = await EnrolledExitChilrenResponceHelper()
        .callChildrenResponce(widget.EnrolledChilGUID);
    // var enrolledChild = await EnrolledChilrenResponceHelper()
    //     .callChildrenResponce(widget.CHHGUID,widget.HHGUID);
    if (alredRecord.isNotEmpty) {
      Map<String, dynamic> responseData = jsonDecode(alredRecord[0].responces!);
      EnrolledExitChilrenTab.childName = responseData['child_name'];
      var items = expendedItems[tabBreakItems[index].name];
      // if (!returnStatus) {
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
          var items = expendedItems[tabBreakItems[_tabController.index].name];
          for (int i = 0; i < items!.length; i++) {
            if (items[i].reqd == 1 &&
                !responseData.containsKey(items[i].fieldname)) {
              returnStatus = false;
              break;
            }
            if (returnStatus && responseData.containsKey(items[i].fieldname)) {
              print("Condition met for tab $index");
              returnStatus = true;
              break;
            }
          }
        }
      }
      // if (!returnStatus) {
      //   if(enrolledChild.length>0){
      //     Map<String, dynamic> enResponce = jsonDecode(enrolledChild.first.responces!);
      //     var nextco = (_tabController.index + 1);
      //     if (nextco == index) {
      //       var items = expendedItems[tabBreakItems[_tabController.index].name];
      //       for (int i = 0; i < items!.length; i++) {
      //         if (items[i].reqd==1 && !enResponce.containsKey(items[i].fieldname)) {
      //           returnStatus = false;
      //           break;
      //         }
      //         if (returnStatus && enResponce.containsKey(items[i].fieldname)) {
      //           print("Condition met for tab $index");
      //           returnStatus = true;
      //           break;
      //         }
      //
      //       }
      //     }
      //   }
      //
      // }
    }
    // Return false if conditions are not met
    return returnStatus;
  }

  Future<bool> checkConditionsBeforeChangingTabProfile(int index) async {
    bool returnStatus = false;
    var alredRecord = await EnrolledChilrenResponceHelper()
        .callChildrenResponce(widget.CHHGUID, widget.HHGUID);
    if (alredRecord.isNotEmpty) {
      Map<String, dynamic> responseData = jsonDecode(alredRecord[0].responces!);
      EnrolledExitChilrenTab.childName = responseData['child_name'];
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
            if (items[i].reqd == 1 &&
                !responseData.containsKey(items[i].fieldname)) {
              returnStatus = false;
              break;
            }
            if (returnStatus && responseData.containsKey(items[i].fieldname)) {
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

  void handleTabChange(int index) async {
    if (index > 0) {
      await checkConditionsBeforeChangingTabProfile(index).then((value) {
        if (value) {
          tabIndex = index;
          setState(() {
            _tabController.index = tabIndex;
          });
        }
        // Navigator.pop(context);
      });
    } else {
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

  Future<void> updateVerificationStatus(BuildContext mContext) async {
    var varyItem = await OptionsModelHelper()
        .getMstCommonOptions('CC Verification status', lng);
    varyItem = varyItem
        .where((element) => (element.name == '2') || (element.name == '3'))
        .toList();
    var verifiable = Global.returnTrLable(
        translatsLabel, CustomText.Verification_status, lng);
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
                                  Global.returnTrLable(translatsLabel,
                                      CustomText.statusUpdateSuccssFully, lng!),
                                  Global.returnTrLable(
                                      translatsLabel, CustomText.ok, lng!),
                                  true,
                                  mContext);
                            } else {
                              Validate().singleButtonPopup(
                                  Global.returnTrLable(translatsLabel,
                                      CustomText.selectVerifyStatus, lng!),
                                  Global.returnTrLable(
                                      translatsLabel, CustomText.ok, lng!),
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
    var alredRecord = await EnrolledExitChilrenResponceHelper()
        .callChildrenResponce(widget.EnrolledChilGUID);
    if (alredRecord.length > 0) {
      Map<String, dynamic> responseData = jsonDecode(alredRecord[0].responces!);
      responseData['status'] = value!.name;
      var name = responseData['name'];
      var userName = (await Validate().readString(Validate.userName))!;
      responseData['app_updated_on'] = Validate().currentDateTime();
      responseData['app_updated_by'] = userName;
      responseData['verified_by'] = userName;
      responseData['verified_on'] = Validate().currentDateTime();
      var responcesJs = jsonEncode(responseData);
      await EnrolledExitChilrenResponceHelper().insertUpdate(
          widget.EnrolledChilGUID,
          widget.CHHGUID,
          widget.HHname,
          name,
          Global.stringToInt(responseData['creche_id'].toString()),
          responcesJs,
          responseData['appcreated_on'],
          responseData['appcreated_by'],
          responseData['app_updated_on'],
          responseData['app_updated_by'],
          responseData['date_of_exit']);
    }
  }
}
