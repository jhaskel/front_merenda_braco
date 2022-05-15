import 'dart:async';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:merenda_escolar/pages/produtos/Produto.dart';
import 'package:rxdart/rxdart.dart';

class BlocProdutos extends BlocBase {
  BlocProdutos();
//Stream that receives a number and changes the count;
  var _counterProduto = BehaviorSubject<List<Produto>>.seeded(null);
//output
  Stream<List<Produto>> get outProduto => _counterProduto.stream;
//input
  Sink<List<Produto>> get inProduto => _counterProduto.sink;

//dispose will be called automatically by closing its streams
  @override
  void dispose() {
    _counterProduto.close();
    super.dispose();
  }

}