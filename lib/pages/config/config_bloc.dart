

import 'dart:async';

import 'package:merenda_escolar/pages/config/Config.dart';
import 'package:merenda_escolar/utils/network.dart';

import 'config_api.dart';

class ConfigBloc {
  final _streamController = StreamController<List<Config>>();
  Stream<List<Config>> get stream => _streamController.stream;


  Future<List<Config>> fetch(context) async {
    try {
      if(!await isNetworkOn()) {

      }else{
        List<Config> dicas = await ConfigApi.get(context);
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
