import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:merenda_escolar/pages/unidadeEscolar/UnidadeEscolar.dart';
import 'package:merenda_escolar/pages/unidadeEscolar/UnidadeEscolar_api.dart';


class UnidadeBloc extends ChangeNotifier {
  double total = 0;
  final _streamController = StreamController<List<UnidadeEscolar>>();
  Stream<List<UnidadeEscolar>> get stream => _streamController.stream;
  List<UnidadeEscolar> _lista = [];
  int itens = 0;
  int nivel;

  Future<List<UnidadeEscolar>> fetch(context) async {
    try {
      List<UnidadeEscolar> dados = await UnidadeEscolarApi.get(context,false);
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

  Future<List<UnidadeEscolar>> fetchSetor(context, int setor) async {
    try {
      List<UnidadeEscolar> dados = await UnidadeEscolarApi.getSetor(context, setor);
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

  List<UnidadeEscolar> get lista => [..._lista];
  int get listaCount => lista.length;

  addAll(List<UnidadeEscolar> dados) {
    _lista.addAll(dados);
    notifyListeners();
  }

  nivelUnidade(int unidade) {
    print("unix $unidade");
    for (var x in lista) {
      print("unixy ${x.id}");
      if (x.id == unidade) {
        print("entrou");
        nivel = x.nivelescolar;
        print("unixx $nivel");
      }
    }
    notifyListeners();
  }

  add(UnidadeEscolar item) {
    _lista.add(item);
    increase(item);
  }

  remove(UnidadeEscolar item) {
    _lista.removeWhere((x) => x.id == item.id);
    decrease(item);
  }

  removeAll() {
    _lista.clear();
    notifyListeners();
  }

  bool itemInUnidade(UnidadeEscolar item) {
    var result = false;
    _lista.forEach((x) {
      if (item.id == x.id) result = true;
    });
    return result;
  }

  increase(UnidadeEscolar item) {
    itens = 0;
    _lista.forEach((x) {
      itens++;
    });
    notifyListeners();
  }

  decrease(UnidadeEscolar item) {
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
