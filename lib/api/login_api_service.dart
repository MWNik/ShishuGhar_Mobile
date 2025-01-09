import 'package:http/http.dart';
import 'package:http/http.dart' as http;

import '../utils/constants.dart';

class LoginApiService {


  Future<Response> loginUser(
      String username, String pwd, String deviceId, String appVersion) async {
    var endurl = '${Constants.baseUrl}method/frappe.val.api.login';
    final body = {
      "usr": username.trim(),
      "pwd": pwd.trim(),
      "app_device_id": deviceId.trim(),
      "app_device_version": appVersion.trim()
    };

    try {
      var response = await http.post(Uri.parse(endurl), body: body);
      print(response.body);
      return response;
    } catch (e) {
      print('Internal server error: ${e}');
      return Response('Internal server error - $e', 500);
    }
  }

  Future<Response> changeDeviceId(
      String username, String pwd, String deviceId, String appVersion) async {
    var deviceChnageUrl =
        '${Constants.baseUrl}method/frappe.val.api.update_device_id';
    final body = {
      "usr": username.trim(),
      "pwd": pwd.trim(),
      "app_device_id": deviceId.trim(),
      "app_device_version": appVersion.trim()
    };

    try {
      var response = await http.post(Uri.parse(deviceChnageUrl), body: body);
      return response;
    } catch (e) {
      return Response("Internal server error = $e", 500);
    }
  }
}
