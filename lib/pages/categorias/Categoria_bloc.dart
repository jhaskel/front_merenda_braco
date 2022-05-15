

import 'dart:async';




import 'package:merenda_escolar/pages/categorias/Categoria.dart';
import 'package:merenda_escolar/pages/categorias/Categoria_api.dart';
import 'package:merenda_escolar/utils/network.dart';

class CategoriaBloc {
  final _streamController = StreamController<List<Categoria>>();
  Stream<List<Categoria>> get stream => _streamController.stream;


  Future<List<Categoria>> fetch(context) async {
    try {
      if(!await isNetworkOn()) {

      }else{
        List<Categoria> dicas = await CategoriaApi.get(context);
        _streamController.add(dicas);
        return dicas;
      }

    } catch (e) {
      if(! _streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }

  Future<List<Categoria>> fetchAtivo(context) async {
    try {
      if(!await isNetworkOn()) {

      }else{
        List<Categoria> dicas = await CategoriaApi.getAtivo(context);
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
