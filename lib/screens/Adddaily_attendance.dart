import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/custom_widget/custom_appbar.dart';
import 'package:shishughar/custom_widget/custom_dropdown.dart';
import 'package:shishughar/custom_widget/custom_text.dart';
import 'package:shishughar/custom_widget/custom_textfield.dart';
import 'package:shishughar/custom_widget/customdatepicker.dart';

import 'package:shishughar/style/styles.dart';

import '../custom_widget/custom_btn.dart';

class AddDailyAttendanceScreen extends StatefulWidget {
  const AddDailyAttendanceScreen({super.key});

  @override
  State<AddDailyAttendanceScreen> createState() =>
      _AddDailyAttendanceScreenState();
}

class _AddDailyAttendanceScreenState extends State<AddDailyAttendanceScreen> {
  bool isChecked = false;
  TextEditingController DOBcontroller = TextEditingController();
  String? selectedOdour;
  List<bool> checkedList = [false, false, false, false, false];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppbar(
        text: CustomText.AddDailyAttendance,
        onTap: () {
          Navigator.pop(context);
        },
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 44.h,
                decoration: BoxDecoration(
                    color: Color(0xff5979AA),
                    borderRadius: BorderRadius.circular(5.r)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Row(
                        children: [
                          RichText(
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                  text: CustomText.Districts,
                                  style: Styles.white124P,
                                  children: [
                                    TextSpan(
                                        text: "Kalahandi",
                                        style: Styles.white126P),
                                  ])),
                          SizedBox(
                            width: 10.w,
                          ),
                          Text(
                            "|",
                            style: Styles.white125,
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          RichText(
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                  text: CustomText.Blocks,
                                  style: Styles.white124P,
                                  children: [
                                    TextSpan(
                                        text: "Golamunda",
                                        style: Styles.white126P),
                                  ])),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Row(
                        children: [
                          RichText(
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                  text: CustomText.Blocks,
                                  style: Styles.white124P,
                                  children: [
                                    TextSpan(
                                        text: "Badachergaon",
                                        style: Styles.white126P),
                                  ])),
                          SizedBox(
                            width: 10.w,
                          ),
                          Text(
                            "|",
                            style: Styles.white125,
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          RichText(
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                  text: CustomText.Villages,
                                  style: Styles.white124P,
                                  children: [
                                    TextSpan(
                                        text: "Mermahul",
                                        style: Styles.white126P),
                                  ])),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: CustomDatepicker(
                  color: Color(0xffF2F7FF),
                  controller: DOBcontroller,
                  width: 200.w,
                ),
              ),
              Divider(
                color: Color(0xffF0F0F0),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: Text(
                  CustomText.Status,
                  style: Styles.black146,
                ),
              ),
              Row(
                children: [
                  SizedBox(
                    height: 20,
                    width: 20,
                    child: Checkbox(
                        materialTapTargetSize: MaterialTapTargetSize.padded,
                        side: BorderSide(color: Color(0xff5979AA), width: 2),
                        activeColor: Color(0xff5979AA),
                        checkColor: Colors.white,
                        value: isChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked = value!;
                          });
                        }),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Text(
                    CustomText.ShishuGharclosed,
                    style: Styles.black124,
                  ),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              CustomDropdownField(
                titleText: CustomText.Reasonforclosure,
                items: ["A", "B"],
                selectedItem: selectedOdour,
                onChanged: (value) {},
              ),
              Row(
                children: [
                  Text(CustomText.OpenTime),
                  SizedBox(
                    width: 10.w,
                  ),
                  Text(
                    CustomText.Hours,
                    style: Styles.black125,
                  ),
                  SizedBox(
                    width: 4.w,
                  ),
                  Expanded(
                    child: CustomTextFieldRowButton(
                      controller: DOBcontroller,
                      titleText: CustomText.Hours,
                      keyboardtype: TextInputType.number,
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Text(
                    CustomText.Minutes,
                    style: Styles.black125,
                  ),
                  SizedBox(
                    width: 4.w,
                  ),
                  Expanded(
                    child: CustomTextFieldRowButton(
                      controller: DOBcontroller,
                      titleText: CustomText.Minutes,
                      keyboardtype: TextInputType.number,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                children: [
                  Column(
                    children: [
                      Text(CustomText.closeTime),
                    ],
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Text(
                    CustomText.Hours,
                    style: Styles.black125,
                  ),
                  SizedBox(
                    width: 4.w,
                  ),
                  Expanded(
                    child: CustomTextFieldRowButton(
                      controller: DOBcontroller,
                      titleText: CustomText.Hours,
                      keyboardtype: TextInputType.number,
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Text(
                    CustomText.Minutes,
                    style: Styles.black125,
                  ),
                  SizedBox(
                    width: 4.w,
                  ),
                  Expanded(
                    child: CustomTextFieldRowButton(
                      controller: DOBcontroller,
                      titleText: CustomText.Minutes,
                      keyboardtype: TextInputType.number,
                    ),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: Divider(
                  color: Color(0xffFFF1E0),
                ),
              ),
              Text(
                CustomText.NumberofChildrenServed,
                style: Styles.black124,
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              CustomText.Breakfast,
                              style: Styles.black125,
                            ),
                            SizedBox(
                              width: 40.w,
                            ),
                            Expanded(
                              child: CustomTextFieldRowButton(
                                controller: DOBcontroller,
                                keyboardtype: TextInputType.number,
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Row(
                          children: [
                            Text(
                              CustomText.Egg,
                              style: Styles.black125,
                            ),
                            Spacer(),
                            Expanded(
                              child: CustomTextFieldRowButton(
                                controller: DOBcontroller,
                                keyboardtype: TextInputType.number,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              CustomText.Lunch,
                              style: Styles.black125,
                            ),
                            Spacer(),
                            Expanded(
                              child: CustomTextFieldRowButton(
                                controller: DOBcontroller,
                                keyboardtype: TextInputType.number,
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Row(
                          children: [
                            Text(
                              CustomText.EveningSnacks,
                              style: Styles.black125,
                            ),
                            Expanded(
                              child: CustomTextFieldRowButton(
                                controller: DOBcontroller,
                                keyboardtype: TextInputType.number,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              Row(
                children: [
                  Text(
                    CustomText.NameofEnrolledChildren,
                    style: Styles.black123,
                  ),
                  Spacer(),
                  Text(
                    CustomText.Attendance,
                    style: Styles.black123,
                  )
                ],
              ),
              SizedBox(
                height: 300.h,
                child: ListView.builder(
                    itemCount: 5,
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          title: Text(
                            'Aman Singh ',
                            style: Styles.black124,
                          ),
                          subtitle: Text(
                            '12345',
                            style: Styles.black124,
                          ),
                          trailing: Padding(
                            padding: EdgeInsets.only(right: 40.w),
                            child: Checkbox(
                              side: BorderSide(
                                  color: Color(0xff5979AA), width: 2),
                              activeColor: Color(0xff5979AA),
                              checkColor: Colors.white,
                              value: checkedList[index],
                              onChanged: (bool? newValue) {
                                setState(() {
                                  checkedList[index] = newValue!;
                                });
                              },
                            ),
                          ));
                    }),
              ),
              Row(
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
                        // Navigator.of(context).push(MaterialPageRoute(
                        //     builder: (BuildContext context) =>
                        //         ViewVisitScreen()));
                      },
                      text: CustomText.Next,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
