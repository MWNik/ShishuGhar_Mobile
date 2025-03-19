import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/custom_widget/custom_btn.dart';
import 'package:shishughar/custom_widget/custom_text.dart';
import 'package:shishughar/database/helper/dynamic_screen_helper/house_hold_tab_responce.dart';
import 'package:shishughar/database/helper/enrolled_exit_child/enrolled_exit_child_responce_helper.dart';
import 'package:shishughar/model/apimodel/form_logic_api_model.dart';
import 'package:shishughar/model/apimodel/house_hold_field_item_model_api.dart';
import 'package:shishughar/model/apimodel/translation_language_api_model.dart';
import 'package:shishughar/model/dynamic_screen_model/enrolled_children_responce_model.dart';
import 'package:shishughar/model/dynamic_screen_model/options_model.dart';
import 'package:shishughar/screens/tabed_screens/enrolled_exit_child/enrolled_exit_child_tab.dart';
import 'package:shishughar/utils/validate.dart';

import '../../../custom_widget/dynamic_screen_widget/custom_dynamic_image.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_custom_dropdown.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_custom_textfield_float.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_custom_yesno_checkbox.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_customdatepicker.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_customtextfield_int.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_customtextfield_new.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamin_multi_check_screen.dart';
import '../../../custom_widget/single_poup_dailog.dart';
import '../../../database/helper/creche_helper/creche_data_helper.dart';
import '../../../database/helper/dynamic_screen_helper/house_hold_children_helper.dart';
import '../../../database/helper/enrolled_children/enrolled_children_field_helper.dart';
import '../../../database/helper/enrolled_children/enrolled_children_responce_helper.dart';
import '../../../database/helper/form_logic_helper.dart';
import '../../../database/helper/image_file_tab_responce_helper.dart';
import '../../../model/databasemodel/tab_image_file_model.dart';
import '../../../utils/globle_method.dart';
import '../../../database/helper/dynamic_screen_helper/options_model_helper.dart';
import '../../../database/helper/translation_language_helper.dart';
import '../house_hold/depending_logic.dart';
import 'enrolled_children_tab.dart';

class EnrolledChilrenTabItem extends StatefulWidget {
  final String HHGUID;
  final String cHHGuid;
  final String EnrolledChilGUID;
  final HouseHoldFielItemdModel tabBreakItem;
  final Map<String, List<HouseHoldFielItemdModel>> screenItem;
  final Function(int) changeTab;
  final int tabIndex;
  final int crecheId;
  final int totalTab;
  final int isNew;
  final bool isImageUpdate;
  final bool isEditable;
  String? minDate;
  int? isUploaded;

  EnrolledChilrenTabItem(
      {super.key,
      required this.HHGUID,
      required this.EnrolledChilGUID,
      required this.cHHGuid,
      required this.tabBreakItem,
      required this.screenItem,
      required this.changeTab,
      required this.tabIndex,
      required this.totalTab,
      required this.isNew,
      required this.crecheId,
      required this.isImageUpdate,
      required this.isEditable,
      this.minDate,
      this.isUploaded});

  @override
  _EnrolledChilrenTabItemState createState() => _EnrolledChilrenTabItemState();
}

class _EnrolledChilrenTabItemState extends State<EnrolledChilrenTabItem> {
  bool _isLoading = true;
  bool shouldEditMesure = false;
  List<HouseHoldTabResponceHelper> retrivedList = [];
  List<OptionsModel> options = [];
  DependingLogic? logic;
  List<HouseHoldFielItemdModel> multselectItemTab = [];
  Map<String, dynamic> myMap = {};
  List<Translation> translats = [];
  String userName = '';
  String? saveNext = CustomText.Next;
  String? responce;
  String? role;
  String lng = 'eng';
  bool isRecordNew = true;
  String genderId = '';
  int? isEditedFromExisting = 0;
  int? isUploaded = 0;
  Map<String, FocusNode> _focusNode = {};
  ScrollController _searchController = ScrollController();

  @override
  void initState() {
    super.initState();
    initializeData();
    var items = widget.screenItem[widget.tabBreakItem.name]!;
    for (var elements in items) {
      _focusNode.addEntries([MapEntry(elements.fieldname!, FocusNode())]);
    }
    _searchController.addListener(() {
      if (_searchController.position.isScrollingNotifier.value) {
        _focusNode.forEach((_, focusNode) {
          focusNode.unfocus();
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.forEach((_, focusNode) => focusNode.dispose);
    super.dispose();
  }

  Future<void> initializeData() async {
    userName = (await Validate().readString(Validate.userName))!;
    role = await Validate().readString(Validate.role);
    List<String> valueNames = [
      CustomText.Creches,
      CustomText.Next,
      CustomText.back,
      CustomText.ok,
      CustomText.exit,
      CustomText.ChildEnrollsuccess,
      CustomText.enrolled,
      CustomText.Enroll,
      CustomText.Save,
      CustomText.Yes,
      CustomText.No,
      CustomText.select_here,
      CustomText.typehere,
      CustomText.Submit,
      CustomText.plsFilManForm,
      CustomText.dataSaveSuc,
      CustomText.childUpdatedSucces,
      CustomText.valuLesThanOrEqual,
      CustomText.valueLesThan,
      CustomText.valuGreaterThanOrEqual,
      CustomText.valuGreaterThan,
      CustomText.valuEqual,
      CustomText.plsSelectIn,
      CustomText.valuLenLessOrEqual,
      CustomText.valuLenGreaterOrEqual,
      CustomText.valuLenEqual,
      CustomText.PleaseEnterValueIn,
      CustomText.PleaseSelectAfterTimeIn,
      CustomText.PleaseSelectAfterDateIn,
      CustomText.PleaseSelectBeforTimeIn,
      CustomText.PleaseSelectBeforDateIn,
      CustomText.PleaseSelectBeforTimeInIsValidTime,
      CustomText.plsFilManForm,
      CustomText.wesUsageGraterQuatOpen,
      CustomText.leavingLesThanjoining
    ];
    List<HouseHoldFielItemdModel> items =
        widget.screenItem[widget.tabBreakItem.name!]!;
    items.forEach((element) {
      if (Global.validString(element.label)) {
        valueNames.add(element.label!.trim());
      }
    });

    await TranslationDataHelper()
        .callTranslateString(valueNames)
        .then((value) => translats.addAll(value));

    if (widget.isNew == 1) {
      isRecordNew = false;
    }

    multselectItemTab =
        await EnrolledChildrenFieldHelper().callMultiSelectTabItem();
    await updateHiddenValue();
    await callScrenControllers('Child Profile');
    // calinitialScreen();
    if (widget.tabIndex == (widget.totalTab - 1)) {
      saveNext = CustomText.saveEnrolled;
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, 'itemRefresh');
        return false; // Change this according to your logic
      },
      child: _isLoading
          ? Container(
              color: Colors.white,
              child: Center(child: CircularProgressIndicator()))
          : Scaffold(
              body: Column(
                children: [
                  Divider(),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 10.h),
                      child: SingleChildScrollView(
                        controller: _searchController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: cWidget(widget.tabBreakItem.name!),
                        ),
                      ),
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
                    child: Row(
                      children: [
                        Expanded(
                          child: CElevatedButton(
                            color: Color(0xffF26BA3),
                            onPressed: () {
                              // ch(2);
                              nextTab(0, context);
                            },
                            text: Global.returnTrLable(
                                    translats, CustomText.back, lng)
                                .trim(),
                          ),
                        ),
                        // Row(children: [
                        SizedBox(width: 10),
                        role == 'Creche Supervisor'
                            ? widget.tabIndex == (widget.totalTab - 1)
                                ?
                                //  Expanded(
                                //     child: CElevatedButton(
                                //     color: Color(0xff5979AA),
                                //     onPressed: () {
                                //       Navigator.pop(context, 'itemRefresh');
                                //     },
                                //     text: Global.returnTrLable(
                                //         translats, CustomText.exit, lng),
                                //   ))
                                SizedBox()
                                : (widget.isEditable == true
                                    ? Expanded(
                                        child: CElevatedButton(
                                          color: Color(0xff5979AA),
                                          onPressed: () {
                                            saveOnly(1, context);
                                            // widget.changeTab(1);
                                          },
                                          text: Global.returnTrLable(
                                                  translats, 'Save', lng)
                                              .trim(),
                                        ),
                                      )
                                    : SizedBox())
                            : SizedBox(),
                        // ]
                        // ),
                        role == 'Creche Supervisor'
                            ? widget.tabIndex == (widget.totalTab - 1)
                                ? (widget.isEditable == true
                                    ? SizedBox(width: 10)
                                    : SizedBox())
                                : (widget.isEditable == true
                                    ? SizedBox(width: 10)
                                    : SizedBox())
                            : SizedBox(),
                        widget.tabIndex == (widget.totalTab - 1)
                            ? (widget.isEditable == false
                                ? Expanded(
                                    child: CElevatedButton(
                                    color: Color(0xff5979AA),
                                    onPressed: () {
                                      Navigator.pop(context, 'itemRefresh');
                                    },
                                    text: Global.returnTrLable(
                                        translats, CustomText.exit, lng),
                                  ))
                                : Expanded(
                                    child: CElevatedButton(
                                      color: Color(0xff5979AA),
                                      onPressed: () {
                                        widget.isEditable == true
                                            ? nextTab(1, context)
                                            : widget.changeTab(1);
                                      },
                                      text: widget.tabIndex ==
                                              (widget.totalTab - 1)
                                          ? ((isRecordNew)
                                              ? Global.returnTrLable(translats,
                                                  CustomText.Enroll, lng)
                                              : Global.returnTrLable(translats,
                                                  CustomText.Submit, lng))
                                          : Global.returnTrLable(
                                              translats, CustomText.Next, lng),
                                    ),
                                  ))
                            : Expanded(
                                child: CElevatedButton(
                                  color: Color(0xff369A8D),
                                  onPressed: () {
                                    widget.isEditable == true
                                        ? nextTab(1, context)
                                        : widget.changeTab(1);
                                  },
                                  text: widget.tabIndex == (widget.totalTab - 1)
                                      ? ((isRecordNew)
                                          ? Global.returnTrLable(
                                              translats, CustomText.Enroll, lng)
                                          : Global.returnTrLable(translats,
                                              CustomText.Submit, lng))
                                      : Global.returnTrLable(
                                          translats, CustomText.Next, lng),
                                ),
                              ),
                      ],
                    ),
                  ),

                  // Padding(
                  //   padding:
                  //       EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
                  //   child: Row(
                  //     children: [
                  //       Expanded(
                  //         child: CElevatedButton(
                  //           color: Color(0xffF26BA3),
                  //           onPressed: () {
                  //             // ch(2);
                  //             nextTab(0, context);
                  //           },
                  //           text: Global.returnTrLable(
                  //                   translats, CustomText.back, lng)
                  //               .trim(),
                  //         ),
                  //       ),
                  //       // Row(children: [
                  //       SizedBox(width: 10),
                  //       role == 'Creche Supervisor'
                  //           ? widget.tabIndex == (widget.totalTab - 1)
                  //               ?
                  //               //  Expanded(
                  //               //     child: CElevatedButton(
                  //               //     color: Color(0xff5979AA),
                  //               //     onPressed: () {
                  //               //       Navigator.pop(context, 'itemRefresh');
                  //               //     },
                  //               //     text: Global.returnTrLable(
                  //               //         translats, CustomText.exit, lng),
                  //               //   ))
                  //               SizedBox()
                  //               : (widget.isEditable == true
                  //                   ? Expanded(
                  //                       child: CElevatedButton(
                  //                         color: Color(0xff5979AA),
                  //                         onPressed: () {
                  //                           saveOnly(1, context);
                  //                           // widget.changeTab(1);
                  //                         },
                  //                         text: Global.returnTrLable(
                  //                                 translats, 'Save', lng)
                  //                             .trim(),
                  //                       ),
                  //                     )
                  //                   : SizedBox())
                  //           : SizedBox(),
                  //       // ]
                  //       // ),
                  //       role == 'Creche Supervisor'
                  //           ? widget.tabIndex == (widget.totalTab - 1)
                  //               ? (widget.isEditable == true?SizedBox(width: 10):SizedBox())
                  //               : (widget.isEditable == true
                  //                   ? SizedBox(width: 10)
                  //                   : SizedBox())
                  //           : SizedBox(),
                  //       widget.tabIndex == (widget.totalTab - 1)
                  //           ? (widget.isEditable == false
                  //               ? Expanded(
                  //                   child: CElevatedButton(
                  //                   color: Color(0xff5979AA),
                  //                   onPressed: () {
                  //                     Navigator.pop(context, 'itemRefresh');
                  //                   },
                  //                   text: Global.returnTrLable(
                  //                       translats, CustomText.exit, lng),
                  //                 ))
                  //               : Expanded(
                  //                   child: CElevatedButton(
                  //                     color: Color(0xff5979AA),
                  //                     onPressed: () {
                  //                       widget.isEditable == true
                  //                           ? nextTab(1, context)
                  //                           : widget.changeTab(1);
                  //                     },
                  //                     text: widget.tabIndex ==
                  //                             (widget.totalTab - 1)
                  //                         ? ((isRecordNew)
                  //                             ? Global.returnTrLable(translats,
                  //                                 CustomText.Enroll, lng)
                  //                             : Global.returnTrLable(translats,
                  //                                 CustomText.Submit, lng))
                  //                         : Global.returnTrLable(
                  //                             translats, CustomText.Next, lng),
                  //                   ),
                  //                 ))
                  //           : Expanded(
                  //               child: CElevatedButton(
                  //                 color: Color(0xff369A8D),
                  //                 onPressed: () {
                  //                   widget.isEditable == true
                  //                       ? nextTab(1, context)
                  //                       : widget.changeTab(1);
                  //                 },
                  //                 text: widget.tabIndex == (widget.totalTab - 1)
                  //                     ? ((isRecordNew)
                  //                         ? Global.returnTrLable(
                  //                             translats, CustomText.Enroll, lng)
                  //                         : Global.returnTrLable(translats,
                  //                             CustomText.Submit, lng))
                  //                     : Global.returnTrLable(
                  //                         translats, CustomText.Next, lng),
                  //               ),
                  //             ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
    );
  }

  List<Widget> cWidget(
    String itemId,
  ) {
    List<Widget> screenItems = [];
    var items = widget.screenItem[itemId];
    if (items != null) {
      for (int i = 0; i < items.length; i++) {
        screenItems.add(widgetTypeWidget(i, items[i]));
        screenItems.add(SizedBox(height: 5.h));
        if (!logic!.callDependingLogic(myMap, items[i])) {
          myMap.remove(items[i].fieldname);
        }
      }
    }
    return screenItems;
  }

  widgetTypeWidget(int index, HouseHoldFielItemdModel quesItem) {
    switch (quesItem.fieldtype) {
      case 'Link':
        List<OptionsModel> items = options
            .where((element) => element.flag == 'tab${quesItem.options}')
            .toList();
        return DynamicCustomDropdownField(
          hintText:
              Global.returnTrLable(translats, CustomText.select_here, lng),
          focusNode: _focusNode[quesItem.fieldname],
          titleText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng),
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : logic!.dependeOnMendotory(myMap, quesItem),
          items: items,
          readable: widget.isEditable == true
              ? logic!.callReadableLogic(myMap, quesItem)
              : true,
          selectedItem: myMap[quesItem.fieldname],
          isVisible: logic!.callDependingLogic(myMap, quesItem),
          onChanged: (value) {
            if (value != null)
              myMap[quesItem.fieldname!] = value.name!;
            else
              myMap.remove(quesItem.fieldname);
            setState(() {});
          },
        );
      case 'Date':
        return CustomDatepickerDynamic(
          focusNode: _focusNode[quesItem.fieldname],
          initialvalue: myMap[quesItem.fieldname!],
          fieldName: quesItem.fieldname,
          readable: widget.isEditable == true
              ? logic!.callReadableLogic(myMap, quesItem)
              : true,
          minDate: quesItem.fieldname == 'date_of_enrollment'
              ? Global.validString(widget.minDate)
                  ? DateTime.parse(widget.minDate!).subtract(Duration(days: 1))
                  : null
              : null,
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : logic!.dependeOnMendotory(myMap, quesItem),
          calenderValidate: logic!.calenderValidation(myMap, quesItem),
          isVisible: logic!.callDependingLogic(myMap, quesItem),
          onChanged: (value) {
            myMap[quesItem.fieldname!] = value;
            var logData = logic!.callDateDiffrenceLogic(myMap, quesItem);
            if (logData.isNotEmpty) {
              if (logData.keys.length > 0) {
                // var item =myMap[logData.keys.first];
                // if(item==null||logData.values.first!=item) {
                myMap.addEntries(
                    [MapEntry(logData.keys.first, logData.values.first)]);

                // }
              }
            }
            setState(() {});
          },
          titleText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng),
        );
      case 'Data':
        return DynamicCustomTextFieldNew(
          focusNode: _focusNode[quesItem.fieldname],
          titleText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng),
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : logic!.dependeOnMendotory(myMap, quesItem),
          initialvalue: myMap[quesItem.fieldname!],
          maxlength: quesItem.length,
          keyboard: logic!.keyBoardLogic(quesItem.fieldname!),
          readable: widget.isEditable == true
              ? logic!.callReadableLogic(myMap, quesItem)
              : true,
          hintText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng),
          isVisible: logic!.callDependingLogic(myMap, quesItem),
          onChanged: (value) {
            if (value.isNotEmpty)
              myMap[quesItem.fieldname!] = value;
            else
              myMap.remove(quesItem.fieldname);
          },
        );
      case 'Int':
        return DynamicCustomTextFieldInt(
          hintText: Global.returnTrLable(translats, CustomText.typehere, lng),
          focusNode: _focusNode[quesItem.fieldname],
          keyboardtype: TextInputType.number,
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : logic!.dependeOnMendotory(myMap, quesItem),
          maxlength: quesItem.length,
          initialvalue: myMap[quesItem.fieldname!],
          readable: widget.isEditable == true
              ? logic!.callReadableLogic(myMap, quesItem)
              : true,
          titleText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng),
          isVisible: logic!.callDependingLogic(myMap, quesItem),
          onChanged: (value) {
            print('Entered text: $value');
            if (value != null) {
              myMap[quesItem.fieldname!] = value;
              var logData = logic!.callAutoGeneratedValue(myMap, quesItem);
              if (logData.isNotEmpty) {
                if (logData.keys.length > 0) {
                  myMap.addEntries(
                      [MapEntry(logData.keys.first, logData.values.first)]);
                  // setState(() {});
                }
              }
            } else {
              myMap.remove(quesItem.fieldname);
              // setState(() {});
            }
          },
        );
      case 'Table MultiSelect': // Multi select Drop Down
        String itemResopnceField = '';
        List<OptionsModel> items = options
            .where(
                (element) => element.flag == 'tab${quesItem.multiselectlink}')
            .toList();
        List<HouseHoldFielItemdModel> msFieldName = multselectItemTab
            .where((element) => element.parent == '${quesItem.options}')
            .toList();
        if (msFieldName.length > 0) {
          itemResopnceField = msFieldName[0].fieldname!;
        }
        return DynamicMultiCheckGridView(
          items: items,
          childRatio: quesItem.fieldname == "specially_abled_option" ? 2.2 : 4,
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : logic!.dependeOnMendotory(myMap, quesItem),
          titleText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng),
          isVisible: logic!.callDependingLogic(myMap, quesItem),
          selectedItem: myMap[quesItem.fieldname],
          responceFieldName: itemResopnceField,
          readable: widget.isEditable == true
              ? logic!.callReadableLogic(myMap, quesItem)
              : true,
          onChanged: (value) {
            if (value != null)
              myMap[quesItem.fieldname!] = value;
            else
              myMap.remove(quesItem.fieldname);

            setState(() {});
          },
        );
      // case 'Check':
      //   return DynamicCustomCheckboxWithLabel(
      //     label: Global.returnTrLable(translats, quesItem.label!.trim(), lng),
      //     initialValue: myMap[quesItem.fieldname!],
      //     isVisible: logic!.callDependingLogic(myMap,quesItem),
      //     onChanged: (value) {
      //       if(value>0)
      //         myMap[quesItem.fieldname!] = value;
      //       else myMap.remove(quesItem.fieldname);
      //       setState(() {});
      //     },
      //   );
      case 'Check':
        return DynamicCustomYesNoCheckboxWithLabel(
          label: Global.returnTrLable(translats, quesItem.label!.trim(), lng),
          initialValue: myMap[quesItem.fieldname],
          labelControlls: translats,
          lng: lng,
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : logic!.dependeOnMendotory(myMap, quesItem),
          readable: widget.isEditable == true
              ? logic!.callReadableLogic(myMap, quesItem)
              : true,
          isVisible: logic!.callDependingLogic(myMap, quesItem),
          onChanged: (value) {
            print('yesNo $value');
            myMap[quesItem.fieldname!] = value;
            if (myMap['child_specially_abled'] == 0) {
              myMap['specially_abled_option'] = [];
            }
            setState(() {});
          },
        );
      case 'Long Text':
        return DynamicCustomTextFieldNew(
          focusNode: _focusNode[quesItem.fieldname],
          maxline: 3,
          titleText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng),
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : logic!.dependeOnMendotory(myMap, quesItem),
          initialvalue: myMap[quesItem.fieldname!],
          maxlength: quesItem.length,
          readable: widget.isEditable == true
              ? logic!.callReadableLogic(myMap, quesItem)
              : true,
          hintText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng),
          isVisible: logic!.callDependingLogic(myMap, quesItem),
          onChanged: (value) {
            if (value.isNotEmpty)
              myMap[quesItem.fieldname!] = value;
            else
              myMap.remove(quesItem.fieldname);
          },
        );
      case 'Select':
        return DynamicCustomTextFieldInt(
          focusNode: _focusNode[quesItem.fieldname],
          keyboardtype: TextInputType.number,
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : logic!.dependeOnMendotory(myMap, quesItem),
          maxlength: quesItem.length,
          readable: widget.isEditable == true
              ? logic!.callReadableLogic(myMap, quesItem)
              : true,
          titleText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng),
          initialvalue: myMap[quesItem.fieldname!],
          onChanged: (value) {
            print('Entered text: $value');
            if (value != null)
              myMap[quesItem.fieldname!] = value;
            else {
              myMap.remove(quesItem.fieldname);
              setState(() {});
            }
          },
        );
      case 'Small Text':
        return DynamicCustomTextFieldNew(
          focusNode: _focusNode[quesItem.fieldname],
          titleText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng),
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : logic!.dependeOnMendotory(myMap, quesItem),
          maxlength: quesItem.length,
          readable: widget.isEditable == true
              ? logic!.callReadableLogic(myMap, quesItem)
              : true,
          initialvalue: myMap[quesItem.fieldname!],
          onChanged: (value) {
            print('Entered text: $value');
            if (value.isNotEmpty)
              myMap[quesItem.fieldname!] = value;
            else
              myMap.remove(quesItem.fieldname);
          },
        );
      case 'Float':
        return DynamicCustomTextFieldFloat(
          hintText: Global.returnTrLable(translats, CustomText.typehere, lng),
          focusNode: _focusNode[quesItem.fieldname],
          titleText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng),
          keyboardtype: TextInputType.number,
          isRequred: quesItem.reqd,
          maxlength: quesItem.length,
          fieldName: quesItem.fieldname!,
          initialvalue: myMap[quesItem.fieldname!],
          readable: widget.isEditable == true
              ? (quesItem.fieldname == 'height' ||
                      quesItem.fieldname == 'weight'
                  ? shouldEditMesure
                  : logic!.callReadableLogic(myMap, quesItem))
              : true,
          isVisible: logic!.callDependingLogic(myMap, quesItem),
          onChanged: (value) {
            print('Entered text: $value');
            if (value != null) {
              myMap[quesItem.fieldname!] = value;
              var logData = logic!.callAutoGeneratedValue(myMap, quesItem);
              if (logData.isNotEmpty) {
                if (logData.keys.length > 0) {
                  myMap.addEntries(
                      [MapEntry(logData.keys.first, logData.values.first)]);
                }
              }
            } else {
              myMap.remove(quesItem.fieldname);
            }
          },
        );
      case 'Attach':
        return CustomImageDynamic(
          child_guid: widget.cHHGuid,
          assetPath: myMap[quesItem.fieldname!],
          readable: widget.isEditable == true ? widget.isImageUpdate : true,
          titleText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng),
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : logic!.dependeOnMendotory(myMap, quesItem),
          onChanged: (value) async {},
          onName: (value) async {
            myMap[quesItem.fieldname!] = value;
            await saveImageInDatabase(
                value, Global.validToString(quesItem.fieldname));
            setState(() {});
          },
        );
      default:
        return SizedBox();
    }
  }

  Future<void> callScrenControllers(screen_type) async {
    var lngtr = await Validate().readString(Validate.sLanguage);
    if (lngtr != null) {
      lng = lngtr;
    }
    List<HouseHoldFielItemdModel> items =
        widget.screenItem[widget.tabBreakItem.name!]!;
    List<String> defaultCommon = [];
    List<String> logicFields = [];
    for (int i = 0; i < items.length; i++) {
      if (Global.validString(items[i].options)) {
        if (items[i].options == 'Creche') {
          await OptionsModelHelper()
              .callCrechInOption(items[i].options!.trim(), widget.crecheId)
              .then((data) {
            options.addAll(data);
          });
          defaultDisableDailog(items[i].fieldname!, items[i].options!);
        } else {
          if (items[i].ismultiselect == 1) {
            defaultCommon.add('tab${items[i].multiselectlink!.trim()}');
          } else
            defaultCommon.add('tab${items[i].options!.trim()}');
        }
      }
      logicFields.add(items[i].fieldname!);
    }
    await OptionsModelHelper()
        .getAllMstCommonNotINOptionsWthouASC(defaultCommon, lng)
        .then((data) {
      options.addAll(data);
    });
    await FormLogicDataHelper().callFormLogic(screen_type).then((data) {
      logic = DependingLogic(translats, data, lng);
    });
  }

  defaultDisableDailog(String fieldName, String flag) async {
    var tabName = 'tab$flag';
    var item = options.where((element) => element.flag == tabName).toList();
    if (item.length > 0) {
      myMap[fieldName] = item.first.name!;
    }
  }

  nextTab(int type, BuildContext mContext) async {
    if (type == 1) {
      if (_checkValidation()) {
        if (widget.tabIndex < (widget.totalTab - 1)) {
          await saveDataInData(false);
        } else if (widget.tabIndex == (widget.totalTab - 1)) {
          await saveDataInData(true);
          String msg = Global.returnTrLable(
              translats, CustomText.ChildEnrollsuccess, lng);
          if (!isRecordNew) {
            msg = Global.returnTrLable(
                translats, CustomText.childUpdatedSucces, lng);
          }
          bool shouldProceed = await showDialog(
            context: context,
            builder: (context) {
              return SingleButtonPopupDialog(
                  message: msg,
                  button: Global.returnTrLable(translats, CustomText.ok, lng));
            },
          );
          if (shouldProceed) {
            if (shouldProceed == true) {
              Navigator.pop(context, 'itemRefresh');
            }
          }
          // return;
        }
        widget.changeTab(type);
        setState(() {});
      }
    } else {
      if (widget.tabIndex == 0) {
        Navigator.pop(context, 'itemRefresh');
      } else {
        widget.changeTab(type);
      }
    }
  }

  saveOnly(int type, BuildContext mContext) async {
    if (type == 1) {
      if (_checkValidation()) {
        await saveDataInData(false);
        Validate().singleButtonPopup(
            Global.returnTrLable(translats, CustomText.dataSaveSuc, lng),
            Global.returnTrLable(translats, CustomText.ok, lng),
            false,
            context);
      }
    } else {
      if (widget.tabIndex == 0) {
        Navigator.pop(context, 'itemRefresh');
      } else {
        widget.changeTab(type);
      }
    }
  }

  Future<void> saveDataInData(bool islastindex) async {
    var widgets = widget.screenItem[widget.tabBreakItem.name];
    if (widgets != null) {
      Map<String, dynamic> responces = {};
      widgets.forEach((element) async {
        if (myMap[element.fieldname] != null) {
          responces[element.fieldname!] = myMap[element.fieldname];
        }
      });
      var responcesJs = jsonEncode(myMap);
      var name = myMap['name'];
      EnrolledExitChilrenTab.childName = myMap['child_name'];
      print(responcesJs);
      var childItems = EnrolledChildrenResponceModel(
          CHHGUID: widget.cHHGuid,
          HHGUID: widget.HHGUID,
          name: name as int?,
          responces: responcesJs,
          created_at: myMap['appcreated_on'],
          created_by: myMap['appcreated_by'],
          update_at: myMap['app_updated_on'],
          updated_by: myMap['app_updated_by'],
          is_deleted: 0,
          is_uploaded: 0,
          is_edited: islastindex
              ? 1
              : (isRecordNew
                  ? 2
                  : (widget.isUploaded == 0)
                      ? isEditedFromExisting
                      : 1));
      await EnrolledChilrenResponceHelper().inserts(childItems);
      if (islastindex) {
        await EnrolledExitChilrenResponceHelper()
            .updateEditFlag(widget.cHHGuid, widget.crecheId);
      }

      // if (genderId != Global.getItemValues(responcesJs, 'gender_id')) {
      //   await EnrolledExitChilrenResponceHelper()
      //       .isUpdateEdit(widget.EnrolledChilGUID, responcesJs);
      // }
      if (isRecordNew && myMap['creche_id'] != null) {
        await HouseHoldChildrenHelperHelper().UpdateCrecheId(
            widget.cHHGuid, Global.stringToInt(myMap['creche_id'].toString()));
      }
    }
  }

  String getItemValues(String response, String key) {
    String returnValue = "";
    Map<String, dynamic> itemresponse = jsonDecode(response);
    var value = itemresponse[key];
    if (value != null) {
      returnValue = value.toString();
    }
    return returnValue;
  }

  bool _checkValidation() {
    var validStatus = true;
    var items = widget.screenItem[widget.tabBreakItem.name];
    if (items != null) {
      for (int i = 0; i < items.length; i++) {
        var element = items[i];
        if (element.reqd == 1) {
          var valuees = myMap[element.fieldname];
          if (!Global.validString(valuees.toString().trim())) {
            Validate().singleButtonPopup(
                Global.returnTrLable(translats, CustomText.plsFilManForm, lng),
                Global.returnTrLable(translats, CustomText.ok, lng),
                false,
                context);
            validStatus = false;
            break;
          }
        }
        var validationMsg = logic!.validationMessge(myMap, element);
        if (Global.validString(validationMsg)) {
          Validate().singleButtonPopup(
              validationMsg!,
              Global.returnTrLable(translats, CustomText.ok, lng),
              false,
              context);
          validStatus = false;
          break;
        }
      };
    } else {
      print("selected items is null");
    }

    return validStatus;
  }

  Future<void> updateHiddenValue() async {
    var alredRecord = await EnrolledChilrenResponceHelper()
        .callChildrenResponce(widget.cHHGuid, widget.HHGUID);

    if (alredRecord.length > 0) {
      Map<String, dynamic> responseData = jsonDecode(alredRecord[0].responces!);
      responseData.forEach((key, value) {
        myMap[key] = value;
      });
      isEditedFromExisting = alredRecord[0].is_edited;
      isUploaded = alredRecord[0].is_uploaded;
      if (responseData['appcreated_on'] != null ||
          responseData['appcreated_by'] != null) {
        myMap['app_updated_on'] = Validate().currentDateTime();
        myMap['app_updated_by'] = userName;
      } else {
        myMap['appcreated_by'] = userName;
        myMap['appcreated_on'] = Validate().currentDateTime();
      }
      genderId = Global.getItemValues(alredRecord[0].responces, 'gender_id');
      var name = alredRecord[0].name;
      if (name != null) {
        myMap['name'] = name;
      }
      if (alredRecord.first.is_edited == 0) {
        if (Global.stringToDouble(myMap['height'].toString()) == 0) {
          myMap.remove('height');
        }
        if (Global.stringToDouble(myMap['weight'].toString()) == 0) {
          myMap.remove('weight');
        }
      }

      var enrolledExit = await EnrolledExitChilrenResponceHelper()
          .callChildrenResponce(widget.EnrolledChilGUID);
      if (enrolledExit.length > 0) {
        genderId =
            Global.getItemValues(enrolledExit.first.responces!, 'gender_id');
        myMap['gender_id'] = genderId;
        myMap['child_dob'] =
            Global.getItemValues(enrolledExit.first.responces!, 'child_dob');
        myMap['child_name'] =
            Global.getItemValues(enrolledExit.first.responces!, 'child_name');
      }
    } else {
      var fromHHInfo = await HouseHoldChildrenHelperHelper()
          .callHouseHoldChildrenItem(widget.cHHGuid);
      Map<String, dynamic> responseData = jsonDecode(fromHHInfo[0].responces!);

      genderId = Global.getItemValues(fromHHInfo[0].responces, 'gender_id');

      responseData.forEach((key, value) {
        if (key != 'appcreated_on' &&
            key != 'appcreated_by' &&
            key != 'name' &&
            key != 'hhcguid') myMap[key] = value;
      });

      myMap['appcreated_on'] = Validate().currentDateTime();
      myMap['appcreated_by'] = userName;

      var crecheInfo =
          await CrecheDataHelper().getCrecheResponceItem(widget.crecheId);
      if (crecheInfo.isNotEmpty) {
        Map<String, dynamic> result = jsonDecode(crecheInfo.first.responces!);
        List<String> locationItem = [
          'state_id',
          'district_id',
          'block_id',
          'gp_id',
          'village_id'
        ];
        result.forEach((key, value) {
          if (locationItem.contains(key)) {
            myMap[key] = value;
          }
        });
      }
    }
    myMap['chhguid'] = widget.cHHGuid;
    myMap['hhguid'] = widget.HHGUID;
  }

  saveImageInDatabase(String imageName, String imageFieldName) async {
    var item = await ImageFileTabHelper()
        .getImageByDoctypeId(widget.cHHGuid, CustomText.ChildProfile);
    var items = ImageFileTabResponceModel(
      image_name: imageName,
      doctype: CustomText.ChildProfile,
      field_name: imageFieldName,
      doctype_guid: widget.cHHGuid,
      img_guid: Validate().randomGuid(),
      is_edited: 1,
      update_at: "",
      updated_by: "",
      name: myMap['name'],
      is_uploaded: 0,
      created_at: Validate().currentDateTime(),
      created_by: userName,
    );
    if (item.isEmpty) {
      await ImageFileTabHelper().inserts(items);
    } else {
      await ImageFileTabHelper().updateImageOnlyItem(items);
    }
  }

  // bool crechedOpeningDate() {
  //   DateTime? closingDate = Global.stringToDate(widget.openingDate);
  //   if (closingDate != null) {
  //     return closingDate.isBefore(DateTime.now()) ||
  //         closingDate.isAtSameMomentAs(DateTime.now());
  //   } else
  //     return true;
  // }
}
