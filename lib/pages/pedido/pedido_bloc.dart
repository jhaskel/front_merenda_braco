
import 'dart:async';

import 'package:merenda_escolar/pages/pedido/Pedido.dart';
import 'package:merenda_escolar/pages/pedido/pedido_api.dart';

import 'package:merenda_escolar/utils/network.dart';

class PedidoBloc {
  final _streamController = StreamController<List<Pedido>>();
  Stream<List<Pedido>> get stream => _streamController.stream;

  Future<List<Pedido>> fetch(context) async {
    try {
      if(!await isNetworkOn()) {

      }else{
        List<Pedido> dicas = await PedidoApi.get(context);
        _streamController.add(dicas);
        return dicas;
      }

    } catch (e) {
      if(! _streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }
  Future<List<Pedido>> fetchEscola(context, int escola) async {
    try {
      if(!await isNetworkOn()) {

      }else{
        List<Pedido> dicas = await PedidoApi.getByEscola(context,escola);
        _streamController.add(dicas);
        return dicas;
      }

    } catch (e) {
      if(! _streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }
  Future<List<Pedido>> fetchCode(context, String code) async {
    try {
      if(!await isNetworkOn()) {

      }else{
        List<Pedido> dicas = await PedidoApi.getByCode(context,code);
        _streamController.add(dicas);
        return dicas;
      }

    } catch (e) {
      if(! _streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }
  Future<List<Pedido>> fetchCheck(context, bool ischeck) async {
    try {
      if(!await isNetworkOn()) {

      }else{
        List<Pedido> dicas = await PedidoApi.getByCheck(context,ischeck);
        _streamController.add(dicas);
        return dicas;
      }

    } catch (e) {
      if(! _streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }
  Future<List<Pedido>> fetchId(context, int id) async {
    try {
      if(!await isNetworkOn()) {

      }else{
        List<Pedido> dicas = await PedidoApi.getById(context,id);
        _streamController.add(dicas);
        return dicas;
      }

    } catch (e) {
      if(! _streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }


  void dispose() {
    _streamController.close();

  }
}
