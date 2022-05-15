import 'dart:convert' as convert;



import 'package:merenda_escolar/constants.dart';
import 'package:merenda_escolar/pages/licitacao/Licitacao.dart';
import 'package:merenda_escolar/utils/api_response.dart';

import 'package:merenda_escolar/utils/http_helper.dart' as http;

class LicitacaoApi {
  static Future<List<Licitacao>> get(
    context,
  ) async {
    String url = "$BASE_URL/licitacao";
    final response = await http.get(context,url);
    print("resp ${response.body}");
    String json = response.body;
    List list = convert.json.decode(json);
    List<Licitacao> favoritos = list.map<Licitacao>((map) => Licitacao.fromMap(map)).toList();
    return favoritos;
  }

  static Future<List<Licitacao>> getFornecedor(context, int fornecedor) async {
    String url = "$BASE_URL/licitacao/fornecedor/$fornecedor";
    final response = await http.get(context,url);
    String json = response.body;
    List list = convert.json.decode(json);
    List<Licitacao> favoritos = list.map<Licitacao>((map) => Licitacao.fromMap(map)).toList();
    return favoritos;
  }

  static Future<ApiResponse<bool>> save(context, Licitacao c) async {
    try {
      var url = "$BASE_URL/licitacao";
      if (c.id != null) {
        url += "/${c.id}";
      }
      String json = c.toJson();
      var response = await (c.id == null
          ? http.post(context,url, body: json)
          : http.put(context,url, body: json));
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("ok ${c.isativo}");
        return ApiResponse.ok();
      }
      Map mapResponse = convert.json.decode(response.body);
      return ApiResponse.error(msg: mapResponse["error"]);
    } catch (e) {
      return ApiResponse.error(msg: "Não foi possível salvar a licitacao");
    }
  }

  static Future<ApiResponse> delete(context, Licitacao c) async {
    try {
      String url = "$BASE_URL/licitacao/${c.id}";
      var response = await http.delete(context,url);
      if (response.statusCode == 200) {
        return ApiResponse.ok(id: 1);
      }
    } catch (e) {}
    return ApiResponse.error(msg: "Não foi possível deletar a licitacao");
  }
}
