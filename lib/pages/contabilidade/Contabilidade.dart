import 'dart:convert' as convert;

class Contabilidade {
  int id;
  int orgao;
  String nomeOrgao;
  int unidade;
  String nomeUnidade;
  int projeto;
  String nomeProjeto;
  String nomeReceita;
  int cod;
  int code;
  String elemento;
  int nivel;
  double orcamento;

  Contabilidade(
      {this.id,
        this.orgao,
        this.nomeOrgao,
        this.unidade,
        this.nomeUnidade,
        this.projeto,
        this.nomeProjeto,
        this.nomeReceita,
        this.cod,
        this.code,
        this.elemento,
        this.nivel,
        this.orcamento
      });

  Contabilidade.fromMap(Map<String, dynamic> json) {
    id = json['id'];
    orgao = json['orgao'];
    nomeOrgao = json['nomeOrgao'];
    unidade = json['unidade'];
    nomeUnidade = json['nomeUnidade'];
    projeto = json['projeto'];
    nomeProjeto = json['nomeProjeto'];
    cod = json['cod'];
    code = json['code'];
    elemento = json['elemento'];
    nivel = json['nivel'];
    orcamento = json['orcamento'];
    nomeReceita = json['nomeReceita'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['orgao'] = this.orgao;
    data['nomeOrgao'] = this.nomeOrgao;
    data['unidade'] = this.unidade;
    data['nomeUnidade'] = this.nomeUnidade;
    data['projeto'] = this.projeto;
    data['nomeProjeto'] = this.nomeProjeto;
    data['cod'] = this.cod;
    data['code'] = this.code;
    data['elemento'] = this.elemento;
    data['nivel'] = this.nivel;
    data['orcamento'] = this.orcamento;
    data['nomeReceita'] = this.nomeReceita;
    return data;
  }
  String toJson() {
    Map map = toMap();
    String json = convert.json.encode(map);
    return json;
  }



   @override
   String toString() {
     return 'Contaibiidadade{id: $id,orgao: $orgao, nomeorga: $nomeOrgao, nivel: $nivel}';
   }
}