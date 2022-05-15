import 'dart:convert' as convert;

import 'package:merenda_escolar/web/utils/prefs.dart';





class Email {
 int id;
  String nome;
  String assunto;
  String content;
  String email;
  String created;


 Email({
      this.id, this.nome, this.assunto, this.content, this.email, this.created});

  Email.fromMap(Map<String, dynamic> map) {

  id = map['id'];
  nome = map['nome'];
  assunto = map['assunto'];
  content = map['content'];
  email = map['email'];
  created = map['created'];


  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['assunto'] = this.assunto;
    data['content'] = this.content;
    data['email'] = this.email;
    data['created'] = this.created;
    return data;
  }

  String toJson(){
    String json = convert.json.encode(toMap());
    return json;
  }

  static void clear() {
    Prefs.setString("user.prefs", "");
  }

  void save() {
    Map map = toMap();
    String json = convert.json.encode(map);
    Prefs.setString("user.prefs", json);
  }

  static Future<Email> getk() async {
    String json = await Prefs.getString("user.prefs");
    if(json.isEmpty) {
      return null;
    }
    Map map = convert.json.decode(json);
    Email user = Email.fromMap(map);
    return user;
  }

  @override
  String toString() {
    return 'Emailk{id: $nome,login: $assunto, nome: $email}';
  }


}


