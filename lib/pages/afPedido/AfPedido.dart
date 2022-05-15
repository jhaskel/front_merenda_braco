import 'dart:convert' as convert;

class AfPedido {
  int id;
  int af;
  int setor;
  int pedido;
  double total;
  int nivel;
  int fornecedor;



  AfPedido(
      {this.id,
        this.af,
        this.setor,
        this.pedido,
        this.total,
        this.nivel,
        this.fornecedor,
      });

  AfPedido.fromMap(Map<String, dynamic> json) {
    id = json['id'];
    af = json['af'];
    fornecedor = json['fornecedor'];
    nivel = json['nivel'];
    pedido = json['pedido'];
    total = json['total'];
    setor = json['setor'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['af'] = this.af;
    data['fornecedor'] = this.fornecedor;
    data['nivel'] = this.nivel;
    data['pedido'] = this.pedido;
    data['total'] = this.total;
    data['setor'] = this.setor;
    return data;
  }
  String toJson() {
    Map map = toMap();
    String json = convert.json.encode(map);
    return json;
  }



   @override
   String toString() {
     return 'afPedido{id: $id,af: $af, pedido: $pedido, nivel: $nivel}';
   }
}