import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:merenda_escolar/pages/setor/Setor.dart';
import 'package:merenda_escolar/pages/setor/setor_api.dart';


class SetorBloc extends ChangeNotifier {
  double total = 0;
  final _streamController = StreamController<List<Setor>>();
  Stream<List<Setor>> get stream => _streamController.stream;
  List<Setor> _lista =[];
  int itens = 0;

  Future<List<Setor>>fetch(context) async {
   try {
        List<Setor> dados = await SetorApi.get(context);
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

    Future<List<Setor>> fetchId(context,int id) async {
   try {
        List<Setor> dados = await SetorApi.getId(context,id);
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

  List<Setor> get lista => [..._lista];
  int get listaCount => lista.length;

   addAll(List<Setor>dados) {
    _lista.addAll(dados);
     notifyListeners();
  }

  add(Setor item) {
    _lista.add(item);
    increase(item);
  }

  remove(Setor item) {
    _lista.removeWhere((x) => x.id == item.id);
    decrease(item);
  }

  removeAll() {
    _lista.clear();
    notifyListeners();
  }

  bool itemInSetor(Setor item) {
    var result = false;
    _lista.forEach((x) {
      if (item.id == x.id) result = true;
    });
    return result;
  }

  increase(Setor item) {
    itens = 0;
    _lista.forEach((x) {
      itens++;
    });
    notifyListeners();
  }
  decrease(Setor item) {
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
