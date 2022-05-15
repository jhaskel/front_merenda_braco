
import 'package:http/http.dart' as http;
import 'package:merenda_escolar/app_model.dart';
import 'package:merenda_escolar/pages/login/usuario.dart';

Future<http.Response> get(context, String url) async {
  final headers = await _headers(context);
  var response = await http.get(url, headers: headers);
  return response;
}

Future<http.Response> post(context, String url, {body}) async {
  final headers = await _headers(context);
  var response = await http.post(url, body: body, headers: headers);
  return response;
}

Future<http.Response> put(context, String url, {body}) async {
  final headers = await _headers(context);
  var response = await http.put(url, body: body, headers: headers);
  return response;
}

Future<http.Response> delete(context, String url) async {
  final headers = await _headers(context);
  var response = await http.delete(url,headers: headers);
  return response;
}

Future<Map<String, String>> _headers(context) async {
  Usuario user = AppModel.get(context).user;

  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Authorization": "Bearer ${user.token}"
  };
  print(headers);
  return headers;
}

