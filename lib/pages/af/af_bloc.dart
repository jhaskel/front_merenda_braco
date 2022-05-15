
import 'dart:async';

import 'package:merenda_escolar/pages/af/Af.dart';
import 'package:merenda_escolar/pages/af/af_api.dart';

import 'package:merenda_escolar/utils/network.dart';

class AfBloc {
  final _streamController = StreamController<List<Af>>();
  Stream<List<Af>> get stream => _streamController.stream;

  Future<List<Af>> fetch(context) async {
    try {
      if(!await isNetworkOn()) {

      }else{
        List<Af> dicas = await AfApi.get(context);
        _streamController.add(dicas);
        return dicas;
      }

    } catch (e) {
      if(! _streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }
  Future<List<Af>> fetchEscola(context, int escola) async {
    try {
      if(!await isNetworkOn()) {

      }else{
        List<Af> dicas = await AfApi.getByEscola(context,escola);
        _streamController.add(dicas);
        return dicas;
      }

    } catch (e) {
      if(! _streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }
  Future<List<Af>> fetchFornecedor(context, int fornecedor) async {
    try {
      if(!await isNetworkOn()) {

      }else{
        List<Af> dicas = await AfApi.getByFornecedor(context,fornecedor);
        _streamController.add(dicas);
        return dicas;
      }

    } catch (e) {
      if(! _streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }
  Future<List<Af>> fetchDespesa(context, bool isdespesa) async {
    try {
      if(!await isNetworkOn()) {

      }else{
        List<Af> dicas = await AfApi.getByDespesa(context,isdespesa);
        _streamController.add(dicas);
        return dicas;
      }

    } catch (e) {
      if(! _streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }
  Future<List<Af>> fetchStatus(context, String status) async {
    try {
      if(!await isNetworkOn()) {

      }else{
        List<Af> dicas = await AfApi.getByStatus(context,status);
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
