import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../utils/constants.dart';

class ChildAttendanceDataDownloadApi {
  Future<Response> childAttendanceDataDownload(String token,String username,String pwd) async {
    var url = Uri.parse('${Constants.baseUrl}method/child_attendance');
    var headers = {'Authorization': token};
    Map<String, String> parameters = {
      'usr': username.trim(),
      'pwd': pwd.trim(),
    };
    try {
      var responce = await http.post(url, headers: headers,body: parameters);
      print(responce.body);
      return responce;
    } catch (e) {
      return Response('Internal server error - $e', 500);
    }
  }
}
