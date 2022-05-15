
import 'dart:async';

import 'package:merenda_escolar/pages/unidadeEscolar/UnidadeEscolar.dart';
import 'package:merenda_escolar/pages/unidadeEscolar/UnidadeEscolar_api.dart';
import 'package:merenda_escolar/utils/network.dart';


class UnidadeEscolarBloc {
  final _streamController = StreamController<List<UnidadeEscolar>>();
  Stream<List<UnidadeEscolar>> get stream => _streamController.stream;

  Future<List<UnidadeEscolar>> fetch(context,bool ispublic) async {
    try {
      if(!await isNetworkOn()) {

      }else{
        List<UnidadeEscolar> dicas = await UnidadeEscolarApi.get(context,ispublic);
        _streamController.add(dicas);
        return dicas;
      }

    } catch (e) {
      if(! _streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }
  Future<List<UnidadeEscolar>> fetchId(context,int escola) async {
    try {
      if(!await isNetworkOn()) {

      }else{
        List<UnidadeEscolar> dicas = await UnidadeEscolarApi.getId(context,escola);
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
