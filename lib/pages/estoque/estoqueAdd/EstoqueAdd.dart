import 'dart:convert' as convert;

import 'package:merenda_escolar/web/utils/prefs.dart';


class EstoqueAd {
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
  String processo;
  int fornecedor;
  bool agrofamiliar;
  double valor;
  int ano;
  String createdAt;
  bool isativo;
  String modifiedAt;



  EstoqueAd(
      {this.id,
      this.produto,
      this.setor,
      this.code,
      this.alias,
      this.nomeproduto,
      this.categoria,
      this.licitacao,
      this.processo,
      this.fornecedor,
      this.quantidade,
      this.valor,
      this.unidade,
      this.agrofamiliar,
      this.ano,
      this.isativo,
      this.createdAt,
      this.modifiedAt,


    
      });

  EstoqueAd.fromMap(Map<String, dynamic> json) {
    id = json['id'];
    produto = json['produto'];
    setor = json['setor'];
    categoria = json['categoria'];
    licitacao = json['licitacao'];
    processo = json['processo'];
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

   
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['produto'] = this.produto;
    data['setor'] = this.setor;
    data['categoria'] = this.categoria;
    data['licitacao'] = this.licitacao;
    data['processo'] = this.processo;
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

    return data;
  }

  static void clear() {
    Prefs.setString("pro.prefs", "");
  }

  void save() {
    Prefs.setString("pro.prefs", toJson());
  }

  static Future<EstoqueAd> get() async {
    String json = Prefs.getString("pro.prefs");
    if (json.isEmpty) {
      return null;
    }
    Map map = convert.json.decode(json);
    EstoqueAd pro = EstoqueAd.fromMap(map);
    return pro;
  }

  String toJson() {
    Map map = toMap();
    String json = convert.json.encode(map);
    return json;
  }

  @override
  String toString() {
    return 'Usuariok{id: $id,nome: $alias, quantidade: $quantidade, unidade: $unidade}';
  }
}
