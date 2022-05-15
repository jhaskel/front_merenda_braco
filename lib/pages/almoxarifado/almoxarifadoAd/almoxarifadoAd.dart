import 'dart:convert' as convert;
class AlmoxarifadoAd {
  int id;
  int produto;
  int licitacao;
  int escola;
  String alias;
  int quantidade;
  String created;
  int categoria;
  String nomeescola;
  String unidade;
  bool isativo;
  bool istroca;
  String obs;


  AlmoxarifadoAd(
      {this.id,
        this.produto,
        this.licitacao,
        this.escola,
        this.alias,
        this.quantidade,
        this.categoria,
        this.created,
        this.nomeescola,
        this.unidade,
        this.isativo,
        this.istroca,
        this.obs,

      });

  AlmoxarifadoAd.fromMap(Map<String, dynamic> json) {
    id = json['id'];
    produto = json['produto'];
    escola = json['escola'];
    licitacao = json['licitacao'];
    alias = json['alias'];
    quantidade = json['quantidade'];
    created = json['created'];
    categoria = json['categoria'];
    nomeescola = json['nomeescola'];
    unidade = json['unidade'];
    isativo = json['isativo'];
    istroca = json['istroca'];
    obs = json['obs'];


  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['produto'] = this.produto;
    data['licitacao'] = this.licitacao;
    data['escola'] = this.escola;
    data['alias'] = this.alias;
    data['quantidade'] = this.quantidade;
    data['created'] = this.created;
    data['categoria'] = this.categoria;
    data['nomeescola'] = this.nomeescola;
    data['unidade'] = this.unidade;
    data['isativo'] = this.isativo;
    data['istroca'] = this.istroca;
    data['obs'] = this.obs;


    return data;
  }

  String toJson() {
    Map map = toMap();
    String json = convert.json.encode(map);
    return json;
  }


   @override
   String toString() {
     return 'Usuariok{id: $id,escola: $escola, categoria: $categoria, produto: $produto,quant$isativo}';
   }
}