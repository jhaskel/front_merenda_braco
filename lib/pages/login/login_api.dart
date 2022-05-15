import 'dart:convert';

import 'package:merenda_escolar/constants.dart';
import 'package:merenda_escolar/pages/login/login_bloc.dart';
import 'package:merenda_escolar/pages/login/usuario.dart';

import 'package:merenda_escolar/utils/api_response.dart';
import 'package:http/http.dart' as http;

class LoginApi {
  static Future<ApiResponse<Usuario>> login(LoginInput input) async {
    try {
      var url = '$BASE_URL/login';

      Map<String, String> headers = {"Content-Type": "application/json"};
      String body = input.toJson();
      print(">> $body");

      var response = await http.post(url, body: body, headers: headers);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      Map mapResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        final user = Usuario.fromMap(mapResponse);

        return ApiResponse.ok(result: user);
      }

      return ApiResponse.error(msg: mapResponse["error"]);
    } catch (error, exception) {
      print("Erro no login $error > $exception");

      return ApiResponse.error(msg: "Não foi possível fazer o login.");
    }
  }
}
