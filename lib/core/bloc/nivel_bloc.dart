import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:merenda_escolar/pages/nivel/Nivel.dart';
import 'package:merenda_escolar/pages/nivel/Nivel_api.dart';



class NivelBloc extends ChangeNotifier {
  double total = 0;
  final _streamController = StreamController<List<Nivel>>();
  Stream<List<Nivel>> get stream => _streamController.stream;
  List<Nivel> _lista =[];
  int itens = 0;
  Map<int,String> mapNivel = new Map();

  Future<List<Nivel>> fetch(context) async {
   try {
        List<Nivel> dados = await NivelApi.get(context);
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

  Future<List<Nivel>> fetchSetor(context,int setor) async {
    try {
      List<Nivel> dados = await NivelApi.getSetor(context,setor);
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

  List<Nivel> get lista => [..._lista];
  int get listaCount => lista.length;

   addAll(List<Nivel>dados) {
    _lista.addAll(dados);
    mapDataLocal(dados);
     notifyListeners();
  }

  mapDataLocal(List<Nivel> dados ){
    for(var gh in dados){
      mapNivel.putIfAbsent(gh.id, () => gh.nome);
    }
   }

  add(Nivel item) {
    _lista.add(item);
    increase(item);
  }

  remove(Nivel item) {
    _lista.removeWhere((x) => x.id == item.id);
    decrease(item);
  }

  removeAll() {
    _lista.clear();
    notifyListeners();
  }

  bool itemInNivel(Nivel item) {
    var result = false;
    _lista.forEach((x) {
      if (item.id == x.id) result = true;
    });
    return result;
  }

  increase(Nivel item) {
    itens = 0;
    _lista.forEach((x) {
      itens++;
    });
    notifyListeners();
  }
  decrease(Nivel item) {
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
  }
}
