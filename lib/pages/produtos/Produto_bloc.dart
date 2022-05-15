import 'dart:async';

import 'package:merenda_escolar/pages/produtos/Produto.dart';
import 'package:merenda_escolar/pages/produtos/Produto_api.dart';


class ProdutoBloc {
  final _streamController = StreamController<List<Produto>>();
  Stream<List<Produto>> get stream => _streamController.stream;

  Future<List<Produto>> fetch(context) async {
    try {

        List<Produto> dados = await ProdutoApi.get(context);
        _streamController.add(dados);

        return dados;

    } catch (e) {
      if (!_streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }

    Future<List<Produto>> fetchId(context,int id) async {
    try {

        List<Produto> dados = await ProdutoApi.getId(context,id);
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
