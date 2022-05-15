import 'dart:convert' as convert;

import 'package:merenda_escolar/utils/utils.dart';

class Licitacao {
  int id;
  int ano;
  String processo;
  String edital;
  String objeto;
  String alias;
  double valorfinal;
  String prazo;
  String homologadoAt;
  String createdAt;
  String modifiedAt;
  bool isativo;

  Licitacao({
      this.id,
      this.ano,
      this.processo,
      this.edital,
      this.objeto,
      this.alias,
      this.valorfinal,
      this.prazo,
      this.homologadoAt,
      this.createdAt,
      this.modifiedAt,
      this.isativo});

  Licitacao.fromMap(Map<String, dynamic> json) {
    id = json['id'];
    ano = json['ano'];
    processo = json['processo'];
    edital = json['edital'];
    objeto = json['objeto'];
    alias = json['alias'];
    valorfinal = json['valorfinal'];
    prazo = json['prazo'];
    homologadoAt = json['homologadoAt'];
    isativo = json['isativo'];
    createdAt = json['createdAt'];
    modifiedAt = json['modifiedAt'];

  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ano'] = this.ano;
    data['processo'] = this.processo;
    data['edital'] = this.edital;
    data['objeto'] = this.objeto;
    data['alias'] = this.alias;
    data['valorfinal'] = this.valorfinal;
    data['prazo'] = this.prazo;
    data['homologadoAt'] = this.homologadoAt;
    data['isativo'] = this.isativo;
    data['createdAt'] = this.createdAt;
    data['modifiedAt'] = this.modifiedAt;

    return data;
  }
  String toJson() {
    Map map = toMap();
    String json = convert.json.encode(map);
    return json;
  }

  @override
  String toString() {
    return 'Licitacaok{id: $id,objeto: $objeto, processo: $processo,edital: $edital}';
  }


}