import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shishughar/utils/validate.dart';

import '../custom_widget/custom_btn.dart';
import '../custom_widget/custom_text.dart';
import '../custom_widget/label_value_row.dart';
import '../database/helper/translation_language_helper.dart';
import '../model/apimodel/translation_language_api_model.dart';
import '../style/styles.dart';
import 'globle_method.dart';

class LocationAccuracyWithDistanceDialog extends StatefulWidget {
  final Function(double lat, double lng, String address) onLocationResult;
  final double targetLat;
  final double targetLng;
  final double maxAllowedDistance;

  const LocationAccuracyWithDistanceDialog({
    super.key,
    required this.onLocationResult,
    required this.targetLat,
    required this.targetLng,
    required this.maxAllowedDistance,
  });

  @override
  State<LocationAccuracyWithDistanceDialog> createState() =>
      _LocationAccuracyWithDistanceDialogState();
}

class _LocationAccuracyWithDistanceDialogState
    extends State<LocationAccuracyWithDistanceDialog> {
  double? bestAccuracy;
  Position? bestPosition;
  Timer? timer;
  StreamSubscription<Position>? positionSubscription;
  int elapsedSeconds = 0;
  double? currentDistance;
  List<Translation> translats = [];
  String lng = 'en';

  @override
  void initState() {
    super.initState();
    checkPermissionAndStart();
  }

  Future<void> checkPermissionAndStart() async {

    lng = await Validate().readString(Validate.sLanguage)??'en';
    List<String> valueItems = [
    CustomText.Save,
    CustomText.Cancel,
    CustomText.Elapsed,
    CustomText.Accuracy,
    CustomText.LatLng,
    CustomText.Distance,
    CustomText.WithinAllowedRange,
    CustomText.TooFar,
    CustomText.NotAllowedWithInRange,
    CustomText.gettingLocationWithAccuracy,
    ];
    await TranslationDataHelper()
        .callTranslateString(valueItems)
        .then((value) => translats.addAll(value));


    var status = await Permission.location.request();
    if (status.isGranted) {
      startGettingLocation();
    } else {
      if (mounted) Navigator.pop(context);
    }
  }

  void startGettingLocation() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() => elapsedSeconds++);
      }
    });

    positionSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 0,
      ),
    ).listen((position) {
      if (!mounted) return;

      setState(() {
        if (bestAccuracy == null || position.accuracy < bestAccuracy!) {
          bestAccuracy = position.accuracy;
          bestPosition = position;
          currentDistance = Geolocator.distanceBetween(
            widget.targetLat,
            widget.targetLng,
            position.latitude,
            position.longitude,
          );
        }
      });
    });
  }

  void stop() {
    timer?.cancel();
    positionSubscription?.cancel();
  }

  @override
  void dispose() {
    stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String elapsedText =
        "${(elapsedSeconds ~/ 60).toString().padLeft(2, '0')}:${(elapsedSeconds % 60).toString().padLeft(2, '0')}";

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      contentPadding: EdgeInsets.zero,
      content: Container(
          width: MediaQuery.of(context).size.width * 5.00,
          // height: MediaQuery.of(context).size.height * 0.2,
          child:
          IntrinsicHeight(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    height: 40,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Color(0xff5979AA),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5.0),
                        topRight: Radius.circular(5.0),
                      ),
                    ),
                    child: Center(
                        child:
                        Text(CustomText.SHISHUGHAR, style: Styles.white126P)),
                  ),
                  SizedBox(height: 10,),
                  Text(
                    Global.returnTrLable(translats,CustomText.gettingLocationWithAccuracy,lng),
                    style: Styles.black128,
                    strutStyle:
                    StrutStyle(height: 1.2),
                  ),
                  SizedBox(height: 10,),
                  LabelValueRow(label:  Global.returnTrLable(translats,CustomText.Elapsed,lng),value: elapsedText,),
                  LabelValueRow(label: Global.returnTrLable(translats,CustomText.Accuracy,lng),value: '${bestAccuracy?.toStringAsFixed(1) ?? '--'} m"',),
                  LabelValueRow(label: Global.returnTrLable(translats,CustomText.LatLng,lng),value: '${bestPosition?.latitude ?? '--'}, ${bestPosition?.longitude ?? '--'}',),
                  LabelValueRow(label: Global.returnTrLable(translats,CustomText.Distance,lng),value: '${currentDistance?.toStringAsFixed(1) ?? '--'} m',),
                  SizedBox(height: 10,),
                  Container(
                    child: Text(
                      // currentDistance != null &&
                      //     currentDistance! <= widget.maxAllowedDistance
                      //     ?
                    '${Global.returnTrLable(translats,CustomText.WithinAllowedRange,lng)} (${widget.maxAllowedDistance} m)'
                          // : Global.returnTrLable(translats,CustomText.TooFar,lng),
                     , style: TextStyle(
                        color: currentDistance != null &&
                            currentDistance! <= widget.maxAllowedDistance
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: CElevatedButton(
                            text:  Global.returnTrLable(
                                translats, CustomText.Cancel, lng),
                            color: Color(0xffDB4B73),
                            onPressed: () {
                              if (mounted) Navigator.pop(context);
                            },
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: CElevatedButton(
                            text: Global.returnTrLable(
                                translats, CustomText.Save, lng),
                            color: Color(0xff369A8D),
                            onPressed: () {
                              if (currentDistance != null &&
                                  currentDistance! <= widget.maxAllowedDistance) {
                                stop();
                                if (bestPosition != null) {
                                  widget.onLocationResult(
                                    bestPosition!.latitude,
                                    bestPosition!.longitude,
                                    "", // Can be replaced with address via geocoding
                                  );
                                  if (mounted) Navigator.pop(context);
                                }
                              } else {
                                if (mounted) Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                   SnackBar(
                                    content: Text(Global.returnTrLable(translats,CustomText.NotAllowedWithInRange,lng)),
                                  ),
                                );
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  )
                ]),
          )),
    );
  }
}
