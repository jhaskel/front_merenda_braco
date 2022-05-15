
import 'dart:async';
import 'package:merenda_escolar/pages/afPedido/AfPedido.dart';
import 'package:merenda_escolar/pages/afPedido/afpedido_api.dart';
import 'package:merenda_escolar/utils/network.dart';

class AfPedidoBloc {
  final _streamController = StreamController<List<AfPedido>>();
  Stream<List<AfPedido>> get stream => _streamController.stream;

  Future<List<AfPedido>> fetch(context) async {
    try {
      if(!await isNetworkOn()) {

      }else{
        List<AfPedido> dicas = await AfPedidoApi.get(context);
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
