
import 'dart:async';

import 'package:merenda_escolar/pages/nivel/Nivel.dart';
import 'package:merenda_escolar/pages/nivel/Nivel_api.dart';
import 'package:merenda_escolar/utils/network.dart';

class NivelBloc {
  final _streamController = StreamController<List<Nivel>>();
  Stream<List<Nivel>> get stream => _streamController.stream;

  Future<List<Nivel>> fetch(context) async {
    try {
      if(!await isNetworkOn()) {

      }else{
        List<Nivel> dicas = await NivelApi.get(context);
        _streamController.add(dicas);
        return dicas;
      }

    } catch (e) {
      if(! _streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }

  Future<List<Nivel>> fetchId(context,int id) async {
    try {
      if(!await isNetworkOn()) {

      }else{
        List<Nivel> dicas = await NivelApi.getId(context,id);
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
