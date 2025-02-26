import 'dart:async';
import 'dart:convert';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shishughar/custom_widget/dynamic_screen_widget/dynamic_custom_time_picker.dart';
import 'package:shishughar/database/helper/translation_language_helper.dart';
import 'package:shishughar/model/apimodel/form_logic_api_model.dart';
import 'package:shishughar/model/apimodel/translation_language_api_model.dart';
import 'package:shishughar/screens/tabed_screens/house_hold/depending_logic.dart';

import 'package:shishughar/utils/validate.dart';
import '../../../custom_widget/custom_btn.dart';
import '../../../custom_widget/custom_text.dart';
import '../../../custom_widget/dynamic_screen_widget/custom_dynamic_image_replica.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_custom_dropdown.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_custom_yesno_checkbox.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_customdatepicker.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_customtextfield_int.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_customtextfield_new.dart';
import '../../../database/helper/creche_helper/creche_data_helper.dart';
import '../../../database/helper/dynamic_screen_helper/options_model_helper.dart';
import '../../../database/helper/form_logic_helper.dart';
import '../../../database/helper/image_file_tab_responce_helper.dart';
import '../../../model/apimodel/creche_database_responce_model.dart';
import '../../../model/apimodel/house_hold_field_item_model_api.dart';
import '../../../model/databasemodel/tab_image_file_model.dart';
import '../../../model/dynamic_screen_model/options_model.dart';
import '../../../utils/globle_method.dart';

class CrecheScreenItem extends StatefulWidget {
  final int name;
  final HouseHoldFielItemdModel tabBreakItem;
  final Map<String, List<HouseHoldFielItemdModel>> screenItem;
  final Function(int) changeTab;
  final int tabIndex;
  final int totalTab;
  final bool isUpdate;

  const CrecheScreenItem(
      {super.key,
      required this.name,
      required this.tabBreakItem,
      required this.screenItem,
      required this.changeTab,
      required this.tabIndex,
      required this.totalTab,
      required this.isUpdate});

  @override
  _CrecheScreenItemState createState() => _CrecheScreenItemState();
}

class _CrecheScreenItemState extends State<CrecheScreenItem> {
  bool _isLoading = true;
  // List<HouseHoldTabResponceMosdel> retrivedList = [];
  // List<HouseHoldFielItemdModel> modifiedItems = [];
  List<OptionsModel> options = [];
  DependingLogic? logic;
  Map<String, dynamic> myMap = {};
  List<Translation> translats = [];
  String userName = '';
  String? saveNext = CustomText.Next;
  String? responce;
  String lng = "en";
  bool isNew = true;
  String? role;
  bool isOnlyView = false;
  Map<String, FocusNode> _focusNode = {};
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    calinitialScreen();
    var items = widget.screenItem[widget.tabBreakItem.name]!;

    for (var elements in items) {
      _focusNode.addEntries([MapEntry(elements.fieldname!, FocusNode())]);
    }
    _scrollController.addListener(() {
      if (_scrollController.position.isScrollingNotifier.value) {
        _focusNode.forEach((_, focusNode) => focusNode.unfocus());
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _focusNode.forEach((_, focusNode) => focusNode.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
          color: Colors.white,
          child: Center(child: CircularProgressIndicator()));
    } else {
      return Scaffold(
        body: Column(
          children: [
            Divider(),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: cWidget(widget.tabBreakItem.name!),
                  ),
                ),
              ),
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
              child: Row(
                children: [
                  Expanded(
                    child: CElevatedButton(
                      color: Color(0xffF26BA3),
                      onPressed: () {
                        // ch(2);
                        nextTab(0);
                      },
                      text:
                          Global.returnTrLable(translats, CustomText.back, lng)
                              .trim(),
                    ),
                  ),
                  SizedBox(width: 10),
                  isOnlyView
                      ? SizedBox()
                      : Expanded(
                          child: CElevatedButton(
                            color: Color(0xff5979AA),
                            onPressed: () {
                              saveData(1);
                              // widget.changeTab(1);
                            },
                            text: Global.returnTrLable(translats, "Save", lng)
                                .trim(),
                          ),
                        ),
                  isOnlyView ? SizedBox() : SizedBox(width: 10),
                  Expanded(
                    child: CElevatedButton(
                      color: Color(0xff369A8D),
                      onPressed: () {
                        if (isOnlyView == false) {
                          nextTab(1);
                        } else {
                          widget.changeTab(1);
                          setState(() {});
                        }
                        // widget.changeTab(1);
                      },
                      text:
                          Global.returnTrLable(translats, CustomText.Next, lng),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
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

  widgetTypeWidget(
    int index,
    HouseHoldFielItemdModel quesItem,
  ) {
    // if (quesItem.fieldtype == CustomText.columnBreak) {
    //   return Divider(
    //       color: Colors
    //           .grey); // You can customize the color and thickness of the Divider as needed
    // }
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
          selectedItem: myMap[quesItem.fieldname],
          readable: isOnlyView ? true : logic!.callReadableLogic(myMap, quesItem),
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
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : logic!.dependeOnMendotory(myMap, quesItem),
          calenderValidate: [],
          readable: isOnlyView ? true : logic!.callReadableLogic(myMap, quesItem),
          onChanged: (value) {
            myMap[quesItem.fieldname!] = value;
            var logData = logic!.callDateDiffrenceLogic(myMap, quesItem);
            if (logData.isNotEmpty) {
              if (logData.keys.length > 0) {
                myMap.addEntries(
                    [MapEntry(logData.keys.first, logData.values.first)]);
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
          readable:
              isOnlyView ? true : logic!.callReadableLogic(myMap, quesItem),
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
          readable:
              isOnlyView ? true : logic!.callReadableLogic(myMap, quesItem),
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
      // case 'Check':
      //   return DynamicCustomCheckboxWithLabel(
      //     label: Global.returnTrLable(translats, quesItem.label!.trim(), lng),
      //     initialValue: myMap[quesItem.fieldname!],
      //     isVisible:
      //         logic!.callDependingLogic( myMap, quesItem),
      //     onChanged: (value) {
      //       if (value > 0)
      //         myMap[quesItem.fieldname!] = value;
      //       else
      //         myMap.remove(quesItem.fieldname);
      //       setState(() {});
      //     },
      //   );
      case 'Attach':
        return CustomImageDynamicReplica(
          // isDelitable: widget.isUpdate == true ? false : true,
          translats: translats,
          lng: lng,
          isDelitable: true,
          docType: CustomText.Creches,
          child_guid: widget.name.toString(),
          readable: isOnlyView,
          assetPath: myMap[quesItem.fieldname!],
          titleText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng),
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : logic!.dependeOnMendotory(myMap, quesItem),
          onChanged: (value) async {},
          onDelete: (value) async {
            if (value) {
              myMap.remove(quesItem.fieldname);
              // myMap[quesItem.fieldname!] = "duduludutdu";
              setState(() {});
            }
          },
          onName: (value) async {
            if (Global.validString(value)) {
              myMap[quesItem.fieldname!] = value;
              await saveImageInDatabase(
                  value, Global.validToString(quesItem.fieldname));
              setState(() {});
            }
          },
        );
      case 'Long Text':
        return DynamicCustomTextFieldNew(
          focusNode: _focusNode[quesItem.fieldname],
          maxline: 3,
          titleText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng!),
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : logic!.dependeOnMendotory(myMap, quesItem),
          initialvalue: myMap[quesItem.fieldname!],
          maxlength: quesItem.length,
          readable:
              isOnlyView ? true : logic!.callReadableLogic(myMap, quesItem),
          hintText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng!),
          isVisible: logic!.callDependingLogic(myMap, quesItem),
          onChanged: (value) {
            if (value.isNotEmpty)
              myMap[quesItem.fieldname!] = value;
            else
              myMap.remove(quesItem.fieldname);
          },
        );
      case 'Check':
        return DynamicCustomYesNoCheckboxWithLabel(
          label: Global.returnTrLable(translats, quesItem.label!.trim(), lng),
          initialValue: myMap[quesItem.fieldname],
          labelControlls: translats,
          lng: lng,
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : logic!.dependeOnMendotory(myMap, quesItem),
          readable:
              isOnlyView ? true : logic!.callReadableLogic(myMap, quesItem),
          isVisible: logic!.callDependingLogic(myMap, quesItem),
          onChanged: (value) {
            // if (value > 0)
            print('yesNo $value');
            myMap[quesItem.fieldname!] = value;
            // else
            //   myMap.remove(quesItem.fieldname);
            setState(() {});
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
          readable:
              isOnlyView ? true : logic!.callReadableLogic(myMap, quesItem),
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
          readable:
              isOnlyView ? true : logic!.callReadableLogic(myMap, quesItem),
          initialvalue: myMap[quesItem.fieldname!],
          onChanged: (value) {
            print('Entered text: $value');
            if (value.isNotEmpty)
              myMap[quesItem.fieldname!] = value;
            else
              myMap.remove(quesItem.fieldname);
          },
        );
      case 'Geolocation':
        return CElevatedButton(
          text: (isNew == true)
              ? Global.returnTrLable(translats, quesItem.label!.trim(), lng)
              : Global.returnTrLable(translats, CustomText.UpdateLocation, lng),
          onPressed: () {
            if (isOnlyView == false) {
              checkPermissionStatus(quesItem.fieldname!);
            }
          },
        );
      case 'Time':
        return CustomTimepickerDynamic(
          initialvalue: myMap[quesItem.fieldname!],
          fieldName: quesItem.fieldname,
          readable:
          isOnlyView ? true : logic!.callReadableLogic(myMap, quesItem),
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : logic!.dependeOnMendotory(myMap, quesItem),
          isVisible: logic!.callDependingLogic(myMap, quesItem),
          onChanged: (value) {
            myMap[quesItem.fieldname!] = value;
            var logData = logic!.callDateDiffrenceLogic(myMap, quesItem);
            if (logData.isNotEmpty) {
              if (logData.keys.length > 0) {
                myMap.addEntries(
                    [MapEntry(logData.keys.first, logData.values.first)]);
                setState(() {});
              }
            }
          },
          titleText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng),
        );
      default:
        return SizedBox();
    }
  }

  Future<void> callScrenControllers(screen_type) async {
    lng = (await Validate().readString(Validate.sLanguage))!;
    var alredRecord =
        await CrecheDataHelper().getCrecheResponceItem(widget.name);
    Map<String, dynamic> responseData = {};
    if (alredRecord.isNotEmpty) {
      responseData = jsonDecode(alredRecord[0].responces!);
    }
    List<HouseHoldFielItemdModel> items =
        widget.screenItem[widget.tabBreakItem.name!]!;
    await updateHiddenValue();
    List<String> defaultCommon = [];
    List<String> logicFields = [];

    for (int i = 0; i < items.length; i++) {
      if (Global.validString(items[i].options)) {
        if (!(items[i].options == 'Creche')) {
          if ((items[i].options == 'State') ||
              (items[i].options == 'District') ||
              (items[i].options == 'Block') ||
              (items[i].options == 'Gram Panchayat') ||
              (items[i].options == 'Village') ||
              (items[i].options == 'User') ||
              (items[i].options == 'Days Of Week') ||
              (items[i].options == 'Partner')) {
            if (items[i].options == 'Partner' || items[i].options == 'User') {
              await OptionsModelHelper()
                  .getPartnerMstCommonOptions(
                      items[i].options!.trim(), responseData)
                  .then((data) {
                options.addAll(data);
              });
              defaultDisableDailog(items[i].fieldname!, items[i].options!);
            } else if (items[i].options == 'Days Of Week') {
              await OptionsModelHelper()
                  .callDayOfWeekMstCommonOptions(items[i].options!.trim(), lng)
                  .then((data) {
                options.addAll(data);
              });
            } else {
              await OptionsModelHelper()
                  .getLocationData(items[i].options!.trim(), responseData, lng)
                  .then((data) {
                options.addAll(data);
              });
              defaultDisableDailog(items[i].fieldname!, items[i].options!);
            }
          } else {
            defaultCommon.add('tab${items[i].options!.trim()}');
          }
        } else {
          // defaultCommon.add('tab${items[i].options!.trim()}');
        }
      }
      logicFields.add(items[i].fieldname!);
    }
    print("item v ${defaultCommon.length}");
    await OptionsModelHelper()
        .getAllMstCommonNotINOptions(defaultCommon, lng!)
        .then((data) {
      options.addAll(data);
    });
    List<String> labelTranslats = [];
    for (var element in items) {
      if (Global.validString(element.label)) {
        labelTranslats.add(element.label!);
      }
    }
    await TranslationDataHelper()
        .callTranslateString(labelTranslats)
        .then((value) => translats.addAll(value));

    await FormLogicDataHelper().callFormLogic(screen_type).then((data) {
      logic = DependingLogic(translats, data, lng);
    });
    // var latsLongs = items
    //     .where((element) =>
    //         element.fieldname == 'latitude' || element.fieldname == 'longitude')
    //     .toList();
    // if (latsLongs.isNotEmpty) {
    //   var itemIndex = items.indexOf(latsLongs[0]);
    //   latsLongs[0].fieldtype = 'Location';
    //   // items.insert(itemIndex, latsLongs[0]);
    //   items[itemIndex] = latsLongs[0];
    //   items.remove(latsLongs[1]);
    // }
    // modifiedItems = items;
  }

  Future<void> calinitialScreen() async {
    role = (await Validate().readString(Validate.role))!;
    userName = (await Validate().readString(Validate.userName))!;
    translats.clear();
    await setLabelTextData();
    await TranslationDataHelper()
        .callCresheTranslate()
        .then((value) => translats.addAll(value));
    await callScrenControllers(CustomText.Creches);
    isOnlyView = role == CustomText.crecheSupervisor.trim() ? false : true;
    setState(() {
      _isLoading = false;
    });
  }

  defaultDisableDailog(String fieldName, String flag) async {
    var tabName = 'tab$flag';
    var item = options.where((element) => element.flag == tabName).toList();
    if (item.length > 0) {
      myMap[fieldName] = item.first.name!;
    }
  }

  nextTab(int type) async {
    if (type == 1) {
      if (_checkValidation()) {
        if (widget.tabIndex < (widget.totalTab - 1)) {
          await saveDataInData();
        } else if (widget.tabIndex == (widget.totalTab - 1)) {
          await saveDataInData();
          Validate().singleButtonPopup(
              Global.returnTrLable(translats, CustomText.dataSaveSuc, lng),
              Global.returnTrLable(translats, CustomText.ok, lng!),
              false,
              context);
        }
        widget.changeTab(type);
        setState(() {});
      } else {
        // Validate().singleButtonPopup(Global.returnTrLable(
        //     translats, CustomText.plsFilManForm, lng),Global.returnTrLable(
        //     translats, CustomText.ok, lng!),false,context);
      }
    } else {
      if (widget.tabIndex == 0) {
        Navigator.pop(context, 'itemRefresh');
      } else {
        widget.changeTab(type);
      }
    }
  }

  saveData(int type) async {
    if (type == 1) {
      if (_checkValidation()) {
        if (widget.tabIndex < (widget.totalTab - 1)) {
          await saveDataInData();
        } else if (widget.tabIndex == (widget.totalTab - 1)) {
          await saveDataInData();
          // Validate().singleButtonPopup(Global.returnTrLable(
          //     translats, CustomText.dataSaveSuc, lng),Global.returnTrLable(
          //     translats, CustomText.ok, lng!),false,context);
        }
        // widget.changeTab(type);
        // setState(() {});
        Validate().singleButtonPopup(
            Global.returnTrLable(translats, CustomText.dataSaveSuc, lng),
            Global.returnTrLable(translats, CustomText.ok, lng!),
            false,
            context);
      } else {
        // Validate().singleButtonPopup(Global.returnTrLable(
        //     translats, CustomText.plsFilManForm, lng),Global.returnTrLable(
        //     translats, CustomText.ok, lng!),false,context);
      }
    } else {
      if (widget.tabIndex == 0) {
        // Navigator.pop(context, 'itemRefresh');
      } else {
        widget.changeTab(type);
      }
    }
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
                Global.returnTrLable(translats, CustomText.ok, lng!),
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
              Global.returnTrLable(translats, CustomText.ok, lng!),
              false,
              context);
          validStatus = false;
          break;
        }
      }
      ;
    } else {
      print("selected items is null");
    }

    return validStatus;
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

  Future<void> saveDataInData() async {
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
      print(responcesJs);
      var item = CresheDatabaseResponceModel(
        name: name,
        responces: responcesJs,
        is_uploaded: 0,
        is_edited: 1,
        is_deleted: 0,
        created_at: myMap['app_created_on'],
        created_by: myMap['app_created_by'],
        update_at: myMap['app_updated_on'],
        updated_by: myMap['app_updated_by'],
      );
      await CrecheDataHelper().inserts(item);
    }
  }

  Future<void> updateHiddenValue() async {
    var allFields = widget.screenItem[widget.tabBreakItem.name];
    var alredRecord =
        await CrecheDataHelper().getCrecheResponceItem(widget.name);

    if (alredRecord.length > 0) {
      Map<String, dynamic> responseData = jsonDecode(alredRecord[0].responces!);
      responseData.forEach((key, value) {
        myMap[key] = value;
      });
      if (responseData['app_created_on'] != null ||
          responseData['app_created_by'] != null) {
        myMap['app_updated_on'] = Validate().currentDateTime();
        myMap['app_updated_by'] = userName;
      } else {
        myMap['app_created_by'] = userName;
        myMap['app_created_on'] = Validate().currentDateTime();
      }
    } else {
      myMap['app_created_by'] = userName;
      myMap['app_created_on'] = Validate().currentDateTime();
    }
    var lats = myMap['latitude'];
    var longs = myMap['longitude'];
    if (lats != null && longs != null) {
      setState(() {
        isNew = false;
      });
    }
  }

  Future<void> setLabelTextData() async {
    List<String> valueNames = [
      CustomText.back,
      CustomText.Next,
      CustomText.plsFilManForm,
      CustomText.pleaseWait,
      CustomText.dataSaveSuc,
      CustomText.ok,
      CustomText.Save,
      CustomText.UpdateLocation,
      CustomText.select_here,
      CustomText.Yes,
      CustomText.No,
      CustomText.SelectOneoption,
      CustomText.Camera,
      CustomText.Gallery,
      CustomText.typehere,
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

    await TranslationDataHelper()
        .callTranslateString(valueNames)
        .then((value) => translats.addAll(value));
  }

  Future<void> getLocation(String fieldName) async {
    var location = Location();

    try {
      showLoaderDialog(context);
      LocationData currentLocation = await location.getLocation();
      // Use currentLocation.latitude and currentLocation.longitude
      print(
          'Latitude: ${currentLocation.latitude}, Longitude: ${currentLocation.longitude}');
      myMap['latitude'] = '${currentLocation.latitude}';
      myMap['longitude'] = '${currentLocation.longitude}';
      myMap[fieldName] =
          '${currentLocation.latitude},${currentLocation.longitude}';
      isNew = false;
      setState(() {});
      // Navigator.pop(context);
    } catch (e) {
      // Handle errors, such as no GPS signal or permissions denied
      print('Error getting location: $e');
    } finally {
      Navigator.pop(context);
    }
  }

  Future<Position> getCurrentPositionWithTimeout() async {
    int retryCount = 0;

    // Retry loop to get current location
    while (retryCount < 2) {
      try {
        // Attempt to get the current position with a 10-second timeout
        var position = await Geolocator.getCurrentPosition()
            .timeout(Duration(seconds: 10));
        return position; // If successful, return the position
      } catch (e) {
        if (e is TimeoutException) {
          retryCount++;
          print('Timeout reached, retrying... ($retryCount)');
          await Future.delayed(Duration(seconds: 1)); // Wait before retrying
        } else {
          try {
            // Fallback to Location package if Geolocator fails
            final locationData = await Location().getLocation();
            if (locationData.latitude != null &&
                locationData.longitude != null) {
              return Position(
                latitude: locationData.latitude ?? 0.0,
                longitude: locationData.longitude ?? 0.0,
                altitude: locationData.altitude ?? 0.0,
                accuracy: locationData.accuracy ?? 0.0,
                heading: locationData.heading ?? 0.0,
                speed: locationData.speed ?? 0.0,
                speedAccuracy: locationData.speedAccuracy ?? 0.0,
                timestamp: locationData.time != null
                    ? DateTime.fromMillisecondsSinceEpoch(
                        locationData.time!.toInt())
                    : DateTime.now(),
                altitudeAccuracy: locationData.accuracy ?? 0.0,
                headingAccuracy: locationData.accuracy ?? 0.0,
              );
            } else {
              // If Location package fails, fallback to last known position
              Position? lastKnownPosition =
                  await Geolocator.getLastKnownPosition();
              if (lastKnownPosition != null) {
                return lastKnownPosition; // Return the last known position if available
              } else
                rethrow; // Rethrow if no valid data found
            }
          } catch (e) {
            print('Error using Location package: $e');
            // Try to get the last known position as a final fallback
            Position? lastKnownPosition =
                await Geolocator.getLastKnownPosition();
            if (lastKnownPosition != null) {
              return lastKnownPosition; // Return last known position
            } else
              rethrow; // If all options fail, rethrow the error
          }
        }
      }
    }

    // If both retries and fallbacks fail, throw TimeoutException
    throw TimeoutException(
        'Failed to get current position after $retryCount retries and no valid last known position.');
  }

  Future<void> _getLocation(String fieldName) async {
    try {
      showLoaderDialog(context);

      final currentLocation = await getCurrentPositionWithTimeout();

      myMap['latitude'] = '${currentLocation.latitude}';
      myMap['longitude'] = '${currentLocation.longitude}';
      myMap[fieldName] =
          '${currentLocation.latitude},${currentLocation.longitude}';
      isNew = false;
      setState(() {});
    } catch (e) {
      if (e is TimeoutException) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Location is not captured. Please try again.")));
      }
      print('Error getting location: $e');
    } finally {
      Navigator.pop(context);
    }
  }

  Future<void> checkPermissionStatus(String fieldName) async {
    var status = await Permission.location.status;
    if (status.isDenied) {
      status = await Permission.location.request();
      if (status.isGranted) {
        await requestServiceEnable(fieldName);
      } else {
        bool shouldProceed = await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: Text('Permission Required'),
              content: Text('Please allow location permission'),
              actions: [
                TextButton(
                  onPressed: () async {
                    await AppSettings.openAppSettings();
                    Navigator.of(context).pop(true);
                  },
                  child: Text('Settings'),
                ),
              ],
            );
          },
        );
        if (shouldProceed == true) {
          var status = await Permission.location.status;
          if (status.isGranted) {
            await requestServiceEnable(fieldName);
          }
        }
      }
    } else {
      await requestServiceEnable(fieldName);
    }
  }

  Future<void> requestServiceEnable(String fieldName) async {
    Location location = Location();
    bool serviceEnabled;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      } else {
        await _getLocation(fieldName);
      }
    } else {
      await _getLocation(fieldName);
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
                SizedBox(height: 10.h),
                Text(Global.returnTrLable(
                    translats, CustomText.pleaseWait, lng!)),
              ],
            ),
          ),
        );
      },
    );
  }

  saveImageInDatabase(String imageName, String imageFieldName) async {
    var item = await ImageFileTabHelper()
        .getImageByDoctypeId(widget.name.toString(), CustomText.Creches);
    var items = ImageFileTabResponceModel(
      image_name: imageName,
      doctype: CustomText.Creches,
      field_name: imageFieldName,
      doctype_guid: widget.name.toString(),
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
}
