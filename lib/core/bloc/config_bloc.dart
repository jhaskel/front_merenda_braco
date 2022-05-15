import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:merenda_escolar/pages/config/Config.dart';
import 'package:merenda_escolar/pages/config/config_api.dart';



class ConfigBloc extends ChangeNotifier {
  double total = 0;
  final _streamController = StreamController<List<Config>>();
  Stream<List<Config>> get stream => _streamController.stream;
  List<Config> _lista =[];
  int itens = 0;

  Future<List<Config>> fetch(context) async {
   try {
        List<Config> dados = await ConfigApi.get(context);
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


  List<Config> get lista => [..._lista];
  int get listaCount => lista.length;

   addAll(List<Config>dados) {
    _lista.addAll(dados);
     notifyListeners();
  }

  add(Config item) {
    _lista.add(item);
    increase(item);
  }

  remove(Config item) {
    _lista.removeWhere((x) => x.id == item.id);
    decrease(item);
  }

  removeAll() {
    _lista.clear();
    notifyListeners();
  }

  bool itemInConfig(Config item) {
    var result = false;
    _lista.forEach((x) {
      if (item.id == x.id) result = true;
    });
    return result;
  }

  increase(Config item) {
    itens = 0;
    _lista.forEach((x) {
      itens++;
    });
    notifyListeners();
  }
  decrease(Config item) {
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
