import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shishughar/custom_widget/custom_appbar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shishughar/custom_widget/custom_btn.dart';
import 'package:shishughar/custom_widget/custom_text.dart';
import 'package:shishughar/custom_widget/double_button_dailog.dart';
import 'package:shishughar/custom_widget/dynamic_screen_widget/dynamic_custom_dropdown.dart';
import 'package:shishughar/custom_widget/dynamic_screen_widget/dynamic_custom_textfield_float.dart';
import 'package:shishughar/custom_widget/dynamic_screen_widget/dynamic_custom_yesno_checkbox.dart';
import 'package:shishughar/custom_widget/dynamic_screen_widget/dynamic_customdatepicker.dart';
import 'package:shishughar/custom_widget/dynamic_screen_widget/dynamic_customtextfield_new.dart';
import 'package:shishughar/custom_widget/dynamic_screen_widget/dynamin_multi_check_screen.dart';
import 'package:shishughar/custom_widget/single_poup_dailog.dart';
import 'package:shishughar/database/helper/creche_helper/creche_data_helper.dart';
import 'package:shishughar/database/helper/dynamic_screen_helper/options_model_helper.dart';
import 'package:shishughar/database/helper/form_logic_helper.dart';
import 'package:shishughar/database/helper/image_file_tab_responce_helper.dart';
import 'package:shishughar/database/helper/translation_language_helper.dart';
import 'package:shishughar/model/apimodel/form_logic_api_model.dart';
import 'package:shishughar/model/apimodel/house_hold_field_item_model_api.dart';
import 'package:shishughar/model/apimodel/translation_language_api_model.dart';
import 'package:shishughar/model/databasemodel/tab_image_file_model.dart';
import 'package:shishughar/model/dynamic_screen_model/options_model.dart';
import 'package:shishughar/screens/tabed_screens/house_hold/depending_logic.dart';
import 'package:shishughar/style/styles.dart';
import 'package:shishughar/utils/constants.dart';
import 'package:shishughar/utils/get_Location.dart';
import 'package:shishughar/utils/globle_method.dart';
import 'package:shishughar/utils/validate.dart';

import '../../../custom_widget/dynamic_screen_widget/dynamic_customtextfield_int.dart';
import '../../../database/helper/check_in/check_in_response_helper.dart';
import '../../../database/helper/check_in/checkin_meta_helper.dart';
import '../../../model/dynamic_screen_model/checkIn_response_model.dart';
import 'package:geolocator/geolocator.dart';

class CheckInDetailsScreen extends StatefulWidget {
  final int creche_id;
  String ccinguid;
  DateTime? lastGrowthDate;
  DateTime? minGrowthDate;
  bool isEdit;

  CheckInDetailsScreen(
      {super.key,
      required this.ccinguid,
      required this.creche_id,
      this.lastGrowthDate,
      this.minGrowthDate,
      required this.isEdit});

  State<CheckInDetailsScreen> createState() => _CheckInDetailsScreen();
}

class _CheckInDetailsScreen extends State<CheckInDetailsScreen> {
  List<TabFormsLogic> logics = [];
  List<HouseHoldFielItemdModel> allItems = [];
  Map<String, dynamic> myMap = {};
  List<OptionsModel> options = [];
  List<HouseHoldFielItemdModel> multselectItemTab = [];
  bool _isLoading = true;
  String userName = '';
  String? role;
  String? lng = 'en';
  List<Translation> translats = [];
  String? selecteditem;
  var _image;
  String? imagePath;
  String? dateOfVisit;
  String? lats;
  String? langs;
  String? address;
  String? crecheName;
  List<CheckInResponseModel> checkItems = [];
  bool isSettingOpen = false;
  String itemResopnceField = '';
  List<dynamic> itemsList = [];
  Map<String, dynamic> visitpurpose = {'tabEntitlement': []};
  List<String> hiddens = [
    'partner_id',
    'state_id',
    'district_id',
    'block_id',
    'gp_id',
    'village_id',
    'creche_image',
    'supervisor_id'
  ];

  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance.addObserver(this);

    initializedData();
  }

  Future<void> initializedData() async {
    // var isConnected=await Validate().checkInternetConnectivity();
    // if(!isConnected){
    //   Validate().singleButtonPopup(CustomText.nointernetconnectionavailable, CustomText.ok, true, context);
    //   return ;
    // }
    userName = (await Validate().readString(Validate.userName))!;
    lng = (await Validate().readString(Validate.sLanguage))!;
    translats.clear();
    List<String> valueNames = [
      CustomText.Save,
      CustomText.Creches,
      CustomText.CrecheCaregiver,
      CustomText.Next,
      CustomText.back,
      CustomText.Submit,
      CustomText.checkIN
    ];
    await TranslationDataHelper()
        .callTranslateString(valueNames)
        .then((value) => translats = value);
    multselectItemTab = await CheckInMetaHelper().callMultiSelectTabItem();

    checkItems =
        await CheckInResponseHelper().getCheckinsByGUIDItem(widget.ccinguid);
    var items =
        await CrecheDataHelper().getCrecheResponceItem(widget.creche_id);

    // var checkinResponseMap = jsonDecode(checkItems[0].responces!);
    print(items.length);
    // print(checkinResponseMap);
    if (items.length > 0) {
      crecheName = Global.getItemValues(items[0].responces!, 'creche_id');
      setState(() {});
      if (checkItems.length > 0) {
        dateOfVisit =
            Global.getItemValues(checkItems[0].responces, 'date_of_checkin');
        address =
            Global.getItemValues(checkItems[0].responces, 'checkin_location');
        lats = Global.getItemValues(checkItems[0].responces, 'latitude');
        langs = Global.getItemValues(checkItems[0].responces, 'longitude');

        // List<dynamic> res = jsonDecode(
        //     Global.getItemValues(checkItems[0].responces, 'visit_purpose'));
        // print(res[0]);
        // List<Map<String, dynamic>> keyValueList = [];
        // if (res.isNotEmpty) {
        //   for (var i = 0; i < res.length; i++) {
        //     if (res[i]['idx'] != null) {
        //       Map<String, dynamic> keyValueMap = {};
        //       keyValueMap['tabEntitlement'] = res[i]['idx'];
        //       print(keyValueMap);
        //       keyValueList.add(keyValueMap);
        //     } else {
        //       Map<String, dynamic> keyValueMap = {};
        //       keyValueMap['tabEntitlement'] = res[i]['tabEntitlement'];
        //       print(keyValueMap);
        //       keyValueList.add(keyValueMap);
        //     }
        //   }
        // }
        // visitpurpose['tabEntitlement'] = keyValueList;
        imagePath =
            Global.getItemValues(checkItems[0].responces, 'creche_image');
        if (Global.validString(imagePath)) {
          initImage(imagePath);
        }
        setState(() {});
      } else {
        // Map<String,String> map = {};
        // map = await GetLocation().checkLocationPermission(context);
        // lats = map['lats'];
        // langs = map['langs'];
        // address =  map['address'];
        // if(address != null) {
        //   setState(() { });
        // }
        // checkPermissionStatus();
        checkLocationPermission();
      }
    }
    await updateHiddenValue();

    await callScrenControllers('Creche Check In');
  }

  Future<void> _clearImagePath() async {
    await ImageFileTabHelper()
        .deleteImageFile(CustomText.checkInsCrech, widget.ccinguid);
    setState(() {
      _image = null;
      imagePath = null;
    });
  }

  initImage(String? assetPath) async {
    if (Global.validString(assetPath)) {
      var tempFile = File('${Constants.phoneImagePath}$assetPath'!);
      var alradyFile = await tempFile.exists();
      if (alradyFile) _image = File('${Constants.phoneImagePath}$assetPath'!);
    } else {
      String imageData = 'assets/image_placeholder.jpg';
      _image = await loadAssetImageAsFile(imageData);
    }
    setState(() {});
  }

  Future<File> loadAssetImageAsFile(String assetPath) async {
    final byteData = await rootBundle.load(assetPath);
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/${assetPath.split('/').last}');
    await file.writeAsBytes(byteData.buffer.asUint8List());
    return file;
  }

  Future<void> callScrenControllers(screen_type) async {
    lng = (await Validate().readString(Validate.sLanguage))!;
    await CheckInMetaHelper().getCheckinbyParent(screen_type).then((value) {
      allItems = value;
    });
    allItems = allItems
        .where((element) =>
            !(hiddens.contains(element.fieldname)) &&
            element.fieldtype != 'Column Break')
        .toList();
    List<String> defaultCommon = [];
    List<String> defaultCommonMulti = [];
    for (int i = 0; i < allItems.length; i++) {
      if (Global.validString(allItems[i].options)) {
        if (allItems[i].options == 'Creche') {
          await OptionsModelHelper()
              .callCrechInOption(allItems[i].options!.trim(), widget.creche_id)
              .then((data) {
            options.addAll(data);
          });
          defaultDisableDailog(allItems[i].fieldname!, allItems[i].options!);
        } else {
          if (allItems[i].ismultiselect == 1) {
            defaultCommon.add('tab${allItems[i].multiselectlink!.trim()}');
          } else
            defaultCommon.add('tab${allItems[i].options!.trim()}');
        }
      }
    }
    await OptionsModelHelper()
        .getAllMstCommonNotINOptions(defaultCommon, lng!)
        .then((value) => options.addAll(value));
    await OptionsModelHelper()
        .getAllMstCommonNotINOptionsWthouASC(defaultCommonMulti, lng!)
        .then((value) {
      options.addAll(value);
    });

    await FormLogicDataHelper().callFormLogic(screen_type).then((data) {
      logics.addAll(data);
    });

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

  bool _checkValidation() {
    var validStatus = true;
    if (allItems.isNotEmpty) {
      for (int i = 0; i < allItems.length; i++) {
        var element = allItems[i];
        if (element.reqd == 1) {
          var values = myMap[element.fieldname];
          if (!Global.validString(values.toString().trim())) {
            Validate().singleButtonPopup(
                Global.returnTrLable(translats, CustomText.plsFilManForm, lng!),
                Global.returnTrLable(translats, CustomText.ok, lng!),
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
              Global.returnTrLable(translats, validationMsg, lng!),
              Global.returnTrLable(translats, CustomText.ok, lng!),
              false,
              context);
          validStatus = false;
          break;
        }
      }
    } else {
      print('selected itemis null');
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
                    translats, CustomText.dataSaveSuc, lng!),
                button: Global.returnTrLable(translats, CustomText.ok, lng!));
          },
        );
        if (shouldProceed) {
          if (shouldProceed == true) {
            Navigator.pop(context, 'itemRefresh');
          }
        }
        setState(() {});
      }
    } else {
      Navigator.pop(context, 'temRefresh');
    }
  }

  Future<void> saveDataInData() async {
    if (allItems.isNotEmpty) {
      Map<String, dynamic> responses = {};
      allItems.forEach((element) async {
        if (myMap[element.fieldname] != null) {
          responses[element.fieldname!] = myMap[element.fieldname];
        }
      });
      var responcesJs = jsonEncode(myMap);
      print(responcesJs);
      var checkinItems = CheckInResponseModel(
          ccinguid: widget.ccinguid,
          name: myMap['name'],
          creche_id: widget.creche_id,
          responces: responcesJs,
          is_uploaded: 0,
          is_deleted: 0,
          is_edited: 1,
          created_at: myMap['appcreated_on'],
          created_by: myMap['appcreated_by'],
          update_at: Validate().currentDateTime(),
          updated_by: userName);
      await CheckInResponseHelper().inserts(checkinItems);
    }
  }

  Future<void> updateHiddenValue() async {
    userName = (await Validate().readString(Validate.userName))!;
    var alrecords =
        await CheckInResponseHelper().getCheckinsByGUIDItem(widget.ccinguid);
    if (alrecords.isNotEmpty) {
      Map<String, dynamic> responseData = jsonDecode(alrecords[0].responces!);
      responseData.forEach((key, value) {
        myMap[key] = value;
      });
      if (responseData['appcreated_on'] != null ||
          responseData['appcreated_by'] != null) {
        myMap['app_updated_on'] = Validate().currentDateTime();
        myMap['app_updated_by'] = userName;
      } else {
        myMap['appcreated_by'] = userName;
        myMap['appcreated_on'] = Validate().currentDateTime();
      }
      var name = alrecords[0].name;
      if (name != null) {
        myMap['name'] = name;
      }
    } else {
      var creCheDetails =
          await CrecheDataHelper().getCrecheResponceItem(widget.creche_id);
      if (creCheDetails.isNotEmpty) {
        myMap['appcreated_by'] = userName;
        myMap['appcreated_on'] = Validate().currentDateTime();
        myMap['supervisor_id'] =
            Global.getItemValues(creCheDetails[0].responces, 'supervisor_id');
        myMap['creche_id'] = widget.creche_id.toString();
        myMap['partner_id'] =
            Global.getItemValues(creCheDetails[0].responces!, 'partner_id');
        myMap['state_id'] =
            Global.getItemValues(creCheDetails[0].responces!, 'state_id');
        myMap['district_id'] =
            Global.getItemValues(creCheDetails[0].responces!, 'district_id');
        myMap['block_id'] =
            Global.getItemValues(creCheDetails[0].responces!, 'block_id');
        myMap['gp_id'] =
            Global.getItemValues(creCheDetails[0].responces!, 'gp_id');
        myMap['village_id'] =
            Global.getItemValues(creCheDetails[0].responces!, 'village_id');
        myMap['ccinguid'] = widget.ccinguid;
        myMap['date_of_checkin'] = Global.initCurrentDate();
      }
    }
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

  widgetTypeWidget(int index, HouseHoldFielItemdModel quesItem) {
    switch (quesItem.fieldtype) {
      case 'Link':
        List<OptionsModel> items = options
            .where((element) => element.flag == 'tab${quesItem.options}')
            .toList();
        return DynamicCustomDropdownField(
          titleText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng!),
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : DependingLogic().dependeOnMendotory(logics, myMap, quesItem),
          items: items,
          selectedItem: myMap[quesItem.fieldname],
          readable: widget.isEdit
              ? true
              : DependingLogic().callReadableLogic(logics, myMap, quesItem),
          isVisible:
              DependingLogic().callDependingLogic(logics, myMap, quesItem),
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
          readable: true,
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
              Global.returnTrLable(translats, quesItem.label!.trim(), lng!),
        );
      case 'Data':
        String? initialValue = '';
        if (quesItem.fieldname == 'latitude') {
          initialValue = lats ?? '';
          setState(() {
            myMap[quesItem.fieldname!] = lats;
          });
        } else if (quesItem.fieldname == 'longitude') {
          initialValue = langs ?? '';
          setState(() {
            myMap[quesItem.fieldname!] = langs;
          });
        } else if (quesItem.fieldname == 'checkin_location') {
          initialValue = address ?? '';
          setState(() {
            myMap[quesItem.fieldname!] = address;
          });
        } else {
          initialValue = myMap[quesItem.fieldname];
        }
        return DynamicCustomTextFieldNew(
          titleText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng!),
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : DependingLogic().dependeOnMendotory(logics, myMap, quesItem),
          // initialvalue: myMap[quesItem.fieldname!],
          initialvalue: initialValue,
          maxlength: quesItem.length,
          keyboard: DependingLogic().keyBoardLogic(quesItem.fieldname!, logics),
          readable: (quesItem.fieldname == 'longitude' ||
                  quesItem.fieldname == 'latitude' ||
                  quesItem.fieldname == 'checkin_location')
              ? true
              : widget.isEdit
                  ? true
                  : DependingLogic().callReadableLogic(logics, myMap, quesItem),
          hintText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng!),
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
          readable: widget.isEdit
              ? true
              : DependingLogic().callReadableLogic(logics, myMap, quesItem),
          titleText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng!),
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
          childRatio: 4,
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : DependingLogic().dependeOnMendotory(logics, myMap, quesItem),
          titleText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng!),
          readable: widget.isEdit
              ? true
              : DependingLogic().callReadableLogic(logics, myMap, quesItem),
          isVisible:
              DependingLogic().callDependingLogic(logics, myMap, quesItem),
          selectedItem: myMap[quesItem.fieldname],
          responceFieldName: itemResopnceField,
          onChanged: (value) {
            if (value != null)
              myMap[quesItem.fieldname!] = value;
            else
              myMap.remove(quesItem.fieldname);

            setState(() {});
          },
        );
      case 'Check':
        return DynamicCustomYesNoCheckboxWithLabel(
          label: Global.returnTrLable(translats, quesItem.label!.trim(), lng!),
          initialValue: myMap[quesItem.fieldname],
          labelControlls: translats,
          lng: lng!,
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : DependingLogic().dependeOnMendotory(logics, myMap, quesItem),
          readable: widget.isEdit
              ? true
              : DependingLogic().callReadableLogic(logics, myMap, quesItem),
          isVisible:
              DependingLogic().callDependingLogic(logics, myMap, quesItem),
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
          maxline: 3,
          titleText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng!),
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : DependingLogic().dependeOnMendotory(logics, myMap, quesItem),
          initialvalue: myMap[quesItem.fieldname!],
          maxlength: quesItem.length,
          readable: widget.isEdit
              ? true
              : DependingLogic().callReadableLogic(logics, myMap, quesItem),
          hintText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng!),
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
          readable: widget.isEdit
              ? true
              : DependingLogic().callReadableLogic(logics, myMap, quesItem),
          titleText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng!),
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
              Global.returnTrLable(translats, quesItem.label!.trim(), lng!),
          isRequred: quesItem.reqd == 1
              ? quesItem.reqd
              : DependingLogic().dependeOnMendotory(logics, myMap, quesItem),
          maxlength: quesItem.length,
          readable: DependingLogic().callReadableLogic(logics, myMap, quesItem),
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
          titleText:
              Global.returnTrLable(translats, quesItem.label!.trim(), lng!),
          keyboardtype: TextInputType.number,
          isRequred: quesItem.reqd,
          maxlength: quesItem.length,
          fieldName: quesItem.fieldname!,
          initialvalue: myMap[quesItem.fieldname!],
          readable: widget.isEdit,
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
                }
              }
            } else {
              myMap.remove(quesItem.fieldname);
            }
          },
        );
      // case 'Attach':
      //   return CustomImageDynamic(
      //     // child_guid: widget.EnrolledChilGUID,
      //     assetPath: myMap[quesItem.fieldname!],
      //     readable: widget.isEdit,
      //     titleText:
      //     Global.returnTrLable(translats, quesItem.label!.trim(), lng!),
      //     isRequred: quesItem.reqd == 1
      //         ? quesItem.reqd
      //         : DependingLogic().dependeOnMendotory(logics, myMap, quesItem),
      //     onChanged: (value) async {
      //     },
      //     onName: (value) async {
      //       myMap[quesItem.fieldname!] = value;
      //       await saveImageInDatabase(value,Global.validToString(quesItem.fieldname));
      //       setState(() {});
      //     },
      //   );
      default:
        return SizedBox();
    }
  }

  saveImageInDatabase(String imageName, String imageFieldName) async {
    var item = await ImageFileTabHelper()
        .getImageByDoctypeId(widget.ccinguid!, CustomText.checkInsCrech);
    var items = ImageFileTabResponceModel(
      image_name: imageName,
      doctype: CustomText.checkInsCrech,
      field_name: imageFieldName,
      doctype_guid: widget.ccinguid,
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

  Future<void> selectImageFile() async {
    bool? dailo = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return DoubleButtonDailog(
            message: Global.returnTrLable(
                translats, CustomText.Plsselecimgoption, lng!),
            posButton: Global.returnTrLable(translats, CustomText.Camera, lng!),
            negButton:
                Global.returnTrLable(translats, CustomText.Gallery, lng!));
      },
    );
    if (dailo != null) {
      XFile? file;
      if (dailo) {
        file = await ImagePicker().pickImage(source: ImageSource.camera);
      } else
        file = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (file != null) {
//
        var save = await savePickedImage(file,
            "image_${widget.ccinguid}_${DateTime.now().millisecondsSinceEpoch}.png");
        imagePath = save.path.split('/').last;
        _image = File(save.path);
        setState(() {
          myMap['creche_image'] = imagePath;
        });
        await saveImageInDatabase(
            imagePath!, Global.validToString('creche_image'));
      }
    }
  }

  Future<File> savePickedImage(XFile pickedImage, String docType) async {
    final Directory appDirectory = await getApplicationDocumentsDirectory();
    final Directory imagesDirectory =
        Directory('${appDirectory.path}/shishughar_images');
    final bool exist = await imagesDirectory.exists();
    if (!exist) {
      await imagesDirectory.create(recursive: true);
    }
    final String fileName = docType;
    final File newImagePath = File('${imagesDirectory.path}/$fileName');

    final Uint8List bytes = await pickedImage.readAsBytes();
    await newImagePath.writeAsBytes(bytes);

    return newImagePath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        text: lng != null
            ? Global.returnTrLable(translats, CustomText.checkIN, lng!)
            : CustomText.checkIN,
        onTap: () {
          Navigator.pop(context, 'itemRefresh');
        },
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                if (_image == null) {
                                  if (widget.isEdit == false) selectImageFile();
                                }
                              },
                              child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10.h),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Color(0xffF9F9F9),
                                        border: Border.all(
                                            color: Color(0xffACACAC)),
                                        borderRadius:
                                            BorderRadius.circular(5.r)),
                                    height: 80.h,
                                    width: 78.w,
                                    child: !Global.validString(imagePath)
                                        ? Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                "assets/add_btn.png",
                                                scale: 4,
                                                color: Color(0xff80E0AA),
                                              ),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              Text(
                                                CustomText.ChildPicture,
                                                style: Styles.Grey104,
                                                textAlign: TextAlign.center,
                                              )
                                            ],
                                          )
                                        : SizedBox(
                                            child:
                                                _buildImageWidget(imagePath)),
                                  )),
                            ),
                            SizedBox(height: 3.h),
                            (widget.isEdit == false)
                                ? (_image != null)
                                    ? Center(
                                        child: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.04, // Adjust height as needed
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.1, // Adjust width as needed

                                          child: ElevatedButton(
                                              onPressed: () =>
                                                  _clearImagePath(),
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors
                                                      .red, // Background color
                                                  // onPrimary: Colors.white, // Text color
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                  ),
                                                  padding: EdgeInsets.zero),
                                              child: Icon(
                                                Icons.delete,
                                                size: 20,
                                              )),
                                        ),
                                      )
                                    : SizedBox()
                                : SizedBox(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: cWidget(),
                            ),
                          ]),
                    ),
                  ),
                ),
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
                          translats, CustomText.back, lng!),
                    )),
                    widget.isEdit ? SizedBox() : SizedBox(width: 10),
                    widget.isEdit
                        ? SizedBox()
                        : Expanded(
                            child: CElevatedButton(
                            color: Color(0xff369A8D),
                            onPressed: () {
                              nextTab(1, context);
                            },
                            text: Global.returnTrLable(
                                translats, CustomText.Submit, lng!),
                          ))
                  ]),
                ),
              ],
            ),
    );
  }

  Widget _buildImageWidget(imagePath) {
    if (_image != null) {
      return Image.file(
        _image!,
        fit: BoxFit.fill,
      );
    } else if (imagePath != null && imagePath.isNotEmpty) {
      return Image.network(
        '${Constants.ImagebaseUrl}${imagePath}',
        fit: BoxFit.fill,
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        errorBuilder:
            (BuildContext context, Object error, StackTrace? stackTrace) {
          return Image.asset(
            'assets/no_network.png', // Path to your placeholder image
            fit: BoxFit.fill,
            width: 100,
            height: 100,
          );
        },
      );
    } else {
      return SizedBox();
    }
  }

  Future<void> checkPermissionStatus() async {
    var status = await Permission.location.status;
    if (status.isDenied) {
      status = await Permission.location.request();
      await Future.delayed(Duration(seconds: 2));
      if (status.isGranted) {
        await requestServiceEnable();
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
        await Future.delayed(Duration(seconds: 2));
        if (shouldProceed == true) {
          var status = await Permission.location.status;
          if (status.isGranted) {
            await requestServiceEnable();
          }
        }
      }
    } else {
      await requestServiceEnable();
    }
  }

  Future<void> requestServiceEnable() async {
    Location location = Location();
    bool serviceEnabled;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      } else {
        await getLocation();
      }
    } else {
      await getLocation();
    }
  }

  Future<void> getLocation() async {
    var location = Location();
    try {
      // show progresss bar
      showLoaderDialog(context);
      LocationData currentLocation = await location.getLocation();
      print(
          'Latitude: ${currentLocation.latitude}, Longitude: ${currentLocation.longitude}');
      lats = '${currentLocation.latitude}';
      langs = '${currentLocation.longitude}';
      address = await Validate().getAddressFromLatLng(
          currentLocation.latitude!, currentLocation.longitude!);
      // Navigator.pop(context);
      if (address != null) {
        setState(() {});
      }
      print('address: ${address}');
    } catch (e) {
      print('Error getting location: $e');
    } finally {
      Navigator.pop(context);
    }
  }
// Future<void> checkLocationPermission(
//       ) async {
//     if (await _hasLocationPermission()) {
//        await _requestServiceEnable();
//     } else {
//        await _requestPermission();
//     }
//   }
//   Future<bool> _hasLocationPermission() async {
//     return await Permission.location.status.isGranted;
//   }
//   Future<void> _requestPermission() async {
//     final status = await Permission.location.request();
//     if (status.isGranted) {
//        await _requestServiceEnable();
//     } else {
//       await _showPermissionDialog();

//     }
//   }
//    Future<void> _showPermissionDialog() async {
//     bool shouldProceed = await showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Permission Required'),
//           content: Text('Please allow location permission'),
//           actions: [
//             TextButton(
//               onPressed: () async {
//                 await AppSettings.openAppSettings();
//                 Navigator.of(context).pop(true);
//               },
//               child: Text('Settings'),
//             ),
//           ],
//         );
//       },
//     );

//      if(shouldProceed == true){
//         await _requestPermission();}

//   }
//   Future<void> _requestServiceEnable(
//       ) async {
//     final location = Location();
//     if (await location.serviceEnabled()) {
//        await _getLocation();
//     } else {
//       final serviceEnabled = await location.requestService();
//       if (serviceEnabled) {
//          await _getLocation();
//       } else {

//       }
//     }
//   }
//   Future<void> _getLocation() async {
//     final location = Location();

//     try {
//       showLoaderDialog(context);
//       final currentLocation = await location.getLocation();
//       lats = currentLocation.latitude.toString();
//       langs = currentLocation.longitude.toString();
//        address = await Validate().getAddressFromLatLng(
//           currentLocation.latitude!, currentLocation.longitude!);
//       // Navigator.pop(context);
//        if(address != null){
//         setState(() {

//         });
//        }
//     } catch (e) {
//       print('Error getting location: $e');

//     } finally {
//       Navigator.pop(context);
//     }
//   }
  Future<void> checkLocationPermission() async {
    if (await _hasLocationPermission()) {
      await _requestServiceEnable();
    } else {
      await _requestPermission();
    }
  }

  Future<bool> _hasLocationPermission() async {
    return await Permission.location.status.isGranted;
  }

  Future<void> _requestPermission() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      // if (_permissionRequested) {
      await _requestServiceEnable();
      // }
    } else {
      await _showPermissionDialog();
    }
  }

  Future<void> _showPermissionDialog() async {
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
                // Navigator.of(context).pop(true);
              },
              child: Text('Settings'),
            ),
          ],
        );
      },
    );

    if (shouldProceed == true) {
      // _permissionRequested = true;
      await _requestPermission();
    }
  }

  Future<void> _requestServiceEnable() async {
    final location = Location();
    // bool isServiceEnabled = await location.serviceEnabled();
    bool isServiceEnable = await Geolocator.isLocationServiceEnabled();
    if (isServiceEnable) {
      await _getLocation(isServiceEnable);
    } else {
      // _serviceEnableRequested = true;
      final serviceEnabled = await location.requestService();
      await Future.delayed(Duration(seconds: 2));
      if (serviceEnabled) {
        await _getLocation(serviceEnabled);
      } else {
        print("Location Service not Enable");
        // Handle the case where the user denies the request
      }
    }
  }

  // bool _serviceEnableRequested = false;

  // Future<void> _getLocation(bool shouldProceed) async {
  //   // final location = Location();
  //
  //   if (shouldProceed) {
  //     try {
  //       showLoaderDialog(context);
  //       // Future.delayed(Duration(seconds: 10));
  //       // final currentLocation = await location.getLocation();
  //       final currentLocation = await Geolocator.getCurrentPosition();
  //       lats = currentLocation.latitude.toString();
  //       langs = currentLocation.longitude.toString();
  //       address = await Validate().getAddressFromLatLng(
  //           currentLocation.latitude!, currentLocation.longitude!);
  //       // Navigator.pop(context);
  //       if (address != null) {
  //         setState(() {});
  //       }
  //     } catch (e) {
  //       print('Error getting location: $e');
  //     } finally {
  //       Navigator.pop(context);
  //     }
  //   } else {
  //     Validate().singleButtonPopup(
  //         "Service Not Enaled", CustomText.ok, false, context);
  //   }
  // }

  // bool _permissionRequested = false;

  // @override
  // void dispose() {
  //   WidgetsBinding.instance.removeObserver(this);
  //   super.dispose();
  // }

  // @override
  // Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
  //   super.didChangeAppLifecycleState(state);
  //   if (state == AppLifecycleState.resumed) {
  //     // Perform the actions you want when the app is resumed
  //     print("App resumed");
  //     // if (isSettingOpen) {
  //     //   isSettingOpen = false;
  //     //   await checkPermissionStatus();
  //     // }
  //   }
  // }

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




  Future<Position> getCurrentPositionWithTimeout() async {
    int retryCount = 0;

    // Retry loop to get current location
    while (retryCount < 2) {
      try {
        // Attempt to get the current position with a 10-second timeout
        var position = await Geolocator.getCurrentPosition()
            .timeout(Duration(seconds: 10));
        return position;  // If successful, return the position
      } catch (e) {
        if (e is TimeoutException) {
          retryCount++;
          print('Timeout reached, retrying... ($retryCount)');
          await Future.delayed(Duration(seconds: 1));  // Wait before retrying
        } else {
          try {
            // Fallback to Location package if Geolocator fails
            final locationData = await Location().getLocation();
            if (locationData.latitude != null && locationData.longitude != null) {
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
                return lastKnownPosition;  // Return the last known position if available
              }else
              rethrow;  // Rethrow if no valid data found
            }
          } catch (e) {
            print('Error using Location package: $e');
            // Try to get the last known position as a final fallback
            Position? lastKnownPosition =
            await Geolocator.getLastKnownPosition();
            if (lastKnownPosition != null) {
              return lastKnownPosition;  // Return last known position
            }else
            rethrow;  // If all options fail, rethrow the error
          }
        }
      }
    }

    // If both retries and fallbacks fail, throw TimeoutException
    throw TimeoutException(
        'Failed to get current position after $retryCount retries and no valid last known position.');
  }



  Future<void> _getLocation(bool shouldProceed) async {
    if (shouldProceed) {
      try {
        showLoaderDialog(context);

        final currentLocation = await getCurrentPositionWithTimeout();

        lats = currentLocation.latitude.toString();
        langs = currentLocation.longitude.toString();
        address = await Validate().getAddressFromLatLng(
            currentLocation.latitude!, currentLocation.longitude!);
        if (address != null) {
          setState(() {});
        }
      } catch (e) {
        // if (e is TimeoutException) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Location not ticked please try again.")));
        // }
      } finally {
        Navigator.pop(context);
      }
    } else {
      Validate().singleButtonPopup(
          "Service Not Enaled", CustomText.ok, false, context);
    }
  }
}
