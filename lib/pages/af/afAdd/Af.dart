import 'dart:convert' as convert;

class AfAdd {
  int id;
  int nivel;
  int setor;
  int code;
  int fornecedor;  
  bool isenviado;
  String status;
  String empenho;
  bool isativo;
  String createdAt;
  String processo;
  int despesa;
  int coddespesa;
  int codedespesa;
  bool isdespesa;
  int licitacao;


  AfAdd(
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
        this.processo,
        this.empenho,
        this.licitacao,


      });

  AfAdd.fromMap(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    nivel = json['nivel'];
    setor = json['setor'];
    fornecedor = json['fornecedor'];
    createdAt = json['createdAt'];
    isenviado = json['isenviado'];
    status = json['status'];
    isativo = json['isativo'];
    despesa = json['despesa'];
    coddespesa = json['coddespesa'];
    codedespesa = json['codedespesa'];
    isdespesa = json['isdespesa'];
    processo = json['processo'];
    empenho = json['empenho'];
    licitacao = json['licitacao'];


  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nivel'] = this.nivel;
    data['setor'] = this.setor;
    data['code'] = this.code;
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
     return 'Af{id: $id,code: $code, fornecedor: $fornecedor, enviado: $isenviado}';
   }
}