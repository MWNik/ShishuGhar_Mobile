import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../utils/constants.dart';

class CrecheMonetringCheckListCBMApi {
  Future<Response> cmcCBMMetaApi(
      String username, String pwd, String token) async {
    var url = Uri.parse(
        '${Constants.baseUrl}method/creche_monitoring_checklist_cbm_meta');
    var headers = {'Authorization': token};
    Map<String, String> parameters = {
      'usr': username,
      'pwd': pwd,
    };
    try {
      var responce = await http.post(url, headers: headers, body: parameters);
      print(responce.body);
      return responce;
    } catch (e) {
      return Response('Internal server error - $e', 500);
    }
  }

  Future<Response> cmcCBMDownloadApi(
      String username, String pwd, String token) async {
    var url = Uri.parse(
        '${Constants.baseUrl}method/creche_monitoring_checklist_cbm_data');
    var headers = {'Authorization': token};
    Map<String, String> parameters = {
      'usr': username,
      'pwd': pwd,
    };
    try {
      var responce = await http.post(url, headers: headers, body: parameters);
      print(responce.body);
      return responce;
    } catch (e) {
      return Response('Internal server error - $e', 500);
    }
  }

  Future<http.Response> cmcCBMUpload(String token, String responce) async {
    var url = Uri.parse(
        '${Constants.baseUrl}resource/Creche Monitoring Checklist CBM');

    var headers = {'Authorization': token};

    print('PARAMETER FOR CHILD PROFILE DATA: $responce');

    try {
      var response = await http.post(url, body: responce, headers: headers);
      return response;
    } catch (e) {
      print('Exception caught: $e');
      return http.Response('Error uploading cmcCBM data', 500);
    }
  }

  Future<http.Response> cmcCBMUploadUdate(
      String token, String responce, int? name) async {
    var url = Uri.parse(
        '${Constants.baseUrl}resource/Creche Monitoring Checklist CBM/$name');
    var headers = {'Authorization': token};

    print('PARAMETER FOR CHILD PROFILE DATA: $responce');

    try {
      var response = await http.put(url, body: responce, headers: headers);
      return response;
    } catch (e) {
      print('Exception caught: $e');
      return http.Response('Error uploading cmcCBMdata', 500);
    }
  }
}
