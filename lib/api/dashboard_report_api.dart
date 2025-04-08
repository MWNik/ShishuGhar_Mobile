import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../utils/constants.dart';

class DashboardReportApi {
  Future<Response> callDashboardReportApi(
      String year, String month,String crecheId, String token) async {

    var endurl = '${Constants.baseUrl}method/frappe.val.app_dashboard.app_dashboard';
    var headers = {'Authorization': token};

    Map<String, String> body = {"year": year, "month": month, "creche": crecheId};
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
