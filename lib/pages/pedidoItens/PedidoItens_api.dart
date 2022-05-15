import 'dart:convert' as convert;
import 'package:merenda_escolar/constants.dart';
import 'package:merenda_escolar/pages/pedidoItens/PedidoItens.dart';
import 'package:merenda_escolar/utils/api_response.dart';
import 'package:merenda_escolar/utils/http_helper.dart' as http;
import 'package:http/http.dart' as htttp;

class PedidoItensApi {
  static Future<List<PedidoItens>> get(context) async {
    String url = "$BASE_URL/itens";
    print("GET2 > $url");
    final response = await http.get( context,url);
    print("resp ${response.body}");
    String json = response.body;
    List list = convert.json.decode(json);
    List<PedidoItens> favoritos = list.map<PedidoItens>((map) =>
        PedidoItens.fromMap(map)).toList();
    print("jsonfaavo${json}");
    return favoritos;
  }
  static Future<List<PedidoItens>> getByEscola(context,int escola,int pedido) async {
    String url = "$BASE_URL/itens/escola/$escola/$pedido";
    print("GET2 > $url");
    final response = await http.get( context,url);
    print("resp ${response.body}");
    String json = response.body;
    List list = convert.json.decode(json);
    List<PedidoItens> favoritos = list.map<PedidoItens>((map) =>
        PedidoItens.fromMap(map)).toList();
    print("jsonfaavo${json}");
    return favoritos;
  }
  static Future<List<PedidoItens>> getByEscolar(context,int escola,int ano) async {
    String url = "$BASE_URL/itens/escolar/$escola/$ano";
    print("GET2 > $url");
    final response = await http.get( context,url);
    print("resp ${response.body}");
    String json = response.body;
    List list = convert.json.decode(json);
    List<PedidoItens> favoritos = list.map<PedidoItens>((map) =>
        PedidoItens.fromMap(map)).toList();
    print("jsonfaavo${json}");
    return favoritos;
  }

  static Future<List<PedidoItens>> getByPedido(context,String pedido) async {
    String url = "$BASE_URL/itens/pedido/$pedido";
    print("GET2 > $url");
    final response = await http.get( context,url);
    print("resp ${response.body}");
    String json = response.body;
    List list = convert.json.decode(json);
    List<PedidoItens> favoritos = list.map<PedidoItens>((map) =>
        PedidoItens.fromMap(map)).toList();
    print("jsonfaavo${json}");
    return favoritos;
  }

  static Future<List<PedidoItens>> getByAfi(context) async {
    String url = "$BASE_URL/itens/afi";
    print("GET2 > $url");

    final response = await http.get( context,url);

    print("resp ${response.body}");

    String json = response.body;

    List list = convert.json.decode(json);

    List<PedidoItens> favoritos = list.map<PedidoItens>((map) =>
        PedidoItens.fromMap(map)).toList();
    print("jsonfaavo${json}");
    return favoritos;
  }
  static Future<List<PedidoItens>> getByAf(context,int af) async {

    String url = "$BASE_URL/itens/af/$af";
    print("GET2 > $url");

    final response = await http.get( context,url);

    print("resp ${response.body}");

    String json = response.body;

    List list = convert.json.decode(json);

    List<PedidoItens> favoritos = list.map<PedidoItens>((map) =>
        PedidoItens.fromMap(map)).toList();
    print("jsonfaavo${json}");
    return favoritos;
  }
  static Future<List<PedidoItens>> getByPedidoAll(context,String pedido) async {
    String url = "$BASE_URL/itens/pedidoall/$pedido";
    print("GET2 > $url");

    final response = await http.get( context,url);

    print("resp ${response.body}");

    String json = response.body;

    List list = convert.json.decode(json);

    List<PedidoItens> favoritos = list.map<PedidoItens>((map) =>
        PedidoItens.fromMap(map)).toList();
    print("jsonfaavo${json}");
    return favoritos;
  }
  static Future<List<PedidoItens>> getByPedidoGroup(context) async {

    String url = "$BASE_URL/itens/pedidos";
    print("GET2 > $url");

    final response = await http.get( context,url);

    print("resp ${response.body}");

    String json = response.body;

    List list = convert.json.decode(json);

    List<PedidoItens> favoritos = list.map<PedidoItens>((map) =>
        PedidoItens.fromMap(map)).toList();
    print("jsonfaavo${json}");
    return favoritos;
  }
  static Future<List<PedidoItens>> getAno(context,int ano) async {
    String url = "$BASE_URL/itens/ano/$ano";
    print("GET2 > $url");

    final response = await http.get( context,url);

    print("resp ${response.body}");

    String json = response.body;

    List list = convert.json.decode(json);

    List<PedidoItens> favoritos = list.map<PedidoItens>((map) =>
        PedidoItens.fromMap(map)).toList();
    print("jsonfaavo${json}");
    return favoritos;
  }
  static Future<List<PedidoItens>> getByEscolaAll(context,int ano) async {
    String url = "$BASE_URL/itens/escolaAll/$ano";
    print("GET2 > $url");

    final response = await http.get( context,url);

    print("resp ${response.body}");

    String json = response.body;

    List list = convert.json.decode(json);

    List<PedidoItens> favoritos = list.map<PedidoItens>((map) =>
        PedidoItens.fromMap(map)).toList();
    print("jsonfaavo${json}");
    return favoritos;
  }
  static Future<List<PedidoItens>> getByTotalMes(context,int ano,bool ispublic) async {


    String url = "$BASE_URL/itens/totalMes/$ano";
    print("GET2 > $url");

    final response = await htttp.get( url);

    print("resp $url ${response.body}");

    String json = response.body;

    List list = convert.json.decode(json);
    print("list $url ${json}");
    List<PedidoItens> favoritos = list.map<PedidoItens>((map) =>
        PedidoItens.fromMap(map)).toList();
    print("jsonfaavo $url ${json}");
    return favoritos;
  }
  static Future<List<PedidoItens>> getByTotalMesNivel(context,int nivel,int ano) async {
    String url = "$BASE_URL/itens/totalMesNivel/$nivel/$ano";
    print("GET2 > $url");

    final response = await http.get( context,url);

    print("resp ${response.body}");

    String json = response.body;

    List list = convert.json.decode(json);

    List<PedidoItens> favoritos = list.map<PedidoItens>((map) =>
        PedidoItens.fromMap(map)).toList();
    print("jsonfaavo${json}");
    return favoritos;
  }


  static Future<List<PedidoItens>> getByTotalMesEscola(context,int escola,int ano) async {
    String url = "$BASE_URL/itens/totalMesEscola/$escola/$ano";
    print("GET2 > $url");

    final response = await htttp.get( url);

    print("resp ${response.body}");

    String json = response.body;

    List list = convert.json.decode(json);

    List<PedidoItens> favoritos = list.map<PedidoItens>((map) =>
        PedidoItens.fromMap(map)).toList();
    print("jsonfaavo${json}");
    return favoritos;
  }
  static Future<List<PedidoItens>> getByTotalCategoria(context,int ano) async {
    String url = "$BASE_URL/itens/totalCategoria/$ano";
    print("GET2 > $url");

    final response = await htttp.get( url);

    print("resp ${response.body}");

    String json = response.body;

    List list = convert.json.decode(json);

    List<PedidoItens> favoritos = list.map<PedidoItens>((map) =>
        PedidoItens.fromMap(map)).toList();
    print("jsonfaavo${json}");
    return favoritos;
  }
  static Future<List<PedidoItens>> getByTotalCategoriaNivel(context,int nivel,int ano) async {
    String url = "$BASE_URL/itens/totalCategoriaNivel/$nivel/$ano";
    print("GET2 > $url");

    final response = await http.get( context,url);

    print("resp ${response.body}");

    String json = response.body;

    List list = convert.json.decode(json);

    List<PedidoItens> favoritos = list.map<PedidoItens>((map) =>
        PedidoItens.fromMap(map)).toList();
    print("jsonfaavo${json}");
    return favoritos;
  }
  static Future<List<PedidoItens>> getByTotalCategoriaEscola(context,int escola,int ano) async {
    String url = "$BASE_URL/itens/totalCategoriaEscola/$escola/$ano";
    print("GET2 > $url");

    final response = await htttp.get( url);

    print("resp ${response.body}");

    String json = response.body;

    List list = convert.json.decode(json);

    List<PedidoItens> favoritos = list.map<PedidoItens>((map) =>
        PedidoItens.fromMap(map)).toList();
    print("jsonfaavo${json}");
    return favoritos;
  }
  static Future<List<PedidoItens>> getByTotalEscola(context,int ano) async {
    String url = "$BASE_URL/itens/totalEscolas/$ano";
    print("GET2 > $url");

    final response = await htttp.get( url);

    print("resp ${response.body}");

    String json = response.body;

    List list = convert.json.decode(json);

    List<PedidoItens> favoritos = list.map<PedidoItens>((map) =>
        PedidoItens.fromMap(map)).toList();
    print("jsonfaavo${json}");
    return favoritos;
  }
  static Future<List<PedidoItens>> getByTotalEscolaNivel(context,int nivel,int ano) async {
    String url = "$BASE_URL/itens/totalEscolaNivel/$nivel/$ano";
    print("GET2 > $url");

    final response = await http.get( context,url);

    print("resp ${response.body}");

    String json = response.body;

    List list = convert.json.decode(json);

    List<PedidoItens> favoritos = list.map<PedidoItens>((map) =>
        PedidoItens.fromMap(map)).toList();
    print("jsonfaavo${json}");
    return favoritos;
  }
  static Future<List<PedidoItens>> getByTotalEscolaEscola(context,int escola,int ano) async {
    String url = "$BASE_URL/itens/totalEscolaEscola/$escola/$ano";
    print("GET2 > $url");

    final response = await http.get( context,url);

    print("resp ${response.body}");

    String json = response.body;

    List list = convert.json.decode(json);

    List<PedidoItens> favoritos = list.map<PedidoItens>((map) =>
        PedidoItens.fromMap(map)).toList();
    print("jsonfaavo${json}");
    return favoritos;
  }
  static Future<List<PedidoItens>> getByMediaAlunos(context,int ano) async {
    String url = "$BASE_URL/itens/mediaAlunos/$ano";
    print("GET2 > $url");

    final response = await htttp.get( url);

    print("resp ${response.body}");

    String json = response.body;

    List list = convert.json.decode(json);

    List<PedidoItens> favoritos = list.map<PedidoItens>((map) =>
        PedidoItens.fromMap(map)).toList();
    print("jsonfaavo${json}");
    return favoritos;
  }
  static Future<List<PedidoItens>> getByMediaAlunosNivel(context,int nivel,int ano) async {
    String url = "$BASE_URL/itens/mediaAlunosNivel/$nivel/$ano";
    print("GET2 > $url");

    final response = await http.get( context,url);

    print("resp ${response.body}");

    String json = response.body;

    List list = convert.json.decode(json);

    List<PedidoItens> favoritos = list.map<PedidoItens>((map) =>
        PedidoItens.fromMap(map)).toList();
    print("jsonfaavo${json}");
    return favoritos;
  }
  static Future<List<PedidoItens>> getByMediaAlunosEscola(context,int escola,int ano) async {
    String url = "$BASE_URL/itens/mediaAlunosEscola/$escola/$ano";
    print("GET2 > $url");

    final response = await http.get( context,url);

    print("resp ${response.body}");

    String json = response.body;

    List list = convert.json.decode(json);

    List<PedidoItens> favoritos = list.map<PedidoItens>((map) =>
        PedidoItens.fromMap(map)).toList();
    print("jsonfaavo${json}");
    return favoritos;
  }
  static Future<List<PedidoItens>> getByProdutos(context,int produto,int ano) async {
    String url = "$BASE_URL/itens/produtos/$produto/$ano";
    print("GET2 > $url");

    final response = await http.get( context,url);

    print("resp ${response.body}");

    String json = response.body;

    List list = convert.json.decode(json);

    List<PedidoItens> favoritos = list.map<PedidoItens>((map) =>
        PedidoItens.fromMap(map)).toList();
    print("jsonfaavo${json}");
    return favoritos;
  }
  static Future<List<PedidoItens>> getMaisPedido(context,int ano) async {
    String url = "$BASE_URL/itens/maispedidos/$ano";
    print("GET2 > $url");
    final response = await http.get( context,url);
    print("resp ${response.body}");
    String json = response.body;
    List list = convert.json.decode(json);
    List<PedidoItens> favoritos = list.map<PedidoItens>((map) =>
        PedidoItens.fromMap(map)).toList();
    print("jsonfaavo${json}");
    return favoritos;
  }

  static Future<List<PedidoItens>> getProduto(context, int produto) async {
    String url = "$BASE_URL/itens/produto/$produto";
    final response = await http.get(context,url);
    String json = response.body;
    List list = convert.json.decode(json);
    List<PedidoItens> favoritos =
    list.map<PedidoItens>((map) => PedidoItens.fromMap(map)).toList();
    return favoritos;
  }

  static Future<List<PedidoItens>> getEstoques(context, int produto,int licitacao) async {
    String url = "$BASE_URL/itens/estoques/$produto/$licitacao";
    print('url $url');
    final response = await http.get(context,url);

    String json = response.body;

    List list = convert.json.decode(json);

    List<PedidoItens> favoritos =

    list.map<PedidoItens>((map) => PedidoItens.fromMap(map)).toList();

    return favoritos;
  }

  static Future<ApiResponse<bool>> save(context, PedidoItens c) async {
    try {
      var url = "$BASE_URL/itens";
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

        PedidoItens empreendimento = PedidoItens.fromMap(mapResponse);

        print("PedidoItens salvo: ${empreendimento.id}");

        return ApiResponse.ok();
      }

      Map mapResponse = convert.json.decode(response.body);
      return ApiResponse.error(msg: mapResponse["error"]);
    } catch (e) {
      print(e);

      return ApiResponse.error(msg: "Não foi possível salvar o empreendimento");
    }
  }


  static Future<ApiResponse<bool>> delete(context, PedidoItens c) async {
    try {
      String url = "$BASE_URL/itens/${c.id}";

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
