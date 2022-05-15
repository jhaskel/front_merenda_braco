import 'dart:convert' as convert;

class UnidadeEscolar {
  int id;
  int nivelescolar;
  int setor;
  String nome;
  String alias;
  String endereco;
  String bairro;
  int alunos;
  bool isativo;
  bool isescola;
  String created;
  String modified;

  UnidadeEscolar(
      {this.id,
        this.nivelescolar,
        this.setor,
        this.nome,
        this.alias,
        this.endereco,
        this.bairro,
        this.alunos,
        this.isativo,
        this.isescola,
        this.created,
        this.modified});

  UnidadeEscolar.fromMap(Map<String, dynamic> json) {
    id = json['id'];
    nivelescolar = json['nivelescolar'];
    setor = json['setor'];
    nome = json['nome'];
    alias = json['alias'];
    endereco = json['endereco'];
    bairro = json['bairro'];
    alunos = json['alunos'];
    isativo = json['isativo'];
    created = json['created'];
    modified = json['modified'];
    isescola = json['isescola'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nivelescolar'] = this.nivelescolar;
    data['setor'] = this.setor;
    data['nome'] = this.nome;
    data['alias'] = this.alias;
    data['endereco'] = this.endereco;
    data['bairro'] = this.bairro;
    data['alunos'] = this.alunos;
    data['isativo'] = this.isativo;
    data['created'] = this.created;
    data['modified'] = this.modified;
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