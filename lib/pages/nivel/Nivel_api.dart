import 'dart:convert' as convert;
import 'package:merenda_escolar/constants.dart';
import 'package:merenda_escolar/pages/nivel/Nivel.dart';

import 'package:merenda_escolar/utils/api_response.dart';
import 'package:merenda_escolar/utils/http_helper.dart' as http;


class NivelApi {
  static Future<List<Nivel>> get(context,) async {
    String url = "$BASE_URL/nivel";
    print("GET2 > $url");

    final response = await http.get( context,url);

    print("resp ${response.body}");

    String json = response.body;

    List list = convert.json.decode(json);

    List<Nivel> favoritos = list.map<Nivel>((map) =>
        Nivel.fromMap(map)).toList();
    print("jsonfaavo${json}");
    return favoritos;
  }
  static Future<List<Nivel>> getId(context,int id) async {
    String url = "$BASE_URL/nivel/id/$id";
    print("GET2 > $url");

    final response = await http.get( context,url);

    print("resp ${response.body}");

    String json = response.body;

    List list = convert.json.decode(json);

    List<Nivel> favoritos = list.map<Nivel>((map) =>
        Nivel.fromMap(map)).toList();
    print("jsonfaavo${json}");
    return favoritos;
  }
  static Future<List<Nivel>> getSetor(context,int setor) async {
    String url = "$BASE_URL/nivel/setor/$setor";
    print("GET2 > $url");
    final response = await http.get(context,url);
    print("resp ${response.body}");
    String json = response.body;
    List list = convert.json.decode(json);
    List<Nivel> favoritos = list.map<Nivel>((map) =>
        Nivel.fromMap(map)).toList();
    print("jsonfaavo${json}");
    return favoritos;
  }



  static Future<ApiResponse<bool>> save(context, Nivel c) async {
    try {
      var url = "$BASE_URL/nivel";
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
          : http.put(context, url, body: json));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map mapResponse = convert.json.decode(response.body);

        Nivel empreendimento = Nivel.fromMap(mapResponse);

        print("Nivel salvo: ${empreendimento.id}");

        return ApiResponse.ok();
      }

      Map mapResponse = convert.json.decode(response.body);
      return ApiResponse.error(msg: mapResponse["error"]);
    } catch (e) {
      print(e);

      return ApiResponse.error(msg: "Não foi possível salvar o empreendimento");
    }
  }


  static Future<ApiResponse> delete(context, Nivel c) async {
    try {
      String url = "$BASE_URL/nivel/${c.id}";

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

    return ApiResponse.error(msg: "Não foi possível deletar o empreendimento");
  }

}
