import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shishughar/custom_widget/custom_text.dart';
import 'package:shishughar/database/helper/translation_language_helper.dart';
import 'package:shishughar/model/apimodel/translation_language_api_model.dart';
import 'package:shishughar/utils/globle_method.dart';
import 'package:shishughar/utils/validate.dart';

class GetLocation {
  Future<Map<String, String>> checkLocationPermission(
      BuildContext context) async {
    if (await _hasLocationPermission()) {
      return await _requestServiceEnable(context);
    } else {
      return await _requestPermission(context);
    }
  }

  Future<bool> _hasLocationPermission() async {
    return await Permission.location.status.isGranted;
  }

  Future<Map<String, String>> _requestPermission(BuildContext context) async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      return await _requestServiceEnable(context);
    } else {
      await _showPermissionDialog(context, 1);
      return {};
    }
  }

  Future<void> _showPermissionDialog(BuildContext context, int type) async {
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
    if (shouldProceed) {
      if (type == 1)
        await _requestPermission(context);
      else {
        final location = Location();
        await _locationpermission(location);
      }
    }
  }

  Future<void> _locationpermission(Location location) async {
    if (await location.serviceEnabled()) {
      await _savingLovation(location);
    } else {
      final serviceEnabled = await location.requestService();
      if (serviceEnabled) {
        await _savingLovation(location);
      }
    }
  }

  Future<void> cachingCurrentLocationn(BuildContext context) async {
    final location = Location();
    if (await _hasLocationPermission()) {
      await _locationpermission(location);
    } else {
      final status = await Permission.location.request();
      if (status.isGranted) {
        await _locationpermission(location);
      } else {
        await _showPermissionDialog(context, 0);
      }
    }
  }

  Future<void> _savingLovation(Location location) async {
    try {
      final currentLocation = await location.getLocation();
      var address = await Validate().getAddressFromLatLng(
          currentLocation.latitude!, currentLocation.longitude!);
      Validate()
          .saveString(Validate.latitude, currentLocation.latitude.toString());
      Validate()
          .saveString(Validate.longitude, currentLocation.longitude.toString());
      Validate().saveString(Validate.address, address);
    } catch (e) {
      print("Error fetching Location: $e");
    }
  }

  Future<Map<String, String>> _requestServiceEnable(
      BuildContext context) async {
    final location = Location();
    if (await location.serviceEnabled()) {
      return await _getLocation(context);
    } else {
      final serviceEnabled = await location.requestService();
      if (serviceEnabled) {
        return await _getLocation(context);
      } else {
        return {};
      }
    }
  }

  Future<Map<String, String>> _getLocation(BuildContext context) async {
    final location = Location();
    final translats = await _getTranslations();
    final lng = await Validate().readString(Validate.sLanguage);
    try {
      showLoaderDialog(context, translats, lng);
      final currentLocation = await location.getLocation();
      final address = await Validate().getAddressFromLatLng(
          currentLocation.latitude!, currentLocation.longitude!);
      // Navigator.pop(context);
      return {
        'lats': '${currentLocation.latitude}',
        'langs': '${currentLocation.longitude}',
        'address': address,
      };
    } catch (e) {
      print('Error getting location: $e');
      return {};
    } finally {
      Navigator.pop(context);
    }
  }

  Future<List<Translation>> _getTranslations() async {
    final valueName = [CustomText.pleaseWait];
    // final lng = await Validate().readString(Validate.sLanguage);
    return await TranslationDataHelper().callTranslateString(valueName);
  }

  void showLoaderDialog(
      BuildContext context, List<Translation> translats, String? lng) {
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
        });
  }
}
