import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:shishughar/utils/globle_method.dart';
import 'package:shishughar/custom_widget/custom_text.dart';
import '../../../model/apimodel/form_logic_api_model.dart';
import '../../../model/apimodel/house_hold_field_item_model_api.dart';
import '../../../model/apimodel/tabHeight_for_age_Boys_model.dart';
import '../../../model/apimodel/tabHeight_for_age_Girls_model.dart';
import '../../../model/apimodel/tabWeight_for_age_Boys _model.dart';
import '../../../model/apimodel/tabWeight_for_age_Girls _model.dart';
import '../../../model/apimodel/tabWeight_to_Height_Boys_model.dart';
import '../../../model/apimodel/tabWeight_to_Height_Girls_model.dart';
import '../../../model/apimodel/translation_language_api_model.dart';
import '../../../utils/validate.dart';

class DependingLogic {
  List<Translation> translation;
  List<TabFormsLogic> logics;
  String lng = 'en';

  DependingLogic(this.translation, this.logics, this.lng);

  bool callDependingLogic(
      Map<String, dynamic> answred, HouseHoldFielItemdModel parentItem) {
    bool dependingAns = false;
    var parentQlogic = logics
        .where((element) =>
            element.parentControl == parentItem.fieldname &&
            (element.type_of_logic_id == '1' ||
                element.type_of_logic_id == '3' ||
                element.type_of_logic_id == '12' ||
                element.type_of_logic_id == '24' ||
                element.type_of_logic_id == '25' ||
                element.type_of_logic_id == '18'))
        .toList();
    if (parentQlogic.length > 0) {
      for (int i = 0; i < parentQlogic.length; i++) {
        var element = parentQlogic[i];
        if (element.type_of_logic_id == '1') {
          var dependVAlu = answred[element.dependentControls].toString();
          if (dependVAlu == element.algorithmExpression.toString()) {
            dependingAns = true;
            break;
          }
        } else if (element.type_of_logic_id == '3') {
          var dependVAlu = answred[element.dependentControls].toString();
          if (dependVAlu == element.algorithmExpression.toString()) {
            dependingAns = true;
            break;
          }
        } else if (element.type_of_logic_id == '12') {
          var dependVAlu = answred[element.dependentControls];
          var elgoFieldName =
              Global.splitData(element.algorithmExpression.toString(), ',');
          if (dependVAlu != null) {
            dependVAlu.forEach((element) {
              if (element[elgoFieldName[0]].toString() == elgoFieldName[1]) {
                dependingAns = true;
              }
            });
            // var multiItems=Global.splitData(dependVAlu, ',');
            // if(multiItems.contains(element.algorithmExpression.toString())){
            //   dependingAns = true;
            //   break;
            // }
          }
        } else if (element.type_of_logic_id == '18') {
          var dependVAlu = answred[element.dependentControls];
          if (dependVAlu != null) {
            var multiItems = Global.splitData(dependVAlu, ',');
            if (multiItems.contains(element.algorithmExpression.toString())) {
              dependingAns = true;
              break;
            }
          }
        } else if (element.type_of_logic_id == '24') {
          if (element.dependentControls == element.parentControl) {
            var dependVAlu = answred[element.dependentControls];
            if ((!Global.validString(element.algorithmExpression)) &&
                dependVAlu != null) {
              dependingAns = true;
            }
          } else {
            var dependVAlu = answred[element.dependentControls];
            if ((!Global.validString(element.algorithmExpression)) &&
                dependVAlu != null) {
              dependingAns = true;
            }
          }
        } else if (element.type_of_logic_id == '25') {
          if (element.dependentControls == element.parentControl) {
            dependingAns = false;
            break;
          }
        }
      }
    } else {
      dependingAns = true;
    }
    print("return logic  $dependingAns  name ${parentItem.fieldname}");
    return dependingAns;
  }

  bool callReadableLogic(
      Map<String, dynamic> answred, HouseHoldFielItemdModel parentItem) {
    bool dependingAns = false;
    var parentQlogic = logics
        .where((element) =>
            element.parentControl == parentItem.fieldname &&
            (element.type_of_logic_id == '2' ||
                element.type_of_logic_id == '4' ||
                element.type_of_logic_id == '13'))
        .toList();
    if (parentQlogic.length > 0) {
      for (int i = 0; i < parentQlogic.length; i++) {
        var element = parentQlogic[i];
        if (element.type_of_logic_id == '2') {
          var dependVAlu = answred[element.dependentControls].toString();
          if (dependVAlu == element.algorithmExpression.toString()) {
            dependingAns = true;
            break;
          }
        } else if (element.type_of_logic_id == '4') {
          dependingAns = true;
          break;
        } else if (element.type_of_logic_id == '13') {
          dependingAns = true;
          break;
        }
      }
    } else {
      dependingAns = false;
    }
    print("return logic  $dependingAns  name ${parentItem.fieldname}");
    return dependingAns;
  }

  Map callDateDiffrenceLogic(
      Map<String, dynamic> answred, HouseHoldFielItemdModel parentItem) {
    Map item = {};
    var parentQlogic = logics
        .where((element) =>
            element.dependentControls == parentItem.fieldname &&
            (element.type_of_logic_id == '5' ||
                element.type_of_logic_id == '14'))
        .toList();
    if (parentQlogic.length > 0) {
      for (int i = 0; i < parentQlogic.length; i++) {
        var element = parentQlogic[i];
        if (element.type_of_logic_id == '5') {
          var dependVAlu = answred[element.dependentControls];
          if (dependVAlu != null) {
            var date = Validate().stringToDate(dependVAlu);
            int? calucalteDate;
            if (Global.validToString(element.algorithmExpression)
                    .toLowerCase() ==
                'm')
              calucalteDate = Validate().calculateAgeInMonths(date);
            else if (Global.validToString(element.algorithmExpression)
                    .toLowerCase() ==
                'y')
              calucalteDate = Validate().calculateAgeInYear(date);
            else if (Global.validToString(element.algorithmExpression)
                    .toLowerCase() ==
                'd') calucalteDate = Validate().calculateAgeInDays(date);

            item[element.parentControl] = calucalteDate;
            break;
          }
        } else if (element.type_of_logic_id == '14') {
          var expValue = Global.splitData(element.algorithmExpression, ',');
          if (expValue.length == 3) {
            if (expValue[2] == '>') {
              var dependVAlu = answred[element.dependentControls];
              var controlCompare = answred[expValue[1]];
              if (controlCompare != null && dependVAlu != null) {
                var date = Validate().stringToDate(dependVAlu);
                var expDate = Validate().stringToDate(controlCompare);
                int? calucalteDate;
                if (expValue[0].toString().toLowerCase() == 'm')
                  calucalteDate =
                      Validate().calculateAgeInMonthsDepenExp(date, expDate);
                else if (expValue[0].toString().toLowerCase() == 'y')
                  calucalteDate = Validate().calculateAgeInYear(date);
                else if (expValue[0].toString().toLowerCase() == 'd')
                  calucalteDate = Validate().calculateAgeInDays(date);

                item[element.parentControl] = calucalteDate;
                break;
              }
            } else if (expValue[2] == '<') {
              var dependVAlu = answred[expValue[1]];
              var controlCompare = answred[element.dependentControls];
              if (controlCompare != null && dependVAlu != null) {
                var date = Validate().stringToDate(dependVAlu);
                var expDate = Validate().stringToDate(controlCompare);
                int? calucalteDate;
                if (expValue[0].toString().toLowerCase() == 'm')
                  calucalteDate =
                      Validate().calculateAgeInMonthsDepenExp(date, expDate);
                else if (expValue[0].toString().toLowerCase() == 'y')
                  calucalteDate =
                      Validate().calculateAgeInYearDepenExp(date, expDate);
                else if (expValue[0].toString().toLowerCase() == 'd')
                  calucalteDate =
                      Validate().calculateAgeInDaysEx(date, expDate);

                item[element.parentControl] = calucalteDate;
                break;
              }
            }
          }
        }
      }
    }

    return item;
  }

  Map callAutoGeneratedValue(
      Map<String, dynamic> answred, HouseHoldFielItemdModel parentItem) {
    Map item = {};
    var parentQlogic = logics
        .where((element) =>
            element.dependentControls.contains(parentItem.fieldname!) &&
            (element.type_of_logic_id == '4' ||
                element.type_of_logic_id == '22'))
        .toList();
    if (parentQlogic.length > 0) {
      for (int i = 0; i < parentQlogic.length; i++) {
        var element = parentQlogic[i];
        if (element.type_of_logic_id == '4') {
          var dependVAlu = Global.splitData(element.dependentControls, ',');
          if (dependVAlu.length > 0) {
            int? fiValue;
            dependVAlu.forEach((depV) {
              var value = answred[depV.toString().trim()];
              if (value != null) {
                fiValue = Global.validToInt(fiValue) + Global.validToInt(value);
              }
            });
            if (fiValue != null) {
              item[element.parentControl] = fiValue;
            }
          }
        }
        if (element.type_of_logic_id == '22') {
          var dependVAlu = Global.splitData(element.dependentControls, ':');
          if (dependVAlu.length > 0) {
            double? fiValue1;
            dependVAlu.forEach((depV) {
              if (depV.contains('+')) {
                double? temp;
                var depenItem = Global.splitData(depV, '+');
                depenItem.forEach((action) {
                  if (temp != null) {
                    temp = temp! +
                        Global.stringToDouble(
                            answred[action.toString().trim()].toString());
                  } else
                    temp = Global.stringToDouble(
                        answred[action.toString().trim()].toString());
                });
                if (fiValue1 != null && temp != null) {
                  if (element.algorithmExpression == '-') {
                    fiValue1 = (fiValue1! - temp!);
                  } else if (element.algorithmExpression == '+') {
                    fiValue1 = (fiValue1! + temp!);
                  }
                } else {
                  fiValue1 = temp;
                }
              } else if (depV.contains('-')) {
                double? temp;
                var depenItem = Global.splitData(depV, '-');
                depenItem.forEach((action) {
                  if (temp != null) {
                    temp = temp! -
                        Global.stringToDouble(
                            answred[action.toString().trim()].toString());
                  } else
                    temp = Global.stringToDouble(
                        answred[action.toString().trim()].toString());
                });

                if (fiValue1 != null && temp != null) {
                  if (element.algorithmExpression == '-') {
                    fiValue1 = (fiValue1! - temp!);
                  } else if (element.algorithmExpression == '+') {
                    fiValue1 = (fiValue1! + temp!);
                  }
                } else {
                  fiValue1 = temp;
                }
              }
            });
            if (fiValue1 != null) {
              item[element.parentControl] = fiValue1;
            }
          }
        }
      }
    }

    return item;
  }

  List<String> calenderValidation(
      Map<String, dynamic> answred, HouseHoldFielItemdModel parentItem) {
    List<String> items = [];
    var parentQlogic = logics
        .where((element) =>
            element.dependentControls.contains(parentItem.fieldname!) &&
            (element.type_of_logic_id == '8' ||
                element.type_of_logic_id == '16'))
        .toList();
    if (parentQlogic.length > 0) {
      for (int i = 0; i < parentQlogic.length; i++) {
        if (parentQlogic[i].type_of_logic_id == '8') {
          if (parentQlogic[i].dependentControls ==
              parentQlogic[i].parentControl) {
            var algoExp =
                Global.splitData(parentQlogic[i].algorithmExpression, ',');
            var date = dateinilizataion(algoExp, algoExp[0]);
            if (date != null) {
              items.add(algoExp[0]);
              items.add(date.toString());
              break;
            }
          }
        } else if (parentQlogic[i].type_of_logic_id == '16') {
          var parentDate = answred[parentQlogic[i].parentControl];
          if (parentDate != null) {
            items
                .add(Global.validToString(parentQlogic[i].algorithmExpression));
            print("object,${parentDate.split('-').map(int.parse).toList()}");
            if (parentQlogic[i].algorithmExpression == '<') {
              List<dynamic> dateParts =
                  parentDate.split('-').map(int.parse).toList();
              var dateNew = DateTime(dateParts[0], dateParts[1], dateParts[2])
                  .subtract(Duration(days: 1));
              var dateNewString =
                  "${dateNew.year}-${dateNew.month}-${dateNew.day}";
              print("object $dateNewString");
              items.add(dateNewString);
            } else if (parentQlogic[i].algorithmExpression == '>') {
              List<dynamic> dateParts =
                  parentDate.split('-').map(int.parse).toList();
              var dateNew = DateTime(dateParts[0], dateParts[1], dateParts[2])
                  .add(Duration(days: 1));
              var dateNewString =
                  "${dateNew.year}-${dateNew.month}-${dateNew.day}";
              print("object $dateNewString");
              items.add(dateNewString);
            }

            break;
          }
        }
      }
    }

    return items;
  }

  DateTime? dateinilizataion(List<String> item, String dateType) {
    DateTime? datetime;
    if (item[0] == dateType) {
      if (item.length == 3) {
        if (item[2].toLowerCase() == 'd') {
          datetime = DateTime.now()
              .subtract(Duration(days: Global.stringToInt(item[1])));
        } else if (item[2].toLowerCase() == 'm') {
          int daysToSubtract = Global.stringToInt(item[1]) * 30;
          datetime = DateTime.now().subtract(Duration(days: daysToSubtract));
        } else if (item[2].toLowerCase() == 'y') {
          int daysToSubtract = Global.stringToInt(item[1]) * 365;
          datetime = DateTime.now().subtract(Duration(days: daysToSubtract));
        } else
          datetime = DateTime(1990);
      } else
        datetime = DateTime(1990);
    }
    return datetime;
  }

  String? validationMessge(
      Map<String, dynamic> answred, HouseHoldFielItemdModel parentItem) {
    String? retuenValu;
    var logicdependControl = logics
        .where((element) =>
            element.parentControl==parentItem.fieldname! &&
            (element.type_of_logic_id == '1' ||
                element.type_of_logic_id == '3' ||
                element.type_of_logic_id == '7' ||
                element.type_of_logic_id == '9' ||
                element.type_of_logic_id == '17' ||
                element.type_of_logic_id == '19' ||
                element.type_of_logic_id == '12' ||
                element.type_of_logic_id == '18' ||
                element.type_of_logic_id == '6' ||
                element.type_of_logic_id == '16' ||
                element.type_of_logic_id == '23' ||
                element.type_of_logic_id == '24'))
        .toList();

    if (logicdependControl.length > 0) {
      for (int i = 0; i < logicdependControl.length; i++) {
        var element = logicdependControl[i];
        if (element.type_of_logic_id == '6') {
          if (element.parentControl == element.dependentControls) {
            var exp = Global.splitData(element.algorithmExpression, ',');
            if (exp.length > 0) {
              var validValu = Global.stringToInt(exp[0]);
              var dependVAlu = Global.stringToInt(
                  answred[element.dependentControls].toString());
              if (Global.validString(
                  answred[element.dependentControls].toString())) {
                if (exp[1] == '<=') {
                  if (!(dependVAlu < validValu)) {
                    var updateMsg = Global.returnTrLable(
                        translation, CustomText.valuLesThanOrEqual, lng);
                    var label = Global.returnTrLable(
                        translation, parentItem.label, lng);
                    updateMsg = updateMsg.replaceAll(
                        RegExp("#", caseSensitive: false), label);
                    updateMsg = updateMsg.replaceAll(
                        RegExp("@", caseSensitive: false), '$validValu');
                    retuenValu = updateMsg;
                    break;
                  }
                } else if (exp[1] == '<') {
                  if (!(dependVAlu < validValu)) {
                    var updateMsg = Global.returnTrLable(
                        translation, CustomText.valueLesThan, lng);
                    var label = Global.returnTrLable(
                        translation, parentItem.label, lng);
                    updateMsg = updateMsg.replaceAll(
                        RegExp("#", caseSensitive: false), label);
                    updateMsg = updateMsg.replaceAll(
                        RegExp("@", caseSensitive: false), '$validValu');
                    retuenValu = updateMsg;
                    break;
                  }
                } else if (exp[1] == '>=') {
                  if (!(dependVAlu >= validValu)) {
                    var updateMsg = Global.returnTrLable(
                        translation, CustomText.valuGreaterThanOrEqual, lng);
                    var label = Global.returnTrLable(
                        translation, parentItem.label, lng);
                    updateMsg = updateMsg.replaceAll(
                        RegExp("#", caseSensitive: false), label);
                    updateMsg = updateMsg.replaceAll(
                        RegExp("@", caseSensitive: false), '$validValu');
                    retuenValu = updateMsg;
                    break;
                  }
                } else if (exp[1] == '>') {
                  if (!(dependVAlu > validValu)) {
                    var updateMsg = Global.returnTrLable(
                        translation, CustomText.valuGreaterThan, lng);
                    var label = Global.returnTrLable(
                        translation, parentItem.label, lng);
                    updateMsg = updateMsg.replaceAll(
                        RegExp("#", caseSensitive: false), label);
                    updateMsg = updateMsg.replaceAll(
                        RegExp("@", caseSensitive: false), '$validValu');
                    retuenValu = updateMsg;
                    break;
                  }
                } else if (exp[1] == '==') {
                  if (!(dependVAlu == validValu)) {
                    var updateMsg = Global.returnTrLable(
                        translation, CustomText.valuEqual, lng);
                    var label = Global.returnTrLable(
                        translation, parentItem.label, lng);
                    updateMsg = updateMsg.replaceAll(
                        RegExp("#", caseSensitive: false), label);
                    updateMsg = updateMsg.replaceAll(
                        RegExp("@", caseSensitive: false), '$validValu');
                    retuenValu = updateMsg;
                    break;
                  }
                }
              }
            }
          } else {
            var parrentValue = Global.stringToIntNull(
                answred[element.parentControl].toString());
            var dependVAlu = Global.stringToIntNull(
                answred[element.dependentControls].toString());
            if (parrentValue != null && dependVAlu != null) {
              if (element.algorithmExpression == '<=') {
                if (!(parrentValue <= dependVAlu)) {
                  var updateMsg = Global.returnTrLable(
                      translation, CustomText.valuLesThanOrEqual, lng);
                  var label =
                      Global.returnTrLable(translation, parentItem.label, lng);
                  updateMsg = updateMsg.replaceAll(
                      RegExp("#", caseSensitive: false), label);
                  updateMsg = updateMsg.replaceAll(
                      RegExp("@", caseSensitive: false), '$dependVAlu');
                  retuenValu = updateMsg;
                  break;
                }
              } else if (element.algorithmExpression == '<') {
                if (!(parrentValue < dependVAlu)) {
                  var updateMsg = Global.returnTrLable(
                      translation, CustomText.valueLesThan, lng);
                  var label =
                      Global.returnTrLable(translation, parentItem.label, lng);
                  updateMsg = updateMsg.replaceAll(
                      RegExp("#", caseSensitive: false), label);
                  updateMsg = updateMsg.replaceAll(
                      RegExp("@", caseSensitive: false), '$dependVAlu');
                  retuenValu = updateMsg;
                  break;
                }
              } else if (element.algorithmExpression == '>=') {
                if (!(parrentValue >= dependVAlu)) {
                  var updateMsg = Global.returnTrLable(
                      translation, CustomText.valuGreaterThanOrEqual, lng);
                  var label =
                      Global.returnTrLable(translation, parentItem.label, lng);
                  updateMsg = updateMsg.replaceAll(
                      RegExp("#", caseSensitive: false), label);
                  updateMsg = updateMsg.replaceAll(
                      RegExp("@", caseSensitive: false), '$dependVAlu');
                  retuenValu = updateMsg;
                  break;
                }
              } else if (element.algorithmExpression == '>') {
                if (!(parrentValue > dependVAlu)) {
                  var updateMsg = Global.returnTrLable(
                      translation, CustomText.valuGreaterThan, lng);
                  var label =
                      Global.returnTrLable(translation, parentItem.label, lng);
                  updateMsg = updateMsg.replaceAll(
                      RegExp("#", caseSensitive: false), label);
                  updateMsg = updateMsg.replaceAll(
                      RegExp("@", caseSensitive: false), '$dependVAlu');
                  retuenValu = updateMsg;
                  break;
                }
              } else if (element.algorithmExpression == '==') {
                if (!(parrentValue == dependVAlu)) {
                  var updateMsg = Global.returnTrLable(
                      translation, CustomText.valuEqual, lng);
                  var label =
                      Global.returnTrLable(translation, parentItem.label, lng);
                  updateMsg = updateMsg.replaceAll(
                      RegExp("#", caseSensitive: false), label);
                  updateMsg = updateMsg.replaceAll(
                      RegExp("@", caseSensitive: false), '$dependVAlu');
                  retuenValu = updateMsg;
                  break;
                }
              }
            }
          }
        } else if (element.type_of_logic_id == '24') {
          if (element.dependentControls == element.parentControl) {
            var dependVAlu = answred[element.dependentControls];
            if ((!Global.validString(element.algorithmExpression)) &&
                dependVAlu != null &&
                !Global.validString(
                    answred[element.parentControl].toString())) {
              var updateMsg = Global.returnTrLable(
                  translation, CustomText.PleaseEnterValueIn, lng);
              var label =
                  Global.returnTrLable(translation, parentItem.label, lng);
              updateMsg = updateMsg.replaceAll(
                  RegExp("#", caseSensitive: false), label);
              retuenValu = updateMsg;
              break;
            }
          } else {
            var dependVAlu = answred[element.dependentControls];
            if ((!Global.validString(element.algorithmExpression)) &&
                dependVAlu != null &&
                !Global.validString(
                    answred[element.parentControl].toString())) {
              var updateMsg = Global.returnTrLable(
                  translation, CustomText.PleaseEnterValueIn, lng);
              var label =
                  Global.returnTrLable(translation, parentItem.label, lng);
              updateMsg = updateMsg.replaceAll(
                  RegExp("#", caseSensitive: false), label);
              retuenValu = updateMsg;
              break;
            }
          }
        } else if (element.type_of_logic_id == '1' ||
            element.type_of_logic_id == '3') {
          if (element.type_of_logic_id == '1') {
            var dependVAlu = answred[element.dependentControls].toString();
            if (dependVAlu == element.algorithmExpression.toString()) {
              var parentValu = answred[element.parentControl].toString();
              if (!(Global.validString(parentValu))) {
                if (parentItem.fieldtype == 'Data' ||
                    parentItem.fieldtype == 'Int' ||
                    parentItem.fieldtype == 'Float') {
                  var updateMsg = Global.returnTrLable(
                      translation, CustomText.PleaseEnterValueIn, lng);
                  var label =
                      Global.returnTrLable(translation, parentItem.label, lng);
                  updateMsg = updateMsg.replaceAll(
                      RegExp("#", caseSensitive: false), label);
                  retuenValu = updateMsg;
                } else {
                  var updateMsg = Global.returnTrLable(
                      translation, CustomText.plsSelectIn, lng);
                  var label =
                      Global.returnTrLable(translation, parentItem.label, lng);
                  updateMsg = updateMsg.replaceAll(
                      RegExp("#", caseSensitive: false), label);
                  retuenValu = updateMsg;
                }
                break;
              }
            }
          }
          else if (element.type_of_logic_id == '3') {
            // if(element.parentControl==parentItem.fieldname!){
            var dependVAlu = answred[element.dependentControls].toString();
            if (dependVAlu == element.algorithmExpression.toString()) {
              var parentValu = answred[element.parentControl].toString();
              if (!(Global.validString(parentValu))) {
                if (parentItem.fieldtype == 'Data' ||
                    parentItem.fieldtype == 'Int' ||
                    parentItem.fieldtype == 'Float') {
                  var updateMsg = Global.returnTrLable(
                      translation, CustomText.PleaseEnterValueIn, lng);
                  var label =
                      Global.returnTrLable(translation, parentItem.label, lng);
                  updateMsg = updateMsg.replaceAll(
                      RegExp("#", caseSensitive: false), label);
                  retuenValu = updateMsg;
                } else {
                  var updateMsg = Global.returnTrLable(
                      translation, CustomText.plsSelectIn, lng);
                  var label = Global.returnTrLable(
                      translation, parentItem.label!.trim(), lng);
                  updateMsg = updateMsg.replaceAll(
                      RegExp("#", caseSensitive: false), label);
                  retuenValu = updateMsg;
                }
                break;
              // }
            }}
          }
        } else if (element.type_of_logic_id == '7') {
          var dependVAlu = answred[element.dependentControls].toString();
          var parentValue = answred[element.parentControl].toString();
          if (element.algorithmExpression.toString() == '>') {
            var parentDate = Global.stringToDate(parentValue);
            var dependsDate = Global.stringToDate(dependVAlu);
            if (parentDate != null && dependsDate != null) {
              if (!(dependsDate.isBefore(parentDate))) {
                retuenValu = Global.returnTrLable(
                    translation, CustomText.leavingLesThanjoining, lng);
                break;
              }
            }
          }
        } else if (element.type_of_logic_id == '9') {
          if (element.dependentControls == element.parentControl) {
            var exp = Global.splitData(element.algorithmExpression, ',');
            if (exp.length > 1) {
              var dependVAlu = answred[element.dependentControls];
              var validateTime = Global.splitData(exp[1], ':');
              var dependVAluTime = Global.splitData(dependVAlu, ':');
              if (validateTime.length == 2 && dependVAluTime.length >= 2) {
                var validTime = TimeOfDay(
                    hour: Global.stringToInt(validateTime[0]),
                    minute: Global.stringToInt(validateTime[1]));
                var dependTime = TimeOfDay(
                    hour: Global.stringToInt(dependVAluTime[0]),
                    minute: Global.stringToInt(dependVAluTime[1]));
                if (exp[0] == '<=') {
                  if (!(Validate().toMinutes(dependTime) <=
                      Validate().toMinutes(validTime))) {
                    var updateMsg = Global.returnTrLable(
                        translation, CustomText.PleaseSelectBeforTimeIn, lng);
                    var label = Global.returnTrLable(
                        translation, parentItem.label, lng);
                    updateMsg = updateMsg.replaceAll(
                        RegExp("#", caseSensitive: false), label);
                    updateMsg = updateMsg.replaceAll(
                        RegExp("@", caseSensitive: false), '${exp[1]}');
                    retuenValu = updateMsg;
                  }
                } else if (exp[0] == ">=") {
                  if (!(Validate().toMinutes(dependTime) >=
                      Validate().toMinutes(validTime))) {
                    var updateMsg = Global.returnTrLable(
                        translation, CustomText.PleaseSelectAfterTimeIn, lng);
                    var label = Global.returnTrLable(
                        translation, parentItem.label, lng);
                    updateMsg = updateMsg.replaceAll(
                        RegExp("#", caseSensitive: false), label);
                    updateMsg = updateMsg.replaceAll(
                        RegExp("@", caseSensitive: false), '${exp[1]}');
                    retuenValu = updateMsg;
                  }
                }
              }
            }
          } else {
            var dependVAlu = answred[element.dependentControls];
            var parentValue = answred[element.parentControl];
            if (element.algorithmExpression.toString() == '>') {
              if (dependVAlu != null && parentValue != null) {
                TimeOfDay? startTime;
                TimeOfDay? endTime;
                var startTimes = Global.splitData(dependVAlu, ':');
                var endTimes = Global.splitData(parentValue, ':');
                if (startTimes.length >= 2 && endTimes.length >= 2) {
                  startTime = TimeOfDay(
                      hour: Global.stringToInt(startTimes[0]),
                      minute: Global.stringToInt(startTimes[1]));
                  endTime = TimeOfDay(
                      hour: Global.stringToInt(endTimes[0]),
                      minute: Global.stringToInt(endTimes[1]));
                  int startMinutes = startTime.hour * 60 + startTime.minute;
                  int endMinutes = endTime.hour * 60 + endTime.minute;
                  if (startMinutes > endMinutes) {
                    var updateMsg = Global.returnTrLable(translation,
                        CustomText.PleaseSelectBeforTimeInIsValidTime, lng);
                    var label = Global.returnTrLable(
                        translation, parentItem.label, lng);
                    updateMsg = updateMsg.replaceAll(
                        RegExp("#", caseSensitive: false), label);
                    retuenValu = updateMsg;
                    break;
                  }
                }
              }
            }
          }
        } else if (element.type_of_logic_id == '17') {
          if (element.parentControl == element.dependentControls) {
            var exp = Global.splitData(element.algorithmExpression, ',');
            if (exp.length > 0) {
              var validValu = Global.stringToInt(exp[0]);
              var dependVAlu =
                  answred[element.dependentControls].toString().length;
              if (Global.validString(
                  answred[element.dependentControls].toString())) {
                if (exp[1] == '<=') {
                  if (!(dependVAlu <= validValu)) {
                    var updateMsg = Global.returnTrLable(
                        translation, CustomText.valuLenLessOrEqual, lng);
                    var label = Global.returnTrLable(
                        translation, parentItem.label, lng);
                    updateMsg = updateMsg.replaceAll(
                        RegExp("#", caseSensitive: false), label);
                    updateMsg = updateMsg.replaceAll(
                        RegExp("@", caseSensitive: false), '$validValu');
                    retuenValu = updateMsg;
                    break;
                  }
                } else if (exp[1] == '>=') {
                  if (!(dependVAlu >= validValu)) {
                    var updateMsg = Global.returnTrLable(
                        translation, CustomText.valuLenGreaterOrEqual, lng);
                    var label = Global.returnTrLable(
                        translation, parentItem.label, lng);
                    updateMsg = updateMsg.replaceAll(
                        RegExp("#", caseSensitive: false), label);
                    updateMsg = updateMsg.replaceAll(
                        RegExp("@", caseSensitive: false), '$validValu');
                    retuenValu = updateMsg;
                    break;
                  }
                } else if (exp[1] == '==') {
                  if (!(dependVAlu == validValu)) {
                    var updateMsg = Global.returnTrLable(
                        translation, CustomText.valuLenEqual, lng);
                    var label = Global.returnTrLable(
                        translation, parentItem.label, lng);
                    updateMsg = updateMsg.replaceAll(
                        RegExp("#", caseSensitive: false), label);
                    updateMsg = updateMsg.replaceAll(
                        RegExp("@", caseSensitive: false), '$validValu');
                    retuenValu = updateMsg;
                    break;
                  }
                }
              }
            }
          }
        } else if (element.type_of_logic_id == '19') {
          if (element.parentControl == element.dependentControls) {
            var exp = Global.splitData(element.algorithmExpression, ',');
            if (exp.length > 0) {
              var validValu = Global.stringToInt(exp[0]);
              var dependVAlu = Global.stringToDouble(
                  answred[element.dependentControls].toString());
              if (parentItem.reqd == 1) {
                if (Global.validString(
                    answred[element.dependentControls].toString())) {
                  if (exp[1] == '<=') {
                    if (!(dependVAlu <= validValu)) {
                      var updateMsg = Global.returnTrLable(
                          translation, CustomText.valuLesThanOrEqual, lng);
                      var label = Global.returnTrLable(
                          translation, parentItem.label, lng);
                      updateMsg = updateMsg.replaceAll(
                          RegExp("#", caseSensitive: false), label);
                      updateMsg = updateMsg.replaceAll(
                          RegExp("@", caseSensitive: false), '$validValu');
                      retuenValu = updateMsg;
                      break;
                    }
                  } else if (exp[1] == '<') {
                    if (!(dependVAlu < validValu)) {
                      var updateMsg = Global.returnTrLable(
                          translation, CustomText.valueLesThan, lng);
                      var label = Global.returnTrLable(
                          translation, parentItem.label, lng);
                      updateMsg = updateMsg.replaceAll(
                          RegExp("#", caseSensitive: false), label);
                      updateMsg = updateMsg.replaceAll(
                          RegExp("@", caseSensitive: false), '$validValu');
                      retuenValu = updateMsg;
                      break;
                    }
                  } else if (exp[1] == '>=') {
                    if (!(dependVAlu >= validValu)) {
                      var updateMsg = Global.returnTrLable(
                          translation, CustomText.valuGreaterThanOrEqual, lng);
                      var label = Global.returnTrLable(
                          translation, parentItem.label, lng);
                      updateMsg = updateMsg.replaceAll(
                          RegExp("#", caseSensitive: false), label);
                      updateMsg = updateMsg.replaceAll(
                          RegExp("@", caseSensitive: false), '$validValu');
                      retuenValu = updateMsg;
                      break;
                    }
                  } else if (exp[1] == '>') {
                    if (!(dependVAlu > validValu)) {
                      var updateMsg = Global.returnTrLable(
                          translation, CustomText.valuGreaterThan, lng);
                      var label = Global.returnTrLable(
                          translation, parentItem.label, lng);
                      updateMsg = updateMsg.replaceAll(
                          RegExp("#", caseSensitive: false), label);
                      updateMsg = updateMsg.replaceAll(
                          RegExp("@", caseSensitive: false), '$validValu');
                      retuenValu = updateMsg;
                      break;
                    }
                  } else if (exp[1] == '==') {
                    if (!(dependVAlu == validValu)) {
                      var updateMsg = Global.returnTrLable(
                          translation, CustomText.valuEqual, lng);
                      var label = Global.returnTrLable(
                          translation, parentItem.label, lng);
                      updateMsg = updateMsg.replaceAll(
                          RegExp("#", caseSensitive: false), label);
                      updateMsg = updateMsg.replaceAll(
                          RegExp("@", caseSensitive: false), '$validValu');
                      retuenValu = updateMsg;
                      break;
                    }
                  }
                } else {
                  var updateMsg = Global.returnTrLable(
                      translation, CustomText.PleaseEnterValueIn, lng);
                  var label =
                      Global.returnTrLable(translation, parentItem.label, lng);
                  updateMsg = updateMsg.replaceAll(
                      RegExp("#", caseSensitive: false), label);
                  retuenValu = updateMsg;
                }
              } else if (Global.validString(
                  answred[element.dependentControls].toString())) {
                if (exp[1] == '<=') {
                  if (!(dependVAlu <= validValu)) {
                    var updateMsg = Global.returnTrLable(
                        translation, CustomText.valuLesThanOrEqual, lng);
                    var label = Global.returnTrLable(
                        translation, parentItem.label, lng);
                    updateMsg = updateMsg.replaceAll(
                        RegExp("#", caseSensitive: false), label);
                    updateMsg = updateMsg.replaceAll(
                        RegExp("@", caseSensitive: false), '$validValu');
                    retuenValu = updateMsg;
                    break;
                  }
                } else if (exp[1] == '<') {
                  if (!(dependVAlu < validValu)) {
                    var updateMsg = Global.returnTrLable(
                        translation, CustomText.valueLesThan, lng);
                    var label = Global.returnTrLable(
                        translation, parentItem.label, lng);
                    updateMsg = updateMsg.replaceAll(
                        RegExp("#", caseSensitive: false), label);
                    updateMsg = updateMsg.replaceAll(
                        RegExp("@", caseSensitive: false), '$validValu');
                    retuenValu = updateMsg;
                    break;
                  }
                } else if (exp[1] == '>=') {
                  if (!(dependVAlu >= validValu)) {
                    var updateMsg = Global.returnTrLable(
                        translation, CustomText.valuGreaterThanOrEqual, lng);
                    var label = Global.returnTrLable(
                        translation, parentItem.label, lng);
                    updateMsg = updateMsg.replaceAll(
                        RegExp("#", caseSensitive: false), label);
                    updateMsg = updateMsg.replaceAll(
                        RegExp("@", caseSensitive: false), '$validValu');
                    retuenValu = updateMsg;
                    break;
                  }
                } else if (exp[1] == '>') {
                  if (!(dependVAlu > validValu)) {
                    var updateMsg = Global.returnTrLable(
                        translation, CustomText.valuGreaterThan, lng);
                    var label = Global.returnTrLable(
                        translation, parentItem.label, lng);
                    updateMsg = updateMsg.replaceAll(
                        RegExp("#", caseSensitive: false), label);
                    updateMsg = updateMsg.replaceAll(
                        RegExp("@", caseSensitive: false), '$validValu');
                    retuenValu = updateMsg;
                    break;
                  }
                } else if (exp[1] == '==') {
                  if (!(dependVAlu == validValu)) {
                    var updateMsg = Global.returnTrLable(
                        translation, CustomText.valuEqual, lng);
                    var label = Global.returnTrLable(
                        translation, parentItem.label, lng);
                    updateMsg = updateMsg.replaceAll(
                        RegExp("#", caseSensitive: false), label);
                    updateMsg = updateMsg.replaceAll(
                        RegExp("@", caseSensitive: false), '$validValu');
                    retuenValu = updateMsg;
                    break;
                  }
                }
              }
            }
          } else {
            var parrentValue = Global.stringToDouble(
                answred[element.parentControl].toString());
            var dependVAlu = Global.stringToDouble(
                answred[element.dependentControls].toString());
            if (answred[element.parentControl] != null &&
                answred[element.dependentControls] != null) {
              if (element.algorithmExpression == '<=') {
                if (!(parrentValue <= dependVAlu)) {
                  var updateMsg = Global.returnTrLable(
                      translation, CustomText.valuLesThanOrEqual, lng);
                  var label =
                      Global.returnTrLable(translation, parentItem.label, lng);
                  updateMsg = updateMsg.replaceAll(
                      RegExp("#", caseSensitive: false), label);
                  updateMsg = updateMsg.replaceAll(
                      RegExp("@", caseSensitive: false), '$dependVAlu');
                  retuenValu = updateMsg;
                  break;
                }
              } else if (element.algorithmExpression == '<') {
                if (!(parrentValue < dependVAlu)) {
                  var updateMsg = Global.returnTrLable(
                      translation, CustomText.valueLesThan, lng);
                  var label =
                      Global.returnTrLable(translation, parentItem.label, lng);
                  updateMsg = updateMsg.replaceAll(
                      RegExp("#", caseSensitive: false), label);
                  updateMsg = updateMsg.replaceAll(
                      RegExp("@", caseSensitive: false), '$dependVAlu');
                  retuenValu = updateMsg;
                  break;
                }
              } else if (element.algorithmExpression == '>=') {
                if (!(parrentValue >= dependVAlu)) {
                  var updateMsg = Global.returnTrLable(
                      translation, CustomText.valuGreaterThanOrEqual, lng);
                  var label =
                      Global.returnTrLable(translation, parentItem.label, lng);
                  updateMsg = updateMsg.replaceAll(
                      RegExp("#", caseSensitive: false), label);
                  updateMsg = updateMsg.replaceAll(
                      RegExp("@", caseSensitive: false), '$dependVAlu');
                  retuenValu = updateMsg;
                  break;
                }
              } else if (element.algorithmExpression == '>') {
                if (!(parrentValue > dependVAlu)) {
                  var updateMsg = Global.returnTrLable(
                      translation, CustomText.valuGreaterThan, lng);
                  var label =
                      Global.returnTrLable(translation, parentItem.label, lng);
                  updateMsg = updateMsg.replaceAll(
                      RegExp("#", caseSensitive: false), label);
                  updateMsg = updateMsg.replaceAll(
                      RegExp("@", caseSensitive: false), '$dependVAlu');
                  retuenValu = updateMsg;
                  break;
                }
              } else if (element.algorithmExpression == '==') {
                if (!(parrentValue == dependVAlu)) {
                  var updateMsg = Global.returnTrLable(
                      translation, CustomText.valuEqual, lng);
                  var label =
                      Global.returnTrLable(translation, parentItem.label, lng);
                  updateMsg = updateMsg.replaceAll(
                      RegExp("#", caseSensitive: false), label);
                  updateMsg = updateMsg.replaceAll(
                      RegExp("@", caseSensitive: false), '$dependVAlu');
                  retuenValu = updateMsg;
                  break;
                }
              }
            }
            if (parentItem.reqd == 1) {
              if (Global.validString(
                  answred[element.dependentControls].toString())) {
                if (element.algorithmExpression == '<=') {
                  if (!(dependVAlu <= parrentValue)) {
                    var updateMsg = Global.returnTrLable(
                        translation, CustomText.valuLesThanOrEqual, lng);
                    var label = Global.returnTrLable(
                        translation, parentItem.label, lng);
                    updateMsg = updateMsg.replaceAll(
                        RegExp("#", caseSensitive: false), label);
                    updateMsg = updateMsg.replaceAll(
                        RegExp("@", caseSensitive: false), '$parrentValue');
                    retuenValu = updateMsg;
                    break;
                  }
                } else if (element.algorithmExpression == '<') {
                  if (!(dependVAlu < parrentValue)) {
                    var updateMsg = Global.returnTrLable(
                        translation, CustomText.valueLesThan, lng);
                    var label = Global.returnTrLable(
                        translation, parentItem.label, lng);
                    updateMsg = updateMsg.replaceAll(
                        RegExp("#", caseSensitive: false), label);
                    updateMsg = updateMsg.replaceAll(
                        RegExp("@", caseSensitive: false), '$parrentValue');
                    retuenValu = updateMsg;
                    break;
                  }
                } else if (element.algorithmExpression == '>=') {
                  if (!(dependVAlu >= parrentValue)) {
                    var updateMsg = Global.returnTrLable(
                        translation, CustomText.valuGreaterThanOrEqual, lng);
                    var label = Global.returnTrLable(
                        translation, parentItem.label, lng);
                    updateMsg = updateMsg.replaceAll(
                        RegExp("#", caseSensitive: false), label);
                    updateMsg = updateMsg.replaceAll(
                        RegExp("@", caseSensitive: false), '$parrentValue');
                    retuenValu = updateMsg;
                    break;
                  }
                } else if (element.algorithmExpression == '>') {
                  if (!(dependVAlu > parrentValue)) {
                    var updateMsg = Global.returnTrLable(
                        translation, CustomText.valuGreaterThan, lng);
                    var label = Global.returnTrLable(
                        translation, parentItem.label, lng);
                    updateMsg = updateMsg.replaceAll(
                        RegExp("#", caseSensitive: false), label);
                    updateMsg = updateMsg.replaceAll(
                        RegExp("@", caseSensitive: false), '$parrentValue');
                    retuenValu = updateMsg;
                    break;
                  }
                } else if (element.algorithmExpression == '==') {
                  if (!(dependVAlu == parrentValue)) {
                    var updateMsg = Global.returnTrLable(
                        translation, CustomText.valuEqual, lng);
                    var label = Global.returnTrLable(
                        translation, parentItem.label, lng);
                    updateMsg = updateMsg.replaceAll(
                        RegExp("#", caseSensitive: false), label);
                    updateMsg = updateMsg.replaceAll(
                        RegExp("@", caseSensitive: false), '$parrentValue');
                    retuenValu = updateMsg;
                    break;
                  }
                }
              } else {
                var updateMsg = Global.returnTrLable(
                    translation, CustomText.PleaseEnterValueIn, lng);
                var label =
                    Global.returnTrLable(translation, parentItem.label, lng);
                updateMsg = updateMsg.replaceAll(
                    RegExp("#", caseSensitive: false), label);
                retuenValu = updateMsg;
              }
            } else if (Global.validString(
                answred[element.dependentControls].toString())) {
              if (element.algorithmExpression == '<=') {
                if (!(parrentValue <= dependVAlu)) {
                  var updateMsg = Global.returnTrLable(
                      translation, CustomText.valuLesThanOrEqual, lng);
                  var label =
                      Global.returnTrLable(translation, parentItem.label, lng);
                  updateMsg = updateMsg.replaceAll(
                      RegExp("#", caseSensitive: false), label);
                  updateMsg = updateMsg.replaceAll(
                      RegExp("@", caseSensitive: false), '$dependVAlu');
                  retuenValu = updateMsg;
                  break;
                }
              } else if (element.algorithmExpression == '<') {
                if (!(parrentValue < dependVAlu)) {
                  var updateMsg = Global.returnTrLable(
                      translation, CustomText.valueLesThan, lng);
                  var label =
                      Global.returnTrLable(translation, parentItem.label, lng);
                  updateMsg = updateMsg.replaceAll(
                      RegExp("#", caseSensitive: false), label);
                  updateMsg = updateMsg.replaceAll(
                      RegExp("@", caseSensitive: false), '$dependVAlu');
                  retuenValu = updateMsg;
                  break;
                }
              } else if (element.algorithmExpression == '>=') {
                if (!(parrentValue >= dependVAlu)) {
                  var updateMsg = Global.returnTrLable(
                      translation, CustomText.valuGreaterThanOrEqual, lng);
                  var label =
                      Global.returnTrLable(translation, parentItem.label, lng);
                  updateMsg = updateMsg.replaceAll(
                      RegExp("#", caseSensitive: false), label);
                  updateMsg = updateMsg.replaceAll(
                      RegExp("@", caseSensitive: false), '$dependVAlu');
                  retuenValu = updateMsg;
                  break;
                }
              } else if (element.algorithmExpression == '>') {
                if (!(parrentValue > dependVAlu)) {
                  var updateMsg = Global.returnTrLable(
                      translation, CustomText.valuGreaterThan, lng);
                  var label =
                      Global.returnTrLable(translation, parentItem.label, lng);
                  updateMsg = updateMsg.replaceAll(
                      RegExp("#", caseSensitive: false), label);
                  updateMsg = updateMsg.replaceAll(
                      RegExp("@", caseSensitive: false), '$dependVAlu');
                  retuenValu = updateMsg;
                  break;
                }
              } else if (element.algorithmExpression == '==') {
                if (!(parrentValue == dependVAlu)) {
                  var updateMsg = Global.returnTrLable(
                      translation, CustomText.valuEqual, lng);
                  var label =
                      Global.returnTrLable(translation, parentItem.label, lng);
                  updateMsg = updateMsg.replaceAll(
                      RegExp("#", caseSensitive: false), label);
                  updateMsg = updateMsg.replaceAll(
                      RegExp("@", caseSensitive: false), '$dependVAlu');
                  retuenValu = updateMsg;
                  break;
                }
              }
            }
          }
        } else if (element.type_of_logic_id == '12') {
          var dependVAlu = answred[element.dependentControls];
          var elgoFieldName =
              Global.splitData(element.algorithmExpression.toString(), ',');
          if (dependVAlu != null) {
            dependVAlu.forEach((depItem) {
              if (depItem[elgoFieldName[0]].toString() == elgoFieldName[1]) {
                var parentControlValue =
                    answred[element.parentControl].toString();
                if (!Global.validString(parentControlValue)) {
                  if (parentItem.fieldtype == 'Data' ||
                      parentItem.fieldtype == 'Int' ||
                      parentItem.fieldtype == 'Float') {
                    var updateMsg = Global.returnTrLable(
                        translation, CustomText.PleaseEnterValueIn, lng);
                    var label = Global.returnTrLable(
                        translation, parentItem.label, lng);
                    updateMsg = updateMsg.replaceAll(
                        RegExp("#", caseSensitive: false), label);
                    retuenValu = updateMsg;
                  } else {
                    var updateMsg = Global.returnTrLable(
                        translation, CustomText.plsSelectIn, lng);
                    var label = Global.returnTrLable(
                        translation, parentItem.label, lng);
                    updateMsg = updateMsg.replaceAll(
                        RegExp("#", caseSensitive: false), label);
                    retuenValu = updateMsg;
                  }
                }
              }
            });
            break;
          }
        } else if (element.type_of_logic_id == '18') {
          var dependVAlu = answred[element.dependentControls];
          if (dependVAlu != null) {
            var multiItems = Global.splitData(dependVAlu, ',');
            if (multiItems.contains(element.algorithmExpression.toString())) {
              var parentControlValue = answred[element.parentControl];
              if (!Global.validString(parentControlValue)) {
                if (parentItem.fieldtype == 'Data' ||
                    parentItem.fieldtype == 'Int' ||
                    parentItem.fieldtype == 'Float') {
                  var updateMsg = Global.returnTrLable(
                      translation, CustomText.PleaseEnterValueIn, lng);
                  var label =
                      Global.returnTrLable(translation, parentItem.label, lng);
                  updateMsg = updateMsg.replaceAll(
                      RegExp("#", caseSensitive: false), label);
                  retuenValu = updateMsg;
                  ;
                } else {
                  var updateMsg = Global.returnTrLable(
                      translation, CustomText.plsSelectIn, lng);
                  var label =
                      Global.returnTrLable(translation, parentItem.label, lng);
                  updateMsg = updateMsg.replaceAll(
                      RegExp("#", caseSensitive: false), label);
                  retuenValu = updateMsg;
                }
              }
              break;
            }
          }
        } else if (element.type_of_logic_id == '16') {
          var dependVAlu = answred[element.dependentControls];
          var parentVAlu = answred[element.parentControl];
          if (dependVAlu != null && parentVAlu != null) {
            List<dynamic> dependParts =
                dependVAlu.split('-').map(int.parse).toList();
            var dependDate =
                DateTime(dependParts[0], dependParts[1], dependParts[2]);
            List<dynamic> parentParts =
                parentVAlu.split('-').map(int.parse).toList();
            var parentDate =
                DateTime(parentParts[0], parentParts[1], parentParts[2]);
            if (element.algorithmExpression == '<') {
              if (dependDate.isBefore(parentDate)) {
                var updateMsg = Global.returnTrLable(
                    translation, CustomText.PleaseSelectAfterDateIn, lng);
                var label =
                    Global.returnTrLable(translation, parentItem.label, lng);
                updateMsg = updateMsg.replaceAll(
                    RegExp("#", caseSensitive: false), label);
                updateMsg = updateMsg.replaceAll(
                    RegExp("@", caseSensitive: false), '$parentVAlu');
                retuenValu = updateMsg;
                break;
              }
            } else if (element.algorithmExpression == '>') {
              if (dependDate.isAfter(parentDate)) {
                var updateMsg = Global.returnTrLable(
                    translation, CustomText.PleaseSelectBeforDateIn, lng);
                var label =
                    Global.returnTrLable(translation, parentItem.label, lng);
                updateMsg = updateMsg.replaceAll(
                    RegExp("#", caseSensitive: false), label);
                updateMsg = updateMsg.replaceAll(
                    RegExp("@", caseSensitive: false), '$parentVAlu');
                retuenValu = updateMsg;
                break;
              }
            }
          }
        } else if (element.type_of_logic_id == '23') {
          var parentVAlu = answred[element.parentControl];
          if (parentVAlu != null) {
            var dependVAlu = Global.splitData(element.dependentControls, ':');
            if (dependVAlu.length > 0) {
              double? fiValue1;
              dependVAlu.forEach((depV) {
                if (depV.contains('+')) {
                  double? temp;
                  var depenItem = Global.splitData(depV, '+');
                  depenItem.forEach((action) {
                    if (temp != null) {
                      temp = temp! +
                          Global.stringToDouble(
                              answred[action.toString().trim()].toString());
                    } else
                      temp = Global.stringToDouble(
                          answred[action.toString().trim()].toString());
                  });
                  if (fiValue1 != null && temp != null) {
                    if (element.algorithmExpression == '<=') {
                      if ((temp! < fiValue1!)) {
                        // retuenValu =
                        // "Value of ${parentItem.label} must be less than Or equal to $temp";
                        // "Sum of Usage and Wastage cannot be more than the sum of Quantity Received and Opening Stock :$temp";
                        var updateMsg = Global.returnTrLable(translation,
                            CustomText.wesUsageGraterQuatOpen, lng);
                        var label = Global.returnTrLable(
                            translation, parentItem.label, lng);
                        updateMsg = updateMsg.replaceAll(
                            RegExp("#", caseSensitive: false), label);
                        updateMsg = updateMsg.replaceAll(
                            RegExp("@", caseSensitive: false), '$temp');
                        retuenValu = updateMsg;
                      }
                    } else if (element.algorithmExpression == '<') {
                      if ((temp! < fiValue1!)) {
                        var updateMsg = Global.returnTrLable(
                            translation, CustomText.valueLesThan, lng);
                        var label = Global.returnTrLable(
                            translation, parentItem.label, lng);
                        updateMsg = updateMsg.replaceAll(
                            RegExp("#", caseSensitive: false), label);
                        updateMsg = updateMsg.replaceAll(
                            RegExp("@", caseSensitive: false), '$temp');
                        retuenValu = updateMsg;
                      }
                    } else if (element.algorithmExpression == '>=') {
                      if ((temp! >= fiValue1!)) {
                        var updateMsg = Global.returnTrLable(translation,
                            CustomText.valuGreaterThanOrEqual, lng);
                        var label = Global.returnTrLable(
                            translation, parentItem.label, lng);
                        updateMsg = updateMsg.replaceAll(
                            RegExp("#", caseSensitive: false), label);
                        updateMsg = updateMsg.replaceAll(
                            RegExp("@", caseSensitive: false), '$temp');
                        retuenValu = updateMsg;
                      }
                    } else if (element.algorithmExpression == '>') {
                      if ((temp! > fiValue1!)) {
                        var updateMsg = Global.returnTrLable(
                            translation, CustomText.valuGreaterThan, lng);
                        var label = Global.returnTrLable(
                            translation, parentItem.label, lng);
                        updateMsg = updateMsg.replaceAll(
                            RegExp("#", caseSensitive: false), label);
                        updateMsg = updateMsg.replaceAll(
                            RegExp("@", caseSensitive: false), '$temp');
                        retuenValu = updateMsg;
                      }
                    } else if (element.algorithmExpression == '==') {
                      if ((temp == fiValue1)) {
                        var updateMsg = Global.returnTrLable(
                            translation, CustomText.valuEqual, lng);
                        var label = Global.returnTrLable(
                            translation, parentItem.label, lng);
                        updateMsg = updateMsg.replaceAll(
                            RegExp("#", caseSensitive: false), label);
                        updateMsg = updateMsg.replaceAll(
                            RegExp("@", caseSensitive: false), '$temp');
                        retuenValu = updateMsg;
                      }
                    }
                  } else
                    fiValue1 = temp;
                } else if (depV.contains('-')) {
                  double? temp;
                  var depenItem = Global.splitData(depV, '-');
                  depenItem.forEach((action) {
                    if (temp != null) {
                      temp = temp! -
                          Global.stringToDouble(
                              answred[action.toString().trim()].toString());
                    } else
                      temp = Global.stringToDouble(
                          answred[action.toString().trim()].toString());
                  });

                  if (fiValue1 != null && temp != null) {
                    if (element.algorithmExpression == '<=') {
                      if ((temp! <= fiValue1!)) {
                        var updateMsg = Global.returnTrLable(
                            translation, CustomText.valuLesThanOrEqual, lng);
                        var label = Global.returnTrLable(
                            translation, parentItem.label, lng);
                        updateMsg = updateMsg.replaceAll(
                            RegExp("#", caseSensitive: false), label);
                        updateMsg = updateMsg.replaceAll(
                            RegExp("@", caseSensitive: false), '$temp');
                        retuenValu = updateMsg;
                      }
                    } else if (element.algorithmExpression == '<') {
                      if ((temp! < fiValue1!)) {
                        var updateMsg = Global.returnTrLable(
                            translation, CustomText.valueLesThan, lng);
                        var label = Global.returnTrLable(
                            translation, parentItem.label, lng);
                        updateMsg = updateMsg.replaceAll(
                            RegExp("#", caseSensitive: false), label);
                        updateMsg = updateMsg.replaceAll(
                            RegExp("@", caseSensitive: false), '$temp');
                        retuenValu = updateMsg;
                      }
                    } else if (element.algorithmExpression == '>=') {
                      if ((temp! >= fiValue1!)) {
                        var updateMsg = Global.returnTrLable(translation,
                            CustomText.valuGreaterThanOrEqual, lng);
                        var label = Global.returnTrLable(
                            translation, parentItem.label, lng);
                        updateMsg = updateMsg.replaceAll(
                            RegExp("#", caseSensitive: false), label);
                        updateMsg = updateMsg.replaceAll(
                            RegExp("@", caseSensitive: false), '$temp');
                        retuenValu = updateMsg;
                      }
                    } else if (element.algorithmExpression == '>') {
                      if ((temp! > fiValue1!)) {
                        var updateMsg = Global.returnTrLable(
                            translation, CustomText.valuGreaterThan, lng);
                        var label = Global.returnTrLable(
                            translation, parentItem.label, lng);
                        updateMsg = updateMsg.replaceAll(
                            RegExp("#", caseSensitive: false), label);
                        updateMsg = updateMsg.replaceAll(
                            RegExp("@", caseSensitive: false), '$temp');
                        retuenValu = updateMsg;
                      }
                    } else if (element.algorithmExpression == '==') {
                      if ((temp == fiValue1)) {
                        var updateMsg = Global.returnTrLable(
                            translation, CustomText.valuEqual, lng);
                        var label = Global.returnTrLable(
                            translation, parentItem.label, lng);
                        updateMsg = updateMsg.replaceAll(
                            RegExp("#", caseSensitive: false), label);
                        updateMsg = updateMsg.replaceAll(
                            RegExp("@", caseSensitive: false), '$temp');
                        retuenValu = updateMsg;
                      }
                    }
                  } else
                    fiValue1 = temp;
                }
              });
            }
          }
        } else if (element.type_of_logic_id == '9') {}
      }
    }

    return retuenValu;
  }

  static int AutoColorCreateByHeightWight(
      List<TabHeightforageBoysModel> tabHeightforageBoys,
      List<TabHeightforageGirlsModel> tHeightforageGirls,
      List<TabWeightforageBoysModel> tabWeightforageBoys,
      List<TabWeightforageGirlsModel> tabWeightforageGirls,
      List<TabWeightToHeightBoysModel> tabWeightToHeightBoys,
      List<TabWeightToHeightGirlsModel> tabWeightToHeightGirls,
      String fieldname,
      String gender,
      Map<String, dynamic> cWidgetDatamap) {
    int retuenValu = 0;

    if (fieldname == 'weight_for_age'|| fieldname == 're_weight_for_age') {
      var age = cWidgetDatamap['age_months'];
      var weight = cWidgetDatamap['weight'];
      if(fieldname == 're_weight_for_age'){
        weight = cWidgetDatamap['re_weight'];
         age = cWidgetDatamap['re_age_months'];
      }

      if (age != null && weight != null) {
        if (gender == '1') {
          var filtredItem = tabWeightforageBoys
              .where((element) =>
                  Global.retrunValidNum(element.age_in_days) == age)
              .toList();
          if (filtredItem.length > 0) {
            if (Global.validNum(weight.toString()) <= filtredItem[0].red!) {
              retuenValu = 1;
            } else if (Global.validNum(weight.toString()) <=
                    filtredItem[0].yellow_max! &&
                Global.validNum(weight.toString()) >
                    filtredItem[0].yellow_min!) {
              retuenValu = 2;
            } else if (Global.validNum(weight.toString()) >
                filtredItem[0].green!) {
              retuenValu = 3;
            }
          }
        } else if (gender == '2' || gender == '3') {
          var filtredItem = tabWeightforageGirls
              .where((element) =>
                  Global.retrunValidNum(element.age_in_days) == age)
              .toList();
          if (filtredItem.length > 0) {
            if (Global.validNum(weight.toString()) <= filtredItem[0].red!) {
              retuenValu = 1;
            } else if (Global.validNum(weight.toString()) <=
                    filtredItem[0].yellow_max! &&
                Global.validNum(weight.toString()) >
                    filtredItem[0].yellow_min!) {
              retuenValu = 2;
            } else if (Global.validNum(weight.toString()) >
                filtredItem[0].green!) {
              retuenValu = 3;
            }
          }
        }
      }
    }
    else if (fieldname == 'height_for_age'|| fieldname == 're_height_for_age') {
      var age = cWidgetDatamap['age_months'];
      var height = cWidgetDatamap['height'];
      var measurement_equipment = cWidgetDatamap['measurement_equipment'];
      if(fieldname == 're_height_for_age'){
         age = cWidgetDatamap['re_age_months'];
         height = cWidgetDatamap['re_height'];
         measurement_equipment = cWidgetDatamap['re_measurement_equipment'];
      }

      if (age != null && height != null) {
        if (age < (25 * 30) && height > 0 && measurement_equipment == '1') {
          ///Stediometer
          height = Global.stringToDouble(height.toString()) + 0.7;
        } else if (age > (24 * 30) &&
            height > 0 &&
            measurement_equipment == '2') {
          ///Infantometer
          height = Global.stringToDouble(height.toString()) - 0.7;
        }
        if (gender == '1') {
          var filtredItem = tabHeightforageBoys
              .where((element) =>
                  Global.retrunValidNum(element.age_in_days) == age)
              .toList();
          if (filtredItem.length > 0) {
            if (Global.validNum(height.toString()) <= filtredItem[0].red!) {
              retuenValu = 1;
            } else if (Global.validNum(height.toString()) <=
                    filtredItem[0].yellow_max! &&
                Global.validNum(height.toString()) >
                    filtredItem[0].yellow_min!) {
              retuenValu = 2;
            } else if (Global.validNum(height.toString()) >
                filtredItem[0].green!) {
              retuenValu = 3;
            }
          }
        } else if (gender == '2' || gender == '3') {
          var filtredItem = tHeightforageGirls
              .where((element) =>
                  Global.retrunValidNum(element.age_in_days) == age)
              .toList();
          if (filtredItem.length > 0) {
            if (Global.validNum(height.toString()) <= filtredItem[0].red!) {
              retuenValu = 1;
            } else if (Global.validNum(height.toString()) <=
                    filtredItem[0].yellow_max! &&
                Global.validNum(height.toString()) >
                    filtredItem[0].yellow_min!) {
              retuenValu = 2;
            } else if (Global.validNum(height.toString()) >
                filtredItem[0].green!) {
              retuenValu = 3;
            }
          }
        }
      }
    }
    else if (fieldname == 'weight_for_height'||fieldname == 're_weight_for_height') {
      var weight = cWidgetDatamap['weight'];
      var height = cWidgetDatamap['height'];
      var measurement_equipment = cWidgetDatamap['measurement_equipment'];
      if(fieldname == 're_weight_for_height'){
         weight = cWidgetDatamap['re_weight'];
         height = cWidgetDatamap['re_height'];
         measurement_equipment = cWidgetDatamap['re_measurement_equipment'];
      }

      if (weight != null && height != null) {
        if (height > 0 && measurement_equipment == '1') {
          ///Stediometer
          height = Global.stringToDouble(height.toString()) + 0.7;
        } else if (height > 0 && measurement_equipment == '2') {
          ///Infantometer
          height = Global.stringToDouble(height.toString()) - 0.7;
        }
        if (gender == '1') {
          var filtredItem = tabWeightToHeightBoys
              .where((element) =>
                  element.length ==
                  Global.roundToNearest(Global.validNum(height.toString())))
              .toList();
          if (filtredItem.length > 0) {
            if (Global.validNum(weight.toString()) <= filtredItem[0].red!) {
              retuenValu = 1;
            } else if (Global.validNum(weight.toString()) <=
                    filtredItem[0].yellow_max! &&
                Global.validNum(weight.toString()) >
                    filtredItem[0].yellow_min!) {
              retuenValu = 2;
            } else if (Global.validNum(weight.toString()) >
                filtredItem[0].green!) {
              retuenValu = 3;
            }
          }
        } else if (gender == '2' || gender == '3') {
          var filtredItem = tabWeightToHeightGirls
              .where((element) =>
                  element.length ==
                  Global.roundToNearest(Global.validNum(height.toString())))
              .toList();
          if (filtredItem.length > 0) {
            if (Global.validNum(weight.toString()) <= filtredItem[0].red!) {
              retuenValu = 1;
            } else if (Global.validNum(weight.toString()) <=
                    filtredItem[0].yellow_max! &&
                Global.validNum(weight.toString()) >
                    filtredItem[0].yellow_min!) {
              retuenValu = 2;
            } else if (Global.validNum(weight.toString()) >
                filtredItem[0].green!) {
              retuenValu = 3;
            }
          }
        }
      }
    }

    return retuenValu;
  }

  static String AutoColorCreateByHeightWightString(
      List<TabHeightforageBoysModel> tabHeightforageBoys,
      List<TabHeightforageGirlsModel> tHeightforageGirls,
      List<TabWeightforageBoysModel> tabWeightforageBoys,
      List<TabWeightforageGirlsModel> tabWeightforageGirls,
      List<TabWeightToHeightBoysModel> tabWeightToHeightBoys,
      List<TabWeightToHeightGirlsModel> tabWeightToHeightGirls,
      String fieldname,
      String gender,
      Map<String, dynamic> cWidgetDatamap) {
    String growthValue = '';

    if (fieldname == 'weight_for_age'||fieldname == 're_weight_for_age') {
      var age = cWidgetDatamap['age_months'];
      var weight = cWidgetDatamap['weight'];
      if(fieldname == 're_weight_for_age'){
         age = cWidgetDatamap['re_age_months'];
         weight = cWidgetDatamap['re_weight'];
      }

      if (age != null && weight != null) {
        if (gender == '1') {
          var filtredItem = tabWeightforageBoys
              .where((element) =>
                  Global.retrunValidNum(element.age_in_days) == age)
              .toList();
          if (filtredItem.length > 0) {
            if (Global.validNum(weight.toString()) <= filtredItem[0].red!) {
              growthValue = "<=${filtredItem[0].red!}";
            } else if (Global.validNum(weight.toString()) <=
                    filtredItem[0].yellow_max! &&
                Global.validNum(weight.toString()) >
                    filtredItem[0].yellow_min!) {
              growthValue =
                  ">${filtredItem[0].yellow_min!}-<=${filtredItem[0].yellow_max!}";
            } else if (Global.validNum(weight.toString()) >
                filtredItem[0].green!) {
              growthValue = ">${filtredItem[0].green!}";
            }
          }
        } else if (gender == '2' || gender == '3') {
          var filtredItem = tabWeightforageGirls
              .where((element) =>
                  Global.retrunValidNum(element.age_in_days) == age)
              .toList();
          if (filtredItem.length > 0) {
            if (Global.validNum(weight.toString()) <= filtredItem[0].red!) {
              growthValue = "<=${filtredItem[0].red!}";
            } else if (Global.validNum(weight.toString()) <=
                    filtredItem[0].yellow_max! &&
                Global.validNum(weight.toString()) >
                    filtredItem[0].yellow_min!) {
              growthValue =
                  ">${filtredItem[0].yellow_min!}-<=${filtredItem[0].yellow_max!}";
            } else if (Global.validNum(weight.toString()) >
                filtredItem[0].green!) {
              growthValue = ">${filtredItem[0].green!}";
            }
          }
        }
      }
    } else if (fieldname == 'height_for_age'||fieldname == 're_height_for_age') {
      var age = cWidgetDatamap['age_months'];
      var height = cWidgetDatamap['height'];
      var measurement_equipment = cWidgetDatamap['measurement_equipment'];
      if(fieldname == 're_height_for_age'){
         age = cWidgetDatamap['re_age_months'];
         height = cWidgetDatamap['re_height'];
         measurement_equipment = cWidgetDatamap['re_measurement_equipment'];
      }

      if (age != null && height != null) {
        if (age < (25 * 30) && height > 0 && measurement_equipment == '1') {
          ///Stediometer
          height = Global.stringToDouble(height.toString()) + 0.7;
        } else if (age > (24 * 30) &&
            height > 0 &&
            measurement_equipment == '2') {
          ///Infantometer
          height = Global.stringToDouble(height.toString()) - 0.7;
        }
        if (gender == '1') {
          var filtredItem = tabHeightforageBoys
              .where((element) =>
                  Global.retrunValidNum(element.age_in_days) == age)
              .toList();
          if (filtredItem.length > 0) {
            if (Global.validNum(height.toString()) <= filtredItem[0].red!) {
              growthValue = "<=${filtredItem[0].red!}";
            } else if (Global.validNum(height.toString()) <=
                    filtredItem[0].yellow_max! &&
                Global.validNum(height.toString()) >
                    filtredItem[0].yellow_min!) {
              growthValue =
                  ">${filtredItem[0].yellow_min!}-<=${filtredItem[0].yellow_max!}";
            } else if (Global.validNum(height.toString()) >
                filtredItem[0].green!) {
              growthValue = ">${filtredItem[0].green!}";
            }
          }
        } else if (gender == '2' || gender == '3') {
          var filtredItem = tHeightforageGirls
              .where((element) =>
                  Global.retrunValidNum(element.age_in_days) == age)
              .toList();
          if (filtredItem.length > 0) {
            if (Global.validNum(height.toString()) <= filtredItem[0].red!) {
              growthValue = "<=${filtredItem[0].red!}";
            } else if (Global.validNum(height.toString()) <=
                    filtredItem[0].yellow_max! &&
                Global.validNum(height.toString()) >
                    filtredItem[0].yellow_min!) {
              growthValue =
                  ">${filtredItem[0].yellow_min!}-<=${filtredItem[0].yellow_max!}";
            } else if (Global.validNum(height.toString()) >
                filtredItem[0].green!) {
              growthValue = ">${filtredItem[0].green!}";
            }
          }
        }
      }
    } else if (fieldname == 'weight_for_height'||fieldname == 're_weight_for_height') {
      var weight = cWidgetDatamap['weight'];
      var height = cWidgetDatamap['height'];
      var measurement_equipment = cWidgetDatamap['measurement_equipment'];
      if(fieldname == 're_weight_for_height'){
         weight = cWidgetDatamap['re_weight'];
         height = cWidgetDatamap['re_height'];
         measurement_equipment = cWidgetDatamap['re_measurement_equipment'];
      }

      if (weight != null && height != null) {
        if (height > 0 && measurement_equipment == '1') {
          ///Stediometer
          height = Global.stringToDouble(height.toString()) + 0.7;
        } else if (height > 0 && measurement_equipment == '2') {
          ///Infantometer
          height = Global.stringToDouble(height.toString()) - 0.7;
        }
        if (gender == '1') {
          var filtredItem = tabWeightToHeightBoys
              .where((element) =>
                  element.length ==
                  Global.roundToNearest(Global.validNum(height.toString())))
              .toList();
          if (filtredItem.length > 0) {
            if (Global.validNum(weight.toString()) <= filtredItem[0].red!) {
              growthValue = "<=${filtredItem[0].red!}";
            } else if (Global.validNum(weight.toString()) <=
                    filtredItem[0].yellow_max! &&
                Global.validNum(weight.toString()) >
                    filtredItem[0].yellow_min!) {
              growthValue =
                  ">${filtredItem[0].yellow_min!}-<=${filtredItem[0].yellow_max!}";
            } else if (Global.validNum(weight.toString()) >
                filtredItem[0].green!) {
              growthValue = ">${filtredItem[0].green!}";
            }
          }
        } else if (gender == '2' || gender == '3') {
          var filtredItem = tabWeightToHeightGirls
              .where((element) =>
                  element.length ==
                  Global.roundToNearest(Global.validNum(height.toString())))
              .toList();
          if (filtredItem.length > 0) {
            if (Global.validNum(weight.toString()) <= filtredItem[0].red!) {
              growthValue = "<=${filtredItem[0].red!}";
            } else if (Global.validNum(weight.toString()) <=
                    filtredItem[0].yellow_max! &&
                Global.validNum(weight.toString()) >
                    filtredItem[0].yellow_min!) {
              growthValue =
                  ">${filtredItem[0].yellow_min!}-<=${filtredItem[0].yellow_max!}";
            } else if (Global.validNum(weight.toString()) >
                filtredItem[0].green!) {
              growthValue = ">${filtredItem[0].green!}";
            }
          }
        }
      }
    }

    return growthValue;
  }

  // String AutoColorCreateByHeightWightString(
  //     List<TabHeightforageBoysModel> tabHeightforageBoys,
  //     List<TabHeightforageGirlsModel> tHeightforageGirls,
  //     List<TabWeightforageBoysModel> tabWeightforageBoys,
  //     List<TabWeightforageGirlsModel> tabWeightforageGirls,
  //     List<TabWeightToHeightBoysModel> tabWeightToHeightBoys,
  //     List<TabWeightToHeightGirlsModel> tabWeightToHeightGirls,
  //     String fieldname,
  //     String gender,
  //     Map<String, dynamic> cWidgetDatamap)
  // {
  //   String growthValue = '';
  //
  //   if (fieldname == 'weight_for_age') {
  //     var age = cWidgetDatamap['age_months'];
  //     var weight = cWidgetDatamap['weight'];
  //     if (age != null && weight != null) {
  //       if (gender == '1') {
  //         var filtredItem = tabWeightforageBoys
  //             .where((element) =>
  //         Global.retrunValidNum(element.age_in_days) ==
  //                 age)
  //             .toList();
  //         if (filtredItem.length > 0) {
  //           if (Global.validNum(weight.toString()) <= filtredItem[0].red!) {
  //             growthValue = "<=${filtredItem[0].red!}";
  //           } else if (Global.validNum(weight.toString()) <=
  //                   filtredItem[0].yellow_max! &&
  //               Global.validNum(weight.toString()) >=
  //                   filtredItem[0].yellow_min!) {
  //             growthValue =
  //                 "${filtredItem[0].yellow_min!}-${filtredItem[0].yellow_max!}";
  //           } else if (Global.validNum(weight.toString()) >=
  //               filtredItem[0].green!) {
  //             growthValue = ">=${filtredItem[0].green!}";
  //           }
  //         }
  //       } else if (gender == '2' || gender == '3') {
  //         var filtredItem = tabWeightforageGirls
  //             .where((element) =>
  //         Global.retrunValidNum(element.age_in_days) ==
  //                 age)
  //             .toList();
  //         if (filtredItem.length > 0) {
  //           if (Global.validNum(weight.toString()) <= filtredItem[0].red!) {
  //             growthValue = "<=${filtredItem[0].red!}";
  //           } else if (Global.validNum(weight.toString()) <=
  //                   filtredItem[0].yellow_max! &&
  //               Global.validNum(weight.toString()) >=
  //                   filtredItem[0].yellow_min!) {
  //             growthValue =
  //                 "${filtredItem[0].yellow_min!}-${filtredItem[0].yellow_max!}";
  //           } else if (Global.validNum(weight.toString()) >=
  //               filtredItem[0].green!) {
  //             growthValue = ">=${filtredItem[0].green!}";
  //           }
  //         }
  //       }
  //     }
  //   } else if (fieldname == 'height_for_age') {
  //     var age = cWidgetDatamap['age_months'];
  //     var height = cWidgetDatamap['height'];
  //     var measurement_equipment = cWidgetDatamap['measurement_equipment'];
  //
  //     if (age != null && height != null) {
  //       if (age < (25*30) && height > 0 && measurement_equipment == '1') {
  //         ///Stediometer
  //         height = Global.stringToDouble(height.toString()) + 0.7;
  //       } else if (age > (24*30) && height > 0 && measurement_equipment == '2') {
  //         ///Infantometer
  //         height = Global.stringToDouble(height.toString()) - 0.7;
  //       }
  //       if (gender == '1') {
  //         var filtredItem = tabHeightforageBoys
  //             .where((element) =>
  //         Global.retrunValidNum(element.age_in_days) ==
  //                 age)
  //             .toList();
  //         if (filtredItem.length > 0) {
  //           if (Global.validNum(height.toString()) <= filtredItem[0].red!) {
  //             growthValue = "<=${filtredItem[0].red!}";
  //           } else if (Global.validNum(height.toString()) <=
  //                   filtredItem[0].yellow_max! &&
  //               Global.validNum(height.toString()) >=
  //                   filtredItem[0].yellow_min!) {
  //             growthValue =
  //                 "${filtredItem[0].yellow_min!}-${filtredItem[0].yellow_max!}";
  //           } else if (Global.validNum(height.toString()) >=
  //               filtredItem[0].green!) {
  //             growthValue = ">=${filtredItem[0].green!}";
  //           }
  //         }
  //       }
  //       else if (gender == '2' || gender == '3') {
  //         var filtredItem = tHeightforageGirls
  //             .where((element) =>
  //         Global.retrunValidNum(element.age_in_days) ==
  //                 age)
  //             .toList();
  //         if (filtredItem.length > 0) {
  //           if (Global.validNum(height.toString()) <= filtredItem[0].red!) {
  //             growthValue = "<=${filtredItem[0].red!}";
  //           } else if (Global.validNum(height.toString()) <=
  //                   filtredItem[0].yellow_max! &&
  //               Global.validNum(height.toString()) >=
  //                   filtredItem[0].yellow_min!) {
  //             growthValue =
  //                 "${filtredItem[0].yellow_min!}-${filtredItem[0].yellow_max!}";
  //           } else if (Global.validNum(height.toString()) >=
  //               filtredItem[0].green!) {
  //             growthValue = ">=${filtredItem[0].green!}";
  //           }
  //         }
  //       }
  //     }
  //   } else if (fieldname == 'weight_for_height') {
  //     var weight = cWidgetDatamap['weight'];
  //     var height = cWidgetDatamap['height'];
  //     var measurement_equipment = cWidgetDatamap['measurement_equipment'];
  //
  //     if (weight != null && height != null) {
  //       if (height > 0 && measurement_equipment == '1') {
  //         ///Stediometer
  //         height = Global.stringToDouble(height.toString()) + 0.7;
  //       } else if (height > 0 && measurement_equipment == '2') {
  //         ///Infantometer
  //         height = Global.stringToDouble(height.toString()) - 0.7;
  //       }
  //       if (gender == '1') {
  //         var filtredItem = tabWeightToHeightBoys
  //             .where((element) =>
  //                 element.length ==
  //                 Global.roundToNearestHalf(Global.validNum(height.toString())))
  //             .toList();
  //         if (filtredItem.length > 0) {
  //           if (Global.validNum(weight.toString()) <= filtredItem[0].red!) {
  //             growthValue = "<=${filtredItem[0].red!}";
  //           } else if (Global.validNum(weight.toString()) <=
  //                   filtredItem[0].yellow_max! &&
  //               Global.validNum(weight.toString()) >=
  //                   filtredItem[0].yellow_min!) {
  //             growthValue =
  //                 "${filtredItem[0].yellow_min!}-${filtredItem[0].yellow_max!}";
  //           } else if (Global.validNum(weight.toString()) >=
  //               filtredItem[0].green!) {
  //             growthValue = ">=${filtredItem[0].green!}";
  //           }
  //         }
  //       } else if (gender == '2' || gender == '3') {
  //         var filtredItem = tabWeightToHeightGirls
  //             .where((element) =>
  //                 element.length ==
  //                 Global.roundToNearestHalf(Global.validNum(height.toString())))
  //             .toList();
  //         if (filtredItem.length > 0) {
  //           if (Global.validNum(weight.toString()) <= filtredItem[0].red!) {
  //             growthValue = "<=${filtredItem[0].red!}";
  //           } else if (Global.validNum(weight.toString()) <=
  //                   filtredItem[0].yellow_max! &&
  //               Global.validNum(weight.toString()) >=
  //                   filtredItem[0].yellow_min!) {
  //             growthValue =
  //                 "${filtredItem[0].yellow_min!}-${filtredItem[0].yellow_max!}";
  //           } else if (Global.validNum(weight.toString()) >=
  //               filtredItem[0].green!) {
  //             growthValue = ">=${filtredItem[0].green!}";
  //           }
  //         }
  //       }
  //     }
  //   }
  //
  //   return growthValue;
  // }

  TabFormsLogic? keyBoardLogic(String fieldName) {
    TabFormsLogic? keyLogic;
    var keyLogics = logics
        .where((element) =>
            element.parentControl == fieldName &&
            element.type_of_logic_id == '15')
        .toList();
    if (keyLogics.length > 0) {
      keyLogic = keyLogics[0];
    }
    return keyLogic;
  }

  int dependeOnMendotory(
      Map<String, dynamic> answred, HouseHoldFielItemdModel parentItem) {
    int isMendotory = 0;
    var parentQlogic = logics
        .where((element) =>
            element.parentControl == parentItem.fieldname &&
            (element.type_of_logic_id == '1' ||
                element.type_of_logic_id == '3' ||
                element.type_of_logic_id == '12' ||
                element.type_of_logic_id == '18' ||
                element.type_of_logic_id == '24'))
        .toList();

    if (parentQlogic.length > 0) {
      isMendotory = 1;
    }
    return isMendotory;
  }
}
