import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:merenda_escolar/pages/pnae/Pnae.dart';
import 'package:merenda_escolar/pages/pnae/pnae_api.dart';


class PnaeBloc extends ChangeNotifier {
  double total = 0;
  final _streamController = StreamController<List<Pnae>>();
  Stream<List<Pnae>> get stream => _streamController.stream;
  List<Pnae> _lista =[];
  int itens = 0;

  Future<List<Pnae>> fetch(context) async {
  print('chegou');
   try {
   print('verdade');
        List<Pnae> dados = await PnaeApi.get(context);
        _streamController.add(dados);
        print( 'DADOS $dados');
        _lista.clear();
        addAll(dados);
        return dados;
    } catch (e) {
    print('mentira');
      if (!_streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }


  List<Pnae> get lista => [..._lista];
  int get listaCount => lista.length;
   addAll(List<Pnae>dados) {
    _lista.addAll(dados);
     notifyListeners();
  }

  add(Pnae item) {
    _lista.add(item);
    increase(item);
  }

  remove(Pnae item) {
    _lista.removeWhere((x) => x.id == item.id);
    decrease(item);
  }

  removeAll() {
    _lista.clear();
    notifyListeners();
  }

  bool itemInPnae(Pnae item) {
    var result = false;
    _lista.forEach((x) {
      if (item.id == x.id) result = true;
    });
    return result;
  }

  increase(Pnae item) {
    itens = 0;
    _lista.forEach((x) {
      itens++;
    });
    notifyListeners();
  }
  decrease(Pnae item) {
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
