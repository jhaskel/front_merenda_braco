import 'dart:convert' as convert;
import 'package:merenda_escolar/constants.dart';
import 'package:merenda_escolar/pages/compras/Compras.dart';

import 'package:merenda_escolar/utils/api_response.dart';
import 'package:merenda_escolar/utils/http_helper.dart' as http;

class ComprasApi {


  static Future<List<Compras>> getByCart(context,String pedido) async {
    String url = "$BASE_URL/compras/cart/$pedido";
    print("GET2 > $url");
    final response = await http.get( context,url);
    print("resp ${response.body}");
    String json = response.body;
    List list = convert.json.decode(json);
    List<Compras> favoritos = list.map<Compras>((map) =>
        Compras.fromMap(map)).toList();
    print("json $url ${json}");
    return favoritos;
  }
  static Future<List<Compras>> getPed(context,int pedido) async {
    String url = "$BASE_URL/compras/pedido/$pedido";
    print("GET2 > $url");

    final response = await http.get( context,url);

    print("resp ${response.body}");

    String json = response.body;

    List list = convert.json.decode(json);

    List<Compras> favoritos = list.map<Compras>((map) =>
        Compras.fromMap(map)).toList();
    print("jsonfaavo${json}");
    return favoritos;
  }

  static Future<ApiResponse<bool>> save(context, Compras c) async {
    try {
      var url = "$BASE_URL/compras";
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

        Compras empreendimento = Compras.fromMap(mapResponse);

        print("Compras salvo: ${empreendimento.id}");

        return ApiResponse.ok();
      }

      Map mapResponse = convert.json.decode(response.body);
      return ApiResponse.error(msg: mapResponse["error"]);
    } catch (e) {
      print(e);

      return ApiResponse.error(msg: "Não foi possível salvar o empreendimento");
    }
  }
  static Future<ApiResponse<bool>> delete(context, Compras c) async {
    try {
      String url = "$BASE_URL/compras/${c.id}";

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
