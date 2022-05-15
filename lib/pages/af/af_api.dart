import 'dart:convert' as convert;
import 'package:merenda_escolar/constants.dart';
import 'package:merenda_escolar/pages/af/Af.dart';
import 'package:merenda_escolar/utils/api_response.dart';
import 'package:merenda_escolar/utils/http_helper.dart' as http;


class AfApi {
  static Future<List<Af>> get(context) async {
    String url = "$BASE_URL/af";
    print("GET2 > $url");
    final response = await http.get( context,url);
    print("resp ${response.body}");
    String json = response.body;
    List list = convert.json.decode(json);
    List<Af> favoritos = list.map<Af>((map) =>
        Af.fromMap(map)).toList();
    print("jsonfaavo${json}");
    return favoritos;
  }

  static Future<List<Af>> getByEscola(context,int escola) async {
    String url = "$BASE_URL/af/escola/$escola";
    print("GET2 > $url");
    final response = await http.get( context,url);
    print("resp ${response.body}");
    String json = response.body;
    List list = convert.json.decode(json);
    List<Af> favoritos = list.map<Af>((map) =>
        Af.fromMap(map)).toList();
    print("jsonfaavo${json}");
    return favoritos;
  }
  static Future<List<Af>> getByFornecedor(context,int fornecedor) async {
    String url = "$BASE_URL/af/fornecedor/$fornecedor";
    print("GET2 > $url");

    final response = await http.get( context,url);

    print("resp ${response.body}");

    String json = response.body;

    List list = convert.json.decode(json);

    List<Af> favoritos = list.map<Af>((map) =>
        Af.fromMap(map)).toList();
    print("jsonfaavo${json}");
    return favoritos;
  }

  static Future<List<Af>> getByDespesa(context,bool isdespesa) async {
    String url = "$BASE_URL/af/despesa/$isdespesa";
    print("GET2 > $url");
    final response = await http.get( context,url);

    print("resp ${response.body}");

    String json = response.body;

    List list = convert.json.decode(json);

    List<Af> favoritos = list.map<Af>((map) =>
        Af.fromMap(map)).toList();
    print("jsonfaavo${json}");
    return favoritos;
  }

  static Future<List<Af>> getByStatus(context,String status) async {
    String url = "$BASE_URL/af/status/$status";
    print("GET2 > $url");
    final response = await http.get( context,url);

    print("resp ${response.body}");

    String json = response.body;

    List list = convert.json.decode(json);

    List<Af> favoritos = list.map<Af>((map) =>
        Af.fromMap(map)).toList();
    print("jsonfaavo${json}");
    return favoritos;
  }


  static Future<List<Af>> getSetor(context, int setor) async {
    String url = "$BASE_URL/af/setor/$setor";
    final response = await http.get(context,url);
    String json = response.body;
    List list = convert.json.decode(json);
    List<Af> favoritos = list.map<Af>((map) => Af.fromMap(map)).toList();
    return favoritos;
  }


  static Future<List<Af>> getCode(context, int code) async {
    String url = "$BASE_URL/af/code/$code";
    final response = await http.get(context,url);
    String json = response.body;
    List list = convert.json.decode(json);
    List<Af> favoritos = list.map<Af>((map) => Af.fromMap(map)).toList();
    return favoritos;
  }


  static Future<ApiResponse<bool>> save(context, Af c) async {
    try {
      var url = "$BASE_URL/af";
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

        Af empreendimento = Af.fromMap(mapResponse);

        print("Af salvo: ${empreendimento.id}");

        return ApiResponse.ok();
      }

      Map mapResponse = convert.json.decode(response.body);
      return ApiResponse.error(msg: mapResponse["error"]);
    } catch (e) {
      print(e);

      return ApiResponse.error(msg: "Não foi possível salvar o empreendimento");
    }
  }


  static Future<ApiResponse<bool>> delete(context, Af c) async {
    try {
      String url = "$BASE_URL/af/${c.id}";

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
