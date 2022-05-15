import 'dart:convert' as convert;

import 'package:merenda_escolar/constants.dart';
import 'package:merenda_escolar/pages/fornecedor/Fornecedor.dart';
import 'package:merenda_escolar/utils/api_response.dart';
import 'package:merenda_escolar/utils/http_helper.dart' as http;


class FornecedorApi {

  static Future<List<Fornecedor>> get(context) async {
    String url = "$BASE_URL/fornecedor";

    print("GET > $url");

    final response = await http.get(context, url);

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body.substring(0, 50)}');

    String json = response.body;

    List list = convert.json.decode(json);

    List<Fornecedor> fornecedors = list.map<Fornecedor>((map) =>
        Fornecedor.fromMap(map)).toList();

    return fornecedors;
  }
  static Future<List<Fornecedor>> getId(context,int id) async {
    String url = "$BASE_URL/fornecedor/id/$id";

    print("GET > $url");
    final response = await http.get(context, url);

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body.substring(0, 50)}');

    String json = response.body;

    List list = convert.json.decode(json);

    List<Fornecedor> fornecedors = list.map<Fornecedor>((map) =>
        Fornecedor.fromMap(map)).toList();

    return fornecedors;
  }


  static Future<List<Fornecedor>> getFornecedorByEmpreendedor(context, int empreendedor) async {
    String url = "$BASE_URL/fornecedor/id/$empreendedor";

    print("GET2 > $url");

    final response = await http.get(context, url);

    String json = response.body;

    List list = convert.json.decode(json);

    List<Fornecedor> favoritos = list.map<Fornecedor>((map) =>
        Fornecedor.fromMap(map)).toList();
    print("jsonfaavo${json}");
    return favoritos;
  }

  static Future<ApiResponse<bool>> save(context, Fornecedor c) async {
    try {
      var url = "$BASE_URL/fornecedor";
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

        Fornecedor fornecedor = Fornecedor.fromMap(mapResponse);

        print("Fornecedor salvo: ${fornecedor.id}");

        return ApiResponse.ok(id: fornecedor.id);
      }

      Map mapResponse = convert.json.decode(response.body);
      return ApiResponse.error(msg: mapResponse["error"]);
    } catch (e) {
      print(e);

      return ApiResponse.error(msg: "Não foi possível salvar o fornecedor");
    }
  }


  static Future<ApiResponse> delete(context, Fornecedor c) async {
    try {
      String url = "$BASE_URL/fornecedor/${c.id}";

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

    return ApiResponse.error(msg: "Não foi possível deletar o fornecedor");
  }



}
