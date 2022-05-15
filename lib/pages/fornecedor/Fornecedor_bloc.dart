

import 'dart:async';

import 'package:merenda_escolar/pages/fornecedor/Fornecedor.dart';
import 'package:merenda_escolar/pages/fornecedor/Fornecedor_api.dart';
import 'package:merenda_escolar/utils/network.dart';

class FornecedorBloc {
  final _streamController = StreamController<List<Fornecedor>>();
  Stream<List<Fornecedor>> get stream => _streamController.stream;


  Future<List<Fornecedor>> fetch(context) async {
    try {
      if(!await isNetworkOn()) {

      }else{
        List<Fornecedor> dicas = await FornecedorApi.get(context);
        _streamController.add(dicas);
        return dicas;
      }

    } catch (e) {
      if(! _streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }
  Future<List<Fornecedor>> fetchId(context,int id) async {
    try {
      if(!await isNetworkOn()) {

      }else{
        List<Fornecedor> dicas = await FornecedorApi.getId(context,id);
        _streamController.add(dicas);
        return dicas;
      }

    } catch (e) {
      if(! _streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }

  Future<List<Fornecedor>> fetchEmpreendedor(context,int empreendedor) async {
    try {
      if(!await isNetworkOn()) {

      }else{
        List<Fornecedor> dicas = await FornecedorApi.getFornecedorByEmpreendedor(context,empreendedor);
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
