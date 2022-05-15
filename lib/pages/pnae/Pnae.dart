import 'dart:convert' as convert;
class Pnae {
  int id;
  double valor;
  String created;
  int ano;

  int cidade;

  Pnae({this.id, this.valor, this.created, this.ano, this.cidade});

  Pnae.fromMap(Map<String, dynamic> json) {
    id = json['id'];
    valor = json['valor'];
    created = json['created'];
    ano = json['ano'];
    cidade = json['cidade'];

  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['valor'] = this.valor;
    data['created'] = this.created;
    data['ano'] = this.ano;
    data['cidade'] = this.cidade;

    return data;

}
  String toJson() {
    Map map = toMap();
    String json = convert.json.encode(map);
    return json;
  }


   @override
   String toString() {
     return 'Pnae{id: $id,valor: $valor, ano: $ano, created: $created}';
   }
}