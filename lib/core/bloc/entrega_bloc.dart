import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:merenda_escolar/pages/entrega/Entrega.dart';
import 'package:merenda_escolar/pages/entrega/entrega_api.dart';





class EntregaBloc extends ChangeNotifier {

  double total = 0;
  final _streamController = StreamController<List<Entrega>>();
  final _streamController2 = StreamController<List<Entrega>>();
  Stream<List<Entrega>> get stream => _streamController.stream;
  Stream<List<Entrega>> get stream2 => _streamController2.stream;
  List<Entrega> _lista =[];
  List<Entrega> _lista2 =[];
  int itens = 0;


  Future<List<Entrega>> fetch(context) async {
    try {
      List<Entrega> dados = await EntregaApi.get(context);
      _streamController.add(dados);
      _lista.clear();
      addAll(dados);
      return dados;

    } catch (e) {
      if (!_streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }

  Future<List<Entrega>> fetchOrdem(context, int ordem) async {
    try {
      List<Entrega> dados = await EntregaApi.getOrdem(context, ordem);
      _streamController.add(dados);
      _lista.clear();
      print("DADOSX $dados");
      addAll(dados);
      return dados;

    } catch (e) {
      _lista.clear();
      if (!_streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }
  Future<List<Entrega>> fetchPedido(context, int pedido) async {
    try {
      List<Entrega> dados = await EntregaApi.getPedido(context, pedido);
      _streamController2.add(dados);
      _lista2.clear();
      print("DADOSX $dados");
      addAll2(dados);
      return dados;

    } catch (e) {
      _lista2.clear();
      if (!_streamController2.isClosed) {
        _streamController2.addError(e);
      }
    }
  }


  List<Entrega> get lista => [..._lista];
  List<Entrega> get lista2 => [..._lista2];
  int get listaCount => lista.length;
  int get listaCount2 => lista2.length;

   addAll(List<Entrega>dados) {
     print("LISD 01");
    _lista.addAll(dados);
    print("LISTAUUUU $lista");
     notifyListeners();
  }

  addAll2(List<Entrega>dados) {
    _lista2.addAll(dados);
    notifyListeners();
  }

  add(Entrega item) {
    _lista.add(item);
    increase(item);
  }


  remove(Entrega item) {
    _lista.removeWhere((x) => x.id == item.id);
    decrease(item);
  }

  removeAll() {
    _lista.clear();
    notifyListeners();
  }

  itemInEntrega(Entrega item) {
    var result = false;
    _lista.forEach((x) {
      if (item.id == x.id) result = true;
    });
    return result;
  }

  increase(Entrega item) {
    itens = 0;
    _lista.forEach((x) {
      itens++;
    });
    notifyListeners();
  }
  decrease(Entrega item) {
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
  alteraQuant(int index, double quantidade) {
    lista[index].quantidade = quantidade;
    notifyListeners();
  }

  void clearr() {
    _lista = [];
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _streamController.close();
    _streamController2.close();
  }
}
