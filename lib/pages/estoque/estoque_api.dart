import 'dart:convert' as convert;

import 'package:merenda_escolar/constants.dart';
import 'package:merenda_escolar/pages/estoque/Estoque.dart';
import 'package:merenda_escolar/utils/api_response.dart';

import 'package:merenda_escolar/utils/http_helper.dart' as http;

class EstoqueApi {
  static Future<List<Estoque>> get(context,) async {
    String url = "$BASE_URL/estoque";
    final response = await http.get(context,url);
    String json = response.body;
    List list = convert.json.decode(json);
    List<Estoque> favoritos = list.map<Estoque>((map) =>
        Estoque.fromMap(map)).toList();
    return favoritos;
  }
  static Future<List<Estoque>> getSetor(context,int setor) async {
    String url = "$BASE_URL/estoque/estoque/$setor";
    print("URLx $url");
    final response = await http.get(context,url);
    print("UR2L ${response.body}");
    String json = response.body;
    List list = convert.json.decode(json);

    List<Estoque> favoritos = list.map<Estoque>((map) =>
        Estoque.fromMap(map)).toList();
    print("UR3L ${favoritos}");
    return favoritos;
  }
  static Future<List<Estoque>> getLicitacao(context,int licitacao) async {
    String url = "$BASE_URL/estoque/licitacao/$licitacao";
    print("URL $url");
    final response = await http.get(context,url);
    print("UR2L ${response.body}");
    String json = response.body;
    List list = convert.json.decode(json);

    List<Estoque> favoritos = list.map<Estoque>((map) =>
        Estoque.fromMap(map)).toList();
    print("UR3L ${favoritos}");
    return favoritos;
  }
  static Future<List<Estoque>> getId(context,int id) async {
    String url = "$BASE_URL/estoque/id/$id";
    final response = await http.get(context,url);
    String json = response.body;
    List list = convert.json.decode(json);
    List<Estoque> favoritos = list.map<Estoque>((map) =>
        Estoque.fromMap(map)).toList();
    return favoritos;
  }
  static Future<List<Estoque>> getMenos(context) async {
    String url = "$BASE_URL/estoque/menos";
    final response = await http.get(context,url);
    String json = response.body;
    List list = convert.json.decode(json);
    List<Estoque> favoritos = list.map<Estoque>((map) =>
        Estoque.fromMap(map)).toList();

    return favoritos;
  }
  static Future<List<Estoque>> getFornecedor(context,int fornecedor) async {
    String url = "$BASE_URL/estoque/fornecedor/$fornecedor";
    print("URL $url");
    final response = await http.get(context,url);
    print("UR2L ${response.body}");
    String json = response.body;
    List list = convert.json.decode(json);

    List<Estoque> favoritos = list.map<Estoque>((map) =>
        Estoque.fromMap(map)).toList();
    print("UR3L ${favoritos}");
    return favoritos;
  }



  static Future<ApiResponse<bool>> save(context, Estoque c) async {
    try {
      var url = "$BASE_URL/estoque";
      if (c.id != null) {
        url += "/${c.id}";
      }

      String json = c.toJson();

      var response = await (c.id == null
          ? http.post( context,url, body: json)
          : http.put(context,url, body: json));

      if (response.statusCode == 200 || response.statusCode == 201) {


        return ApiResponse.ok();
      }

      Map mapResponse = convert.json.decode(response.body);
      return ApiResponse.error(msg: mapResponse["error"]);
    } catch (e) {

      return ApiResponse.error(msg: "Não foi possível salvar a estoque");
    }
  }


  static Future<ApiResponse> delete(context, Estoque c) async {
    try {
      String url = "$BASE_URL/estoque/${c.id}";

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
