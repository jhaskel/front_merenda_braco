
import 'dart:async';



import 'package:merenda_escolar/pages/compras/Compras.dart';
import 'package:merenda_escolar/pages/compras/compras_api.dart';
import 'package:merenda_escolar/utils/network.dart';

class ComprasBloc {
  final _streamController = StreamController<List<Compras>>();
  Stream<List<Compras>> get stream => _streamController.stream;

  Future<List<Compras>> fetch(context,String pedido) async {
    try {
      if(!await isNetworkOn()) {

      }else{
        List<Compras> dicas = await ComprasApi.getByCart(context,pedido);
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
