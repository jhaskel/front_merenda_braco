import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:merenda_escolar/pages/login/usuario.dart';
import 'package:merenda_escolar/pages/produtos/Produto.dart';
import 'package:merenda_escolar/pages/produtos/Produto_api.dart';



class ProdutoBloc extends ChangeNotifier {
  double total = 0;
  int quantProdutoSemAf = 0;
  final _streamController = StreamController<List<Produto>>();
  Stream<List<Produto>> get stream => _streamController.stream;
  List<Produto> _lista =[];
  int itens = 0;
  bool _isLoading = false;

  Future<List<Produto>> fetch(context, {Usuario user}) async {
    print("01");

    try {
      print("02");

      List<Produto> dados = await ProdutoApi.get(context);
        _streamController.add(dados);
        _lista.clear();
         print("DAD $dados");
        addAll(dados);

        return dados;

    } catch (e) {
      print("03");
      if (!_streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }

  Future<List<Produto>> fetchUnidade(context,int unidade) async {
    try {
      List<Produto> dados = await ProdutoApi.get(context);
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


  List<Produto> get lista => [..._lista];
  int get listaCount => lista.length;
  bool get isLoading => _isLoading;

   addAll(List<Produto>dados) {
     print("PEDF1 $lista");
    _lista.addAll(dados);
    print("PEDF $lista");

    _isLoading = true;
     notifyListeners();
  }

  add(Produto item) {
    _lista.add(item);
    increase(item);
  }

  remove(Produto item) {
    _lista.removeWhere((x) => x.id == item.id);
    decrease(item);
  }



  incrementSemAf(){
    quantProdutoSemAf++;
    notifyListeners();
  }
  decrementSemAf(){
    quantProdutoSemAf--;
    notifyListeners();
  }

  removeAll() {
    _lista.clear();
    notifyListeners();
  }

  bool itemInProduto(Produto item) {
    var result = false;
    _lista.forEach((x) {
      if (item.id == x.id) result = true;
    });
    return result;
  }

  increase(Produto item) {
    itens = 0;
    _lista.forEach((x) {
      itens++;
    });
    notifyListeners();
  }
  decrease(Produto item) {
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

  @override
  void dispose() {
    super.dispose();
    _streamController.close();
  }
}
