import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../utils/constants.dart';

class ChildImmunizationDataDownloadApi {
  Future<Response> childImmunizationDataDownload(
      String token, String username, String pwd) async {
    var url = Uri.parse('${Constants.baseUrl}method/child_immunization_data');
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
}
