import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:merenda_escolar/pages/almoxarifado/almoxarifado.dart';
import 'package:merenda_escolar/pages/almoxarifado/almoxarifado_api.dart';



class AlmoxarifadoBloc extends ChangeNotifier {
  double total = 0;
  final _streamController = StreamController<List<Almoxarifado>>();
  final _streamControllerTroca = StreamController<List<Almoxarifado>>();
  Stream<List<Almoxarifado>> get stream => _streamController.stream;
  Stream<List<Almoxarifado>> get stream2 => _streamControllerTroca.stream;
  List<Almoxarifado> _lista =[];
  List<Almoxarifado> _listaTroca =[];
  int itens = 0;

  Future<List<Almoxarifado>> fetch(context,int licitacao) async {

   try {
        List<Almoxarifado> dados = await AlmoxarifadoApi.get(context,licitacao);
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
  Future<List<Almoxarifado>> fetchEscola(context,int escola) async {

    try {
      List<Almoxarifado> dados = await AlmoxarifadoApi.getEscola(context,escola);
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
  Future<List<Almoxarifado>> fetchTroca(context,int escola) async {
    try {
      List<Almoxarifado> dados = await AlmoxarifadoApi.getTroca(context);
      _streamControllerTroca.add(dados);
      _listaTroca.clear();
      addAllTroca(dados);
      return dados;

    } catch (e) {
      if (!_streamControllerTroca.isClosed) {
        _streamControllerTroca.addError(e);
      }
    }
  }



  List<Almoxarifado> get lista => [..._lista];
  List<Almoxarifado> get listaTroca => [..._listaTroca];
  int get listaCount => lista.length;

   addAll(List<Almoxarifado>dados) {
    _lista.addAll(dados);
     notifyListeners();
  }

  addAllTroca(List<Almoxarifado>dados) {
    _listaTroca.addAll(dados);
    notifyListeners();
  }

  add(Almoxarifado item) {
    _lista.add(item);
    increase(item);
  }

  remove(Almoxarifado item) {
    _lista.removeWhere((x) => x.id == item.id);
    decrease(item);
  }


  decrement(Almoxarifado item) {
    _lista.removeWhere((x) => x.id == item.id);
    decrease(item);
  }

  removeAll() {
    _lista.clear();
    notifyListeners();
  }

  bool itemInAlmoxarifado(Almoxarifado item) {
    var result = false;
    _lista.forEach((x) {
      if (item.id == x.id) result = true;
    });
    return result;
  }

  increase(Almoxarifado item) {
    itens = 0;
    _lista.forEach((x) {
      itens++;
    });
    notifyListeners();
  }
  decrease(Almoxarifado item) {
    itens = 0;
    _lista.forEach((x) {
      itens--;
    });
    notifyListeners();
  }

  calculateAlmoxarifado() {
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
    _streamControllerTroca.close();
  }
}
