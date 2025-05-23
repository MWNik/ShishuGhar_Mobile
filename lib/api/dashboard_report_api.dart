import 'package:http/http.dart' as http;
import 'package:shishughar/model/dynamic_screen_model/options_model.dart';
import 'package:shishughar/utils/globle_method.dart';
import '../utils/constants.dart';
import '../utils/validate.dart';
import 'package:dio/dio.dart' as dio;

class DashboardReportApi {
  Future<http.Response> callDashboardReportApi(
      String year, String month, String crecheId, String token) async {
    var endurl =
        '${Constants.baseUrl}method/frappe.val.app_dashboard.app_dashboard';
    var headers = {'Authorization': token};

    Map<String, String> body = {
      "year": year,
      "month": month,
      "creche": crecheId
    };
    try {
      var response =
          await http.post(Uri.parse(endurl), headers: headers, body: body);
      print(response.body);

      return response;
    } catch (e) {
      print('Internal server error: ${e}');
      return http.Response('Internal server error - $e', 500);
    }
  }

  Future<http.Response> callDashboardSupReportApi(
      String? userName,
      String year,
      String month,
      OptionsModel? selectedState,
      OptionsModel? selectedDistrict,
      OptionsModel? selectedBlock,
      OptionsModel? selectedGramPanchayat,
      OptionsModel? selectedVillage,
      OptionsModel? selectedCreche,
      String token) async {
    var endurl =
        '${Constants.baseUrl}method/frappe.val.ph_report_card.dashboard_section_one';
    var headers = {
      'Authorization': token,
      // 'Content-Type': 'application/json'
    };
    Map<String, String> body = {
      "year": year,
      "month": month,
    };
    if (Global.validString(userName)) {
      body['supervisor_id'] = userName!;
    }
    if (selectedState != null) {
      body['state_id'] = '${selectedState.name}';
    }

    if (selectedDistrict != null) {
      body['district_id'] = '${selectedDistrict.name}';
    }
    if (selectedBlock != null) {
      body['block_id'] = '${selectedBlock.name}';
    }
    if (selectedGramPanchayat != null) {
      body['gp_id'] = '${selectedGramPanchayat.name}';
    }
    if (selectedVillage != null) {
      body['village_id'] = '${selectedVillage.name}';
    }
    if (selectedCreche != null) {
      body['creche_id'] = '${selectedCreche.name}';
    }

    print('body $body');
    // var itemBody=jsonEncode(body);
    print("start time ${Validate().currentDateTime()}");
    try {
      var response = await http.post(Uri.parse(endurl), body: body);
      // print(response.body);
      print("end time ${Validate().currentDateTime()}");
      return response;
    } catch (e) {
      print('Internal server error: ${e}');
      return http.Response('Internal server error - $e', 500);
    }
  }

  // Future<dio.Response> callDashboardSupReportApiDio(
  //     String? userName,  String year, String month,OptionsModel? selectedState, OptionsModel? selectedDistrict, OptionsModel? selectedBlock,
  //     OptionsModel? selectedGramPanchayat, OptionsModel? selectedVillage, OptionsModel? selectedCreche, String token)
  // async {
  //
  //   var endurl = '${Constants.baseUrl}method/frappe.val.ph_report_card.dashboard_section_one';
  //   // var headers = {'Authorization': token,
  //     // 'Content-Type': 'application/json'
  //   // };
  //   Map<String, String> body = {
  //     "year": year,
  //     "month": month,
  //     "supervisor_id": userName!
  //   };
  //
  //   if(selectedState!=null) {
  //     body['state_id']='${selectedState.name}';
  //   }
  //   if(selectedDistrict!=null) {
  //     body['district_id']='${selectedDistrict.name}';
  //   }
  //   if(selectedBlock!=null) {
  //     body['block_id']='${selectedBlock.name}';
  //   }
  //   if(selectedGramPanchayat!=null) {
  //     body['gp_id']='${selectedGramPanchayat.name}';
  //   }
  //   if(selectedVillage!=null) {
  //     body['village_id']='${selectedVillage.name}';
  //   }
  //   if(selectedCreche!=null) {
  //     body['creche_id']='${selectedCreche.name}';
  //   }
  //
  //
  //   // print('body $body');
  //   // var itemBody=jsonEncode(body);
  //   print("start time ${Validate().currentDateTime()}");
  //   try {
  //     var response = await dio.post(
  //     Uri.parse(endurl),
  //   data: body,
  //   options: dio.Options(headers: headers));
  //     // print(response.body);
  //     print("end time ${Validate().currentDateTime()}");
  //     return response;
  //   } catch (e) {
  //     print('Internal server error: ${e}');
  //     return dio.Response('Internal server error - $e', 500);
  //   }
  // }

  Future<http.Response> callDashboardCardDetailsApi(
      String? userName,
      String query_type,
      String year,
      String month,
      OptionsModel? selectedState,
      OptionsModel? selectedDistrict,
      OptionsModel? selectedBlock,
      OptionsModel? selectedGramPanchayat,
      OptionsModel? selectedVillage,
      OptionsModel? selectedCreche,
      String token) async {
    var endurl =
        '${Constants.baseUrl}method/frappe.val.ph_report_card_detail.fetch_card_data';
    var headers = {
      'Authorization': token,
      // 'Content-Type': 'application/json'
    };
    Map<String, String> body = {
      "year": year,
      "month": month,
      // "supervisor_id": userName!,
      "query_type": query_type
    };

    if (selectedState != null) {
      body['state_id'] = '${selectedState.name}';
    }
    if (selectedDistrict != null) {
      body['district_id'] = '${selectedDistrict.name}';
    }
    if (selectedBlock != null) {
      body['block_id'] = '${selectedBlock.name}';
    }
    if (selectedGramPanchayat != null) {
      body['gp_id'] = '${selectedGramPanchayat.name}';
    }
    if (selectedVillage != null) {
      body['village_id'] = '${selectedVillage.name}';
    }
    if (selectedCreche != null) {
      body['creche_id'] = '${selectedCreche.name}';
    }
    print('body $body');
    try {
      var response =
          await http.post(Uri.parse(endurl), headers: headers, body: body);
      print(response.body);

      return response;
    } catch (e) {
      print('Internal server error: ${e}');
      return http.Response('Internal server error - $e', 500);
    }
  }
}
