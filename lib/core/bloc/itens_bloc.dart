import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:merenda_escolar/models/itens.dart';
import 'package:merenda_escolar/pages/pedidoItens/PedidoItens.dart';
import 'package:merenda_escolar/pages/pedidoItens/PedidoItens_api.dart';


class ItensBloc extends ChangeNotifier {
  double total = 0;
  final _streamController = StreamController<List<PedidoItens>>();
  Stream<List<PedidoItens>> get stream => _streamController.stream;
  List<PedidoItens> _lista =[];
  List<Itens> _listaFor =[];
  int itens = 0;
  int itensFor = 0;

  Future<List<PedidoItens>> fetchAf(context,int af) async {
   print('aquixx');
   try {
        List<PedidoItens> dados = await PedidoItensApi.getByAf(context,af);
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

  Future<List<PedidoItens>> fetchItensByNivel(context,int nivel) async {
    print('aquixx');
    try {
      List<PedidoItens> dados = await PedidoItensApi.getByAf(context,nivel);
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


  List<PedidoItens> get lista => [..._lista];
  List<Itens> get listaFor => [..._listaFor];
  int get listaCount => lista.length;

   addAll(List<PedidoItens>dados) {
    _lista.addAll(dados);
     notifyListeners();
  }

  add(PedidoItens item) {
    _lista.add(item);
    increase(item);
  }

  addFor(Itens item) {
    _listaFor.add(item);
    _listaFor.sort((a, b) => a.diaEntrega.compareTo(b.diaEntrega));

    increaseFor(item);
  }

  remove(PedidoItens item) {
    _lista.removeWhere((x) => x.id == item.id);
    decrease(item);
  }

  removeAll() {
    _lista.clear();
    notifyListeners();
  }

  bool itemInPedidoItens(PedidoItens item) {
    var result = false;
    _lista.forEach((x) {
      if (item.id == x.id) result = true;
    });
    return result;
  }

  increase(PedidoItens item) {
    itens = 0;
    _lista.forEach((x) {
      itens++;
    });
    notifyListeners();
  }

  alteraQuant(int index, double quantidade){
     listaFor[index].quantidade = quantidade;
   notifyListeners();


  }

  decrease(PedidoItens item) {
    itens = 0;
    _lista.forEach((x) {
      itens--;
    });
    notifyListeners();
  }


  increaseFor(Itens item) {
    itensFor = 0;
    _listaFor.forEach((x) {
      itensFor++;
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

  void clearr() {
    _listaFor = [];
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _streamController.close();
  }
}
