import 'dart:convert' as convert;
import 'package:merenda_escolar/constants.dart';
import 'package:merenda_escolar/pages/login/usuario.dart';
import 'package:merenda_escolar/utils/api_response.dart';
import 'package:merenda_escolar/utils/http_helper.dart' as http;
import 'package:http/http.dart' as htttp;
import 'package:merenda_escolar/utils/utils.dart';

class UsuariosApi {

  static Future<List<Usuario>> get(context) async {
    String url = "$BASE_URL/usuarios";

    print("GET > $url");

    final response = await http.get( context,url);

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body.substring(0, 50)}');

    String json = response.body;

    List list = convert.json.decode(json);

    List<Usuario> usuarios = list.map<Usuario>((map) =>
        Usuario.fromMap(map)).toList();

    return usuarios;
  }


  static Future<List<Usuario>> getUsuarioBycpf(context) async {

    String cpf ;
    Usuario user = await Usuario.get();
    cpf =user.cpf;

    String url = "$BASE_URL/usuarios/cpf/$cpf";

    print("GET2 > $url");

    final response = await http.get(context, url);

    String json = response.body;

    List list = convert.json.decode(json);

    List<Usuario> favoritos = list.map<Usuario>((map) =>
        Usuario.fromMap(map)).toList();
    print("jsonfaavo${json}");
    return favoritos;
  }

  static Future<List<Usuario>> getUsuarioByNivel(context, ) async {
    String nivel = Niveis.unidade;
    String url = "$BASE_URL/usuarios/nivel/$nivel";

    print("GET2 > $url");

    final response = await http.get(context, url);

    String json = response.body;

    List list = convert.json.decode(json);

    List<Usuario> favoritos = list.map<Usuario>((map) =>
        Usuario.fromMap(map)).toList();
    print("jsonfaavo${json}");
    return favoritos;
  }

  static Future<ApiResponse<bool>> save(context, Usuario c) async {
    try {
      var url = "$BASE_URL/usuarios";
      if (c.id != null) {
        url += "/${c.id}";
      }
      Map<String,String> headers = {
        "Content-Type": "application/json"
      };

      print("POST > $url");

      String json = c.toJson();

      print("JSON > $json");


      var response = await (c.id == null
          ? htttp.post(url, body: json,headers: headers)
          : htttp.put(url, body: json,headers: headers));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 500) {

        return ApiResponse.error(msg: "Esse usuário já está em uso");

      }
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map mapResponse = convert.json.decode(response.body);

        Usuario empreendimento = Usuario.fromMap(mapResponse);

        print("Empreendimento salvo: ${empreendimento.id}");

        return ApiResponse.ok();
      }

      Map mapResponse = convert.json.decode(response.body);
      return ApiResponse.error(msg: mapResponse["error"]);
    } catch (e) {
      print(e);

      return ApiResponse.error(msg: "Não foi possível salvar o empreendimento");
    }
  }


  static Future<ApiResponse> delete(context, Usuario c) async {
    try {
      String url = "$BASE_URL/usuarios/${c.id}";

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

    return ApiResponse.error(msg: "Não foi possível deletar o usuario");
  }



}
