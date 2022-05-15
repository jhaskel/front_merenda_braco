import 'dart:convert' as convert;
import 'package:merenda_escolar/constants.dart';
import 'package:merenda_escolar/pages/config/Config.dart';
import 'package:merenda_escolar/utils/api_response.dart';
import 'package:merenda_escolar/utils/http_helper.dart' as http;


class ConfigApi {

  static Future<List<Config>> get(context) async {
    String url = "$BASE_URL/config";
    print("GET > $url");
    final response = await http.get(context, url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body.substring(0, 50)}');

    String json = response.body;

    List list = convert.json.decode(json);

    List<Config> config = list.map<Config>((map) =>
        Config.fromMap(map)).toList();

    return config;
  }

  static Future<List<Config>> getConfigByProcesso(context,
      String processo) async {
    String url = "$BASE_URL/config/processo/$processo";

    print("GET2 > $url");

    final response = await http.get(context, url);

    String json = response.body;

    List list = convert.json.decode(json);

    List<Config> favoritos = list.map<Config>((map) =>
        Config.fromMap(map)).toList();
    print("jsonfaavo${json}");
    return favoritos;
  }

  static Future<ApiResponse<bool>> save(context, Config c) async {
    try {
      var url = "$BASE_URL/config";
      if (c.id != null) {
        url += "/${c.id}";
      }

      Map<String, String> headers = {
        "Content-Type": "application/json"
      };

      print("POST > $url");

      String json = c.toJson();

      print("JSON > $json");


      var response = await (c.id == null
          ? http.post(context, url, body: json)
          : http.put( context,url, body: json));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map mapResponse = convert.json.decode(response.body);

        Config config = Config.fromMap(mapResponse);

        print("Config salvo: ${config.id}");

        return ApiResponse.ok();
      }

      Map mapResponse = convert.json.decode(response.body);
      return ApiResponse.error(msg: mapResponse["error"]);
    } catch (e) {
      print(e);

      return ApiResponse.error(msg: "Não foi possível salvar o config");
    }
  }



  static Future<ApiResponse> delete(context, Config c) async {
    try {
      String url = "$BASE_URL/config/${c.id}";

      print("DELETE > $url");

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

    return ApiResponse.error(msg: "Não foi possível deletar o config");
  }



}
