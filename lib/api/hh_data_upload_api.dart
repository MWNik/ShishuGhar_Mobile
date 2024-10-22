import 'dart:convert';

import 'package:http/http.dart';
import 'package:http/http.dart' as http;

import '../utils/constants.dart';
import '../utils/validate.dart';

class HHDataUploadApi {
  Future<Response> uploadHHData(String token, Map<String, dynamic> data) async {
    String endurl = '${Constants.baseUrl}resource/Household%20Form';

    var headers = {'Authorization': token, 'Content-Type': 'application/json'};
    Map<String, dynamic> body = {
      'data': data,
    };
    String json = jsonEncode(body);
    print("upload json $json");
    await Validate().createUploadedJson("Token $token\n\n$json");
    try {
      var response =
          await http.post(Uri.parse(endurl), headers: headers, body: json);
      print("body res ${response.body}");
      return response;
    } catch (e) {
      print('Internal server error: ${e}');
      return Response('Internal server error - $e', 500);
    }
  }

  // Future<Response> uploadHHDataUpdate(
  //   String token,int id,Map<String, dynamic> data ) async {
  //   String endurl = '${Constants.baseUrl}resource/Household%20Form/$id';
  //   var headers = {
  //     'Authorization': token,
  //     // 'Authorization': 'token a3599d5dd4e01ed:26b64e7ea8555e7',
  //     'Content-Type': 'application/json'};
  //   // Map<String, dynamic> body = {
  //   //   'data': data,
  //   // };
  //   String json=jsonEncode(data);
  //   print("upload json $json");
  //   try {
  //     var response = await http.put(Uri.parse(endurl), headers: headers, body: json);
  //     print("body res ${response.body}");
  //     return response;
  //
  //   } catch (e) {
  //     print('Internal server error: ${e}');
  //     return Response('Internal server error - $e', 500);
  //   }
  // }

  Future<Response> uploadHHDataUpdate(String token, int id,
      Map<String, dynamic> data, List<dynamic> childrenList) async {
    String endurl = '${Constants.baseUrl}resource/Household%20Form/$id';
    var headers = {
      'Authorization': token,
      // 'Authorization': 'token a3599d5dd4e01ed:26b64e7ea8555e7',
      'Content-Type': 'application/json'
    };
    // Map<String, dynamic> body = {
    //   'data': data,
    // };
    String json = jsonEncode(data); //HH data in json format
    print("upload json $json");
    await Validate().createUploadedJson("Token $token\n\n$json");
    try {
      bool proceed = true;
      for (var element in childrenList) {
        
        if (element['name'] != null) {
          var reasponceChildren = await uploadChildrenDataUpdate(token,
              element['name'], element); //child data passed in json format
          if (reasponceChildren.statusCode != 200) {
            proceed = false;
            break;
          }
        } else {
          element['parent'] = data['name'];
          element['parentfield'] = 'children';
          element['parenttype'] = 'Household Form';
          element['doctype'] = 'Household Child Form';
          var reasponceChildren = await uploadHHChildrenData(token, element);
          if (reasponceChildren.statusCode != 200) {
            proceed = false;
            break;
          }
        }
      }
      if (proceed) {
        var response =
            await http.put(Uri.parse(endurl), headers: headers, body: json);
        print("body res ${response.body}");
        return response;
      } else {
        return Response('Internal server error - ', 500);
      }
    } catch (e) {
      print('Internal server error: ${e}');
      return Response('Internal server error - $e', 500);
    }
  }

  Future<Response> uploadHHDataUpdatewithSequence(
      String token,
      int id,
      Map<String, dynamic> data,
      List<dynamic> childrenList,
      int sequenceType) async {
    String endurl = '${Constants.baseUrl}resource/Household%20Form/$id';
    var headers = {
      'Authorization': token,
      // 'Authorization': 'token a3599d5dd4e01ed:26b64e7ea8555e7',
      'Content-Type': 'application/json'
    };
    // Map<String, dynamic> body = {
    //   'data': data,
    // };
    String json = jsonEncode(data); //HH data in json format
    print("upload json $json");
    await Validate().createUploadedJson("Token $token\n\n$json");
    try {
      bool proceed = true;
      for (var element in childrenList) {
        if (element['name'] != null) {
          if (sequenceType == 0) {
            var reasponceChildren = await uploadChildrenDataUpdate(token,
                element['name'], element); //child data passed in json format
            if (reasponceChildren.statusCode != 200) {
              proceed = false;
              break;
            }
          }
        } else {
          element['parent'] = data['name'];
          element['parentfield'] = 'children';
          element['parenttype'] = 'Household Form';
          element['doctype'] = 'Household Child Form';
          var reasponceChildren = await uploadHHChildrenData(token, element);
          if (reasponceChildren.statusCode != 200) {
            proceed = false;
            break;
          }
        }
      }
      if (proceed) {
        var response =
            await http.put(Uri.parse(endurl), headers: headers, body: json);
        print("body res ${response.body}");
        return response;
      } else {
        return Response('Internal server error - ', 500);
      }
    } catch (e) {
      print('Internal server error: ${e}');
      return Response('Internal server error - $e', 500);
    }
  }

  Future<Response> downloadHHData(String token, int id) async {
    String endurl = '${Constants.baseUrl}resource/Household%20Form/$id';
    // var headers = {
    //   'Authorization': token,
    //   'Content-Type': 'application/json'
    // };

    print("upload json $json");
    try {
      // var response = await http.get(Uri.parse(endurl), headers: headers);
      var response = await http.get(Uri.parse(endurl));
      print("body res ${response.body}");
      return response;
    } catch (e) {
      print('Internal server error: ${e}');
      return Response('Internal server error - $e', 500);
    }
  }

  Future<Response> uploadLatestApiHHData(
      String token, Map<String, dynamic> hhData) async {
    String endurl = '${Constants.baseUrl}method/verification_update';

    var headers = {'Authorization': token, 'Content-Type': 'application/json'};

    String json = jsonEncode(hhData);
    print("upload data $json");
    await Validate().createUploadedJson("Token $token\n\n$json");
    try {
      var response =
          await http.post(Uri.parse(endurl), headers: headers, body: json);
      print("body res ${response.body}");
      return response;
    } catch (e) {
      print('Internal server error: ${e}');
      return Response('Internal server error - $e', 500);
    }
  }

  Future<Response> uploadHHChildrenData(
      String token, Map<String, dynamic> childList) async {
    String endurl = '${Constants.baseUrl}resource/Household%20Child%20Form';

    var headers = {'Authorization': token};
    String json = jsonEncode(childList);
    print("upload json $json");
    await Validate().createUploadedJson("Token $token\n\n$json");
    try {
      var response =
          await http.post(Uri.parse(endurl), headers: headers, body: json);
      print("body res ${response.body}");
      return response;
    } catch (e) {
      print('Internal server error: ${e}');
      return Response('Internal server error - $e', 500);
    }
  }

  Future<Response> uploadChildrenDataUpdate(
      String token, int id, Map<String, dynamic> childrenList) async {
    String endurl = '${Constants.baseUrl}resource/Household%20Child%20Form/$id';
    var headers = {
      'Authorization': token,
    };
    childrenList.remove('name');
    String json = jsonEncode(childrenList);
    print("upload json $json");
    await Validate().createUploadedJson("Token $token\n\n$json");
    try {
      var response =
          await http.put(Uri.parse(endurl), headers: headers, body: json);
      print("body res ${response.body}");
      return response;
    } catch (e) {
      print('Internal server error: ${e}');
      return Response('Internal server error - $e', 500);
    }
  }
}
