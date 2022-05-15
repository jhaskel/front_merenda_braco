import 'dart:convert' as convert;
import 'package:merenda_escolar/constants.dart';
import 'package:merenda_escolar/pages/contabilidade/Contabilidade.dart';

import 'package:merenda_escolar/utils/api_response.dart';
import 'package:merenda_escolar/utils/http_helper.dart' as http;


class ContabilidadeApi {
  static Future<List<Contabilidade>> get(context) async {
    String url = "$BASE_URL/contabilidade";
    print("GET2 > $url");

    final response = await http.get( context,url);

    print("resp ${response.body}");

    String json = response.body;

    List list = convert.json.decode(json);

    List<Contabilidade> favoritos = list.map<Contabilidade>((map) =>
        Contabilidade.fromMap(map)).toList();
    return favoritos;
  }

  static Future<List<Contabilidade>> getNivel(context,int nivel) async {
    String url = "$BASE_URL/contabilidade/nivel/$nivel";
    print("GET2 > $url");

    final response = await http.get( context,url);

    String json = response.body;

    List list = convert.json.decode(json);

    List<Contabilidade> favoritos = list.map<Contabilidade>((map) =>
        Contabilidade.fromMap(map)).toList();
    return favoritos;
  }
  static Future<List<Contabilidade>> findById(context,int id) async {
    String url = "$BASE_URL/contabilidade/id/$id";
    print("GET2 > $url");
    final response = await http.get( context,url);
    String json = response.body;
    List list = convert.json.decode(json);
    List<Contabilidade> favoritos = list.map<Contabilidade>((map) =>
        Contabilidade.fromMap(map)).toList();
    print("contacod${json}");
    return favoritos;
  }


  static Future<ApiResponse<bool>> save(context, Contabilidade c) async {
    try {
      var url = "$BASE_URL/contabilidade";
      if (c.id != null) {
        url += "/${c.id}";
      }

      Map<String, String> headers = {
        "Content-Type": "application/json"
      };

      String json = c.toJson();

           var response = await (c.id == null
          ? http.post(context, url, body: json)
          : http.put(context, url, body: json));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map mapResponse = convert.json.decode(response.body);

        Contabilidade empreendimento = Contabilidade.fromMap(mapResponse);



        return ApiResponse.ok();
      }

      Map mapResponse = convert.json.decode(response.body);
      return ApiResponse.error(msg: mapResponse["error"]);
    } catch (e) {
      print(e);

      return ApiResponse.error(msg: "Não foi possível salvar o empreendimento");
    }
  }


  static Future<ApiResponse<bool>> delete(context, Contabilidade c) async {
    try {
      String url = "$BASE_URL/contabilidade/${c.id}";

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
