import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:merenda_escolar/pages/fornecedor/Fornecedor.dart';
import 'package:merenda_escolar/pages/fornecedor/Fornecedor_api.dart';



class FornecedorBloc extends ChangeNotifier {
  double total = 0;
  final _streamController = StreamController<List<Fornecedor>>();
  Stream<List<Fornecedor>> get stream => _streamController.stream;
  List<Fornecedor> _lista =[];

  final _streamController1 = StreamController<List<Fornecedor>>();
  Stream<List<Fornecedor>> get stream1 => _streamController1.stream;
  List<Fornecedor> _lista1 =[];
  int itens = 0;

  Future<List<Fornecedor>> fetch(context) async {
   print('aquixx');
   try {
        List<Fornecedor> dados = await FornecedorApi.get(context);
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

  Future<List<Fornecedor>> fetchId(context,int id) async {
  print('aqui');
    try {
        List<Fornecedor> dados = await FornecedorApi.getId(context,id);
        _streamController1.add(dados);
         _lista1.clear();
        addAll1(dados);
        return dados;
    } catch (e) {
      if(! _streamController1.isClosed) {
        _streamController1.addError(e);
      }
    }
  }

  List<Fornecedor> get lista => [..._lista];
  List<Fornecedor> get lista1 => [..._lista1];
  int get listaCount => lista.length;

   addAll(List<Fornecedor>dados) {
    _lista.addAll(dados);
     notifyListeners();
  }

  addAll1(List<Fornecedor>dados) {
    _lista1.addAll(dados);
    notifyListeners();
  }

  add(Fornecedor item) {
    _lista.add(item);
    increase(item);
  }

  remove(Fornecedor item) {
    _lista.removeWhere((x) => x.id == item.id);
    decrease(item);
  }

  removeAll() {
    _lista.clear();
    notifyListeners();
  }

  bool itemInFornecedor(Fornecedor item) {
    var result = false;
    _lista.forEach((x) {
      if (item.id == x.id) result = true;
    });
    return result;
  }

  increase(Fornecedor item) {
    itens = 0;
    _lista.forEach((x) {
      itens++;
    });
    notifyListeners();
  }
  decrease(Fornecedor item) {
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
    _streamController1.close();
  }
}
