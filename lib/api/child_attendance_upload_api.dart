
import 'package:http/http.dart' as http;

import '../utils/constants.dart';


import '../utils/validate.dart';

class ChildAttendanceUploadApi {
  Future<http.Response> AttendanceUpload(String token, String responce) async {
    var url =
        Uri.parse('${Constants.baseUrl}method/frappe.val.api.child_attendance');
    var headers = {'Authorization': token, 'Content-Type': 'application/json'};

    print('PARAMETER FOR CHILD PROFILE DATA: $responce');
    // Map<String, dynamic> body = {
    //   'data': responce,
    // };
    // String json=jsonEncode(responce);

    try {
      await Validate().createUploadedJson("Token $token\n\n$responce");
      var response = await http.post(url, body: responce, headers: headers);
      print('Exception caught: ${response.body}');
      return response;
    } catch (e) {
      print('Exception caught: $e');
      return http.Response('Error uploading child profile data', 500);
    }
  }
  // Future<http.Response> AttendanceUpload(String token, String responce) async {
  //   var url =
  //       Uri.parse('${Constants.baseUrl}resource/Child Attendance');
  //   var headers = {'Authorization': token, 'Content-Type': 'application/json'};

  //   print('PARAMETER FOR CHILD PROFILE DATA: $responce');
  //   // Map<String, dynamic> body = {
  //   //   'data': responce,
  //   // };
  //   // String json=jsonEncode(responce);

  //   try {
  //     await Validate().createUploadedJson("Token $token\n\n$responce");
  //     var response = await http.post(url, body: responce, headers: headers);
  //     print('Exception caught: ${response.body}');
  //     return response;
  //   } catch (e) {
  //     print('Exception caught: $e');
  //     return http.Response('Error uploading child profile data', 500);
  //   }
  // }

  Future<http.Response> childAttendanceUpload(
      String token, String responce, int? name) async {
    var url = Uri.parse('${Constants.baseUrl}resource/Child Attendance/$name');
    var headers = {'Authorization': token};

    print('PARAMETER FOR CHILD PROFILE DATA: $responce');

    try {
      await Validate().createUploadedJson("Token $token\n\n$responce");
      var response = await http.put(url, body: responce, headers: headers);
      return response;
    } catch (e) {
      print('Exception caught: $e');
      return http.Response('Error uploading child profile data', 500);
    }
  }
}
