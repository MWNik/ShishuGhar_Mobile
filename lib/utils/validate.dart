import 'dart:math';
import 'dart:typed_data';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shishughar/utils/constants.dart';
import 'package:sqflite/sqflite.dart';

import '../custom_widget/single_poup_dailog.dart';

class Validate {
  static String userName = 'name';
  static String loginName = 'loginName';
  static String fullName = 'fullName';
  static String appToken = 'appToken';
  static String Password = 'Password';
  static String state = 'StateName';
  static String district = 'DistrictName';
  static String block = 'BlockName';
  static String gramPanchayat = 'GramPanchayat';

  static String stateID = 'stateID';
  static String districtID = 'districtID';
  static String blockID = 'blockID';
  static String gramPanchayatID = 'gramPanchayatID';
  static String latitude = 'latitude';
  static String longitude = 'longitude';
  static String address = 'address';

  static String village = 'Village';
  static String villageId = 'villageId';
  static String CrcheID = 'CrcheID';
  static String CrecheIdName = 'CrecheIdName';
  static String CrecheSName = 'CrecheSName';
  static String mobile_no = 'mobile_no';
  // static String crecheSelectedItem = 'crecheSelectedItem';
  static String sLanguage = 'sLanguage';
  static String villageIdES = 'villageIdES';
  static String householdForm = 'HouseholdForm';
  static String chilAttendence = 'chilAttendence';
  static String chilAnthropomertry = 'chilAnthropomertry';
  static String creChemodifiedDate = 'creChemodifiedDate';
  static String childProfilemodifiedDate = 'childProfilemodifiedDate';
  static String childEnrolledExitmodifiedData = 'childEnrolledExitmodifiedData';
  static String householdChildForm = 'HouseholdChildForm';
  static String role = 'role';
  static String panchayatId = 'panchayatId';
  static String msterDownloadDateTime = 'msterDownloadDateTime';
  static String dataDownloadDateTime = 'dataDownloadDateTime';
  static String dataUploadDateTime = 'dataUploadDateTime';

  static String childEventUpdateDate = 'childEventUpdateDate';
  static String childExitUpdatedDate = 'childExitUpdatedDate';
  static String childGravienceUpdatedDate = 'childGravienceUpdatedDate';
  static String ChildImmunizationUpdateDate = 'ChildImmunizationUpdateDate';
  static String ChildHealthUpdateDate = 'ChildHealthUpdateDate';
  static String ChildAntroUpdateDate = 'ChildAntroUpdateDate';
  static String ChildAttendeceUpdateDate = 'ChildAttendeceUpdateDate';
  static String crecheMonitoringMeta = 'crecheMonitoringMeta';
  static String childFollowUpUpdatedDate = 'childFollowUpUpdatedDate';
  static String childReferralUpdatedDate = 'childReferralUpdatedDate';
  static String crecheCommitteUpdateDate = 'crecheCommitteUpdateDate';
  // static String cmcCBMMetaUpdatedate = 'cmcCBMMetaUpdatedate';
  // static String cmcALMMetaUpdatedate = 'cmcALMMetaUpdatedate';
  // static String cmcCCMetaUpdatedate = 'cmcCCMetaUpdatedate';
  static String cashbookExpencesMetaUpdateDate =
      'cashbookExpencesMetaUpdateDate';
  static String cashbookRecieptMetaUpdateDate = 'cashbookRecieptMetaUpdateDate';
  static String villageProfileUpdateDate = 'villageProfile';
  static String chechInUpdateDate = 'ChechInUpdateDate';
  static String stockmetaUpdateDate = "stockmetaUpdateDate";
  static String requisitionMetaUpdateDate = "requisitionMetaUpdateDate";

//

  static String qizeFilterComon = '@#@';

  validateemail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter Your User Id';
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

  validatecontactName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter Your User Id';
    }
    return null;
  }

  validateMobileNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter Your Mobile no.';
    }
    if (value.trim().length < 10) {
      return 'Mobile must be at least 10 digits';
    }
    return null;
  }

  // Future<String> getStringSharedSaved(
  //     SharedPreferences prefe, String key) async {
  //   var sValue = prefe.getString(key);
  //   var sUUIDNUMBER = prefe.getString(Validate.sUUIDNUMBER);
  //   var fValue = AESEncryption.decrypt(sValue!,sUUIDNUMBER!);
  //   return fValue;
  // }

  validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'enter your password';
    }
    if (value.trim().length < 8) {
      return "Password must be at least 8 Numbers in length";
    }
    return null;
  }

  void saveString(String key, String value) async {
    SharedPreferences field = await SharedPreferences.getInstance();
    field.setString(key, value);
  }

  Future<String?> readString(String key) async {
    SharedPreferences field = await SharedPreferences.getInstance();
    return field.getString(key);
  }

  void saveInt(String key, int value) async {
    SharedPreferences field = await SharedPreferences.getInstance();
    field.setInt(key, value);
  }

  Future<int?> readInt(String key) async {
    SharedPreferences field = await SharedPreferences.getInstance();
    return field.getInt(key);
  }

  void saveBoolean(String key, bool value) async {
    SharedPreferences field = await SharedPreferences.getInstance();
    field.setBool(key, value);
  }

  Future<bool?> readBoolean(String key) async {
    SharedPreferences field = await SharedPreferences.getInstance();
    return field.getBool(key);
  }

  String randomGuid() {
    const ch = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz0123456789';
    Random r = Random();
    String rnNumber = String.fromCharCodes(
        Iterable.generate(24, (_) => ch.codeUnitAt(r.nextInt(ch.length))));
    rnNumber = rnNumber + (DateTime.now().millisecondsSinceEpoch).toString();
    print("created $rnNumber");
    return rnNumber;
  }

  String currentDateTime() {
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd HH:mm:ss');
    return formatter.format(now);
  }

  String createAtToCurrentDate(String? date) {
    if (date != null) {
      DateTime parsedDate = DateFormat('yyyy-MM-dd HH:mm:ss').parse(date);
      var formatter = new DateFormat('yyyy-MM-dd');
      DateTime item =
          DateTime(parsedDate.year, parsedDate.month, DateTime.now().day);
      return formatter.format(item);
    } else {
      var formatter = new DateFormat('yyyy-MM-dd');
      return formatter.format(DateTime.now());
    }
  }

  String autoCrecheCareGiverCode(String code) {
    int randomNumber = 1000 + Random().nextInt(9000);
    return '$code$randomNumber';
  }

  int currentDateTimeMillisecoud() {
    var now = new DateTime.now();
    return now.millisecondsSinceEpoch;
  }

  String currentDate() {
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    return formatter.format(now);
  }

  String changeDateFomate(
      String currentFormate, String changeFomate, String date) {
    DateTime tempDate = new DateFormat(currentFormate).parse(date);
    var formatter = new DateFormat(changeFomate);
    return formatter.format(tempDate);
  }

  Future<bool> checkNetworkConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi));
  }

  // Future<bool> checkInternetConnectivity() async {
  //   var connectivityResult = await Connectivity().checkConnectivity();
  //   return connectivityResult != ConnectivityResult.none;
  // }

  // void showNoInternetAlert() {
  //   Fluttertoast.showToast(
  //     msg: 'No internet connection available',
  //     toastLength: Toast.LENGTH_SHORT,
  //     gravity: ToastGravity.BOTTOM,
  //     timeInSecForIosWeb: 1,
  //     backgroundColor: Colors.red,
  //     textColor: Colors.white,
  //     fontSize: 16.0,
  //   );
  // }

  void singleButtonPopup(
      String msg, String button, bool isBack, BuildContext context) async {
    bool shouldProceed = await showDialog(
      context: context,
      builder: (context) {
        return SingleButtonPopupDialog(message: msg, button: button);
      },
    );
    if (isBack) {
      if (shouldProceed == true) {
        Navigator.pop(context);
      }
    }
  }

  Map<String, dynamic> keyesFromResponce(Map<String, dynamic> responce) {
    List<String> removedItem = [];
    removedItem.add('docstatus');
    removedItem.add('doctype');
    removedItem.add('idx');
    removedItem.add('modified');
    removedItem.add('modified_by');
    removedItem.add('creation');
    removedItem.forEach((element) {
      if (responce[element] != null) {
        responce.remove(element);
      }
    });
    return responce;
  }

  Map<String, dynamic> detailFromResponse(Map<String, dynamic> response) {
    List<String> removedItem = [];
    removedItem.add('creche_id');
    removedItem.add('date_of_enrollment');
    removedItem.add('height');
    removedItem.add('name');
    removedItem.add('weight');
    removedItem.add('childenrollguid');
    removedItem.forEach((element) {
      if (response[element] != null) {
        response.remove(element);
      }
    });
    return response;
  }

  Map<String, dynamic> addCrecheInfor(Map<String, dynamic> response) {
    List<String> locationItem = [
      'state_id',
      'district_id',
      'block_id',
      'gp_id',
      'village_id'
    ];
    response.forEach((key, value) {
      if (!locationItem.contains(key)) {
        response.remove(key);
      }
    });
    return response;
  }

  // String convertDateFormat(String inputDate) {
  //   // DateFormat originalFormat = DateFormat('dd-MM-yyyy');
  //   // DateFormat newFormat = DateFormat('yyyy-MM-dd');
  //   //
  //   // DateTime dateTime = originalFormat.parse(inputDate);
  //   // String formattedDate = newFormat.format(dateTime);
  //     DateTime originalFormat = DateFormat('dd-MM-yyyy').parse(inputDate);
  //     String newFormat = DateFormat('yyyy-MM-dd').format(originalFormat);
  //
  //   // DateTime dateTime = originalFormat.parse(inputDate);
  //   // String formattedDate = newFormat.format(dateTime);
  //
  //   return newFormat;
  // }

  String displeDateFormateMM(String inputDate) {
    DateTime originalFormat = DateFormat('yyyy-MM-dd').parse(inputDate);
    String newFormat = DateFormat('dd-MM-yyyy').format(originalFormat);
    return newFormat;
  }

  String displeDateFormate(String? inputDate) {
    String result = '';
    if (inputDate != null) {
      DateTime originalFormat = DateFormat('yyyy-MM-dd').parse(inputDate);
      String newFormat = DateFormat('dd-MMM-yyyy').format(originalFormat);
      result = newFormat;
    }
    return result;
  }

  String displeDateFormateMobileDateTimeFormate(String inputDate) {
    DateTime originalFormat =
        DateFormat('yyyy-MM-dd HH:mm:ss').parse(inputDate);
    String newFormat =
        DateFormat('dd-MMM-yyyy HH:mm:ss').format(originalFormat);
    return newFormat;
  }

  DateTime stringToDate(String inputDate) {
    DateTime dateTime = DateTime.now();
    try {
      DateFormat originalFormat = DateFormat('yyyy-MM-dd');
      dateTime = originalFormat.parse(inputDate);
    } catch (e) {
      print(e);
    }

    return dateTime;
  }

  DateTime? stringToDateNull(String inputDate) {
    DateTime? dateTime;
    try {
      DateFormat originalFormat = DateFormat('yyyy-MM-dd');
      dateTime = originalFormat.parse(inputDate);
    } catch (e) {
      print(e);
    }
    return dateTime;
  }

  // String convertDate(String inputDate) {
  //   // DateFormat originalFormat = DateFormat('yyyy-MM-dd');
  //   // DateFormat newFormat = DateFormat('dd-MM-yyyy');
  //   //
  //   // DateTime dateTime = originalFormat.parse(inputDate);
  //   // String formattedDate = newFormat.format(dateTime);
  //   DateTime originalFormat = DateFormat('yyyy-MM-dd').parse(inputDate);
  //   String newFormat = DateFormat('dd-MM-yyyy').format(originalFormat);
  //
  //   return newFormat;
  // }

  int calculateAgeInMonths(DateTime birthDate) {
    final now = DateTime.now();
    int ageInMonths =
        (now.year - birthDate.year) * 12 + now.month - birthDate.month;
    if (now.day < birthDate.day) {
      ageInMonths--;
    }
    return ageInMonths;
  }

  int calculateAgeInMonthsDepenExp(DateTime birthDate, DateTime conmarDate) {
    int ageInMonths = (conmarDate.year - birthDate.year) * 12 +
        conmarDate.month -
        birthDate.month;
    if (conmarDate.day < birthDate.day) {
      ageInMonths--;
    }
    return ageInMonths;
  }

  int calculateAgeInMonthEnrolled(DateTime birthDate) {
    final now = DateTime.now();
    int ageInMonths =
        (now.year - birthDate.year) * 12 + now.month - birthDate.month;
    // if (now.day > birthDate.day) {
    //   ageInMonths++;
    // }
    return ageInMonths;
  }

  int calculateAgeInYear(DateTime birthDate) {
    final now = DateTime.now();
    int ageInYears = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      ageInYears--;
    }
    return ageInYears;
  }

  int calculateAgeInYearDepenExp(DateTime birthDate, DateTime conmarDate) {
    int ageInYears = conmarDate.year - birthDate.year;
    if (conmarDate.month < birthDate.month ||
        (conmarDate.month == birthDate.month &&
            conmarDate.day < birthDate.day)) {
      ageInYears--;
    }
    return ageInYears;
  }

  int calculateAgeInDays(DateTime birthDate) {
    final now = DateTime.now();
    final difference = now.difference(birthDate);
    final ageInDays = difference.inDays;
    return ageInDays;
  }

  int calculateAgeInDaysEx(DateTime birthDate, DateTime conmarDate) {
    final difference = conmarDate.difference(birthDate);
    final ageInDays = difference.inDays;
    return ageInDays;
  }

  Future<String> imageFileToBase64(String imagePath) async {
    File imageFile = File(imagePath);
    List<int> imageBytes = await imageFile.readAsBytes();
    String base64Image = base64Encode(imageBytes);
    return base64Image;
  }

  Future<Uint8List> imageFileToUint8List(String imagePath) async {
    File imageFile = File(imagePath);
    return await imageFile.readAsBytes();
    // String base64Image = base64Encode(imageBytes);
    // return base64Image;
  }

  Future<Uint8List> imageBase64Toimage(String imagePath) async {
    Uint8List bytes = base64Decode(imagePath);
    return bytes;
  }

  Future<String> getAddressFromLatLng(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      Placemark place = placemarks.first;
      print(place);
      // You can access various properties of the Placemark object to get address details
      print(
          'Address: ${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}');
      return '${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}';
    } catch (e) {
      print('Error: $e');
      return '';
    }
  }

  int calculateDaysInMonths(DateTime currentDate, int months) {
    // DateTime currentDate=DateTime.now();
    int year = currentDate.year;
    int month = currentDate.month;
    int totalDays = 0;

    for (int i = 0; i < months; i++) {
      int daysInMonth = getDaysInMonth(year, month);
      totalDays += daysInMonth;

      // Move to the next month
      month++;
      if (month > 12) {
        month = 1; // Reset to January
        year++; // Move to the next year
      }
    }

    return totalDays;
  }

  int getDaysInMonth(int year, int month) {
    if (month == 2) {
      // February: check for leap year
      if ((year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)) {
        return 29; // Leap year
      } else {
        return 28; // Non-leap year
      }
    } else if ([4, 6, 9, 11].contains(month)) {
      return 30; // April, June, September, November
    } else {
      return 31; // All other months
    }
  }

  TimeOfDay? stringToTimeOfDay(String? time) {
    if (time != null) {
      DateTime parsedTime = DateFormat.jm().parse(time);
      return TimeOfDay.fromDateTime(parsedTime);
      // return TimeOfDay(hour:int.parse(time.split(":")[0]),minute: int.parse(time.split(":")[1]));
    } else
      TimeOfDay.now();
  }

  Future<void> shareFile(File filePath) async {
    try {
      // Ensure the file exists
      if (await filePath.exists()) {
        // Share the image file using share_plus
        await Share.shareXFiles([XFile('${filePath.path}')],
            text:
                'Database Db ${Validate().currentDateTime()}' // You can specify the mime type if needed
            );
      } else {
        print('file file not found at $filePath');
      }
    } catch (e) {
      print('file sharing image: ${e.toString()}');
    }
  }

  Future<void> createDbBackup() async {
    try {
      // Get the path to the database
      String databasePath = join(await getDatabasesPath(), 'sishughar.db');

      // Get the directory where you want to store the backup
      Directory databaseDir = Directory(Constants.databaseFile);

      // Check if the directory exists, if not, create it
      if (!await databaseDir.exists()) {
        await databaseDir.create(recursive: true);
      }

      // Construct the backup file path inside the directory
      String backupFilePath = join(databaseDir.path, 'sishughar.db');

      // Create the backup by copying the database file
      File databaseFile = File(databasePath);

      if (await databaseFile.exists()) {
        await databaseFile.copy(backupFilePath);
        print('Backup created and saved successfully at $backupFilePath');
        shareFile(File(
            backupFilePath)); // Assuming shareFile is your method to share the file
      } else {
        print('Database file not found at $databasePath');
      }
    } catch (e) {
      print('Error creating backup: ${e.toString()}');
    }
  }

  Future<void> createUploadedJson(String testData) async {
    try {
      var databaseDir = Directory('${Constants.uploadeJsonFile}');

      // Ensure the directory exists
      if (!await databaseDir.exists()) {
        await databaseDir.create(recursive: true);
      }

      // Generate the file path
      String dataFilePath = join(databaseDir.path, 'json_.txt');

      // Create the file and write data to it
      File file = File(dataFilePath);
      await file.writeAsString(testData);

      if (await file.exists()) {
        print('File created and JSON data written successfully at $file');
        // shareFile(file);
      } else {
        print('File file not found at $file');
      }
    } catch (e) {
      print('Error creating backup: ${e.toString()}');
    }
  }
}
