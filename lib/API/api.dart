import 'dart:convert';

import 'package:http/http.dart' as http;

class CallAPI {
  final String url = 'http://192.168.100.2:8000/api/';
  postData(data, apiURL) async {
    var fullUrl = url + apiURL;
    return await http.post(Uri.parse(fullUrl),
        body: jsonEncode(data), headers: _setHeadersLogin());
  }

  _setHeadersLogin() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };

  getDataUser(data, apiURL) async {
    var fullUrl = url + apiURL;
    return await http.get(Uri.parse(fullUrl), headers: _setHeadersUser(data));
  }

  _setHeadersUser(data) =>
      {'Content-type': 'application/json', 'Authorization': 'Bearer $data'};
}
