import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../utils/constants.dart';

class ChildEventDataDownloadApi {
  Future<Response> childEventDataDownload(
      String username, String pwd, String token) async {
    var url = Uri.parse('${Constants.baseUrl}method/child_event_data');
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

  Future<Response> childEventDataDownloadCC(
      String villageId, String username, String pwd, String token) async {
    var url = Uri.parse('${Constants.baseUrl}method/child_event_data_village');
    var headers = {'Authorization': token, 'Content-Type': 'application/json'};
    List<int> integerList = villageId.split(',').map(int.parse).toList();
    Map<String, dynamic> parameters = {
      "village_id": integerList,
      "usr": username,
      "pwd": pwd
    };
    try {
      var json=jsonEncode(parameters);
      var responce = await http.post(url, headers: headers, body: json);
      print(responce.body);
      return responce;
    } catch (e) {
      return Response('Internal server error - $e', 500);
    }
  }
}
