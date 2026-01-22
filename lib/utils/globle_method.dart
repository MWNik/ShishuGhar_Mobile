import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shishughar/utils/validate.dart';

import '../model/apimodel/creche_database_responce_model.dart';
import '../model/apimodel/translation_language_api_model.dart';
import '../model/databasemodel/tabBlock_model.dart';
import '../model/databasemodel/tabDistrict_model.dart';
import '../model/databasemodel/tabGramPanchayat_model.dart';
import '../model/databasemodel/tabVillage_model.dart';
import '../model/databasemodel/tabstate_model.dart';
import '../model/dynamic_screen_model/options_model.dart';

class Global {
  static validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter valid E-Mail Address';
    }
    if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  static validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter Your User Id';
    }

    return null;
  }

  static double callPercentage(int totalValue, int percentage) {
    return (percentage / totalValue) * 100;
  }

  static validateMobileNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter Your Mobile no.';
    }
    if (value.trim().length < 10) {
      return 'Mobile must be at least 10 digits';
    }
    return null;
  }

  static validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'enter your password';
    }
    if (value.trim().length < 8) {
      return "Password must be at least 8 Numbers in length";
    }
    return null;
  }

  static bool validString(String? value) {
    if (value == null || value.isEmpty || value == 'null')
      return false;
    else
      return true;
  }

  static String validToString(String? value) {
    if (value != null) {
      if (value == 'null' || value.isEmpty) {
        return '';
      } else {
        return value.toString();
      }
    } else {
      return '';
    }
  }

  static String? validToStringNullable(String? value) {
    if(validString(value)){
      return value;
    }else{
      return null;
    }
  }

  static String convertToTwoDigit(int number) {
    return number.toString().padLeft(2, '0');
  }

  static bool validToBool(bool? isSelected) {
    if (isSelected != null) {
      return isSelected;
    } else {
      return false;
    }
  }

  static int validToInt(int? value) {
    if (value != null) {
      return value;
    } else {
      return 0;
    }
  }

  static String getItemValues(String? response, String key) {
    String returnValue = "";
    if (validString(response)) {
      Map<String, dynamic> itemresponse = jsonDecode(response!);
      var value = itemresponse[key];
      if (value != null) {
        returnValue = value.toString();
        print(" keyvalue $key $returnValue");
      }
    }
    return returnValue;
  }

  static int stringToInt(String? value) {
    try {
      if (Global.validString(value))
        return int.parse(value!);
      else
        return 0;
    } on Exception {
      return 0;
    }
  }

  static int? stringToIntNull(String? value) {
    try {
      if (Global.validString(value))
        return int.parse(value!);
      else
        return null;
    } on Exception {
      return null;
    }
  }

  static double stringToDouble(String? value) {
    try {
      if (Global.validString(value))
        return double.parse(value!);
      else
        return 0;
    } on Exception {
      return 0;
    }
  }

  static double? stringToDoubleNullable(String? value) {
    try {
      if (Global.validString(value))
        return double.parse(value!);
      else
        return null;
    } on Exception {
      return null;
    }
  }

  static double presentPercent(int present, int total) {
    if (total <= 0) return 0;           // avoid divide-by-zero
    return (present / total) * 100;     // e.g., 15/20 * 100 = 75.0
  }

  static int getbackDaysByMonth(String? date,int month) {
    int days=0;
    try {
      if(Global.validString(date)) {
        DateTime? dateValue = Validate().stringToDateNull(date!);
        if (dateValue != null) {
          DateTime newDate = DateTime(
              dateValue.year, dateValue.month - month, dateValue.day);
          days = Validate().calculateAgeInDaysEx(newDate, dateValue);
        }
      }
     return days;
    } on Exception {
      return days;
    }
  }

  static double roundToNearestHalf(double number) {
    return (number * 2).ceil() / 2;
  }
  static double roundToNearest(double number) {
    print(double.parse(number.toStringAsFixed(1)));
    return double.parse(number.toStringAsFixed(1));
  }


  static double roundAfterTwoDecimalTr(num number) {
    double truncatedValue = (number * 100).truncateToDouble()/ 100;
    return truncatedValue;
  }

  static double stringToDoubleTr(String? number) {
    double truncatedValue=0.00;
    if(validNum(number)>0){
      double value = double.parse(number!);
       truncatedValue = (value * 100).truncateToDouble()/ 100;
    }
    return truncatedValue;
  }

  static double roundAfterThreeDecimalTr(num number) {
    double truncatedValue = (number * 1000).truncateToDouble()/ 1000;
    return truncatedValue;
  }

  static double stringToDoubleThreeTr(String? number) {
    double truncatedValue=0.00;
    if(validNum(number)>0){
      double value = double.parse(number!);
      truncatedValue = (value * 1000).truncateToDouble()/ 1000;
    }
    return truncatedValue;
  }


  static String intToString(int? value) {
    try {
      return validToString('$value');
    } on Exception {
      return "";
    }
  }

  static double validNum(String? values) {
    try {
      print(double.parse(values.toString()));
      return double.parse(values.toString());
    } on Exception {
      return 0;
    }
  }

  static List<String> splitData(String? values, String rejex) {
    if (validString(values)) {
      return values!.split(rejex);
    } else {
      return [];
    }
  }

  static num retrunValidNum(num? values) {
    try {
      if (values != null) {
        return values;
      } else
        return 0;
    } on Exception {
      return 0;
    }
  }

  static double calculateZScore(double value, double M, double L, double S) {
    // if (L == 0) {
    //   throw ArgumentError("L should not be zero to avoid division errors.");
    // }
    // return ((pow(value / M, L)) - 1) / (S * L);
    // Step 1: Compute (value / M)
    double ratio = value / M;

    // Step 2: Compute (ratio^L)
    double ratioToL = pow(ratio, L).toDouble(); // Convert result to double

    // Step 3: Compute (ratio^L - 1)
    double numerator = ratioToL - 1;

    // Step 4: Compute (S * L)
    double denominator = S * L;

    // Step 5: Compute Z-score
    double zScore = numerator / denominator;

    if (zScore <= -3) {
     var sd3neg = (M * pow(1 + L * S * (-3), 1 / L)).toDouble();
     var sd2neg = (M * pow(1 + L * S * (-2), 1 / L)).toDouble();
     var sd23neg = (sd2neg - sd3neg).toDouble();
      zScore = (-3 + (value - sd3neg) / sd23neg).toDouble();
    }else if (zScore >= 3) {
      var sd3pos = (M * pow(1 + L * S * (3), 1 / L)).toDouble();
      var sd2pos = (M * pow(1 + L * S * (2), 1 / L)).toDouble();
      var sd23pos = (sd3pos - sd2pos).toDouble();
      zScore = (3 + (value - sd3pos) / sd23pos).toDouble();
    }
    return stringToDouble(zScore.toStringAsFixed(2));
   // return zScore;
  }

  static String returnTrLable(
      List<Translation> translats, String? key, String lang) {
    String retuValue = '';
    if (validString(key)) {
      retuValue = key!;
      if (Global.validString(lang)) {
        //  if (!(lang == 'en')) {
        var trs = translats
            .where(
                (element) => element.name!.toLowerCase() == key.toLowerCase())
            .toList();
        if (trs.length > 0) {
          if (lang == "hi") {
            retuValue = trs[0].hindi!;
          } else if (lang == "od") {
            retuValue = trs[0].odia!;
          } else if (lang == "en") {
            retuValue = trs[0].english!;
          } else if (lang == "kn") {
            retuValue = trs[0].kannada!;
          }
        } else {
          retuValue = key;
        }
        // }else{retuValue = key;}
      }
    } else
      retuValue = validToString(key);
    return retuValue;
  }

  static String errorBodyToString(String? errorBody, String key) {
    try {
      if (errorBody != null) {
        var mesg = jsonDecode(errorBody);
        var msg = mesg[key];
        if (Global.validString(msg)) {
          return msg;
        } else
          return "Server error!";
      } else
        return "Server error!";
    } on Exception {
      return "Server error!";
    }
  }

  static String errorBodyToStringFromList(String? errorBody) {
    
    if (errorBody != null) {
      try {
        var mesg = jsonDecode(errorBody);
        if (mesg != null && mesg is Map) {
          String jsonString = mesg["_server_messages"];
          List<dynamic> messageList = jsonDecode(jsonString);
          if (messageList.isNotEmpty) {
            var message = jsonDecode(messageList[0]);
            var msg = message['message'];
            print("Message: $msg");
            return msg;
          } else {
            return 'Something Went wrong!.';
          }
        } else {
          return 'Something Went wrong!.';
        }
      } catch (e) {
        print("Error decoding JSON: $e");
        return 'Something Went wrong!.';
      }
    } else {
      return 'Something Went wrong!.';
    }
  }

  static DateTime? stringToDate(String? date) {
    try {
      if (Global.validString(date)) {
        var split = date!.split('-');
        if (split.length == 3) {
          int year = int.parse(split[0]);
          int month = int.parse(split[1]);
          int day = int.parse(split[2]);
          return DateTime(year, month, day);
        }
        return null;
      } else
        return null;
    } on Exception {
      return null;
    }
  }

  static String initCurrentDate() {
    String currentDate = "";
    currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return currentDate;
  }

  static List<OptionsModel> callFiltersCreches(
      List<CresheDatabaseResponceModel> creches, String lng, OptionsModel? parentItem)
  {
    List<OptionsModel> teCreches = [];
    if (parentItem != null && creches.length > 0) {
      creches =
          creches.where((element) => getItemValues(element.responces, 'village_id') == parentItem.name).toList();
      creches.forEach((element) {
        var item = OptionsModel();
        item.name = "${element.name}";
        item.flag = "tabCreche";
        item.values = getItemValues(element.responces, 'creche_name');
        teCreches.add(item);
      });
    }
    return teCreches;
  }

  static List<OptionsModel> callAllModelCreches(
      List<CresheDatabaseResponceModel> creches, String lng)
  {
    List<OptionsModel> teCreches = [];
    if (creches.length>0) {
      creches.forEach((element) {
        var item = OptionsModel();
        item.name = "${element.name}";
        item.flag = "tabCreche";
        item.values = getItemValues(element.responces, 'creche_name');
        teCreches.add(item);
      });
    }
    return teCreches;
  }

  static List<OptionsModel> callFiltersCrechesByState(
      List<CresheDatabaseResponceModel> creches, String lng, OptionsModel? parentItem)
  {
    List<OptionsModel> teCreches = [];
    if (parentItem != null && creches.length > 0) {
      creches =
          creches.where((element) => getItemValues(element.responces, 'state_id') == parentItem.name).toList();
      creches.forEach((element) {
        var item = OptionsModel();
        item.name = "${element.name}";
        item.flag = "tabCreche";
        item.values = getItemValues(element.responces, 'creche_name');
        teCreches.add(item);
      });
    }
    return teCreches;
  }

  static List<OptionsModel> callFiltersCrechesByDistric(
      List<CresheDatabaseResponceModel> creches, String lng, OptionsModel? parentItem)
  {
    List<OptionsModel> teCreches = [];
    if (parentItem != null && creches.length > 0) {
      creches =
          creches.where((element) => getItemValues(element.responces, 'district_id') == parentItem.name).toList();
      creches.forEach((element) {
        var item = OptionsModel();
        item.name = "${element.name}";
        item.flag = "tabCreche";
        item.values = getItemValues(element.responces, 'creche_name');
        teCreches.add(item);
      });
    }
    return teCreches;
  }

  static List<OptionsModel> callFiltersCrechesByBlock(
      List<CresheDatabaseResponceModel> creches, String lng, OptionsModel? parentItem)
  {
    List<OptionsModel> teCreches = [];
    if (parentItem != null && creches.length > 0) {
      creches =
          creches.where((element) => getItemValues(element.responces, 'block_id') == parentItem.name).toList();
      creches.forEach((element) {
        var item = OptionsModel();
        item.name = "${element.name}";
        item.flag = "tabCreche";
        item.values = getItemValues(element.responces, 'creche_name');
        teCreches.add(item);
      });
    }
    return teCreches;
  }

  static List<OptionsModel> callFiltersCrechesByGP(
      List<CresheDatabaseResponceModel> creches, String lng, OptionsModel? parentItem)
  {
    List<OptionsModel> teCreches = [];
    if (parentItem != null && creches.length > 0) {
      creches =
          creches.where((element) => getItemValues(element.responces, 'gp_id') == parentItem.name).toList();
      creches.forEach((element) {
        var item = OptionsModel();
        item.name = "${element.name}";
        item.flag = "tabCreche";
        item.values = getItemValues(element.responces, 'creche_name');
        teCreches.add(item);
      });
    }
    return teCreches;
  }

  static List<OptionsModel> callFiltersVillages(
      List<TabVillage> villages, String lng, OptionsModel? parentItem)
  {
    List<OptionsModel> teVillage = [];
    if (parentItem != null && villages.length > 0) {
      villages =
          villages.where((element) => element.gpId == parentItem.name).toList();
      villages.forEach((element) {
        var item = OptionsModel();
        item.name = "${element.name}";
        item.flag = "tabVillage";
        var value = "${element.value}";
        if (lng == 'hi' && Global.validString(element.village_hi.toString())) {
          value = element.village_hi.toString();
        } else if (lng == 'od' &&
            Global.validString(element.village_od.toString())) {
          value = element.village_od.toString();
        } else if (lng == 'kn' &&
            Global.validString(element.village_kn.toString())) {
          value = element.village_kn.toString();
        }
        item.values = value;
        teVillage.add(item);
      });
    }
    return teVillage;
  }



  static List<OptionsModel> callGramPanchyats(
      List<TabGramPanchayat> gp, String lng, OptionsModel? parentItem)
  {
    List<OptionsModel> teGramP = [];
    if (parentItem != null && gp.length > 0) {
      gp = gp.where((element) => element.blockId == parentItem.name).toList();
      gp.forEach((element) {
        var item = OptionsModel();
        item.name = "${element.name}";
        item.flag = "tabGram Panchayat";
        var value = "${element.value}";
        if (lng == 'hi' && Global.validString(element.gp_hi.toString())) {
          value = element.gp_hi.toString();
        } else if (lng == 'od' &&
            Global.validString(element.gp_od.toString())) {
          value = element.gp_od.toString();
        } else if (lng == 'kn' &&
            Global.validString(element.gp_kn.toString())) {
          value = element.gp_kn.toString();
        }
        item.values = value;
        teGramP.add(item);
      });
    }
    return teGramP;
  }

  static List<OptionsModel> callBlocks(
      List<TabBlock> bloks, String lng, OptionsModel? parentItem)
  {
    List<OptionsModel> teBlock = [];
    if (parentItem != null && bloks.length > 0) {
      bloks = bloks
          .where((element) => element.districtId == parentItem.name)
          .toList();
      bloks.forEach((element) {
        var item = OptionsModel();
        item.name = "${element.name}";
        item.flag = "tabBlock";
        var value = "${element.value}";
        if (lng == 'hi' && Global.validString(element.block_hi.toString())) {
          value = element.block_hi.toString();
        } else if (lng == 'od' &&
            Global.validString(element.block_od.toString())) {
          value = element.block_od.toString();
        } else if (lng == 'kn' &&
            Global.validString(element.block_kn.toString())) {
          value = element.block_kn.toString();
        }
        item.values = value;
        teBlock.add(item);
      });
    }
    return teBlock;
  }

  static List<OptionsModel> callDistrict(
      List<TabDistrict> districts, String lng, OptionsModel? parentItem)
  {
    List<OptionsModel> teDistrict = [];
    if (parentItem != null && districts.length > 0) {
      districts = districts
          .where((element) => element.stateId == parentItem.name)
          .toList();
      districts.forEach((element) {
        var item = OptionsModel();
        item.name = "${element.name}";
        item.flag = "tabDistrict";
        var value = "${element.value}";
        if (lng == 'hi' && Global.validString(element.district_hi.toString())) {
          value = element.district_hi.toString();
        } else if (lng == 'od' &&
            Global.validString(element.district_od.toString())) {
          value = element.district_od.toString();
        } else if (lng == 'kn' &&
            Global.validString(element.district_kn.toString())) {
          value = element.district_kn.toString();
        }
        item.values = value;
        teDistrict.add(item);
      });
    }
    return teDistrict;
  }

  static List<OptionsModel> callNativeDistrict(
      List<TabDistrict> districts, String lng, OptionsModel? parentItem)
  {
    List<OptionsModel> teDistrict = [];
    if (parentItem != null && districts.length > 0) {
      districts = districts
          .where((element) => element.stateId == parentItem.name)
          .toList();
      districts.forEach((element) {
        var item = OptionsModel();
        item.name = "${element.name}";
        item.flag = "tabNativeDistrict";
        var value = "${element.value}";
        if (lng == 'hi' && Global.validString(element.district_hi.toString())) {
          value = element.district_hi.toString();
        } else if (lng == 'od' &&
            Global.validString(element.district_od.toString())) {
          value = element.district_od.toString();
        } else if (lng == 'kn' &&
            Global.validString(element.district_kn.toString())) {
          value = element.district_kn.toString();
        }
        item.values = value;
        teDistrict.add(item);
      });
    }
    return teDistrict;
  }

  static List<OptionsModel> callSatates(List<TabState> states, String lng)
  {
    List<OptionsModel> teStates = [];
    if (states.length > 0) {
      states.forEach((element) {
        var item = OptionsModel();
        item.name = "${element.name}";
        item.flag = "tabState";
        var value = "${element.value}";
        if (lng == 'hi' && Global.validString(element.state_hi.toString())) {
          value = element.state_hi.toString();
        } else if (lng == 'od' &&
            Global.validString(element.state_od.toString())) {
          value = element.state_od.toString();
        } else if (lng == 'kn' &&
            Global.validString(element.state_kn.toString())) {
          value = element.state_kn.toString();
        }
        item.values = value;
        teStates.add(item);
      });
    }
    return teStates;
  }

  static List<OptionsModel> callNativeSatates(List<TabState> states, String lng)
  {
    List<OptionsModel> teStates = [];
    if (states.length > 0) {
      states.forEach((element) {
        var item = OptionsModel();
        item.name = "${element.name}";
        item.flag = "tabNativeState";
        var value = "${element.value}";
        if (lng == 'hi' && Global.validString(element.state_hi.toString())) {
          value = element.state_hi.toString();
        } else if (lng == 'od' &&
            Global.validString(element.state_od.toString())) {
          value = element.state_od.toString();
        } else if (lng == 'kn' &&
            Global.validString(element.state_kn.toString())) {
          value = element.state_kn.toString();
        }
        item.values = value;
        teStates.add(item);
      });
    }
    return teStates;
  }

  static String replaceSpecialSymbol({
    required String message,
    String? addedValue,
    String? tempValue,
  }) {
    String updatedMessage = message;

    if (tempValue != null && tempValue.isNotEmpty) {
      updatedMessage = updatedMessage.replaceAll(RegExp('@', caseSensitive: false), tempValue);
    }

    if (addedValue != null && addedValue.isNotEmpty) {
      updatedMessage = updatedMessage.replaceAll(RegExp('#', caseSensitive: false), addedValue);
    }

    return updatedMessage;
  }

 static void applyDisplayCutout(Color statusBarColor) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: statusBarColor, // Set status bar color
      statusBarIconBrightness: Brightness.light, // Set icons to dark (black)
      systemNavigationBarColor: Colors.transparent, // Transparent navigation bar
      systemNavigationBarIconBrightness: Brightness.dark, // Dark nav bar icons
    ));
    // Ensure proper cutout handling
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
      overlays: [SystemUiOverlay.top], // Ensure status bar is visible
    );
  }


  static Color getColorByData(int? countData){
    if(validToInt(countData)>0){
      return Colors.white;
    }return Colors.grey.shade300;
  }

  static String getDateByMonthYear(int year, int month) {
    // Create a DateTime for the 0th day of the *next* month
    DateTime lastDay = DateTime(year, month + 1, 0);
    var formatter = new DateFormat('yyyy-MM-dd');
    return formatter.format(lastDay);
  }

  static String getFirstDayDateByDate(String date) {
    var dateTime=Validate().stringToDate(date);
    DateTime lastDay = DateTime(dateTime.year, dateTime.month, 1);
    var formatter = new DateFormat('yyyy-MM-dd');
    return formatter.format(lastDay);
  }

  static String getMonthYearByDate(String date) {
    var dateTime=Validate().stringToDate(date);
    DateTime lastDay = DateTime(dateTime.year, dateTime.month, 1);
    var formatter = new DateFormat('yyyy-MM');
    return formatter.format(lastDay);
  }

  static String getMonthYearCurrentDayByDate(String date) {
    var dateTime=Validate().stringToDate(date);
    DateTime lastDay = DateTime(dateTime.year, dateTime.month, DateTime.now().day);
    var formatter = new DateFormat('yyyy-MM');
    return formatter.format(lastDay);
  }

  static Map<String, Color> cardColors = {
    'NoOfCreches': Color(0xffe8e8e8),
    'CurrentActiveChildren': Color(0xffe8e8e8),
    'NoOfCrechesSubmittedAttendance': Color(0xffe8e8e8),
    'NoOfCrechesNotSubmittedAttendance': Color(0xffe8e8e8),

    'AvgNoOfDaysCrecheOpened': Color(0xffcfe5fc),
    'AvgAttendancePerDay': Color(0xffcfe5fc),
    'MaximumAttendanceInDay': Color(0xffcfe5fc),
    'AnthroDataSubmitted': Color(0xffcfe5fc),
    'AnthroDataNotSubmitted': Color(0xffcfe5fc),
    'AvgNoDaysAttendanceSubmitted': Color(0xffcfe5fc),

    'CurrentEligibleChildren': Color(0xffebfced),
    'ChildrenEnrolledThisMonth': Color(0xffebfced),
    'ChildrenExitedThisMonth': Color(0xffebfced),
    'CumulativeExitChildren': Color(0xffebfced),
    'RedFlagChildren': Color(0xffebfced),

    'ChildrenMeasurementTaken': Color(0xfffce9cf),
    'ModeratelyUnderweight': Color(0xfffce9cf),
    'ModeratelyWasted': Color(0xfffce9cf),
    'Growthfaltering1': Color(0xfffce9cf),
    'ModeratelyStunted': Color(0xfffce9cf),

    'ChildrenMeasurementNotTaken': Color(0xfffcd9d9),
    'SeverelyUnderweight': Color(0xfffcd9d9),
    'SeverelyWasted': Color(0xfffcd9d9),
    'Growthfaltering2': Color(0xfffcd9d9),
    'SeverelyStunted': Color(0xfffcd9d9),
  };

  static Map<String, Color> cardBorderColors = {
    'NoOfCreches': Color(0xffa8a8a8),
    'CurrentActiveChildren': Color(0xffa8a8a8),
    'NoOfCrechesSubmittedAttendance': Color(0xffa8a8a8),
    'NoOfCrechesNotSubmittedAttendance': Color(0xffa8a8a8),

    'AvgNoOfDaysCrecheOpened': Color(0xff7ebefa),
    'AvgAttendancePerDay': Color(0xff7ebefa),
    'MaximumAttendanceInDay': Color(0xff7ebefa),
    'AnthroDataSubmitted': Color(0xff7ebefa),
    'AnthroDataNotSubmitted': Color(0xff7ebefa),
    'AvgNoDaysAttendanceSubmitted': Color(0xff7ebefa),

    'CurrentEligibleChildren': Color(0xffa9f8ac),
    'ChildrenEnrolledThisMonth': Color(0xffa9f8ac),
    'ChildrenExitedThisMonth': Color(0xffa9f8ac),
    'CumulativeExitChildren': Color(0xffa9f8ac),
    'RedFlagChildren': Color(0xffa9f8ac),

    'ChildrenMeasurementTaken': Color(0xfff3cf9e),
    'ModeratelyUnderweight': Color(0xfff3cf9e),
    'ModeratelyWasted': Color(0xfff3cf9e),
    'Growthfaltering1': Color(0xfff3cf9e),
    'ModeratelyStunted': Color(0xfff3cf9e),

    'ChildrenMeasurementNotTaken': Color(0xffff9090),
    'SeverelyUnderweight': Color(0xffff9090),
    'SeverelyWasted': Color(0xffff9090),
    'Growthfaltering2': Color(0xffff9090),
    'SeverelyStunted': Color(0xffff9090),
  };

  static Color getCardColor(String cardId) {
    return cardColors[cardId] ?? const Color(0xffe8e8e8); // default fallback
  }

  static Color getCardBorderColor(String cardId) {
    return cardBorderColors[cardId] ?? const Color(0xffe8e8e8); // default fallback
  }

  static String languageWise(
       String lng, String? en, String? hi,String? od,String? kn,)
  {
    String itemValue=Global.validToString(en);
    if (lng == 'hi' && Global.validString(hi)) {
      itemValue=hi!;
    } else if (lng == 'od' &&
        Global.validString(od)) {
      itemValue=od!;
    } else if (lng == 'kn' &&
        Global.validString(kn)) {
      itemValue=kn!;
    }
    return itemValue;
  }


  static String subtractMonths(String date, int monthsBack) {
    // Target month/year
    DateTime inputDate = Validate().stringToDate(date);
    int newYear = inputDate.year;
    int newMonth = inputDate.month - monthsBack;

    // Adjust year if month underflows
    while (newMonth <= 0) {
      newMonth += 12;
      newYear -= 1;
    }

    // Find the last day of that month
    int lastDayOfMonth = DateTime(newYear, newMonth + 1, 0).day;

    // Clamp day to avoid invalid dates
    int newDay = inputDate.day > lastDayOfMonth ? lastDayOfMonth : inputDate.day;

    return Validate().dateToString(DateTime(newYear, newMonth, newDay))!;
  }

  static bool isCurrentMonth(String date){
    DateTime inputDate = Validate().stringToDate(date);
    DateTime currenDate = DateTime.now();
    if(inputDate.year==currenDate.year&&inputDate.month==currenDate.month){
      return true;
    }else return false;

  }


}
