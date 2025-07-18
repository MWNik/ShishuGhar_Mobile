import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shishughar/utils/globle_method.dart';

import '../../style/styles.dart';
import '../../utils/constants.dart';
import '../custom_text.dart';
import '../double_button_dailog.dart';
import 'package:path/path.dart' as path;


class CustomImageDynamic extends StatefulWidget {
  final String? assetPath;
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
  String? imageName;
  bool? readable;

  CustomImageDynamic({
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
  });

  @override
  _CustomImageDynamicState createState() => _CustomImageDynamicState();
}

class _CustomImageDynamicState extends State<CustomImageDynamic> {
  File? image;
  File? placeHolder;

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
        GestureDetector(
          onTap: () async {
            if (widget.readable == false) {
              var dialogResult = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return DoubleButtonDailog(
                    message: CustomText.SelectOneoption,
                    posButton: CustomText.Camera,
                    negButton: CustomText.Gallery,
                  );
                },
              );

              XFile? file;
              if (dialogResult == true) {
                file = await ImagePicker().pickImage(source: ImageSource.camera);
              } else {
                file = await ImagePicker().pickImage(source: ImageSource.gallery);
              }

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
          },
          child: _buildImageWidget(),
        ),
      ],
    );
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
        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
          return Image.asset(
            'assets/no_network.png',  // Path to your placeholder image
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

  Future<File> savePickedImage(XFile pickedImage, String? childGuid) async {
    // Get app document directory
    final Directory appDirectory = await getApplicationDocumentsDirectory();
    final Directory imagesDirectory =
    Directory('${appDirectory.path}/shishughar_images');

    // Create directory if not exists
    if (!await imagesDirectory.exists()) {
      await imagesDirectory.create(recursive: true);
    }

    // Set file name and target path

    final String fileName = 'image_${childGuid}_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final String targetPath =  path.join(imagesDirectory.path, fileName);

    // Compress the image file
    final List<int>? compressedBytes = await FlutterImageCompress.compressWithFile(
      pickedImage.path,
      quality: 10, // You can adjust this for more/less compression
      format: CompressFormat.jpeg,
    );

    // Write compressed file
    final File newImageFile = File(targetPath);
    await newImageFile.writeAsBytes(compressedBytes!);

    // Delete original picked image file if it's a temp file
    try {
      final File originalFile = File(pickedImage.path);
      if (await originalFile.exists()) {
        await originalFile.delete();
        print('Original image deleted: ${pickedImage.path}');
      }
    } catch (e) {
      print('Failed to delete original file: $e');
    }

    print('Compressed Image Path: $targetPath');
    // print('Compressed Image Size: ${compressedBytes.lengthInBytes} bytes');

    return newImageFile;
  }


  // static Future<File> savePickedImage(XFile pickedImage, String? childGuid) async {
  //   final Directory appDirectory = await getApplicationDocumentsDirectory();
  //   final Directory imagesDirectory = Directory('${appDirectory.path}/shishughar_images');
  //   final bool exist = await imagesDirectory.exists();
  //   if (!exist) {
  //     await imagesDirectory.create(recursive: true);
  //   }
  //   final String uniqueFileName = 'image_${childGuid}_${DateTime.now().millisecondsSinceEpoch}.png';
  //   final File newImagePath = File('${imagesDirectory.path}/$uniqueFileName');
  //
  //   final Uint8List bytes = await pickedImage.readAsBytes();
  //   await newImagePath.writeAsBytes(bytes);
  //
  //   return newImagePath;
  // }

  void initImage(String? assetPath) async {
    if (Global.validString(assetPath)) {
      var tempFile = File('${Constants.phoneImagePath}$assetPath');
      var alreadyFile = await tempFile.exists();
      if (alreadyFile) {
        setState(() {
          image = tempFile;
        });
      }
    } else {
      String imageData = 'assets/image_placeholder.jpg';
      placeHolder = await loadAssetImageAsFile(imageData);
      setState(() {});
    }
  }

  Future<File> loadAssetImageAsFile(String assetPath) async {
    final byteData = await rootBundle.load(assetPath);
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/${assetPath.split('/').last}');
    await file.writeAsBytes(byteData.buffer.asUint8List());
    return file;
  }

  @override
  void initState() {
    super.initState();
    initImage(widget.assetPath);
  }

  @override
  void didUpdateWidget(covariant CustomImageDynamic oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.assetPath != widget.assetPath) {
      initImage(widget.assetPath);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
