import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../utils/constants.dart';

class AttendanceMetaApi {
  Future<Response> callAttendanceData(
      String username, String pwd, String token) async {

    var endurl = '${Constants.baseUrl}method/attendance_meta';
    var headers = {'Authorization': token};
    Map<String, String> body = {"usr": username, "pwd": pwd};
    try {
      var response =
          await http.post(Uri.parse(endurl), headers: headers, body: body);
      print(response.body);

      return response;
    } catch (e) {
      print('Internal server error: ${e}');
      return Response('Internal server error - $e', 500);
    }
  }
}
