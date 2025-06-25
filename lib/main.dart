import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:intl/intl.dart';
import 'package:shishughar/firebase_options.dart';
import 'package:shishughar/screens/splashScreen.dart';
import 'package:shishughar/screens/synchronization_screen_new.dart';
import 'package:shishughar/screens/tabed_screens/anthrometory/child_growth_listing_screen.dart';
import 'package:shishughar/screens/tabed_screens/attendence/attendance_listed_screen.dart';
import 'package:shishughar/screens/tabed_screens/child_follow_up/follow_up_tab_screen_all_child.dart';
import 'package:shishughar/screens/tabed_screens/child_reffrel/reffral_tab_screen.dart';
import 'package:shishughar/utils/globle_method.dart';
import 'package:shishughar/utils/notification_service.dart';
import 'package:shishughar/utils/validate.dart';
import 'package:workmanager/workmanager.dart';
import 'custom_widget/custom_text.dart';
import 'database/database_helper.dart';
import 'database/helper/anthromentory/child_growth_response_helper.dart';
import 'database/helper/cashbook/expences/cashbook_response_expences_helper.dart';
import 'database/helper/cashbook/receipt/cashbook_receipt_response_helper.dart';
import 'database/helper/check_in/check_in_response_helper.dart';
import 'database/helper/child_attendence/child_attendance_helper_responce.dart';
import 'database/helper/child_attendence/child_attendence_helper.dart';
import 'database/helper/child_event/child_event_response_helper.dart';
import 'database/helper/child_exit/child_exit_response_Helper.dart';
import 'database/helper/child_gravience/child_grievances_response_helper.dart';
import 'database/helper/child_health/child_health_response_helper.dart';
import 'database/helper/child_immunization/child_immunization_response_helper.dart';
import 'database/helper/child_reffrel/child_refferal_response_helper.dart';
import 'database/helper/creche_comite_meeting/creche_committie_response_helper.dart';
import 'database/helper/creche_helper/creche_data_helper.dart';
import 'database/helper/creche_monitoring/creche_monitoring_response_helper.dart';
import 'database/helper/dynamic_screen_helper/house_hold_tab_responce.dart';
import 'database/helper/enrolled_exit_child/enrolled_exit_child_responce_helper.dart';
import 'database/helper/follow_up/child_followUp_response_helper.dart';
import 'database/helper/image_file_tab_responce_helper.dart';
import 'database/helper/requisition/requisition_response_helper.dart';
import 'database/helper/stock/stock_response_helper.dart';
import 'database/helper/village_profile/village_profile_response_helper.dart';
import 'utils/notification_service.dart';

// @pragma('vm:entry-point')
// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) async {
//     try {
//       print("workManager success task");
//     await checkConditionAndNotify();
//     return true;
//     } catch (e) {
//       print("workManager $e");
//       return false;
//     }
//   });
// }

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    print("Workmanager BG: callbackDispatcher started for task '$task'.");

    // Crucial: Initialize services needed for the background task.
    // WidgetsFlutterBinding.ensureInitialized(); // May not always be needed, but good for some plugins.
    try {
      print("Workmanager BG: Firebase initialized.");

      // Initialize your DatabaseHelper. Adjust if it's a singleton or has a specific init pattern.
      var dataBaseHelper = DatabaseHelper();
      await dataBaseHelper.openDb();
      print("Workmanager BG: Database initialized.");

      // Initialize NotificationService if it requires setup for background.
      // Some notification services initialize themselves when first used.
      // await NotificationService.init(); // If you have an init method
    } catch (e, stack) {
      print(
          "Workmanager BG: ERROR during background initialization: $e\n$stack");
      // Optionally record to Crashlytics
      // await FirebaseCrashlytics.instance.recordError(e, stack, information: ['Background Init Failed']);
      return Future.value(false); // Indicate failure
    }

    try {
      print(
          "Workmanager BG: Executing checkConditionAndNotify for task '$task'.");
      await checkConditionAndNotify();
      print(
          "Workmanager BG: Task '$task' completed via checkConditionAndNotify.");
      return Future.value(true);
    } catch (e, stack) {
      print(
          "Workmanager BG: ERROR executing task '$task' in checkConditionAndNotify: $e\n$stack");
      // Optionally record to Crashlytics
      // await FirebaseCrashlytics.instance.recordError(e, stack, information: ['Background Task Execution Failed']);
      return Future.value(false); // Indicate failure
    }
  });
}
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var dataBaseHelper = DatabaseHelper();
  await dataBaseHelper.openDb();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  final notificationAppLaunchDetails =
  await FlutterLocalNotificationsPlugin().getNotificationAppLaunchDetails();

  String? initialPayload = notificationAppLaunchDetails?.notificationResponse?.payload;
  var anthroItems = await ChildGrowthResponseHelper().excuteIsNotSubmitedDate();
  print("checkWorondition $anthroItems");
  if (Platform.isAndroid) {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    if (androidInfo.version.sdkInt >= 33) {
      var isEnable=await NotificationService.checkAndroidNotificationPermission();
          if(!isEnable){
            NotificationService.requestPermission();
          }
    }
  }
  await NotificationService.initialize((payload) {
    if (payload != null && payload.isNotEmpty) {
      if(Global.validString(payload)){
        var item=jsonDecode(payload);
        switch(item['type']){
          case 'Upload data':
            navigatorKey.currentState?.pushNamed('/upload_data');
            break;
          case 'Child Referral':
            navigatorKey.currentState?.pushNamed('/red_flag_screen');
            break;
            case 'Child Attendance':
            navigatorKey.currentState?.pushNamed('/attendance' ,arguments: {
            'creche_id': item['creche_id'],
            'creche_name': item['creche_name'],
            },);
            break;
          case 'Growth Monitoring':
            navigatorKey.currentState?.pushNamed('/growth_Monitoring',arguments: {
              'creche_id': item['creche_id'],
              'creche_name': item['creche_name'],
            });
            break;
          case 'Follow up':
            navigatorKey.currentState?.pushNamed('/follow_up');
            break;
          default:'';
        }


      }
    }
  });
  await initWorkManager();
  await Workmanager().registerPeriodicTask(
    "twelveHourCheck",
    "conditionCheck",
    frequency: const Duration(minutes: 16),
    initialDelay: const Duration(minutes: 1), // First check after 10 seconds
    constraints: Constraints(
      networkType: NetworkType.not_required,
    ),
  );

  runApp( MyApp(payload:initialPayload));
}

Future<void> initWorkManager() async {
  await Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: false,
  );
}

Future<Map<String, dynamic>> checkCondition() async {
  Map<String, dynamic> notiItems = {};
  var pendindTaskCount = await callCountForUpload();
  var role = await Validate().readString(Validate.role);
  if (pendindTaskCount > 0) {
    Map<String, String> body = {};
    body['message']= 'You have completed $pendindTaskCount records for upload. Please upload now.';
    body['type']=CustomText.uploadData;
    notiItems[CustomText.uploadData] =body;
  }
  if(role== CustomText.crecheSupervisor){
  var attendenceItem = await ChildAttendenceHelper().excuteIsNotSubmitedDate();
  var anthroItems = await ChildGrowthResponseHelper().excuteIsNotSubmitedDate();
  var reffralItems = await excuteReffralItems();
  var followupsItes =  await ChildFollowUpTabResponseHelper().allChildSchduledFollowp();

  if (attendenceItem.isNotEmpty) {

    var date = attendenceItem.first['min_of_max_dates'];
    var crecheName =Global.getItemValues(attendenceItem.first['responces'], 'creche_name');
    if (Global.validString(date) && Global.validString(crecheName)) {
      Map<String, String> body = {};
      body['creche_id']=attendenceItem.first['creche_id'].toString();
      body['creche_name']=crecheName;
      body['type']=CustomText.childAttendance;
      body['message']= 'You have not submitted attendance of child at ${crecheName} creche after $date.';
      notiItems[CustomText.childAttendance] =body;
    }
  }
  if (anthroItems.isNotEmpty) {
    var date = anthroItems.first['min_of_max_months'];
    var crecheName =Global.getItemValues(anthroItems.first['responces'], 'creche_name');
    if (Global.validString(date)&& Global.validString(crecheName)) {
      Map<String, String> body = {};
      body['creche_id']=anthroItems.first['creche_id'].toString();
      body['creche_name']=crecheName;
      body['type']=CustomText.GrowthMonitoring;
      body['message']= 'You have not submitted growth monitoring of child a ${crecheName} creche after $date.';
      notiItems[CustomText.GrowthMonitoring] =body;
    }
  }
  if (reffralItems.isNotEmpty) {
    Map<String, String> body = {};
    body['message']= 'Red flag child visit is pending. Please complete and sync.';
    body['type']=CustomText.ChildReffrel;
    notiItems[CustomText.ChildReffrel] =body;
  }
  if (followupsItes.isNotEmpty) {
    Map<String, String> body = {};
    body['message']='Child follow up visit is pending. Please complete and sync.';
    body['type']=CustomText.fllowUp;
    notiItems[CustomText.fllowUp] =body;

  }
  }
  return notiItems;
}

Future<int> callCountForUpload() async {
  var hhItems = await HouseHoldTabResponceHelper().getHouseHoldItems();
  var crecheProfile = await CrecheDataHelper().callCrecheForUpload();
  var chilAttendence =
      await ChildAttendanceResponceHelper().callChildAttendencesAllForUpoad();
  var crecheCheckIn =
      await CheckInResponseHelper().callCrecheCheckInResponses();
  var anthropomentry =
      await ChildGrowthResponseHelper().callChildGrowthResponsesForUpload();
  var childeventResponses =
      await ChildEventTabResponceHelper().getEditedChildEventsForUpload();
  var childImmunizationDAta =
      await ChildImmunizationResponseHelper().getChildImmunizationForUpload();
  var childHeathData =
      await ChildHealthTabResponceHelper().getChildHealthForUpload();
  var childexitdata =
      await ChildExitResponceHelper().getEditedChildExitForUpload();
  var grievanceData =
      await ChildGrievancesTabResponceHelper().getChildGrievanceForUpload();
  var creCheMonitoring =
      await CrecheMonitorResponseHelper().getCrecheResponseForUpload();
  var referralData =
      await ChildReferralTabResponseHelper().getChildReferralForUpload();
  var followUpData =
      await ChildFollowUpTabResponseHelper().getChildFollowUpForUpload();
  var ccmData =
      await CrecheCommittieResponnseHelper().getCrecheCommittieForUpload();
  var cashBookDataExpences = await CashBookResponseExpencesHelper()
      .getEditedCashBookForExpenceUpload();
  var stockData = await StockResponseHelper().getStockForUpload();
  var requisitionData =
      await RequisitionResponseHelper().getRequisitonsForUpload();
  var cashBookDataReciept =
      await CashBookReceiptResponseHelper().getEditedCashBookReceiptForUpload();
  var villageProfiles =
      await VillageProfileResponseHelper().getVillageProfileforUpload();
  var ImageFileData = await ImageFileTabHelper().getImageForUpload();
  var childEnrollExitData =
      await EnrolledExitChilrenResponceHelper().callChildrenForUpload();
  hhItems = hhItems
      .where((element) =>
          Global.stringToInt(
              Global.getItemValues(element.responces!, 'verification_status')) >
          1)
      .toList();

  int totalPendingCount = hhItems.length +
      crecheProfile.length +
      chilAttendence.length +
      crecheCheckIn.length +
      anthropomentry.length +
      childeventResponses.length +
      childImmunizationDAta.length +
      childHeathData.length +
      childexitdata.length +
      grievanceData.length +
      creCheMonitoring.length +
      referralData.length +
      followUpData.length +
      ccmData.length +
      cashBookDataExpences.length +
      ImageFileData.length +
      villageProfiles.length +
      cashBookDataReciept.length +
      childEnrollExitData.length +
      stockData.length +
      requisitionData.length;

  return totalPendingCount;
}

Future<Map<String, dynamic>> excuteReffralItems() async {
  var childAnthro = await ChildGrowthResponseHelper().allAnthormentryDisableOCT();
  Map<String, dynamic> growthGuidByDate = {};
  List<String> childrenIdList = [];
  if (childAnthro.isEmpty) {
    throw ArgumentError('The list of objects cannot be empty.');
  }

  Map<String, dynamic> allAnthroWithChild = {};
  childAnthro.forEach((element) {
    allAnthroWithChild[
    Global.getItemValues(element.responces!, 'measurement_date')] =
    jsonDecode(element.responces!)['anthropromatic_details'];
  });
  DateFormat dateFormat = DateFormat('yyyy-MM-dd');

  // Sort the entries by date keys
  List<MapEntry<String, dynamic>> sortedEntries = allAnthroWithChild.entries
      .toList()
    ..sort((e1, e2) =>
        dateFormat.parse(e1.key).compareTo(dateFormat.parse(e2.key)));

  // Create a new map from the sorted entries
  Map<String, dynamic> sortedMap = Map.fromEntries(sortedEntries);
  Map<String, dynamic> childWith = {};
  sortedMap.forEach((key, value) {
    List<dynamic> childItem = value as List<dynamic>;
    childItem.forEach((element) {
      if (Global.stringToDouble(element['weight_for_height'].toString()) ==
          1 ||
          // Global.stringToDouble(element['weight_for_height'].toString()) ==
          //     2 ||
          Global.stringToInt(
              element['any_medical_major_illness'].toString()) ==
              1 ||
          Global.stringToDouble(element['weight_for_age'].toString()) == 1) {
        Map<String, dynamic> growthData = {};
        growthData['childenrollguid'] = element['childenrollguid'];
        growthData['cgmguid'] = element['cgmguid'];
        growthData['measurement_taken_date'] =
        element['measurement_taken_date'];
        childWith['$key#!${element['childenrollguid']}'] = growthData;
      }
    });
  });
  childWith.forEach((key, value) {
    var enrolChilGUID = value['childenrollguid'];
    childrenIdList.add(enrolChilGUID);
    growthGuidByDate[key] = value;
  });

  print("final child $childWith");
  var enrolledChildrenList = await EnrolledExitChilrenResponceHelper()
      .callEnrollChildrenforByMultiEnrollGuid(childrenIdList);

  var reffrelChildrenList =
  await ChildReferralTabResponseHelper().callAllReffralsWithoutExit();

  List<String> tempFoeRemove = [];
  growthGuidByDate.forEach((key, value) {
    var enrolledGUID = value['childenrollguid'];
    var cgmguid = value['cgmguid'];
    var filterItem = reffrelChildrenList
        .where((element) => (element.childenrolledguid == enrolledGUID &&
        element.cgmguid == cgmguid))
        .toList();
    if (filterItem.length > 0) {
      tempFoeRemove.add(key);
    } else {
      var extedItem = enrolledChildrenList
          .where((element) => (element.ChildEnrollGUID == enrolledGUID &&
          Global.validString(element.date_of_exit)))
          .toList();
      if (extedItem.length > 0) {
        tempFoeRemove.add(key);
      }
    }
  });
  tempFoeRemove.forEach((element) {
    growthGuidByDate.remove(element);
  });
  return growthGuidByDate;

}



Future<void> checkConditionAndNotify() async {
  var items = await checkCondition();
  if (items.isNotEmpty) {

    for (var entry in items.entries) {
      await NotificationService.showNotification(
        title: entry.key,
        body: entry.value['message'] ?? "No details available",payload: jsonEncode(entry.value),
      );
    }
  }
}

class MyApp extends StatelessWidget {
   MyApp({super.key,this.payload});
  String? payload;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(375, 640),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Shishu Ghar',
            navigatorKey: navigatorKey,
            theme: ThemeData(
              scaffoldBackgroundColor: Colors.white,
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: UpdateCheckScreen(payload:payload),
    onGenerateRoute: (RouteSettings settings) {
    switch (settings.name) {
      case '/splash':
        return MaterialPageRoute(builder: (_) => SplashScreen(payload: payload));
      case '/upload_data':
        return MaterialPageRoute(builder: (_) => const SynchronizationScreenNew());
      case '/red_flag_screen':
        return MaterialPageRoute(builder: (_) =>  ReffralTabScreen(
          tabTitle: CustomText.FlaggedChilderen,
        ));
      case '/follow_up':
        return MaterialPageRoute(builder: (_) =>  FollowUpTabScreenAllChild(
          tabTitle: CustomText.fllowUp,
          tabOneTitle: CustomText.schduleDate,
          tabTwoTitle: CustomText.complted,
        ));
      case '/attendance':
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => AttendanceListedScreen(
            creche_nameId: Global.stringToInt(args['creche_id']),
            creche_name: args['creche_name'],
          ),
        );
      case '/growth_Monitoring':
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => ChildGrowthListingScreen(
            creche_nameId:  Global.stringToInt(args['creche_id']),
            creche_name: args['creche_name'],
          ),
        );
      default:
        return MaterialPageRoute(builder: (_) =>  SplashScreen());
    }


            },
            // home: CoordinatorLocationScreen()
          );
        });
  }
}

class UpdateCheckScreen extends StatefulWidget {

  UpdateCheckScreen(
      {super.key, this.payload});
  String? payload;
  @override
  _UpdateCheckScreenState createState() => _UpdateCheckScreenState();
}

class _UpdateCheckScreenState extends State<UpdateCheckScreen> {
  @override
  void initState() {
    super.initState();
    _checkForUpdate();
  }

  Future<void> _checkForUpdate() async {
    try {
      AppUpdateInfo updateInfo = await InAppUpdate.checkForUpdate();
      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        _showUpdateDialog();
      }else{
        _navigateToSplashScreen();
      }
    } catch (e) {
      print('Error checking for update: $e');
      _navigateToSplashScreen(); // Proceed to splash screen in case of an error
    }
  }

  void _showUpdateDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      // Prevent dismissing by tapping outside the dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Available'),
          content: Text(
              'A new version of the app is available. Please update to the latest version.'),
          actions: <Widget>[
            // TextButton(
            //   onPressed: () {
            //     Navigator.of(context).pop();
            //     _navigateToSplashScreen();
            //   },
            //   child: Text('Cancel'),
            // ),
            TextButton(
              onPressed: () {
                _performImmediateUpdate();
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _performImmediateUpdate() {
    InAppUpdate.performImmediateUpdate().catchError((e) {
      print('Error performing immediate update: $e');
    });
  }

  void _navigateToSplashScreen() {
    Navigator.pushReplacementNamed(context, '/splash');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
