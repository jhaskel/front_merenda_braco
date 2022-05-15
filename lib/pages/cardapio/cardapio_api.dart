import 'dart:convert' as convert;

import 'package:merenda_escolar/constants.dart';
import 'package:merenda_escolar/pages/cardapio/Cardapio.dart';
import 'package:merenda_escolar/utils/api_response.dart';
import 'package:merenda_escolar/utils/http_helper.dart' as http;
import 'package:http/http.dart' as htttp;

class CardapioApi {
  static Future<List<Cardapio>> get(context) async {
    String url = "$BASE_URL/cardapio";
    final response = await htttp.get(url);
    String json = response.body;
    List list = convert.json.decode(json);
    List<Cardapio> favoritos =
        list.map<Cardapio>((map) => Cardapio.fromMap(map)).toList();

    return favoritos;
  }

  static Future<ApiResponse<bool>> save(context, Cardapio c) async {
    try {
      var url = "$BASE_URL/cardapio";
      if (c.id != null) {
        url += "/${c.id}";
      }
      String json = c.toJson();

      var response = await (c.id == null
          ? http.post(context,url, body: json)
          : http.put(context,url, body: json));
      if (response.statusCode == 200 || response.statusCode == 201) {

        return ApiResponse.ok();
      }

      Map mapResponse = convert.json.decode(response.body);
      return ApiResponse.error(msg: mapResponse["error"]);
    } catch (e) {


      return ApiResponse.error(msg: "Não foi possível salvar o empreendimento");
    }
  }

  static Future<ApiResponse> delete(context, Cardapio c) async {
    try {
      String url = "$BASE_URL/cardapio/${c.id}";



      var response = await http.delete(context,url);


      if (response.statusCode == 200) {
        Map mapResponse = convert.json.decode(response.body);
        return ApiResponse.ok(msg: mapResponse["msg"]);
      }
    } catch (e) {

    }

    return ApiResponse.error(msg: "Não foi possível deletar o empreendimento");
  }
}
