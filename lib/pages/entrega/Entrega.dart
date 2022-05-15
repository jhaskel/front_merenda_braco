import 'dart:convert';

class Entrega {
  int id;
  int ordem;
  int pedido;
  int escola;
  String dia;
  String nomeescola;
  int produto;
  int licitacao;
  String alias;
  String unidade;
  String fornecedor;
  double quantidade;
  double valor;
  bool isrecebido;
  int categoria;

  Entrega({
     this.id,
     this.ordem,
     this.pedido,
     this.escola,
     this.dia,
     this.produto,
     this.unidade,
     this.fornecedor,
     this.quantidade,
     this.valor,
     this.nomeescola,
     this.isrecebido,
     this.alias,
     this.licitacao,
     this.categoria,

  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ordem': ordem,
      'pedido': pedido,
      'escola': escola,
      'dia': dia,
      'produto': produto,
      'unidade': unidade,
      'quantidade': quantidade,
       'fornecedor': fornecedor,
       'valor': valor,
       'nomeescola': nomeescola,
       'isrecebido': isrecebido,
       'alias': alias,
       'licitacao': licitacao,
       'categoria': categoria,
    };
  }

  factory Entrega.fromMap(Map<String, dynamic> map) {
    return Entrega(
      id: map['id'],
      ordem: map['ordem'],
      pedido: map['pedido'],
      escola: map['escola'],
      dia: map['dia'],
      produto: map['produto'],
      unidade: map['unidade'],
      quantidade: map['quantidade'],
       fornecedor: map['fornecedor'],
       valor: map['valor'],
       nomeescola: map['nomeescola'],
      isrecebido: map['isrecebido'],
      alias: map['alias'],
      licitacao: map['licitacao'],
      categoria: map['categoria'],

    );
  }

  String toJson() => json.encode(toMap());

  factory Entrega.fromJson(String source) => Entrega.fromMap(json.decode(source));
}
