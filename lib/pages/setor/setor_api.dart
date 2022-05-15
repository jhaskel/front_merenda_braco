import 'dart:convert' as convert;

import 'package:merenda_escolar/constants.dart';
import 'package:merenda_escolar/pages/setor/Setor.dart';
import 'package:merenda_escolar/utils/api_response.dart';

import 'package:merenda_escolar/utils/http_helper.dart' as http;

class SetorApi {
  static Future<List<Setor>> get(context,) async {
    String url = "$BASE_URL/setor";
    print("GET2 > $url");
    final response = await http.get(context,url);
    print("resp ${response.body}");
    String json = response.body;
    List list = convert.json.decode(json);
    List<Setor> favoritos = list.map<Setor>((map) =>
        Setor.fromMap(map)).toList();
    print("jsonfaavo${json}");
    return favoritos;
  }

   static Future<List<Setor>> getId(context,int id) async {
    String url = "$BASE_URL/setor/id/$id";
    print("GET2 > $url");
    final response = await http.get(context,url);
    print("resp ${response.body}");
    String json = response.body;
    List list = convert.json.decode(json);
    List<Setor> favoritos = list.map<Setor>((map) =>
        Setor.fromMap(map)).toList();
    print("jsonfaavo${json}");
    return favoritos;
  }


  static Future<ApiResponse<bool>> save(context, Setor c) async {
    try {
      var url = "$BASE_URL/setor";
      if (c.id != null) {
        url += "/${c.id}";      }

      print("POST > $url");
      String json = c.toJson();
      print("JSON > $json");

      var response = await (c.id == null
          ? http.post(context, url, body: json)
          : http.put(context,url, body: json));

      if (response.statusCode == 200 || response.statusCode == 201) {

        return ApiResponse.ok();
      }

      Map mapResponse = convert.json.decode(response.body);
      return ApiResponse.error(msg: mapResponse["error"]);
    } catch (e) {
      print(e);

      return ApiResponse.error(msg: "Não foi possível salvar a categoria");
    }
  }


  static Future<ApiResponse> delete(context, Setor c) async {
    try {
      String url = "$BASE_URL/setor/${c.id}";
      var response = await http.delete( context,url);

      if (response.statusCode == 200) {
        Map mapResponse = convert.json.decode(response.body);
        return ApiResponse.ok(msg: mapResponse["msg"]);
      }
    } catch (e) {

    }

    return ApiResponse.error(msg: "Não foi possível deletar a categoria");
  }

}
