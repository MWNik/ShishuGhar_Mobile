import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shishughar/api/language_translation_api.dart';
import 'package:shishughar/api/modified_date_api.dart';
import 'package:shishughar/custom_widget/custom_appbar.dart';
import 'package:shishughar/custom_widget/custom_text.dart';
import 'package:shishughar/custom_widget/custom_textfield.dart';
import 'package:shishughar/database/helper/modifieddatahelper.dart';
import 'package:shishughar/model/apimodel/modifiedDate_apiModel.dart';
import 'package:shishughar/model/apimodel/translation_language_api_model.dart';
import 'package:shishughar/screens/Add_visit_notes.dart';

import 'package:shishughar/style/styles.dart';

class VisitNotesScreen extends StatefulWidget {
  const VisitNotesScreen({super.key});

  @override
  State<VisitNotesScreen> createState() => _VisitNotesScreenState();
}

class _VisitNotesScreenState extends State<VisitNotesScreen> {
  TextEditingController Searchcontroller = TextEditingController();
  TranslationModel translationModel = TranslationModel();
  List<Translation> TranslationList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => AddVisitNotesScreeb()));
        },
        child: Image.asset(
          "assets/add_btn.png",
          scale: 2.7,
          color: Color(0xff5979AA),
        ),
      ),
      appBar: CustomAppbar(
        text: CustomText.VisitNotes,
        onTap: () async {
          TranslationService translationService = TranslationService();
          ModifiedDateApiService modifiedDateApiService =
              ModifiedDateApiService();


          // ModifiedApiModel? modifiedApiModel =
          //     await modifiedDateApiService.getModifiedData();
          // if (modifiedApiModel != null) {
          //   List<DocType>? docTypeList = modifiedApiModel.docType;
          //
          //   ModifiedDataHelper modifiedDataHelper = ModifiedDataHelper();
          //
          //   if (docTypeList != null) {
          //     print("Insert  Modified data into the database");
          //     await modifiedDataHelper.insertModifiedData(docTypeList);
          //   } else {
          //     print("Not Insert translation data into the database");
          //   }
          // }
        },
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: CustomTextFieldRow(
                    controller: Searchcontroller,
                    hintText: CustomText.Search,
                    prefixIcon: Image.asset(
                      "assets/search.png",
                      scale: 2.4,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Image.asset(
                  "assets/filter_icon.png",
                  scale: 2.4,
                ),
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            ListView.builder(
                itemCount: 3,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.h),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Color(0xffE7F0FF)),
                          borderRadius: BorderRadius.circular(10.r)),
                      height: 65.h,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 8.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(
                                        text: CustomText.VisitOn,
                                        style: Styles.black104,
                                        children: [
                                          TextSpan(
                                              text: "Anjali Sharna",
                                              style: Styles.blue125),
                                        ])),
                                RichText(
                                    strutStyle: StrutStyle(height: 1.h),
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(
                                        text: CustomText.Creche,
                                        style: Styles.black104,
                                        children: [
                                          TextSpan(
                                              text: "Supervisor",
                                              style: Styles.blue125),
                                        ])),
                                RichText(
                                    strutStyle: StrutStyle(height: 1.h),
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(
                                        text: CustomText.Villages,
                                        style: Styles.black104,
                                        children: [
                                          TextSpan(
                                              text: " Dec 1, 2023",
                                              style: Styles.blue125),
                                        ])),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
