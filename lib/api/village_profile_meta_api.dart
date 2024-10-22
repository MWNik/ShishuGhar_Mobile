import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../utils/constants.dart';
import '../utils/validate.dart';

class VillageProfileMetaApi {
  Future<Response> callVillageProfileMeta(
      String username, String pwd, String token) async {
    var endurl = '${Constants.baseUrl}method/village_profile_meta';
    var headers = {'Authorization': token}; 
    Map<String, String> body = {"usr": username, "pwd": pwd};
    var response =
        await http.post(Uri.parse(endurl), headers: headers, body: body);
    print(response.body);
    try {
      return response;
    } catch (e) {
      print('Internal server error: ${e}');
      return Response('Internal server error - $e', 500);
    }
  }

  Future<Response> VillageProfileDownloadApi(
      String username, String pwd, String token) async {
    var url = Uri.parse('${Constants.baseUrl}method/village_profile_data');
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

  Future<Response> VillageProfileDownloadApiCC(
      String villageId,String username, String pwd, String token) async {
    var url = Uri.parse('${Constants.baseUrl}method/village_profile_data_village');
    var headers = {'Authorization': token, 'Content-Type': 'application/json'};
    List<int> integerList = villageId.split(',').map(int.parse).toList();
    Map<String, dynamic> parameters = {
      "village_id": integerList,
      "usr": username,
      "pwd": pwd
    };
    try {
      var responce = await http.post(url, headers: headers, body: jsonEncode(parameters));
      print(responce.body);
      return responce;
    } catch (e) {
      return Response('Internal server error - $e', 500);
    }
  }

  Future<http.Response> callVillageUploadUdate(
      String token, String responce, int? name) async {
    var url = Uri.parse('${Constants.baseUrl}resource/Village/$name');

    var headers = {'Authorization': token};

    print('PARAMETER FOR CHILD PROFILE DATA: $responce');

    try {
      await Validate().createUploadedJson("Token $token\n\n$responce");
      var response = await http.put(url, body: responce, headers: headers);
      return response;
    } catch (e) {
      print('Exception caught: $e');
      return http.Response('Error uploading cashBookdata', 500);
    }
  }

  Future<http.Response> villageProfileUpload(
      String token, String responce) async {
    var url = Uri.parse('${Constants.baseUrl}resource/Village');

    var headers = {'Authorization': token};

    print('PARAMETER FOR CHILD PROFILE DATA: $responce');

    try {
      await Validate().createUploadedJson("Token $token\n\n$responce");
      var response = await http.put(url, body: responce, headers: headers);
      return response;
    } catch (e) {
      print('Exception caught: $e');
      return http.Response('Error uploading cashBookdata', 500);
    }
  }
}
