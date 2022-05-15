
import 'dart:async';

import 'package:merenda_escolar/pages/pedidoItens/PedidoItens.dart';
import 'package:merenda_escolar/pages/pedidoItens/PedidoItens_api.dart';

import 'package:merenda_escolar/utils/network.dart';
import 'package:http/http.dart' as htttp;

class PedidoItensBloc {
  final _streamController = StreamController<List<PedidoItens>>();
  Stream<List<PedidoItens>> get stream => _streamController.stream;

  Future<List<PedidoItens>> fetch(context) async {
    try {
      if(!await isNetworkOn()) {

      }else{
        List<PedidoItens> dicas = await PedidoItensApi.get(context);
        _streamController.add(dicas);
        return dicas;
      }

    } catch (e) {
      if(! _streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }
  Future<List<PedidoItens>> fetchEscola(context, int escola,int pedido) async {
    try {
      if(!await isNetworkOn()) {

      }else{
        List<PedidoItens> dicas = await PedidoItensApi.getByEscolar(context,escola,pedido);
        _streamController.add(dicas);
        return dicas;
      }

    } catch (e) {
      if(! _streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }
  Future<List<PedidoItens>> fetchEscolar(context, int escola,int ano) async {
    try {
      if(!await isNetworkOn()) {

      }else{
        List<PedidoItens> dicas = await PedidoItensApi.getByEscolar(context,escola,ano);
        _streamController.add(dicas);
        return dicas;
      }

    } catch (e) {
      if(! _streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }
  Future<List<PedidoItens>> fetchPedido(context, String  pedido) async {
    try {
      if(!await isNetworkOn()) {

      }else{
        List<PedidoItens> dicas = await PedidoItensApi.getByPedido(context,pedido);
        _streamController.add(dicas);
        return dicas;
      }

    } catch (e) {
      if(! _streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }
  Future<List<PedidoItens>> fetchAfi(context,) async {
    try {
      if(!await isNetworkOn()) {

      }else{
        List<PedidoItens> dicas = await PedidoItensApi.getByAfi(context);
        _streamController.add(dicas);
        return dicas;
      }

    } catch (e) {
      if(! _streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }
  Future<List<PedidoItens>> fetchAf(context,int af) async {
    try {
      if(!await isNetworkOn()) {

      }else{
        List<PedidoItens> dicas = await PedidoItensApi.getByAf(context,af);
        _streamController.add(dicas);
        return dicas;
      }

    } catch (e) {
      if(! _streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }
  Future<List<PedidoItens>> fetchPedidoAll(context, String  pedido) async {
    try {
      if(!await isNetworkOn()) {

      }else{
        List<PedidoItens> dicas = await PedidoItensApi.getByPedidoAll(context,pedido);
        _streamController.add(dicas);
        return dicas;
      }

    } catch (e) {
      if(! _streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }
  Future<List<PedidoItens>> fetchPedidosGroup(context,) async {
    try {
      if(!await isNetworkOn()) {

      }else{
        List<PedidoItens> dicas = await PedidoItensApi.getByPedidoGroup(context);
        _streamController.add(dicas);
        return dicas;
      }

    } catch (e) {
      if(! _streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }
  Future<List<PedidoItens>> fetchAno(context, int ano) async {
    try {
      if(!await isNetworkOn()) {

      }else{
        List<PedidoItens> dicas = await PedidoItensApi.getAno(context,ano);
        _streamController.add(dicas);
        return dicas;
      }

    } catch (e) {
      if(! _streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }
  Future<List<PedidoItens>> fetchEscolaAll(context, int ano) async {
    try {
      if(!await isNetworkOn()) {

      }else{
        List<PedidoItens> dicas = await PedidoItensApi.getByEscolaAll(context,ano);
        _streamController.add(dicas);
        return dicas;
      }

    } catch (e) {
      if(! _streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }
  Future<List<PedidoItens>> fetchTotalMes(context, int ano) async {
    print("YESW");
    try {
      if(!await isNetworkOn()) {

      }else{
        List<PedidoItens> dicas = await PedidoItensApi.getByTotalMes(context,ano,true);
        _streamController.add(dicas);
        return dicas;
      }

    } catch (e) {
      if(! _streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }
  Future<List<PedidoItens>> fetchTotalMesNivel(context, int nivel,int ano) async {
    try {
      if(!await isNetworkOn()) {

      }else{
        List<PedidoItens> dicas = await PedidoItensApi.getByTotalMesNivel(context,nivel,ano);
        _streamController.add(dicas);
        return dicas;
      }

    } catch (e) {
      if(! _streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }
  Future<List<PedidoItens>> fetchTotalMesEscola(context, int escola,int ano) async {
    print("YES");
    try {
      if(!await isNetworkOn()) {

      }else{
        List<PedidoItens> dicas = await PedidoItensApi.getByTotalMesEscola(context,escola,ano);
        _streamController.add(dicas);
        return dicas;
      }

    } catch (e) {
      if(! _streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }
  Future<List<PedidoItens>> fetchTotalCategoria(context, int ano) async {
    try {
      if(!await isNetworkOn()) {

      }else{
        List<PedidoItens> dicas = await PedidoItensApi.getByTotalCategoria(context,ano);
        _streamController.add(dicas);
        return dicas;
      }

    } catch (e) {
      if(! _streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }
  Future<List<PedidoItens>> fetchTotalCategoriaNivel(context, int nivel,int ano) async {
    try {
      if(!await isNetworkOn()) {

      }else{
        List<PedidoItens> dicas = await PedidoItensApi.getByTotalCategoriaNivel(context,nivel,ano);
        _streamController.add(dicas);
        return dicas;
      }

    } catch (e) {
      if(! _streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }
  Future<List<PedidoItens>> fetchTotalCategoriaEscola(context, int escola,int ano) async {
    try {
      if(!await isNetworkOn()) {

      }else{
        List<PedidoItens> dicas = await PedidoItensApi.getByTotalCategoriaEscola(context,escola,ano);
        _streamController.add(dicas);
        return dicas;
      }

    } catch (e) {
      if(! _streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }
  Future<List<PedidoItens>> fetchTotalEscola(context, int ano) async {
    try {
      if(!await isNetworkOn()) {

      }else{
        List<PedidoItens> dicas = await PedidoItensApi.getByTotalEscola(context,ano);
        _streamController.add(dicas);
        return dicas;
      }

    } catch (e) {
      if(! _streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }
  Future<List<PedidoItens>> fetchTotalEscolaNivel(context, int nivel,int ano) async {
    try {
      if(!await isNetworkOn()) {

      }else{
        List<PedidoItens> dicas = await PedidoItensApi.getByTotalEscolaNivel(context,nivel,ano);
        _streamController.add(dicas);
        return dicas;
      }

    } catch (e) {
      if(! _streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }
  Future<List<PedidoItens>> fetchTotalEscolaEscola(context, int escola,int ano) async {
    try {
      if(!await isNetworkOn()) {

      }else{
        List<PedidoItens> dicas = await PedidoItensApi.getByTotalEscolaNivel(context,escola,ano);
        _streamController.add(dicas);
        return dicas;
      }

    } catch (e) {
      if(! _streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }
  Future<List<PedidoItens>> fetchMediaAlunos(context, int ano) async {
    try {
      if(!await isNetworkOn()) {

      }else{
        List<PedidoItens> dicas = await PedidoItensApi.getByMediaAlunos(context,ano);
        _streamController.add(dicas);
        return dicas;
      }

    } catch (e) {
      if(! _streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }
  Future<List<PedidoItens>> fetchMediaAlunosNivel(context, int nivel,int ano) async {
    try {
      if(!await isNetworkOn()) {

      }else{
        List<PedidoItens> dicas = await PedidoItensApi.getByMediaAlunosNivel(context,nivel,ano);
        _streamController.add(dicas);
        return dicas;
      }

    } catch (e) {
      if(! _streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }
  Future<List<PedidoItens>> fetchMediaAlunosEscola(context, int escola,int ano) async {
    try {
      if(!await isNetworkOn()) {

      }else{
        List<PedidoItens> dicas = await PedidoItensApi.getByMediaAlunosNivel(context,escola,ano);
        _streamController.add(dicas);
        return dicas;
      }

    } catch (e) {
      if(! _streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }

  Future<List<PedidoItens>> fetchProdutos(context, int produto,int ano) async {
    try {
      if(!await isNetworkOn()) {

      }else{
        List<PedidoItens> dicas = await PedidoItensApi.getByProdutos(context,produto,ano);
        _streamController.add(dicas);
        return dicas;
      }

    } catch (e) {
      if(! _streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }
  Future<List<PedidoItens>> fetchMaisPedidos(context,int ano) async {
    try {
      if(!await isNetworkOn()) {

      }else{
        List<PedidoItens> dicas = await PedidoItensApi.getMaisPedido(context,ano);
        _streamController.add(dicas);
        return dicas;
      }

    } catch (e) {
      if(! _streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }

  Future<List<PedidoItens>> fetchProduto(context, int produto) async {
    try {
      List<PedidoItens> dados = await PedidoItensApi.getProduto(context, produto);
      _streamController.add(dados);
      return dados;
    } catch (e) {
      if (!_streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }

  Future<List<PedidoItens>> fetchEstoques(context, int produto, int licitacao) async {
    try {

      List<PedidoItens> dados = await PedidoItensApi.getEstoques(context, produto,licitacao);
      _streamController.add(dados);
      return dados;
    } catch (e) {

      if (!_streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }



  void dispose() {
    _streamController.close();

  }
}
