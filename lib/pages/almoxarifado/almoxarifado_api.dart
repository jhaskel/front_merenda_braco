import 'dart:convert' as convert;
import 'package:merenda_escolar/constants.dart';
import 'package:merenda_escolar/pages/almoxarifado/almoxarifado.dart';
import 'package:merenda_escolar/utils/api_response.dart';
import 'package:merenda_escolar/utils/http_helper.dart' as http;
import 'package:http/http.dart' as htttp;

class AlmoxarifadoApi {
  static Future<List<Almoxarifado>> get(context,int licitacao) async {
    String url = "$BASE_URL/almoxarifado/licitacao/$licitacao";
    print("GET2 > $url");
    final response = await http.get( context,url);
    print("resp ${response.body}");
    String json = response.body;
    List list = convert.json.decode(json);
    List<Almoxarifado> favoritos = list.map<Almoxarifado>((map) =>
        Almoxarifado.fromMap(map)).toList();
    print("jsonfaavo${json}");
    return favoritos;
  }

  static Future<List<Almoxarifado>> getEscola(context,int escola) async {
    String url = "$BASE_URL/almoxarifado/escola/$escola";
    print("GET2 > $url");
    final response = await http.get( context,url);
    print("resp ${response.body}");
    String json = response.body;
    List list = convert.json.decode(json);
    List<Almoxarifado> favoritos = list.map<Almoxarifado>((map) =>
        Almoxarifado.fromMap(map)).toList();
    print("jsonfaavo${json}");
    return favoritos;
  }

  static Future<List<Almoxarifado>> getTroca(context) async {
    String url = "$BASE_URL/almoxarifado/troca";
    print("GET2 > $url");
    final response = await http.get( context,url);
    print("resp ${response.body}");
    String json = response.body;
    List list = convert.json.decode(json);
    List<Almoxarifado> favoritos = list.map<Almoxarifado>((map) =>
        Almoxarifado.fromMap(map)).toList();
    print("jsonfaavo${json}");
    return favoritos;
  }



}
