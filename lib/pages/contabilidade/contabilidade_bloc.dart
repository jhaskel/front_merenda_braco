
import 'dart:async';

import 'package:merenda_escolar/pages/contabilidade/Contabilidade.dart';
import 'package:merenda_escolar/pages/contabilidade/contabilidade_api.dart';

import 'package:merenda_escolar/utils/network.dart';

class ContabilidadeBloc {
  final _streamController = StreamController<List<Contabilidade>>();
  Stream<List<Contabilidade>> get stream => _streamController.stream;




  void dispose() {
    _streamController.close();

  }
}
