import 'dart:async';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:merenda_escolar/pages/af/Af.dart';
import 'package:rxdart/rxdart.dart';


class BlocAf extends BlocBase {
  BlocAf();
  List<Af> lista;

//Stream that receives a number and changes the count;

  var _counterController = BehaviorSubject<List<Af>>.seeded([]);
  var _quant = BehaviorSubject<int>.seeded(0);

//output
  Stream<List<Af>> get outPage => _counterController.stream;
  Stream<int> get outQuant => _quant.stream;
//input
  Sink<List<Af>> get inPage => _counterController.sink;
  Sink<int> get inQuant => _quant.sink;

  decrementar(){
    _quant.add(_quant.value -1);
  }

//dispose will be called automatically by closing its streams
  @override
  void dispose() {
    _counterController.close();
    _quant.close();
    super.dispose();
  }
}
