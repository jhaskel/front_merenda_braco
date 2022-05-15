


import 'dart:async';

import 'package:flutter/material.dart';
import 'package:merenda_escolar/pages/login/usuario.dart';
import 'package:merenda_escolar/pages/usuarios/usuarios_api.dart';
import 'package:merenda_escolar/utils/network.dart';

class UsuariosBloc {
  final _streamController = StreamController<List<Usuario>>();
  Stream<List<Usuario>> get stream => _streamController.stream;


  Future<List<Usuario>> fetch(BuildContext context) async {
    try {
      if(!await isNetworkOn()) {

      }else{
        List<Usuario> dicas = await UsuariosApi.get(context);
        _streamController.add(dicas);
        return dicas;
      }

    } catch (e) {
      if(! _streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }

  Future<List<Usuario>> fetchNivel(BuildContext context) async {
    try {
      if(!await isNetworkOn()) {

      }else{
        List<Usuario> dicas = await UsuariosApi.getUsuarioByNivel(context);
        _streamController.add(dicas);
        return dicas;
      }

    } catch (e) {
      if(! _streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }

  void dispose() {
    _streamController.close();



  }
}
