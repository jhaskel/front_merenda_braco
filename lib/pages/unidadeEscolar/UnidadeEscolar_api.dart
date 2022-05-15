import 'dart:convert' as convert;
import 'package:merenda_escolar/app_model.dart';
import 'package:merenda_escolar/constants.dart';
import 'package:merenda_escolar/pages/login/usuario.dart';
import 'package:merenda_escolar/pages/unidadeEscolar/UnidadeEscolar.dart';
import 'package:merenda_escolar/utils/api_response.dart';
import 'package:merenda_escolar/utils/http_helper.dart' as http;
import 'package:http/http.dart' as htttp;
import 'dart:convert';




class UnidadeEscolarApi {



  static Future<List<UnidadeEscolar>> get(context,bool ispulic) async {
  if(!ispulic){
    String url = "$BASE_URL/escolas";
    print("GET21 > $url");
    final response = await http.get( context,url);
    print("resp ${response.body}");
    String json = response.body;

    List list = convert.json.decode(json);

    List<UnidadeEscolar> favoritos = list.map<UnidadeEscolar>((map) =>
        UnidadeEscolar.fromMap(map)).toList();
    print("jsonfaavo${json}");
    return favoritos;
  }

  String url = "$BASE_URL/escolas";
  print("GET21 > $url");
  final response = await htttp.get( url);
  print("resp ${response.body}");
  String json = response.body;

  List list = convert.json.decode(json);

  List<UnidadeEscolar> favoritos = list.map<UnidadeEscolar>((map) =>
      UnidadeEscolar.fromMap(map)).toList();
  print("jsonfaavo${json}");
  return favoritos;
  }


  static Future<List<UnidadeEscolar>> getSetor(context,int setor) async {
    String url = "$BASE_URL/unidades/setor/$setor";
    final response = await http.get(context,url);
    String json = response.body;
    List list = convert.json.decode(json);
    List<UnidadeEscolar> unidades =
    list.map<UnidadeEscolar>((map) => UnidadeEscolar.fromMap(map)).toList();

    return unidades;
  }


  static Future<List<UnidadeEscolar>> getId(context,int id) async {

    String url = "$BASE_URL/escolas/id/$id";
    print("GET2 > $url");

    final response = await http.get( context,url);

    print("resp ${response.body}");

    String json = response.body;

    List list = convert.json.decode(json);

    List<UnidadeEscolar> favoritos = list.map<UnidadeEscolar>((map) =>
        UnidadeEscolar.fromMap(map)).toList();
    print("jsonfaavo${json}");
    return favoritos;
  }



  static Future<ApiResponse<bool>> save(context, UnidadeEscolar c) async {
    try {
      var url = "$BASE_URL/escolas";
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

        UnidadeEscolar empreendimento = UnidadeEscolar.fromMap(mapResponse);

        print("UnidadeEscolar salvo: ${empreendimento.id}");

        return ApiResponse.ok();
      }

      Map mapResponse = convert.json.decode(response.body);
      return ApiResponse.error(msg: mapResponse["error"]);
    } catch (e) {
      print(e);

      return ApiResponse.error(msg: "Não foi possível salvar o empreendimento");
    }
  }


  static Future<ApiResponse> delete(context, UnidadeEscolar c) async {
    try {
      String url = "$BASE_URL/escolas/${c.id}";

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

    return ApiResponse.error(msg: "Não foi possível deletar o empreendimento");
  }


}
