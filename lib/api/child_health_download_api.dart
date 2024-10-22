import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../utils/constants.dart';

class ChildHealthDataDownloadApi {
  Future<Response> childHealthDataDownload(
      String username, String pwd, String token) async {
    var url = Uri.parse('${Constants.baseUrl}method/child_health_data');
    var headers = {'Authorization': token};
    Map<String, String> parameters = {
      'usr': username.trim(),
      'pwd': pwd.trim(),
    };
    try {
      var responce = await http.post(url, headers: headers, body: parameters);
      print(responce.body);
      return responce;
    } catch (e) {
      return Response('Internal server error - $e', 500);
    }
  }

  Future<Response> childHealthDataDownloadCC(
      String villageId, String username, String pwd, String token) async {
    var url = Uri.parse('${Constants.baseUrl}method/child_health_data_village');
    var auth = {'Authorization': token, 'Content-Type': 'application/json'};
    List<int> integerList = villageId.split(',').map(int.parse).toList();
    Map<String, dynamic> parameters = {
      "village_id": integerList,
      "usr": username,
      "pwd": pwd
    };

    try {
      var raw = jsonEncode(parameters);
      var responce = await http.post(url, headers: auth, body: raw);
      print(responce.body);
      return responce;
    } catch (e) {
      return Response('Internal server error - $e', 500);
    }
  }
}
