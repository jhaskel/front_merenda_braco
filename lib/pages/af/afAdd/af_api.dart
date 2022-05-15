import 'dart:convert' as convert;

import 'package:merenda_escolar/constants.dart';
import 'package:merenda_escolar/pages/af/afAdd/Af.dart';
import 'package:merenda_escolar/utils/api_response.dart';

import 'package:merenda_escolar/utils/http_helper.dart' as http;

class AfAddApi {

  static Future<ApiResponse<bool>> save(context, AfAdd c) async {
    try {
      var url = "$BASE_URL/afAdd";
      if (c.id != null) {
        url += "/${c.id}";
      }
      print('url: ${url}');
      String json = c.toJson();
      print("JSON > $json");
      var response = await (c.id == null
          ? http.post(context, url, body: json)
          : http.put(context,url, body: json));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse.ok();
      }
      Map mapResponse = convert.json.decode(response.body);
      return ApiResponse.error(msg: mapResponse["error"]);
    } catch (e) {
          return ApiResponse.error(msg: "Não foi possível salvar a af");
    }
  }
  static Future<ApiResponse> delete(context, AfAdd c) async {
    try {
      String url = "$BASE_URL/afAdd/${c.id}";
      print('url: ${url}');
      var response = await http.delete(context, url);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        Map mapResponse = convert.json.decode(response.body);
        return ApiResponse.ok(msg: mapResponse["msg"]);
      }
    } catch (e) {
      print(e);
    }

    return ApiResponse.error(msg: "Não foi possível deletar a af");
  }

}
