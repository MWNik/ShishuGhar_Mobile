import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:shishughar/utils/globle_method.dart';

import '../../../model/apimodel/form_logic_api_model.dart';
import '../../../model/apimodel/house_hold_field_item_model_api.dart';
import '../../../model/apimodel/tabHeight_for_age_Boys_model.dart';
import '../../../model/apimodel/tabHeight_for_age_Girls_model.dart';
import '../../../model/apimodel/tabWeight_for_age_Boys _model.dart';
import '../../../model/apimodel/tabWeight_for_age_Girls _model.dart';
import '../../../model/apimodel/tabWeight_to_Height_Boys_model.dart';
import '../../../model/apimodel/tabWeight_to_Height_Girls_model.dart';
import '../../../utils/validate.dart';

class DependingLogic {
  bool callDependingLogic(List<TabFormsLogic> logics,
      Map<String, dynamic> answred, HouseHoldFielItemdModel parentItem) {
    bool dependingAns = false;
    var parentQlogic = logics
        .where((element) =>
            element.parentControl == parentItem.fieldname &&
            (element.type_of_logic_id == '1' ||
                element.type_of_logic_id == '3' ||
                element.type_of_logic_id == '12' ||
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
        }
      }
    } else {
      dependingAns = true;
    }
    print("return logic  $dependingAns  name ${parentItem.fieldname}");
    return dependingAns;
  }

  bool callReadableLogic(List<TabFormsLogic> logics,
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

  Map callDateDiffrenceLogic(List<TabFormsLogic> logics,
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
            if (element.algorithmExpression.toLowerCase() == 'm')
              calucalteDate = Validate().calculateAgeInMonths(date);
            else if (element.algorithmExpression.toLowerCase() == 'y')
              calucalteDate = Validate().calculateAgeInYear(date);
            else if (element.algorithmExpression.toLowerCase() == 'd')
              calucalteDate = Validate().calculateAgeInDays(date);

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

  Map callAutoGeneratedValue(List<TabFormsLogic> logics,
      Map<String, dynamic> answred, HouseHoldFielItemdModel parentItem) {
    Map item = {};
    var parentQlogic = logics
        .where((element) =>
            element.dependentControls.contains(parentItem.fieldname!) &&
            (element.type_of_logic_id == '4'))
        .toList();
    //   var items= logics.where((element) => element.parentControl.contains(parentItem.fieldname!) &&(element.type_of_logic_id=='20')
    // ).toList();
    // parentQlogic.addAll(items);
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
        // else if(element.type_of_logic_id=='20'){
        //   var dependVAlu=answred[element.dependentControls];
        //   var algo=Global.splitData(element.algorithmExpression,'');
        //   if(dependVAlu!=null && algo.length==2){
        //     if(dependVAlu==algo[0]){
        //
        //     }
        //   }
        // }
      }
    }

    return item;
  }

  List<String> calenderValidation(List<TabFormsLogic> logics,
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
            items.add(parentQlogic[i].algorithmExpression);
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

  String? validationMessge(List<TabFormsLogic> logics,
      Map<String, dynamic> answred, HouseHoldFielItemdModel parentItem) {
    String? retuenValu;
    // var parentQlogic = logics
    //     .where((element) =>
    //         element.dependentControls.contains(parentItem.fieldname!) &&
    //         (element.type_of_logic_id == '6'))
    //     .toList();
    var logicdependControl = logics
        .where((element) =>
    element.parentControl.contains(parentItem.fieldname!) &&
        (element.type_of_logic_id == '1' ||
            element.type_of_logic_id == '3' ||
            element.type_of_logic_id == '7' ||
            element.type_of_logic_id == '9' ||
            element.type_of_logic_id == '17' ||
            element.type_of_logic_id == '19' ||
            element.type_of_logic_id == '12' ||
            element.type_of_logic_id == '18' ||
            element.type_of_logic_id == '6' ||
            element.type_of_logic_id == '16'))
        .toList();

    // parentQlogic.addAll(logicdependControl);
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
                  if (!(dependVAlu <= validValu)) {
                    retuenValu =
                    "Value of ${parentItem.label} must be less than Or equal to $validValu";
                    break;
                  }
                } else if (exp[1] == '<') {
                  if (!(dependVAlu < validValu)) {
                    retuenValu =
                    "Value of ${parentItem.label} must be less than $validValu";
                    break;
                  }
                } else if (exp[1] == '>=') {
                  if (!(dependVAlu >= validValu)) {
                    retuenValu =
                    "Value of ${parentItem.label} must be greater than Or equal to $validValu";
                    break;
                  }
                } else if (exp[1] == '>') {
                  if (!(dependVAlu > validValu)) {
                    retuenValu =
                    "Value of ${parentItem.label} must be greater than $validValu";
                    break;
                  }
                } else if (exp[1] == '==') {
                  if (!(dependVAlu == validValu)) {
                    retuenValu =
                    "Value of ${parentItem.label} must be equal to $validValu";
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
                  retuenValu =
                  "Value of ${parentItem.label} must be less than Or equal to $dependVAlu";
                  break;
                }
              } else if (element.algorithmExpression == '<') {
                if (!(parrentValue < dependVAlu)) {
                  retuenValu =
                  "Value of ${parentItem.label} must be less than $dependVAlu";
                  break;
                }
              } else if (element.algorithmExpression == '>=') {
                if (!(parrentValue >= dependVAlu)) {
                  retuenValu =
                  "Value of ${parentItem.label} must be greater than Or equal to $dependVAlu";
                  break;
                }
              } else if (element.algorithmExpression == '>') {
                if (!(parrentValue > dependVAlu)) {
                  retuenValu =
                  "Value of ${parentItem.label} must be greater than $dependVAlu";
                  break;
                }
              } else if (element.algorithmExpression == '==') {
                if (!(parrentValue==dependVAlu)) {
                  retuenValu =
                  "Value of ${parentItem.label} must be equal to $dependVAlu";
                  break;
                }
              }
            }
          }
        } else if (element.type_of_logic_id == '1' ||
            element.type_of_logic_id == '3') {
          if (element.type_of_logic_id == '1') {
            var dependVAlu = answred[element.dependentControls].toString();
            if (dependVAlu == element.algorithmExpression.toString()) {
              var parentValu = answred[element.parentControl].toString();
              if (!(Global.validString(parentValu))) {
                if(parentItem.fieldtype=='Data' || parentItem.fieldtype=='Int' || parentItem.fieldtype=='Float')
                  retuenValu = "Please fill ${parentItem.label}";
                else  retuenValu = "Please select ${parentItem.label}";
                break;
              }
            }
          } else if (element.type_of_logic_id == '3') {
            var dependVAlu = answred[element.dependentControls].toString();
            if (dependVAlu == element.algorithmExpression.toString()) {
              var parentValu = answred[element.parentControl].toString();
              if (!(Global.validString(parentValu))) {
                if(parentItem.fieldtype=='Data' || parentItem.fieldtype=='Int' || parentItem.fieldtype=='Float')
                retuenValu = "Please fill ${parentItem.label}";
                else  retuenValu = "Please select ${parentItem.label}";
                break;
              }
            }
          }
        } else if (element.type_of_logic_id == '7') {
          var dependVAlu = answred[element.dependentControls].toString();
          var parentValue = answred[element.parentControl].toString();
          if (element.algorithmExpression.toString() == '>') {
            var parentDate = Global.stringToDate(parentValue);
            var dependsDate = Global.stringToDate(dependVAlu);
            if (parentDate != null && dependsDate != null) {
              if (!(dependsDate.isBefore(parentDate))) {
                // retuenValu =
                // "${dependsDate.day}-${dependsDate.month}-${dependsDate.year} should be in the future relative to the  ${parentItem
                //     .label}";
                retuenValu = 'Date of leaving must be after date of joining';
                break;
              }
            }
          }
        } else if (element.type_of_logic_id == '9') {
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
                  retuenValu = "${parentItem.label} is not valid";
                  break;
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
                    retuenValu =
                    "Value of ${parentItem.label} length must be less than Or equal to $validValu";
                    break;
                  }
                } else if (exp[1] == '>=') {
                  if (!(dependVAlu >= validValu)) {
                    retuenValu =
                    "Value of ${parentItem.label} length must be greater than Or equal to $validValu";
                    break;
                  }
                } else if (exp[1] == '==') {
                  if (!(dependVAlu == validValu)) {
                    retuenValu =
                    "Value of ${parentItem.label} length must be equal to $validValu";
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
                      retuenValu =
                      "Value of ${parentItem.label} must be less than Or equal to $validValu";
                      break;
                    }
                  } else if (exp[1] == '<') {
                    if (!(dependVAlu < validValu)) {
                      retuenValu =
                      "Value of ${parentItem.label} must be less than $validValu";
                      break;
                    }
                  } else if (exp[1] == '>=') {
                    if (!(dependVAlu >= validValu)) {
                      retuenValu =
                      "Value of ${parentItem.label} must be greater than Or equal to $validValu";
                      break;
                    }
                  } else if (exp[1] == '>') {
                    if (!(dependVAlu > validValu)) {
                      retuenValu =
                      "Value of ${parentItem.label} must be greater than $validValu";
                      break;
                    }
                  } else if (exp[1] == '==') {
                    if (!(dependVAlu == validValu)) {
                      retuenValu =
                      "Value of ${parentItem.label} must be equal to $validValu";
                      break;
                    }
                  }
                } else
                  'Please enter value in ${parentItem.label}';
              } else if (Global.validString(
                  answred[element.dependentControls].toString())) {
                if (exp[1] == '<=') {
                  if (!(dependVAlu <= validValu)) {
                    retuenValu =
                    "Value of ${parentItem.label} must be less than Or equal to $validValu";
                    break;
                  }
                } else if (exp[1] == '<') {
                  if (!(dependVAlu < validValu)) {
                    retuenValu =
                    "Value of ${parentItem.label} must be less than $validValu";
                    break;
                  }
                } else if (exp[1] == '>=') {
                  if (!(dependVAlu >= validValu)) {
                    retuenValu =
                    "Value of ${parentItem.label} must be greater than Or equal to $validValu";
                    break;
                  }
                } else if (exp[1] == '>') {
                  if (!(dependVAlu > validValu)) {
                    retuenValu =
                    "Value of ${parentItem.label} must be greater than $validValu";
                    break;
                  }
                } else if (exp[1] == '==') {
                  if (!(dependVAlu == validValu)) {
                    retuenValu =
                    "Value of ${parentItem.label} must be equal to $validValu";
                    break;
                  }
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
                  if(parentItem.fieldtype=='Data' || parentItem.fieldtype=='Int' || parentItem.fieldtype=='Float')
                    retuenValu = "Please enter ${parentItem.label}";
                  else  retuenValu = "Please select ${parentItem.label}";
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
                if(parentItem.fieldtype=='Data' || parentItem.fieldtype=='Int' || parentItem.fieldtype=='Float')
                  retuenValu = "Please enter ${parentItem.label}";
                else  retuenValu = "Please select ${parentItem.label}";
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
                retuenValu =
                "Please enter After ${parentItem.label} to $parentVAlu";
                break;
              }
            } else if (element.algorithmExpression == '>') {
              if (dependDate.isAfter(parentDate)) {
                retuenValu =
                "Please enter Before ${parentItem.label} to $parentVAlu";
                break;
              }
            }
          }
        }
      }
    }

    return retuenValu;
  }

  int AutoColorCreateByHeightWight(
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

    if (fieldname == 'weight_for_age') {
      var age = cWidgetDatamap['age_months'];
      var weight = cWidgetDatamap['weight'];
      if (age != null && weight != null) {
        if (gender == '1') {
          var filtredItem = tabWeightforageBoys
              .where((element) => element.age_in_months == age)
              .toList();
          if (filtredItem.length > 0) {
            if (Global.validNum(weight.toString()) <= filtredItem[0].red!) {
              retuenValu = 1;
            } else if (Global.validNum(weight.toString()) <=
                    filtredItem[0].yellow_max! &&
                Global.validNum(weight.toString()) >=
                    filtredItem[0].yellow_min!) {
              retuenValu = 2;
            } else if (Global.validNum(weight.toString()) >=
                filtredItem[0].green!) {
              retuenValu = 3;
            }
          }
        } else if (gender == '2' || gender == '3') {
          var filtredItem = tabWeightforageGirls
              .where((element) => element.age_in_months == age)
              .toList();
          if (filtredItem.length > 0) {
            if (Global.validNum(weight.toString()) <= filtredItem[0].red!) {
              retuenValu = 1;
            } else if (Global.validNum(weight.toString()) <=
                    filtredItem[0].yellow_max! &&
                Global.validNum(weight.toString()) >=
                    filtredItem[0].yellow_min!) {
              retuenValu = 2;
            } else if (Global.validNum(weight.toString()) >=
                filtredItem[0].green!) {
              retuenValu = 3;
            }
          }
        }
      }
    } else if (fieldname == 'height_for_age') {
      var age = cWidgetDatamap['age_months'];
      var height = cWidgetDatamap['height'];
      var measurement_equipment = cWidgetDatamap['measurement_equipment'];

      if (age != null && height != null) {
        if (age < 25 && height > 0 && measurement_equipment == '1') {
          ///Stediometer
          height = Global.stringToDouble(height.toString()) + 0.7;
        } else if (age > 24 && height > 0 && measurement_equipment == '2') {
          ///Infantometer
          height = Global.stringToDouble(height.toString()) - 0.7;
        }
        if (gender == '1') {
          var filtredItem = tabHeightforageBoys
              .where((element) => element.age_in_months == age)
              .toList();
          if (filtredItem.length > 0) {
            if (Global.validNum(height.toString()) <= filtredItem[0].red!) {
              retuenValu = 1;
            } else if (Global.validNum(height.toString()) <=
                    filtredItem[0].yellow_max! &&
                Global.validNum(height.toString()) >=
                    filtredItem[0].yellow_min!) {
              retuenValu = 2;
            } else if (Global.validNum(height.toString()) >=
                filtredItem[0].green!) {
              retuenValu = 3;
            }
          }
        } else if (gender == '2' || gender == '3') {
          var filtredItem = tHeightforageGirls
              .where((element) => element.age_in_months == age)
              .toList();
          if (filtredItem.length > 0) {
            if (Global.validNum(height.toString()) <= filtredItem[0].red!) {
              retuenValu = 1;
            } else if (Global.validNum(height.toString()) <=
                    filtredItem[0].yellow_max! &&
                Global.validNum(height.toString()) >=
                    filtredItem[0].yellow_min!) {
              retuenValu = 2;
            } else if (Global.validNum(height.toString()) >=
                filtredItem[0].green!) {
              retuenValu = 3;
            }
          }
        }
      }
    } else if (fieldname == 'weight_for_height') {
      var weight = cWidgetDatamap['weight'];
      var height = cWidgetDatamap['height'];
      var measurement_equipment = cWidgetDatamap['measurement_equipment'];

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
                  Global.roundToNearestHalf(Global.validNum(height.toString())))
              .toList();
          if (filtredItem.length > 0) {
            if (Global.validNum(weight.toString()) <= filtredItem[0].red!) {
              retuenValu = 1;
            } else if (Global.validNum(weight.toString()) <=
                    filtredItem[0].yellow_max! &&
                Global.validNum(weight.toString()) >=
                    filtredItem[0].yellow_min!) {
              retuenValu = 2;
            } else if (Global.validNum(weight.toString()) >=
                filtredItem[0].green!) {
              retuenValu = 3;
            }
          }
        } else if (gender == '2' || gender == '3') {
          var filtredItem = tabWeightToHeightGirls
              .where((element) =>
                  element.length ==
                  Global.roundToNearestHalf(Global.validNum(height.toString())))
              .toList();
          if (filtredItem.length > 0) {
            if (Global.validNum(weight.toString()) <= filtredItem[0].red!) {
              retuenValu = 1;
            } else if (Global.validNum(weight.toString()) <=
                    filtredItem[0].yellow_max! &&
                Global.validNum(weight.toString()) >=
                    filtredItem[0].yellow_min!) {
              retuenValu = 2;
            } else if (Global.validNum(weight.toString()) >=
                filtredItem[0].green!) {
              retuenValu = 3;
            }
          }
        }
      }
    }

    return retuenValu;
  }

  String AutoColorCreateByHeightWightString(
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

    if (fieldname == 'weight_for_age') {
      var age = cWidgetDatamap['age_months'];
      var weight = cWidgetDatamap['weight'];
      if (age != null && weight != null) {
        if (gender == '1') {
          var filtredItem = tabWeightforageBoys
              .where((element) => element.age_in_months == age)
              .toList();
          if (filtredItem.length > 0) {
            if (Global.validNum(weight.toString()) <= filtredItem[0].red!) {
              growthValue = "=>${filtredItem[0].red!}";
            } else if (Global.validNum(weight.toString()) <=
                    filtredItem[0].yellow_max! &&
                Global.validNum(weight.toString()) >=
                    filtredItem[0].yellow_min!) {
              growthValue =
                  "${filtredItem[0].yellow_min!}-${filtredItem[0].yellow_max!}";
            } else if (Global.validNum(weight.toString()) >=
                filtredItem[0].green!) {
              growthValue = ">=${filtredItem[0].green!}";
            }
          }
        } else if (gender == '2' || gender == '3') {
          var filtredItem = tabWeightforageGirls
              .where((element) => element.age_in_months == age)
              .toList();
          if (filtredItem.length > 0) {
            if (Global.validNum(weight.toString()) <= filtredItem[0].red!) {
              growthValue = "=>${filtredItem[0].red!}";
            } else if (Global.validNum(weight.toString()) <=
                    filtredItem[0].yellow_max! &&
                Global.validNum(weight.toString()) >=
                    filtredItem[0].yellow_min!) {
              growthValue =
                  "${filtredItem[0].yellow_min!}-${filtredItem[0].yellow_max!}";
            } else if (Global.validNum(weight.toString()) >=
                filtredItem[0].green!) {
              growthValue = ">=${filtredItem[0].green!}";
            }
          }
        }
      }
    } else if (fieldname == 'height_for_age') {
      var age = cWidgetDatamap['age_months'];
      var height = cWidgetDatamap['height'];
      var measurement_equipment = cWidgetDatamap['measurement_equipment'];

      if (age != null && height != null) {
        if (age < 25 && height > 0 && measurement_equipment == '1') {
          ///Stediometer
          height = Global.stringToDouble(height.toString()) + 0.7;
        } else if (age > 24 && height > 0 && measurement_equipment == '2') {
          ///Infantometer
          height = Global.stringToDouble(height.toString()) - 0.7;
        }
        if (gender == '1') {
          var filtredItem = tabHeightforageBoys
              .where((element) => element.age_in_months == age)
              .toList();
          if (filtredItem.length > 0) {
            if (Global.validNum(height.toString()) <= filtredItem[0].red!) {
              growthValue = "=>${filtredItem[0].red!}";
            } else if (Global.validNum(height.toString()) <=
                    filtredItem[0].yellow_max! &&
                Global.validNum(height.toString()) >=
                    filtredItem[0].yellow_min!) {
              growthValue =
                  "${filtredItem[0].yellow_min!}-${filtredItem[0].yellow_max!}";
            } else if (Global.validNum(height.toString()) >=
                filtredItem[0].green!) {
              growthValue = ">=${filtredItem[0].green!}";
            }
          }
        } else if (gender == '2' || gender == '3') {
          var filtredItem = tHeightforageGirls
              .where((element) => element.age_in_months == age)
              .toList();
          if (filtredItem.length > 0) {
            if (Global.validNum(height.toString()) <= filtredItem[0].red!) {
              growthValue = "=>${filtredItem[0].red!}";
            } else if (Global.validNum(height.toString()) <=
                    filtredItem[0].yellow_max! &&
                Global.validNum(height.toString()) >=
                    filtredItem[0].yellow_min!) {
              growthValue =
                  "${filtredItem[0].yellow_min!}-${filtredItem[0].yellow_max!}";
            } else if (Global.validNum(height.toString()) >=
                filtredItem[0].green!) {
              growthValue = ">=${filtredItem[0].green!}";
            }
          }
        }
      }
    } else if (fieldname == 'weight_for_height') {
      var weight = cWidgetDatamap['weight'];
      var height = cWidgetDatamap['height'];
      var measurement_equipment = cWidgetDatamap['measurement_equipment'];

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
                  Global.roundToNearestHalf(Global.validNum(height.toString())))
              .toList();
          if (filtredItem.length > 0) {
            if (Global.validNum(weight.toString()) <= filtredItem[0].red!) {
              growthValue = "=>${filtredItem[0].red!}";
            } else if (Global.validNum(weight.toString()) <=
                    filtredItem[0].yellow_max! &&
                Global.validNum(weight.toString()) >=
                    filtredItem[0].yellow_min!) {
              growthValue =
                  "${filtredItem[0].yellow_min!}-${filtredItem[0].yellow_max!}";
            } else if (Global.validNum(weight.toString()) >=
                filtredItem[0].green!) {
              growthValue = ">=${filtredItem[0].green!}";
            }
          }
        } else if (gender == '2' || gender == '3') {
          var filtredItem = tabWeightToHeightGirls
              .where((element) =>
                  element.length ==
                  Global.roundToNearestHalf(Global.validNum(height.toString())))
              .toList();
          if (filtredItem.length > 0) {
            if (Global.validNum(weight.toString()) <= filtredItem[0].red!) {
              growthValue = "=>${filtredItem[0].red!}";
            } else if (Global.validNum(weight.toString()) <=
                    filtredItem[0].yellow_max! &&
                Global.validNum(weight.toString()) >=
                    filtredItem[0].yellow_min!) {
              growthValue =
                  "${filtredItem[0].yellow_min!}-${filtredItem[0].yellow_max!}";
            } else if (Global.validNum(weight.toString()) >=
                filtredItem[0].green!) {
              growthValue = ">=${filtredItem[0].green!}";
            }
          }
        }
      }
    }

    return growthValue;
  }

  TabFormsLogic? keyBoardLogic(String fieldName, List<TabFormsLogic> logics) {
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

  int dependeOnMendotory(List<TabFormsLogic> logics,
      Map<String, dynamic> answred, HouseHoldFielItemdModel parentItem) {
    int isMendotory = 0;
    var parentQlogic = logics
        .where((element) =>
            element.parentControl == parentItem.fieldname &&
            (element.type_of_logic_id == '1' ||
                element.type_of_logic_id == '3' ||
                element.type_of_logic_id == '12' ||
                element.type_of_logic_id == '18'))
        .toList();

    if (parentQlogic.length > 0) {
      isMendotory = 1;
    }
    return isMendotory;
  }
}
