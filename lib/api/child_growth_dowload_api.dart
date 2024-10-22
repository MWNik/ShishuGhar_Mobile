import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../utils/constants.dart';

class ChildGrowthDownloadApi {
  Future<Response> callChildGrowthData(
      String username, String pwd, String token) async {
    var endurl = '${Constants.baseUrl}method/child_growth_data';
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

  Future<Response> callChildGrowthDataCC(
      String villageId, String username, String pwd, String token) async {
    var endurl = '${Constants.baseUrl}method/child_growth_data_village';
    var headers = {'Authorization': token, 'Content-Type': 'application/json'};
    List<int> integerList = villageId.split(',').map(int.parse).toList();
    Map<String, dynamic> body = {
      "village_id": integerList,
      "usr": username,
      "pwd": pwd
    };
    var response =
        await http.post(Uri.parse(endurl), headers: headers, body: jsonEncode(body));
    print(response.body);
    try {
      return response;
    } catch (e) {
      print('Internal server error: ${e}');
      return Response('Internal server error - $e', 500);
    }
  }
}
