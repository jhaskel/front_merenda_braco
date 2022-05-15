import 'dart:convert' as convert;
class PedidoAdd {
  int id;
  int escola;
  int licitacao;
  double total;
  String status;
  String user;
  bool isaf;
  String createdAt;
  String modifiedAt;
  bool isativo;
  bool ischeck;
  

  PedidoAdd(
      {this.id,
        this.escola,
        this.total,
        this.status,
        this.isaf,
        this.user,
        this.createdAt,
        this.modifiedAt,
        this.isativo,
        this.ischeck,
        this.licitacao,
      });

  PedidoAdd.fromMap(Map<String, dynamic> json) {
    id = json['id'];
    escola = json['escola'];
    total = json['total'];
    status = json['status'];
    user = json['user'];
    isaf = json['isaf'];
    createdAt = json['createdAt'];
    modifiedAt = json['modifiedAt'];
    isativo = json['isativo'];
    ischeck = json['ischeck'];
    licitacao = json['licitacao'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['escola'] = this.escola;
    data['user'] = this.user;
    data['total'] = this.total;
    data['status'] = this.status;
    data['isaf'] = this.isaf;
    data['createdAt'] = this.createdAt;
    data['modifiedAt'] = this.modifiedAt;
    data['isativo'] = this.isativo;
    data['ischeck'] = this.ischeck;
    data['licitacao'] = this.licitacao;
    return data;
  }
  String toJson() {
    Map map = toMap();
    String json = convert.json.encode(map);
    return json;
  }


  @override
  String toString() {
    return 'Usuariok{id: $id,escola: $escola, produto: $escola, escola: $id}';
  }
}