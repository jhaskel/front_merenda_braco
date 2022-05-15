import 'dart:convert' as convert;
import 'package:merenda_escolar/constants.dart';
import 'package:merenda_escolar/pages/pnae/Pnae.dart';

import 'package:merenda_escolar/utils/api_response.dart';
import 'package:merenda_escolar/utils/http_helper.dart' as http;
import 'package:http/http.dart' as htttp;


class PnaeApi {

  static Future<List<Pnae>> get(context) async {
    var ano = DateTime.now().year;
    String url = "$BASE_URL/pnae/ano/$ano";
    print("GET2 > $url");

    final response = await http.get( context,url);

    print("resp ${response.body}");

    String json = response.body;
    print("01PNAE $json");

    List list = convert.json.decode(json);
    print("02PNAE $list");
    List<Pnae> favoritos = list.map<Pnae>((map) =>
        Pnae.fromMap(map)).toList();
    print("jsonfaavo${json}");
    return favoritos;
  }


  static Future<ApiResponse<bool>> save(context, Pnae c) async {
    try {
      var url = "$BASE_URL/pnae";
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

        Pnae empreendimento = Pnae.fromMap(mapResponse);

        print("Pnae salvo: ${empreendimento.id}");

        return ApiResponse.ok();
      }

      Map mapResponse = convert.json.decode(response.body);
      return ApiResponse.error(msg: mapResponse["error"]);
    } catch (e) {
      print(e);

      return ApiResponse.error(msg: "Não foi possível salvar o empreendimento");
    }
  }


  static Future<ApiResponse<bool>> delete(context, Pnae c) async {
    try {
      String url = "$BASE_URL/pnae/${c.id}";

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
