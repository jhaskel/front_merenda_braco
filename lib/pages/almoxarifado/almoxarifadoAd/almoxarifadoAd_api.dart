import 'dart:convert' as convert;
import 'package:merenda_escolar/constants.dart';
import 'package:merenda_escolar/pages/almoxarifado/almoxarifado.dart';
import 'package:merenda_escolar/pages/almoxarifado/almoxarifadoAd/almoxarifadoAd.dart';
import 'package:merenda_escolar/utils/api_response.dart';
import 'package:merenda_escolar/utils/http_helper.dart' as http;
import 'package:http/http.dart' as htttp;

class AlmoxarifadoAdApi {




  static Future<ApiResponse<bool>> save(context, AlmoxarifadoAd c) async {
    try {
      var url = "$BASE_URL/almoxarifadoAd";
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

        AlmoxarifadoAd empreendimento = AlmoxarifadoAd.fromMap(mapResponse);

        print("AlmoxarifadoAd salvo: ${empreendimento.id}");

        return ApiResponse.ok();
      }

      Map mapResponse = convert.json.decode(response.body);
      return ApiResponse.error(msg: mapResponse["error"]);
    } catch (e) {
      print(e);

      return ApiResponse.error(msg: "Não foi possível salvar o empreendimento");
    }
  }


  static Future<ApiResponse<bool>> delete(context, AlmoxarifadoAd c) async {
    try {
      String url = "$BASE_URL/almoxarifadoAd/${c.id}";

      print("DELETE > $url");

      var response = await http.delete(context,url);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');


      if (response.statusCode == 200) {
        return ApiResponse.ok() ;
      }

      return ApiResponse.error(msg: "Não foi possível deletar o brique");
    } catch (e) {
      print(e);

      return ApiResponse.error(msg: "Não foi possível deletar o brique");
    }

}}
