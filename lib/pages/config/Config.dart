
import 'dart:convert' as convert;
class Config {
  int id;
  String entidade;
  String setor;
  String nomeContato;
  String cargo;
  String email;
  String celular;
  bool isativo;
  String created;
  Null modified;

  Config(
      {this.id,
        this.entidade,
        this.setor,
        this.nomeContato,
        this.cargo,
        this.email,
        this.celular,
        this.isativo,
        this.created,
        this.modified});

  Config.fromMap(Map<String, dynamic> json) {
    id = json['id'];
    entidade = json['entidade'];
    setor = json['setor'];
    nomeContato = json['nomeContato'];
    cargo = json['cargo'];
    email = json['email'];
    celular = json['celular'];
    isativo = json['isativo'];
    created = json['created'];
    modified = json['modified'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['entidade'] = this.entidade;
    data['setor'] = this.setor;
    data['nomeContato'] = this.nomeContato;
    data['cargo'] = this.cargo;
    data['email'] = this.email;
    data['celular'] = this.celular;
    data['isativo'] = this.isativo;
    data['created'] = this.created;
    data['modified'] = this.modified;
    return data;
  }

  String toJson() {
    String json = convert.json.encode(toMap());
    return json;
  }


  @override
  String toString() {
    return 'Protocolo{id: $id,login: $celular, nome: $nomeContato}';
  }
}