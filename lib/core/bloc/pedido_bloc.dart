import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:merenda_escolar/pages/login/usuario.dart';
import 'package:merenda_escolar/pages/pedido/Pedido.dart';
import 'package:merenda_escolar/pages/pedido/pedido_api.dart';
import 'package:provider/provider.dart';


class PedidoBloc extends ChangeNotifier {
  double total = 0;
  int quantPedidoSemAf = 0;
  final _streamController = StreamController<List<Pedido>>();
  Stream<List<Pedido>> get stream => _streamController.stream;
  List<Pedido> _lista =[];
  int itens = 0;
  bool _isLoading = false;

  Future<List<Pedido>> fetchEscola(context, int escola) async {
    try {

        List<Pedido> dados = await PedidoApi.getByEscola(context,escola);
        _streamController.add(dados);
        _lista.clear();
        addAll(dados);

    } catch (e) {
      _lista.clear();
      if(! _streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }
  Future<List<Pedido>> fetchCheck(context, bool ischeck) async {
    try {
        List<Pedido> dados = await PedidoApi.getByCheck(context,ischeck);
        _streamController.add(dados);
        _lista.clear();
        addAll(dados);

    } catch (e) {
      _lista.clear();
      itens = 0;
      notifyListeners();
      if(! _streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }
  Future<List<Pedido>> fetch(context, {Usuario user}) async {

    try {

      List<Pedido> dados = await PedidoApi.get(context);
        _streamController.add(dados);
        _lista.clear();
        addAll(dados,setor: user.setor);
        return dados;

    } catch (e) {
      _lista.clear();
      if (!_streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }
  Future<List<Pedido>> fetchUnidade(context,int unidade) async {
    try {
      List<Pedido> dados = await PedidoApi.getByEscola(context,unidade);
      _streamController.add(dados);
      _lista.clear();
      addAll(dados);
      return dados;

    } catch (e) {
      _lista.clear();
      if (!_streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }


  List<Pedido> get lista => [..._lista];
  int get listaCount => lista.length;
  bool get isLoading => _isLoading;

   addAll(List<Pedido>dados,{ int setor}) {
     print("ÇÇÇÇÇ");
    _lista.addAll(dados);
    itens = _lista.length;
    _isLoading = true;
     notifyListeners();
  }

  add(Pedido item) {
    _lista.add(item);
    increase(item);
  }

  remove(Pedido item) {
    _lista.removeWhere((x) => x.id == item.id);
    decrease(item);
  }



  incrementSemAf(){
    quantPedidoSemAf++;
    notifyListeners();
  }
  decrementSemAf(){
    quantPedidoSemAf--;
    notifyListeners();
  }

  removeAll() {
    _lista.clear();
    notifyListeners();
  }

  bool itemInPedido(Pedido item) {
    var result = false;
    _lista.forEach((x) {
      if (item.id == x.id) result = true;
    });
    return result;
  }

  increase(Pedido item) {
    itens = 0;
    _lista.forEach((x) {
      itens++;
    });
    print("NEW $itens");
    notifyListeners();
  }
  decrease(Pedido item) {
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
  addQuant(int quant) {
    itens = itens + quant;
    notifyListeners();
  }

  decQuant(int quant) {
    itens = itens - quant;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _streamController.close();
  }
}
