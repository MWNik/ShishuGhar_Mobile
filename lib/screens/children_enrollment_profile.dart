import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_radio_slider/flutter_radio_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/custom_widget/custom_appbar.dart';
import 'package:shishughar/custom_widget/custom_btn.dart';
import 'package:shishughar/custom_widget/custom_dropdown.dart';
import 'package:shishughar/custom_widget/custom_radio_btn.dart';
import 'package:shishughar/custom_widget/custom_text.dart';
import 'package:shishughar/custom_widget/customtextfield.dart';

import 'package:shishughar/style/styles.dart';

class ChildrenEnrollmentProfileScreen extends StatefulWidget {
  const ChildrenEnrollmentProfileScreen({super.key});

  @override
  State<ChildrenEnrollmentProfileScreen> createState() =>
      _ChildrenEnrollmentProfileScreenState();
}

class _ChildrenEnrollmentProfileScreenState
    extends State<ChildrenEnrollmentProfileScreen> {
  String? selectedOdour;
  bool isexpanded = true;
  String Gendertype = 'Male';
  String Agree = 'Yes';

  List<bool> boolList = List.filled(6, true);
  List Expandedtext = [
    "A. Child Details",
    "B. Entry Time Data",
    "C. Family Details",
    "D. Social & Economic Details",
    "E. Eligibility",
    "F. Child Entry in Home"
  ];
  TextEditingController DOBcontroller = TextEditingController();
  TextEditingController Nominationtimecontroller = TextEditingController();
  TextEditingController NominationDatecontroller = TextEditingController();
  int activeStep = 0;
  @override
  Widget build(BuildContext context) {
    final themeData = SliderTheme.of(context).copyWith(
      overlayColor: Colors.lightGreen.withAlpha(32),
      activeTickMarkColor: Colors.green,
      activeTrackColor: Colors.lightGreen,
      inactiveTrackColor: Colors.grey[300],
      inactiveTickMarkColor: Colors.grey[500],
      tickMarkShape: RoundSliderTickMarkShape(
        tickMarkRadius: 10, // Adjust the radius of the tick marks as needed
      ),
    );
    return Scaffold(
      appBar: CustomAppbar(
        text: CustomText.ChildEnrollment,
        onTap: () {
          Navigator.pop(context);
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              SliderTheme(
                data: themeData,
                child: RadioSlider(
                  onChanged: (value) {
                    // Do something
                  },
                  divisions: 5,
                  outerCircle: false,
                ),
              ),
              EasyStepper(
                showStepBorder: true,
                stepRadius: 12,
                borderThickness: 2,
                activeStepBorderType: BorderType.normal,
                stepShape: StepShape.circle,
                lineStyle: LineStyle(
                  lineThickness: 3,
                  defaultLineColor: Colors.green,
                  lineType: LineType.normal,
                ),
                activeStep: activeStep,
                fitWidth: true,
                direction: Axis.horizontal,
                unreachedStepIconColor: Colors.white,
                unreachedStepBorderColor: Colors.black54,
                finishedStepBackgroundColor: Colors.green,
                unreachedStepBackgroundColor: Colors.grey,
                showTitle: true,
                onStepReached: (index) => setState(() => activeStep = index),
                steps: const [
                  EasyStep(
                    icon: Icon(Icons.check),
                    title: 'Cart',
                    activeIcon: Icon(Icons.check),
                  ),
                  EasyStep(
                    icon: Icon(Icons.check),
                    title: 'Cart',
                    activeIcon: Icon(Icons.check),
                  ),
                  EasyStep(
                    icon: Icon(Icons.check),
                    title: 'Cart',
                    activeIcon: Icon(Icons.check),
                  ),
                  EasyStep(
                    icon: Icon(Icons.check),
                    title: 'Cart',
                    activeIcon: Icon(Icons.check),
                  ),
                  EasyStep(
                    icon: Icon(Icons.check),
                    activeIcon: Icon(Icons.check),
                    title: 'Address',
                  ),
                  EasyStep(
                    icon: Icon(Icons.check),
                    activeIcon: Icon(Icons.check),
                    title: 'Checkout',
                  ),
                ],
              ),
              RadioSlider(
                divisions: 6,
                activeColor: Colors.green,
                onChanged: (value) {/* no-op */},
              ),
              // RadioSliderTickMarkShape(),

              Divider(
                color: Colors.white,
              ),
              ListView.builder(
                  itemCount: Expandedtext.length,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        boolList[index]
                            ? Row(
                                children: [
                                  Text(
                                    Expandedtext[index],
                                    style: Styles.black123,
                                  ),
                                  Spacer(),
                                  InkWell(
                                    onTap: () {
                                      boolList[index] = !boolList[index];
                                      setState(() {});
                                    },
                                    child: Icon(
                                      boolList[index]
                                          ? Icons.expand_less
                                          : Icons.expand_more,
                                      color: Color(0xff5E5E5E),
                                    ),
                                  ),
                                ],
                              )
                            : Container(
                                decoration: BoxDecoration(
                                    color: Color(0xffFBFBFB),
                                    borderRadius: BorderRadius.circular(10.r),
                                    border:
                                        Border.all(color: Color(0xffE0E0E0))),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            Expandedtext[index],
                                            style: Styles.red145,
                                          ),
                                          Spacer(),
                                          InkWell(
                                            onTap: () {
                                              boolList[index] =
                                                  !boolList[index];
                                              setState(() {});
                                            },
                                            child: Icon(
                                              boolList[index]
                                                  ? Icons.expand_less
                                                  : Icons.expand_more,
                                              color: Color(0xff5E5E5E),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: CustomTextField(
                                              controller: DOBcontroller,
                                              titleText: CustomText.DOB,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5.w,
                                          ),
                                          Expanded(
                                            child: CustomTextField(
                                              controller:
                                                  Nominationtimecontroller,
                                              titleText: CustomText.Nomination,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        CustomText.Gender,
                                        style: Styles.black124,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: CustomRadioButton(
                                              value: 'Male',
                                              groupValue: Gendertype,
                                              onChanged: (value) {
                                                setState(() {
                                                  Gendertype = value!;
                                                });
                                              },
                                              label: CustomText.Male,
                                            ),
                                          ),
                                          Expanded(
                                            child: CustomRadioButton(
                                              value: 'Female',
                                              groupValue: Gendertype,
                                              onChanged: (value) {
                                                setState(() {
                                                  Gendertype = value!;
                                                });
                                              },
                                              label: CustomText.Female,
                                            ),
                                          ),
                                          Expanded(
                                            child: CustomRadioButton(
                                              value: 'Transgender',
                                              groupValue: Gendertype,
                                              onChanged: (value) {
                                                setState(() {
                                                  Gendertype = value!;
                                                });
                                              },
                                              label: CustomText.Transgender,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: CustomTextField(
                                              controller:
                                                  NominationDatecontroller,
                                              titleText:
                                                  CustomText.NominationDate,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10.w,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  CustomText
                                                      .PresentBreastFeeding,
                                                  style: Styles.black124,
                                                ),
                                                SizedBox(
                                                  height: 30,
                                                  child: Row(
                                                    children: [
                                                      CustomRadioButton(
                                                        value: 'Yes',
                                                        groupValue: Agree,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            Agree = value!;
                                                          });
                                                        },
                                                        label: CustomText.Yes,
                                                      ),
                                                      SizedBox(
                                                        width: 20,
                                                      ),
                                                      CustomRadioButton(
                                                        value: 'NO',
                                                        groupValue: Agree,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            Agree = value!;
                                                          });
                                                        },
                                                        label: CustomText.No,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      CustomTextField(
                                        controller: NominationDatecontroller,
                                        titleText: CustomText.Clarify,
                                      ),
                                      CustomDropdownField(
                                        icon: Image.asset(
                                          "assets/arrow.png",
                                        ),
                                        titleText: CustomText
                                            .howManySiblingsArChildhave,
                                        items: ["A", "B"],
                                        selectedItem: selectedOdour,
                                        onChanged: (value) {},
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                        Divider(
                          color: Colors.white,
                        ),
                      ],
                    );
                  }),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h),
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
