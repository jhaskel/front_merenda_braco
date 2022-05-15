import 'dart:async';

import 'package:merenda_escolar/pages/estoque/Estoque.dart';
import 'package:merenda_escolar/pages/estoque/estoque_api.dart';


class EstoqueBloc {
  final _streamController = StreamController<List<Estoque>>();
  Stream<List<Estoque>> get stream => _streamController.stream;

  Future<List<Estoque>> fetch(context) async {
    try {

        List<Estoque> dados = await EstoqueApi.get(context);
        _streamController.add(dados);
        return dados;

    } catch (e) {
      if (!_streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }

    Future<List<Estoque>> fetchId(context,int id) async {
    try {

        List<Estoque> dados = await EstoqueApi.getId(context,id);
        _streamController.add(dados);
        return dados;

    } catch (e) {
      if (!_streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }


  Future<List<Estoque>> fetchMenos(context) async {
    try {

        List<Estoque> dados = await EstoqueApi.getMenos(context);
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
