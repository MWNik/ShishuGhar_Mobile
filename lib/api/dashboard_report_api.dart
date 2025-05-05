import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shishughar/model/dynamic_screen_model/options_model.dart';
import '../utils/constants.dart';
import '../utils/globle_method.dart';

class DashboardReportApi {
  Future<Response> callDashboardReportApi(
      String year, String month,String crecheId, String token)
  async {

    var endurl = '${Constants.baseUrl}method/frappe.val.app_dashboard.app_dashboard';
    var headers = {'Authorization': token};

    Map<String, String> body = {"year": year, "month": month, "creche": crecheId};
    try {
      var response =
          await http.post(Uri.parse(endurl), headers: headers, body: body);
      print(response.body);

      return response;
    } catch (e) {
      print('Internal server error: ${e}');
      return Response('Internal server error - $e', 500);
    }
  }

  Future<Response> callDashboardSupReportApi(
      String year, String month,OptionsModel? selectedState, OptionsModel? selectedDistrict, OptionsModel? selectedBlock,
      OptionsModel? selectedGramPanchayat, OptionsModel? selectedVillage, OptionsModel? selectedCreche, String token)
  async {

    var endurl = '${Constants.baseUrl}method/frappe.val.ph_report_card.dashboard_section_one';
    var headers = {'Authorization': token};
    Map<String, String> body = {"year": year, "month": month};

    if(selectedState!=null) {
      body['state_id']='${selectedState.name}';
    }
    if(selectedDistrict!=null) {
      body['district_id']='${selectedDistrict.name}';
    }
    if(selectedBlock!=null) {
      body['block_id']='${selectedBlock.name}';
    }
    if(selectedGramPanchayat!=null) {
      body['gp_id']='${selectedGramPanchayat.name}';
    }
    if(selectedVillage!=null) {
      body['village_id']='${selectedVillage.name}';
    }
    if(selectedCreche!=null) {
      body['creche_id']='${selectedCreche.name}';
    }
    print('body $body');
    try {
      var response =
      await http.post(Uri.parse(endurl), headers: headers, body: body);
      print(response.body);

      return response;
    } catch (e) {
      print('Internal server error: ${e}');
      return Response('Internal server error - $e', 500);
    }
  }

  Future<Response> callDashboardCardDetailsApi(
      String query_type,String year, String month,OptionsModel? selectedState, OptionsModel? selectedDistrict, OptionsModel? selectedBlock,
      OptionsModel? selectedGramPanchayat, OptionsModel? selectedVillage, OptionsModel? selectedCreche, String token)
  async {

    var endurl = '${Constants.baseUrl}method/frappe.val.ph_report_card_detail.fetch_card_data';
    var headers = {'Authorization': token};
    Map<String, String> body = {"year": year, "month": month, "query_type": query_type};

    if(selectedState!=null) {
      body['state_id']='${selectedState.name}';
    }
    if(selectedDistrict!=null) {
      body['district_id']='${selectedDistrict.name}';
    }
    if(selectedBlock!=null) {
      body['block_id']='${selectedBlock.name}';
    }
    if(selectedGramPanchayat!=null) {
      body['gp_id']='${selectedGramPanchayat.name}';
    }
    if(selectedVillage!=null) {
      body['village_id']='${selectedVillage.name}';
    }
    if(selectedCreche!=null) {
      body['creche_id']='${selectedCreche.name}';
    }
    print('body $body');
    try {
      var response =
      await http.post(Uri.parse(endurl), headers: headers, body: body);
      print(response.body);

      return response;
    } catch (e) {
      print('Internal server error: ${e}');
      return Response('Internal server error - $e', 500);
    }
  }



}
