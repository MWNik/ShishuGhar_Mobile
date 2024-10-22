import 'dart:convert';

import 'package:http/http.dart' as http;

import '../utils/constants.dart';
import '../utils/validate.dart';

class CrecheCheckInApi {
  Future<http.Response> checkInMeta(
      String username, String pwd, String token) async {
    var url = Uri.parse('${Constants.baseUrl}method/checkin_meta');
    var headers = {'Authorization': token};
    Map<String, String> parameters = {
      'usr': username.trim(),
      'pwd': pwd.trim(),
    };
    try {
      var response = await http.post(url, headers: headers, body: parameters);
      print('RESPONSE BODY FOR CHECKIN META: ${response.body}');
      return response;
    } catch (e) {
      print('Internal server error: ${e}');
      return http.Response('Internal server error - $e', 500);
    }
  }

  Future<http.Response> checkInUpload(String token, String responce) async {
    var url = Uri.parse('${Constants.baseUrl}resource/Creche Check In');
    var headers = {'Authorization': token};
    print('JSON BODY FOR CHECK IN: $responce');
    try {
      await Validate().createUploadedJson("Token $token\n\n$responce");
      var response = await http.post(url, body: responce, headers: headers);
      print('API response body: ${response.body}');
      return response;
    } catch (e) {
      print('EXCETION CAUGHT: $e');
      return http.Response('Error uploading creche check in data', 500);
    }
  }

  Future<http.Response> callDownloadCreCheCheckINApi(
      String username, String pwd, String token) async {
    var url = Uri.parse('${Constants.baseUrl}method/checkin_data');
    var headers = {'Authorization': token};

    Map<String, String> parameters = {
      'usr': username.trim(),
      'pwd': pwd.trim(),
    };
    try {
      var response = await http.post(url, headers: headers, body: parameters);
      print(response.body);
      return response;
    } catch (e) {
      print('Internal server error: ${e}');
      return http.Response('Internal server error - $e', 500);
    }
  }

  Future<http.Response> callDownloadCreCheCheckINApiCC(
      String villageId, String username, String pwd, String token) async {
    var url = Uri.parse('${Constants.baseUrl}method/checkin_data_village');
    var headers = {'Authorization': token, 'Content-Type': 'application/json'};
    List<int> integerList =villageId.split(',').map(int.parse).toList();
    Map<String, dynamic> parameters = {
      'village_id': integerList,
      'usr': username.trim(),
      'pwd': pwd.trim(),
    };
    try {
      var response = await http.post(url, headers: headers, body: jsonEncode(parameters));
      print(response.body);
      return response;
    } catch (e) {
      print('Internal server error: ${e}');
      return http.Response('Internal server error - $e', 500);
    }
  }
}
