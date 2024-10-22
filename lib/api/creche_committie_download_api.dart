import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../utils/constants.dart';

class CrecheCommitteeMeetingDownloadApi {
  Future<Response> callCrecheCommitteeMeetingDownloadData(
      String username, String pwd, String token) async {
    var endurl =
        '${Constants.baseUrl}method/creche_committee_meeting_data_download';
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

  Future<Response> callCrecheCommitteeMeetingDownloadDataCC(
      String blockId,String username, String pwd, String token) async {
    var endurl =
        '${Constants.baseUrl}method/creche_committee_meeting_data_download_village';
    var headers = {'Authorization': token, 'Content-Type': 'application/json'};
    List<int> integerList = blockId.split(',').map(int.parse).toList();
    Map<String, dynamic> parameters = {
      "village_id": integerList,
      "usr": username,
      "pwd": pwd
    };
    var response =
        await http.post(Uri.parse(endurl), headers: headers, body: jsonEncode(parameters));
    print(response.body);
    try {
      return response;
    } catch (e) {
      print('Internal server error: ${e}');
      return Response('Internal server error - $e', 500);
    }
  }
}
