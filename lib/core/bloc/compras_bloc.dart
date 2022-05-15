import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:merenda_escolar/pages/compras/Compras.dart';
import 'package:merenda_escolar/pages/compras/compras_api.dart';



class ComprasBloc extends ChangeNotifier {
  double total = 0;
  final _streamController = StreamController<List<Compras>>();
  Stream<List<Compras>> get stream => _streamController.stream;
  List<Compras> _lista =[];
  int itens = 0;

  Future<List<Compras>> fetchPedido(context,int pedido) async {
    print("BB01");
   try {
        List<Compras> dados = await ComprasApi.getPed(context,pedido);
        _streamController.add(dados);
        print("DXC $dados");
        _lista.clear();
        addAll(dados);
        return dados;

    } catch (e) {
     print("BB02");
     _lista.clear();
      if (!_streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }



  List<Compras> get lista => [..._lista];
  int get listaCount => lista.length;

   addAll(List<Compras>dados) {
    _lista.addAll(dados);
     notifyListeners();
  }

  add(Compras item) {
    _lista.add(item);
    increase(item);
  }

  remove(Compras item) {
    _lista.removeWhere((x) => x.id == item.id);
    decrease(item);
  }

  removeAll() {
    _lista.clear();
    notifyListeners();
  }

  bool itemInCompras(Compras item) {
    var result = false;
    _lista.forEach((x) {
      if (item.id == x.id) result = true;
    });
    return result;
  }

  increase(Compras item) {
    itens = 0;
    _lista.forEach((x) {
      itens++;
    });
    notifyListeners();
  }
  decrease(Compras item) {
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
  addQuant(int quant) {
    itens = itens + quant;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _streamController.close();
  }
}
