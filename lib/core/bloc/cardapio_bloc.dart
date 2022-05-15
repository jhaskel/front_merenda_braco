import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:merenda_escolar/pages/cardapio/Cardapio.dart';
import 'package:merenda_escolar/pages/cardapio/cardapio_api.dart';



class CardapioBloc extends ChangeNotifier {

  double total = 0;
  final _streamController = StreamController<List<Cardapio>>();
  Stream<List<Cardapio>> get stream => _streamController.stream;
  List<Cardapio> _lista =[];
  int itens = 0;

  Future<List<Cardapio>> fetch(context) async {
    try {
      List<Cardapio> dados = await CardapioApi.get(context);
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


  List<Cardapio> get lista => [..._lista];
  int get listaCount => lista.length;

   addAll(List<Cardapio>dados) {
    _lista.addAll(dados);
     notifyListeners();
  }

  add(Cardapio item) {
    _lista.add(item);
    increase(item);
  }

  remove(Cardapio item) {
    _lista.removeWhere((x) => x.id == item.id);
    decrease(item);
  }

  removeAll() {
    _lista.clear();
    notifyListeners();
  }

  itemInCardapio(Cardapio item) {
    var result = false;
    _lista.forEach((x) {
      if (item.id == x.id) result = true;
    });
    return result;
  }

  increase(Cardapio item) {
    itens = 0;
    _lista.forEach((x) {
      itens++;
    });
    notifyListeners();
  }
  decrease(Cardapio item) {
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
