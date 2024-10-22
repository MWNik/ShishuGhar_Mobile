import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../utils/constants.dart';

class DownloadDataApi {
  Future<Response> callVillageFilterDataApi(
      String villageId, String username, String pwd, String token) async {
    var url = Uri.parse('${Constants.baseUrl}method/hh_village_filter');
    var headers = {'Authorization': token};
    Map<String, String> parameters = {
      'village_id': villageId.trim(),
      'usr': username.trim(),
      'pwd': pwd.trim(),
    };
    try {
      var response = await http.post(url, headers: headers, body: parameters);
      print(response.body);
      return response;
    } catch (e) {
      print('Internal server error: ${e}');
      return Response('Internal server error - $e', 500);
    }
  }

  Future<Response> callVillagesDataDownload(
      String villageId, String username, String pwd, String token) async {
    var url = Uri.parse('${Constants.baseUrl}method/hh_mvillage_filter');
    var headers = {'Authorization': token, 'Content-Type': 'application/json'};
    List<int> integerList = villageId.split(',').map(int.parse).toList();
    Map<String, dynamic> parameters = {
      'village_id': integerList,
      'usr': username.trim(),
      'pwd': pwd.trim(),
    };
    try {
      var response =
          await http.post(url, headers: headers, body: jsonEncode(parameters));
      print('responce body: ${response.body}');
      print(response.body);
      return response;
    } catch (e) {
      print('Internal server error: ${e}');
      return Response('Internal server error - $e', 500);
    }
  }

  Future<Response> callVillagesDataDownloadCC(
      String villagesss, String username, String pwd, String token) async {
    var url = Uri.parse('${Constants.baseUrl}method/hh_mvillage_filter');
    var headers = {'Authorization': token, 'Content-Type': 'application/json'};
    List<int> integerList = villagesss.split(',').map(int.parse).toList();
    Map<String, dynamic> parameters = {
      'village_id': integerList,
      'usr': username.trim(),
      'pwd': pwd.trim(),
    };
    try {
      var response =
          await http.post(url, headers: headers, body: jsonEncode(parameters));
      print('responce body: ${response.body}');
      print(response.body);
      return response;
    } catch (e) {
      print('Internal server error: ${e}');
      return Response('Internal server error - $e', 500);
    }
  }
}
