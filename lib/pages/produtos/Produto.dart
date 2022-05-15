import 'dart:convert' as convert;

import 'package:merenda_escolar/web/utils/prefs.dart';



class Produto {
  int id;
  String nome;
  String alias;
  String unidade;



  Produto(
      {this.id,

        this.nome,
        this.alias,
        this.unidade,


      });

  Produto.fromMap(Map<String, dynamic> json) {
    id = json['id'];

    nome = json['nome'];
    alias = json['alias'];

    unidade = json['unidade'];

  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;

    data['nome'] = this.nome;
    data['alias'] = this.alias;

    data['unidade'] = this.unidade;


    return data;
  }

  static void clear() {
    Prefs.setString("pro.prefs", "");
  }

  void save() {
    Prefs.setString("pro.prefs", toJson());
  }

  static Future<Produto> get() async {
    String json = Prefs.getString("pro.prefs");
    if (json.isEmpty) {
      return null;
    }
    Map map = convert.json.decode(json);
    Produto pro = Produto.fromMap(map);
    return pro;
  }
  String toJson() {
    Map map = toMap();
    String json = convert.json.encode(map);
    return json;
  }


  @override
  String toString() {
    return 'Usuariok{id: $id,nome: $nome, fantasia: $nome, unidade: $id}';
  }
}