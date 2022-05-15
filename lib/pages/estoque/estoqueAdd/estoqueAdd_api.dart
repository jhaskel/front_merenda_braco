import 'dart:convert' as convert;

import 'package:merenda_escolar/constants.dart';

import 'package:merenda_escolar/pages/estoque/estoqueAdd/EstoqueAdd.dart';
import 'package:merenda_escolar/utils/api_response.dart';

import 'package:merenda_escolar/utils/http_helper.dart' as http;

class EstoqueAddApi {


  static Future<ApiResponse<bool>> save(context, EstoqueAd c) async {
    try {
      var url = "$BASE_URL/estoqueAdd";
      if (c.id != null) {
        url += "/${c.id}";
      }
      print("URL $url");

      String json = c.toJson();


      var response = await (c.id == null
          ? http.post( context,url, body: json)
          : http.put(context,url, body: json));

      if (response.statusCode == 200 || response.statusCode == 201) {

        print("body ${response.body}");
        return ApiResponse.ok();
      }

      Map mapResponse = convert.json.decode(response.body);
      return ApiResponse.error(msg: mapResponse["error"]);
    } catch (e) {

      return ApiResponse.error(msg: "Não foi possível salvar o estoque");
    }
  }


  static Future<ApiResponse> delete(context, EstoqueAd c) async {
    try {
      String url = "$BASE_URL/estoqueAdd/${c.id}";

      var response = await http.delete(context, url);


      if (response.statusCode == 200) {
        Map mapResponse = convert.json.decode(response.body);
        return ApiResponse.ok(msg: mapResponse["msg"]);
      }
    } catch (e) {

    }

    return ApiResponse.error(msg: "Não foi possível deletar a estoque");
  }

}
