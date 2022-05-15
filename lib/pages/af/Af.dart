import 'dart:convert' as convert;

import 'package:merenda_escolar/utils/utils.dart';



class Af {
  int id;
  int code;
  int fornecedor;
  int nivel;
  int setor;
  bool isenviado;
  String status;
  String empenho;
  bool isativo;
  String createdAt;
  int despesa;
  int coddespesa;
  int codedespesa;
  bool isdespesa;
  String processo;
  //não esta no banco
  String nomefor;
  double tot;
  int licitacao;



  Af(
      {this.id,
        this.code,
        this.nivel,
        this.setor,
        this.fornecedor,
        this.createdAt,
        this.isenviado,
        this.status,
        this.isativo,
        this.despesa,
        this.coddespesa,
        this.codedespesa,
        this.isdespesa,
        this.nomefor,
        this.tot,
        this.processo,
        this.empenho,
        this.licitacao,

      });

  Af.fromMap(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    fornecedor = json['fornecedor'];
    nivel = json['nivel'];
    setor = json['setor'];
    empenho = json['empenho'];

    createdAt = json['createdAt'];
    isenviado = json['isenviado'];
    status = json['status'];
    isativo = json['isativo'];
    despesa = json['despesa'];
    coddespesa = json['coddespesa'];
    codedespesa = json['codedespesa'];
    isdespesa = json['isdespesa'];
    processo = json['processo'];
    licitacao = json['licitacao'];

    nomefor = json['nomefor'];
    tot = json['tot'];

  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['nivel'] = this.nivel;
    data['setor'] = this.setor;
    data['fornecedor'] = this.fornecedor;
    data['createdAt'] = this.createdAt;
    data['isenviado'] = this.isenviado;
    data['isativo'] = this.isativo;
    data['status'] = this.status;
    data['despesa'] = this.despesa;
    data['coddespesa'] = this.coddespesa;
    data['codedespesa'] = this.codedespesa;
    data['isdespesa'] = this.isdespesa;
    data['processo'] = this.processo;
    data['tot'] = this.tot;
    data['nomefor'] = this.nomefor;
    data['empenho'] = this.empenho;
    data['licitacao'] = this.licitacao;

    return data;
  }
  String toJson() {
    Map map = toMap();
    String json = convert.json.encode(map);
    return json;
  }

  @override
  String toString() {
    return 'Usuariok{id: $id,code: $code, fornecedor: $Role,fornecedor, enviado: $isenviado}';
  }
}