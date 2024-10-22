import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/custom_widget/custom_appbar.dart';
import 'package:shishughar/database/helper/village_profile/village_profiile_fileds_helper.dart';
import 'package:shishughar/database/helper/village_profile/village_profile_response_helper.dart';
import 'package:shishughar/model/dynamic_screen_model/village_profile_response_model.dart';
import '../../../../custom_widget/custom_btn.dart';
import '../../../../custom_widget/custom_text.dart';
import '../../../../custom_widget/dynamic_screen_widget/dynamic_custom_dropdown.dart';
import '../../../../custom_widget/dynamic_screen_widget/dynamic_custom_yesno_checkbox.dart';
import '../../../../custom_widget/dynamic_screen_widget/dynamic_customdatepicker.dart';
import '../../../../custom_widget/dynamic_screen_widget/dynamic_customtextfield_int.dart';
import '../../../../custom_widget/dynamic_screen_widget/dynamic_customtextfield_new.dart';
import '../../../../custom_widget/dynamic_screen_widget/dynamin_multi_check_screen.dart';
import '../../../../custom_widget/single_poup_dailog.dart';
import '../../../../database/helper/dynamic_screen_helper/options_model_helper.dart';
import '../../../../database/helper/form_logic_helper.dart';
import '../../../../database/helper/translation_language_helper.dart';
import '../../../../model/apimodel/form_logic_api_model.dart';
import '../../../../model/apimodel/house_hold_field_item_model_api.dart';
import '../../../../model/apimodel/translation_language_api_model.dart';
import '../../../../model/dynamic_screen_model/options_model.dart';
import '../../../../utils/globle_method.dart';
import '../../../../utils/validate.dart';
import '../../house_hold/depending_logic.dart';

class DemograficalDetailsScreen extends StatefulWidget {
  final String dGuid;
  final int vName;
  final bool isEditable;
  final Map<String, dynamic>? demoRec;

  DemograficalDetailsScreen({
    super.key,
    required this.dGuid,
    required this.vName,
    required this.demoRec,
    required this.isEditable,
  });

  @override
  _demograficalDetail createState() => _demograficalDetail();
}

class _demograficalDetail extends State<DemograficalDetailsScreen> {
  List<TabFormsLogic> logics = [];
  List<HouseHoldFielItemdModel> allItems = [];
  Map<String, dynamic> myMap = {};
  List<OptionsModel> options = [];
  List<VillageProfileResponseModel> villageRce = [];
  bool _isLoading = true;
  String userName = '';
  String? role;
  String? lng = 'en';
  List<Translation> labelControlls = [];

  Future<void> initializeData() async {
    userName = (await Validate().readString(Validate.userName))!;
    lng = (await Validate().readString(Validate.sLanguage))!;
    labelControlls.clear();
    List<String> valueNames = [
      CustomText.Save,
      CustomText.Creches,
      CustomText.CrecheCaregiver,
      CustomText.Next,
      CustomText.back,
      CustomText.Submit,
      CustomText.demographicalDetails
    ];
    await TranslationDataHelper()
        .callTranslateString(valueNames)
        .then((value) => labelControlls = value);

    await TranslationDataHelper()
        .callTranslateEnrolledChildren()
        .then((value) => labelControlls.addAll(value));
    await updateHiddenValue();
    await callScrenControllers('Demographic Details');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppbar(
          text: Global.returnTrLable(
              labelControlls, CustomText.demographicalDetails, lng!),
          onTap: () => Navigator.pop(context, 'itemRefresh'),
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Divider(),
                  Expanded(
                      child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    child: SingleChildScrollView(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: cWidget(),
                    )),
                  )),
                  Divider(),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    child: Row(children: [
                      Expanded(
                          child: CElevatedButton(
                        color: Color(0xffF26BA3),
                        onPressed: () {
                          nextTab(0, context);
                        },
                        text: Global.returnTrLable(
                            labelControlls, CustomText.back, lng!),
                      )),
                      SizedBox(width: widget.isEditable?10:0),
                      widget.isEditable?Expanded(
                          child: CElevatedButton(
                        color: Color(0xff369A8D),
                        onPressed: () {
                          nextTab(1, context);
                        },
                        text: Global.returnTrLable(
                            labelControlls, CustomText.Submit, lng!),
                      )):SizedBox()
                    ]),
                  )
                ],
              ));
  }

  List<Widget> cWidget() {
    List<Widget> screenItems = [];
    if (allItems.length > 0) {
      for (int i = 0; i < allItems.length; i++) {
        screenItems.add(widgetTypeWidget(i, allItems[i]));
        screenItems.add(SizedBox(height: 5.h));
        if (!DependingLogic().callDependingLogic(logics, myMap, allItems[i])) {
          myMap.remove(allItems[i].fieldname);
        }
      }
    }
    return screenItems;
  }

  defaultDisableDailog(String fieldName, String flag) async {
    var tabName = 'tab$flag';
    var item = options.where((element) => element.flag == tabName).toList();
    if (item.length > 0) {
      myMap[fieldName] = item.first.name!;
    }
  }

  widgetTypeWidget(int index, HouseHoldFielItemdModel quesItem) {
    switch (quesItem.fieldtype) {
      case 'Link':
        List<OptionsModel> items = options
            .where((element) => element.flag == 'tab${quesItem.options}')
            .toList();
        if(options.length==1){
          defaultDisableDailog(quesItem.fieldname!,'tab${quesItem.options}');
        }
        return DynamicCustomDropdownField(
          titleText:
          Global.returnTrLable(labelControlls, quesItem.label!.trim(), lng!),
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : DependingLogic().dependeOnMendotory(logics, myMap, quesItem),
          items: items,
          selectedItem: myMap[quesItem.fieldname],
          isVisible:
          DependingLogic().callDependingLogic(logics, myMap, quesItem),
          readable:widget.isEditable?DependingLogic().callReadableLogic(logics, myMap, quesItem):true,
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
          initialvalue: myMap[quesItem.fieldname!],
          fieldName: quesItem.fieldname,
          readable:widget.isEditable?DependingLogic().callReadableLogic(logics, myMap, quesItem):true,
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : DependingLogic().dependeOnMendotory(logics, myMap, quesItem),
          calenderValidate:
          DependingLogic().calenderValidation(logics, myMap, quesItem),
          onChanged: (value) {
            myMap[quesItem.fieldname!] = value;
            var logData = DependingLogic()
                .callDateDiffrenceLogic(logics, myMap, quesItem);
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
          Global.returnTrLable(labelControlls, quesItem.label!.trim(), lng!),
        );
      case 'Data':
        return DynamicCustomTextFieldNew(
          titleText:
          Global.returnTrLable(labelControlls, quesItem.label!.trim(), lng!),
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : DependingLogic().dependeOnMendotory(logics, myMap, quesItem),
          initialvalue: myMap[quesItem.fieldname!],
          maxlength: quesItem.length,
          keyboard: DependingLogic().keyBoardLogic(quesItem.fieldname!, logics),
          readable:widget.isEditable?DependingLogic().callReadableLogic(logics, myMap, quesItem):true,
          hintText:
          Global.returnTrLable(labelControlls, quesItem.label!.trim(), lng!),
          isVisible:
          DependingLogic().callDependingLogic(logics, myMap, quesItem),
          onChanged: (value) {
            if (value.isNotEmpty)
              myMap[quesItem.fieldname!] = value;
            else
              myMap.remove(quesItem.fieldname);
          },
        );
      case 'Int':
        return DynamicCustomTextFieldInt(
          keyboardtype: TextInputType.number,
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : DependingLogic().dependeOnMendotory(logics, myMap, quesItem),
          maxlength: quesItem.length,
          initialvalue: myMap[quesItem.fieldname!],
          readable:widget.isEditable?DependingLogic().callReadableLogic(logics, myMap, quesItem):true,
          titleText:
          Global.returnTrLable(labelControlls, quesItem.label!.trim(), lng!),
          isVisible:
          DependingLogic().callDependingLogic(logics, myMap, quesItem),
          onChanged: (value) {
            print('Entered text: $value');
            if (value != null) {
              myMap[quesItem.fieldname!] = value;
              var logData = DependingLogic()
                  .callAutoGeneratedValue(logics, myMap, quesItem);
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
      // case 'Table MultiSelect': // Multi select Drop Down
      //   String itemResopnceField = '';
      //   List<OptionsModel> items = options
      //       .where(
      //           (element) => element.flag == 'tab${quesItem.multiselectlink}')
      //       .toList();
      //   List<HouseHoldFielItemdModel> msFieldName = multselectItemTab
      //       .where((element) => element.parent == '${quesItem.options}')
      //       .toList();
      //   if (msFieldName.length > 0) {
      //     itemResopnceField = msFieldName[0].fieldname!;
      //   }
      //   return DynamicMultiCheckGridView(
      //     items: items,
      //     isRequred: quesItem.reqd == 1
      //         ? quesItem.reqd
      //         : DependingLogic().dependeOnMendotory(logics, myMap, quesItem),
      //     titleText:
      //     Global.returnTrLable(labelControlls, quesItem.label!.trim(), lng!),
      //     selectedItem: myMap[quesItem.fieldname],
      //     responceFieldName: itemResopnceField,
      //     readable:widget.isEditable?DependingLogic().callReadableLogic(logics, myMap, quesItem):true,
      //     onChanged: (value) {
      //       if (value != null) myMap[quesItem.fieldname!] = value;
      //       // else
      //       //   myMap.remove(quesItem.fieldname);
      //
      //       setState(() {});
      //     },
      //   );
      case 'Check':
        return DynamicCustomYesNoCheckboxWithLabel(
          label: Global.returnTrLable(labelControlls, quesItem.label!.trim(), lng!),
          initialValue: myMap[quesItem.fieldname],
          readable:widget.isEditable?DependingLogic().callReadableLogic(logics, myMap, quesItem):true,
          labelControlls: labelControlls,
          lng: lng!,
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : DependingLogic().dependeOnMendotory(logics, myMap, quesItem),
          isVisible: DependingLogic().callDependingLogic(logics, myMap, quesItem),
          onChanged: (value) {
            print('yesNo $value');
            myMap[quesItem.fieldname!] = value;
            setState(() {});
          },
        );
      case 'Long Text':
        return DynamicCustomTextFieldNew(
          maxline: 3,
          titleText:
    Global.returnTrLable(labelControlls, quesItem.label!.trim(), lng!),
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : DependingLogic().dependeOnMendotory(logics, myMap, quesItem),
          initialvalue: myMap[quesItem.fieldname!],
          maxlength: quesItem.length,
          readable:widget.isEditable?DependingLogic().callReadableLogic(logics, myMap, quesItem):true,
          hintText:
    Global.returnTrLable(labelControlls, quesItem.label!.trim(), lng!),
          isVisible:
          DependingLogic().callDependingLogic(logics, myMap, quesItem),
          onChanged: (value) {
            if (value.isNotEmpty)
              myMap[quesItem.fieldname!] = value;
            else
              myMap.remove(quesItem.fieldname);
          },
        );
      case 'Select':
        return DynamicCustomTextFieldInt(
          keyboardtype: TextInputType.number,
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : DependingLogic().dependeOnMendotory(logics, myMap, quesItem),
          maxlength: quesItem.length,
          readable:widget.isEditable?DependingLogic().callReadableLogic(logics, myMap, quesItem):true,
          titleText:
    Global.returnTrLable(labelControlls, quesItem.label!.trim(), lng!),
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
          titleText:
    Global.returnTrLable(labelControlls, quesItem.label!.trim(), lng!),
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : DependingLogic().dependeOnMendotory(logics, myMap, quesItem),
          maxlength: quesItem.length,
          readable:widget.isEditable?DependingLogic().callReadableLogic(logics, myMap, quesItem):true,
          initialvalue: myMap[quesItem.fieldname!],
          onChanged: (value) {
            print('Entered text: $value');
            if (value.isNotEmpty)
              myMap[quesItem.fieldname!] = value;
            else
              myMap.remove(quesItem.fieldname);
          },
        );
    // case 'Long Text':
    //   return CustomImageDynamic(
    //     assetPath:myMap[quesItem.fieldname!],
    //     titleText:
    //     Global.returnTrLable(translats, quesItem.label!.trim(), lng),
    //     isRequred: quesItem.reqd==1?quesItem.reqd:DependingLogic().dependeOnMendotory(logics, myMap, quesItem),
    //     onChanged: (value) {
    //       print('Entered text: $value');
    //       myMap[quesItem.fieldname!] = value;
    //       setState(() {});
    //     },
    //   );
      default:
        return SizedBox();
    }
  }

  Future<void> callScrenControllers(screen_type) async {
    var lngtr = await Validate().readString(Validate.sLanguage);
    if (lngtr != null) {
      lng = lngtr;
    }
    villageRce = await VillageProfileResponseHelper()
        .getVillageProfilebyName(widget.vName);
    await VillageProfileFieldsHelper()
        .getVillageProfilebyParent(screen_type)
        .then((value) async {
      allItems = value;
    });

    List<String> defaultCommon = [];
    for (int i = 0; i < allItems.length; i++) {
      if (Global.validString(allItems[i].options)) {
        defaultCommon.add('tab${allItems[i].options!.trim()}');
      }
    }

    await OptionsModelHelper()
        .getAllMstCommonNotINOptions(defaultCommon, lng!)
        .then((value) => options.addAll(value));

    await FormLogicDataHelper().callFormLogic(screen_type).then((data) {
      logics.addAll(data);
    });
    List<String> labelItems = [];
    allItems.forEach((element) {
      if (Global.validString(element.label)) {
        labelItems.add(element.label!);
      }
    });
    await TranslationDataHelper()
        .callTranslateString(labelItems)
        .then((value) => labelControlls.addAll(value));

    setState(() {
      _isLoading = false;
    });
  }

  bool _checkValidation() {
    var validStatus = true;
    if (allItems.length > 0) {
      for (int i = 0; i < allItems.length; i++) {
        var element = allItems[i];
        if (element.reqd == 1) {
          var valuees = myMap[element.fieldname];
          if (!Global.validString(valuees.toString().trim())) {
            Validate().singleButtonPopup(
                Global.returnTrLable(
                    labelControlls, CustomText.plsFilManForm, lng!),
                Global.returnTrLable(labelControlls, CustomText.ok, lng!),
                false,
                context);
            validStatus = false;
            break;
          }
        }
        var validationMsg =
            DependingLogic().validationMessge(logics, myMap, element);
        if (Global.validString(validationMsg)) {
          Validate().singleButtonPopup(
              Global.returnTrLable(labelControlls, validationMsg, lng!),
              Global.returnTrLable(labelControlls, CustomText.ok, lng!),
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

  nextTab(int type, BuildContext mContext) async {
    if (type == 1) {
      if (_checkValidation()) {
        await saveDataInData();
        bool shouldProceed = await showDialog(
          context: context,
          builder: (context) {
            return SingleButtonPopupDialog(
                message: Global.returnTrLable(
                    labelControlls, CustomText.dataSaveSuc, lng!),
                button:
                    Global.returnTrLable(labelControlls, CustomText.ok, lng!));
          },
        );
        if (shouldProceed) {
          Navigator.pop(context, 'itemRefresh');
        }
        // return;

        setState(() {});
      }
    } else {
      Navigator.pop(context, 'itemRefresh');
    }
  }

  Future<void> saveDataInData() async {
    if (allItems.isNotEmpty) {
      // Fetch the village profile data by name
      villageRce = await VillageProfileResponseHelper()
          .getVillageProfilebyName(widget.vName);
      if (villageRce.isNotEmpty) {
        Map<String, dynamic> responseMap = jsonDecode(villageRce[0].responces!);
        List<Map<String, dynamic>> demoListMap =
            List<Map<String, dynamic>>.from(responseMap['demographical']);

        bool found = false;
        for (int i = 0; i < demoListMap.length; i++) {
          if (demoListMap[i]['demo_guid'] == widget.dGuid) {
            myMap['name'] = demoListMap[i]['name'];
            demoListMap[i] = myMap;
            found = true;
            break;
          }
        }
        if (!found) {
          demoListMap.add(myMap);
        }

        responseMap['demographical'] = demoListMap;
        String updatedJsonResponse = jsonEncode(responseMap);
        print(updatedJsonResponse);
        var items = VillageProfileResponseModel(
          village_code: villageRce[0].village_code,
          village_name: villageRce[0].village_name,
          name: widget.vName,
          responces: updatedJsonResponse,
          is_deleted: 0,
          is_edited: 1,
          is_uploaded: 0,
          created_at: villageRce[0].created_at,
          created_by: villageRce[0].created_by,
          update_at: DateTime.now().toString(),
          updated_by: userName,
        );
        await VillageProfileResponseHelper().inserts(items);
      }
    }
  }

  Future<void> updateHiddenValue() async {
    userName = (await Validate().readString(Validate.userName))!;
    var responseMap = widget.demoRec ?? {};
    if (responseMap.isNotEmpty) {
      myMap = responseMap;
    } else {
      var villageResponse = await VillageProfileResponseHelper()
          .getVillageProfilebyName(widget.vName);

      myMap['creation'] = DateTime.now().toString();
      myMap['owner'] = userName;
      myMap['parent'] = villageResponse[0].name;
      myMap['parentfield'] = 'demographical';
      myMap['parenttype'] = "Village";
      myMap['demo_guid'] = widget.dGuid;
      myMap['no_of_hamlets_in_village'] = Global.getItemValues(
          villageResponse[0].responces, 'no_of_hamlets_in_village');
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

  @override
  void initState() {
    super.initState();
    initializeData();
  }
}
