
import 'dart:convert' as convert;

class Setor {
  int id;
  String nome;
  bool isativo;
  String createdAt;
  String modifiedAt;


  Setor({this.id, this.nome,this.isativo,this.createdAt,this.modifiedAt});

  Setor.fromMap(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    isativo = json['isativo'];
    modifiedAt = json['modifiedAt'];
    createdAt = json['createdAt'];

  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['isativo'] = this.isativo;
    data['modifiedAt'] = this.modifiedAt;
    data['createdAt'] = this.createdAt;

    return data;
  }

  String toJson() {
    String json = convert.json.encode(toMap());
    return json;
  }


  @override
  String toString() {
    return 'Usuariok{id: $id,nome: $nome}';
  }
}