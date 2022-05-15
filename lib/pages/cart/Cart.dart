import 'dart:convert' as convert;

import 'package:start_chart/chart/utils/date_format_util.dart';

class Cart {
  int id;
  int escola;
  int produto;
  int idestoque;
  int categoria;
  int licitacao;
  int fornecedor;
  String alias;
  String unidade;
  String processo;
  int cod;
  double quantidade;
  double valor;
  double total;
  String createdAt;
  String nomeescola;
  String nomefornecedor;
  bool isagro;


  Cart(
      {this.id,
        this.escola,
        this.produto,
        this.categoria,
        this.licitacao,
        this.fornecedor,
        this.idestoque,
        this.alias,
        this.unidade,
        this.cod,
        this.quantidade,
        this.valor,
        this.total,
        this.createdAt,
        this.isagro,
        this.nomeescola,
        this.nomefornecedor,
        this.processo,
      });

  Cart.fromMap(Map<String, dynamic> json) {
    id = json['id'];
    escola = json['escola'];
    produto = json['produto'];
    categoria = json['categoria'];
    licitacao = json['licitacao'];
    fornecedor = json['fornecedor'];
    unidade = json['unidade'];
    cod = json['cod'];
    alias = json['alias'];
    idestoque = json['idestoque'];
    quantidade = json['quantidade'];
    valor = json['valor'];
    total = json['total'];
    createdAt = json['created'];
    isagro = json['isagro'];
    nomeescola = json['nomeescola'];
    nomefornecedor = json['nomefornecedor'];
    processo = json['processo'];

  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['escola'] = this.escola;
    data['produto'] = this.produto;
    data['categoria'] = this.categoria;
    data['licitacao'] = this.licitacao;
    data['fornecedor'] = this.fornecedor;
    data['unidade'] = this.unidade;
    data['cod'] = this.cod;
    data['alias'] = this.alias;
    data['quantidade'] = this.quantidade;
    data['valor'] = this.valor;
    data['idestoque'] = this.idestoque;
    data['total'] = this.total;
    data['createdAt'] = this.createdAt;
    data['isagro'] = this.isagro;
    data['nomeescola'] = this.nomeescola;
    data['nomefornecedor'] = this.nomefornecedor;
    data['processo'] = this.processo;

    return data;
  }
  String toJson() {
    Map map = toMap();
    String json = convert.json.encode(map);
    return json;
  }


  @override
  String toString() {
    return 'Usuariok{id: $id,escola: $escola, produto: $produto, unidade: $id}';
  }
}