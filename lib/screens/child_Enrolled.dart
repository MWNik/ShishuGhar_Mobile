import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shishughar/custom_widget/custom_appbar.dart';
import 'package:shishughar/custom_widget/custom_text.dart';
import 'package:shishughar/custom_widget/customtextfield.dart';
import 'package:shishughar/screens/children_enrollment_profile.dart';

import 'package:shishughar/style/styles.dart';

import '../custom_widget/custom_btn.dart';
import '../custom_widget/custom_dropdown.dart';

class ChildEnrolledScreen extends StatefulWidget {
  const ChildEnrolledScreen({super.key});

  @override
  State<ChildEnrolledScreen> createState() => _ChildEnrolledScreenState();
}

class _ChildEnrolledScreenState extends State<ChildEnrolledScreen> {
  String? selecteditem;
  TextEditingController Childnamecontroller = TextEditingController();
  TextEditingController ChildIDcontroller = TextEditingController();
  TextEditingController ChildEnrollementcontroller = TextEditingController();
  final _picker = ImagePicker();
  var _image;

  Future<void> _openImagePicker() async {
    XFile? pickedImage = await _picker.pickImage(
      source: ImageSource.camera,
    );
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        text: CustomText.ChildEnrollment,
        onTap: () {
          Navigator.pop(context);
        },
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          // decoration: BoxDecoration(
          //   image: DecorationImage(
          //     alignment: Alignment.topCenter,
          //     image: AssetImage(
          //       "assets/tlogo.png",
          //     ),
          //   ),
          // ),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  _openImagePicker();
                },
                child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color(0xffF9F9F9),
                          border: Border.all(color: Color(0xffACACAC)),
                          borderRadius: BorderRadius.circular(5.r)),
                      height: 80.h,
                      width: 78.w,
                      child: _image == null
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/add_btn.png",
                                  scale: 4,
                                  color: Color(0xff80E0AA),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Text(
                                  CustomText.ChildPicture,
                                  style: Styles.Grey104,
                                  textAlign: TextAlign.center,
                                )
                              ],
                            )
                          : SizedBox(child: Image.file(_image)),
                    )),
              ),
              SizedBox(
                height: 10.h,
              ),
              CustomTextField(
                controller: ChildIDcontroller,
                titleText: CustomText.ChildId,
              ),
              SizedBox(
                height: 10.h,
              ),
              CustomTextField(
                controller: Childnamecontroller,
                titleText: CustomText.ChildName,
              ),
              SizedBox(
                height: 10.h,
              ),
              CustomTextField(
                controller: ChildEnrollementcontroller,
                titleText: CustomText.ChildCareName,
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomDropdownField(
                      titleText: CustomText.Village,
                      items: ["A", "B"],
                      selectedItem: selecteditem,
                      onChanged: (value) {},
                    ),
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  Expanded(
                    child: CustomDropdownField(
                      titleText: CustomText.GramPanchayat,
                      items: ["A", "B"],
                      selectedItem: selecteditem,
                      onChanged: (value) {},
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomDropdownField(
                      titleText: CustomText.Block,
                      items: ["A", "B"],
                      selectedItem: selecteditem,
                      onChanged: (value) {},
                    ),
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  Expanded(
                    child: CustomDropdownField(
                      titleText: CustomText.District,
                      items: ["A", "B"],
                      selectedItem: selecteditem,
                      onChanged: (value) {},
                    ),
                  ),
                ],
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: Row(
                  children: [
                    Expanded(
                      child: CElevatedButton(
                        color: Color(0xffF26BA3),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        text: CustomText.back,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: CElevatedButton(
                        color: Color(0xff5979AA),
                        onPressed: () {
                          // Navigator.of(context).push(MaterialPageRoute(
                          //     builder: (BuildContext context) =>
                          //         LineholdlistedScreen()));
                        },
                        text: CustomText.Save,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: CElevatedButton(
                        color: Color(0xff2CAFA1),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  ChildrenEnrollmentProfileScreen()));
                        },
                        text: CustomText.Next,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
