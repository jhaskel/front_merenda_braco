import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:merenda_escolar/pages/estoque/Estoque.dart';
import 'package:merenda_escolar/pages/estoque/estoque_api.dart';
import 'package:merenda_escolar/utils/network.dart';




class EstoqueBloc extends ChangeNotifier {
  double total = 0;
  final _streamController = StreamController<List<Estoque>>();
  final _streamController1 = StreamController<List<Estoque>>();
  Stream<List<Estoque>> get stream => _streamController.stream;
  Stream<List<Estoque>> get stream1 => _streamController1.stream;
  List<Estoque> _lista =[];
  List<Estoque> _lista1 =[];
  int itens = 0;
  Map<int,String> mapEstoque = new Map();


  List<Estoque> get lista => [..._lista];
  List<Estoque> get lista1 => [..._lista1];
  int get listaCount => lista.length;
  int get lista1Count => lista1.length;

  Future<List<Estoque>>fetchSetor(context,int setor) async {
   try {
     if(!await isNetworkOn()) {
       print("SEMNET");
     }else
       print("TEMNET");
     print("X01 $setor");
        List<Estoque> dados = await EstoqueApi.getSetor(context,setor);
        _streamController.add(dados);
        _lista.clear();
        addAll(dados);
        return dados;
    } catch (e) {
     print("X02");
      if (!_streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }

  Future<List<Estoque>>fetchLicitacao(context,int licitacao) async {
    try {
      if(!await isNetworkOn()) {
        print("SEMNET");

      }else
        print("TEMNET");

      List<Estoque> dados = await EstoqueApi.getLicitacao(context,licitacao);
      _streamController.add(dados);
      _lista.clear();
      addAll(dados);
      return dados;
    } catch (e) {
      print("X02");
      _lista.clear();
      if (!_streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }

 Future<List<Estoque>> fetchId(context,int id) async {
   try {
        List<Estoque> dados = await EstoqueApi.getId(context,id);
        _streamController.add(dados);
        addAll(dados);
        return dados;

    } catch (e) {
      if (!_streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }


  Future<List<Estoque>>fetchFornecedor(context,int fornecedor) async {
    try {
      if(!await isNetworkOn()) {
        print("SEMNET");

      }else
        print("TEMNET");

      List<Estoque> dados = await EstoqueApi.getFornecedor(context,fornecedor);
      _streamController1.add(dados);
      _lista1.clear();
      addAll1(dados);
      return dados;
    } catch (e) {
      print("X02");
      _lista1.clear();
      if (!_streamController1.isClosed) {
        _streamController1.addError(e);
      }
    }
  }



   addAll(List<Estoque>dados) {
     print("HH");

    _lista.addAll(dados);
     _lista.sort((b, a) => a.agrofamiliar.toString().compareTo(b.agrofamiliar.toString()));
    mapDataLocal(dados);
     notifyListeners();
  }

  addAll1(List<Estoque>dados) {
    _lista1.addAll(dados);
    notifyListeners();
  }

  mapDataLocal(List<Estoque> dados ){
    for(var gh in dados){
      mapEstoque.putIfAbsent(gh.id, () => gh.alias);
    }

  }

  add(Estoque item) {
    _lista.add(item);
    increase(item);
  }

  remove(Estoque item) {
    _lista.removeWhere((x) => x.id == item.id);
    decrease(item);
  }

  removeAll() {
    _lista.clear();
    notifyListeners();
  }

  bool itemInEstoque(Estoque item) {
    var result = false;
    _lista.forEach((x) {
      if (item.id == x.id) result = true;
    });
    return result;
  }

  increase(Estoque item) {
    itens = 0;
    _lista.forEach((x) {
      itens++;
    });
    notifyListeners();
  }
  decrease(Estoque item) {
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
