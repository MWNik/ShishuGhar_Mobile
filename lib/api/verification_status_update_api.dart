import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../utils/constants.dart';





class VerificationStatusUpdateApi {

  Future<Response> callVerificationStatusApi(String villageId,String username, String pwd, String token) async {
    var url = Uri.parse(
        '${Constants.baseUrl}method/hh_verification');
    var headers = {'Authorization': token};
    Map<String, String> parameters = {
      'village_id': villageId.trim(),
      'usr': username.trim(),
      'pwd': pwd.trim(),
    };
    try {
      var response = await http.post(url, headers: headers, body: parameters);
      return response;

    } catch (e) {
      print('Internal server error: ${e}');
      return Response('Internal server error - $e', 500);
    }
  }


}