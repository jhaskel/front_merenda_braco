import 'dart:convert' as convert;
import 'package:merenda_escolar/constants.dart';
import 'package:merenda_escolar/pages/pedido/Pedido.dart';
import 'package:merenda_escolar/utils/api_response.dart';
import 'package:merenda_escolar/utils/http_helper.dart' as http;


class PedidoApi {
  static Future<List<Pedido>> get(context) async {
    String url = "$BASE_URL/pedidos";
    print("GET2 > $url");

    final response = await http.get( context,url);

    print("resp ${response.body}");

    String json = response.body;

    List list = convert.json.decode(json);

    List<Pedido> favoritos = list.map<Pedido>((map) =>
        Pedido.fromMap(map)).toList();
    print("jsonfaavo${json}");
    return favoritos;
  }


  static Future<List<Pedido>> getByEscola(context,int escola) async {
    String url = "$BASE_URL/pedidos/escola/$escola";
    print("GET2 > $url");

    final response = await http.get( context,url);

    print("resp ${response.body}");

    String json = response.body;

    List list = convert.json.decode(json);

    List<Pedido> favoritos = list.map<Pedido>((map) =>
        Pedido.fromMap(map)).toList();
    print("jsonfaavo${json}");
    return favoritos;
  }
  static Future<List<Pedido>> getByCode(context,String code) async {
    String url = "$BASE_URL/pedidos/code/$code";
    print("GET2 > $url");

    final response = await http.get( context,url);

    print("resp ${response.body}");

    String json = response.body;

    List list = convert.json.decode(json);

    List<Pedido> favoritos = list.map<Pedido>((map) =>
        Pedido.fromMap(map)).toList();
    print("jsonfaavo${json}");
    return favoritos;
  }
  static Future<List<Pedido>> getByCheck(context,bool ischeck) async {
    String url = "$BASE_URL/pedidos/check/$ischeck";
    print("GET2 > $url");

    final response = await http.get( context,url);

    print("resp ${response.body}");

    String json = response.body;

    List list = convert.json.decode(json);

    List<Pedido> favoritos = list.map<Pedido>((map) =>
        Pedido.fromMap(map)).toList();
    print("jsonfaavo${json}");
    return favoritos;
  }
  static Future<List<Pedido>> getById(context,int id) async {
    String url = "$BASE_URL/pedidos/id/$id";
    print("GET2 > $url");

    final response = await http.get( context,url);

    print("resp ${response.body}");

    String json = response.body;

    List list = convert.json.decode(json);

    List<Pedido> favoritos = list.map<Pedido>((map) =>
        Pedido.fromMap(map)).toList();
    print("jsonfaavo${json}");
    return favoritos;
  }
  static Future<ApiResponse<bool>> save(context, Pedido c) async {
    try {
      var url = "$BASE_URL/pedidos";
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

        Pedido empreendimento = Pedido.fromMap(mapResponse);

        print("Pedido salvo: ${empreendimento.id}");

        return ApiResponse.ok();
      }

      Map mapResponse = convert.json.decode(response.body);
      return ApiResponse.error(msg: mapResponse["error"]);
    } catch (e) {
      print('error $e');

      return ApiResponse.error(msg: "Não foi possível salvar o pedido");
    }
  }
  static Future<ApiResponse<bool>> delete(context, Pedido c) async {
    try {
      String url = "$BASE_URL/pedidos/${c.id}";

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
