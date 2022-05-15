import 'dart:convert' as convert;

class Nivel {
  int id;
  int setor;
  String nome;
  bool isativo;
  bool isescola;
  String created;
  String modified;

  Nivel({this.id, this.nome, this.isescola,this.setor,this.isativo, this.created, this.modified});

  Nivel.fromMap(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    isativo = json['isativo'];
    created = json['created'];
    modified = json['modified'];
    setor = json['setor'];
    isescola = json['isescola'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['isativo'] = this.isativo;
    data['created'] = this.created;
    data['modified'] = this.modified;
    data['setor'] = this.setor;
    data['isescola'] = this.isescola;
    return data;
  }



  String toJson() {
    Map map = toMap();
    String json = convert.json.encode(map);
    return json;
  }


   @override
   String toString() {
     return 'Usuariok{id: $id,nome: $nome, fantasia: $nome, cpf: $id}';
   }
}