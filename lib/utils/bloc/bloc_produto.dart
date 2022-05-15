import 'dart:async';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:merenda_escolar/pages/produtos/Produto.dart';
import 'package:rxdart/rxdart.dart';




class BlocProduto extends BlocBase {

  BlocProduto();
  List<Produto> lista;

//Stream that receives a number and changes the count;


  var _counterController = BehaviorSubject<List<Produto>>.seeded([]);
  var _quant = BehaviorSubject<int>.seeded(0);
  var _comprado = BehaviorSubject<int>.seeded(0);
    var _estoque = BehaviorSubject<int>.seeded(0);


//output
  Stream<List<Produto>> get outPage => _counterController.stream;
  Stream<int> get outQuant => _quant.stream;
  Stream<int> get outComprado => _comprado.stream;
  Stream<int> get outEstoque => _estoque.stream;
//input
  Sink<List<Produto>> get inPage => _counterController.sink;
  Sink<int> get inQant => _quant.sink;
  Sink<int> get inComprado => _comprado.sink;
  Sink<int> get inEstoque => _estoque.sink;


  calculaestoque(){
   _estoque.add(_quant.value - _comprado.value);
  }
//dispose will be called automatically by closing its streams
  @override
  void dispose() {
    _counterController.close();
    _quant.close();
      _comprado.close();
        _estoque.close();

    super.dispose();
  }

}