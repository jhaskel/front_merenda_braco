import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:merenda_escolar/pages/almoxarifado/almoxarifado.dart';
import 'package:merenda_escolar/pages/almoxarifado/almoxarifado_api.dart';
import 'package:merenda_escolar/pages/contabilidade/Contabilidade.dart';
import 'package:merenda_escolar/pages/contabilidade/contabilidade_api.dart';



class ContabilidadeBloc extends ChangeNotifier {
  double total = 0;
  final _streamController = StreamController<List<Contabilidade>>();
  Stream<List<Contabilidade>> get stream => _streamController.stream;
  List<Contabilidade> _lista =[];

  final _streamController1 = StreamController<List<Contabilidade>>();
  Stream<List<Contabilidade>> get stream1 => _streamController1.stream;
  List<Contabilidade> _lista1 =[];
  int itens = 0;


  Future<List<Contabilidade>> fetchNivel(context, int nivel) async {
    try {
        List<Contabilidade> dados = await ContabilidadeApi.getNivel(context,nivel);
        _streamController1.add(dados);
        _lista1.clear();
        addAllNivel(dados);
        return dados;

    } catch (e) {
      if(! _streamController1.isClosed) {
        _streamController1.addError(e);
      }
    }
  }

  Future<List<Contabilidade>> findById(context,int id) async {
    try {
        List<Contabilidade> dados = await ContabilidadeApi.findById(context,id);
        _streamController.add(dados);
        _lista.clear();
        addAllDespesa(dados);
        return dados;

    } catch (e) {
      if(! _streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }


  List<Contabilidade> get lista => [..._lista];
  List<Contabilidade> get lista1 => [..._lista1];
  int get listaCount => lista.length;

   addAllDespesa(List<Contabilidade>dados) {
    _lista.addAll(dados);
     notifyListeners();
  }

  addAllNivel(List<Contabilidade>dados) {

    _lista1.addAll(dados);
    print("XC $lista1");
    notifyListeners();
  }

  add(Contabilidade item) {
    _lista.add(item);
    increase(item);
  }

  remove(Contabilidade item) {
    _lista.removeWhere((x) => x.id == item.id);
    decrease(item);
  }


  decrement(Contabilidade item) {
    _lista.removeWhere((x) => x.id == item.id);
    decrease(item);
  }

  removeAll() {
    _lista.clear();
    notifyListeners();
  }

  bool itemInContabilidade(Contabilidade item) {
    var result = false;
    _lista.forEach((x) {
      if (item.id == x.id) result = true;
    });
    return result;
  }

  increase(Contabilidade item) {
    itens = 0;
    _lista.forEach((x) {
      itens++;
    });
    notifyListeners();
  }
  decrease(Contabilidade item) {
    itens = 0;
    _lista.forEach((x) {
      itens--;
    });
    notifyListeners();
  }

  calculateContabilidade() {
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
    _streamController1.close();
  }
}
