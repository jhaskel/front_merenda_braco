import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:merenda_escolar/pages/login/usuario.dart';
import 'package:merenda_escolar/pages/usuarios/usuarios_api.dart';




class UsuarioBloc extends ChangeNotifier {
  double total = 0;
  final _streamController = StreamController<List<Usuario>>();
  final _currentUser = StreamController<List<Usuario>>();
  Stream<List<Usuario>> get stream => _streamController.stream;
  List<Usuario> _lista =[];
  List<Usuario> _listUserCurrent =[];
  Usuario _userCurrent;
  int itens = 0;

  Future<List<Usuario>> fetch(context) async {

   try {
        List<Usuario> dados = await UsuariosApi.get(context);
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


  List<Usuario> get lista => [..._lista];
  List<Usuario> get listUserCurrent => [..._listUserCurrent];
  Usuario get userCurrent => _userCurrent;
  int get listaCount => lista.length;

   addAll(List<Usuario>dados) {
    _lista.addAll(dados);
     notifyListeners();
  }

  addAllUserCurrent(List<Usuario>dados) {
    _listUserCurrent.addAll(dados);
    _userCurrent = listUserCurrent.first;
    notifyListeners();
  }

  add(Usuario item) {
    _lista.add(item);
    increase(item);
  }

  remove(Usuario item) {
    _lista.removeWhere((x) => x.id == item.id);
    decrease(item);
  }

  removeAll() {
    _lista.clear();
    notifyListeners();
  }

  bool itemInUsuario(Usuario item) {
    var result = false;
    _lista.forEach((x) {
      if (item.id == x.id) result = true;
    });
    return result;
  }

  increase(Usuario item) {
    itens = 0;
    _lista.forEach((x) {
      itens++;
    });
    notifyListeners();
  }
  decrease(Usuario item) {
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
    _currentUser.close();
  }
}
