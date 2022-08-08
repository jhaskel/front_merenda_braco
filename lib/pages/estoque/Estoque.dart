import 'dart:convert' as convert;

import 'package:merenda_escolar/web/utils/prefs.dart';


class Estoque {
  int id;
  int produto;
  int setor;
  int code;
  String alias;
  String nomeproduto;
  double quantidade;
  String unidade;
  int categoria;
  int licitacao;
  int fornecedor;
  bool agrofamiliar;
  double valor;
  int ano;
  String createdAt;
  bool isativo;
  String modifiedAt;
  String processo;
  String nomefornecedor;
  //join
  double comprado;
  String nomecategoria;
  String nomelicitacao;


  Estoque(
      {this.id,
      this.produto,
      this.setor,
      this.code,
      this.alias,
      this.nomeproduto,
      this.categoria,
      this.licitacao,
      this.fornecedor,
      this.quantidade,
      this.valor,
      this.unidade,
      this.agrofamiliar,
      this.ano,
      this.isativo,
      this.createdAt,
      this.modifiedAt,
      this.processo,
      this.comprado,
      this.nomecategoria,
      this.nomelicitacao,
      this.nomefornecedor,

      });

  Estoque.fromMap(Map<String, dynamic> json) {
    id = json['id'];
    produto = json['produto'];
    setor = json['setor'];
    categoria = json['categoria'];
    licitacao = json['licitacao'];
    fornecedor = json['fornecedor'];
    code = json['code'];
    alias = json['alias'];
    nomeproduto = json['nomeproduto'];
    quantidade = json['quantidade'];
    valor = json['valor'];
    unidade = json['unidade'];
    agrofamiliar = json['agrofamiliar'];
    ano = json['ano'];
    isativo = json['isativo'];
    createdAt = json['createdAt'];
    modifiedAt = json['modifiedAt'];
    processo = json['processo'];
    comprado = json['comprado'];
    nomecategoria = json['nomecategoria'];
    nomelicitacao = json['nomelicitacao'];
    nomefornecedor = json['nomefornecedor'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['produto'] = this.produto;
    data['setor'] = this.setor;
    data['categoria'] = this.categoria;
    data['licitacao'] = this.licitacao;
    data['fornecedor'] = this.fornecedor;
    data['code'] = this.code;
    data['alias'] = this.alias;
    data['nomeproduto'] = this.nomeproduto;
    data['quantidade'] = this.quantidade;
    data['valor'] = this.valor;
    data['unidade'] = this.unidade;
    data['agrofamiliar'] = this.agrofamiliar;
    data['ano'] = this.ano;
    data['isativo'] = this.isativo;
    data['createdAt'] = this.createdAt;
    data['modifiedAt'] = this.modifiedAt;
    data['processo'] = this.processo;
    data['comprado'] = this.comprado;
    data['nomecategoria'] = this.nomecategoria;
    data['nomelicitacao'] = this.nomelicitacao;
    data['nomefornecedor'] = this.nomefornecedor;
    return data;
  }

  static void clear() {
    Prefs.setString("pro.prefs", "");
  }

  void save() {
    Prefs.setString("pro.prefs", toJson());
  }

  static Future<Estoque> get() async {
    String json = Prefs.getString("pro.prefs");
    if (json.isEmpty) {
      return null;
    }
    Map map = convert.json.decode(json);
    Estoque pro = Estoque.fromMap(map);
    return pro;
  }

  String toJson() {
    Map map = toMap();
    String json = convert.json.encode(map);
    return json;
  }

  @override
  String toString() {
    return 'Usuariok{id: $id,nome: $alias, valor: $valor, quantidade:$quantidade, unidade: $unidade,comprado:$comprado,agrofamiliar:$agrofamiliar,isativo:$isativo}';
  }
}
