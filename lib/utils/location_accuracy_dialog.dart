



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

class LocationAccuracyDialog extends StatefulWidget {
  final Function(String lat, String lng, String address) onLocationResult;
  const LocationAccuracyDialog({super.key, required this.onLocationResult});

  @override
  State<LocationAccuracyDialog> createState() => _LocationAccuracyDialogState();
}

class _LocationAccuracyDialogState extends State<LocationAccuracyDialog> {
  double? bestAccuracy;
  Position? bestPosition;
  Timer? timer;
  int elapsedSeconds = 0;
  StreamSubscription<Position>? positionSubscription;
  bool isGettingLocation = true;
  List<Translation> translats = [];
  String lng = 'en';

  @override
  void initState() {
    super.initState();
    checkPermissionAndStart();
  }

  Future<void> checkPermissionAndStart() async {




    var status = await Permission.location.request();
    if (status.isGranted) {
      startGettingLocation();
    } else {
      if (mounted) Navigator.pop(context);
    }
  }

  Future<void> startGettingLocation() async {
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
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() => elapsedSeconds++);
      }
    });

    positionSubscription=Geolocator.getPositionStream(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.bestForNavigation,
          distanceFilter: 0),
    ).listen((position) {
      if (!mounted) return;
      setState(() {
        if (bestAccuracy == null || position.accuracy < bestAccuracy!) {
          bestAccuracy = position.accuracy;
          bestPosition = position;
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
    String elapsedText = "${(elapsedSeconds ~/ 60).toString().padLeft(2, '0')}:${(elapsedSeconds % 60).toString().padLeft(2, '0')}";
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
                              stop();
                              if (bestPosition != null) {
                                widget.onLocationResult(
                                  bestPosition!.latitude.toString(),
                                  bestPosition!.longitude.toString(),
                                  "", // Can be replaced with address via geocoding
                                );
                                if (mounted) Navigator.pop(context);
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
