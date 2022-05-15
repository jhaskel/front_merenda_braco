import 'dart:convert' as convert;

import 'package:merenda_escolar/constants.dart';
import 'package:merenda_escolar/pages/entrega/Entrega.dart';
import 'package:merenda_escolar/utils/api_response.dart';
import 'package:merenda_escolar/utils/http_helper.dart' as http;


class EntregaApi {
  static Future<List<Entrega>> get(context) async {
    String url = "$BASE_URL/entrega";
    final response = await http.get(context,url);
    String json = response.body;
    List list = convert.json.decode(json);
    List<Entrega> favoritos =
        list.map<Entrega>((map) => Entrega.fromMap(map)).toList();

    return favoritos;
  }

  static Future<List<Entrega>> getOrdem(context,int ordem) async {
    String url = "$BASE_URL/entrega/ordem/$ordem";
    print('ordemAPI1 $url');
    final response = await http.get(context,url);
    String json = response.body;
    print('ordemAPI2 $json');
    List list = convert.json.decode(json);
    print('ordemAPI3 $list');
    List<Entrega> favoritos =
    list.map<Entrega>((map) => Entrega.fromMap(map)).toList();
    print('ordemAPI4 $favoritos');
    return favoritos;
  }
  static Future<List<Entrega>> getPedido(context,int pedido) async {
    String url = "$BASE_URL/entrega/pedido/$pedido";
    print('pedidoAPI1 $url');
    final response = await http.get(context,url);
    String json = response.body;
    List list = convert.json.decode(json);
    List<Entrega> favoritos =
    list.map<Entrega>((map) => Entrega.fromMap(map)).toList();
    return favoritos;
  }

  static Future<ApiResponse<bool>> save(context, Entrega c) async {
    try {
      var url = "$BASE_URL/entrega";
      if (c.id != null) {
        url += "/${c.id}";
      }
      print("url post $url");
     
      String json = c.toJson();

      var response = await (c.id == null
          ? http.post(context,url, body: json)
          : http.put(context,url, body: json));
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("statuscode${response.statusCode}");
print("ok gravou${c.quantidade} em ${c.id}");
        return ApiResponse.ok();
      }

      Map mapResponse = convert.json.decode(response.body);
      return ApiResponse.error(msg: mapResponse["error"]);
    } catch (e) {


      return ApiResponse.error(msg: "Não foi possível salvar o empreendimento");
    }
  }



  static Future<ApiResponse> delete(context, Entrega c) async {
    try {
      String url = "$BASE_URL/entrega/${c.id}";



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
