import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../utils/constants.dart';

class ChildGrievanceDataDownloadApi {
  Future<Response> childGrievanceDataDownload(
      String username, String pwd, String token) async {
    var url = Uri.parse('${Constants.baseUrl}method/grievance_data');
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
