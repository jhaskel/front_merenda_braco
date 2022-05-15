import 'dart:convert' as convert;
class PedidoItens {
  int id;
  int setor;
  int cod;
  int pedido;
  int produto;
  int escola;
  int nivel;
  String alias;
  double quantidade;
  double valor;
  double total;
  int af;
  String obs;
  String created;
  int categoria;
  int fornecedor;
  bool ischeck;
  int idestoque;
  bool isagro;
  int ano;
  String nomenivel;
  String nomeescola;
  String unidade;
  String status;
  String mes;
  bool isativo;
 double totalAgro;
  double tot;
  String nomec;
  String processo;
  String diaEntrega;
  int licitacao;

  PedidoItens(
      {this.id,
        this.cod,
        this.pedido,
        this.produto,
        this.escola,
        this.nivel,
        this.alias,
        this.quantidade,
        this.valor,
        this.total,
        this.af,
        this.obs,
        this.categoria,
        this.fornecedor,
        this.created,
        this.ischeck,
        this.licitacao,

        this.ano,
        this.nomeescola,
        this.nomenivel,
        this.unidade,
        this.isagro,
        this.status,
        this.mes,
        this.setor,
        this.idestoque,

        this.isativo,
        this.processo,

      this.totalAgro,
        this.tot,
        this.nomec,
        this.diaEntrega
      });

  PedidoItens.fromMap(Map<String, dynamic> json) {
    id = json['id'];
    cod = json['cod'];
    pedido = json['pedido'];
    produto = json['produto'];
    escola = json['escola'];
    nivel = json['nivel'];
    alias = json['alias'];
    quantidade = json['quantidade'];
    valor = json['valor'];
    total = json['total'];
    af = json['af'];
    obs = json['obs'];
    created = json['created'];
    fornecedor = json['fornecedor'];
    categoria = json['categoria'];
    ischeck = json['ischeck'];
    idestoque = json['idestoque'];

    ano = json['ano'];
    nomenivel = json['nomenivel'];
    nomeescola = json['nomeescola'];
    unidade = json['unidade'];
    isagro = json['isagro'];
    status = json['status'];
    setor = json['setor'];
    mes = json['mes'];
    licitacao = json['licitacao'];

    isativo = json['isativo'];
    processo = json['processo'];

    totalAgro = json['totalAgro'];
   tot = json['tot'];
    nomec = json['nomec'];
    diaEntrega = json['diaEntrega'];

  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cod'] = this.cod;
    data['pedido'] = this.pedido;
    data['produto'] = this.produto;
    data['escola'] = this.escola;
    data['nivel'] = this.nivel;
    data['alias'] = this.alias;
    data['quantidade'] = this.quantidade;
    data['valor'] = this.valor;
    data['total'] = this.total;
    data['af'] = this.af;
    data['obs'] = this.obs;
    data['created'] = this.created;
    data['fornecedor'] = this.fornecedor;
    data['categoria'] = this.categoria;
    data['ischeck'] = this.ischeck;
    data['idestoque'] = this.idestoque;
    data['licitacao'] = this.licitacao;

    data['ano'] = this.ano;
    data['nomenivel'] = this.nomenivel;
    data['nomeescola'] = this.nomeescola;
    data['unidade'] = this.unidade;
    data['isagro'] = this.isagro;
    data['status'] = this.status;
    data['mes'] = this.mes;
    data['setor'] = this.setor;
    data['isativo'] = this.isativo;
    data['processo'] = this.processo;

    data['totalAgro'] = this.totalAgro;
   data['tot'] = this.tot;
    data['nomec'] = this.nomec;
    data['diaEntrega'] = this.diaEntrega;

    return data;
  }
  String toJson() {
    Map map = toMap();
    String json = convert.json.encode(map);
    return json;
  }


   @override
   String toString() {
     return 'Usuariok{id: $produto,escola: $nomeescola, categoria: $categoria, produto: $produto,entrega$diaEntrega}';
   }
}