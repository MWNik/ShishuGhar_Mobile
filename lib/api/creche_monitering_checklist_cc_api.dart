import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../utils/constants.dart';

class CrecheMonetringCheckListCCApi {
  Future<Response> cmcCCMetaApi(
      String username, String pwd, String token) async {
    var url = Uri.parse(
        '${Constants.baseUrl}method/creche_monitoring_checklist_cc_meta');
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

  Future<Response> cmcCCDownloadApi(
      String username, String pwd, String token) async {
    var url = Uri.parse(
        '${Constants.baseUrl}method/creche_monitoring_checklist_cc_data');
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

  Future<http.Response> cmcCCUpload(String token, String responce) async {
    var url = Uri.parse(
        '${Constants.baseUrl}resource/Creche Monitoring Checklist CC');

    var headers = {'Authorization': token};

    print('PARAMETER FOR CHILD PROFILE DATA: $responce');

    try {
      var response = await http.post(url, body: responce, headers: headers);
      return response;
    } catch (e) {
      print('Exception caught: $e');
      return http.Response('Error uploading cmcALM data', 500);
    }
  }

  Future<http.Response> cmcCCUploadUdate(
      String token, String responce, int? name) async {
    var url = Uri.parse(
        '${Constants.baseUrl}resource/Creche Monitoring Checklist CC/$name');
    var headers = {'Authorization': token};

    print('PARAMETER FOR CHILD PROFILE DATA: $responce');

    try {
      var response = await http.put(url, body: responce, headers: headers);
      return response;
    } catch (e) {
      print('Exception caught: $e');
      return http.Response('Error uploading cmcALMdata', 500);
    }
  }
}
