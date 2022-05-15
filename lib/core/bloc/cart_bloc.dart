import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:merenda_escolar/pages/cart/Cart.dart';
import 'package:merenda_escolar/pages/cart/Cart_api.dart';



class CartBloc extends ChangeNotifier {
  double total = 0;
  final _streamController = StreamController<List<Cart>>();
  final _streamController2 = StreamController<double>();
  Stream<List<Cart>> get stream => _streamController.stream;
  Stream<double> get stream2 => _streamController2.stream;
  List<Cart> _lista =[];
  int itens = 0;
  double qdeProdutoCart  = 0.0;

  Future<List<Cart>> fetchUnidade(context,int unidade) async {
    try {
      List<Cart> dados = await CartApi.getUnidade(context,unidade);
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

  Future<double> fetchQdeProdutoCart(context,int produto) async {

    notifyListeners();
    try {
      double dados = await CartApi.getCartProduto(context,produto);
      _streamController2.add(dados);
      addQdeProdutoCart(dados);
      return dados;
    } catch (e) {
      if (!_streamController2.isClosed) {
        _streamController2.addError(e);
      }
    }
  }

  limparCart(){
    lista.clear();
    itens=0;
  }

  List<Cart> get lista => [..._lista];
  int get listaCount => lista.length;

  addAll(List<Cart>dados) {
    _lista.addAll(dados);
    total = 0;
    for(var x in lista){

      total=total+x.total;
    }
    notifyListeners();
  }
  
  addQdeProdutoCart(double dados){

    qdeProdutoCart=0.0;
    if(dados !=null){
      qdeProdutoCart = dados;
    }
    print("DADDX$qdeProdutoCart");
    notifyListeners();
  }

  add(Cart item) {
    _lista.add(item);
    increase(item);
  }

  remove(Cart item) {
    _lista.removeWhere((x) => x.id == item.id);
    total = 0;
    for(var x in lista){
      total=total+x.total;
    }
    decrease(item);
  }

  removeAll() {
    _lista.clear();
    total =0;
    itens = 0;
    notifyListeners();
  }

  bool itemInCart(Cart item) {
    var result = false;
    _lista.forEach((x) {
      if (item.id == x.id) result = true;
    });
    return result;
  }

  increase(Cart item) {
    itens = 0;
    _lista.forEach((x) {
      itens++;
    });
    notifyListeners();
  }

  decrease(Cart item) {

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

  List<Cart> cart = [];


  get() {
    return cart;
  }

  increment(Cart item) {
    total = total + item.valor;
    notifyListeners();
  }

  decrement(Cart item) {
    total = total - item.valor;

    notifyListeners();
  }

  calculateTotal() {
    total = 0;
    cart.forEach((x) {
      total += (x.valor * x.quantidade);
    });
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _streamController.close();
    _streamController2.close();
  }
}

