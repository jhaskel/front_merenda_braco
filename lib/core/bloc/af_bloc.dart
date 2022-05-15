import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:merenda_escolar/pages/af/Af.dart';
import 'package:merenda_escolar/pages/af/af_api.dart';
import 'package:merenda_escolar/utils/utils.dart';
import 'package:flutter/material.dart';




class AfBloc extends ChangeNotifier {
  double total = 0;
  final _streamController = StreamController<List<Af>>();
  Stream<List<Af>> get stream => _streamController.stream;
  List<Af> _lista =[];
  final _streamController1 = StreamController<List<Af>>();
  final _streamController2 = StreamController<List<Af>>();
  Stream<List<Af>> get stream1 => _streamController1.stream;
  Stream<List<Af>> get stream2 => _streamController2.stream;
  List<Af> _af =[];
  List<Af> _listOrdem =[];
  int itens = 0;
  int itensNovos = 0;
  int itensAutorizados = 0;
  int itensEmpenhado = 0;
  bool isDespesa= false;


  Future<List<Af>> fetchSetor(context, int setor) async {

   try {
        List<Af> dados = await AfApi.getSetor(context,setor);
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
  Future<List<Af>> fetchCode(context, int code) async {
print("REFAZ");
    try {
      List<Af> dados = await AfApi.getCode(context,code);
      _streamController1.add(dados);
      _af.clear();
      addAllAf(dados);
      return dados;

    } catch (e) {
      if (!_streamController1.isClosed) {
        _streamController1.addError(e);
      }
    }
  }
  Future<List<Af>> fetchStatus(context, String status) async {
    try {
      List<Af> dados = await AfApi.getByStatus(context,status);
      _streamController2.add(dados);
      _listOrdem.clear();
      addAllOrdem(dados);
      return dados;

    } catch (e) {
      _listOrdem.clear();
      if (!_streamController2.isClosed) {
        _streamController2.addError(e);
      }
    }
  }

  List<Af> get lista => [..._lista];
  List<Af> get af => [..._af];
  List<Af> get listOrdem => [..._listOrdem];
  int get listaCount => lista.length;

   addAll(List<Af>dados) {
     print("YES");
    _lista.addAll(dados);
    quantifica(_lista);
     notifyListeners();
  }
  addAllAf(List<Af>dados) {
    _af.addAll(dados);
    notifyListeners();
  }

  addAllOrdem(List<Af>dados) {
    _listOrdem.addAll(dados);

    notifyListeners();
  }

  add(Af item) {
    _lista.add(item);
    increase(item);
  }

  remove(Af item) {
    _lista.removeWhere((x) => x.id == item.id);
    decrease(item);
  }

  ativaDespesa(){
     isDespesa = true;
     notifyListeners();
  }

  removeAll() {
    _lista.clear();
    notifyListeners();
  }

  bool itemInAf(Af item) {
    var result = false;
    _lista.forEach((x) {
      if (item.id == x.id) result = true;
    });
    return result;
  }

  increase(Af item) {
    itens = 0;
    _lista.forEach((x) {
      itens++;
    });
    notifyListeners();
  }
  decrease(Af item) {
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
  void quantifica(List<Af> listOrdem) {
     itensNovos=0;
     itensAutorizados=0;
     itensEmpenhado=0;
     for(var x in listOrdem){
       if (x.status == Status.ordemProcessada){
         itensNovos++;
       }
     }
     for(var x in listOrdem){
       if (x.status == Status.ordemAutorizada){
         itensAutorizados++;
       }
     }
     for(var x in listOrdem){
       if (x.status == Status.ordemEmpenhada){
         itensEmpenhado++;
       }
     }


  }
  addItensNovos(int quant ){
    itensNovos = itensNovos+quant;
    notifyListeners();
  }

  decItensNovos(int quant ){
    itensNovos = itensNovos-quant;
   notifyListeners();
   }

  decItensAutorizados(int quant ){
    itensAutorizados = itensAutorizados-quant;
    addItensEmpenhados(quant);

  }
  addItensEmpenhados(int quant ){
    itensEmpenhado = itensEmpenhado+quant;
    notifyListeners();
  }
  decItensEmpenhados(int quant ){
    itensEmpenhado = itensEmpenhado-quant;
    notifyListeners();
  }


  @override
  void dispose() {
    super.dispose();
    _streamController.close();
    _streamController1.close();
    _streamController2.close();
  }


}
