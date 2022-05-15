import 'dart:convert' as convert;
import 'package:merenda_escolar/app_model.dart';
import 'package:merenda_escolar/pages/login/login_page.dart';
import 'package:merenda_escolar/utils/nav.dart';
import 'package:merenda_escolar/utils/utils.dart';
import 'package:merenda_escolar/web/utils/prefs.dart';

// global
void logout(context) {
  Usuario.clear();
  Prefs.prefs.clear();
  AppModel.get(context).setUser(null);

  push(context, LoginPage(), replace: true);

  PagesModel.get(context).popAll();
}

class Usuario {
  int id;
  int setor;
  String nome;
  String email;
  String login;
  String senha;
  int escola;
  String nivel;
  bool isativo;

  String created;
  String modified;
  String token;
  List<String> roles;

  bool selected = false;

  Usuario(
      {this.id,
        this.login,
        this.setor,
        this.nome,
        this.email,
        this.senha,
        this.created,
        this.isativo,
        this.token,
        this.nivel,
        this.escola,
        this.modified,
        this.roles});

  Usuario.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    login = map['login'];
    nome = map['nome'];
    email = map['email'];
    senha = map['senha'];
    created = map['created'];
    isativo = map['isativo'];
    token = map['token'];
    nivel = map['nivel'];
    escola = map['escola'];
    modified = map['modified'];
    setor = map['setor'];
    roles = map['roles'] != null ? map['roles'].cast<String>() : null;
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['login'] = this.login;
    data['nome'] = this.nome;
    data['email'] = this.email;
    data['senha'] = this.senha;
    data['created'] = this.created;
    data['isativo'] = this.isativo;

    data['nivel'] = this.nivel;
    data['escola'] = this.escola;
    data['token'] = this.token;
    data['roles'] = this.roles;
    data['setor'] = this.setor;
    data['modified'] = this.modified;
    return data;
  }

  static void clear() {
    Prefs.setString("user.prefs", "");
  }

  void save() {
    Prefs.setString("user.prefs", toJson());
  }

  static Future<Usuario> get() async {
    String json = Prefs.getString("user.prefs");
    if (json.isEmpty) {
      return null;
    }
    Map map = convert.json.decode(json);
    Usuario user = Usuario.fromMap(map);
    return user;
  }

  String toJson() {
    Map map = toMap();
    String json = convert.json.encode(map);
    return json;
  }

  bool isAdmin() {
    return nivel != null && nivel.contains(Niveis.admin);
  }

  bool isUnidade() {
    return nivel != null && nivel.contains(Niveis.unidade);
  }


  bool isGerente() {
    return nivel != null && nivel.contains(Niveis.admin);
  }


  bool isMaster() {
    return nivel != null && nivel.contains(Niveis.master);
  }

  bool isFornecedor() {
    return nivel != null && nivel.contains(Niveis.fornecedor);
  }

  bool isEmpenho() {
    return nivel != null && nivel.contains(Niveis.empenho);
  }


  @override
  String toString() {
    return 'Usuario{login: $login, nome: $nome, escola: $escola}';
  }
}
