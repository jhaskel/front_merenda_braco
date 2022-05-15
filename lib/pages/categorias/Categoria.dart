
import 'dart:convert' as convert;
class Categoria {
  int id;
  int icone;
  String nome;
  String image;
  bool isativo;
  bool isalimento;

  Categoria({this.id, this.nome,this.icone, this.image,this.isativo,this.isalimento});

  Categoria.fromMap(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    image = json['image'];
    isativo = json['isativo'];
    icone = json['icone'];
    isalimento = json['isalimento'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['image'] = this.image;
    data['isativo'] = this.isativo;
    data['icone'] = this.icone;
    data['isalimento'] = this.isalimento;
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