import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:merenda_escolar/constants.dart';
import 'package:merenda_escolar/pages/email/Email.dart';
import 'package:merenda_escolar/utils/api_response.dart';

class EmailApi {
  static Future<ApiResponse<bool>>save(Email c ) async {
    try {
      String url = "https://app-merenda.herokuapp.com/email";
        c.id = 1;
      Map<String,String> headers = {
        "Content-Type": "application/json"
      };

      print("POST > $url");

      String json = c.toJson();

      print("JSON > $json");

      var response = await http.post(url, body: json,headers: headers);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 500) {

        return ApiResponse.error();

      }
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("passou no if response.statusCode == 200 || response.statusCode == 201 e printou");

        Map mapResponse = convert.json.decode(response.body);

        Email usuario = Email.fromMap(mapResponse);

        print("Novo usuario: ${usuario.id}");

        return ApiResponse.ok();
      }

      if (response.body == null || response.body.isEmpty) {
        return ApiResponse.error();
      }

      Map mapResponse = convert.json.decode(response.body);
      return ApiResponse.error();
    } catch (e) {
      print(e);
      return ApiResponse.error();
    }
  }

}
