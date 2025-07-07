import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shishughar/custom_widget/custom_appbar.dart';
import 'package:shishughar/screens/tabed_screens/enrolled_exit_child/enrolled_exit_child_tab.dart';

import '../custom_widget/custom_text.dart';
import '../database/helper/creche_helper/creche_data_helper.dart';
import '../database/helper/dynamic_screen_helper/options_model_helper.dart';
import '../database/helper/village_data_helper.dart';
import '../style/styles.dart';
import '../utils/globle_method.dart';
import '../utils/validate.dart';

class EnrolledChildTermsCondition extends StatefulWidget {
  final String CHHGUID;
  final String HHGUID;
  final String EnrolledChilGUID;
  final int HHname;
  final int crecheId;
  final int isNew;
  static String? childName;
  final bool isImageUpdate;
  final bool isEditable;
  String? minDate;
  String? childId;
  final String openingDate;
  final String closingDate;

  EnrolledChildTermsCondition(
      {super.key,
      required this.CHHGUID,
      required this.HHGUID,
      required this.HHname,
      required this.crecheId,
      required this.EnrolledChilGUID,
      required this.isNew,
      required this.isImageUpdate,
      required this.isEditable,
      required this.openingDate,
      required this.closingDate,
      this.minDate,
      this.childId});

  @override
  State<EnrolledChildTermsCondition> createState() =>
      _EnrolledChildTermsConditionState();
}

class _EnrolledChildTermsConditionState
    extends State<EnrolledChildTermsCondition> {
  String parterName = '';
  String villgeName = '';

  @override
  Widget build(BuildContext context) {
    Global.applyDisplayCutout(Color(0xff5979AA));
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppbar(
          text: CustomText.BENEFICIARYCONSENTFORM,
          onTap: () => Navigator.pop(context),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle("Introduction"),
                      _buildSectionText(
                        "$parterName (“We”/ “Us”/ “Our”) operate the Shishughar at $villgeName Location. "
                        "We are supported by Azim Premji Philanthropic Initiatives Pvt. Ltd. (APPI) "
                        "through their Rural Creche Initiative Programme.",
                      ),
                      _buildSectionTitle("Purpose"),
                      _buildSectionText(
                        "We collect Personal Information and Sensitive Personal Information of your child "
                        "to assess growth, health, and nutritional conditions and monitor the Programme progress.",
                      ),
                      _buildSectionTitle("What Information Do We Collect?"),
                      _buildSectionText(
                        "Personal Information: Child's name, age, gender, contact number, anthropometric data, etc.\n"
                        "Sensitive Personal Information: Illness and immunization status.",
                      ),
                      _buildSectionTitle("Data Storage & Retention"),
                      _buildSectionText(
                        "Information is stored in the Shishughar App and retained as required for the stated purpose or by law.",
                      ),
                      _buildSectionTitle("Data Security"),
                      _buildSectionText(
                        "We use reasonable security measures to protect your Personal and Sensitive Information.",
                      ),
                      _buildSectionTitle("Sharing of Data"),
                      _buildSectionText(
                        "Data is shared with APPI for the stated purpose but is anonymized in reports.",
                      ),
                      _buildSectionTitle("Data Deletion"),
                      _buildSectionText(
                        "You may request deletion of data by contacting us at the Shishughar.",
                      ),
                      _buildSectionTitle("Contact Information"),
                      _buildSectionText(
                        "For questions, contact the Creche Caregiver or Supervisor at the Shishughar.",
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      // Handle cancel action
                      Navigator.pop(context, 'cancel');
                    },
                    child: Text(CustomText.Cancel, style: Styles.red125),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          horizontal: 30.0), // Adjust padding as needed
                      backgroundColor: Color(0xff369A8D), // Background color
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(30.0), // Round corners
                      ),
                    ),
                    onPressed: () async {
                      // Navigator.pop(context, 'Accept');
                      var reponce = await Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  EnrolledExitChilrenTab(
                                      openingDate: widget.openingDate,
                                      closingDate: widget.closingDate,
                                      isEditable: widget.isEditable,
                                      CHHGUID: widget.CHHGUID,
                                      HHGUID: widget.HHGUID,
                                      HHname: widget.HHname,
                                      EnrolledChilGUID: widget.EnrolledChilGUID,
                                      crecheId: widget.crecheId,
                                      minDate: widget.minDate,
                                      isNew: widget.isNew,
                                      isImageUpdate: widget.isImageUpdate)));
                      if (reponce == 'itemRefresh') {
                        Navigator.pop(context, reponce);
                      }
                    },
                    child: Text(
                      CustomText.IAgree,
                      style: Styles.white125,
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: Styles.black128,
      ),
    );
  }

  Widget _buildSectionText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        text,
        style: Styles.black124r,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    initVillageAndPartenerName();
  }

  Future initVillageAndPartenerName() async {
    var items = await CrecheDataHelper().getCrecheResponceItem(widget.crecheId);
    if (items.length > 0) {
      var parterNameId =
          Global.getItemValues(items.first.responces!, 'partner_id');
      var villgeNameId =
          Global.getItemValues(items.first.responces!, 'village_id');
      if (Global.validString(parterNameId)) {
        var parners = await OptionsModelHelper()
            .partnerByPartnerId(Global.stringToInt(parterNameId));
        if (parners.length > 0) {
          parterName = parners.first.values!;
        }
      }
      if (Global.validString(villgeNameId)) {
        var villages = await VillageDataHelper()
            .villageById(Global.stringToInt(villgeNameId));
        if (villages.length > 0) {
          villgeName = villages.first.value!;
        }
      }
    }
    setState(() {});
  }
}
