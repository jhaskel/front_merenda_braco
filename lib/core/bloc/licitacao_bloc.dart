import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:merenda_escolar/pages/licitacao/Licitacao.dart';
import 'package:merenda_escolar/pages/licitacao/licitacao_api.dart';




class LicitacaoBloc extends ChangeNotifier {
  double total = 0;
  final _streamController = StreamController<List<Licitacao>>();
  Stream<List<Licitacao>> get stream => _streamController.stream;
  List<Licitacao> _lista =[];
  int itens = 0;

  Future<List<Licitacao>> fetch(context) async {
   print('aquixx');
   try {
        List<Licitacao> dados = await LicitacaoApi.get(context);
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



  List<Licitacao> get lista => [..._lista];
  int get listaCount => lista.length;

   addAll(List<Licitacao>dados) {
    _lista.addAll(dados);
     notifyListeners();
  }

  add(Licitacao item) {
    _lista.add(item);
    increase(item);
  }

  remove(Licitacao item) {
    _lista.removeWhere((x) => x.id == item.id);
    decrease(item);
  }

  removeAll() {
    _lista.clear();
    notifyListeners();
  }

  bool itemInLicitacao(Licitacao item) {
    var result = false;
    _lista.forEach((x) {
      if (item.id == x.id) result = true;
    });
    return result;
  }

  increase(Licitacao item) {
    itens = 0;
    _lista.forEach((x) {
      itens++;
    });
    notifyListeners();
  }
  decrease(Licitacao item) {
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
