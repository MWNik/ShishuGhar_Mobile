import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../utils/constants.dart';

class CrecehDataDownloadApi {
  Future<Response> crechedatadownloadapi(
      String username, String pwd, String token) async {
    var url = Uri.parse('${Constants.baseUrl}method/creche_data');
    var headers = {'Authorization': token};
    Map<String, String> parameters = {
      'usr': username,
      'pwd': pwd,
    };
    try {
      var responce = await http.post(url, headers: headers, body: parameters);
      return responce;
    } catch (e) {
      return Response('Internal server error - $e', 500);
    }
  }

  Future<Response> crechedatadownloadapiCC(
      String villageId, String username, String pwd, String token) async {
    var url = Uri.parse('${Constants.baseUrl}method/creche_data_village');
    var headers = {'Authorization': token, 'Content-Type': 'application/json'};
    List<int> integerList = villageId.split(',').map(int.parse).toList();
    Map<String, dynamic> parameters = {
      'village_id': integerList,
      'usr': username,
      'pwd': pwd,
    };
    try {
      var responce = await http.post(url, headers: headers, body: jsonEncode(parameters));
      return responce;
    } catch (e) {
      return Response('Internal server error - $e', 500);
    }
  }
}
