import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shishughar/model/apimodel/translation_language_api_model.dart';
import 'package:shishughar/utils/globle_method.dart';

import '../../database/helper/image_file_tab_responce_helper.dart';
import '../../style/styles.dart';
import '../../utils/constants.dart';
import '../custom_btn.dart';
import '../custom_text.dart';

class CustomImageDynamicReplica extends StatefulWidget {
  String? assetPath;
  final String? child_guid;
  String? titleText;
  final BoxFit fit;
  final AlignmentGeometry alignment;
  final ImageRepeat repeat;
  final FilterQuality filterQuality;
  final double? scale;
  final double? width;
  final double? height;
  void Function(String)? onChanged;
  final Color? color;
  final int? isRequred;
  void Function(String)? onName;
  void Function(bool)? onDelete;
  String? imageName;
  bool? readable;
  final bool? isDelitable;
  final String docType;
  List<Translation> translats;
  String lng;

  CustomImageDynamicReplica({
    this.assetPath,
    this.child_guid,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.filterQuality = FilterQuality.low,
    this.scale,
    this.width,
    this.height,
    this.color,
    this.onName,
    this.imageName,
    this.titleText,
    this.isRequred,
    this.onChanged,
    this.readable,
    required this.isDelitable,
    required this.docType,
    required this.onDelete,
    required this.translats,
    required this.lng
  });

  @override
  _CustomImageDynamicReplicaState createState() =>
      _CustomImageDynamicReplicaState();
}

class _CustomImageDynamicReplicaState extends State<CustomImageDynamicReplica> {
  File? image;
  File? placeHolder;

  @override
  void initState() {
    super.initState();
    initImage(widget.assetPath);
  }

  void initImage(String? assetPath) async {
    if (Global.validString(assetPath)) {
      var tempFile = File('${Constants.phoneImagePath}$assetPath');
      var alreadyFile = await tempFile.exists();
      print(alreadyFile);
      if (alreadyFile) {
        // setState(() {
        image = tempFile;
        setState(() {});
        print("Image initialized with file: ${image?.path}");
        // });
      }
    } else {
      String imageData = 'assets/image_placeholder.jpg';
      // placeHolder = await loadAssetImageAsFile(imageData);
      // setState(() {});
      try {
        // Introduce a delay before setting the placeholder image
        // await Future.delayed(Duration(seconds: 1)); // Adjust the delay duration as needed
        placeHolder = await loadAssetImageAsFile(imageData);
        setState(() {});
      } catch (e) {
        print('Error loading placeholder image: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RichText(
          text: TextSpan(
            text: widget.titleText ?? '',
            style: Styles.black124,
            children: (widget.isRequred == 1)
                ? [
                    TextSpan(
                      text: '*',
                      style: TextStyle(color: Colors.red),
                    ),
                  ]
                : [],
          ),
        ),
        SizedBox(height: 2),
        Column(
          children: [
            GestureDetector(
              onTap: () async {
                if (widget.readable == false &&
                    !Global.validString(widget.assetPath)) {
                  openDailogBox(context, CustomText.SelectOneoption,
                      CustomText.Camera, CustomText.Gallery);
                }
              },
              child: _buildImageWidget(),
            ),
            Visibility(
              
                visible: widget.isDelitable == true &&
                        Global.validString(widget.assetPath)
                    ? true
                    : false,
                child: Column(
                  children: [
                    SizedBox(height: 5),
                    Container(
                      height: MediaQuery.of(context).size.height *
                          0.04, // Adjust height as needed
                      width: MediaQuery.of(context).size.width *
                          0.1, // Adjust width as needed

                      child: ElevatedButton(
                          onPressed: () async {
                            await clearImagePath();
                            // initImage(widget.assetPath);
                            widget.onDelete!(true);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red, // Background color
                              // onPrimary: Colors.white, // Text color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              padding: EdgeInsets.zero),
                          child: Icon(
                            Icons.delete,
                            size: 20,
                          )),
                    ),
                  ],
                ))
          ],
        ),
      ],
    );
  }

  Future<void> clearImagePath() async {
    await ImageFileTabHelper()
        .deleteImageFile(widget.docType, widget.child_guid!);
    // widget.assetPath = null;

    print("Clearing image path...");
    widget.imageName = null;
    image = null;
    // setState(() {});
  }

  Widget _buildImageWidget() {
    if (image != null) {
      return Image.file(
        image!,
        fit: widget.fit,
        alignment: widget.alignment,
        repeat: widget.repeat,
        filterQuality: widget.filterQuality,
        width: 100,
        height: 100,
        color: widget.color,
      );
    } else if (widget.assetPath != null && widget.assetPath!.isNotEmpty) {
      return Image.network(
        '${Constants.ImagebaseUrl}${widget.assetPath}',
        fit: BoxFit.fill,
        width: 100,
        height: 100,
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
    } else if (placeHolder != null) {
      return Image.file(
        placeHolder!,
        fit: widget.fit,
        alignment: widget.alignment,
        repeat: widget.repeat,
        filterQuality: widget.filterQuality,
        width: 100,
        height: 100,
        color: widget.color,
      );
    } else {
      return SizedBox();
    }
  }

  static Future<File> savePickedImage(
      XFile pickedImage, String? childGuid) async {
    final Directory appDirectory = await getApplicationDocumentsDirectory();
    final Directory imagesDirectory =
        Directory('${appDirectory.path}/shishughar_images');
    final bool exist = await imagesDirectory.exists();
    if (!exist) {
      await imagesDirectory.create(recursive: true);
    }
    final String uniqueFileName =
        'image_${childGuid}_${DateTime.now().millisecondsSinceEpoch}.png';
    final File newImagePath = File('${imagesDirectory.path}/$uniqueFileName');

    final Uint8List bytes = await pickedImage.readAsBytes();
    await newImagePath.writeAsBytes(bytes);

    return newImagePath;
  }

  // Future<File> loadAssetImageAsFile(String assetPath) async {
  //   final byteData = await rootBundle.load(assetPath);
  //   final directory = await getApplicationDocumentsDirectory();
  //   final file = File('${directory.path}/${assetPath.split('/').last}');
  //   await file.writeAsBytes(byteData.buffer.asUint8List());
  //   return file;
  // }
  Future<File> loadAssetImageAsFile(String assetPath) async {
    try {
      final byteData = await rootBundle.load(assetPath);
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/${assetPath.split('/').last}');
      await file.writeAsBytes(byteData.buffer.asUint8List());
      print('Placeholder image saved at: ${file.path}');
      return file;
    } catch (e) {
      print('Error saving asset image as file: $e');
      rethrow; // Re-throw the exception to be caught in initImage
    }
  }

  @override
  void didUpdateWidget(covariant CustomImageDynamicReplica oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.assetPath != widget.assetPath) {
      print("Widget updated, reinitializing image.");
      initImage(widget.assetPath);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  openDailogBox(BuildContext context, String message, String negButton,
      String posButton) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          contentPadding: EdgeInsets.zero,
          content: Container(
              width: MediaQuery.of(context).size.width * 5.00,
              // height: MediaQuery.of(context).size.height * 0.2,
              child: IntrinsicHeight(
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
                            child: Text(CustomText.SHISHUGHAR,
                                style: Styles.white126P)),
                      ),
                      Center(
                          child: Text(Global.returnTrLable(widget.translats, message, widget.lng),
                              style: Styles.black3125,
                              textAlign: TextAlign.center)),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: CElevatedButton(
                                text: Global.returnTrLable(widget.translats, posButton, widget.lng),
                                color: Color(0xffDB4B73),
                                onPressed: () async {
                                  Navigator.of(context).pop(false);
                                  var file = await ImagePicker()
                                      .pickImage(source: ImageSource.gallery);
                                  await captureImage(file);
                                },
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: CElevatedButton(
                                text: Global.returnTrLable(widget.translats,negButton , widget.lng),
                                color: Color(0xff369A8D),
                                onPressed: () async {
                                  Navigator.of(context).pop(false);
                                  var file = await ImagePicker()
                                      .pickImage(source: ImageSource.camera);
                                  await captureImage(file);
                                },
                              ),
                            )
                          ],
                        ),
                      )
                    ]),
              )),
        );
      },
    );
  }

  Future captureImage(XFile? file) async {
    if (file != null) {
      var save = await savePickedImage(file, widget.child_guid);

      setState(() {
        image = File(save.path);
        widget.onChanged?.call(save.path);
        widget.imageName = basename(save.path);
        widget.onName?.call(widget.imageName!);
      });
        }
  }
}
