import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/custom_widget/custom_appbar.dart';
import 'package:shishughar/custom_widget/custom_btn.dart';
import 'package:shishughar/custom_widget/dynamic_screen_widget/dynamic_custom_dropdown.dart';
import 'package:shishughar/custom_widget/dynamic_screen_widget/dynamic_customdatepicker.dart';
import 'package:shishughar/database/helper/dynamic_screen_helper/options_model_helper.dart';
import 'package:shishughar/model/databasemodel/vaccines_model.dart';

import '../../../custom_widget/custom_text.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_custom_checkbox.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_custom_textfield_float.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_custom_time_picker.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_custom_yesno_checkbox.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_customtextfield_int.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamic_customtextfield_new.dart';
import '../../../custom_widget/dynamic_screen_widget/dynamin_multi_check_screen.dart';
import '../../../custom_widget/single_poup_dailog.dart';
import '../../../database/helper/child_immunization/child_immunization_meta_fileds_helper.dart';
import '../../../database/helper/child_immunization/child_immunization_response_helper.dart';
import '../../../database/helper/creche_helper/creche_data_helper.dart';
import '../../../database/helper/form_logic_helper.dart';
import '../../../database/helper/translation_language_helper.dart';
import '../../../database/helper/vaccines_helper.dart';
import '../../../model/apimodel/form_logic_api_model.dart';
import '../../../model/apimodel/house_hold_field_item_model_api.dart';
import '../../../model/apimodel/translation_language_api_model.dart';
import '../../../model/dynamic_screen_model/child_immunization_response_model.dart';
import '../../../model/dynamic_screen_model/enrolled_children_responce_model.dart';
import '../../../model/dynamic_screen_model/options_model.dart';
import '../../../style/styles.dart';
import '../../../utils/globle_method.dart';
import '../../../utils/validate.dart';
import '../house_hold/depending_logic.dart';

class ChildImmunizationExpendedDetailsScreen extends StatefulWidget {
  final int enName;
  final String? child_immunization_guid;
  final String? chilenrolledGUID;
  final String? creche_id;
  final String? childName;
  final String? childHHID;
  final EnrolledChildrenResponceModel? enrolledItem;

  ChildImmunizationExpendedDetailsScreen(
      {super.key,
      required this.creche_id,
      required this.child_immunization_guid,
      required this.chilenrolledGUID,
      required this.enName,
      required this.enrolledItem,
      required this.childName,
      required this.childHHID
      });

  @override
  _ChildImmunizationExpendedScreenSatet createState() =>
      _ChildImmunizationExpendedScreenSatet();
}

class _ChildImmunizationExpendedScreenSatet
    extends State<ChildImmunizationExpendedDetailsScreen> {
  List<TabFormsLogic> logics = [];
  List<HouseHoldFielItemdModel> allItems = [];
  Map<String, dynamic> myMap = {};
  List<OptionsModel> options = [];
  bool _isLoading = true;
  String userName = '';
  String? role;
  String? lng = 'en';
  List<Translation> labelControlls = [];
  List<VaccineModel> vaccines = [];
  List<VaccineModel> vaccinesCard = [];
  int? expends;
  int childAgeInDays=0;
  Map<int, Map<String, dynamic>> vaccinesResponce = {};

  List<String> hiddens=[ 'partner_id',
    'state_id',
    'district_id',
    'block_id',
    'gp_id',
    'village_id',
    'creche_id',
    'child_id'];


  Future<void> initializeData() async {
     userName = (await Validate().readString(Validate.userName))!;
    lng = (await Validate().readString(Validate.sLanguage))!;
    var dateTime=Global.stringToDate(Global.getItemValues(widget.enrolledItem!.responces!, 'child_dob')) ;
    childAgeInDays=Validate().calculateAgeInDays(dateTime!);
    print("childAgeInDays $childAgeInDays");

    labelControlls.clear();
    List<String> valueNames = [
      CustomText.Save,
      CustomText.Creches,
      CustomText.CrecheCaregiver,
      CustomText.Next,
      CustomText.back, CustomText.Submit
    ];
    await TranslationDataHelper()
        .callTranslateString(valueNames)
        .then((value) => labelControlls = value);

    await TranslationDataHelper()
        .callTranslateEnrolledChildren()
        .then((value) => labelControlls.addAll(value));

    vaccinesCard=await VaccinesDataHelper().callImmunizationExpendTitle(childAgeInDays);
    vaccines=await VaccinesDataHelper().callVaccinesByDays(childAgeInDays);

    await updateHiddenValue();

    await callScrenControllers('Vaccine Details');
  }

  @override
  Widget build(BuildContext context) {
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
          title: RichText(
            text: TextSpan(
              children: [
              WidgetSpan(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '${widget.childName}',
                      style: Styles.white145,
                    ),
                    Text(
                      '${widget.childHHID}',
                      style: Styles.white126P,
                    ),
                    // Add additional TextSpans here if needed
                  ],
                ),
              )
              ],
            ),
          ),
          centerTitle: true,
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
                      children: cParentWidget(),
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
                      SizedBox(width: 10),
                      Expanded(
                          child: CElevatedButton(
                        color: Color(0xff369A8D),
                        onPressed: () {
                          nextTab(1, context);
                        },
                        text: Global.returnTrLable(
                            labelControlls,  CustomText.Submit, lng!),
                      ))
                    ]),
                  )
                ],
              ));
  }

  List<Widget> cParentWidget() {
    List<Widget> screenItems = [];
    if (vaccinesCard.length > 0) {
      for (int i = 0; i < vaccinesCard.length; i++) {
        var vaccineItem = vaccinesCard[i];
        screenItems.add(
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                border: Border.all(color: Color(0xffE0E0E0)),
                borderRadius: BorderRadius.circular(10.r),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                               vaccineItem.categories!,
                              style: Styles.blue126),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: InkWell(
                              onTap: () {
                                setState(() {
                                  if (expends == i) {
                                    expends = -1;
                                  } else
                                    expends = i;
                                });
                              },
                              child: expends == i
                                  ? Image.asset(
                                "assets/circle_arrow.png",
                                scale: 2.2,
                              )
                                  : Image.asset(
                                "assets/circle_down_arrow.png",
                                scale: 2.2,
                              )),
                        )
                      ],
                    ),
                  ),
                  Visibility(
                    visible: expends == i,
                    child: Container(
                      color: Colors.white,
                      child:
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: cVAccineWiget(vaccineItem.days!),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
        // screenItems.add(Divider(
        //   thickness: 1,
        //   color: Colors.grey,
        // ));
        // screenItems.add(SizedBox(height: 10,));
      }
    }
    return screenItems;
  }

  List<Widget> cVAccineWiget(int days) {

    List<Widget> screenItems = [];
    var daysVaccine=vaccines.where((element) => element.days==days).toList();
    daysVaccine.forEach((element) {
      screenItems.add(SizedBox(height: 5.h));
      screenItems.add(RichText(
          strutStyle: StrutStyle(height: 1.h),
          overflow: TextOverflow.ellipsis,
          text: TextSpan(
              text: '${CustomText.VaccineName} : ',
              style: Styles.blue124,
              children: [
                TextSpan(
                    text: element.vaccine,
                    style: Styles.blue126),
              ])));
      screenItems.add(SizedBox(height: 5.h));
      screenItems.add(RichText(
          strutStyle: StrutStyle(height: 1.h),
          overflow: TextOverflow.ellipsis,
          text: TextSpan(
              text: '${CustomText.SiteForVaccinations} : ',
              style: Styles.blue124,
              children: [
                TextSpan(
                    text: element.site_for_vaccinations,
                    style: Styles.blue126),
              ])));
      if (allItems .length>0) {
          for (int i = 0; i < allItems.length; i++) {
            var cWidgetDatamap = vaccinesResponce[element.name];
            if (cWidgetDatamap == null) {
              cWidgetDatamap = {};
              vaccinesResponce[element.name!] = cWidgetDatamap;
            }
            screenItems.add(widgetTypeWidget(allItems[i],cWidgetDatamap, element.name!));
            screenItems.add(SizedBox(height: 5.h));
            if (!DependingLogic().callDependingLogic(logics, myMap, allItems[i])) {
              myMap.remove(allItems[i].fieldname);
            }
          }
        }
    });


    //

    return screenItems;
  }

  List<Widget> cWidget(int vaccineID) {
    var cWidgetDatamap = vaccinesResponce[vaccineID];
    if (cWidgetDatamap == null) {
      cWidgetDatamap = {};
      vaccinesResponce[vaccineID] = cWidgetDatamap;
    }
    List<Widget> screenItems = [];
    if (allItems .length>0) {
      for (int i = 0; i < allItems.length; i++) {
        screenItems.add(widgetTypeWidget(allItems[i],cWidgetDatamap, vaccineID));
        screenItems.add(SizedBox(height: 5.h));
        if (!DependingLogic().callDependingLogic(logics, myMap, allItems[i])) {
          myMap.remove(allItems[i].fieldname);
        }
      }
    }
    return screenItems;
  }

  widgetTypeWidget(HouseHoldFielItemdModel quesItem,
      Map<String, dynamic> itemsAnswred, int vaccineID) {
    switch (quesItem.fieldtype) {
      case 'Table MultiSelect':
        List<OptionsModel> items = options
            .where((element) => element.flag == 'tab${quesItem.options}')
            .toList();
        return DynamicMultiCheckGridView(
          items: items,
          selectedItem: itemsAnswred[quesItem.fieldname],
          responceFieldName: itemsAnswred[quesItem.fieldname],
          onChanged: (value) {
            if (value != null)
              itemsAnswred[quesItem.fieldname!] = value;
            else
              itemsAnswred.remove(quesItem.fieldname);

            updateItemsForChildren(itemsAnswred, vaccineID);

            setState(() {});
          },
        );
      case 'Link':
        List<OptionsModel> items = options
            .where((element) => element.flag == 'tab${quesItem.options}')
            .toList();
        return DynamicCustomDropdownField(
          titleText:
          Global.returnTrLable(labelControlls, quesItem.label!.trim(), lng!),
          isRequred: quesItem.reqd==1?quesItem.reqd:DependingLogic().dependeOnMendotory(logics, myMap, quesItem),
          items: items,
          selectedItem: itemsAnswred[quesItem.fieldname!],
          isVisible: DependingLogic()
              .callDependingLogic(logics, itemsAnswred, quesItem),
          onChanged: (value) {
            if (value != null)
              itemsAnswred[quesItem.fieldname!] = value.name;
            else
              itemsAnswred.remove(quesItem.fieldname);
            updateItemsForChildren(itemsAnswred, vaccineID);

            setState(() {});
          },
        );
      case 'Date':
        return CustomDatepickerDynamic(
          calenderValidate:[],
          titleText:
          Global.returnTrLable(labelControlls, quesItem.label!.trim(), lng!),
          initialvalue: itemsAnswred[quesItem.fieldname!],
          fieldName: quesItem.fieldname,

          isRequred: quesItem.reqd==1?quesItem.reqd:DependingLogic().dependeOnMendotory(logics, myMap, quesItem),
          onChanged: (value) {
            itemsAnswred[quesItem.fieldname!] = value;
            var logData = DependingLogic()
                .callDateDiffrenceLogic(logics, itemsAnswred, quesItem);
            if (logData.isNotEmpty) {
              if (logData.keys.length > 0) {
                itemsAnswred.addEntries(
                    [MapEntry(logData.keys.first, logData.values.first)]);

                updateItemsForChildren(itemsAnswred, vaccineID);

              }
            }
            setState(() {});
          },
        );
      case 'Long Text':
        return DynamicCustomTextFieldNew(
          maxline: 3,
          titleText: Global.returnTrLable(
              labelControlls, quesItem.label!.trim(), lng!),
          isRequred: quesItem.reqd==1?quesItem.reqd:DependingLogic().dependeOnMendotory(logics, myMap, quesItem),
          initialvalue: myMap[quesItem.fieldname!],
          maxlength: quesItem.length,
          readable: DependingLogic().callReadableLogic(logics, myMap, quesItem),
          hintText: Global.returnTrLable(
              labelControlls, quesItem.label!.trim(), lng!),
          isVisible:
          DependingLogic().callDependingLogic(logics, myMap, quesItem),
          onChanged: (value) {
            if (value.isNotEmpty)
              myMap[quesItem.fieldname!] = value;
            else
              myMap.remove(quesItem.fieldname);
          },
        );
      case 'Data':
        return DynamicCustomTextFieldNew(
          titleText:
          Global.returnTrLable(labelControlls, quesItem.label!.trim(), lng!),
          isRequred: quesItem.reqd==1?quesItem.reqd:DependingLogic().dependeOnMendotory(logics, myMap, quesItem),
          initialvalue: itemsAnswred[quesItem.fieldname!],
          keyboard: DependingLogic().keyBoardLogic(quesItem.fieldname!,logics),
          maxlength: quesItem.length,
          readable: DependingLogic()
              .callReadableLogic(logics, itemsAnswred, quesItem),
          hintText:
          Global.returnTrLable(labelControlls, quesItem.label!.trim(), lng!),
          isVisible: DependingLogic()
              .callDependingLogic(logics, itemsAnswred, quesItem),
          onChanged: (value) {
            if (value.isNotEmpty)
              itemsAnswred[quesItem.fieldname!] = value;
            else
              itemsAnswred.remove(quesItem.fieldname);

            updateItemsForChildren(itemsAnswred, vaccineID);
          },
        );
      case 'Int':
        return DynamicCustomTextFieldInt(
          titleText:
          Global.returnTrLable(labelControlls, quesItem.label!.trim(), lng!),
          keyboardtype: TextInputType.number,
          isRequred: quesItem.reqd==1?quesItem.reqd:DependingLogic().dependeOnMendotory(logics, myMap, quesItem),
          maxlength: quesItem.length,
          initialvalue: itemsAnswred[quesItem.fieldname!],
          readable: DependingLogic()
              .callReadableLogic(logics, itemsAnswred, quesItem),
          isVisible: DependingLogic()
              .callDependingLogic(logics, itemsAnswred, quesItem),
          onChanged: (value) {
            print('Entered text: $value');
            if (value != null) {
              itemsAnswred[quesItem.fieldname!] = value;
              var logData = DependingLogic()
                  .callAutoGeneratedValue(logics, itemsAnswred, quesItem);
              if (logData.isNotEmpty) {
                if (logData.keys.length > 0) {
                  itemsAnswred.addEntries(
                      [MapEntry(logData.keys.first, logData.values.first)]);
                  updateItemsForChildren(itemsAnswred, vaccineID);
                  // setState(() {});
                }
              }
            } else {
              itemsAnswred.remove(quesItem.fieldname);
              updateItemsForChildren(itemsAnswred, vaccineID);
              setState(() {});
            }
          },
        );
      // case 'Check':
      //   return DynamicCustomCheckboxWithLabel(
      //     label:
      //     Global.returnTrLable(labelControlls, quesItem.label!.trim(), lng!),
      //     initialValue: itemsAnswred[quesItem.fieldname!],
      //     isVisible: DependingLogic()
      //         .callDependingLogic(logics, itemsAnswred, quesItem),
      //     onChanged: (value) {
      //       if (value > 0)
      //         itemsAnswred[quesItem.fieldname!] = value;
      //       else
      //         itemsAnswred.remove(quesItem.fieldname);
      //
      //       updateItemsForChildren(itemsAnswred, vaccineID);
      //       setState(() {});
      //     },
      //   );
      case 'Check':
        return DynamicCustomYesNoCheckboxWithLabel(
          label: Global.returnTrLable(
              labelControlls, quesItem.label!.trim(), lng!),
          initialValue: myMap[quesItem.fieldname],
          labelControlls:labelControlls,
          lng: lng!,
          isRequred: quesItem.reqd==1?quesItem.reqd:DependingLogic().dependeOnMendotory(logics, myMap, quesItem),
          readable: DependingLogic()
              .callReadableLogic(logics, myMap, quesItem),
          isVisible: DependingLogic()
              .callDependingLogic(logics, myMap, quesItem),
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
          titleText:
          Global.returnTrLable(labelControlls, quesItem.label!.trim(), lng!),
          keyboardtype: TextInputType.number,
          isRequred: quesItem.reqd==1?quesItem.reqd:DependingLogic().dependeOnMendotory(logics, myMap, quesItem),
          maxlength: quesItem.length,
          readable: DependingLogic()
              .callReadableLogic(logics, itemsAnswred, quesItem),
          initialvalue: itemsAnswred[quesItem.fieldname!],
          onChanged: (value) {
            print('Entered text: $value');
            if (value != null)
              itemsAnswred[quesItem.fieldname!] = value;
            else {
              itemsAnswred.remove(quesItem.fieldname);

              updateItemsForChildren(itemsAnswred, vaccineID);
              setState(() {});
            }
          },
        );
      case 'Small Text':
        return DynamicCustomTextFieldNew(
          titleText:
          Global.returnTrLable(labelControlls, quesItem.label!.trim(), lng!),
          isRequred: quesItem.reqd==1?quesItem.reqd:DependingLogic().dependeOnMendotory(logics, myMap, quesItem),
          maxlength: quesItem.length,
          readable: DependingLogic()
              .callReadableLogic(logics, itemsAnswred, quesItem),
          initialvalue: itemsAnswred[quesItem.fieldname!],
          onChanged: (value) {
            print('Entered text: $value');
            if (value.isNotEmpty)
              itemsAnswred[quesItem.fieldname!] = value;
            else
              itemsAnswred.remove(quesItem.fieldname);

            updateItemsForChildren(itemsAnswred, vaccineID);
          },
        );
      case 'Float':
        return DynamicCustomTextFieldFloat(
          titleText:
          Global.returnTrLable(labelControlls, quesItem.label!.trim(), lng!),
          fieldName: quesItem.fieldname!,
          keyboardtype: TextInputType.number,
          isRequred: quesItem.reqd==1?quesItem.reqd:DependingLogic().dependeOnMendotory(logics, myMap, quesItem),
          maxlength: quesItem.length,
          initialvalue: itemsAnswred[quesItem.fieldname!],
          readable: DependingLogic()
              .callReadableLogic(logics, itemsAnswred, quesItem),
          isVisible: DependingLogic()
              .callDependingLogic(logics, itemsAnswred, quesItem),
          onChanged: (value) {
            print('Entered text: $value');
            if (value != null) {
              itemsAnswred[quesItem.fieldname!] = value;
              var logData = DependingLogic()
                  .callAutoGeneratedValue(logics, itemsAnswred, quesItem);
              if (logData.isNotEmpty) {
                if (logData.keys.length > 0) {
                  itemsAnswred.addEntries(
                      [MapEntry(logData.keys.first, logData.values.first)]);
                  updateItemsForChildren(itemsAnswred, vaccineID);
                  // setState(() {});
                }
              }
            } else {
              itemsAnswred.remove(quesItem.fieldname);
              updateItemsForChildren(itemsAnswred, vaccineID);
              setState(() {});
            }
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
    await ChildImmunizationMetaFieldsHelper()
        .getChildImmunizationMetaFieldsbyScreenType(screen_type)
        .then((value) async {
      allItems = value;
    });

    allItems=allItems.where((element) => !(hiddens.contains(element.fieldname))).toList();

    List<String> defaultCommon = [];
    for (int i = 0; i < allItems.length; i++) {
      if (Global.validString(allItems[i].options)) {
        defaultCommon.add('tab${allItems[i].options!.trim()}');
      }
    }

    await OptionsModelHelper()
        .getAllMstCommonNotINOptions(defaultCommon,lng!)
        .then((value) => options.addAll(value));

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

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    initializeData();
  }

  // bool _checkValidation() {
  //   var validStatus = true;
  //   var items = allItems;
  //   if (items .length>0) {
  //     for (int i = 0; i < items.length; i++) {
  //       var element = items[i];
  //       if (element.reqd == 1) {
  //         var valuees = myMap[element.fieldname];
  //         if (!Global.validString(valuees.toString().trim())) {
  //           Validate().singleButtonPopup(
  //               Global.returnTrLable(
  //                   labelControlls, CustomText.plsFilManForm, lng!),
  //               Global.returnTrLable(labelControlls, CustomText.ok, lng!),false,context);
  //           validStatus = false;
  //           break;
  //         }
  //       }
  //       var validationMsg =
  //           DependingLogic().validationMessge(logics, myMap, element);
  //       if (Global.validString(validationMsg)) {
  //         Validate().singleButtonPopup(
  //             Global.returnTrLable(
  //                 labelControlls, validationMsg, lng!),
  //             Global.returnTrLable(labelControlls, CustomText.ok, lng!),false,context);
  //         validStatus = false;
  //         break;
  //       }
  //     }
  //     ;
  //   } else {
  //     print("selected items is null");
  //   }
  //
  //   return validStatus;
  // }

  nextTab(int type, BuildContext mContext) async {
    if (type == 1) {
      // if (_checkValidation()) {
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
          if (shouldProceed == true) {
            Navigator.pop(context, 'itemRefresh');
          }
        }
        // return;

        setState(() {});
      // }
    } else {
      Navigator.pop(context, 'itemRefresh');
    }
  }

  // Future<void> saveDataInData() async {
  //   if (allItems.length>0) {
  //     Map<String, dynamic> responces = {};
  //     allItems.forEach((element) async {
  //       if (myMap[element.fieldname] != null) {
  //         responces[element.fieldname!] = myMap[element.fieldname];
  //       }
  //     });
  //     var responcesJs = jsonEncode(myMap);
  //     var name = myMap['name'];
  //     print(responcesJs);
  //     var immulizerItem = ChildImmunizationResponceModel(
  //         child_immunization_guid: widget.child_immunization_guid,
  //         childenrolledguid: widget.chilenrolledGUID,
  //         name: myMap['name'],
  //         creche_id: Global.stringToInt(widget.creche_id),
  //         responces: responcesJs,
  //         is_uploaded: 0,
  //         is_edited: 1,
  //         is_deleted: 0,
  //         created_at: myMap['appcreated_on'],
  //         created_by: myMap['appcreated_by'],
  //         update_at: myMap['app_updated_on'],
  //         updated_by: myMap['app_updated_by']);
  //     await ChildImmunizationResponseHelper().inserts(
  //         immulizerItem);
  //   }
  // }

  Future<void> updateHiddenValue() async {
    userName = (await Validate().readString(Validate.userName))!;
    var alrecords = await ChildImmunizationResponseHelper()
        .getChildEventResponcewithGuid(widget.child_immunization_guid!);
    if (alrecords.length > 0) {

      Map<String, dynamic> responcesData = jsonDecode(alrecords[0].responces!);
      var childs = responcesData['vaccine_details'];
      if (childs != null) {
        List<Map<String, dynamic>> children = List<Map<String, dynamic>>.from(childs);
        responcesData.remove('anthropromatic_details');

        children.forEach((element) {
          var itmelement=element;
          vaccinesResponce[Global.stringToInt(element['vaccine_id'].toString())] = itmelement;
        });
      }
      responcesData.forEach((key, value) {
        myMap[key] = value;
      });

      if (responcesData['appcreated_on'] != null ||
          responcesData['app_created_by'] != null) {
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
      var creCheDetails = await CrecheDataHelper()
          .getCrecheResponceItem(Global.stringToInt(widget.creche_id));
      if (creCheDetails.length > 0) {
        myMap['childenrolledguid'] = widget.chilenrolledGUID;
        myMap['appcreated_by'] = userName;
        myMap['appcreated_on'] = Validate().currentDateTime();
        myMap['child_id'] = widget.enName;
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
        myMap['child_immunization_guid'] = widget.child_immunization_guid;
      }
    }
  }

  showLoaderDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
            onWillPop: () async => false,
        child:AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              SizedBox(height: 10),
              const Text("Please wait..."),
            ],
          ),),
        );
      },
    );
  }

  updateItemsForChildren(
      Map<String, dynamic> itemsAnswred, int vaccinesId) {
    var cWidgetDatamap = vaccinesResponce[vaccinesId];
    if (cWidgetDatamap == null) {
      vaccinesResponce[vaccinesId] = itemsAnswred;
    } else {
      itemsAnswred.forEach((key, value) {
        cWidgetDatamap[key] = value;
      });
      vaccinesResponce[vaccinesId] = itemsAnswred;
    }
  }

  Future<void> saveDataInData() async {

    List<dynamic> childValues = [];
      vaccines.forEach((element) {
        var item = vaccinesResponce[element.name];
        if (item != null) {
          if(item['vaccination_date']!=null){
            item['vaccine_id']=element.name;
           childValues.add(item);
          }
        }
      });
      myMap['vaccine_details'] = childValues;

      var responcesJs = jsonEncode(myMap);
      print("responcesJs $responcesJs");
    var immulizerItem = ChildImmunizationResponceModel(
                child_immunization_guid: widget.child_immunization_guid,
                childenrolledguid: widget.chilenrolledGUID,
                name: myMap['name'],
                creche_id: Global.stringToInt(widget.creche_id),
                responces: responcesJs,
                is_uploaded: 0,
                is_edited: 1,
                is_deleted: 0,
                created_at: myMap['appcreated_on'],
                created_by: myMap['appcreated_by'],
                update_at: myMap['app_updated_on'],
                updated_by: myMap['app_updated_by']);
            await ChildImmunizationResponseHelper().inserts(
                immulizerItem);
  }

}
