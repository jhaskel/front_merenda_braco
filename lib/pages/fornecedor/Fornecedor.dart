
import 'dart:convert' as convert;
class Fornecedor {
  int id;
  String nome;
  String cnpj;
  String alias;
  String email;
  String celular;
  bool isativo;


  Fornecedor(
      {this.id,
        this.nome,
        this.cnpj,
        this.alias,
        this.email,
        this.celular,
        this.isativo,

       });

  Fornecedor.fromMap(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    cnpj = json['cnpj'];
    alias = json['alias'];

    email = json['email'];
    celular = json['celular'];
    isativo = json['isativo'];

  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['cnpj'] = this.cnpj;
    data['alias'] = this.alias;
    data['email'] = this.email;
    data['celular'] = this.celular;
    data['isativo'] = this.isativo;
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