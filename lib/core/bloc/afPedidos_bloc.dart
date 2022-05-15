import 'dart:async';
import 'package:flutter/widgets.dart';

import 'package:merenda_escolar/pages/afPedido/AfPedido.dart';
import 'package:merenda_escolar/pages/afPedido/afpedido_api.dart';


class AfPedidoBloc extends ChangeNotifier {
  double total = 0;
  final _streamController = StreamController<List<AfPedido>>();
  Stream<List<AfPedido>> get stream => _streamController.stream;
  List<AfPedido> _lista =[];
  int itens = 0;
  bool isDespesa= false;


  Future<List<AfPedido>> fetch(context) async {
    try {
        List<AfPedido> dados = await AfPedidoApi.get(context);
        _streamController.add(dados);
        _lista.clear();
        addAll(dados);
        return dados;

    } catch (e) {
      if(! _streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }


  List<AfPedido> get lista => [..._lista];
  int get listaCount => lista.length;

   addAll(List<AfPedido>dados) {
    _lista.addAll(dados);
     notifyListeners();
  }

  add(AfPedido item) {
    _lista.add(item);
    increase(item);
  }

  remove(AfPedido item) {
    _lista.removeWhere((x) => x.id == item.id);
    decrease(item);
  }

  ativaDespesa(){
     isDespesa = true;
     notifyListeners();
  }

  removeAll() {
    _lista.clear();
    notifyListeners();
  }

  bool itemInAfPedido(AfPedido item) {
    var result = false;
    _lista.forEach((x) {
      if (item.id == x.id) result = true;
    });
    return result;
  }

  increase(AfPedido item) {
    itens = 0;
    _lista.forEach((x) {
      itens++;
    });
    notifyListeners();
  }
  decrease(AfPedido item) {
    itens = 0;
    _lista.forEach((x) {
      itens--;
    });
    notifyListeners();
  }

  calculateItens() {
    itens = 0;
    _lista.forEach((x) {
      itens++;
    });
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _streamController.close();
  }
}
