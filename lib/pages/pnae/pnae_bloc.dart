
import 'dart:async';
import 'package:merenda_escolar/pages/pnae/Pnae.dart';
import 'package:merenda_escolar/pages/pnae/pnae_api.dart';
import 'package:merenda_escolar/utils/network.dart';

class PnaeBloc {
  final _streamController = StreamController<List<Pnae>>();
  Stream<List<Pnae>> get stream => _streamController.stream;

  Future<List<Pnae>> fetch(context) async {
    try {
      if(!await isNetworkOn()) {

      }else{
        List<Pnae> dicas = await PnaeApi.get(context);
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
