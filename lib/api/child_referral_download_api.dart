import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../utils/constants.dart';

class ChildReferralDataDownloadApi {
  Future<Response> childReferralDataDownload(
      String username, String pwd, String token) async {
    var url =
        Uri.parse('${Constants.baseUrl}method/child_referral_data_download');
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

  Future<Response> childReferralDataDownloadCC(
      String villageId,String username, String pwd, String token) async {
    var url =
        Uri.parse('${Constants.baseUrl}method/child_referral_data_download_village');
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
}
